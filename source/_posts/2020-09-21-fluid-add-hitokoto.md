---
title: fluid主题博客主页添加一言(hitokoto)手把手教学
index_img: /img/2020-09-21/6.png
date: 2020-09-21 20:06:07
tags: 
- hitokoto
- fluid
- hexo
---

### 前言
所以说爱恨真是奇怪的东西，有的早早腐烂入土，有的刻骨。 ——「全球高考」
<!--more-->

#### 启发
不知不觉博客换了yilia、next、fluid三个主题了，三个主题都用了挺长时间。偶然间看到别人发的博客主页有句很好看的句子，自己也想搞一个来于是就动手搞一搞……
![1](/img/2020-09-21/1.png)
对于我这种主页不知道哔哔什么废话的再适合不过了。然鹅那个博客刷新的时候并没有发起特殊的请求，不过还好后来在同事的博客找到获取一句话的网络请求~~，后来发现这个叫一言而且很多博客也有在用，孤陋寡闻了[捂脸]~~
![2](/img/2020-09-21/2.png)
首先fluid_config.yml中首页的一句话是在index下的slogan中的text设置，顺便添加`hitokoto`参数，方便开启和关闭一言。
```yaml
index:
  banner_img: /img/default.jpg  # 首页 Banner 头图，以下相同
  banner_img_height: 100  # 头图高度，屏幕百分比，available: 0 - 100
  banner_mask_alpha: 0.3  # 头图黑色蒙版的透明度，available: 0 - 1.0， 0 是完全透明（无蒙版），1 是完全不透明
  post_default_img: '' # 默认的文章封面图，当没有指定 index_img 时会使用该图片，若都为空则不显示任何图片
  slogan:  # 首页副标题的独立设置
    enable: true  # 为 false 则不显示任何内容
    text: ''
  hitokoto:
    enable: true # 开启hitokoto优先显示hitokoto
  auto_excerpt:
    enable: true
  post_url_target: _self  # available: _blank | _self
  post_meta: # 是否显示文章信息（时间、分类、标签）
    date: true
    category: true
    tag: true
...
```
`text`参数会传到`fluid/layout/index.ejs`
![3](/img/2020-09-21/3.png)
最开始是想在这里更改为一言的一句话，在最上面可以通过插入`<script>`标签,然后使用ajax执行Get请求就可以获得一言的句子，但是此方法获取到的值只能在`<script>`内使用，不能赋值到ejs中~~我也不会也没查到~~**遂卒**
后来百度查到`hitokoto`有官方调用的文档-->[传送门](https://hitokoto.cn/)
也查到一个fluid主题添加一言的教程给了很多帮助-->[传送门](https://pxxyyz.com/posts/30454/)，~~然而那个人的博客主页并没有设置成功/doge~~，还有这篇-->[传送门](https://blog.bill.moe/add-hitokoto/)
根据博客里讲的，修改的地方位于`layout\_partial\plugins\typed.ejs`，仔细想想也没错，修改`index.ejs`可以直接显示一言不用管其他文件但是实现起来有点困难，`typed.ejs`是打字机的js控制程序，通过修改`typed.ejs`实现index页面打印一言，其余页面该打印什么打印什么，只要加个if条件判断是index页面还是其他页面。
#### 修改typed.ejs

首先原始的`typed.ejs`主要分为2部分，第一部分是打字机调用程序，第二部分是接口
![4](/img/2020-09-21/4.png)
首先把打字机调用程序改成`function`形式，通过调用`typing`函数来输出，需要传入的参数有id和hitokoto(subtitle)，在原始的`typed.ejs`中通过`<%- data.subtitle %>`形式来传参，改成函数的时候要改为`hitokoto`，同时在`typed.ejs`中的`#subtitle`是输出点
```
var typed = new Typed('#subtitle', {
```
对应到layout.ejs中的如下位置，通过id来确定输出点~~后来发现改了<%- hitokoto %>这个也可以，装死~~
![5](/img/2020-09-21/5.png)
如果控制台出现如下异常则是因为`typed.ejs`中#后面的参数和`layout.ejs`的输出点的id不一样导致打字机找不到输出点报的异常。
```
TypeError: Cannot read property 'tagName' of null
```
因为我的目标只需要修改index页面的打字机而其他页面还是原来的样子，一旦修改了`#subtitle`就会触发报错，当然也可以不修改，因为我一开始没搞懂就改了，就懒得改回去了。封装好typing函数之后`typing("subtitle", "<%- data.subtitle %>")`就可以调用，达到原来的样子根据参考的博客教程添加`<% if(is_post()) { %>`条件可以过让文章打印原始的subtitle，也就是对应着文章的标题，但是还不行，在其他归档、标签、关于等页面还是会显示一言。打开`about.ejs`和`page.ejs`对比会发现固定页面`page.layout`则是背设为固定，`page.ejs`则不是
```
//about.ejs
page.layout = "about"

//page.ejs
var layout = page.layout
```
因此用`&& page.layout!=='about' && page.layout!=='links' && page.layout!=='archive' && page.layout!=='tags'`可以排除掉不想展示的页面。(如果你想要所有页面设为一言就去掉即可)。按照博客教程是只显示一句话，没有出处。对于引用别人的东西我喜欢加上出处
```
data.hitokoto + '<br><br><span class="from" id="from">' + ' ——「' +data.from + '」</span>'
```
关于出处一开始是用两个函数调用去输出然后发现很乱，一个句子和出处一起输出又不知道怎么实现出处右对齐~~学艺不精,等等我本来就不是专精这个的→\_→。~~于是就通过一些css调整使形式相对更美观一些。
修改后的`type.ejs`如下

```

<% if(theme.fun_features.typing.enable && page.subtitle !== false){ %>
  <%- js_ex(theme.static_prefix.typed, "/typed.min.js") %>
  <script>
    function typing(id, hitokoto){
      var typed = new Typed('#' + id, {
        strings: [
          '  ',
          hitokoto + "&nbsp;",
        ],
        cursorChar: "<%- theme.fun_features.typing.cursorChar %>",
        typeSpeed: <%- theme.fun_features.typing.typeSpeed %>,
        loop: <%- theme.fun_features.typing.loop %>,
      });
      typed.stop();
      $(document).ready(function () {
        $(".typed-cursor").addClass("h2");
        typed.start();
      });
    };
      
  <% if(is_post()) { %>
    typing("subtitle", "<%- data.subtitle %>")
  <% } else if(theme.index.hitokoto.enable && page.layout!=='about' && page.layout!=='links' && page.layout!=='archive' && page.layout!=='tags') { %>
    fetch('https://v1.hitokoto.cn')
    .then(response => response.json())
    .then(data => {
       typing("hitokoto", (data.hitokoto + '<br><br><span class="from" id="from">' + ' ——「' +data.from + '」</span>'))
    })
    .catch(console.error)
    <% } else if(page.layout!== '' ) { %>
        typing("subtitle", "<%- data.subtitle %>")
    <% } %>
  </script>
<% } %>
```
#### 修改layout.ejs
`layout.ejs`则和博客教程的那样即可
```
            <span class="h2" id="subtitle">
              <% if(theme.fun_features.typing.enable == false) { %>
                <%- subtitle %>
              <% } %>
            </span>

            <% if(!is_post()) { %>
            <br>
            <span class="h2" id="subtitle">
              <% if(theme.fun_features.typing.enable == false) { %>
                <%- hitokoto %>
              <% } %>
            </span>
            <% } %>

            <% if(is_post() && page.meta !== false) { %>
              <%- partial('_partial/post-meta') %>
            <% } %>
          </div>
```
成品如下，还有在博客下方评论框实现的。~~为什么刷不到那句话。~~
![6](/img/2020-09-21/6.png)


