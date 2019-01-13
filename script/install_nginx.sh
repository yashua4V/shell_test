#!/bin/bash
echo "安装nginx服务"
echo "......"
echo "......"
echo "......"
echo "创建nginx用户"
useradd -s /sbin/nologin nginx &> /dev/null
id nginx
if [ $? -eq 0 ];then
	echo "创建成功"
else
	echo "创建失败"
	exit
fi
sleep 2
echo "安装依赖中，请稍后......"
num=`yum repolist | sed -n 's/^repolist: //p' | sed -nr 's/,//p'`
if [ $num -gt 0 ];then
	echo "yum源可用数为${num}个"
else
	echo "yum源不可用，请配好yum源再使用此脚本"
	exit
fi
sleep 2
yum -y install wget gcc pcre-devel openssl-devel zlib-devel  &> /dev/null
if [ $? -eq 0 ];then
	echo "依赖安装成功！！！"
else
	echo "依赖安装失败！！！"
fi
mkdir /tmp/soft
cd /tmp/soft
wget http://nginx.org/download/nginx-1.14.2.tar.gz &>/dev/null
if [ -e nginx-1.14.2.tar.gz ];then
	echo "nginx下载成功！！！"
else
	echo "nginx下载失败！！！请检查网络！！！" && exit
fi
tar xf nginx-1.14.2.tar.gz
cd nginx-1.14.2
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module &>/dev/null
make &>/dev/null
make install &> /dev/null
rm -rf /usr/local/nginx/conf/nginx.conf
cp /tmp/work/shell_test/conf/nginx.conf  /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx 

if [ -f /usr/local/nginx/sbin/nginx ];then
	echo "恭喜！！！安装nginx成功"
else
	echo "抱歉！！！安装nginx失败，请退出检查环境等其它原因"  && exit
fi
rm -rf /tmp/soft/nginx*
echo "......"
echo "......"
echo "......"
echo "安装此nginx只适用做调度器，请修改nginx.conf里面的serverIP！！！"