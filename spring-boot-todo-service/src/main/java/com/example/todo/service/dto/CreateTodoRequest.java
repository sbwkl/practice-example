package com.example.todo.service.dto;

import com.example.todo.service.model.TodoPriority;
import lombok.Data;

import java.time.LocalDate;

@Data
public class CreateTodoRequest {
    private String title;
    private String description;
    private TodoPriority priority;
    private LocalDate dueDate;
}
