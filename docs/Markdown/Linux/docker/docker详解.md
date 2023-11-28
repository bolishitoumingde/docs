### Example

[Docker Hub Container Image Library | App Containerization](https://hub.docker.com/)

以MySQL为例：

```bash
docker run -d \
	--name mysql \
	-p 3306:3306 \
	-e TZ=Asia/Shanghai \
	-e MYSQL_ROOT_PASSWORD=123456 \
	mysql
```

* `docker run` 创建并运行一个容器  `-d` 后台运行
* `--name` 给容器起名，必须唯一
* `-p` 设置端口映射，前面是映射到宿主机的端口，后面是容器内部端口
* `-e key=value` 环境变量，镜像执行时可能需要用到
* mysql 指定运行的镜像名称

>  注意：镜像名称一般分为两部分：[repository]:[tag]
>
> * 其中 repository 表示镜像名
> * tag 表示镜像版本
>
> 在未指定 tag 时默认拉取 latest 最新版本

### 常见命令

详见：[Docker Docs](https://docs.docker.com/)

`docker pull [repository]:[tag]` 拉取镜像

`docker images` 查看本地存在的镜像

`docker rmi [-f] [image name]` 删除指定 image name 的镜像 -f 表示强制删除

`docker build`

`docker start` 启动指定 docker 容器

`docker stop` 停止指定 docker 容器

`docker ps` 查看正在运行的 docker 容器

```bash
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"
```

格式化输出正在运行的 docker 容器

`docker rm` 删除容器

`docker logs` 查看容器运行的日志

`docker exec` 进入容器内部执行命令

### 命令别名

创建 Linux 命令别名可以简化命令书写

```bash
vi ~/.bashrc
```

进入 `bashrc` 文件并添加即可

修改完成后使用下方命令更新文件

```bash
source ~/.bashrc
```

### 数据卷挂载

>  数据卷（volume）是一个虚拟目录，是容器内目录与宿主机目录之间映射的桥梁
>
> 建议参照官方镜像文档

容器内文件是隔离在容器内部的，为了从外部访问可以使用**数据卷挂载**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.7gehid5wis40.webp)

挂载操作只能在 docker 容器创建时操作，可以在 docker run 语句中添加 `-v [数据卷]:[容器内目录]` 参数来指定挂载目录，如果挂载了数据卷且数据卷不存在，会自动创建数据卷。

以 nginx 为例：`-v html:/usr/share/nginx/html`

**相关指令**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1wxwey4rv674.webp)

### 本地目录挂载

使用 `-v [本地目录]:[容器内目录]` 参数来指定本地目录挂载

> 注意：本地目录必须以 "/" 或者 "./" 开头，否则会被识别为数据卷
>
> 建议参照官方镜像文档

### Dockerfile 语法

**镜像结构**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3dvrpikqapg0.webp)

**Dockerfile**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2xs7kvv6hw60.webp)

详细语法说明请参考：[Dockerfile reference | Docker Docs](https://docs.docker.com/engine/reference/builder/)

```dockerfile
FROM openjdk:8-jre-buster
ENV TZ=Asia/Shanghai
COPY comic-comic_v1.1.0.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

编写好 Dockerfile 文件后

使用下方命令

```bash
docker build -t [repository]:[tag] .
```

* `-t` 是给镜像起名，格式依旧为 [repository]:[tag] ，不指定 tag 时将默认 latest
* `.` 是指定 Dockerfile 所在目录，如果就在当前目录则指定为 "."

之后使用 `docker run` 命令运行即可

### 容器网络互联

**网络**

默认情况下，所有容器都是以 bridge 方式连接到 docker 的一个虚拟网桥上

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3f42tq1cxf60.png)

加入自定义网络的容器才可以通过容器名互相访问，docker 的网络操作命令如下：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.n8rhxr8hjj4.webp)

### Docker Compose

Docker Compose 通过一个单独的 docker-compose.yml 模板文件（YAML格式）来定义一组相关联的应用容器，帮助我们实现多个关联的 docker 容器的快速部署。

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.112zp8uo9l34.png)

Dockerfile 和 docker-compose.yml 对比如下图：

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.1j04lpbo47uo.webp)

