## 构建镜像

~~~
docker build -t spug-sqlite3 .
~~~

## 启动镜像

~~~
docker run --name spug -p 8080:80 -d spug-sqlite3:latest
