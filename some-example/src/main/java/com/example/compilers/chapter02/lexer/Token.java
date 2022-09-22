package com.example.compilers.chapter02.lexer;

public class Token {

    protected final int tag;

    public Token(int t) {
        this.tag = t;
    }

    @Override
    public String toString() {
        return "Token{" +
                "tag=" + tag +
                '}';
    }
}
