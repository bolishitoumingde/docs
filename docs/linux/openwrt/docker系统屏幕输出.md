## 需求

现在有一个j1900小主机已经刷入iStoreOS系统充当软路由，与此同时我希望使用该系统输出视频信号到电视，当作主机使用。

## 实现

1. **安装docker**

   iStoreOS已经默认安装了docker，可以在侧边目录栏中找到，如果未安装可以在iStore中搜索并安装docker。

2. **安装并启动docker版ubuntu**

   * 在iStore中搜索ubuntu并安装，刷新页面可在服务栏找到ubuntu的设置页面。

     > 导航：服务->Ubuntu

   *  在设置界面配置端口号和登录密码，启动ubuntu系统。

   * 点击上方链接进入系统的Web界面

3. **配置docker输出**

   * 找到docker容器id，使用以下命令实现，复制需要的容器id。
   
     ```bash
     docker ps
     ```
   
   * 使用HDMI线连接电视与主机。
   
   * 获取主机HDMI接口名称，一般情况下，HDMI接口有多个，例如HDMI-1、HDMI-2、HDMI-3等。可以通过以下命令来查看宿主机的所有HDMI接口。
   
     ```bash
     xrandr
     ```
   
   * 选择需要输出的HDMI接口，使用`docker exec`命令在容器内执行以下命令，将显示端口映射到主机的HDMI接口。
   
     ```bash
     docker exec -it <容器ID或名称> /bin/bash -c "xrandr --output HDMI-1 --auto"
     ```
   
   * 你可能还需要进行以下操作，在运行Docker容器时，使用`-v`参数将宿主机上的HDMI接口映射到容器内的某个端口（例如5900）
   
     ```bash
     docker run -it --rm -v /dev/video0:/dev/video0 <image_name> /bin/bash 
     ```
   
     其中，`/dev/video0`是宿主机上的HDMI接口设备文件路径，`<image_name>`是你要运行的Docker镜像的名称。在Linux系统中，这个路径可能是`/sys/class/display/<HDMI接口设备名称>/device/driver`。你可以通过在终端中输入以下命令来查看你的HDMI接口设备名称：
   
     ```bash
     ls /sys/class/display
     ```
   
     在Linux系统中，可以使用以下命令来查看HDMI接口设备的驱动程序：
   
     ```bash
     lsmod | grep HDMI
     ```
   