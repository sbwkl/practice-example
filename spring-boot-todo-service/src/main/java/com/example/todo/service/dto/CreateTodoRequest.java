package com.example.todo.service.dto;

import com.example.todo.service.model.TodoPriority;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CreateTodoRequest {
    @NotBlank
    private String title;
    private String description;
    private String attachment;
    private TodoPriority priority;
    private LocalDateTime dueDate;
}
