@echo off
@echo ------------------------------------------------
@echo ��ǰJava�汾Ϊ:
java -version
@echo ------------------------------------------------
@echo ����Ҫʹ�õ�java�汾��Ӧ��ѡ��:
@echo ѡ��     ����
@echo 202      �л�����ΪJDK8_202
@echo 291      �л�����ΪJDK8_291
@echo 17       �л�����ΪJDK17
@echo ------------------------------------------------
set /P choose=������ѡ��:
IF "%choose%" EQU "202" (
    REM �޸�JAVA_HOME��������Ϊ%JAVA_HOME_202%,
    setx "JAVA_HOME" "%%JAVA_HOME_202%%" /m
    echo �Ѿ��޸� "JAVA_HOME" Ϊ %%JAVA_HOME_202%%
) ELSE IF "%choose%" EQU "291" (
    setx "JAVA_HOME" "%%JAVA_HOME_291%%" /m
    echo �Ѿ��޸� "JAVA_HOME" Ϊ %%JAVA_HOME_291%%
) ELSE IF "%choose%" EQU "17" (
    setx "JAVA_HOME" "%%JAVA_HOME_17%%" /m
    echo �Ѿ��޸� "JAVA_HOME" Ϊ %%JAVA_HOME_17%%
)
pause