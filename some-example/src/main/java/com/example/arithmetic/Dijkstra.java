package com.example.arithmetic;


import com.google.common.collect.Sets;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class Dijkstra {

    public static void main(String[] args) {
        int[][] weights = new int[][]{
                {0,  4, 0,  0,  0,  0, 0,  8, 0},
                {4,  0, 8,  0,  0,  0, 0, 11, 0},
                {0,  8, 0,  7,  0,  4, 0,  0, 2},
                {0,  0, 7,  0,  9, 14, 0,  0, 0},
                {0,  0, 0,  9,  0, 10, 0,  0, 0},
                {0,  0, 4, 14, 10,  0, 2,  0, 0},
                {0,  0, 0,  0,  0,  2, 0,  1, 6},
                {8, 11, 0,  0,  0,  0, 1,  0, 7},
                {0,  0, 2,  0,  0,  0, 6,  7, 0}};
        List<Integer> path = findPath(weights, 1, 7);
        System.out.println(path.stream().map(Object::toString).collect(Collectors.joining(" -> ")));
    }

    static List<Integer> findPath(int[][] weights, int start, int destination) {
        int vertexSize = weights.length;
        double[][] graph = convert(weights);
        Set<Integer> vertex = initVertex(vertexSize);
        Map<Integer, Double> currentDistance = initCurrentDistance(start, vertexSize);
        Map<Integer, Double> shortestDistance = new HashMap<>();
        Map<Integer, List<Integer>> shortestPath = initPath(vertexSize);
        while (!shortestDistance.containsKey(destination)) {
            int u = minVertex(currentDistance);
            shortestDistance.put(u, currentDistance.get(u));
            currentDistance.remove(u);
            for(int v : Sets.difference(vertex, shortestDistance.keySet())) {
                if(shortestDistance.get(u) + graph[u][v] < currentDistance.get(v)) {
                    currentDistance.put(v, shortestDistance.get(u) + graph[u][v]);
                    List<Integer> uPath = new ArrayList<>(shortestPath.get(u));
                    uPath.add(v);
                    shortestPath.put(v, uPath);
                }
            }
        }
        System.out.printf("shortest length: %f\n", shortestDistance.get(destination));
        return shortestPath.get(destination);
    }

    private static Map<Integer, Double> initCurrentDistance(int start, int vertexSize) {
        Map<Integer, Double> currentDistance = new HashMap<>();
        for (int i = 0; i < vertexSize; i++) {
            currentDistance.put(i, Double.POSITIVE_INFINITY);
        }
        currentDistance.put(start, 0.0);
        return currentDistance;
    }

    private static Set<Integer> initVertex(int vertexSize) {
        Set<Integer> vertex = new HashSet<>();
        for (int i = 0; i < vertexSize; i++) {
            vertex.add(i);
        }
        return vertex;
    }
    private static Map<Integer, List<Integer>> initPath(int vertexSize) {
        Map<Integer, List<Integer>> currentDistance = new HashMap<>();
        for (int i = 0; i < vertexSize; i++) {
            List<Integer> l = new ArrayList<>();
            l.add(i);
            currentDistance.put(i, l);
        }
        return currentDistance;
    }

    // int 没有 infinity 处理起来略蛋疼
    private static double[][] convert(int[][] weights) {
        double[][] graph = new double[weights.length][weights.length];
        for (int i = 0; i < weights.length; i++) {
            for (int j = 0; j < weights.length; j++) {
                if (weights[i][j] != 0) {
                    graph[i][j] = weights[i][j];
                } else {
                    graph[i][j] = Double.POSITIVE_INFINITY;
                }
            }
        }
        return graph;
    }

    private static int minVertex(Map<Integer, Double> mapper) {
        Map.Entry<Integer, Double> min = Collections.min(mapper.entrySet(),
                Map.Entry.comparingByValue());
        return min.getKey();
    }
}
