## acme配置泛域名证书

[【acme.sh中文wiki】](https://github.com/acmesh-official/acme.sh/wiki/%E8%AF%B4%E6%98%8E)

### 说明

**acme.sh** 实现了 `acme` 协议, 可以从 letsencrypt 生成免费的证书.

主要步骤:

1. 安装 **acme.sh**
2. 生成证书
3. copy 证书到 nginx/apache 或者其他服务
4. 更新证书
5. 更新 **acme.sh**
6. 出错怎么办, 如何调试

下面详细介绍.

### 安装&使用

1. **安装acme.sh**

   安装很简单, 一个命令：

   ```shell
   curl https://get.acme.sh | sh -s email=my@example.com
   ```

   普通用户和 root 用户都可以安装使用. 安装过程进行了以下几步:

   1. 把 **acme.sh** 安装到你的 **home** 目录下:

   ```shell
   ~/.acme.sh/
   ```

   并创建 一个 shell 的 alias, 例如 .bashrc，方便你的使用: `alias acme.sh=~/.acme.sh/acme.sh`

   2. 自动为你创建 cronjob, 每天 0:00 点自动检测所有的证书, 如果快过期了, 需要更新, 则会自动更新证书.

   更高级的安装选项请参考: https://github.com/Neilpang/acme.sh/wiki/How-to-install

   **安装过程不会污染已有的系统任何功能和文件**, 所有的修改都限制在安装目录中: `~/.acme.sh/`

   3. 安装 **acme** 完成后使用`acme.sh -v`命令查看版本号：

   ```shell
   acme.sh -v
   ```

   4. 设置为自动更新（可选）：

   ```shell
   acme.sh --upgrade --auto-upgrade
   ```

2. **生成证书**

   **acme.sh** 实现了 **acme** 协议支持的所有验证协议. 一般有两种方式验证: **http** 和 **DNS** 验证.

   具体过程参考[【acme.sh中文wiki】](https://github.com/acmesh-official/acme.sh/wiki/%E8%AF%B4%E6%98%8E)

   这里我们介绍通过 **DNS** 配置泛域名证书：

   1. **acme3.x **默认使用 **ZeroSSL** 作为服务提供商，首先申请 **ZeroSSL** 关联账户，执行以下命令，修改邮箱，未注册帐户会自动进行注册。

   ```shell
   acme.sh --register-account -m my@example.com --server zerossl
   ```

   2. 这里以 **dnspod** 为例，在用户中心->安全设置, 找到 API Token 选项栏，生成 **ID** 和 **Token**，在命令行界面将上面生成的 **ID** 和 **Token** 导入环境变量里

   ```shell
   export DP_Id="生成的ID"
   export DP_Key="生成的Token"
   ```

   3. 完成后申请泛域名证书，**dns_dp**  是 **dnspod** 服务商，**修改域名**，其中必须包括 `*.域名` 和 `域名`，这种方式将自动为你的域名添加一条 txt 解析，验证成功后，这条解析记录会被删除：

   ```shell
   acme.sh --issue --dns dns_dp --issue -d *.example.com -d example.com
   ```

   > 证书生成成功后，默认保存在 ~/.acme.sh/\*.example.com（/root/.acme.sh/\*.example.com）对应的目录中

   4. 前面证书生成以后, 接下来需要把证书 copy 到真正需要用它的地方。

   注意，默认生成的证书都放在安装目录下：`~/.acme.sh/`，请不要直接使用此目录下的文件，例如：不要直接让 nginx/apache 的配置文件使用这下面的文件。这里面的文件都是内部使用，而且目录结构可能会变化。

   正确的使用方法是使用 `--install-cert` 命令，并指定目标位置，然后证书文件会被copy到相应的位置，我们先去 `/home/` 目录下新建一个 `/ssl/` 文件夹，进入文件夹在新建一个 `/域名文件夹/`，例如 `/home/ssl/*.example.com/`，然后执行以下命令**（注意替换域名）**：

   ```shell
   acme.sh --installcert -d *.example.com \        --key-file /home/ssl/*.example.com/*.example.com.key \        --fullchain-file /home/ssl/*.example.com/fullchain.cer \        --reloadcmd "service nginx reload"
   ```

   5. 修改 **nginx** 关于域名的配置信息，进入 **nginx** 的配置目录，找到需要修改的域名配置文件，修改证书路径为第 4 步配置的路径，保存即可完成证书配置。

### 更新证书

目前证书在 60 天以后会自动更新，你无需任何操作。

请确保 cronjob 正确安装，看起来是类似这样的：

```shell
crontab  -l

56 * * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
```

### 更新 **acme.sh**

目前由于 acme 协议和 letsencrypt CA 都在频繁的更新, 因此 acme.sh 也经常更新以保持同步.

升级 acme.sh 到最新版 :

```shell
acme.sh --upgrade
```

如果你不想手动升级, 可以开启自动升级:

```shell
acme.sh --upgrade --auto-upgrade
```

之后, acme.sh 就会自动保持更新了.

你也可以随时关闭自动更新:

```shell
acme.sh --upgrade --auto-upgrade  0
```

### 卸载