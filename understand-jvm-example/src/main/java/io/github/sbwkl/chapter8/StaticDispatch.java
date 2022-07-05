package io.github.sbwkl.chapter8;

import java.util.Random;

public class StaticDispatch {

    static abstract class Human {}

    static class Man extends Human {}

    static class Woman extends Human {}

    public void sayHello(Human human) {
        System.out.println("hello, guy!");
    }
    public void sayHello(Man man) {
        System.out.println("hello, man!");
    }
    public void sayHello(Woman woman) {
        System.out.println("Hello, woman!");
    }

    public static void main(String[] args) {
        StaticDispatch sr = new StaticDispatch();
        {
            Human man = new Man();
            Human woman = new Woman();
            sr.sayHello(man);
            sr.sayHello(woman);
        }
        {
            Human human = (new Random()).nextBoolean() ? new Man() : new Woman();
            sr.sayHello((Man) human);
            sr.sayHello((Woman) human);
        }
    }
}
