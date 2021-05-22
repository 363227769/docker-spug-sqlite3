## 构建镜像

~~~
docker build -t spug-sqlite3 .
~~~

## 启动镜像

~~~
docker run  -it --name spug -p 8080:80 -v ~/.ssh:/root/.ssh -d spug-sqlite3:latest
~~~

## 进入镜像

~~~
docker exec -it spug sh 
~~~

## 目录结构
~~~
 # 数据库目录使用sqlite3
 /spug/spug_api/db 
 # 仓库目录
 /spug/spug_api/repos
 # spug日志目录
 /spug/spug_api/logs
 # 密钥
 /root/.ssh
~~~

## 启动

~~~
访问 http://127.0.0.1:8080/
初始账号: admin, 密码: spug.dev
~~~

