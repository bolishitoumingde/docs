@echo off
echo ------------------------------------------------
echo ------------------------------------------------
echo ��ǰJava�汾Ϊ:
java -version
echo ------------------------------------------------
echo ע�⣺���Java��װλ����Ĭ��λ��(C:\Program Files\Java)�򱾳������������λ�þ��ɣ�������Զ����˰�װλ�ã��뽫��������õ���װλ�ø�Ŀ¼
echo ------------------------------------------------
setlocal EnableDelayedExpansion
set "javaPath=%SYSTEMDRIVE%\Program Files\Java\"
echo ------------------------------------------------

:first
set /P flag=��ѡ��Java��װ·���Ƿ�ΪĬ��·����Y/n����
IF "%flag%" EQU "Y" (
	goto second
) ELSE IF "%flag%" EQU "n" (
	set "javaPath="
	goto second
) ELSE (
    echo �����������������
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
set /P versionName=��������Ҫ�л���Java�汾���ƣ�
setx "JAVA_HOME" "%%JAVA_HOME_%versionName%%%" /m

echo ------------------------------------------------
echo �л��汾���
echo ------------------------------------------------
echo ------------------------------------------------

:pause
pause
