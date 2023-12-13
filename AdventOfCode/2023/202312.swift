// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import RegexBuilder
import Algorithms


class S2312: Solving {
    func solvePart1(_ input: String) -> Int {
//        let i: [Int] = [Character]().indices.filter { pattern[$0] == "?" }
        return input.lines
            .compactMap { $0.components(separatedBy: .whitespaces) }
            .map { (pattern: Array($0[0]), counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
            .map { numberOfArrangements($0.pattern, damaged: $0.counts) }
            .reduce(0, +)
//            .flatMap { (pattern, counts) in
//                let p = Array(pattern)
//                return farrangements(
//                    for: p,
//                    counts: counts /*,*/
////                    unknown: p.indices.filter { p[$0] == "?" }
//                )
//                    .map { $0.split(separator: ".").map { $0.count } }
//                    .filter { $0 == counts }
//            }


//        return records.count
    }

    func solvePart2(_ input: String) -> Int {
//        let records = input.lines
//            .compactMap { $0.components(separatedBy: .whitespaces) }
//            .map { (pattern: Array($0[0]), counts: $0[1].split(separator: ",").compactMap { Int($0) }) }
//            .flatMap { (pattern, counts) in
//                let p = Array(Array(repeating: pattern, count: 5).joined(by: "?"))
//                let c = Array(Array(repeating: counts, count: 5).joined())
//                return arrangements(for: p, counts: c)
//                    .map { $0.split(separator: ".").map { $0.count } }
//                    .filter { $0 == counts }
//            }
//
//
//        return records.count

        return 0
    }

    var cachedResults: [String: Int] = [:]
    func numberOfArrangements(_ record: [Character], damaged: [Int]) -> Int {
        let encoded = String(record) + ";" + damaged.compactMap(String.init).joined(separator: ",")
        if let cached = cachedResults[encoded] {
            return cached
        }

        let result: Int
        if record.isEmpty {
            result = damaged.isEmpty ? 1 : 0
        } else if damaged.isEmpty {
            result = record.allSatisfy { $0 != "#" } ? 1 : 0
        } else if record.filter({ $0 != "." }).count < damaged.reduce(0, +)  {
            result = 0
        } else if record.first == "." || record.last == "." {
            result = numberOfArrangements(Array(record.trimming(while: { $0 == "." })), damaged: damaged)
        } else if record.first == "?" {
            let asWorking = ["#"] + record[1...]
            let asDamaged = Array(record[1...])
            result = (
                numberOfArrangements(asWorking, damaged: damaged)
                + numberOfArrangements(asDamaged, damaged: damaged)
            )
        } else {
            let (group, groupsLeft) = (damaged[0], damaged.dropFirst())
            let groupSprings = record.prefix(upTo: group)
            if groupSprings.contains(".") {
                result = 0
            } else if group < record.count && record[group] == "#" {
                result = 0
            } else {
                let recordLeft = Array(record.dropFirst(group+1))
                result = numberOfArrangements(recordLeft, damaged: Array(groupsLeft))
            }
        }

        cachedResults[encoded] = result

        return result
    }


    var memo: [[Character]: [Int]] = [:]

    func isArrangementValid(_ record: [Character], counts: [Int], upTo index: Int) -> Bool {
//        print("record: \(String(record))")
        let ranges: [Int]
        let slice = Array(record[..<index])
        if let r = memo[slice] {
            ranges = r
        } else {
            let r = slice.ranges(of: "#").joinedRanges().map(\.count)
            memo[slice] = r
            ranges = r
        }

//        print("sliced: \(String(record[..<firstUnknown]))")
//        print("counts: \(counts)")
//        print("ranges: \(ranges)")
        guard !ranges.isEmpty else { return true }
        guard ranges.count > 1 else { return ranges.first! <= counts.first! }
        let lastIdx = min(ranges.endIndex - 1, counts.endIndex-1)
        for i in 0..<lastIdx where ranges[i] != counts[i] {
            return false
        }

        return ranges[lastIdx] <= counts[lastIdx]
    }

    func arrangements(for record: [Character], counts: [Int], unknown: [Int]) -> Int {
        guard let firstUnknown = unknown.first else { return 1 }

        let secondUnknown = unknown.dropFirst().first ?? record.endIndex
        var mutableRecord = record
        mutableRecord[firstUnknown] = "."
        var replacements: [[Character]] = []
        if isArrangementValid(mutableRecord, counts: counts, upTo: secondUnknown) { replacements.append(mutableRecord) }
        mutableRecord[firstUnknown] = "#"
        if isArrangementValid(mutableRecord, counts: counts, upTo: secondUnknown) { replacements.append(mutableRecord) }

        return replacements
            .map { arrangements(for: $0, counts: counts, unknown: Array(unknown.dropFirst())) }
            .reduce(0, +)
//            .reduce(into: Set()) { $0.formUnion($1) }
    }

    func farrangements(for record: [Character], counts: [Int]) -> Set<[Character]> {
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
}
