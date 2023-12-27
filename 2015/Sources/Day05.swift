//
//  Day05.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 04/08/2023.
//

import Foundation
import Algorithms
import AOCKit

struct Day05: Solving {
    func solvePart1(_ input: String) -> String {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        let denyList: Set<String> = ["ab", "cd", "pq", "xy"]

        var niceLines: Int = 0
        input.enumerateLines { line, stop in
            var twiceInARow: Bool = false
            var vowelsInLine: [Character] = []

            for (first, second) in zip(line, line.dropFirst()) {
                let seq = "\(first)\(second)"
                print(seq)
                if denyList.contains(seq) { return }
                if first == second { twiceInARow = true }
                if vowelsInLine.isEmpty && vowels.contains(first) { vowelsInLine.append(first) }
                if vowels.contains(second) { vowelsInLine.append(second) }
            }

            if twiceInARow && vowelsInLine.count >= 3  {
                niceLines += 1 }
        }

        return String(niceLines)
    }

    func solvePart2(_ input: String) -> String {

        var niceLines: Int = 0
        input.enumerateLines { line, stop in
            let pairs = Array(zip(line, line.dropFirst()))

            var result: Dictionary<String, Int> = [:]
            var hasRepeatedLetter = false
            var hasPair = false
            for (pair, i) in zip(pairs, pairs.indices) where hasPair == false || hasRepeatedLetter == false {
                let pairString = "\(pair.0)\(pair.1)"
                if let prevIndex = result[pairString], i > prevIndex + 1 {
                    hasPair = true
                } else {
                    result[pairString] = i
                }

                if i < pairs.endIndex - 1 && (pair.0 == pairs[i+1].1) {
                    hasRepeatedLetter = true
                }
            }

            if hasRepeatedLetter && hasPair {
                niceLines += 1
            }
        }

        return String(niceLines)

    }
}
