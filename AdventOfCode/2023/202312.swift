// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import RegexBuilder
import Algorithms

struct S2312: Solving {
    func solvePart1(_ input: String) -> Int {
        let records = input.lines
            .compactMap { $0.components(separatedBy: .whitespaces) }
            .map { (pattern: $0[0], counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
            .flatMap { (pattern, counts) in
                arrangements(for: Array(pattern), counts:counts)
                    .map { $0.split(separator: ".").map { $0.count } }
                    .filter { $0 == counts }
            }


        return records.count
    }

    func solvePart2(_ input: String) -> Int {
        let records = input.lines
            .compactMap { $0.components(separatedBy: .whitespaces) }
            .map { (pattern: Array($0[0]), counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
            .flatMap { (pattern, counts) in
                let p = Array(Array(repeating: pattern, count: 5).joined(by: "?"))
                let c = Array(Array(repeating: counts, count: 5).joined())
                return arrangements(
                    for: p,
                    counts: c
                )
                    .map { $0.split(separator: ".").map { $0.count } }
                    .filter { $0 == counts }
            }


        return records.count

    }

    func regex(_ counts: [Int]) -> Regex<Substring> {
        let expressions = counts
            .map { Repeat(count: $0) { "#" } }
            .interspersed(with: Repeat(1...) {"."} )
            .map { RegexComponentBuilder.buildExpression($0) }

        return Regex {
            /^/
            ZeroOrMore { "." }
            expressions.dropFirst()
                .reduce(
                    RegexComponentBuilder.buildPartialBlock(first: expressions[0]),
                    RegexComponentBuilder.buildPartialBlock(accumulated:next:)
                )
            ZeroOrMore { "." }
            /$/
        }
    }

    func arrangements(for record: [Character], counts: [Int]) -> Set<[Character]> {
        let unknownIndices = record.indices.filter { record[$0] == "?" }
        let damaged = record.filter { $0 == "#" }.count
        let total = counts.reduce(0, +)

        let unknownDamaged = total-damaged
        let replacement = (
            String(repeating: "#", count: unknownDamaged)
            + 
            String(repeating: ".", count: unknownIndices.count - (unknownDamaged))
        )

        let arr = Array(record)
        return replacement.uniquePermutations()
            .reduce(into: Set<[Character]>()) { replaced, next in
                replaced.insert(
                    zip(unknownIndices, next)
                        .reduce(into: arr) { result, unknown in
                            result[unknown.0] = unknown.1
                        }
                )
            }
    }

    func arrangements(for record: String, regex: Regex<Substring>) -> [String] {
        guard let range = record.firstRange(of: /\?/) else {
            if let _ = record.firstMatch(of: regex) {
                return [record]
            }
            return []
        }
        return (
            arrangements(for: record.replacingCharacters(in: range, with: "."), regex: regex)
            +
            arrangements(for: record.replacingCharacters(in: range, with: "#"), regex: regex)
        )
    }
}
