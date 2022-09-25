

public class Buffer {
    private int first;
    private int last;
    private int index;
    private char[] buffer;

    public Buffer() {
        first = 0;
        last = 0;
        index = 0;
        buffer = new char[1024];
    }

    public char peek() {
        if (index == last) {
            buffer[index] = System.in.read();
            last++;
        }
        char t = buffer[index];
        index++;
        return t;
    }

    public char pop() {
        char t = peek();
        first++;
        return t;
    }

    public void reset() {
        index = first;
    }

    public void clear() {
        first = 0;
        last = 0;
        index = 0;
    }
}
