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
                let box = hash(next.label)
                boxes[box, default: [:]][next.label] = Int(String(next.last))
            }
            .reduce(0) { sum, next in
                let (box, lenses) = next
                let boxSum = zip(1..., lenses).reduce(0) { boxSum, next in
                        let (slot, (_, focalLength)) = next
                        return boxSum + (slot * focalLength)
                    }
                return sum + ((box + 1) * boxSum)
            }
    }
}
