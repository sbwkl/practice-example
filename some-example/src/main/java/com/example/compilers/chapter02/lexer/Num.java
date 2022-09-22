package com.example.compilers.chapter02.lexer;

public class Num extends Token {
    public final int value;

    public Num(int v) {
        super(Tag.NUM);
        this.value = v;
    }

    @Override
    public String toString() {
        return String.format("Num{value = %s, tag = %s}", value, super.tag);
    }
}
