@echo off
goto comment
1、tip.ps1 ；check_disk.ps1脚本必须与改bat脚本在同一个文件夹下
2、当磁盘超过限定额度才会发送消息，否则不会发送邮件说明
:comment
rem 每一天检查一次
rem  设置参数
set seconds=86400
rem 磁盘容量少于5g开始报警
set disk_cap=1000
rem 设置需要收邮件的邮箱
set emailes="zkzl1991@foxmail.com"



rem   循环体，每隔一天检查一次
:start
rem  检查磁盘脚本
powershell -ExecutionPolicy unrestricted -File check_disk.ps1 -waits 4 -cap_cap  %disk_cap% -emails  %emailes%
rem  提示框
powershell -ExecutionPolicy unrestricted -File tip.ps1 
rem ping -n  %seconds%  localhost > nul   等待30s
rem  等待秒数
timeout  %seconds%      /NOBREAK     
goto start