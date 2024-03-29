#!/bin/sh

APP_DIR_PATH=$(cd $(dirname $0); pwd)
LOG_DIR_PATH="$APP_DIR_PATH/logs"
LOG_FILE_PATH="$LOG_DIR_PATH/console.log"
PY_FILE_PATH="$APP_DIR_PATH/ChuanhuChatbot.py"

if [ ! -d "$LOG_DIR_PATH" ]; then
     mkdir -p $LOG_DIR_PATH
fi

#检查程序是否在运行
is_exist(){
  pid=`ps -ef|grep $PY_FILE_PATH|grep -v grep|awk '{print $2}' `
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}

#启动方法
start(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${PY_FILE_PATH} is already running. pid=${pid}."
  else
    export PYTHONPATH=$APP_DIR_PATH #设置Python的运行目录
    nohup python3 $PY_FILE_PATH > $LOG_FILE_PATH 2>&1 &
    status
  fi
}

#停止方法
stop(){
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $pid
    echo "${PY_FILE_PATH} is stopped."
  else
    echo "${PY_FILE_PATH} is not running."
  fi
}

#输出运行状态
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${PY_FILE_PATH} is running. pid is ${pid}."
  else
    echo "${PY_FILE_PATH} is not running."
  fi
}

#重启
restart(){
  stop
  start
}

#使用说明，用来提示输入参数
usage() {
    echo "Usage: sh 执行脚本.sh [start|stop|restart|status]"
    exit 1
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac