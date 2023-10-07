#!/usr/bin/env bash

# 设置各变量
NEZHA_SERVER=${NEZHA_SERVER:-"xxxx"}
NEZHA_PORT=${NEZHA_PORT:-"xxxx"}
NEZHA_KEY=${NEZHA_KEY:-""}
TLS="1"  # 设置 TLS 变量为 "1" 表示启用 TLS，设置为 "" 表示禁用

# 检测是否已运行
check_run() {
  [[ $(pidof nezha-agent) ]] && echo "哪吒客户端正在运行中" && exit
}

run() {
  [ -e nezha-agent ] && chmod +x nezha-agent
  if [ -n "$TLS" ]; then
    ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} --tls
  else
    ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY}
  fi
}

check_run
run

