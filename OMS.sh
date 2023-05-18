#!/bin/bash

# 内置版本号
version="1.0.2"
echo -e "当前版本$version，\033[31m\n官网:https://github.com/ZenXSin/server\nqq群:950399874\nby zxs\033[0m"

echo "开始配置，如果你看不懂，一路回车即可"
echo "ctrl+c终止"

if type apt >/dev/null 2>&1; then
  echo "检测到apt包管理(ubuntu/debian)"
  pkg="apt"
else
  if type yum >/dev/null 2>&1; then
    echo "检测到yum包管理(centos)"
    pkg="yum"
  else
    if type snap >/dev/null 2>&1; then
      echo "检测到snap包管理"
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
  read -p "未发现java，需要安装吗？(默认jre 11)[y/n]" i_java
  read -p "输入需要的jre版本(建议11或17)" j_version
  if [ "$i_java" = "y" ] && [ -z "$i_java" ]; then
    "$pkg" install -y openjdk-"$j_version"-jre || { echo "安装jre时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if type screen >/dev/null 2>&1; then
  echo "Found screen"
else
  read -p "未发现screen，需要安装吗？[y/n]" i_screen
  if [ "$i_screen" = "y" ] || [ -z "$i_screen" ]; then
    "$pkg" install -y screen || { echo "安装screen时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if type wget >/dev/null 2>&1; then
  echo "Found wget"
else
  read -p "未发现wget，需要安装吗？[y/n]" i_wget
  if [ "$i_wget" = "y" ] && [ -z "$i_wget" ]; then
    "$pkg" install -y wget || { echo "安装wget时出错，请检查输出";exit 1; }
  else
    echo "停止"
    exit 0
  fi
fi

if [ ! -d "$HOME/mdt" ];then
  echo "未检测到文件夹mdt，创建并配置"
  mkdir "$HOME/mdt"
  cd "$HOME/mdt"
  if [ -f "$HOME/mdt/temp.jar" ];then
    rm "$HOME/mdt/temp.jar"
  else
    echo "continue"
  fi
    echo "开始下载server-release.jar"
    wget "https://github.com/Anuken/Mindustry/releases/latest/download/server-release.jar" -O "$HOME/mdt/temp.jar" || { echo "下载时出错，请检查输出";exit 1; }
    echo "结束"
    exit 0

else
  if [ -f "$HOME/mdt/server-release.jar" ];then
    ps -ef | grep "java -jar server-release.jar" | grep -v grep
    if [ "$?" = "0" ]; then
      echo "似乎一切已就绪，并检测到了一个正在运行的服务器进程，请通过screen -r mdt命令连接窗口"
      echo "结束"
      exit 0
    else
      read -p "似乎一切已就绪，但是未检测到正在运行的服务器进程，你想启动它吗？[y/n]" run_yes
      if [ "$run_yes"="y" ] || [ -z "$run_res" ];then
        screen_name="mdt"
        screen -dmS "$screen_name"
        screen -x -S "$screen_name" -p 0 -X stuff "echo -e \"\e[43;35mctrl+a+d可断开连接\e[0m\" && cd $HOME/mdt && java -jar server-release.jar\n"
        screen -r mdt
      else
        echo "结束"
        exit 0
      fi
    fi
  else
    echo "server-release.jar缺失，重新下载"
    if [ -f "$HOME/mdt/temp.jar" ];then
      rm "$HOME/mdt/temp.jar"
    else
      wget "https://github.com/Anuken/Mindustry/releases/latest/download/server-release.jar" -O "$HOME/mdt/temp.jar" || { echo "下载时出错，请检查输出";exit 1; }
      mv "$HOME/mdt/temp.jar" "$HOME/mdt/server-release.jar"
      echo "结束"
      exit 0
    fi
  fi
fi
exit 0

