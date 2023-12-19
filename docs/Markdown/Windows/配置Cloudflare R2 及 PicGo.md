1. 开通 Cloudflare R2

   * 点击 R2 进入存储桶页面

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.38s8dqeyd140.webp)

   * 点击创建存储桶，绑定支付方式（可免费使用）

   ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2w2h1v96nqa0.webp)

   * 创建存储桶，填写存储桶名称，创建即可

   * 创建完成后点击设置，绑定自定义域名（或者使用R2.dev）

     ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.2ba5at8wm64g.webp)

   * 复制 S3 Api：

     ![image-20231219091236293](https://cdn.jsdelivr.net/gh/bolishitoumingde/hexo_img@main/image-20231219091236293.32ao7akq0mo.webp)

   * 回到 R2 首页（概述），点击管理 R2 Api 令牌：

     ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3xgvc41siga0.webp)

   * 点击创建 Api 令牌，填写令牌名称，权限选择对象读和写，指定存储桶为特定存储桶，选择之前创建的存储桶，点击创建 Api 令牌，记住以下两个值：

     ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.53j5cappa7s0.webp)

   

2. 配置 PicGo

   * 安装并打开 PicGo，点击插件设置，点击搜索框搜索 S3，安装下图展示插件：

     ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.4j4pe5ri4kk0.webp)

   * 点击图床设置，选择 Amazon S3，编辑配置：

     ![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.3utup3919r80.webp)

     

   

   

   