@echo off

echo =========================================

echo          set java envirnment

echo          Thanks��sadwxds

echo          link: http://blog.csdn.net/sadwxds/article/details/52984272

echo =========================================


echo ����sadwxds�Ĳ��ľ����޸�
echo ʹ��ʱ��jdk��װ�������ű�����ͬһĿ¼
echo.
cd %~dp0

	
	rename *jdk*.exe java.exe

	start java.exe

	
	set /p JavaHome=������JDK��װ·��:

	echo �������·���ǣ�%JavaHome%

	setx "JAVA_HOME" "%JavaHome%" -M
	
	setx "CLASSPATH" ".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar;"  -M
	
	wmic ENVIRONMENT where "name='path' and username='<system>'" set VariableValue="%%JAVA_HOME%%\bin;%%JAVA_HOME%%\jre\bin;%path%"

	setx path "%path%" 


	del java.exe




pause
	
