#!/bin/bash

# 内置版本号
version="1.0.2"
echo -e "当前版本$version，\033[31m\n官网:https://github.com/ZenXSin/server\nqq群:950399874\nby zxs\033[0m"
screen_name="mdt"
dir_name="mdt"

echo "开始配置，将在home新建目录($dir_name)并存放所需文件，如果你看不懂，一路回车即可，ctrl+c终止"
read -p "重复执行可以解决大多数错误，回车继续" enter

if type apt >/dev/null 2>&1; then
  echo "Found apt(ubuntu/debian)"
  pkg="apt"
else
  if type yum >/dev/null 2>&1; then
    echo "Found yum(centos)"
    pkg="yum"
  else
    if type snap >/dev/null 2>&1; then
      echo "Found snap"
      pkg="snap"
    else
      echo "未检测到包管理，终止"
      exit 0
    fi
  fi
fi

if type java >/dev/null 2>&1; then
  echo "Found java"
else
  read -p "未发现java，需要安装吗？[enter/n]:" i_java
  read -p "输入需要的jre版本(建议11或17，默认11):" j_version
  if [ -z "$j_version" ]; then
    j_version="11"
  else
    echo "continue"
  fi
  if [ -z "$i_java" ]; then
    "$pkg" install -y openjdk-"$j_version"-jre || { echo "安装jre时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if type screen >/dev/null 2>&1; then
  echo "Found screen"
else
  read -p "未发现screen，需要安装吗？[enter/n]:" i_screen
  if [ -z "$i_screen" ]; then
    "$pkg" install -y screen || { echo "安装screen时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if type wget >/dev/null 2>&1; then
  echo "Found wget"
else
  read -p "未发现wget，需要安装吗？[enter/n]:" i_wget
  if [ -z "$i_wget" ]; then
    "$pkg" install -y wget || { echo "安装wget时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if [ ! -d "$HOME/$dir_name" ];then
  echo "未检测到文件夹$dir_name，创建并配置"
  mkdir "$HOME/$dir_name"
  if [ -f "$HOME/$dir_name/temp.jar" ];then
    rm "$HOME/$dir_name/temp.jar"
  else
    echo "continue"
  fi
    echo "开始下载server-release.jar"
    wget "https://github.com/Anuken/Mindustry/releases/latest/download/server-release.jar" -O "$HOME/$dir_name/temp.jar" || { echo "下载时出错，请检查输出";exit 1; }
    mv "$HOME/$dir_name/temp.jar" "$HOME/$dir_name/server-release.jar"
    echo "结束"
    exit 0

else
  if [ -f "$HOME/$dir_name/server-release.jar" ];then
    ps -ef | grep "java -jar server-release.jar" | grep -v grep
    if [ "$?" = "0" ]; then
      read -p "似乎一切已就绪，并检测到了正在运行的服务器进程，需要连接窗口吗？(你也可以输入screen -r $dir_name连接)[enter/n]:" c_screen
      if [ -z "$c_screen" ];then
        screen -r "$dir_name"
      else
        echo "结束"
        exit 0
      fi
    else
      read -p "似乎一切已就绪，但是未检测到正在运行的服务器进程，你想启动它吗？[enter/n]:" run_yes
      if [ -z "$run_yes" ];then
        screen -ls | grep "$screen_name" | cut -d. -f1 | awk '{print $1}' | xargs kill
        screen -dmS "$screen_name" -a
        screen -x -S "$screen_name" -p 0 -X stuff "echo -e \"\e[43;35mctrl+a+d可断开连接\e[0m\" && cd $HOME/$dir_name && java -jar server-release.jar\n"
        screen -r "$dir_name"
      else
        echo "结束"
        exit 0
      fi
    fi
  else
    echo "server-release.jar缺失，重新下载"
    if [ -f "$HOME/$dir_name/temp.jar" ];then
      rm "$HOME/$dir_name/temp.jar"
    else
      echo "continue"
    fi
    wget "https://github.com/Anuken/Mindustry/releases/latest/download/server-release.jar" -O "$HOME/$dir_name/temp.jar" || { echo "下载时出错，请检查输出";exit 1; }
    mv "$HOME/$dir_name/temp.jar" "$HOME/$dir_name/server-release.jar"
    echo "结束"
    exit 0
  fi
fi
exit 0

