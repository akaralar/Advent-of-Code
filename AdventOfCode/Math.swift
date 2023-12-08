// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

func lcm(_ a: Int, _ b: Int) -> Int { a * (b / gcd(a, b)) }
func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : gcd(min(a, b), max(a, b) % min(a, b)) }
