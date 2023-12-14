1. **构建镜像**

   如果你想要自己构建镜像，你可以使用以下代码进行构建，如果只需要使用，则可以直接进行步骤 2

   ```dockerfile
   # build stage
   FROM node:lts-alpine as build-stage
   
   WORKDIR /app
   COPY package*.json ./
   RUN npm config set registry https://registry.npm.taobao.org/
   RUN npm install
   COPY . .
   RUN npm run build
   
   # production stage
   FROM nginx:stable-alpine as production-stage
   COPY --from=build-stage /app/dist /usr/share/nginx/html
   EXPOSE 80
   CMD ["nginx", "-g", "daemon off;"]
   
   ```

2. **拉取镜像**

   ```bash
   docker pull bolishitoumingde/picx:2.4.0
   ```

3. **启动容器**

   ```bash
   docker run -d --name=picx -p 10000:10000 bolishitoumingde/picx:2.4.0
   ```

   