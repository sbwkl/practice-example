import json
import matplotlib.pyplot as plt

def generate_chart(results_path, output_path):
    with open(results_path) as f:
        results = json.load(f)

    libraries = list(results.keys())
    times = list(results.values())

    plt.figure(figsize=(10, 6))
    plt.bar(libraries, times, color='skyblue')
    plt.xlabel('Markdown Library')
    plt.ylabel('Average Time (seconds)')
    plt.title('Performance Comparison of Python Markdown Libraries')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(output_path)

if __name__ == '__main__':
    generate_chart(
        'python-markdown-comparison/results.json',
        'python-markdown-comparison/performance_chart.png'
    )
