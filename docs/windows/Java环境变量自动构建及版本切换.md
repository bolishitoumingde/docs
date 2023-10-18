**Java环境变量自动构建及版本切换**

> 在实际使用中，我们经常会遇到需要安装多个Java版本的情况，在此基础上使用该工具可以快速切换使用的Java版本

> 以下更新了Java环境变量自动构建工具以及Java版本切换工具v2

分为纯手动版本以及自动版本

## 手动版本

### 环境准备

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

### 代码

```bat
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

### 文件下载

[Java版本切换工具.bat](https://alist.200109.top/d/%E6%9C%AC%E5%9C%B0%E5%AD%98%E5%82%A8/%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F/Java%E7%89%88%E6%9C%AC%E5%88%87%E6%8D%A2%E5%B7%A5%E5%85%B7.bat?sign=G8vFalP0YAD8TOqJGpbBrv7B5UZryZLQYIXTI0VBwHA=:0)

## 自动版本

### 操作步骤

首先在该目录下方下载自动版本的两个文件

**环境变量构建工具**

1. 运行`Java环境变量构建工具.bat`
2. 选择自己安装的Java路径是否为默认路径
3. 选择是否自动构建环境变量
4. 等待构建完成

**版本切换工具**

1. 运行`Java版本切换工具v2.bat`
2. 选择自己安装的Java路径是否为默认路径
3. 输入需要切换的版本名称
4. 完成切换

### 代码

`Java环境变量构建工具.bat`

```bat
@echo off
::获取管理员执行权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
echo ------------------------------------------------
echo ------------------------------------------------
echo 注意：如果Java安装位置是默认位置(C:\Program Files\Java)则本程序放置在任意位置均可，如果你自定义了安装位置，请将本程序放置到安装位置根目录
echo ------------------------------------------------
setlocal EnableDelayedExpansion
set "javaPath=%SYSTEMDRIVE%\Program Files\Java\"

:first
set /P flag=请选择Java安装路径是否为默认路径（Y/n）：
IF "%flag%" EQU "Y" (
	goto second
) ELSE IF "%flag%" EQU "n" (
	set "javaPath="
	goto second
) ELSE (
    echo 输入错误，请重新输入
	goto first
)
echo ------------------------------------------------

:second
set length=0
echo 当前可用Java版本及其路径:
for /d %%a in ("%javaPath%*") do (
	set versionList[!length!]="%%~nxa"
	set pathList[!length!]="%%~dpnxa"
	set /a length+=1
	echo %%~nxa		%%~dpnxa
)
echo ------------------------------------------------

:third
set /P flag=请选择是否需要自动构建环境变量（Y/n）：
IF "%flag%" EQU "Y" (
	goto fouth
) ELSE IF "%flag%" EQU "n" (
	goto pause
) ELSE (
    echo 输入错误，请重新输入
	goto third
)
echo ------------------------------------------------

:fouth
set /a length-=1
for /L %%i in (0,1,%length%) do (
	echo !pathList[%%i]!
	setx "JAVA_HOME_!versionList[%%i]!" !pathList[%%i]! /m
)
setx "JAVA_HOME" "%%JAVA_HOME_!versionList[0]!%%" /m
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" /t REG_EXPAND_SZ /d "%Path%;%%JAVA_HOME%%\bin" /f
setx PATH "%PATH%;%%JAVA_HOME%%\bin;" /m
echo ------------------------------------------------
echo 自动构建环境变量完成
echo ------------------------------------------------
echo ------------------------------------------------

:pause
endlocal 
pause
```

`Java版本切换工具v2.bat`

```bat
@echo off
::获取管理员执行权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
echo ------------------------------------------------
echo ------------------------------------------------
echo 当前Java版本为:
java -version
echo ------------------------------------------------
echo 注意：如果Java安装位置是默认位置(C:\Program Files\Java)则本程序放置在任意位置均可，如果你自定义了安装位置，请将本程序放置到安装位置根目录
echo ------------------------------------------------
setlocal EnableDelayedExpansion
set "javaPath=%SYSTEMDRIVE%\Program Files\Java\"
echo ------------------------------------------------

:first
set /P flag=请选择Java安装路径是否为默认路径（Y/n）：
IF "%flag%" EQU "Y" (
	goto second
) ELSE IF "%flag%" EQU "n" (
	set "javaPath="
	goto second
) ELSE (
    echo 输入错误，请重新输入
	goto first
)
echo ------------------------------------------------

:second
set "versionList="
set length=0
for /d %%a in ("%javaPath%*") do (
	set versionList[!length!]="%%~nxa"
	set /a length+=1
	echo %%~nxa	%%~dpnxa
)
echo ------------------------------------------------

set /a length-=1
:third
for /L %%i in (0,1,%length%) do (
	echo 选项：【%%i】 版本号：!versionList[%%i]!
)
set /P version=请输入需要切换的Java版本（0-%length%）：
IF %version% LEQ %length% (
	setx "JAVA_HOME" "%%JAVA_HOME_!versionList[%version%]!%%" /m
) ELSE (
    echo 输入错误，请重新输入
	echo ------------------------------------------------
	goto third
)

echo ------------------------------------------------
echo 切换版本完成
echo ------------------------------------------------
echo ------------------------------------------------

:pause
endlocal 
pause
```

### 文件下载

[Java环境变量构建工具.bat](https://alist.boliguide.cn/d/%E6%9C%AC%E5%9C%B0%E5%AD%98%E5%82%A8/%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F/Java%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E6%9E%84%E5%BB%BA%E5%B7%A5%E5%85%B7.bat?sign=dzPvJOcZxmSRHIPM6mg4kK5kutQAnZ2OgdLERWYhAMI=:0)

[Java版本切换工具v2.bat](https://alist.boliguide.cn/d/%E6%9C%AC%E5%9C%B0%E5%AD%98%E5%82%A8/%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F/Java%E7%89%88%E6%9C%AC%E5%88%87%E6%8D%A2%E5%B7%A5%E5%85%B7v2.bat?sign=wmRQkHh3YPoRFnyTfhOY0lX3kF7lAiKtOoOvOgOFmKo=:0)
