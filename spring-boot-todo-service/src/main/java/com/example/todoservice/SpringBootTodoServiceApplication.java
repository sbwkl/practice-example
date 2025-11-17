package com.example.todoservice;

import org.springframework.boot.SpringApplication;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.todoservice.mapper")
public class SpringBootTodoServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootTodoServiceApplication.class, args);
	}

}
