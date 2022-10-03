package com.example.compilers.chapter02.lexer;

import java.io.IOException;

public class Buffer {
    private int first;
    private int last;
    private int index;
    private int[] buffer;

    public Buffer() {
        first = 0;
        last = 0;
        index = 0;
        buffer = new int[1024];
    }

    public char peek() throws IOException {
        if (index == last) {
            buffer[index] = System.in.read();
            last++;
        }
        char t = (char) buffer[index];
        index++;
        return t;
    }

    public char pop() throws IOException {
        char t = peek();
        first++;
        return t;
    }

    public void resetIndex() {
        index = first;
    }

    public void clear() {
        first = 0;
        last = 0;
        index = 0;
    }

    public String content() {
        StringBuffer sb = new StringBuffer();
        for (int i = first; i < last; i++) {
            sb.append((char) buffer[i]);
        }
        return sb.toString();
    }
}
