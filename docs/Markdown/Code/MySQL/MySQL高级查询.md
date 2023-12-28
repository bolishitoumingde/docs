## 父子查询

### 子集在其对应父集的下

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

