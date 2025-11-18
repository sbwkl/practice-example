package com.example.todo.service.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("todos")
public class Todo {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String description;

    @TableField("status")
    private TodoStatus status;

    @TableField("priority")
    private TodoPriority priority;

    @TableField("due_date")
    private LocalDate dueDate;

    @TableField("created_at")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
