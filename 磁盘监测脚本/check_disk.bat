@echo off
goto comment
1��tip.ps1 ��check_disk.ps1�ű��������bat�ű���ͬһ���ļ�����
2�������̳����޶���ȲŻᷢ����Ϣ�����򲻻ᷢ���ʼ�˵��
:comment
rem ÿһ����һ��
rem  ���ò���
set seconds=86400
rem ������������5g��ʼ����
set disk_cap=1000
rem ������Ҫ���ʼ�������
set emailes="zkzl1991@foxmail.com"



rem   ѭ���壬ÿ��һ����һ��
:start
rem  �����̽ű�
powershell -ExecutionPolicy unrestricted -File check_disk.ps1 -waits 4 -cap_cap  %disk_cap% -emails  %emailes%
rem  ��ʾ��
powershell -ExecutionPolicy unrestricted -File tip.ps1 
rem ping -n  %seconds%  localhost > nul   �ȴ�30s
rem  �ȴ�����
timeout  %seconds%      /NOBREAK     
goto start