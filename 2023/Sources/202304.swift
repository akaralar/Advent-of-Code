//
//  202304.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 04/12/2023.
//

import Foundation
import RegexBuilder
import AOCKit

struct S2304: Solving {
    let regex = Regex { Capture { OneOrMore(.digit) } transform: { w in Int(w)! } }
    func solvePart1(_ input: String) -> Int {
        input.lines
            .reduce(0) { sum, line in
                let numbers = line.split(separator: ":")
                    .flatMap { $0.split(separator: "|") }
                    .map { $0.matches(of: regex).map(\.output.1) }
                return sum + Set(numbers[1])
                    .intersection(Set(numbers[2]))
                    .reduce(0) { points, _ in points == 0 ? 1 : points * 2 }
            }
    }
    
    func solvePart2(_ input: String) -> Int {
        let lines = input.lines
        return lines
            .reduce(into: Array(repeating: 1, count: lines.count)) { earned, line in
                let numbers = line.split(separator: ":")
                    .flatMap { $0.split(separator: "|") }
                    .map { $0.matches(of: regex).map(\.output.1) }
                let card = numbers[0][0]
                earned = Set(numbers[1])
                    .intersection(Set(numbers[2]))
                    .enumerated()
                    .reduce(into: earned) { earned, next in
                        earned[card+next.0] += earned[card-1]
                    }
            }
            .reduce(0, +)
    }
}
