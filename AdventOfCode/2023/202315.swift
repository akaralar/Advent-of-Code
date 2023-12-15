// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import OrderedCollections

class S2315: Solving {
    func hash(_ str: any StringProtocol) -> Int {
        str.reduce(0) { (($0 + Int($1.asciiValue!)) * 17) % 256 }
    }

    func solvePart1(_ input: String) -> Int {
        input.split(separator: ",").map(hash(_:)).reduce(0, +)
    }

    func solvePart2(_ input: String) -> Int {
        return input.split(separator: ",")
            .map { (label: $0.prefix(while: { $0 != "=" && $0 != "-" }), last: $0.last!) }
            .reduce(into: [Int: OrderedDictionary<Substring, Int>]()) { boxes, next in
                boxes[hash(next.label), default: [:]][next.label] = Int(String(next.last))
            }
            .mapValues { d -> Int in zip(1..., d.elements.values).reduce(0) { $0 + ($1.0 * $1.1) } }
            .reduce(0) { (sum: Int, next: (Int, Int)) -> Int in sum + ((next.0 + 1) * next.1) }
    }
}
