//
//  202302.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 01/12/2023.
//

import Foundation

struct S2302: Solving {
    let gameIDRegex = /Game (\d+)/
    let cubesRegex = /(\d+) (green|blue|red)/

    func solvePart1(_ input: String) -> String {
        let limits: [Substring: Int] = [
            "green": 13,
            "blue": 14,
            "red": 12
        ]

        return input.lines.reduce(0) { sum, line in
            let (_, gameID) = line.firstMatch(of: gameIDRegex)!.output
            for (_, number, color) in line.matches(of: cubesRegex).lazy.map(\.output) {
                if limits[color]! < Int(number)! { return sum }
            }
            return sum + Int(gameID)!
        }.asString
    }

    func solvePart2(_ input: String) -> String {
        return input.lines.reduce(0) { sum, line in
            var maxes: [Substring: Int] = [:]
            for (_, number, color) in line.matches(of: cubesRegex).lazy.map(\.output) {
                maxes[color] = max(maxes[color, default: 0], Int(number)!)
            }
            return sum + maxes.values.reduce(1, *)
        }.asString
    }
}
