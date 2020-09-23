---
title: Web渗透测试中一些信息收集的方法和思路
index_img: /img/2019-01-17/index.jpg
date: 2019-01-17 20:02:20
tags: 
- 信息收集
- Web
- 渗透测试
---
**对敌人不了解，怎么打败敌人**
<!--more-->

### 一、 信息收集：
#### 1.1 真实IP地址
&emsp;&emsp;**如果IP地址不是真实的，测试会出现偏差(如：测试的端口服务全部都是假的)**
&emsp;&emsp;1.1.1 ping命令
&emsp;&emsp;1.1.2 IP138在线查询
&emsp;&emsp;1.1.3 CDN地址探测（隐藏真实IP地址）
&emsp;&emsp;&emsp;&emsp;如：xxx.cdn.XXX....IP地址（这个是CDN地址不是真实IP）
&emsp;&emsp;&emsp;&emsp;绕过CDN小窍门：XSS漏洞、DDOS、邮件订阅...等
#### 1.2 端口服务探测
&emsp;&emsp;**用于暴力破解、系统架构判断**
&emsp;&emsp;1个域名可以解析多个IP地址的端口
&emsp;&emsp;1.2.1 Nmap探测
&emsp;&emsp;1.2.2 Zenmap探测
#### 1.3 HTML前端敏感注释信息
&emsp;&emsp;1.3.1 <\!--看注释信息,**因为有的管理员会把测试账户密码写进去**-->
&emsp;&emsp;1.3.2 前端框架信息，如：Jquery框架
&emsp;&emsp;1.3.3 框架查看攻略
&emsp;&emsp;&emsp;&emsp;1.3.3.1 路径地址（扔百度里）
&emsp;&emsp;&emsp;&emsp;1.3.3.2 JS里面版权信息
&emsp;&emsp;1.3.4 框架信息扔百度里搜索公开漏洞
&emsp;&emsp;&emsp;&emsp;1.3.4.1 DOM XSS跨站脚本攻击漏洞
&emsp;&emsp;&emsp;&emsp;1.3.4.2 ....（其他未知漏洞）
#### 1.4 whois信息收集
&emsp;&emsp;1.4.1 在线收集，如：DNS地址/注册邮箱/时间...等
&emsp;&emsp;&emsp;&emsp;1.4.1.1 拿到邮箱地址可以百度查询公开的密码等信息
&emsp;&emsp;1.4.2 Kali-whois查询
#### 1.5 中间件版本信息
&emsp;&emsp;1.5.1 系统报错的方式
&emsp;&emsp;1.5.2 抓包的方式（如：请求：OPTIONS）
&emsp;&emsp;&emsp;&emsp;1.5.2.1 如果OPTIONS以后开启了PUT方法，可以尝试上传漏洞GETSHELL
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;IIS6.0、Apache存在这个漏洞可能性较大
&emsp;&emsp;1.5.3 漏洞扫描器自带判断功能
&emsp;&emsp;1.5.4 端口服务探测方式自动探测
#### 1.6 系统功能信息
&emsp;&emsp;**只要能交互的，全部都收集（包括功能地址）**
&emsp;&emsp;1.6.1 增删改查功能
&emsp;&emsp;1.6.2 文件上传功能
&emsp;&emsp;1.6.3 功能请求方式和参数
#### 1.7 系统服务端编程语言
&emsp;&emsp;1.7.1 编程语言（JavaWeb、PHP...等）
&emsp;&emsp;&emsp;&emsp;  JSP（特征：HTML前端开头以及部分代码模块后面大量的换行）
&emsp;&emsp;1.7.2 编程框架（如：S2、THinkPHP...等以及相关目录和URL后缀）
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;如：.action、.do
#### 1.8 域名/子域名
&emsp;&emsp;**二级、三级、四级、五级...,通过域名来判断该系统的数量规模**
&emsp;&emsp;1.8.1 子域名挖掘机
&emsp;&emsp;1.8.2 其他工具（....）
#### 1.9 目录/子目录
&emsp;&emsp;**二级、三级、四级、五级...**
&emsp;&emsp;1.9.1 御剑目录扫描器
&emsp;&emsp;1.9.2 Kali-Dirb目录探测
&emsp;&emsp;1.9.3 Kali-Dirbuster（/usr/share/dirbuster下）
&emsp;&emsp;1.9.4 BurpSuite爬虫
#### 1.10 C段/旁注
&emsp;&emsp;1.10.1 旁站在线查询
&emsp;&emsp;1.10.2 C段在线查询
#### 1.11 DNS地址信息收集
&emsp;&emsp;SOA 权威记录
&emsp;&emsp;NS 服务器记录
&emsp;&emsp;A IPv4地址记录
&emsp;&emsp;MX 邮件交换记录
&emsp;&emsp;PTR IP地址反解析
&emsp;&emsp;AAAA IPv6地址记录
&emsp;&emsp;CNAME 别名记录
&emsp;&emsp;1.11.1 Kali-Dig
&emsp;&emsp;1.11.2 Kali-dnsenum
#### 1.12 综合信息收集
&emsp;&emsp;1.12.1 Kali-theharvester(比如：-d baidu.com -l 100 -b bing)
#### 1.13 资产信息收集
&emsp;&emsp;1.13.1 钟馗之眼（在线）
&emsp;&emsp;1.13.2 佛法查询（在线）
#### 1.14 搜索引擎黑客
&emsp;&emsp;1.14.1 百度黑客搜索语法
&emsp;&emsp;1.14.2 谷歌黑客搜索语法
#### 1.15 邮箱信息
&emsp;&emsp;1.15.1 公开的邮箱地址
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;如：@XX.com
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;你可以看到命名规则，还能收集更多的信息
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;留着邮箱地址后期可以暴力破解
&emsp;&emsp;1.15.2 邮箱地址泄露的密码
&emsp;&emsp;1.15.3 邮箱地址泄露的其他信息
#### 1.16 系统公开漏洞
&emsp;&emsp;1.16.1 乌云镜像
&emsp;&emsp;1.16.2 老漏洞复现
&emsp;&emsp;1.16.3 老漏洞暴露的其他信息
#### 1.17 WAF防火墙探测
&emsp;&emsp;1.17.1 报错方式
&emsp;&emsp;1.17.2 漏洞探测（如：敏感字符：% -- " ' @ //等）
&emsp;&emsp;1.17.3 公开漏洞
&emsp;&emsp;1.17.4 扫描探测（如：Nmap）
#### 1.18 其他信息收集
&emsp;&emsp;1.18.1 火狐插件-Wappalyzer
&emsp;&emsp;1.18.2 其他插件....
&emsp;&emsp;1.18.3 APP手机软件破解或抓包
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;破解以后里面有注释信息和其他信息
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;抓包可以看到通讯IP地址，进行二次，三次信息收集和渗透


