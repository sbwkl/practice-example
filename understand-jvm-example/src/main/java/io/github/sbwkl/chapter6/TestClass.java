package io.github.sbwkl.chapter6;

public class TestClass {

    private int m;

    public int incr() {
        return m + 1;
    }

    public static void main(String[] args) {
        {
            int i = 1;
            System.out.println("i = " + i);
        }
        {
            int i = 2;
            System.out.println("i = " + i);
        }
    }
}
