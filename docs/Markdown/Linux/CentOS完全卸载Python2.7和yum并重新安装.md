# CentOS完全卸载Python2.7和yum并重新安装

## 删除

1. **删除现有Python** 

   1. 强制删除已安装程序及其关联

   ```
   rpm -qa|grep python|xargs rpm -ev --allmatches --nodeps
   ```

   2. 删除所有残余文件

   ```
   whereis python |xargs rm -frv
   ##xargs，允许你对输出执行其他某些命令
   ```

   3. 验证删除，返回无结果

   ```
   whereis python
   ```

2. **删除现有的yum**

   ```
   rpm -qa|grep yum|xargs rpm -ev --allmatches --nodeps
   whereis yum |xargs rm -frv
   whereis yum
   ```

## 安装

1. **从镜像下载所需要的rpm文件**

```
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/lvm2-python-libs-2.02.187-6.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/libxml2-python-2.9.1-6.el7.5.x86_64.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-libs-2.7.5-89.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-ipaddress-1.0.16-2.el7.noarch.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-backports-1.0-8.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-2.7.5-89.el7.x86_64.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-pycurl-7.19.0-19.el7.x86_64.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-urlgrabber-3.10-10.el7.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-setuptools-0.9.8-7.el7.noarch.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-kitchen-1.1.1-5.el7.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/python-chardet-2.2.1-3.el7.noarch.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/rpm-python-4.11.3-45.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-utils-1.1.31-54.el7_8.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-3.4.3-168.el7.centos.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-plugin-aliases-1.1.31-54.el7_8.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-plugin-protectbase-1.1.31-54.el7_8.noarch.rpm 
wget http://mirrors.163.com/centos/7.9.2009/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm
```

2. **在当前文件夹执行以下命令**

```
rpm -Uvh --replacepkgs lvm2-python-libs*.rpm --nodeps --force
rpm -Uvh --replacepkgs libxml2-python*.rpm --nodeps --force
rpm -Uvh --replacepkgs python*.rpm --nodeps --force
rpm -Uvh --replacepkgs rpm-python*.rpm yum*.rpm --nodeps --force
```