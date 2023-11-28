## 后台运行

```
nohup java -jar Jar包名称.jar > log名称.log 2 > &1 &
```

## 查询进程

任选其一

```
ps -ef | grep java
```

```
ps -ef | grep "java -jar"
```

```
ps aux|grep jar
```

## 终止进程

```
kill -9 进程PID
```

