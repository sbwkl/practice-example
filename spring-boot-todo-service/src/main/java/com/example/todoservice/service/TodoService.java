package com.example.todoservice.service;

import com.example.todoservice.dto.CreateTodoRequest;
import com.example.todoservice.dto.TodoDto;
import com.example.todoservice.dto.UpdateTodoRequest;

import java.util.List;

public interface TodoService {
    List<TodoDto> findAll();
    TodoDto findById(Long id);
    TodoDto create(CreateTodoRequest request);
    TodoDto update(Long id, UpdateTodoRequest request);
    void delete(Long id);
}
