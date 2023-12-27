// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import AOCKit

public struct S2308: Solving {
    let regex = /(\w+) = \((\w+), (\w+)\)/
    public func solvePart1(_ input: String) -> Int {
        let (instructions, map) = instructionsAndMap(input)
        return steps(start: "AAA", end: { $0 == "ZZZ" }, instructions: instructions, map: map)
    }

    public func solvePart2(_ input: String) -> Int {
        let (instructions, map) = instructionsAndMap(input)
        return map.keys
            .filter { $0.last == "A" }
            .map { steps(start: $0, end: { $0.last == "Z" }, instructions: instructions, map: map) }
            .leastCommonMultiple()
    }

    func instructionsAndMap(_ input: String) -> (Substring, [Substring: [Character: Substring]]) {
        let lines = input.lines
        return (
            lines[0],
            lines.compactMap { $0.firstMatch(of: regex)?.output }
                .reduce(into: [:]) { $0[$1.1] = ["L": $1.2, "R": $1.3] }
        )
    }

    func steps(
        start node: Substring,
        end predicate: (Substring) -> Bool,
        instructions: Substring,
        map: [Substring: [Character: Substring]]
    ) -> Int {
        var lookupResult = node
        return 1 + instructions.cycled().enumerated().first { (_, leftOrRight) in
                lookupResult = map[lookupResult]![leftOrRight]!
                return predicate(lookupResult)
            }!.offset
    }
}
