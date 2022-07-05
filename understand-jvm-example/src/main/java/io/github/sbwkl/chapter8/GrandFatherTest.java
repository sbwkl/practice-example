package io.github.sbwkl.chapter8;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Field;

public class GrandFatherTest {

    class GrandFather {
        void thinking() {
            System.out.println("i am grandfather");
        }
    }

    class Father extends GrandFather {
        void thinking() {
            System.out.println("i am father");
        }
    }

    class Son extends Father {
        void thinking() {
            try {
                {
                    MethodType mt = MethodType.methodType(void.class);
                    MethodHandle mh = MethodHandles.lookup().findSpecial(GrandFather.class, "thinking", mt, getClass());
                    System.out.print("case 1: ");
                    mh.invoke(this);
                }
                {
                    MethodType mt = MethodType.methodType(void.class);
                    Field lookupImpl = MethodHandles.Lookup.class.getDeclaredField("IMPL_LOOKUP");
                    lookupImpl.setAccessible(true);
                    MethodHandle mh = ((MethodHandles.Lookup) lookupImpl.get(null)).findSpecial(GrandFather.class, "thinking", mt, GrandFather.class);
                    System.out.print("case 2: ");
                    mh.invoke(this);
                }
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
    }

    void test() {
        Son son = new Son();
        son.thinking();
    }

    public static void main(String[] args) {
        GrandFatherTest gf = new GrandFatherTest();
        gf.test();
    }
}
