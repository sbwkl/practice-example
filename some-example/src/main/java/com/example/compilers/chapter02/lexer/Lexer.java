package com.example.compilers.chapter02.lexer;

import java.io.IOException;
import java.util.Hashtable;
import java.util.Map;

public class Lexer {
    public int line = 1;
    private char peek = ' ';
    Buffer buffer = new Buffer();
    private Map<String, Token> words = new Hashtable<>();
    void reserve(Word w) {
        words.put(w.lexeme, w);
    }
    public Lexer() {
        reserve(new Word(Tag.TRUE, "true"));
        reserve(new Word(Tag.FALSE, "false"));
    }
    public Token scan() throws IOException {
        for (; ; peek = buffer.pop()) {
            if (peek == ' ' || peek == '\t') continue;
            else if (peek == '\n') line += 1;
            else if (peek == '/') {
                char c = buffer.peek();
                if (c == '/') {
                    // comment
                    do {
                        c = buffer.peek();
                    } while (c != '\n');
                    String content = buffer.content();
                    System.out.printf("comment: %s", peek + content);
                    buffer.clear();
                    peek = ' ';
                    continue;
                } else if (c == '*') {
                    // comment
                    char p1, p2 = ' ';
                    do {
                        p1 = p2;
                        p2 = buffer.peek();
                        if (p2 == '\n') {
                            throw new RuntimeException("syntax error");
                        }
                    } while (!(p1 == '*' && p2 == '/'));
                    String content = buffer.content();
                    System.out.printf("comment: %s\n", peek + content);
                    buffer.clear();
                    peek = ' ';
                    continue;
                } else {
                    buffer.resetIndex();
                    break;
                }
            }
            else break;
        }
        if (Character.isDigit(peek)) {
            int v = 0;
            do {
                v = 10 * v + Character.digit(peek, 10);
                peek = buffer.pop();
            } while (Character.isDigit(peek));
            return new Num(v);
        }
        if (Character.isLetter(peek)) {
            StringBuffer b = new StringBuffer();
            do {
                b.append(peek);
                peek = buffer.pop();
            } while (Character.isLetterOrDigit(peek));
            String s = b.toString();
            Word w = (Word) words.get(s);
            if (w != null) return w;
            w = new Word(Tag.ID, s);
            words.put(s, w);
            return w;
        }
        if (peek == '<') {
            char c = buffer.peek();
            if (c == '=') {
                // <= Token
                Op t = new Op(Tag.LE, peek + c);
                return t;
            } else {
                buffer.resetIndex();
            }
        }
        if (peek = '!') {
            char c = buffer.peek();
            if (c == '=') {
                // !=
            } else {
                buffer.resetIndex();
            }
        }
        if (peek = '>') {
            char c = buffer.peek();
            if (c == '=') {
                // >=
            } else {
                buffer.resetIndex();
            }
        }
        Token t = new Token(peek);
        peek = ' ';
        return t;
    }
}
