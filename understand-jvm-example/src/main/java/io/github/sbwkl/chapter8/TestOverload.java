package io.github.sbwkl.chapter8;

import java.io.Serializable;

public class TestOverload {
    public static void sayHello(Object arg) {
        System.out.println("hello Object " + arg);
    }

    public static void sayHello(int arg) {
        System.out.println("hello int " + arg);
    }

    public static void sayHello(long arg) {
        System.out.println("hello long " + arg);
    }

    public static void sayHello(Character arg) {
        System.out.println("hello Character " + arg);
    }

//    public static void sayHello(char arg) {
//        System.out.println("hello char " + arg);
//    }

    public static void sayHello(char... arg) {
        System.out.println("hello char ..." + arg);
    }

    public static void sayHello(Serializable arg) {
        System.out.println("hello Serializable " + arg);
    }

    public static void main(String[] args) {
        sayHello('a');
    }
}
