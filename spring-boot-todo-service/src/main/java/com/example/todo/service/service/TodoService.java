package com.example.todo.service.service;

import com.example.todo.service.dto.CreateTodoRequest;
import com.example.todo.service.dto.TodoDto;
import com.example.todo.service.dto.UpdateTodoRequest;

import java.util.List;

public interface TodoService {
    List<TodoDto> findAll();
    TodoDto findById(Long id);
    TodoDto create(CreateTodoRequest request);
    TodoDto update(Long id, UpdateTodoRequest request);
    void delete(Long id);
}
