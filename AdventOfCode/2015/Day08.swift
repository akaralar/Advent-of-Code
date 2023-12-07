//
//  Day08.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 07/08/2023.
//

import Foundation
import RegexBuilder

struct Day08: Solving {
    let regex = Regex {
        Capture {
            OneOrMore(.anyOf("\\"))
        }
        "x"
        Capture {
            CharacterClass(
                ("0"..."9"),
                ("a"..."f"),
                ("A"..."F")
            )
            CharacterClass(
                ("0"..."9"),
                ("a"..."f"),
                ("A"..."F")
            )
        }
    }

    func solvePart1(_ input: String) -> String {
        var diff = 0
        for line in input.lines {
            let trimmed = line.dropFirst().dropLast()
            let escapedRegex = trimmed.replacing(regex) { match in
                let (full, slashes, hex) = match.output

                // if the slash count is multiple of 2, they are gonna be escaped so we can't
                // use hex matching
                guard slashes.count % 2 == 1 else { return String(full) }

                let stringFromHex: (any StringProtocol) -> String = { hex in
                    let scalar = Int(hex, radix: 16)!
                    return "\(String(slashes.dropLast()))\(String(Unicode.Scalar(scalar)!))"
                }

                return stringFromHex(hex)
            }

            let escaped = escapedRegex
                .replacingOccurrences(of: #"\\"#, with: #"\"#)
                .replacingOccurrences(of: #"\""#, with: #"""#)

            diff += line.count - escaped.count
        }

        return String(diff)
    }

    func solvePart2(_ input: String) -> String {
        var diff = 0
        for line in input.lines {
            diff += line.filter { $0 == "\"" || $0 == "\\" }.count + 2
        }

        return String(diff)
    }
}
