// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import RegexBuilder

struct S2306: Solving {
    let regex = Regex { Capture { OneOrMore(.digit) } transform: { w in Int(w)! } }

    func countOfWaysToBeat(_ time: Int, _ distance: Int) -> Int {
        let distances = 2 * (1...(time/2))
            .map { $0 * (time-$0) }
            .filter { $0 > distance }
            .count
        return time % 2 == 0 ? distances - 1 : distances
    }
    func solvePart1() -> String {
        let timesAndDistances = input.lines.map { $0.matches(of: regex).map(\.output.1) }

        return zip(timesAndDistances[0], timesAndDistances[1])
            .map(countOfWaysToBeat)
            .reduce(1, *)
            .asString
    }

    func solvePart2() -> String {
        let timesAndDistances = input.lines
            .compactMap { Int($0.matches(of: regex).map(\.output.0).joined()) }
        return countOfWaysToBeat(timesAndDistances[0], timesAndDistances[1]).asString
    }

    var testInput: String {
        """
        Time:      7  15   30
        Distance:  9  40  200
        """
    }
    var input: String {
        """
        Time:        42     68     69     85
        Distance:   284   1005   1122   1341
        """
    }
}
