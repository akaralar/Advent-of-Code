//
//  Day17.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 19/08/2023.
//

import Foundation
import AOCKit

class Day17: Solving {
    func solvePart1(_ input: String) -> String {
        let buckets = input.lines.map { Int($0)! }
        let combinations = (0..<buckets.count)
            .flatMap { buckets.combinations(ofCount: $0) }
            .filter { $0.reduce(0, +) == 150 }

        return String(combinations.count)
    }

    func solvePart2(_ input: String) -> String {
        let buckets = input.lines.map { Int($0)! }
        let combinations = (0..<buckets.count)
            .flatMap { buckets.combinations(ofCount: $0) }
            .filter { $0.reduce(0, +) == 150 }

        let minimumContainers = combinations.map { $0.count }.min()
        return String(combinations.filter { $0.count == minimumContainers }.count)
    }
}
