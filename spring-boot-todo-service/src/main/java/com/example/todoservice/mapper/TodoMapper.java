package com.example.todoservice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.todoservice.model.Todo;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TodoMapper extends BaseMapper<Todo> {
}
