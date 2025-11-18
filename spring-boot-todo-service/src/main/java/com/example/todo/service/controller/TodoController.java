package com.example.todo.service.controller;

import com.example.todo.service.dto.CreateTodoRequest;
import com.example.todo.service.dto.TodoDto;
import com.example.todo.service.dto.UpdateTodoRequest;
import com.example.todo.service.service.TodoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
@RequiredArgsConstructor
@Tag(name = "Todo API", description = "API for managing todo items")
public class TodoController {

    private final TodoService todoService;

    @GetMapping
    @Operation(summary = "Get all todo items")
    public List<TodoDto> getAllTodos() {
        return todoService.findAll();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get a todo item by id")
    public ResponseEntity<TodoDto> getTodoById(@PathVariable Long id) {
        TodoDto todo = todoService.findById(id);
        return todo != null ? ResponseEntity.ok(todo) : ResponseEntity.notFound().build();
    }

    @PostMapping
    @Operation(summary = "Create a new todo item")
    public ResponseEntity<TodoDto> createTodo(@RequestBody CreateTodoRequest request) {
        TodoDto createdTodo = todoService.create(request);
        return new ResponseEntity<>(createdTodo, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update an existing todo item")
    public ResponseEntity<TodoDto> updateTodo(@PathVariable Long id, @RequestBody UpdateTodoRequest request) {
        TodoDto updatedTodo = todoService.update(id, request);
        return updatedTodo != null ? ResponseEntity.ok(updatedTodo) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a todo item")
    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
        todoService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
