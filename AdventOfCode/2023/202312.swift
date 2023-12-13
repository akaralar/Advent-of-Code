// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import RegexBuilder
import Algorithms


class S2312: Solving {
    func solvePart1(_ input: String) -> Int {
        return input.lines
            .compactMap { $0.components(separatedBy: .whitespaces) }
            .map { (pattern: Array($0[0]), counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
            .map { arrangements($0.pattern, $0.counts) }
            .reduce(0, +)
    }

    func solvePart2(_ input: String) -> Int {
        return input.lines
            .compactMap { $0.components(separatedBy: .whitespaces) }
            .map { (pattern: Array($0[0]), counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
            .map {
                let p = Array(Array(repeating: $0.pattern, count: 5).joined(by: "?"))
                let c = Array(Array(repeating: $0.counts, count: 5).joined())
                return arrangements(p, c)
            }
            .reduce(0, +)
    }

    var cachedResults: [String: Int] = [:]
    func arrangements(_ record: [Character], _ counts: [Int]) -> Int {
        let encoded = String(record) + ";" + counts.compactMap(String.init).joined(separator: ",")
        if let cached = cachedResults[encoded] {
            return cached
        }

        let result: Int
        if record.isEmpty {
            result = counts.isEmpty ? 1 : 0
        } else if counts.isEmpty {
            result = record.allSatisfy { $0 != "#" } ? 1 : 0
        } else if record.filter({ $0 != "." }).count < counts.reduce(0, +)  {
            result = 0
        } else if record.first == "." || record.last == "." {
            result = arrangements(Array(record.trimming(while: { $0 == "." })), counts)
        } else if record.first == "?" {
            let asWorking = ["#"] + record[1...]
            let asDamaged = Array(record[1...])
            result = arrangements(asWorking, counts) + arrangements(asDamaged, counts)
        } else {
            if record.prefix(upTo: counts[0]).contains(".") {
                result = 0
            } else if counts[0] < record.count && record[counts[0]] == "#" {
                result = 0
            } else {
                let recordLeft = Array(record.dropFirst(counts[0]+1))
                result = arrangements(recordLeft, Array(counts.dropFirst()))
            }
        }

        cachedResults[encoded] = result

        return result
    }
}
