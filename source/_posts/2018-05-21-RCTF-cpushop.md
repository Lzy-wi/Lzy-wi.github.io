---
title: RCTF密码题cpushop解题过程
index_img: /img/2018-05-22/index.jpg
date: 2018-05-21 18:23:21
tags: 
- writeup
- crypto
- RCTF
---
### 哈希长度拓展攻击学习
参考资料：[哈希长度扩展攻击的简介以及HashPump安装使用方法](哈希长度扩展攻击的简介以及HashPump安装使用方法)
<!--more-->
#### 关于哈希长度拓展
&emsp;&emsp;一开始我也是没有想法~~甚至打算爆破的~~，后来在师姐的指引下看了谋篇博客（见参考资料），就和师姐一起做出来了，写篇博客记录下。题目文件已上传到百度云,链接: [https://pan.baidu.com/s/13d0Re1b_IIez-11dowmvtQ](https://pan.baidu.com/s/13d0Re1b_IIez-11dowmvtQ) 密码: f1t2
##### 大概解题思路
&emsp;&emsp;解释一下题目，linux下`nc cpushop.2018.teamrois.cn 43000`有四个选项，列出菜单，下订单，支付，退出，flag也在菜单里面，然后就是不择手段买到flag
&emsp;&emsp;但是我们的钱是`money = random.randint(1000, 10000)`这么来的flag价格是99999，也就是说正常方法我们是无论如何也买不到flag的,然而它检查price的方法用了for循环。。。
```python
    for k,v in parse_qsl(payment):
        if k == 'product':
            product = v
        elif k == 'price':
            try:
                price = int(v)
            except ValueError:
                print 'Invalid Order!'
                return
```
简而言之就是它会一直检查订单里的价格，比方说，你的订单是长介样子的`product=xxx&price=99999&price=1`上面代码出来的最终结果是price=1
signkey是一个8到32位的str
```python
signkey = ''.join([random.choice(string.letters+string.digits) for _ in xrange(random.randint(8,32))])
```
order的格式
```python
def order():
    n = input_int('Product ID: ')
    if n < 0 or n >= len(items):
        print 'Invalid ID!'
        return
    payment = 'product=%s&price=%d&timestamp=%d' % (items[n][0], items[n][1], time.time()*1000000)
    sign = sha256(signkey+payment).hexdigest()
    payment += '&sign=%s' % sign
    print 'Your order:\n%s\n' % payment
```
##### 长度拓展攻击
假设
密文A：xxxxx
明文B：ABCD
&emsp;&emsp;你知道(`密文A+明文B`)的哈希值和B，因为A我们不知道，爆破会比较困难，通过哈希长度拓展攻击可以修改B的内容
假设我们的带的订单内容如下
```
product=Flag&price=99999&timestamp=1526903707553295&sign=9226bf4f86d5b02042281d87b1b104048c2da41f395350b6f68b05c5addc6fe4
```
那么
明文B：`product=Flag&price=99999&timestamp=1526903707553295`
sha256(密文A+明文B)：`9226bf4f86d5b02042281d87b1b104048c2da41f395350b6f68b05c5addc6fe4
`
如果我们可以把订单的明文添加一个&price=1进去，那么pay的过程它经过for循环后最终价格会变化才能1，那么我们的目的就达到了
最终的一键代码如下，需要安装两个库文件
```
pip install pwntools
pip install hashpumpy
```
```python
from pwn import *
from hashpumpy import hashpump
import time
nc = remote("cpushop.2018.teamrois.cn",43000)
txt = nc.recvuntil('Command:')
print txt
nc.send('2')
print nc.recvuntil('ID:')
nc.send('9')
code = nc.recvuntil('Command:')
print code
flag = code[13:134]
hexdata = flag[57:]
original = flag[0:51]
add = '&price=1'
dic = []
print original
for i in range(8,33):
    a,b = hashpump(hexdata,original,add,i)
    order = b + '&sign=' + a
    nc.send('3')
    print nc.recvuntil('order:')
    print i
    print order
    nc.send(order)
    print nc.recvuntil('Command:')
nc.interactive()
```
tip:`hexdata`是A+B的哈希，`original`是B，`add`是要加的内容，`i`是A的长度。
**爆破A很困难，爆破A的长度就很简单了**
最后构造出来的订单式长这样子
```
product=Flag&price=99999&timestamp=1526818398651000\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x88&price=1&sign=b842b4baa0d4405697b740a871ae60dd64617cdfa1846132373e1b3a371c0db3
```
