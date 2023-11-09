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
3. Osgi 框架的类加载器：历史上 Osgi 框架实现了一套新的类加载器机制，允许同级之间委托进行类的加载。

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



### JDK9 之后的类加载器

