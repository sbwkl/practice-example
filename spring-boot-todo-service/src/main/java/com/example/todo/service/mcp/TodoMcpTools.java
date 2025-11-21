package com.example.todo.service.mcp;

import com.example.todo.service.dto.CreateTodoRequest;
import com.example.todo.service.dto.TodoDto;
import com.example.todo.service.dto.UpdateTodoRequest;
import com.example.todo.service.model.TodoPriority;
import com.example.todo.service.model.TodoStatus;
import com.example.todo.service.service.TodoService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * MCP Tools for Todo management operations.
 * These tools expose todo CRUD operations to MCP clients.
 */
@Component
@RequiredArgsConstructor
public class TodoMcpTools {

    private final TodoService todoService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Tool(name = "list_todos", description = "List all todo items for the authenticated user")
    public String listTodos() {
        try {
            List<TodoDto> todos = todoService.findAll();
            return objectMapper.writeValueAsString(todos);
        } catch (JsonProcessingException e) {
            return "{\"error\": \"Failed to serialize todos: " + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "get_todo", description = "Get a specific todo item by ID")
    public String getTodoById(
            @ToolParam(description = "The ID of the todo item to retrieve") Long id) {
        try {
            TodoDto todo = todoService.findById(id);
            return objectMapper.writeValueAsString(todo);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "create_todo", description = "Create a new todo item")
    public String createTodo(
            @ToolParam(description = "The title of the todo item") String title,
            @ToolParam(description = "The description of the todo item (optional)") String description,
            @ToolParam(description = "The priority of the todo: LOW, MEDIUM, or HIGH (optional, default: MEDIUM)") String priority,
            @ToolParam(description = "The due date in ISO format (optional, e.g., 2025-12-31T23:59:59)") String dueDate) {
        try {
            CreateTodoRequest request = new CreateTodoRequest();
            request.setTitle(title);
            request.setDescription(description);

            if (priority != null && !priority.isEmpty()) {
                request.setPriority(TodoPriority.valueOf(priority.toUpperCase()));
            }

            if (dueDate != null && !dueDate.isEmpty()) {
                request.setDueDate(LocalDateTime.parse(dueDate, DateTimeFormatter.ISO_DATE_TIME));
            }

            TodoDto createdTodo = todoService.create(request);
            return objectMapper.writeValueAsString(createdTodo);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "update_todo", description = "Update an existing todo item")
    public String updateTodo(
            @ToolParam(description = "The ID of the todo item to update") Long id,
            @ToolParam(description = "The new title of the todo item (optional)") String title,
            @ToolParam(description = "The new description of the todo item (optional)") String description,
            @ToolParam(description = "The new status: PENDING, IN_PROGRESS, or COMPLETED (optional)") String status,
            @ToolParam(description = "The new priority: LOW, MEDIUM, or HIGH (optional)") String priority,
            @ToolParam(description = "The new due date in ISO format (optional, e.g., 2025-12-31T23:59:59)") String dueDate) {
        try {
            // First get the existing todo to preserve unchanged fields
            TodoDto existingTodo = todoService.findById(id);

            UpdateTodoRequest request = new UpdateTodoRequest();
            request.setTitle(title != null && !title.isEmpty() ? title : existingTodo.getTitle());
            request.setDescription(description != null ? description : existingTodo.getDescription());

            if (status != null && !status.isEmpty()) {
                request.setStatus(TodoStatus.valueOf(status.toUpperCase()));
            } else {
                request.setStatus(existingTodo.getStatus());
            }

            if (priority != null && !priority.isEmpty()) {
                request.setPriority(TodoPriority.valueOf(priority.toUpperCase()));
            } else {
                request.setPriority(existingTodo.getPriority());
            }

            if (dueDate != null && !dueDate.isEmpty()) {
                request.setDueDate(LocalDateTime.parse(dueDate, DateTimeFormatter.ISO_DATE_TIME));
            } else {
                request.setDueDate(existingTodo.getDueDate());
            }

            TodoDto updatedTodo = todoService.update(id, request);
            return objectMapper.writeValueAsString(updatedTodo);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @Tool(name = "delete_todo", description = "Delete a todo item by ID")
    public String deleteTodo(
            @ToolParam(description = "The ID of the todo item to delete") Long id) {
        try {
            todoService.delete(id);
            return "{\"success\": true, \"message\": \"Todo deleted successfully\"}";
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }
}
