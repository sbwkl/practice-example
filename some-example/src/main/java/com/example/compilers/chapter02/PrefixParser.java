package com.example.compilers.chapter02;

import java.util.Objects;

/**
 * S -> + S S
 *    | - S S
 *    | 0 | 1 | 2 | 3 | 4
 */
public class PrefixParser {

    private char lookahead;
    private int lookaheadIndex = 0;
    private final String input = "- 2 + 1 + - 2 4 4";

    public static void main(String[] args) {
        new PrefixParser().parse();
    }

    public void parse() {
        lookahead = input.charAt(lookaheadIndex);
        s();
    }

    public void s() {
        switch (lookahead) {
            case '+':
                match('+');
                s();
                s();
                break;
            case '-':
                match('-');
                s();
                s();
                break;
            case '0':
                match('0');
                break;
            case '1':
                match('1');
                break;
            case '2':
                match('2');
                break;
            case '3':
                match('3');
                break;
            case '4':
                match('4');
                break;
            case '\0':
                break;
            default:
                throw new RuntimeException("Syntax error");
        }
    }

    public void match(char terminal) {
        if (Objects.equals(lookahead, terminal)) {
            lookahead = nextTerminal();
        } else {
            throw new RuntimeException("Syntax error");
        }
    }

    public char nextTerminal() {
        char t = ' ';
        while (Objects.equals(t, ' ')) {
            lookaheadIndex++;
            if (lookaheadIndex >= input.length()) {
                t = '\0';
                break;
            }
            t = input.charAt(lookaheadIndex);
        }
        return t;
    }

    public static class Node {
        public String t;
        public int v;
    }
}
