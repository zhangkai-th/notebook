@echo off
rem ############################################ע����Ϣ#########################
goto comment
version:1.0
1��tip.ps1 ��check_disk.ps1�ű��������bat�ű���ͬһ���ļ�����
2�������̳����޶���ȲŻᷢ����Ϣ�����򲻻ᷢ���ʼ�˵��
3��Ĭ��ʹ�ñ������䷢���ʼ�
:comment
rem ############################################ע����Ϣ##########################

rem ############################################�������ÿ�ʼ#######################
rem ÿһ����һ��
rem  ���ò���
set seconds=86400
rem ������������5g��ʼ����
set disk_cap=5
rem ������Ҫ���ʼ�������,�������֮���á�;������
set emailes="zkzl1991@foxmail.com"
rem ���������smtp�����server
set server="smtp.139.com"
rem ����smtp����Ķ˿�
set port=25
rem ���÷����ʼ�������
set s_emial="18729961833@139.com"
rem �����������Ȩ��
set password="17cb117eb8fc75d4b100"   
rem ############################################�������ý���#######################


rem ##############################################################################################���벿��#########################################
rem   ѭ���壬ÿ��һ����һ��
:start
rem  �����̽ű�
powershell -ExecutionPolicy unrestricted -File check_disk.ps1 -waits 4 -cap_cap  %disk_cap% -emails  %emailes% -smtp_server  %server%  -smtp_port %port%  -smtp_email  %s_email%  -email_password %password%
rem  ��ʾ��
powershell -ExecutionPolicy unrestricted -File tip.ps1 
rem ping -n  %seconds%  localhost > nul   �ȴ�30s
rem  �ȴ�����
timeout  %seconds%      /NOBREAK     
goto start
rem ##############################################################################################���벿��#########################################