package io.github.sbwkl.chapter2;

public class RuntimeConstantPoolOOM {

    public static void main(String[] args) {
        String str1 = new StringBuilder("计算机").append("软件").toString();
        System.out.println(str1.intern() == str1);
        String str2 = new StringBuilder("ja").append("va").toString();
        System.out.println(str2.intern() == str2);
        String str3 = new StringBuilder("hello").append("hello").toString();
        System.out.println(str3.intern() == str3);
    }
}
