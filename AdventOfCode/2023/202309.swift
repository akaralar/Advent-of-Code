// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import Algorithms

struct S2309: Solving {
    func solvePart1(_ input: String) -> Int {
        return input.lines
            .map { $0.split(separator: " ").compactMap{ Int($0) } }
            .map { findSum(of: $0, extrapolating: \.last!, reducingBy: +) }
            .reduce(0, +)
    }

    func solvePart2(_ input: String) -> Int {
        return input.lines
            .map { $0.split(separator: " ").compactMap{ Int($0) } }
            .map { findSum(of: $0, extrapolating: \.first!, reducingBy: { $1 - $0 }) }
            .reduce(0, +)
    }

    func findSum(
        of history: [Int],
        extrapolating mapper: ([Int]) -> Int,
        reducingBy reducer: (Int, Int) -> Int
    ) -> Int {
        var sequences = [history]
        repeat {
            sequences.append(sequences.last!.adjacentPairs().map { $1 - $0 })
        } while !sequences.last!.allSatisfy { $0 == 0 }
        return sequences.reversed().map(mapper).reduce(0, reducer)
    }
}
