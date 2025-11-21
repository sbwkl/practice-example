package com.example.todo.service.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                // TODO: For production, it's recommended to restrict the allowed origins
                // to a specific list of domains instead of using a wildcard (*).
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowedHeaders("*");
    }
}
