//
//  Day13.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 17/08/2023.
//

import Foundation
import RegexBuilder

class Day13: Solving {
    let regex: Regex = Regex {
        /^/
        Capture {
            OneOrMore(.word)
        }
        " would "
        TryCapture {
            ChoiceOf {
                "lose"
                "gain"
            }
            " "
            OneOrMore(.digit)
        } transform: { str -> Int in
            let value = Int(str.components(separatedBy: " ").last!)!
            return str.hasPrefix("lose") ? -value : value
        }
        " happiness units by sitting next to "
        Capture {
            OneOrMore(.word)
        }
        "."
        /$/
    }
    .anchorsMatchLineEndings()

    func solvePart1(_ input: String) -> String {
        return String(calculateHappiness(from: input, includingMyself: false))
    }

    func solvePart2(_ input: String) -> String {
        return String(calculateHappiness(from: input, includingMyself: true))
    }

    func calculateHappiness(from input: String, includingMyself: Bool) -> Int {
        let happinessTable = input.lines
            .reduce(into: Dictionary<String, [String: Int]>()) { partialResult, substring in
                let (_, name, units, next) = substring.firstMatch(of: regex)!.output
                partialResult[String(name), default: [:]][String(next)] = units
            }
        let allPossibleArrangements = happinessTable.keys.permutations(
            ofCount: happinessTable.keys.count
        )
        
        var maxHappiness = 0
        for arrangement in allPossibleArrangements {
            var happiness = 0
            let adjacentPairs = includingMyself
                ? Array(arrangement.adjacentPairs())
                : arrangement.adjacentPairs() + [(arrangement.last!, arrangement.first!)]

            for (left, right) in adjacentPairs {
                happiness += (happinessTable[left]![right]! + happinessTable[right]![left]!)
            }

            maxHappiness = max(happiness, maxHappiness)
        }
        return maxHappiness
    }
}
