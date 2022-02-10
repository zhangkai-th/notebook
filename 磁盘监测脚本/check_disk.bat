@echo off
rem ############################################注释信息#########################
goto comment
version:1.0
1、tip.ps1 ；check_disk.ps1脚本必须与改bat脚本在同一个文件夹下
2、当磁盘超过限定额度才会发送消息，否则不会发送邮件说明
3、默认使用本人邮箱发送邮件
:comment
rem ############################################注释信息##########################

rem ############################################参数设置开始#######################
rem 每一天检查一次
rem  设置参数
set seconds=86400
rem 磁盘容量少于5g开始报警
set disk_cap=5
rem 设置需要收邮件的邮箱,多个邮箱之间用“;”隔开
set emailes="zkzl1991@foxmail.com"
rem 设置邮箱的smtp服务的server
set server="smtp.139.com"
rem 设置smtp服务的端口
set port=25
rem 设置发送邮件的邮箱
set s_emial="18729961833@139.com"
rem 设置邮箱的授权码
set password="17cb117eb8fc75d4b100"   
rem ############################################参数设置结束#######################


rem ##############################################################################################代码部分#########################################
rem   循环体，每隔一天检查一次
:start
rem  检查磁盘脚本
powershell -ExecutionPolicy unrestricted -File check_disk.ps1 -waits 4 -cap_cap  %disk_cap% -emails  %emailes% -smtp_server  %server%  -smtp_port %port%  -smtp_email  %s_email%  -email_password %password%
rem  提示框
powershell -ExecutionPolicy unrestricted -File tip.ps1 
rem ping -n  %seconds%  localhost > nul   等待30s
rem  等待秒数
timeout  %seconds%      /NOBREAK     
goto start
rem ##############################################################################################代码部分#########################################