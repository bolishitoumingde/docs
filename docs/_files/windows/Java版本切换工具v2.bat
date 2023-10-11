@echo off
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
for /d %%a in ("%javaPath%*") do (
	echo %%~nxa	%%~pnxa
)
echo ------------------------------------------------

:third
set /P versionName=请输入需要切换的Java版本名称：
setx "JAVA_HOME" "%%JAVA_HOME_%versionName%%%" /m

echo ------------------------------------------------
echo 切换版本完成
echo ------------------------------------------------
echo ------------------------------------------------

:pause
pause
