#!/usr/bin/env bash

# 设置各变量
NEZHA_SERVER=${NEZHA_SERVER:-"xxxx"}
NEZHA_SERVER="nezha.phenixg.eu.org"
NEZHA_PORT=${NEZHA_PORT:-"xxxx"}
NEZHA_KEY=${NEZHA_KEY:-""}
TLS="1"  # 设置 TLS 变量为 "1" 表示启用 TLS，设置为 "" 表示禁用

generate_nezha() {
  cat > nezha.sh << EOF
#!/usr/bin/env bash

# 哪吒的三个参数
NEZHA_SERVER=${NEZHA_SERVER}
NEZHA_PORT=${NEZHA_PORT}
NEZHA_KEY=${NEZHA_KEY}

# 检测是否已运行
check_run() {
  [[ \$(pidof nezha-agent) ]] && echo "哪吒客户端正在运行中" && exit
}

# 三个变量不全则不安装哪吒客户端
check_variable() {
  [[ -z "\${NEZHA_SERVER}" || -z "\${NEZHA_PORT}" || -z "\${NEZHA_KEY}" ]] && exit
}

# 下载最新版本 Nezha Agent
download_agent() {
  if [ ! -e nezha-agent ]; then
    URL=\$(wget -qO- -4 "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
    wget -t 2 -T 10 -N \${URL}
    unzip -qod ./ nezha-agent_linux_amd64.zip && rm -f nezha-agent_linux_amd64.zip
  fi
}

# 运行客户端
# run() {
#   [ -e nezha-agent ] && chmod +x nezha-agent && ./nezha-agent -s \${NEZHA_SERVER}:\${NEZHA_PORT} -p \${NEZHA_KEY} --tls
# }


run() {
  [ -e nezha-agent ] && chmod +x nezha-agent
  if [ -n "$TLS" ]; then
    ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} --tls
  else
    ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY}
  fi
}

check_run
check_variable
download_agent
run
wait
EOF
}

generate_config
generate_nezha
[ -e nezha.sh ] && bash nezha.sh 2>&1 &
wait
