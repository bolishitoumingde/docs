@echo off
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" /t REG_EXPAND_SZ /d "%Path%;%%JAVA_HOME%%\bin" /f

echo ------------------------------------------------
echo 自动构建环境变量完成
echo ------------------------------------------------
echo ------------------------------------------------

:pause
endlocal 
pause