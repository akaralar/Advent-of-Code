//
//  Day01.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 01/12/2023.
//

import Foundation
import AOCKit

struct S2301: Solving {
    func solvePart1(_ input: String) -> Int {
        return input.lines.reduce(0) { partialResult, next in
            guard
                let first = next.first(where: \.isNumber),
                let last = next.last(where: \.isNumber)
            else {
                return partialResult
            }
            return Int("\(first)\(last)")! + partialResult
        }
    }

    func solvePart2(_ input: String) -> Int {
        let digitMapping: [String: Character] = [
            "one": "1",
            "two": "2",
            "three": "3",
            "four": "4",
            "five": "5",
            "six": "6",
            "seven": "7",
            "eight": "8",
            "nine": "9"
        ]

        let reverseMapping = digitMapping.reduce(into: [:]) { result, next in
            result[String(next.key.reversed())] = next.value
        }

        return input.lines.reduce(0) { partialResult, next in
            let first = firstDigit(next, digitTable: digitMapping)
            let last = firstDigit(String(next.reversed()), digitTable: reverseMapping)
            return Int("\(first)\(last)")! + partialResult
        }
    }

    func firstDigit(_ line: any StringProtocol, digitTable: [String: Character]) -> Character {
        let spellingTable = Dictionary(grouping: digitTable.keys, by: \.first!)

        var stringToSearch = String(line)
        while !stringToSearch.isEmpty {
            let c = stringToSearch.first!
            if c.isNumber { return c }
            if let possibleSpellings = spellingTable[c] {
                for spelling in possibleSpellings where stringToSearch.hasPrefix(spelling) {
                    return digitTable[spelling]!
                }
            }
            stringToSearch.removeFirst()
        }

        fatalError()
    }
}
