package com.example.todo.service;

import com.example.todo.service.dto.CreateTodoRequest;
import com.example.todo.service.dto.UpdateTodoRequest;
import com.example.todo.service.model.Todo;
import com.example.todo.service.model.TodoPriority;
import com.example.todo.service.model.TodoStatus;
import com.example.todo.service.model.User;
import com.example.todo.service.mapper.TodoMapper;
import com.example.todo.service.mapper.UserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.springframework.security.test.context.support.WithMockUser;

@SpringBootTest
@AutoConfigureMockMvc
@WithMockUser(username = "user", roles = "USER")
public class TodoControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TodoMapper todoMapper;

    @Autowired
    private UserMapper userMapper;

    private User testUser;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        todoMapper.delete(null); // Clear all todos before each test
        userMapper.delete(null);

        testUser = new User();
        testUser.setUsername("user");
        testUser.setPassword("password");
        testUser.setCreatedAt(LocalDateTime.now());
        testUser.setUpdatedAt(LocalDateTime.now());
        userMapper.insert(testUser);
    }

    @Test
    void shouldCreateTodo() throws Exception {
        CreateTodoRequest request = new CreateTodoRequest();
        request.setTitle("Test Todo");
        request.setPriority(TodoPriority.HIGH);
        request.setDueDate(LocalDateTime.now());

        mockMvc.perform(post("/api/todos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("Test Todo"));
    }

    @Test
    void shouldGetAllTodos() throws Exception {
        Todo todo = new Todo();
        todo.setTitle("First Todo");
        todo.setUserId(testUser.getId());
        todo.setStatus(TodoStatus.PENDING);
        todo.setPriority(TodoPriority.LOW);
        todo.setCreatedAt(LocalDateTime.now());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.insert(todo);

        mockMvc.perform(get("/api/todos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title").value("First Todo"));
    }

    @Test
    void shouldGetTodoById() throws Exception {
        Todo todo = new Todo();
        todo.setTitle("Find Me");
        todo.setUserId(testUser.getId());
        todo.setStatus(TodoStatus.PENDING);
        todo.setPriority(TodoPriority.MEDIUM);
        todo.setCreatedAt(LocalDateTime.now());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.insert(todo);

        mockMvc.perform(get("/api/todos/" + todo.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Find Me"));
    }

    @Test
    void shouldReturnNotFoundForInvalidId() throws Exception {
        mockMvc.perform(get("/api/todos/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void shouldUpdateTodo() throws Exception {
        Todo todo = new Todo();
        todo.setTitle("Old Title");
        todo.setUserId(testUser.getId());
        todo.setStatus(TodoStatus.PENDING);
        todo.setPriority(TodoPriority.LOW);
        todo.setCreatedAt(LocalDateTime.now());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.insert(todo);

        UpdateTodoRequest updateRequest = new UpdateTodoRequest();
        updateRequest.setTitle("New Title");
        updateRequest.setPriority(TodoPriority.HIGH);
        updateRequest.setStatus(TodoStatus.COMPLETED);

        mockMvc.perform(put("/api/todos/" + todo.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("New Title"))
                .andExpect(jsonPath("$.priority").value("HIGH"));
    }

    @Test
    void shouldDeleteTodo() throws Exception {
        Todo todo = new Todo();
        todo.setTitle("Delete Me");
        todo.setUserId(testUser.getId());
        todo.setStatus(TodoStatus.PENDING);
        todo.setPriority(TodoPriority.LOW);
        todo.setCreatedAt(LocalDateTime.now());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.insert(todo);

        mockMvc.perform(delete("/api/todos/" + todo.getId()))
                .andExpect(status().isNoContent());
    }
}
