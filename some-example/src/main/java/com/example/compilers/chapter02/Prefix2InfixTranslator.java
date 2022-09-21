package com.example.compilers.chapter02;

import java.util.Objects;

/**
 * S -> + S S
 *    | - S S
 *    | 0 | 1 | 2 | 3 | 4
 */
public class Prefix2InfixTranslator {

    private char lookahead;
    private int lookaheadIndex = 0;
    private final String input = "- 2 + 1 + - 0 3 4";

    public static void main(String[] args) {
        new Prefix2InfixTranslator().parse();
    }

    public void parse() {
        lookahead = input.charAt(lookaheadIndex);
        Node root = s();
        System.out.printf("infix expr: %s\neval value: %s\n", root.t, root.v);
    }

    public Node s() {
        Node node = new Node();
        Node s1, s2;
        switch (lookahead) {
            case '+':
                match('+');
                s1 = s();
                s2 = s();
                node.t = String.format("(%s + %s)", s1.t, s2.t);
                node.v = s1.v + s2.v;
                break;
            case '-':
                match('-');
                s1 = s();
                s2 = s();
                node.t = String.format("(%s - %s)", s1.t, s2.t);
                node.v = s1.v - s2.v;
                break;
            case '0':
                match('0');
                node.t = "0";
                node.v = 0;
                break;
            case '1':
                match('1');
                node.t = "1";
                node.v = 1;
                break;
            case '2':
                match('2');
                node.t = "2";
                node.v = 2;
                break;
            case '3':
                match('3');
                node.t = "3";
                node.v = 3;
                break;
            case '4':
                match('4');
                node.t = "4";
                node.v = 4;
                break;
            case '\0':
                break;
            default:
                throw new RuntimeException("Syntax error");
        }
        return node;
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
