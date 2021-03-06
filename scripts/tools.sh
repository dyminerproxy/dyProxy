#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

install() {
    if [ -d "/etc/dy_Proxy" ]; then
        echo -e "您已安装了该软件,如果确定没有安装,请输入rm -rf /etc/dy_Proxy" && exit 1
    fi
    if screen -list | grep -q "dyProxy_linux64"; then
        echo -e "检测到您已启动了dyProxy_linux64,请关闭后再安装" && exit 1
    fi

    $cmd update -y
    $cmd install curl wget screen -y
    mkdir /etc/dy_Proxy

    echo "请选择版本"
    echo "  1、v1.1.2"
    read -p "$(echo -e "请输入[1]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/dyminerproxy/dyProxy/master/release/v1.1.2/dyProxy_linux64 -O /etc/dy_Proxy/dyProxy_linux64
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /etc/dy_Proxy/dyProxy_linux64

    wget https://raw.githubusercontent.com/dyminerproxy/dyProxy/master/scripts/run.sh -O /etc/dy_Proxy/run.sh
    chmod 777 /etc/dy_Proxy/run.sh

    echo "如果没有报错则安装成功!"
    echo "正在启动..."
    screen -dmS dyProxy_linux64
    sleep 0.2s
    screen -r dyProxy_linux64 -p 0 -X stuff "cd /etc/dy_Proxy"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'
    screen -r dyProxy_linux64 -p 0 -X stuff "./run.sh"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'
    sleep 1s
    cat /etc/dy_Proxy/config.yml
    echo "请输入 cat /etc/dy_Proxy/config.yml 查看您的端口号与账号密码"
    echo "已启动web后台 您可运行 screen -r dyProxy_linux64 查看程序输出"
}

uninstall() {
    read -p "是否确认删除dyProxy_linux64[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            screen -X -S dyProxy_linux64 quit
            rm -rf /etc/dy_Proxy
            echo "卸载dyProxy_linux64成功"
        fi
    fi
}

update() {
    if screen -list | grep -q "dyProxy_linux64"; then
        screen -X -S dyProxy_linux64 quit
    fi
    rm -rf /etc/dy_Proxy/dyProxy_linux64
    echo "请选择版本"
    echo "  1、v1.1.2"
    read -p "$(echo -e "请输入[1]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/dyminerproxy/dyProxy/master/release/v1.1.2/dyProxy_linux64 -O /etc/dy_Proxy/dyProxy_linux64
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /etc/dy_Proxy/dyProxy_linux64


    screen -dmS dyProxy_linux64
    sleep 0.2s
    screen -r dyProxy_linux64 -p 0 -X stuff "cd /etc/dy_Proxy"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'
    screen -r dyProxy_linux64 -p 0 -X stuff "./run.sh"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'

    sleep 1s
    cat /etc/dy_Proxy/config.yml
    echo "请输入 cat /etc/dy_Proxy/config.yml 查看您的端口号与账号密码"
    echo "您可运行 screen -r dyProxy_linux64 查看程序输出"
}

start() {
    if screen -list | grep -q "dyProxy_linux64"; then
        echo -e "dyProxy_linux64已启动,请勿重复启动" && exit 1
    fi
    screen -dmS dyProxy_linux64
    sleep 0.2s
    screen -r dyProxy_linux64 -p 0 -X stuff "cd /etc/dy_Proxy"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'
    screen -r dyProxy_linux64 -p 0 -X stuff "./run.sh"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'

    echo "dyProxy_linux64已启动"
    echo "您可以使用指令screen -r dyProxy_linux64查看程序输出"
}

restart() {
    if screen -list | grep -q "dyProxy_linux64"; then
        screen -X -S dyProxy_linux64 quit
    fi
    screen -dmS dyProxy_linux64
    sleep 0.2s
    screen -r dyProxy_linux64 -p 0 -X stuff "cd /etc/dy_Proxy"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'
    screen -r dyProxy_linux64 -p 0 -X stuff "./run.sh"
    screen -r dyProxy_linux64 -p 0 -X stuff $'\n'

    echo "dyProxy_linux64 重新启动成功"
    echo "您可运行 screen -r dyProxy_linux64 查看程序输出"
}

stop() {
    if screen -list | grep -q "dyProxy_linux64"; then
        screen -X -S dyProxy_linux64 quit
    fi
    echo "dyProxy_linux64 已停止"
}

change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "连接数限制已修改为102400,重启服务器后生效"
    else
        echo -n "当前连接数限制："
        ulimit -n
    fi
}

uninstall_tx_mon() {
    /usr/local/qcloud/YunJing/uninst.sh
    /usr/local/qcloud/stargate/admin/uninstall.sh
    /usr/local/qcloud/monitor/barad/admin/uninstall.sh
    systemctl stop tat_agent
    systemctl disable tat_agent
    rm -rf /etc/systemd/system/tat_agent.service
    rm -rf /etc/systemd/system/cloud-init.target.wants
    rm -rf /usr/local/qcloud/
    rm -rf /usr/local/yd.socket.server
    echo -n "腾讯云监控卸载成功！"
}

check_limit(){
    echo -n "当前连接数限制："
    ulimit -n
}

echo "======================================================="
echo "dyminerproxy的dyProxy_linux64 一键工具"
echo "  1、安装(默认安装到/etc/dy_Proxy)"
echo "  2、卸载"
echo "  3、更新"
echo "  4、启动"
echo "  5、重启"
echo "  6、停止"
echo "  7、解除linux系统连接数限制(需要重启服务器生效)"
echo "  8、查看当前系统连接数限制"
echo "  9、卸载腾讯云监控"
echo "======================================================="
read -p "$(echo -e "请选择[1-9]：")" choose
case $choose in
1)
    install
    ;;
2)
    uninstall
    ;;
3)
    update
    ;;
4)
    start
    ;;
5)
    restart
    ;;
6)
    stop
    ;;
7)
    change_limit
    ;;
8)
    check_limit
    ;;
9)
    uninstall_tx_mon
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac
