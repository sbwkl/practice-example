package io.github.sbwkl.chapter8;

import java.lang.invoke.MethodHandle;

import static java.lang.invoke.MethodHandles.lookup;
import static java.lang.invoke.MethodHandles.publicLookup;

import java.lang.invoke.MethodType;
import java.util.Arrays;
import java.util.List;

public class MethodHandleTest {

    static class A {
        public void println(String s) {
            System.out.println(s);
        }
    }

    public static void main(String[] args) throws Throwable {
        {
            Object obj = System.currentTimeMillis() % 2 == 0 ? System.out : new A();
            getPrintlnMh(obj).invokeExact("hello world");
        }
        {
            Object obj = System.currentTimeMillis() % 2 == 0 ? System.out : new A();
            MethodType mt = MethodType.methodType(void.class, String.class);
            MethodHandle printlnMH = lookup().findVirtual(obj.getClass(), "println", mt);
            printlnMH.invoke(obj, obj.getClass().getSimpleName() + " invoke" );
            printlnMH.invokeWithArguments(obj, obj.getClass().getSimpleName() + " invokeWithArguments");
        }
        {
            MethodType mt = MethodType.methodType(String.class, char.class, char.class);
            MethodHandle replaceMH = publicLookup().findVirtual(String.class, "replace", mt);
            String output = (String) replaceMH.invoke("jovo", Character.valueOf('o'), 'a');
            System.out.println(output);
        }
        {
            MethodType mt = MethodType.methodType(List.class, Object[].class);
            MethodHandle asList = publicLookup().findStatic(Arrays.class, "asList", mt);
            List<Integer> list = (List<Integer>) asList.invokeWithArguments(1,2);
            System.out.println(list);
        }
        {
            MethodType mt = MethodType.methodType(int.class, int.class, int.class);
            MethodHandle sumMH = lookup().findStatic(Integer.class, "sum", mt);
            int sum = (int) sumMH.invokeExact(1, 11);
            System.out.println(sum);
        }
    }

    private static MethodHandle getPrintlnMh(Object receiver) throws NoSuchMethodException, IllegalAccessException {
        MethodType mt = MethodType.methodType(void.class, String.class);
        return lookup().findVirtual(receiver.getClass(), "println", mt).bindTo(receiver);
    }
}
