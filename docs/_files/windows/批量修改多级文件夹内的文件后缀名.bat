@echo off
:before
@set /p before=�������޸�ǰ���ļ���׺������jpeg����
if "%before%"=="" (
	@echo ���벻��Ϊ��
	@goto before
)
:after
@set /p after=�������޸ĺ���ļ���׺������jpg����
if "%after%"=="" (
	@echo ���벻��Ϊ��
	@goto after
)
@set before=*.%before%
@set after=*.%after%
@set /p confirm=ȷ���޸�%before%Ϊ%after%�𣿣�ȷ����س�������
if "%confirm%"=="" (
	@echo ==========�޸��ļ�����==========
	@echo on
	@for /r %%i in (%before%) do ren %%i %after%
	@echo off
	@echo.
	@echo ===========�޸ĳɹ�===========
) else (
	@echo ��ȡ����
)
pause
