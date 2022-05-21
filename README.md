# dyProxy
![img_1.png](img/img_1.png)


## Windows 直接下载运行 <a href="https://github.com/dyminerproxy/dyproxy/releases">Release</a></br>

---

## Liunx一键管理工具 包含安装/启动/停止/更新/删除

```bash
# 可直连github的服务器
bash <(curl -s -L https://raw.githubusercontent.com/dyminerproxy/dyproxy/master/scripts/tools.sh)
```

### 查看运行情况
```bash
screen -r dyProxy
```
### 退出查看运行情况 键盘键入
```
ctrl + a + d
```

---
## Linux手动安装
```bash
mkdir dy_proxy
cd dy_proxy

# x86服务器
wget https://raw.githubusercontent.com/dyminerproxy/dyproxy/master/release/v1.1.2/dyProxy_linux64
chmod 777 dyProxy_linux64
./dyProxy_linux64

```

### 后台运行（注意后面的&）运行完再敲几下回车

```bash
nohup ./dyProxy_linux64 &
# 运行之后查看web账号密码
tail -f nohup.out
```

### 后台运行时关闭

```bash
killall minerProxy
```
### 后台运行时查看
```bash
tail -f nohup.out
```
## 重要说明

```bash
开发者费用
本软件如果您开启了抽水则为 0.3% 的开发者费用,
如果您不开启抽水,则没有开发者费用,可以自行抓包查看


```

<a href="https://jq.qq.com/?_wv=1027&k=ZEjK6SjD">QQ交流群  大爷中转（点击加入）</a></br>

![img_2.png](img/img_2.png)


