package com.example.todoservice.dto;

import com.example.todoservice.model.TodoPriority;
import lombok.Data;

import java.time.LocalDate;

@Data
public class CreateTodoRequest {
    private String title;
    private String description;
    private TodoPriority priority;
    private LocalDate dueDate;
}
