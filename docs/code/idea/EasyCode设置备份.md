## EasyCode设置备份

### controller.java.vm

```java
##定义初始变量
#set($tableName = $tool.append($tableInfo.name, "Controller"))
##设置回调
$!callback.setFileName($tool.append($tableName, ".java"))
$!callback.setSavePath($tool.append($tableInfo.savePath, "/controller"))
##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}controller;

import $!{tableInfo.savePackageName}.entity.$!{tableInfo.name};
import $!{tableInfo.savePackageName}.service.$!{tableInfo.name}Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 * $!{tableInfo.comment}($!{tableInfo.name})表控制层
 *
 * @author $!author
 * @since $!time.currTime()
 */
@RestController
@RequestMapping("$!tool.firstLowerCase($tableInfo.name)")
public class $!{tableName} {
    /**
     * 服务对象
     */
    @Resource
    private $!{tableInfo.name}Service $!tool.firstLowerCase($tableInfo.name)Service;

    /**
     * 分页查询
     *
     * @param $!{tool.firstLowerCase($tableInfo.name)} 筛选条件
     * @param pageRequest      分页对象
     * @return 查询结果
     */
    @GetMapping
    public ResponseEntity<Page<$!{tableInfo.name}>> queryByPage($!{tableInfo.name} $!{tool.firstLowerCase($tableInfo.name)}, PageRequest pageRequest) {
        return ResponseEntity.ok(this.$!{tool.firstLowerCase($tableInfo.name)}Service.queryByPage($!{tool.firstLowerCase($tableInfo.name)}, pageRequest));
    }

    /**
     * 通过主键查询单条数据
     *
     * @param id 主键
     * @return 单条数据
     */
    @GetMapping("{id}")
    public ResponseEntity<$!{tableInfo.name}> queryById(@PathVariable("id") $!pk.shortType id) {
        return ResponseEntity.ok(this.$!{tool.firstLowerCase($tableInfo.name)}Service.queryById(id));
    }

    /**
     * 新增数据
     *
     * @param $!{tool.firstLowerCase($tableInfo.name)} 实体
     * @return 新增结果
     */
    @PostMapping
    public ResponseEntity<$!{tableInfo.name}> add($!{tableInfo.name} $!{tool.firstLowerCase($tableInfo.name)}) {
        return ResponseEntity.ok(this.$!{tool.firstLowerCase($tableInfo.name)}Service.insert($!{tool.firstLowerCase($tableInfo.name)}));
    }

    /**
     * 编辑数据
     *
     * @param $!{tool.firstLowerCase($tableInfo.name)} 实体
     * @return 编辑结果
     */
    @PutMapping
    public ResponseEntity<$!{tableInfo.name}> edit($!{tableInfo.name} $!{tool.firstLowerCase($tableInfo.name)}) {
        return ResponseEntity.ok(this.$!{tool.firstLowerCase($tableInfo.name)}Service.update($!{tool.firstLowerCase($tableInfo.name)}));
    }

    /**
     * 删除数据
     *
     * @param id 主键
     * @return 删除是否成功
     */
    @DeleteMapping
    public ResponseEntity<Boolean> deleteById($!pk.shortType id) {
        return ResponseEntity.ok(this.$!{tool.firstLowerCase($tableInfo.name)}Service.deleteById(id));
    }

}

```

### entity.java.vm

```java
##引入宏定义
$!{define.vm}

##使用宏定义设置回调（保存位置与文件后缀）
#save("/entity", ".java")

##使用宏定义设置包后缀
#setPackageSuffix("entity")

##使用全局变量实现默认包导入
$!{autoImport.vm}
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.NoArgsConstructor;
import lombok.Data;

##表注释（宏定义）
#tableComment("表实体类")
@Data
@NoArgsConstructor
@TableName("$tool.hump2Underline($tableInfo.name)")
public class $!{tableInfo.name} implements Serializable {
##以第一个primary key字段没primary key
#foreach($column in $tableInfo.pkColumn)
    #set($pkColumn = $!column.name)
    #break
#end

##输出每个字段
#foreach($column in $tableInfo.fullColumn)
    #if(${column.comment})
    /**
    * ${column.comment}
    */
    #end
    #if(${column.name} == ${pkColumn})
    @TableId(value = "$tool.hump2Underline($column.name)", type = IdType.AUTO)
    #end
    private $!{tool.getClsNameByFullName($column.type)} $!{column.name};

#end
}
```

### mapper.java.vm

```java
##导入宏定义
$!{define.vm}

##设置表后缀（宏定义）
#setTableSuffix("Mapper")

##保存文件（宏定义）
#save("/mapper", "Mapper.java")

##包路径（宏定义）
#setPackageSuffix("mapper")

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import $!{tableInfo.savePackageName}.entity.$!{tableInfo.name};
import org.apache.ibatis.annotations.Mapper;

##表注释（宏定义）
#tableComment("表数据库访问层")
@Mapper
public interface $!{tableName} extends BaseMapper<$!{tableInfo.name}> {
}
```

### mapper.xml.vm

```xml
##引入mybatis支持
$!{mybatisSupport.vm}

##设置保存名称与保存位置
$!callback.setFileName($tool.append($!{tableInfo.name}, "Mapper.xml"))
$!callback.setSavePath($tool.append($modulePath, "/src/main/resources/mapper"))

##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="$!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper">

    <resultMap type="$!{tableInfo.savePackageName}.entity.$!{tableInfo.name}" id="$!{tableInfo.name}Map">
#foreach($column in $tableInfo.fullColumn)
        <result property="$!column.name" column="$!column.obj.name" jdbcType="$!column.ext.jdbcType"/>
#end
    </resultMap>

    <!--查询单个-->
    <select id="queryById" resultMap="$!{tableInfo.name}Map">
        select
          #allSqlColumn()

        from $!tableInfo.obj.name
        where $!pk.obj.name = #{$!pk.name}
    </select>

    <!--查询指定行数据-->
    <select id="queryAllByLimit" resultMap="$!{tableInfo.name}Map">
        select
          #allSqlColumn()

        from $!tableInfo.obj.name
        <where>
#foreach($column in $tableInfo.fullColumn)
            <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end">
                and $!column.obj.name = #{$!column.name}
            </if>
#end
        </where>
        limit #{pageable.offset}, #{pageable.pageSize}
    </select>

    <!--统计总行数-->
    <select id="count" resultType="java.lang.Long">
        select count(1)
        from $!tableInfo.obj.name
        <where>
#foreach($column in $tableInfo.fullColumn)
            <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end">
                and $!column.obj.name = #{$!column.name}
            </if>
#end
        </where>
    </select>

    <!--新增所有列-->
    <insert id="insert" keyProperty="$!pk.name" useGeneratedKeys="true">
        insert into $!{tableInfo.obj.name}(#foreach($column in $tableInfo.otherColumn)$!column.obj.name#if($velocityHasNext), #end#end)
        values (#foreach($column in $tableInfo.otherColumn)#{$!{column.name}}#if($velocityHasNext), #end#end)
    </insert>

    <insert id="insertBatch" keyProperty="$!pk.name" useGeneratedKeys="true">
        insert into $!{tableInfo.obj.name}(#foreach($column in $tableInfo.otherColumn)$!column.obj.name#if($velocityHasNext), #end#end)
        values
        <foreach collection="entities" item="entity" separator=",">
        (#foreach($column in $tableInfo.otherColumn)#{entity.$!{column.name}}#if($velocityHasNext), #end#end)
        </foreach>
    </insert>

    <insert id="insertOrUpdateBatch" keyProperty="$!pk.name" useGeneratedKeys="true">
        insert into $!{tableInfo.obj.name}(#foreach($column in $tableInfo.otherColumn)$!column.obj.name#if($velocityHasNext), #end#end)
        values
        <foreach collection="entities" item="entity" separator=",">
            (#foreach($column in $tableInfo.otherColumn)#{entity.$!{column.name}}#if($velocityHasNext), #end#end)
        </foreach>
        on duplicate key update
        #foreach($column in $tableInfo.otherColumn)$!column.obj.name = values($!column.obj.name)#if($velocityHasNext),
        #end#end

    </insert>

    <!--通过主键修改数据-->
    <update id="update">
        update $!{tableInfo.obj.name}
        <set>
#foreach($column in $tableInfo.otherColumn)
            <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end">
                $!column.obj.name = #{$!column.name},
            </if>
#end
        </set>
        where $!pk.obj.name = #{$!pk.name}
    </update>

    <!--通过主键删除-->
    <delete id="deleteById">
        delete from $!{tableInfo.obj.name} where $!pk.obj.name = #{$!pk.name}
    </delete>

</mapper>

```

### service.java.vm

```java
##导入宏定义
$!{define.vm}

##设置表后缀（宏定义）
#setTableSuffix("Service")

##保存文件（宏定义）
#save("/service", "Service.java")

##包路径（宏定义）
#setPackageSuffix("service")

import com.baomidou.mybatisplus.extension.service.IService;
import $!{tableInfo.savePackageName}.entity.$!{tableInfo.name};

##表注释（宏定义）
#tableComment("表服务接口")
public interface $!{tableName} extends IService<$!{tableInfo.name}> {
}
```

### serviceImpl.java.vm

```java
##导入宏定义
$!{define.vm}

##设置表后缀（宏定义）
#setTableSuffix("ServiceImpl")

##保存文件（宏定义）
#save("/service/impl", "ServiceImpl.java")

##包路径（宏定义）
#setPackageSuffix("service.impl")

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import $!{tableInfo.savePackageName}.service.$!{tableInfo.name}Service;
import $!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper;
import $!{tableInfo.savePackageName}.entity.$!{tableInfo.name};
import org.springframework.stereotype.Service;

##表注释（宏定义）
#tableComment("表服务实现类")
@Service
public class $!{tableName} extends ServiceImpl<$!{tableInfo.name}Mapper, $!{tableInfo.name}> implements $!{tableInfo.name}Service {
}
```

