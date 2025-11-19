package com.example.todo.service.service;

import com.example.todo.service.dto.CreateTodoRequest;
import com.example.todo.service.dto.TodoDto;
import com.example.todo.service.dto.UpdateTodoRequest;
import com.example.todo.service.exception.ResourceNotFoundException;
import com.example.todo.service.mapper.TodoMapper;
import com.example.todo.service.model.Todo;
import com.example.todo.service.model.TodoStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TodoServiceImpl implements TodoService {

    private final TodoMapper todoMapper;

    @Override
    public List<TodoDto> findAll() {
        return todoMapper.selectList(null).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public TodoDto findById(Long id) {
        Todo todo = todoMapper.selectById(id);
        if (todo == null) {
            throw new ResourceNotFoundException("Todo not found with id: " + id);
        }
        return convertToDto(todo);
    }

    @Override
    public TodoDto create(CreateTodoRequest request) {
        Todo todo = new Todo();
        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());
        todo.setAttachment(request.getAttachment());
        todo.setStatus(TodoStatus.PENDING); // Default status
        todo.setPriority(request.getPriority());
        todo.setDueDate(request.getDueDate());
        todo.setCreatedAt(LocalDateTime.now());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.insert(todo);
        return convertToDto(todo);
    }

    @Override
    public TodoDto update(Long id, UpdateTodoRequest request) {
        Todo todo = todoMapper.selectById(id);
        if (todo == null) {
            throw new ResourceNotFoundException("Todo not found with id: " + id);
        }
        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());
        todo.setAttachment(request.getAttachment());
        todo.setStatus(request.getStatus());
        todo.setPriority(request.getPriority());
        todo.setDueDate(request.getDueDate());
        todo.setUpdatedAt(LocalDateTime.now());
        todoMapper.updateById(todo);
        return convertToDto(todo);
    }

    @Override
    public void delete(Long id) {
        todoMapper.deleteById(id);
    }

    private TodoDto convertToDto(Todo todo) {
        if (todo == null) {
            return null;
        }
        TodoDto dto = new TodoDto();
        dto.setId(todo.getId());
        dto.setTitle(todo.getTitle());
        dto.setDescription(todo.getDescription());
        dto.setAttachment(todo.getAttachment());
        dto.setStatus(todo.getStatus());
        dto.setPriority(todo.getPriority());
        dto.setDueDate(todo.getDueDate());
        dto.setCreatedAt(todo.getCreatedAt());
        dto.setUpdatedAt(todo.getUpdatedAt());
        return dto;
    }
}
