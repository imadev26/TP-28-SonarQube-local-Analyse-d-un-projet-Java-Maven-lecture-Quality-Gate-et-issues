package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // Code Smell: Use a logger
        
        int x = 10;
        int y = 20;
        
        if (x == 10) { // Bug: Condition always true
            System.out.println("X is 10");
        }
        
        String password = "admin"; // Security Hotspot: Hardcoded password
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int subtract(int a, int b) {
        return a - b;
    }
}
