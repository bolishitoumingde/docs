@echo off
:before
@set /p before=请输入修改前的文件后缀（例如jpeg）：
if "%before%"=="" (
	@echo 输入不可为空
	@goto before
)
:after
@set /p after=请输入修改后的文件后缀（例如jpg）：
if "%after%"=="" (
	@echo 输入不可为空
	@goto after
)
@set before=*.%before%
@set after=*.%after%
@set /p confirm=确认修改%before%为%after%吗？（确认请回车！）：
if "%confirm%"=="" (
	@echo ==========修改文件如下==========
	@echo on
	@for /r %%i in (%before%) do ren %%i %after%
	@echo off
	@echo.
	@echo ===========修改成功===========
) else (
	@echo 你取消了
)
pause
