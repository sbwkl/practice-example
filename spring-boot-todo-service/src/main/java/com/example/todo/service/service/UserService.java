package com.example.todo.service.service;

import com.example.todo.service.dto.LoginRequest;
import com.example.todo.service.dto.RegistrationRequest;
import com.example.todo.service.model.User;

public interface UserService {
    User register(RegistrationRequest registrationRequest);
    String login(LoginRequest loginRequest);
}
