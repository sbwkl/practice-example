package com.example.compilers.chapter02.lexer;

import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {
        Lexer lexer = new Lexer();
        Token token = lexer.scan();
        System.out.println(token);
    }
}
