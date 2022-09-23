package com.example.compilers.chapter02.lexer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

public class Lexer {
    public int line = 1;
    private char peek = ' ';
    List<Character> buffer = new ArrayList<>();
    private int bufferIndex = 0;
    private Map<String, Token> words = new Hashtable<>();
    void reserve(Word w) {
        words.put(w.lexeme, w);
    }
    public Lexer() {
        reserve(new Word(Tag.TRUE, "true"));
        reserve(new Word(Tag.FALSE, "false"));
    }
    public Token scan() throws IOException {
        for (; ; peek = nextCharacter()) {
            if (peek == ' ' || peek == '\t') continue;
            else if (peek == '\n') line += 1;
            else if (peek == '/') {
                buffer.add(peek);
            }
            else break;
        }
        if (Character.isDigit(peek)) {
            int v = 0;
            do {
                v = 10 * v + Character.digit(peek, 10);
                peek = nextCharacter();
            } while (Character.isDigit(peek));
            return new Num(v);
        }
        if (Character.isLetter(peek)) {
            StringBuffer b = new StringBuffer();
            do {
                b.append(peek);
                peek = nextCharacter();
            } while (Character.isLetterOrDigit(peek));
            String s = b.toString();
            Word w = (Word) words.get(s);
            if (w != null) return w;
            w = new Word(Tag.ID, s);
            words.put(s, w);
            return w;
        }
        Token t = new Token(peek);
        peek = ' ';
        return t;
    }

    private char nextCharacter() throws IOException {
        if (buffer.isEmpty()) {
            buffer.add((char) System.in.read());
        }
        return buffer.get(0);
    }

}
