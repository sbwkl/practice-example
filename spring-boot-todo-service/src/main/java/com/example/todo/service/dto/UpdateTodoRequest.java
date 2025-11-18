package com.example.todo.service.dto;

import com.example.todo.service.model.TodoPriority;
import com.example.todo.service.model.TodoStatus;
import lombok.Data;

import java.time.LocalDate;

@Data
public class UpdateTodoRequest {
    private String title;
    private String description;
    private TodoStatus status;
    private TodoPriority priority;
    private LocalDate dueDate;
}
