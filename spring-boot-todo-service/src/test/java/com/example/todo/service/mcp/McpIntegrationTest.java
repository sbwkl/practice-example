package com.example.todo.service.mcp;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest

@AutoConfigureMockMvc
public class McpIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldReturnToolsList() throws Exception {
        // 1. Connect to SSE endpoint
        MvcResult sseResult = mockMvc.perform(get("/mcp/sse"))
                .andExpect(status().isOk())
                .andReturn();

        String content = sseResult.getResponse().getContentAsString();
        assertThat(content).contains("event:endpoint");

        // Extract endpoint from SSE response
        // Format is usually: event:endpoint\ndata: /mcp/message?sessionId=...\n\n
        String[] lines = content.split("\\n");
        String messageEndpoint = null;
        for (String line : lines) {
            if (line.startsWith("data:")) {
                messageEndpoint = line.substring(5).trim();
                break;
            }
        }
        assertThat(messageEndpoint).isNotNull();

        // 2. Send tools/list request to the message endpoint
        String requestBody = "{\"jsonrpc\": \"2.0\", \"method\": \"tools/list\", \"id\": 1}";

        mockMvc.perform(post(messageEndpoint)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("list_todos")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("create_todo")));
    }
}
