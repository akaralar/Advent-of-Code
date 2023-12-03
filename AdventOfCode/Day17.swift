//
//  Day17.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 19/08/2023.
//

import Foundation
class Day17: Solving {
    typealias Year = Y2015
    typealias Day = D17

    func solvePart1() -> String {
        let buckets = input.lines.map { Int($0)! }
        let combinations = (0..<buckets.count)
            .flatMap { buckets.combinations(ofCount: $0) }
            .filter { $0.reduce(0, +) == 150 }

        return String(combinations.count)
    }

    func solvePart2() -> String {
        let buckets = input.lines.map { Int($0)! }
        let combinations = (0..<buckets.count)
            .flatMap { buckets.combinations(ofCount: $0) }
            .filter { $0.reduce(0, +) == 150 }

        let minimumContainers = combinations.map { $0.count }.min()
        return String(combinations.filter { $0.count == minimumContainers }.count)
    }

    var input: String {
        """
        50
        44
        11
        49
        42
        46
        18
        32
        26
        40
        21
        7
        18
        43
        10
        47
        36
        24
        22
        40
        """
    }
}
