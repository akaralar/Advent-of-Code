//
//  Parsing.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }

    func lines<Regex: RegexComponent>(matching regex: Regex) -> [Regex.RegexOutput] {
        self.lines.map { $0.firstMatch(of: regex)!.output }
    }
}
