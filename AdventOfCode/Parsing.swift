//
//  Parsing.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation
import CryptoKit

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }

    func lines<Regex: RegexComponent>(matching regex: Regex) -> [Regex.RegexOutput] {
        self.lines.map { $0.firstMatch(of: regex)!.output }
    }
}

extension Int {
    var asString: String {
        String(self)
    }
}



func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
