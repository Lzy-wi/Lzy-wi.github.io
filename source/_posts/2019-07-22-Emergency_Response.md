---
title: 应急响应之linux篇
index_img: /img/2019-07-22/index.jpg
date: 2019-07-22 19:32:50
tags:
- linux
- 应急响应
---

#### 记录一些常用linux应急响应知识
<!--more-->
###### 表现为卡慢-性能资源紧张
```bash
free -m               #以MB为单位查看内存使用情况  
free -l               #查看内存使用细节  
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +4|head #查看内存使用前十名  
vmstat -a             #查看CPU使用详情  
vmstat -d             #查看CPU使用详情  
```
###### 宕机死机
```bash
dmesg -T              #按时间点查看内核日志  
dmesg -T |grep memory #查看和内存相关的日志记录  
dmesg -T |grep cache  #查看和崩溃相关的日志记录  
dmesg -T |grep reboot #查看和重启相关的日志记录  
cat /var/log/syslog   #查看系统日志  
cat /var/log/kern.log #查看内核日志(ubuntu是kern.log，其他是kernel.log)  
```
###### 断网断连排查-表现为网络不通或者间歇性连通
```bash
iptables -L          #查看防火墙  
cat /etc/resolv.conf #查看域名解析  
ifoncifg -a          #查看网卡信息  
```
###### 一些服务的日志位置
```bash
/var/log/httpd/access.log     #http服务日志  
/var/log/vsftp.log            #ftp服务日志  
/var/log/samba                #samba服务日志  
/var/log/message              #DNS、DHCP日志  
```
###### 入侵点入侵特征排查
```bash
netstat -antlop      #查看  
ps -ef               #查看异常连接和对应的文件  
ps aux               #查看那进程详细信息  
lsof -p pid          #查看进程关联账户信息  
  
附录：ps命令常用用法（方便查看系统进程）  
ps a  	#显示现行终端机下的所有程序，包括其他用户的程序。  
ps -A 	#显示所有进程。  
ps c 	#列出程序时，显示每个程序真正的指令名称，而不包含路径，参数或常驻服务的标示。  
ps -e 	#此参数的效果和指定"A"参数相同。  
ps e 	#列出程序时，显示每个程序所使用的环境变量。  
ps f 	#用ASCII字符显示树状结构，表达程序间的相互关系。  
ps -H 	#显示树状结构，表示程序间的相互关系。  
ps -N 	#显示所有的程序，除了执行ps指令终端机下的程序之外。  
ps s 	#采用程序信号的格式显示程序状况。  
ps S 	#列出程序时，包括已中断的子程序资料。  
ps -t<终端机编号> 　#指定终端机编号，并列出属于该终端机的程序的状况。  
ps u 　 #显示所有程序，不以终端机来区分。以用户为主的格式来显示程序状况。  
ps x 　	#显示所有程序，不以终端机来区分。  
```
**最常用的方法是ps -aux,然后再利用一个管道符号导向到grep去查找特定的进程,然后再对特定的进程进行操作**
###### 登陆和爆破排查
```bash
last                        #查看登陆或者重启日志  
lastb                       #查看登录失败日志，或者是cat /var/log/faillog  
who /var/log/wtmp           #查看登录日志，或者last -f /var/run/utmp  
cat /var/log/lastlog        #查看最后的登录日志  
cat /var/log/secure         #查看安全日志  
cat /var/log/cron           #查看计划任务日志  
cat ~/.bash_history | more  #查看历史操作  
grep "Failed password for root" /var/log/auth.log | awk '{print $11}' | sort | uniq -nr | more  #查看root账户登录爆破尝试  
grep "Accepted" /var/log/auth.log | awk '{print $11}' | sort |uniq -c | sort -nr | more #查看登录成功日志信息  
strings /usr/bin/.sshd | egrep '[1-9]{1,3}.[1-9]{1,3}.'   #查看sshd的信息  
```
###### 漏洞利用入侵和后渗透的特征
```bash
#查找webshell:  
find /var/www/ -name "*.php" | xargs egrep 'assert | phpspy | c99sh | milw0rm | eval | \( gunerpress | \(bas464_encode | spider _bc | shell_exec | passthru | \(\$\_\POST\[|eval\(str_rotl3 | .chr\c|\$\{\"\_P|eval\C\$\_R | file_put_contents\C\.\*\$\_ | base64_decode'  
#文件查找的相关命令：  
sudo find / -mtime(atime/ctime) -x   #按照创建、修改时间查找  
sudo find ./ -perm 4777              #按照权限查找文件  
find  ./ -mtime -1 -type f           #按照文件类型查找  
find -mtime -1 -type f -name \*.php  #查找最近一天被修改过的php文件  
```