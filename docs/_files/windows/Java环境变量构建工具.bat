@echo off
echo ------------------------------------------------
echo ------------------------------------------------
echo ע�⣺���Java��װλ����Ĭ��λ��(C:\Program Files\Java)�򱾳������������λ�þ��ɣ�������Զ����˰�װλ�ã��뽫��������õ���װλ�ø�Ŀ¼
echo ------------------------------------------------
setlocal EnableDelayedExpansion
set "javaPath=%SYSTEMDRIVE%\Program Files\Java\"

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
set length=0
echo ��ǰ����Java�汾����·��:
for /d %%a in ("%javaPath%*") do (
	set versionList[!length!]="%%~nxa"
	set pathList[!length!]="%%~dpnxa"
	set /a length+=1
	echo %%~nxa		%%~dpnxa
)
echo ------------------------------------------------

:third
set /P flag=��ѡ���Ƿ���Ҫ�Զ���������������Y/n����
IF "%flag%" EQU "Y" (
	goto fouth
) ELSE IF "%flag%" EQU "n" (
	goto pause
) ELSE (
    echo �����������������
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
echo �Զ����������������
echo ------------------------------------------------
echo ------------------------------------------------

:pause
endlocal 
pause