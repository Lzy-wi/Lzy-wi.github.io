---
title: 网鼎杯writeup（复现）
index_img: /img/2018-08-21/index.jpg
date: 2018-08-21 17:40:30
tags: 
- writeup
- web
- ctf
- misc
---
~~不会ps的不是好ctfer~~
<!--more-->

### misc
#### 0x00 clip
题目是一个旧文件系统里恢复来的disk文件
![3](/img/2018-08-21/3.png)
本以为要用到专门的工具去打开找谷歌百度找了一遍啥也没发现，垃圾软件倒是装了不少，后来队友用010搜索IDAT发现一张有头的和没头的图片
![7](/img/2018-08-21/7.png)
![8](/img/2018-08-21/8.png)
提取出来是这么个鬼样子的
![4](/img/2018-08-21/4.png)
![5](/img/2018-08-21/5.png)
打横切开
![9](/img/2018-08-21/9.png)
重新拼接成下图（我队友做的）
![10](/img/2018-08-21/10.png)
感受到被**ps和脑洞**支配的恐惧了吗
![12](/img/2018-08-21/12.jpg)
#### 0x01 minified
题目是一张图片
![](/img/2018-08-21/flag_enc.png)
StegSolve打开看到red plane0是一片黑色，猜测和0通道有关，分别把red、blue、green和alpha的0通道提取出来
![](/img/2018-08-21/1.png)
用StegSolve的image combiner功能分别对比，在用alpha和green进行XOR对比时可以清楚的看到flag(做出来的人是怎么想到对比0通道的？。)
![2](/img/2018-08-21/2.png)
感受到了被**脑洞**支配的恐惧了吗
![11](/img/2018-08-21/12.jpg)

### web
~~web狗感受到来自世界的恶意，已哭晕在厕所~~
#### 0x00 spider
这道题参考官方给出的writeup-->[传送门](https://mp.weixin.qq.com/s?__biz=MzUzNTkyODI0OA==&mid=2247491146&idx=3&sn=62911c7eede3f3207bd3badb65983d8d&chksm=faff529dcd88db8b00fc09b58bd8d86ebbbd6463cba8d9319718e4ded7046fc60c76475aa943&mpshare=1&scene=23&srcid=0820KKS4SsULFtWOy9z1xffV#rd)
#### 0x01 fakebook
这道题是在比赛结束前1小时时候放出来的题目，一般这种题目都是送~~分题~~送命题
![11](/img/2018-08-21/11.png)
首先拿到题目后发现只能登陆或者join，join的时候发现第四个字段blog似乎只能是网址，一般这种有约束条件又没给出则一定是被隐藏了，查看robots.txt发现果然有东西
![12](/img/2018-08-21/12.png)
约束条件
![13](/img/2018-08-21/13.png)
join之后发现只有username可以点，点进去后发现敏感参数
![14](/img/2018-08-21/14.png)
测试后得到的信息：4个字段，过滤了`union select`，第四个参数进行了序列化
![15](/img/2018-08-21/15.png)
在一段惊天地泣鬼神的注入下然鹅并没有在数据库里发现flag
请教大佬获得hint1：构造类。这样构造出来的类可以执行，php代码如下
```php
<?php
class UserInfo
{
    public $name = "";
    public $age = 0;
    public $blog = "";
}
$a = new UserInfo();
$a->name = '1';
$a->age = 12;
$a->blog = 'baidu.com';
echo serialize($a);
?>
```
![21](/img/2018-08-21/21.png)
![16](/img/2018-08-21/16.png)
源码可以看到读取了文件
![18](/img/2018-08-21/18.png)
请教大佬获得hint2：curl读文件。
源码提示了php调用curl来查询的，联想到curl可以执行读文件操作
![17](/img/2018-08-21/17.png)
把baidu.com改成file:///var/www/html/user.php进行测试发现可以读取user.php的内容验证猜想
![19](/img/2018-08-21/19.png)
读flag，file:///var/www/html/flag.php
![20](/img/2018-08-21/20.png)

