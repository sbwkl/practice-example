import time
import cmarkgfm
import markdown
import markdown2
import mistune
import commonmark

def run_benchmark(library_name, convert_func, markdown_text, iterations=10):
    total_time = 0
    for _ in range(iterations):
        start_time = time.time()
        convert_func(markdown_text)
        end_time = time.time()
        total_time += (end_time - start_time)
    return total_time / iterations

if __name__ == '__main__':
    markdown_text = """
# In hac habitasse platea dictumst

## In hac habitasse platea dictumst

### In hac habitasse platea dictumst

#### In hac habitasse platea dictumst

##### In hac habitasse platea dictumst

###### In hac habitasse platea dictumst

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis,
diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla
justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.
Suspendisse accumsan tortor quis turpis. Sed ante. Sed vel lectus. Donec odio
urna, tempus molestie, porttitor ut, iaculis quis, sem.

Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum
fermentum tortor id mi. Pellentesque egestas, neque sit amet convallis pulvinar,
enim justo euismod enim, quis finibus nulla quam ut dolor.

Nam convallis pellentesque nisl. Integer malesuada commodo nulla. Aenean in
lorem.

---

Donec posuere, erat vel facilisis tristique, sem sapien malesuada dui, vel
suscipit quam diam non turpis. Proin leo. Suspendisse potenti.

Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel euismod
sapien libero ac sapien. Maecenas vitae ex a neque tincidunt ullamcorper.

- Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel euismod
  sapien libero ac sapien.
- Maecenas vitae ex a neque tincidunt ullamcorper.
- In hac habitasse platea dictumst.
- Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec
  condimentum neque sapien placerat ante.
- Nulla justo.

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

1.  Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel
    euismod sapien libero ac sapien.
2.  Maecenas vitae ex a neque tincidunt ullamcorper.
3.  In hac habitasse platea dictumst.
4.  Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec
    condimentum neque sapien placerat ante.
5.  Nulla justo.

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

> Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel euismod
> sapien libero ac sapien. Maecenas vitae ex a neque tincidunt ullamcorper.

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

`Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel euismod
sapien libero ac sapien.`

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

```python
import time
import cmarkgfm
import markdown
import markdown2
import mistune
import commonmark

def run_benchmark(library_name, convert_func, markdown_text, iterations=10):
    total_time = 0
    for _ in range(iterations):
        start_time = time.time()
        convert_func(markdown_text)
        end_time = time.time()
        total_time += (end_time - start_time)
    return total_time / iterations
```

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

| Ut aliquam, massa eget maximus laoreet, lectus est rhoncus nisi, vel euismod |
| :------------------------------------------------------------------------- |
| Maecenas vitae ex a neque tincidunt ullamcorper.                           |
| In hac habitasse platea dictumst.                                          |
| Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec |
| condimentum neque sapien placerat ante.                                    |

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

[Maecenas vitae ex a neque tincidunt ullamcorper.](https://example.com)

Pellentesque egestas, neque sit amet convallis pulvinar, enim justo euismod
enim, quis finibus nulla quam ut dolor. Nam convallis pellentesque nisl.

![Maecenas vitae ex a neque tincidunt ullamcorper.](https://example.com)
"""

    libraries = {
        'cmarkgfm': lambda text: cmarkgfm.github_flavored_markdown_to_html(text),
        'markdown': lambda text: markdown.markdown(text),
        'markdown2': lambda text: markdown2.markdown(text),
        'mistune': lambda text: mistune.html(text),
        'commonmark': lambda text: commonmark.commonmark(text),
    }

    results = {}
    for name, func in libraries.items():
        avg_time = run_benchmark(name, func, markdown_text)
        results[name] = avg_time
        print(f'{name}: {avg_time:.6f} seconds')

    import json
    with open('python-markdown-comparison/results.json', 'w') as f:
        json.dump(results, f)
