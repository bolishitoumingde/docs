## 相关语法函数介绍

> **@**
>
> @是用户变量，@@是系统变量。

> **:=**
>
> 不只在set和update时时赋值的作用，在select也是赋值的作用。

> **GROUP_CONCAT()**
>
> 将group by产生的同一个分组中的值连接起来，返回一个字符串结果。

> **FIND_IN_SET()**
>
> 查询字段(strlist)中包含(str)的结果，返回结果为null或记录

## 父子查询

### 排序

> 不通过联表查询，仅通过`ORDER BY` 语句实现父子集查询功能

**建表语句**

```sql
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父id',
  `sort` int(4) NULL DEFAULT NULL COMMENT '排序',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
  PRIMARY KEY (`id`) USING BTREE
);

INSERT INTO `test` VALUES (1, '测试1', 0, 0, 0);
INSERT INTO `test` VALUES (2, '测试2', 0, 0, 0);
INSERT INTO `test` VALUES (3, '测试2子类1', 2, 0, 0);
INSERT INTO `test` VALUES (4, '测试2子类2', 2, 0, 0);
INSERT INTO `test` VALUES (5, '测试2子类1子类', 3, 0, 0);
INSERT INTO `test` VALUES (6, '测试1子类1', 1, 0, 0);
INSERT INTO `test` VALUES (7, '测试1子类2', 1, 0, 0);
```

**查询语句**

```sql
SELECT
	* 
FROM
	test AS pc1 
WHERE
	pc1.`status` = '0' 
ORDER BY
CASE
		
		WHEN pc1.parent_id = 0 THEN
		pc1.id -- 根节点，按id升序排序
		ELSE pc1.parent_id -- 非根节点，按parent_id降序排序
		
	END,
	pc1.parent_id,-- 同级之间，按parent_id升序排序
	pc1.id -- 同级之间，按id升序排序
```

**查询结果**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.oe49x3o5b7k.webp)

### 递归

> 通过递归实现子查父

**建表语句**

```sql
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单名称',
  `parent_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '上级菜单ID',
  PRIMARY KEY (`id`),
  KEY `idx_valid` (`parent_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';
```

**查询语句1**

> 查询结果不包括自身

```sql
select m.* from (select @id as _id,(select @id:=parent_id from `menu` where id = _id)  from (select @id:=(select parent_id from `menu` where id = 9)) vm,`menu` m 
where @id is not null) vm inner join `menu`  m where id = vm._id
```

**查询结果1**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.5rfbvl1cnn40.webp)

**查询语句2**

> 查询结果包括自身

```sql
SELECT
	@r AS menuId,
	( SELECT @r := parent_id FROM menu WHERE id = menuId ) AS parentId,
	@l := @l + 1 AS lvl 
FROM
	( SELECT @r := 8, @l := 0 ) vars,
	menu h 
WHERE
	@r <> 0 
	AND parent_id > 0;
```

**查询结果2**

![image](https://jsd.cdn.zzko.cn/gh/bolishitoumingde/hexo_img@main/image.ypmfztjypw0.webp)

#### 原理介绍

> 以 查询语句1 为例

> -- 第一部分
>
> -- 得到需要查询节点的父节点id

```sql	
SELECT @id:=(SELECT parent_id FROM `menu` WHERE id=8);
```

> -- 第二部分
>
> -- 根据查询到的父节点id和原表进行联合

```sql
SELECT * FROM (
	SELECT @id:=(SELECT parent_id FROM `menu` WHERE id=8)
) vm, `menu` m;
```

> -- 第三部分
>
> -- 将查询出来的parent_id赋值给变量@id
>
> -- 只改变select * 为 @id as _id,(select @id:=parent_id from `menu` where id = _id) where是为了过滤其他的null值
>
> -- 这一步已经获取到所有的父类id了

```sql
select @id as _id,(select @id:=parent_id from `menu` where id = _id)  
from (
	select @id:=(select parent_id from `menu` where id = 9)
) vm,`menu` m 
where @id is not null;
```

> -- 第四部分
>
> -- 与`menu`表联合查询，获取父类菜单的所有信息

```sql
select `menu`.* from (
	select @id as _id,(select @id:=parent_id from `menu` where id = _id)  
from (
	select @id:=(select parent_id from `menu` where id = 9)
) vm,`menu` m 
where @id is not null 
) vm, `menu`  where vm._id = `menu`.id;
```

**完整过程**

```sql
-- 第一部分
-- 得到需要查询节点的父节点id
SELECT @id:=(SELECT parent_id FROM `menu` WHERE id=8);

-- 第二部分
-- 根据查询到的父节点id和原表进行联合
SELECT * FROM (
	SELECT @id:=(SELECT parent_id FROM `menu` WHERE id=8)
) vm, `menu` m;

-- 第三部分
-- 将查询出来的parent_id赋值给变量@id
-- 只改变select * 为 @id as _id,(select @id:=parent_id from `menu` where id = _id) where是为了过滤其他的null值
-- 这一步已经获取到所有的父类id了
select @id as _id,(select @id:=parent_id from `menu` where id = _id)  
from (
	select @id:=(select parent_id from `menu` where id = 9)
) vm,`menu` m 
where @id is not null;

-- 第四部分
-- 与`menu`表联合查询，获取父类菜单的所有信息
select `menu`.* from (
	select @id as _id,(select @id:=parent_id from `menu` where id = _id)  
from (
	select @id:=(select parent_id from `menu` where id = 9)
) vm,`menu` m 
where @id is not null 
) vm, `menu`  where vm._id = `menu`.id;
```

