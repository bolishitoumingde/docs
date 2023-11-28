## 概述

### JVM 的组成

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3tzixd5y14g0.png)

### 字节码文件的组成

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.23pax9d6vkw0.png)

* 基础信息：

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2n9pqjnreww0.webp)

* 常量池：

  作用：避免相同的内容重复定义，节省空间

  字节码指令中通过编号引用到常量池的过程称之为**符号引用**

* 方法：

  **操作数栈**是临时存放数据的地方，局部变量表是存放方法中的局部变量的位置

* 常用工具：

  `javap -v [字节码文件名称]` 查看具体字节码信息，如果是 jar 包需要先使用 `jar -xvf` 命令解压

## 类的生命周期

> 类的生命周期描述了一个类加载、使用、卸载的整个过程

**应用场景**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.w186dxmuokg.webp)

### 概述

类的生命周期分为五个部分

加载->连接->初始化->使用->卸载

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4n3ve3xpt4o0.webp)

### 加载阶段

1. 加载(Loading)阶段第一步是类加载器根据类的全限定名通过不同的渠道以二进制流的方式获取字节码信息。程序员可以使用 Java 代码拓展的不同的渠道

2. 类加载器在加载完类之后，Java 虚拟机会将字节码中的信息保存到方法区中

3. 类加载器在加载完类之后，Java 虚拟机会将字节码中的信息保存到内存的方法区中生成一个 InstanceKlass 对象，保存类的所有信息，里边还包含实现特定功能比如多态的信息

4. 同时，Java 虚拟机还会在堆中生成一份与方法区中数据类似的 java.lang.Class 对象，作用是在 Java 代码中去获取类的信息以及存储静态字段的数据 (JDK8及之后)

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5rpkiwgsmo00.webp)

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1bmypq4fv10g.webp)

对于开发者来说，只需要访问堆中的 Class 对象而不需要访问方法区中所有信息，这样 Java 虚拟机就能很好地控制开发者访问数据的范围

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1deh1r8pd1q8.webp)

**查看内存中的对象**

推荐使用 JDK 自带的 hsdb 工具查看 Java 虚拟机内存信息。工具位于 JDK 安装目录下 lib 文件夹中的 sa-jdi.jar 中。

启动命令：`java -cp sajdi.jar sun.jvm.hotspot.HSDB`

### 连接阶段

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.71nrdd4j1t4.webp)

#### 验证

连接(Linking)阶段的第一个环节是**验证**，验证的主要目的是检测 Java 字节码文件是否遵守《Java虚拟机规范》中的约束。这个阶段一般不需要程序员参与。主要包含以下四个部分，具体详见《Java虚拟机规范》：

* 文件格式验证，比如文件是否以 0xCAFEBABE 开头，主次版本号是否满足当前 Java 虚拟机版本要求。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2jez8z1p9220.webp)

* 元信息验证，例如类必须有父类 (super不能为空)。

* 验证程序执行指令的语义，比如方法内的指令执行中跳转到不正确的位置。

* 符号引用验证，例如是否访问了其他类中 private 的方法等。

验证案例-版本号的检测：

Hotspot JDK8 中虚拟机源码对版本号检测的代码如下：

```java
return (major >= JAVA_MIN_SUPPORTED_VERSION) &&
    (major <= max_version) &&
    ((major != max_version) ||
     (minor <= JAVA_MAX_SUPPORTED_MINOR_VERSION));
```

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5r8541pt8e40.webp)

#### 准备

第二个环节是**准备**，在 JDK8 版本之后，准备阶段为静态变量(static)分配内存并设置初始值。

* 准备阶段只会给静态变量赋初始值，而每一种基本数据类型和引用数据类型都有其初始值。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1shb03lw21mo.webp)

* final 修饰的基本数据类型的静态变量，准备阶段直接会将代码中的值进行赋值。

#### 解析

第三个环节是**解析**，解析阶段主要是将常量池中的符号引用替换为直接引用，符号引用就是在字节码文件中使用编号来访问常量池中的内容。

### 初始化阶段

初始化阶段会执行静态代码块中的代码，并为静态变量赋值。初始化阶段会执行字节码文件中 clinit(类初始化) 部分的字节码指令，clinit 方法中的执行顺序与 Java 中编写的顺序是一致的。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.560y3zaao500.webp)

以下几种方式会导致类的初始化：

> 添加 -XX:+TraceClassLoading 参数可以打印出加载并初始化的类

* 访问一个类的静态变量或者静态方法，注意变量是 final 修饰的并且等号右边是常量不会触发初始化。
* 调用 `Class.forName(String className)`
* new 一个该类的对象时
* 执行 Main 方法的当前类

注意：clinit 指令在特定情况下不会出现，如下种情况是不会进行初始化指令执行的：

* 无静态代码块且无静态变量赋值语句
* 有静态变量的声明，但是没有赋值语句
* 静态变量的定义使用 final 关键字，这类变量会在连接阶段的准备阶段直接进行初始化

如果存在继承，初始化阶段会有些变化：

* 直接访问父类的静态变量，不会触发子类的初始化
* 子类的初始化 clinit 调用之前，会先调用父类的 clinit 初始化方法

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2s7xngwdt2o0.webp)

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4c4fuynoeos0.webp)

> 注意：
>
> 数组的创建不会导致数组中元素的类进行初始化，new 的是数组，指定其元素类型，但没放入元素。
>
> final 修饰的变量如果赋值的内容需要执行指令才能得出结果，会执行 clinit 方法进行初始化。

## 类加载器

类加载器(ClassLoader)是 Java 虚拟机提供给应用程序去实现获取类和接口字节码数据的技术。

类加载器只参与加载过程中的字节码获取并加载到内存这一部分。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5cttsfk796s0.webp)

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1oofv3rgsxls.webp)

### 类加载器的分类

#### 概述

类加载器分为两类，一类是 Java 代码中实现的，一类是 Java 虚拟机底层源码实现的。

1. 虚拟机底层实现：
   * 源代码位于 Java 虚拟机的源码中，实现语言与虚拟机底层语言一致，比如 Hotspot 使用 C++。
   * 加载程序运行时的基础类，保证 Java程序运行中基础类被正确地加载，比如java.lang.String ，确保其可靠性。
2. JDK 中默认提供或者自定义：
   * JDK 中默认提供了多种处理不同渠道的类加载器，程序员也可以自己根据需求定制。
   * 继承自抽象类 ClassLoader，所有 Java 中实现的类加载器都需要继承 ClassLoader这个抽象类。

类加载器的设计 JDK8 和 8 之后的版本差别较大，JDK8 及之前的版本中默认的类加载器有如下几种:

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.47i1b5u5zuy0.webp)

#### 启动类加载器

* 启动类加载器 (Bootstrap ClassLoader) 是由 Hotspot 虚拟机提供的、使用C++编写的类加载器。
* 默认加载 Java 安装目录 /jre/lib 下的类文件，比如 rt.jar，tools.jar，resources.jar等。

可以通过启动类加载器去加载用户 jar 包：

* 放入 jre/lib 下进行扩展：不推荐，尽可能不要去更改 JDK 安装目录中的内容，会出
  现即使放进去，但文件名不匹配，也不会正常被加载的问题。
* 使用参数进行扩展：推荐，使用 `-Xbootclasspath/a:jar包目录/jar包名` 进行扩展。

#### 扩展类加载器和应用程序类加载器

* 扩展类加载器和应用程序类加载器都是 JDK 中提供的、使用 Java 编写的类加载器。
* 它们的源码都位于 sun.misc.Launcher 中，是一个静态内部类。或者指定 jar 包将字节码文件加载到内存中，继承自 URLClassLoader。通过目录或者指定 jar 包将字节码文件加载到内存中。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.daqyce00n8o.webp)

##### 扩展类加载器

* 扩展类加载器 (Extension Class Loader) 是 JDK 中提供的使用 Java 编写的类加载器。
* 默认加载 Java 安装目录 /jre/lib/ext 下的类文件。

可以通过扩展类加载器去加载用户 jar 包：

* 放入 /jre/lib/ext 下进行扩展：不推荐，尽可能不要去更改 JDK 安装目录中的内容。

* 使用参数进行扩展：推荐，使用 `-Djava.ext.dirs=jar包目录` 进行扩展,这种方式会覆盖掉原始目录，可以用 `;(windows):(macos/linux)` 追加上原始目录。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.54lueq7ax2k0.webp)

### 双亲委派机制

由于 Java 虚拟机中有多个类加载器，双亲委派机制的核心是解决一个类到底由谁加载的问题

双亲委派机制指的是: 当一个类加载器接收到加载类的任务时，会自底向上查找是否加载过，再由顶向下进行加载

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1fihk6a9jacg.webp)

向上查找如果已经加载过，就直接返回 Class 对象，加载过程结束，这样就能避免一个类重复加载。

如果所有的父类加载器都无法加载该类，则由当前类加载器自己尝试加载，所以看上去是自顶向下尝试加载。

第二次再去加载相同的类，仍然会向上进行委派，如果某个类加载器加载过就会直接返回。

向下委派加载起到了一个加载优先级的作用。

Java 中可以通过如下两种方式使用代码去主动加载一个类：

* 使用 Class.forName 方法，使用当前类的类加载器去加载指定的类
* 获取到类加载器，通过类加载器的 loadClass 方法指定某个类加载器加载

> 注意：父类加载器的小细节：
>
> 每个 Java 实现的类加载器中保存了一个成员变量叫“父”(Parent)类加载器，可以理解为它的上级，并不是继承关系。
>
> 应用程序类加载器的 parent 父类加载器是扩展类加载器，而扩展类加载器的 parent 是空，但是在代码逻辑上，扩展类加载器依然会把启动类加载器当成父类加载器处理。
> 启动类加载器使用 C++ 编写，没有父类加载器

**总结：**

类的双亲委派机制是什么：

1. 当一个类加载器去加载某个类的时候，会自底向上查找是否加载过，如果加载过就直接返
   如果一直到最顶层的类加载器都没有加载，再由顶向下进行加载。
2. 应用程序类加载器的父类加载器是扩展类加载器，扩展类加载器的父类加载器是启动类加
   载器。
3. 双亲委派机制的好处有两点：第一是避免恶意代码替换 JDK 中的核心类库，比如
   java.lang.String，确保核心类库的完整性和安全性。第二是避免一个类重复地被加载。

### 打破双亲委派机制

打破双亲委派机制的三种方式：

1. 自定义类加载器：自定义类加载器并且重写 loadClass 方法，就可以将双亲委派机制的代码去除。Tomcat 通过这种方式实现应用之间类隔离。
2. 线程上下文类加载器：利用上下文类加载器加载类，比如 JDBC 和 JNDI 等。
3. OSGI 框架的类加载器：历史上 OSGI 框架实现了一套新的类加载器机制，允许同级之间委托进行类的加载。

#### 自定义类加载器

一个 Tomcat 程序中是可以运行多个 Web 应用的，如果这两个应用中出现了相同限定名的类，比如 Servlet 类，Tomcat 要保证这两个类都能加载并且它们应该是不同的类。如果不打破双亲委派机制，当应用类加载器加载某个 Web 应用中的 MyServlet 之后，另一个Web 应用中相同限定名的 MyServlet 类就无法被加载了。

Tomcat 使用了自定义类加载器来实现应用之间类的隔离，每一个应用会有一个独立的类加载器加载对应的类。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2ozqwfqk1ue0.webp)

先来分析 ClassLoader 的原理，ClassLoader 中包含了 4 个核心方法双亲委派机制的核心代码就位于 loadClass 方法中。

```java
// 类加载的入口，提供了双亲委派机制。内部会调用 findClass
public Class<?> loadClass(String name);
// 由类加载器子类实现,获取二进制数据调用 defineClass，比如 URLClassLoader 会根据文件路径去获取类文件中的二进制数据
protected Class<?> findClass(String name);
// 做一些类名的校验，然后调用虚拟机底层的方法将字节码信息加载到点拟机内存中
protected final Class<?> defineClass(String name, byte[] b, int off, int len);
// 执行类生命周期中的连接阶段
protected final void resolveClass(Class<?> c);
```

具体源码如下：

```java
// ClassLoader.java
public Class<?> loadClass(String name) throws ClassNotFoundException {
    return loadClass(name, false);
}
```

```java
// ClassLoader.java 以下代码已简化
protected Class<?> loadClass(String name, boolean resolve)
    throws ClassNotFoundException
{
    synchronized (getClassLoadingLock(name)) {
        // First, check if the class has already been loaded
        Class<?> c = findLoadedClass(name);
        if (c == null) {
            // parent等于null说明父类加载器是启动类加载器，直接调用findBootstrapClassOrNull
            // 否则调用父类加载器的加载方法
            if (parent != null) {
                c = parent.loadClass(name, false);
            } else {
                c = findBootstrapClassOrNull(name);
            }
            // 父类加载器均无法加载，则由自己加载
            if (c == null) {
                c = findClass(name);
            }
        }
        return c;
    }
}
```

```java
// URLClassLoader.java
protected Class<?> findClass(final String name)
    throws ClassNotFoundException
{
    final Class<?> result;
    try {
        result = AccessController.doPrivileged(
            new PrivilegedExceptionAction<Class<?>>() {
                public Class<?> run() throws ClassNotFoundException {
                    String path = name.replace('.', '/').concat(".class");
                    Resource res = ucp.getResource(path, false);
                    if (res != null) {
                        try {
                            return defineClass(name, res);
                        } catch (IOException e) {
                            throw new ClassNotFoundException(name, e);
                        }
                    } else {
                        return null;
                    }
                }
            }, acc);
    } catch (java.security.PrivilegedActionException pae) {
        throw (ClassNotFoundException) pae.getException();
    }
    if (result == null) {
        throw new ClassNotFoundException(name);
    }
    return result;
}
```

```java
// URLClassLoader.java
private Class<?> defineClass(String name, Resource res) throws IOException {
    long t0 = System.nanoTime();
    int i = name.lastIndexOf('.');
    URL url = res.getCodeSourceURL();
    if (i != -1) {
        String pkgname = name.substring(0, i);
        // Check if package already loaded.
        Manifest man = res.getManifest();
        definePackageInternal(pkgname, man, url);
    }
    // Now read the class bytes and define the class
    java.nio.ByteBuffer bb = res.getByteBuffer();
    if (bb != null) {
        // Use (direct) ByteBuffer:
        CodeSigner[] signers = res.getCodeSigners();
        CodeSource cs = new CodeSource(url, signers);
        sun.misc.PerfCounter.getReadClassBytesTime().addElapsedTimeFrom(t0);
        return defineClass(name, bb, cs);
    } else {
        byte[] b = res.getBytes();
        // must read certificates AFTER reading bytes.
        CodeSigner[] signers = res.getCodeSigners();
        CodeSource cs = new CodeSource(url, signers);
        sun.misc.PerfCounter.getReadClassBytesTime().addElapsedTimeFrom(t0);
        return defineClass(name, b, 0, b.length, cs);
    }
}
```

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.7ah7oiknsyc0.png)

#### 线程上下文类加载器

JDBC 中使用了 DriverManager 来管理项目中引入的不同数据库的驱动，比如 mysql 驱动、oracle 驱动。

DriverManager 属于 rt.jar 是启动类加载器加载的。而用户 jar 包中的驱动需要由应用类加载器加载，这就违反了双亲委派机制。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3f9vyoc3owo0.webp)

那么 DriverManager 怎么知道 jar 包中要加载的驱动在哪儿呢：答案就是 SPI，SPI 全称为(Service Provider Interface)，是 JDK 内置的一种服务提供发现机制，SPI 的工作原理：

1. 在 ClassPath 路径下的 META-INF/services 文件夹中，以接口的全限定名来命名文件名，对应的文件里面写该接口的实现。
2. 使用 ServiceLoader 加载实现类。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5kz90akn9hc0.webp)

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2wpm20rnhmm0.webp)

```java
// 获取线程上下文类加载器
Thread.currentThread().getContextClassLoader();
// 设置线程上下文类加载器 
Thread.currentThread().setContextClassLoader(params);
```

这种由启动类加载器加载的类，委派应用程序类加载器去加载类的方式，打破了双亲委派机制。

#### OSGI 模块化

> 注意：自 JDK9 之后使用另外一套模块化，OSGI 现已不再使用。

OSGI 模块化框架存在同级之间的类加载器的委托加载。OSGI 还使用类加载器实现了热部署的功能。

### JDK9 之后的类加载器

JDK8 及之前的版本中，扩展类加载器和应用程序类加载器的源码位于 rt.jar 包中的 sun.misc.Launcher.java 中。

由于 JDK9 引入了 module 的概念，类加载器在设计上发生了很多变化。

1. 启动类加载器使用 Java 编写，位于 jdk.internal.loader.ClassLoaders 类中。Java 中的 BootClassLoader 继承自 BuiltinClassLoader 实现从模块中找到要加载的字节码资源文件。启动类加载器依然无法通过java代码获取到，返回的仍然是null，保持了统一。

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.elf56d5ddsg.png)

2. 扩展类加载器被替换成了平台类加载器 (Platform Class Loader)，平台类加载器遵循模块化方式加载字节码文件，所以继承关系从URLClassLoader 变成了 BuiltinClassLoader，BuiltinClassLoader 实现了从模块中加载字节码文件。平台类加载器的存在更多的是为了与老版本的设计方案兼容，自身没有特殊的逻辑。

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.l3nzthlv0f4.webp)

### 总结

1. 类加载器的作用是什么：

   类加载器(ClassLoader)负责在类加载过程中的字节码获取并加载到内存这一部分。通过加载字节码数据放入内存转换成 byte[]，接下来调用虚拟机底层方法将 byte[] 转换成方法区和堆中的数据。

2. 有几种类加载器：

   * 启动类加载器 (Bootstrap ClassLoader) 加载核心类
   * 扩展类加载器(Extension ClassLoader) 加载扩展类
   * 应用程序类加载器 (Application ClassLoader) 加载应用classpath中的类
   * 自定义类加载器，重写 findClass 方法
   * JDK9 及之后扩展类加载器 (Extension ClassLoader) 变成了平台类加载器(Platform ClassLoader)

3. 什么是双亲委派机制：

   每个 Java 实现的类加载器中保存了一个成员变量叫“父”(Parent)类加载器，自底向上查找是否加载过，再由顶向下进行加载。避免了核心类被应用程序重写并覆盖的问题，提升了安全性。

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.6pkni9bt6480.webp)

4. 怎么打破双亲委派机制：

   * 重写 loadClass 方法，不再实现双亲委派机制。
   * JNDI、JDBC、JCE、JAXB 和 JBI 等框架使用了 SPI 机制+线程上下文类加载器。
   * OSGI 实现了一整套类加载机制，允许同级类加载器之间互相调用。

## 运行时数据区

> 运行时数据区是 JVM 管理的内存，负责管理 JVM 使用到的内存，比如创建对象和销毁对象。

### 概述

Java 虚拟机在运行 Java 程序过程中管理的内存区域，称之为运行时数据区，《Java虚拟机规范》中规定了每一部分的作用。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.lxi1g9twkxo.webp)

### 程序计数器

程序计数器(Program Counter Register)也叫 PC 寄存器，每个线程会通过程序计数器记录当前要执行的的字节码指令的地址。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3jtmt0wj3hq0.webp)

* 在加载阶段，虚拟机将字节码文件中的指令读取到内存之后，会将原文件中的偏移量转换成内存地址。每一条字节码指令都会拥有一个内存地址。
* 在多线程执行情况下，Java 虚拟机需要通过程序计数器记录 CPU 切换前解释执行到那一句指令并继续解释运行。

### 栈

#### Java 虚拟机栈

Java虚拟机栈 (Java Virtual Machine Stack)采用栈的数据结构来管理方法调用中的基本数据，先进后出(FirstIn Last Out)，每一个方法的调用使用一个栈(Stack Frame)来保存。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.7hxizzsfxd80.webp)

栈帧的组成：

* 局部变量表：局部变量表的作用是在运行过程中存放所有的局部变量。
* 操作数栈：操作数栈是栈恢中虚拟机在执行指令过程中用来存放临时数据的一块区域。
* 帧数据：帧数据主要包含动态链接、方法出口、异常表的引用。

##### 局部变量表

* 局部变量表的作用是在方法执行过程中存放所有的局部变量。编译成字节码文件时就可以确定局部变量表的内容。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1f81tl1n3n1c.webp)

* 栈帧中的局部变量表是一个数组，数组中每一个位置称之为槽(slot)，long和double类型占用两个槽，其他类型占用一个槽。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4f6bqzx5d2u0.webp)

* 实例方法中的序号为 0 的位置存放的是 this，指的是当前调用方法的对象，运行时会在内存中存放实例对象的地址。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2mvtxmo6tqi0.webp)

* 方法参数也会保存在局部变量表中，其顺序与方法中参数定义的顺序一致，局部变量表保存的内容有：实例方法的 this 对象，方法的参数，方法体中声明的局部变量。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2s152fbct6g0.webp)

* 为了节省空间，局部变量表中的槽是可以复用的，一旦某个局部变量不再生效，当前槽就可以再次被使用。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3ttpsez71r60.webp)

##### 操作数栈

* 操作数栈是栈帧中虚拟机在执行指令过程中用来存放中间数据的一块区域。他是一种栈式的数据结构，如果一条指令将一个值压入操作数栈，则后面的指令可以弹出并使用该值。

* 在编译期就可以确定操作数栈的最大深度，从而在执行时正确的分配内存大小。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4gahzm1n6bg0.webp)

##### 帧数据

* 当前类的字节码指令引用了其他类的属性或者方法时，需要将符号引用（编号）转换成对应的运行时常量池中的内存地址。动态链接就保存了编号到运行时常量池的内存地址的映射关系。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.442uvv7s6qi0.webp)

* 方法出口指的是方法在正确或者异常结束时，当前栈帧会被弹出，同时程序计数器应该指向上一个栈帧中的下一条指令的地址。所以在当前栈帧中，需要存储此方法出口的地址。

* 异常表存放的是代码中异常的处理信息，包含了 try 代码块和 catch 代码块执行后跳转到的字节码指令位置。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.kxuuv8dj3t8.webp)

##### 栈内存溢出

* Java 虚拟机栈如果栈帧过多，占用内存超过栈内存可以分配的最大大小就会出现内存溢出。

* Java 虚拟机栈内存溢出时会出现 StackOverflowError 的错误。

* 如果我们不指定栈的大小，JVM 将创建一个具有默认大小的栈。大小取决于操作系统和计算机的体系结构。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4i7mddiwnhu0.webp)

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4atro4rc07s0.webp)

* 要修改 Java 虚拟机栈的大小，可以使用虚拟机参数 `-Xss`。语法：`-Xss栈大小单位`：字节(默认，必须是 1024 的倍数)、或者K(KB)、m或者M(MB)、g或者G(GB)。

* 与 `-Xss` 类似，也可以使用 `-XX:ThreadstackSize` 调整标志来配置堆栈大小格式为：`-XX:ThreadstackSize=1024`

* Windows(64位) 下的 JDK8 测试最小值为 180k，最大值为 1024m。

* 局部变量过多、操作数栈深度过大也会影响栈内存的大小

一般情况下，工作中即便使用了递归进行操作，栈的深度最多也只能到几百,不会出现栈的溢出。所以此参数可以手动指定为 `-Xss256k` 节省内存。

#### 本地方法栈

Java 虚拟机栈存储了 Java 方法调用时的栈帧，而本地方法栈存储的是 native 本地方法的栈帧。

在 Hotspot 虚拟机中，Java 虚拟机栈和本地方法栈实现上使用了同一个栈空间。本地方法栈会在栈内存上生成一个栈帧，临时保存方法的参数同时方便出现异常时也把本地方法的栈信息打印出来。

### 堆

一般 Java 程序中堆内存是空间最大的一块内存区域。创建出来的对象都存在于堆上。

栈上的局部变量表中，可以存放堆上对象的引用。静态变量也可以存放堆对象的引用，通过静态变量就可以实现对象在线程之间共享。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2jhcblkfs8q0.webp)

堆内存大小是有上限的，当对象一直向堆中放入对象达到上限之后，就会抛出 OutofMemory 错误。

* 堆空间有三个需要关注的值，used total max。
* used 指的是当前已使用的堆内存，total 是 Java 虚拟机已经分配的可用堆内存，max 是 Java 虚拟机可以分配的最大堆内存。
* 随着堆中的对象增多，当 total 可以使用的内存即将不足时，Java 虚拟机会继续分配内存给堆。
* 要修改堆的大小，可以使用虚拟机参数 -Xmx (max最大值) 和 -Xms(初始的total)，语法: -Xmx 值 -Xms 值，单位:字节(默认，必须是 1024 的倍数)、k或者K(KB)、m或者M(MB)、g或者G(GB)，限制：Xmx 必须大于 2MB，Xms 必须大于 1MB。

### 方法区

方法区是存放基础信息的位置，线程共享，主要包含三部分内容：

* 类的元信息：保存了所有类的基本信息。
* 运行时常量池：保存了字节码文件中的常量池内容。
* 字符串常量池：保存了字符串常量。

方法区是用来存储每个类的基本信息 (元信息)，一般称之为 InstanceKlass 对象。在类的加载阶段完成。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.fuf2ndw18i8.webp)

方法区除了存储类的元信息之外，还存放了运行时常量池。常量池中存放的是字节码中的常量池内容。

字节码文件中通过编号查表的方式找到常量，这种常量池称为静态常量池。当常量池加载到内存中之后，可以通过内存地址快速的定位到常量池中的内容，这种常量池称为运行时常量池。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.vmnk7e00qhc.webp)

方法区是《Java虚拟机规范》中设计的虚拟概念，每款 Java 虚拟机在实现上都各不相同。Hotspot 设计如下：

* JDK7 及之前的版本将方法区存放在堆区域中的永久代空间，堆的大小由虚拟机参数来控制。
* JDK8 及之后的版本将方法区存放在元空间中，元空间位于操作系统维护的直接内存中，默认情况下只要不超过操作系统承受的上限，可以一直分配。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.6es43rl4l8c0.webp)



方法区中除了类的元信息、运行时常量池之外，还有一块区域叫字符串常量池(StringTable)。字符串常量池存储在代码中定义的常量字符串内容。

早期设计时，字符串常量池是属于运行时常量池的一部分，他们存储的位置也是一致的。后续做出了调整将字符串常量池和运行时常量池做了拆分。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.58uuvnotg7k0.webp)

### 直接内存

直接内存(Direct Memory)并不在《Java虚拟机规范》中存在，所以并不属于 Java 运行时的内存区域，在 JDK 1.4 中引入了 NIO 机制，使用了直接内存，主要为了解决以下两个问题：

* Java 堆中的对象如果不再使用要回收，回收时会影响对象的创建和使用。

* IO 操作比如读文件，需要先把文件读入直接内存 (缓冲区)再把数据复制到 Java 堆中，现在直接放入直接内存即可，同时 Java 堆上维护直接内存的引用，减少了数据复制的开销。写文件也是类似的思路。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.331r4vv21so0.webp)

要创建直接内存上的数据，可以使用 ByteBuffer，语法: `ByteBuffer directBuffer = ByteBuffer.allocateDirect(size);` 

如果需要手动调整直接内存的大小，可以使用 `-XX:MaxDirectMemorySize=大小` 单位 k或K 表示千字节，m或M 表示兆字节，g或G 表示千兆字节。默认不设置该参数情况下，JVM 自动选择最大分配的大小。

## 垃圾回收

### 概述

在 C/C++ 这类没有自动垃圾回收机制的语言中，一个对象如果不再使用，需要手动释放，否则就会出现内存泄漏。我们称这种释放对象的过程为垃圾回收，而需要程序员编写代码进行回收的方式为手动回收。

内存泄漏指的是不再使用的对象在系统中未被回收，内存泄漏的积累可能会导致内存溢出。

Java 中为了简化对象的释放，引入了自动的垃圾回收 (Garbage Collection简称GC) 机制。通过垃圾回收器来对不再使用的对象完成自动的回收，垃圾回收器主要负责对**堆**上的内存进行回收。其他很多现代语言比如 C#、Python、Go 都拥有自己的垃圾回收器。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.h0nr26hd1fc.webp)

垃圾回收的对比：

* 自动垃圾回收：自动根据对象是否使用由虚拟机来回收对象
  * 优点：降低程序员实现难度、降低对象回收 bug 的可能性
  * 缺点：程序员无法控制内存回收的及时性
* 手动垃圾回收：由程序员编程实现对象的删除
  * 优点：回收及时性高，由程序员把控回收的时机
  * 缺点：编写不当容易出现悬空指针、重复释放、内存泄漏等问题

### 方法区的回收

Java 的内存管理和自动垃圾回收：线程不共享的部分，都是伴随着线程的创建而创建，线程的销毁而销毁。而方法的栈帧在执行完方法之后就会自动弹出栈并释放掉对应的内存。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1vzty45ojd8g.webp)

**方法区的回收**

方法区中能回收的内容主要就是不再使用的类，判定一个类可以被卸载。需要同时满足下面三个条件：

* 此类所有实例对象都已经被回收，在堆中不存在任何该类的实例对象以及子类对象

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.24wbyjq4in0g.webp)

* 加载该类的类加载器已经被回收

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.22lmeozy3t0g.webp)

* 该类对应的 java.lang.Class 对象没有在任何地方被引用

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.8yz8crfiwbk.webp)

手动触发回收：如果需要手动触发垃圾回收，可以调用 `System.gc()` 方法。

> 注意：调用 `System.gc()` 方法并不一定会立即回收垃圾，仅仅是向 Java 虚拟机发送一个垃圾回收的请求，具体是否需要执行垃圾回收 Java 虚拟机会自行判断。

### 堆的回收

如何判断堆上的对象可以回收：Java中的对象是否能被回收，是根据对象是否被引用来决定的。如果对象被引用了，说明该对象还
在使用，不允许被回收。

常见的有两种判断方法：**引用计数法**和**可达性分析法**

#### 引用计数法：

引用计数法会为每个对象维护一个引用计数器，当对象被引用时加 1，取消引用时减 1。

引用计数法的优点是实现简单，C++ 中的智能指针就采用了引用计数法，但是它也存在缺点，主要有两点：

* 每次引用和取消引用都需要维护计数器，对系统性能会有一定的影响。
* 存在循环引用问题，所谓循环引用就是当 A 引用 B，B 同时引用A时会出现对象无法回收的问题。

查看垃圾回收日志：

如果想要查看垃圾回收的信息，可以使用 `-verbose:gc` 参数语法：`-verbose:gc`

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3dh73c1k1rk0.webp)

#### 可达性分析法：

Java 使用的是可达性分析算法来判断对象是否可以被回收。可达性分析将对象分为两类：垃圾回收的根对象(GC Root)和普通对象，对象与对象之间存在引用关系。

下图中 A 到 B 再到 C 和 D，形成了一个引用链，可达性分析算法指的是如果从某个到 GC Root 对象是可达的，对象就不可被回收。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1rfsgxtjqs1s.png)

哪些对象被称之为 GCRoot 对象：

* 线程 Thread 对象：引用线程栈帧中的方法参数、局部变量等
* 系统类加载器加载的 java.lang.Class 对象，引用类中的静态变量
* 监视器对象，用来保存同步锁 synchronized 关键字持有的对象
* 本地方法调用时使用的全局对象

#### 五种对象引用

可达性算法中描述的对象引用，一般指的是强引用，即是 GCRoot 对象对普通对象有引用关系，只要这层关系存在，普通对象就不会被回收。除了强引用之外，Java 中还设计了几种其他引用方式：

* 软引用

  软引用相对于强引用是一种比较弱的引用关系，如果一个对象只有软引用关联到它，当程序内存不足时，就会将软引用中的数据进行回收，在 JDK1.2 版之后提供了 SoftReference 类来实现软引用，软引用常用于缓存中。

  软引用的执行过程如下：

  * 将对象使用软引用包装起来，`new SoftReference<对象类型>(对象)`
  * 内存不足时，虚拟机尝试进行垃圾回收。
  * 如果垃圾回收仍不能解决内存不足的问题，回收软引用中的对象
  * 如果依然内存不足，抛出 OutofMemory 异常

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.18khk1cubku8.webp)

  软引用中的对象如果在内存不足时回收，SoftReference 对象本身也需要被回收。如何知道哪些 SoftReference 对象需要回收呢？
  SoftReference 提供了一套队列机制：

  * 软引用创建时，通过构造器传入引用队列
  * 在软引用中包含的对象被回收时，该软引用对象会被放入引用队列
  * 通过代码遍历引用队列，将 SoftReference 的强引用删除

* 弱引用

  弱引用的整体机制和软引用基本一致，区别在于弱引用包含的对象在垃圾回收时，不管内存够不够都会直接被回收。在 JDK1.2 版之后提供了 WeakReference 类来实现弱引用，弱引用主要在 ThreadLocal 中使用。弱引用对象本身也可以使用引用队列进行回收。

* 虚引用

  虚引用也叫幽灵引用/幻影引用，不能通过虚引用对象获取到包含的对象。虚引用唯一的用途是当对象被垃圾回收器回收时可以接收到对应的通知。Java 中使用 PhantomReference 实现了虚引用，直接内存中为了及时知道直接内存对象不再使用，从而回收内存，使用了虚引用来实现。

* 终结器引用

  终结器引用指的是在对象需要被回收时，对象将会被放置在 Finalizer 类中的引用队列中，并在稍后由一条由 FinalizerThread 线程从队列中获取对象，然后执行对象的 finalize 方法。在这个过程中可以在 finalize 方法中再将自身对象使用强引用关联上，但是不建议这样做，如果耗时过长会影响其他对象的回收。

#### 垃圾回收算法

##### 概述

**垃圾回收要做的有两件事：**

* 找到内存中存活的对象
* 释放不再存活对象的内存，使得程序能再次利用这部分空间

**常见的垃圾回收算法：**

* 1960 年 John McCarthy 发布了第一个 GC 算法：标记-清除算法
* 1963 年 Marvin LMinsky 发布了复制算法

本质上后续所有的垃圾回收算法，都是在上述两种算法的基础上优化而来。

* 标记-整理算法
* 分代 GC

**垃圾回收算法的评价标准：**
Java 垃圾回收过程会通过单独的 GC 线程来完成，但是不管使用哪一种 GC 算法，都会有部分阶段需要停止所有的用户线程。这个过程被称之为 Stop The World 简称 STW，如果 STW 时间过长则会影响用户的使用。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2a6yi8y9sav4.webp)

**判断 GC 算法是否优秀**，可以从三个方面来考虑：

* 吞吐量：吞吐量指的是 CPU 用于执行用户代码的时间与 CPU 总执行时间的比值，即吞吐量=执行用户代码时间/
  (执行用户代码时间 + GC时间)。吞吐量数值越高，垃圾回收的效率就越高。

* 最大暂停时间：最大暂停时间指的是所有在垃圾回收过程中的 STW 时间最大值。比如如下的图中，黄色部分的 STW 就是最大暂停时间，显而易见上面的图比下面的图拥有更少的最大暂停时间。最大暂停时间越短，用户使用系统时受到的影响就越短。

  ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5mwv43s6ak80.webp)

* 堆使用效率：不同垃圾回收算法，对堆内存的使用方式是不同的。比如标记清除算法，可以使用完整的堆内存。而复制算
  法会将堆内存一分为二，每次只能使用一半内存。从堆使用效率上来说，标记清除算法要优于复制算法。

上述三种评价标准：堆使用效率、吞吐量，以及最大暂停时间不可兼得，一般来说，堆内存越大，最大暂停时间就越长。想要减少最大暂停时间，就会降低吞吐量，不同的垃圾回收算法，适用于不同的场景。

##### 标记清除算法

标记清除算法的核心思想分为两个阶段：

* 标记阶段，将所有存活的对象进行标记。Java 中使用可达性分析算法，从 GC Root 开始通过引用链遍历出所有存活对象。
* 清除阶段，从内存中删除没有被标记也就是非存活对象。

优点：实现简单，只需要在第一阶段给每个对象维护标志位，第二阶段删除对象即可。

缺点：

* 碎片化问题：由于内存是连续的，所以在对象被删除之后，内存中会出现很多细小的可用内存单元。如果我们需要的是
  个比较大的空间，很有可能这些内存单元的大小过小无法进行分配。
* 分配速度慢：由于内存碎片的存在，需要维护一个空闲链表，极有可能发生每次需要遍历到链表的最后才能获得合适的内存空间。

##### 复制算法

复制算法的核心思想是：

* 准备两块空间 From 空间和 To 空间，每次在对象分配阶段，只能使用其中一块空间 (From空间)。
* 在垃圾回收 GC 阶段，将 From 中存活对象复制到 To 空间。
* 将两块空间的 From 和 To 名字互换。

优点：

* 吞吐量高：复制算法只需要遍历一次存活对象复制到 To 空间即可，比标记-整理算法少了一次遍历的过程，因而性能较好，但是不如标记-清除算法因为标记-清除算法不需要进行对象的移动。
* 不会发生碎片化：复制算法在复制之后就会将对象按顺序放入 To 空间中，所以对象以外的区域都是可用空间，不存在碎片化内存空间。

缺点：内存使用效率低，每次只能让一半的内存空间来为创建对象使用。

##### 标记-整理算法

标记整理算法也叫标记压缩算法，是对标记清理算法中容易产生内存碎片问题的一种解决方案。

核心思想分为两个阶段：

* 标记阶段，将所有存活的对象进行标记。Java 中使用可达性分析算法，从 GC Root 开始通过引用链遍历出所有存活对象。
* 整理阶段，将存活对象移动到堆的一端。清理掉存活对象的内存空间。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.46usrcutry00.webp)

优点：

* 内存使用效率高：整个堆内存都可以使用，不会像复制算法只能使用半个堆内存。
* 不会发生碎片化：在整理阶段可以将对象往内存的一侧进行移动，剩下的空间都是可以分配对象的有效空间。

缺点：整理阶段的效率不高，整理算法有很多种，比如 Lisp2 整理算法需要对整个堆中的对象搜索 3 次，整体性能不佳。可以通过 Two-
Finger、表格算法、ImmixGC 等高效的整理算法优化此阶段的性能。

##### 分代 GC

现代优秀的垃圾回收算法，会将上述描述的垃圾回收算法组合进行使用，其中应用最广的就是分代垃圾回收算法(Generational GC)。

分代垃圾回收将整个内存区域划分为年轻代和老年代：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3bwvisbrzs20.webp)

分代回收时，创建出来的对象，首先会被放入 Eden 伊甸园区。

随着对象在 Eden 区越来越多，如果 Eden 区满，新创建的对象已经无法放入，就会触发年轻代的 GC，称为 Minor GC 或者 Young GC。

Minor GC 会把 Eden 中和 From 需要回收的对象回收，把没有回收的对象放入 To 区。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.6il9vl93gns0.webp)

接下来，S0 会变成 To 区，S1 变成 From 区。当 Eden 区满时再往里放入对象，依然会发生 Minor GC。

此时会回收 Eden 区和 S1(from)中的对象，并把 Eden 和 From 区中剩余的对象放入 S0。

注意：每次 Minor GC 中都会为对象记录他的年龄，初始值为 0，每次 GC 完加 1。

如果 Minor GC 后对象的年龄达到阈值（最大 15，默认值和垃圾回收器有关），对象就会被晋升至老年代。

当老年代中空间不足，无法放入新的对象时，先尝试 minor gc 如果还是不足，就会触发 Full GC，Full GC 会对整个堆进行垃圾回收。

#### 垃圾回收器

垃圾回收器是垃圾回收算法的具体实现。

由于垃圾回收器分为年轻代和老年代，除了 G1 之外其他垃圾回收器必须成对组合进行使用。

具体的关系图如下:

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.c28qx3tksow.webp)

##### 年轻代-Serial 回收器

Serial 是一种**单线程串行**回收年轻代的垃圾回收器

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2kkj44c6fc60.webp)

回收年代和算法：年轻代，复制算法

优点：单 CPU 处理器下吞吐量非常出色

缺点：多 CPU 下吞吐量不如其他垃圾回收器，堆如果偏大会让用户线程处于长时间的等待

适用场景：Java 编写的客户端程序或者硬件配置有限的场景

##### 老年代-SerialOld 垃圾回收器

SerialOld 是 Serial 垃圾回收器的老年代版本，采用单线程串行回收

`-XX:+UseSerialGC` 新生代、老年代都使用串行回收器

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2kkj44c6fc60.webp)

回收年代和算法：老年代，标记-整理算法

优点：单CPU处理器下吞吐量非常出色

缺点：多CPU下吞吐量不如其他垃圾回收器，堆如果偏大会让用户线程处于长时间的等待

适用场景：与 Serial 垃圾回收器搭配使用或者在 CMS 特殊情况下使用

##### 年轻代-ParNew 垃圾回收器

ParNew 垃圾回收器本质上是对 Serial 在多 CPU 下的优化，使用多线程进行垃圾回收

`-XX:+UseParNewGC` 新生代使用 ParNew回收器，老年代使用串行回收器

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.61byslfmnf00.webp)

回收年代和算法：年轻代，复制算法

优点：多CPU处理器下停顿时间较短

缺点：吞吐量和停顿时间不如 G1，所以在 JDK9 之后不建议使用

适用场景：JDK8 及之前的版本中，与 CMS 老年代垃圾回收器搭配使用

##### 老年代- CMS(Concurrent Mark Sweep)垃圾回收器

CMS 垃圾回收器关注的是系统的暂停时间，允许用户线程和垃圾回收线程在某些步骤中同时执行，减少了用户线程的等待时间。

参数：`XX:+UseConcMarkSweepGC`

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.6fekap4ysdo0.webp)

回收年代和算法：老年代，标记-清除算法

优点：系统由于垃圾回收出现的停顿时间较短，用户体验好

缺点：内存碎片问题，退化问题，浮动垃圾问题

* CMS 使用了标记-清除算法，在垃圾收集结束之后会出现大量的内存碎片，CMS 会在 Full GC 时进行碎片的整理。这样会导致用户线程暂停，可以使用 `-XX:CMSFuLLGCsBeforeCompaction=N 参数(默认0)`  调整次 Full GC 之后再整理。
* 无法处理在并发清理过程中产生的“浮动垃圾”，不能做到完全的垃圾回收。
* 如果老年代内存不足无法分配对象，CMS 就会退化成 Serial old 单线程回收老年代。

适用场景：大型的互联网系统中用户请求数据量大、频率高的场景比如订单接口、商品接口等

CMS 执行步骤：

* 初始标记，用极短的时间标记出 GC Roots 能直接关联到的对象
* 并发标记，标记所有的对象，用户线程不需要暂停
* 重新标记，由于并发标记阶段有些对象会发生了变化，存在错标、漏标等情况需要重新标记
* 并发清理，清理死亡的对象，用户线程不需要暂停

##### 年轻代-Parallel Scavenge 垃圾回收器

Parallel Scavenge 是 JDK8 默认的年轻代垃圾回收器，多线程并行回收，关注的是系统的吞吐量。具备自动调整堆内存大小的特点。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.61byslfmnf00.webp)

回收年代和算法：年轻代，复制算法

优点：吞吐量高，而且手动可控。为了提高吞吐量，虚拟机会动态调整堆的参数

缺点：不能保证单次的停顿时间

适用场景：后台任务，不需要与用户交互，并且容易产生大量的对象。比如：大数据的处理，大文件导出

##### 老年代-Parallel old 垃圾回收器

Parallel Old 是为 Parallel Scavenge 收集器设计的老年代版本，利用多线程并发收集。

参数：`-XX:+UseParallelGC` 或 `-XX:+UseParallelOldGC` 可以使用 Parallel Scavenge + ParallelOld 这种组合。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.61byslfmnf00.webp)

回收年代和算法：老年代，标记-整理算法

优点：并发收集，在多核CPU下效率较高

缺点：暂停时间会比较长

适用场景：与 Parallel Scavenge 配套使用

##### G1垃圾回收器

JDK9 之后默认的垃圾回收器是 G1 (Garbage First) 垃圾回收器。

Parallel Scavenge 关注吞吐量，允许用户设置最大暂停时间，但是会减少年轻代可用空间的大小。

CMS 关注暂停时间，但是吞吐量方面会下降。

而 G1 设计目标就是将上述两种垃圾回收器的优点融合。

* 支持巨大的堆空间回收，并有较高的吞吐量。
* 支持多 CPU 并行垃圾回收。
* 允许用户设置最大暂停时间。

G1出现之前的垃圾回收器，内存结构一般是连续的，如下图：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.234q2wt3p0ao.webp)

G1 的整个堆会被划分成多个大小相等的区域，称之为区 Region，区域不要求是连续的。分为 Eden、Survivor、Old 区。Region 的大小通过堆空间大小/2048 计算得到，也可以通过参数 `-XX:G1HeapRegionSize=32m` 指定(其中 32m 指定 region 大小为 32M)，Region size 必须是 2 的指数幂，取值范围从 1M 到 32M。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1ociydldeew0.webp)

G1 垃圾回收有两种方式

* 年轻代回收 (Young GC)
* 混合回收 (Mixed GC)

**年轻代回收 (Young GC)**，回收 Eden 区和 Survivor 区中不用的对象。会导致 STW，G1 中可以通过参数 `-XX:MaxGCPauseMillis=n` (默认200) 设置每次垃圾回收时的最大暂停时间毫秒数，G1 垃圾回收器会尽可能地保证暂停时间。

**执行流程：**

1. 新创建的对象会存放在 Eden 区。当 G1 判断年轻代区不足(max默认60%)，无法分配对象时需要回收时会执行 Young GC。

2. 标记出 Eden 和 Survivor 区域中的存活对象。

3. 根据配置的最大暂停时间**选择某些区域**将存活对象复制到一个新的 Survivor 区中(年龄 +1)，清空这些区域。

   G1 在进行 Young GC 的过程中会去记录每次垃圾回收时每个 Eden 区和 Survivor 区的平均耗时，以作为下次回收时的参考依据。这样就可以根据配置的最大暂停时间计算出本次回收时最多能回收多少个 Region 区域了。比如 `-XX:MaxGCPauseMillis=n` (默认200)，每个Region 回收耗时 40ms，那么这次回收最多只能回收 4 个 Region。

4. 后续 Young GC 时与之前相同，只不过 Survivor 区中存活对象会被搬运到另一个 Survivor 区。

5. 当某个存活对象的年龄到达闽值 (默认15)，将被放入老年代。

6. 部分对象如果大小超过 Region 的一半，会直接放入老年代，这类老年代被称为 Humongous 区。比如堆内存是 4G，每个 Region 是 2M，只要一个大对象超过了 1M 就被放入 Humongous 区，如果对象过大会横跨多个 Region。

7. 多次回收之后，会出现很多 Old 老年代区，此时总堆占有率达到闻值时 (`-XX:InitiatingHeapOccupancyPercent` 默认45%)会触发混合回收 MixedGC，回收所有年轻代和部分老年代的对象以及大对象区。采用复制算法来完成。

**混合回收**：混合回收分为：初始标记 (initial mark)、并发标记 (concurrent mark) 、最终标记(remark或者Finalize Marking)、并发清理(cleanup)
G1 对老年代的清理会选择存活度最低的区域来进行回收，这样可以保证回收效率最高，这也是 G1 (Garbage first)名称的由来。

最后清理阶段使用复制算法，不会产生内存碎片。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3qw2bl57ie80.webp)


> 注意：如果清理过程中发现没有足够的空 Region 存放转移的对象，会出现 Full GC。单线程执行标记-整理算法此时会导致用户线程的暂停。所以尽量保证应该用的堆内存有一定多余的空间。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.55imsn8n78w0.webp)

回收年代和算法：年轻代+老年代，复制算法

优点：

* 对比较大的堆如超过 6G 的堆回收时，不会产生内存碎片
* 并发标记的SATB算法效率高
* 证迟可控

缺点：JDK8 之前还不够成熟

适用场景：JDK8 最新版本、JDK9 之后建议默认使用

##### 组合

垃圾回收器的组合关系虽然很多，但是针对几个特定的版本，比较好的组合选择如下：

JDK8 及之前：

* ParNew + CMS (关注暂停时间)
* Parallel Scavenge + Parallel Old (关注吞吐量)
* G1 (JDK8 之前不建议，较大堆并且关注暂停时间)

JDK9 之后：

* G1 (默认)

  从 JDK9 之后，由于 G1 日趋成熟，JDK 默认的垃圾回收器已经修改为 G1，所以强烈建议在生产环境上使用 G1

##### 总结

有哪几种常见的引用类型：

* 强引用，最常见的引用方式，由可达性分析算法来判断
* 软引用，对象在没有强引用情况下，内存不足时会回收
* 弱引用，对象在没有强引用情况下，会直接回收
* 虚引用，通过虚引用知道对象被回收了
* 终结器引用，对象回收时可以自救，不建议使用

有哪几种常见的垃圾回收算法：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1tofkzzl7u5c.webp)

常见的垃圾回收器有哪些：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2shvo0ngndk0.webp)

## 内存调优

### 内存泄漏和内存溢出

**内存泄漏(memoryleak)：**在 Java 中如果不再使用一个对象，但是该对象依然在 GC ROOT 的引用链上这个对象就不会被垃圾回收器回收，这种情况就称之为**内存泄漏**。

内存泄漏绝大多数情况都是由堆内存泄漏引起的，所以后续没有特别说明则讨论的都是堆内存泄漏。

少量的内存泄漏可以容忍，但是如果发生持续的内存泄漏，就像滚雪球雪球越滚越大，不管有多大的内存迟早会被消耗完，最终导致的结果就是**内存溢出**。但是产生内存溢出并不是只有内存泄漏这一种原因。

常见场景：

* 内存泄漏导致溢出的常见场景是大型的 Java 后端应用中，在处理用户的请求之后，没有及时将用户的数据删除。随着用户请求数量越来越多，内存泄漏的对象占满了堆内存最终导致内存溢出。这种产生的内存溢出会直接导致用户请求无法处理，影响用户的正常使用。重启可以恢复应用使用，但是在运行一段时间之后依然会出现内存溢出。
* 第二种常见场景是分布式任务调度系统如 Elastic-job、Quartz 等进行任务调度时，被调度的 Java 应用在调度任务结束中出现了内泄漏，最终导致多次调度之后内存溢出。这种产生的内存溢出会导致应用执行下次的调度任务执行。同样重启可以恢复应用使用，但是在调度执行一段时间之后依然会出现内存溢出。

### 解决内存泄漏

解决内存溢出的步骤总共分为四个步骤，其中前两个步骤是最核心的：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.55a2emrb19o0.webp)

#### Top命令

top 命令是 linux 下用来查看系统信息的一个命令，它提供给我们去实时地去查看系统的资源，比如执行时的进程、线程和系统参数等信息。

进程使用的内存为 RES(常驻内存)- SHR(共享内存)

优点：操作简单，无额外的软件安装

缺点：只能查看最基础的进程信息，无法查看到每个部分的内存占用(堆、方法区、堆外)

#### VisualVM

visualVM 是多功能合一的 Java 故障排除工具并且他是一款可视化工具，整合了命令行 JDK 工具和轻量级分析功能，功能非常强大。

这款软件在 Oracle JDK 6~8 中发布，但是在 Oracle JDK 9 之后不在 JDK 安装目录下需要单独下载。下载地址：[VisualVM: Home](https://visualvm.github.io/) 

优点：功能丰富，实时监控CPU、内存、线程等详细信息，支持 Idea 插件，开发过程中也可以使用

缺点：对大量集群化部署的 Java 进程需要手动进行管理

#### Arthas

Arthas 是一款线上监控诊断产品，通过全局视角实时查看应用 load、内存 gc、线程的状态信息，并能在不修改应用代码的情况下，对业务问题进行诊断，包括查看方法调用的出入参、异常，监测方法执行耗时，类加载信息等，大大提升线上问题排查效率。

优点：功能强大，不止于监控基础的信息，还能监控单个方法的执行耗时等细节内容。支持应用的集群管理

缺点：部分高级功能使用门槛较高

#### Prometheus + Grafana

Prometheus + Grafana 是企业中运维常用的监控方案，其中 Prometheus 用来采集系统或者应用的相关数据，同时具备告警功能。Grafana 可以将 Prometheus 采集到的数据以可视化的方式进行展示。

Java 程序员要学会如何读懂 Grafana 展示的 Java 虚拟机相关的参数。

优点：支持系统级别和应用级别的监控，比如 linux 操作系统、Redis、MySQL、Java 进程，支持告警并允许自定义告警指标，通过邮件、短信等方式尽早通知相关人员进行处理

缺点：环境搭建较为复杂，一般由运维人员完成

#### 发现问题

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.32xbmgu05io0.webp)

#### 产生原因

1. 代码中的内存泄漏：

   * equals() 和hashCode()：不正确的 equals() 和 hashCode() 实现导致内存泄漏。

     在定义新类时没有重写正确的 equals() 和 hashCode() 方法。在使用 HashMap 的场景下，如果使用这个类对象作为 key，HashMap 在判断 key 是否已经存在时会使用这些方法，如果重写方式不正确，会导致相同的数据被保存多份。

     解决方案：

     * 在定义新实体时，始终重写 equals() 和 hashCode() 方法
     * 重写时一定要确定使用了唯一标识去区分不同的对象，比如用户的 id 等
     * hashmap 使用时尽量使用编号 id 等数据作为 key，不要将整个实体类对象作为 key 存放

   * 内部类引用外部类：非静态的内部类和匿名内部类的错误使用导致内存泄漏

     非静态的内部类默认会持有外部类，尽管代码上不再使用外部类，所以如果有地方引用了这个非静态内部类，会导致外部类也被引用，垃圾回收时无法回收这个外部类。

     匿名内部类对象如果在非静态方法中被创建，会持有调用者对象，垃圾回收时无法回收调用者。

     解决方案：

     * 使用内部类的原因是可以直接获取到外部类中的成员变量值，简化开发。如果不想持有外部类对象，应该使用静态内部类
     * 使用静态方法，可以避免匿名内部类持有调用者对象

   * ThreadLocal 的使用：由于线程池中的线程不被回收导致的ThreadLocal内存泄漏

     如果仅仅使用手动创建的线程，就算没有调用 ThreadLocal 的 remove 方法清理数据，也不会产生内存泄漏。因为当线程被回收时，ThreadLocal 也同样被回收。但是如果使用线程池就不一定了。

     解决方案:

     * 线程方法执行完，一定要调用 ThreadLocal 中的 remove 方法清理对象

   * String 的 intern 方法：由于 JDK6 中的字符串常量池位于永久代，intern 被大量调用并保存产生的内存泄漏

     JDK6 中字符串常量池位于堆内存中的 Perm Gen 永久代中，如果不同字符串的 intern 方法被大量调用，字符串常量池会不停的变大超过永久代内存上限之后就会产生内存溢出问题。

     解决方案：

     * 注意代码中的逻辑，尽量不要将随机生成的字符串加入字符串常量池
     * 增大永久代空间的大小，根据实际的测试/估算结果进行设置 `-XX:MaxPermSize=256M` 

   * 通过静态字段保存对象：大量的数据在静态变量中被引用，但是不再使用，成为了内存泄漏

     如果大量的数据在静态变量中被长期引用，数据就不会被释放，如果这些数据不再使用，就成为了内存泄漏。

     解决方案:

     * 尽量减少将对象长时间的保存在静态变量中，如果不再使用，必须将对象删除(比如在集合中)或者将静态变量设置为 null。
     * 使用单例模式时，尽量使用懒加载，而不是立即加载。
     * Spring 的 Bean 中不要长期存放大对象，如果是缓存用于提升性能，尽量设置过期时间定期失效。

   * 资源没有正常关闭：由于资源没有调用 close 方法正常关闭，导致的内存溢出

2. 并发请求问题

   并发请求问题指的是用户通过发送请求向 Java 应用获取数据，正常情况下 Java 应用将数据返回之后，这部分数据就可以在内存中被释放掉。但是由于用户的并发请求量有可能很大，同时处理数据的时间很长，导致大量的数据存在于内存中，最终超过了内存的上限，导致内存溢出。这类问题的处理思路和内存泄漏类似，首先要定位到对象产生的根源。

### 诊断

当堆内存溢出时，需要在堆内存溢出时将整个堆内存保存下来，生成内存快照(Heap Profile )文件

使用 MAT 打开 hprof 文件，并选择内存泄漏检测功能，MAT 会自行根据内存快照中保存的数据分析内存泄漏的根源。

生成内存快照的Java虚拟机参数：

`-XX:+HeapDumpOnOutOfMemoryError` ：发生 OutOfMemoryError 错误时，自动生成 hprof 内存快照文件.

`XX:HeapDumpPath=<path>` ：指定 hprof 文件的输出路径

**MAT内存泄漏检测的原理**

**支配树：**

MAT 提供了称为**支配树(Dominator Tree)**的对象图。支配树展示的是对象实例间的支配关系。在对象引用图中，所有指向对象 B 的路径都经过对象 A，则认为对象 A 支配对象 B。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.535ycls9zf80.webp)

**深堆和浅堆**

支配树中对象本身占用的空间称之为**浅堆(Shallow Heap)**支配树中对象的子树就是所有被该对象支配的内容，这些内容组成了对象的**深堆(Retained Heap)**也称之为**保留集(Retained Set)** 。深堆的大小表示该对象如果可以被回收，能释放多大的内存空间。


![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.13j47mada4v4.webp)

MAT 就是根据支配树，从叶子节点向根节点遍历，如果发现深堆的大小超过整个堆内存的一定比例闯值，就会将其标记成内存泄漏的“嫌疑对象”

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.6gl6z3l4yf4.webp)



## GC 调优

## 性能调优
