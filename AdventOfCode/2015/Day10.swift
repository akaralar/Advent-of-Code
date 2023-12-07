//
//  Day10.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 08/08/2023.
//

import Foundation

class Day10: Solving {
    func solve(input: String, iterations: Int) -> String {
        var nextInput = input
        var result: String = ""
        for _ in (0..<iterations) {
            result = lookAndSay(nextInput)
            nextInput = result
        }

        return result
    }
    func lookAndSay(_ input: String) -> String {

        var currentCharCount = 0
        var prevChar: Character? = nil
        var result = ""
        for char in input {
            guard let prev = prevChar else {
                currentCharCount += 1
                prevChar = char
                continue
            }
            if char == prev {
                currentCharCount += 1
            } else {
                result.append("\(String(currentCharCount))\(String(prev))")
                currentCharCount = 1
            }
            prevChar = char
        }

        result.append("\(String(currentCharCount))\(prevChar!)")

        return result
    }

    func solvePart1(_ input: String) -> String {
        return String(solve(input: input, iterations: 40).count)
    }

    func solvePart2(_ input: String) -> String {
        return String(solve(input: input, iterations: 50).count)
    }
}
