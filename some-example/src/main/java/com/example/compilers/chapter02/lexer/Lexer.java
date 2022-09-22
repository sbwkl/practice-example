package com.example.compilers.chapter02.lexer;

import java.util.Hashtable;
import java.util.Map;

public class Lexer {
    public int line = 1;
    private char peek = ' ';
    private Map<String, Token> words = new Hashtable<>();
    void reserve(Word w) {
        words.put(w.lexeme, w);
    }
    public Lexer() {
        reserve(new Word(Tag.TRUE, "true"));
        reserve(new Word(Tag.FALSE, "false"));
    }
}
