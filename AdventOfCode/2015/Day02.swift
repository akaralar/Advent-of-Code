//
//  Day02.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation

struct Day02: Solving {
    func solvePart1(_ input: String) -> String {
        let total = input
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: "x").compactMap { Int($0) } }
            .reduce(0) { partialResult, dimension in
                let lw = dimension[0] * dimension[1]
                let wh = dimension[1] * dimension[2]
                let lh = dimension[0] * dimension[2]

                let min = min(lw, wh, lh)

                return partialResult + ((2*lw) + (2*wh) + (2*lh) + min)
            }

        return String(total)
    }

    func shortestDistanceAround(_ dimensions: [Int]) -> Int {
        var mutable = dimensions
        mutable.remove(at: dimensions.firstIndex(of: dimensions.max()!)!)
        return 2 * mutable.reduce(0, +)
    }

    func volume(_ dimensions: [Int]) -> Int {
        dimensions.reduce(1, *)
    }

    func solvePart2(_ input: String) -> String {
        let total = input
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: "x").compactMap { Int($0) } }
            .reduce(0) { total, dimension in
                return total + (shortestDistanceAround(dimension) + volume(dimension))
            }
        return String(total)
    }
}
