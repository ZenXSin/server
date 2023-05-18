#!/bin/bash

# 内置版本号
version="1.0.2"

echo -e "当前版本$version，\033[31m\n官网:https://github.com/ZenXSin/server\nqq群:950399874\nby zxs\033[0m"

echo "你好，请确认你目前已经使用screen创建了一个新的会话，并且当前目录是你要开服的服务器目录。"
select option in "是的，继续安装" "我没有screen，选我安装" "我不是在我的服务器目录，点我退出" "其他原因，退出"
do
case $option in
"是的，继续安装")
break
;;
"我没有screen，选我安装")
sudo apt-get install -y screen || { echo -e "\033[31m请检查是否安装apt-get，然后重新运行本程序。\033[0m"; exit 1; }
break
;;
"我不是在我的服务器目录，点我退出")
exit 1
break
;;
"检查更新")
echo "正在下载最新版本..."
wget --progress=bar:force https://download.fastgit.org/ZenXSin/server/releases/download/mindustry/OMS.sh -O OMS.sh
echo -e "下载完成，当前版本$version。\033[31m\n官网:https://github.com/ZenXSin/server\nqq群:950399874\nby zxs\033[0m"
exit 1
;;
*)
echo "无效选项"
;;
esac
done
read -p "是否安装Java8或以上版本？(y/n) " java_option
if [ "$java_option" = "y" ]; then
echo "开始安装Java8"
sudo apt-get install -y openjdk-8-jdk || { echo -e "\033[31m安装Java失败\033[0m"; exit 1; }
fi
echo "正在下载server.zip"
wget --progress=bar:force https://download.fastgit.org/ZenXSin/server/releases/download/mindustry/server.sh || { echo -e "\033[31m下载失败\033[0m"; exit 1; }
echo "正在解压server.zip"
unzip -q server.zip || { echo -e "\033[31m解压失败\033[0m"; exit 1; }
echo "配置成功，执行指令:java -jar host.jar 开启服务器。"
exit 0