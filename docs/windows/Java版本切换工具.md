# Java版本切换工具

> 在实际使用中，我们经常会遇到需要安装多个Java版本的情况，在此基础上使用该工具可以快速切换使用的Java版本

## 环境准备

1. 设置环境变量

   > 单击此电脑->属性->搞机->高级系统设置->环境变量

   * 在系统变量下选择新建系统变量并保存
     * 变量名：`JAVA_HOME`
     * 变量值：`%JAVA_HOME_你的Java版本%`
   * 再次新建系统变量并保存
     * 变量名：`JAVA_HOME_你的Java版本`
     * 变量值：`你的JDK根目录`
   * 找到系统变量中的Path，选择编辑，在新窗口中点击新建，填入`%JAVA_HOME%\bin`并保存

2. 重复以上步骤配置好你的所有Java版本

3. 下载版本切换工具，使用管理员运行，根据指引操作即可或者也可编辑下方代码进行自定义

## 代码

```shell
@echo off
@echo ------------------------------------------------
@echo 当前Java版本为:
java -version
@echo ------------------------------------------------
@echo 输入要使用的java版本对应的选项:
@echo 选项     含义
@echo 202      切换环境为JDK8_202
@echo 291      切换环境为JDK8_291
@echo 17       切换环境为JDK17
@echo ------------------------------------------------
set /P choose=请输入选择:
IF "%choose%" EQU "202" (
    REM 修改JAVA_HOME环境变量为%JAVA_HOME_202%,
    setx "JAVA_HOME" "%%JAVA_HOME_202%%" /m
    echo 已经修改 "JAVA_HOME" 为 %%JAVA_HOME_202%%
) ELSE IF "%choose%" EQU "291" (
    setx "JAVA_HOME" "%%JAVA_HOME_291%%" /m
    echo 已经修改 "JAVA_HOME" 为 %%JAVA_HOME_291%%
) ELSE IF "%choose%" EQU "17" (
    setx "JAVA_HOME" "%%JAVA_HOME_17%%" /m
    echo 已经修改 "JAVA_HOME" 为 %%JAVA_HOME_17%%
)
pause
```



