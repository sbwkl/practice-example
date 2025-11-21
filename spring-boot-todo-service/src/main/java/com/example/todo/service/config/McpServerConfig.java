package com.example.todo.service.config;

import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for MCP (Model Context Protocol) server.
 * This enables the Spring AI MCP server to expose tools via SSE transport.
 */
@Configuration
public class McpServerConfig {
    // Spring AI MCP auto-configuration will handle the setup
    // Additional custom configuration can be added here if needed
}
