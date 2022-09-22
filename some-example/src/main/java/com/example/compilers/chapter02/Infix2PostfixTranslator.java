package com.example.compilers.chapter02;

import java.util.Objects;

public class Infix2PostfixTranslator {

    public static void main(String[] args) {
        Parser parser = new Parser("9 - 5 + 2");
        parser.expr();
        System.out.println();
    }

    static class Parser {
        int lookahead;
        int lookaheadIndex;
        String input;
        Parser(String input) {
            this.input = input;
            lookaheadIndex = 0;
            lookahead = input.charAt(lookaheadIndex);
        }

        void expr() {
            term();
            while(true) {
                if (lookahead == '+') {
                    match('+');
                    term();
                    System.out.print('+');
                } else if (lookahead == '-') {
                    match('-');
                    term();
                    System.out.print('-');
                } else {
                    return;
                }
            }
        }

        void term() {
            if (Character.isDigit((char) lookahead)) {
                char t = (char) lookahead;
                match(lookahead);
                System.out.print(t);
            } else {
                throw new RuntimeException("syntax error");
            }
        }

        void match(int t) {
            if (lookahead == t) {
                lookahead = nextTerminal();
            } else {
                throw new RuntimeException("syntax error");
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
    }
}
