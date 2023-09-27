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