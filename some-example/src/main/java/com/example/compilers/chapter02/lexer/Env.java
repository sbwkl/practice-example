package com.example.compilers.chapter02.lexer;

import java.util.Hashtable;

public class Env {
    private Hashtable<String, Symbol> table;
    protected Env prev;
    public Env(Env p) {
        table = new Hashtable<>();
        this.prev = p;
    }

    public void put(String s, Symbol sym) {
        this.table.put(s, sym);
    }

    public Symbol get(String s) {
        for (Env e = this; e != null; e = e.prev) {
            Symbol sym = e.table.get(s);
            if (sym != null) {
                return sym;
            }
        }
        return null;
    }
}
