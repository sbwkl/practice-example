package com.example.compilers.chapter02.lexer;

public class Word extends Token {
    public final String lexeme;

    public Word(int t, String s) {
        super(t);
        this.lexeme = s;
    }

    @Override
    public String toString() {
        return String.format("Word{lexeme = %s, tag = %s}", lexeme, super.tag);
    }
}
