package com.example.todo.service.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegistrationRequest {
    @NotBlank
    private String username;

    @NotBlank
    private String password;
}
