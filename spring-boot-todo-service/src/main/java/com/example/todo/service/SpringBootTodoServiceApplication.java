package com.example.todo.service;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

@SpringBootApplication
@MapperScan("com.example.todo.service.mapper")
@EnableWebSecurity
public class SpringBootTodoServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootTodoServiceApplication.class, args);
    }

}
