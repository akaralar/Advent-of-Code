//
//  Day16.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 19/08/2023.
//

import Foundation
import RegexBuilder

class Day16: Solving {
    let regex = Regex {
        TryCapture {
          ChoiceOf {
            "children"
            "cats"
            "samoyeds"
            "pomeranians"
            "akitas"
            "vizslas"
            "goldfish"
            "trees"
            "cars"
            "perfumes"
          }
        } transform: { w in
            String(w)
        }
        ": "
        TryCapture {
            OneOrMore(.digit)
        } transform: { w in
            String(w)
        }
      }
      .anchorsMatchLineEndings()

    lazy var message: [String: String] = {
        let input = """
        children: 3
        cats: 7
        samoyeds: 2
        pomeranians: 3
        akitas: 0
        vizslas: 0
        goldfish: 5
        trees: 3
        cars: 2
        perfumes: 1
        """

        return input.lines.reduce(into: [:]) { partialResult, line in
            let compoundAndValue = line.components(separatedBy: ": ")
            partialResult[compoundAndValue.first!] = compoundAndValue.last!
        }
    }()

    func solvePart1(_ input: String) -> String {
        let senderAunt = input.lines
            .filter { line in
                for match in line.matches(of: regex) {
                    let (_, compound, amount) = match.output
                    if let senderAmount = message[compound], senderAmount == amount {
                        continue
                    }
                    return false
                }
                return true
            }
        return "\(senderAunt)"
    }

    func solvePart2(_ input: String) -> String {
        let senderAunt = input.lines
            .filter { line in
                for match in line.matches(of: regex) {
                    let (_, compound, amount) = match.output
                    if let senderAmount = message[compound] {
                        switch compound {
                        case "cats", "trees": if senderAmount < amount { continue }
                        case "pomeranians", "goldfish": if senderAmount > amount { continue }
                        default: if senderAmount == amount { continue }
                        }
                    }
                    return false
                }
                return true
            }
        return "\(senderAunt)"
    }
}
