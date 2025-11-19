package com.example.todo.service.dto;

import com.example.todo.service.model.TodoPriority;
import com.example.todo.service.model.TodoStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UpdateTodoRequest {
    private String title;
    private String description;
    private String attachment;
    private TodoStatus status;
    private TodoPriority priority;
    private LocalDateTime dueDate;
}
