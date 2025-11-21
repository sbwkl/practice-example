package com.example.todo.service.config;

import com.example.todo.service.mcp.TodoMcpTools;
import com.example.todo.service.mcp.UserMcpTools;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for MCP (Model Context Protocol) server.
 * This enables the Spring AI MCP server to expose tools via SSE transport.
 */
@Configuration
public class McpServerConfig {
    // Spring AI MCP auto-configuration will handle the setup
    // Additional custom configuration can be added here if needed
    
    @Bean
    public ToolCallbackProvider mcpTools(UserMcpTools userMcpTools, TodoMcpTools todoMcpTools) {
        return MethodToolCallbackProvider
            .builder()
            .toolObjects(userMcpTools, todoMcpTools)
            .build();
    }
}
