@echo off

echo =========================================

echo          set java envirnment

echo          Thanks：sadwxds

echo          link: http://blog.csdn.net/sadwxds/article/details/52984272

echo =========================================


echo 根据sadwxds的博文精简及修改
echo 使用时将jdk安装包及本脚本放在同一目录
echo.
cd %~dp0

	
	rename *jdk*.exe java.exe

	start java.exe

	
	set /p JavaHome=请输入JDK安装路径:

	echo 你输入的路径是：%JavaHome%

	setx "JAVA_HOME" "%JavaHome%" -M
	
	setx "CLASSPATH" ".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar;"  -M
	
	wmic ENVIRONMENT where "name='path' and username='<system>'" set VariableValue="%%JAVA_HOME%%\bin;%%JAVA_HOME%%\jre\bin;%path%"

	setx path "%path%" 


	del java.exe




pause
	
