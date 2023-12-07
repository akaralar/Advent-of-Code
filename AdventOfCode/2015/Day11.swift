//
//  Day11.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 09/08/2023.
//

import Foundation

protocol Rule {
    func isValid(input: String) -> Bool
}

struct StraightThreeRule: Rule {
    func isValid(input: String) -> Bool {
        for (first, (second, third)) in zip(
            input,
            zip(input.dropFirst(), input.dropFirst().dropFirst())
        ) {
            if first.asciiValue! + 1 == second.asciiValue!
                && second.asciiValue! + 1 == third.asciiValue!
            {
                return true
            }
        }

        return false
    }
}

struct DenyListRule: Rule {
    func isValid(input: String) -> Bool {
        !input.contains { $0 == "i" || $0 == "o" || $0 == "l" }
    }
}

struct TwoPairsRule: Rule {
    func isValid(input: String) -> Bool {
        var pairs: Dictionary<String, [Int]> = [:]
        for (offset, (first, second)) in zip(input, input.dropFirst()).enumerated() {
            guard first == second else { continue }

            let pair = "\(first)\(second)"
            if
                let pairIindices = pairs[pair],
                !pairIindices.isEmpty,
                offset - pairIindices.last! < 2
            {
                continue
            }

            pairs[pair, default: []].append(offset)

            if pairs.count >= 2 {
                return true
            }
        }

        return false
    }
}

class Day11: Solving {
    let rules: [any Rule] = [
        StraightThreeRule(),
        DenyListRule(),
        TwoPairsRule()
    ]

    func incrementLetter(_ letterIndex: Int, of input: [Character]) -> [Character] {
        let letter = input[letterIndex]
        var result = input
        // if leftmost digit is z, wrap to beginning
        if letterIndex == 0 && letter == "z" {
            return Array(repeating: "a", count: input.count)
        } else if letter == "z" {
            result = incrementLetter(letterIndex-1, of: input)
            result[letterIndex] = "a"
        } else {
            result[letterIndex] = Character(Unicode.Scalar(letter.asciiValue! + 1))
        }

        return result
    }

    func nextValidPassword(_ password: String) -> String {
        var isValid: Bool = false
        var newPass = password
        while !isValid {
            newPass = String(incrementLetter(newPass.count-1, of: Array(newPass)))
            isValid = isPasswordValid(newPass, rules: rules)
        }

        return newPass
    }
    func isPasswordValid(_ password: String, rules: [any Rule]) -> Bool {
        return rules.allSatisfy { $0.isValid(input: password) }
    }
    func solvePart1(_ input: String) -> String {
        return nextValidPassword(input)
    }

    func solvePart2(_ input: String) -> String {
        return nextValidPassword(solvePart1(input))
    }
}
