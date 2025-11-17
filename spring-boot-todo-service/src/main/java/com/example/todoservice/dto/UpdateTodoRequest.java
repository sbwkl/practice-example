package com.example.todoservice.dto;

import com.example.todoservice.model.TodoPriority;
import com.example.todoservice.model.TodoStatus;
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
