package io.github.sbwkl.chapter4;

public class JHSDBTestCase {
    static class Test {
        static ObjectHolder staticObj = new ObjectHolder();
        ObjectHolder instanceObj = new ObjectHolder();

        void foo() {
            ObjectHolder localObj = new ObjectHolder();
            System.out.println("done");
        }
    }

    public static void main(String[] args) {
        Test test = new Test();
        test.foo();
    }
}