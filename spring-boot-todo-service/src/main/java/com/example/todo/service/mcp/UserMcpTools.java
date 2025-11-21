package com.example.todo.service.mcp;

import com.example.todo.service.dto.LoginRequest;
import com.example.todo.service.dto.RegistrationRequest;
import com.example.todo.service.mapper.UserMapper;
import com.example.todo.service.model.User;
import com.example.todo.service.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * MCP Tools for User management operations.
 * These tools expose user registration, login, and profile operations to MCP
 * clients.
 */
@Component
@RequiredArgsConstructor
public class UserMcpTools {

    private final UserService userService;
    private final UserMapper userMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Tool(name = "register_user", description = "Register a new user account")
    public String registerUser(
            @ToolParam(description = "The username for the new account") String username,
            @ToolParam(description = "The password for the new account") String password) {
        try {
            RegistrationRequest request = new RegistrationRequest();
            request.setUsername(username);
            request.setPassword(password);

            User user = userService.register(request);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("userId", user.getId());
            response.put("username", user.getUsername());
            response.put("message", "User registered successfully");

            return objectMapper.writeValueAsString(response);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "login_user", description = "Authenticate a user and get a JWT token")
    public String loginUser(
            @ToolParam(description = "The username") String username,
            @ToolParam(description = "The password") String password) {
        try {
            LoginRequest request = new LoginRequest();
            request.setUsername(username);
            request.setPassword(password);

            String token = userService.login(request);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("token", token);
            response.put("message", "Login successful. Use this token for authenticated requests.");

            return objectMapper.writeValueAsString(response);
        } catch (Exception e) {
            return "{\"error\": \"Authentication failed: " + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "get_current_user", description = "Get information about the currently authenticated user")
    public String getCurrentUser() {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = userMapper.findByUsername(username);

            if (user == null) {
                return "{\"error\": \"User not found\"}";
            }

            Map<String, Object> response = new HashMap<>();
            response.put("id", user.getId());
            response.put("username", user.getUsername());
            response.put("createdAt", user.getCreatedAt());

            return objectMapper.writeValueAsString(response);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }
}
