#!/bin/bash
echo -e "[\033[33m+\033[0m]clean old file"
hexo cl 
echo -e "[\033[36m+\033[0m]generate new file"
hexo g  
echo -e "[\033[34m+\033[0m]compress"
gulp 
echo -e "[\033[32m+\033[0m]deploy"
hexo d
mv /root/Desktop/Blog.zip /root/Desktop/Blog.zip.bak
echo -e "[\033[35m+\033[0m]backup"
zip -q -r /root/Desktop/Blog.zip ./*
echo -e "[\033[31m+\033[0m]delete old backup"
rm -rf /root/Desktop/Blog.zip.bak
echo -e "[\033[30m+\033[0m]finish"