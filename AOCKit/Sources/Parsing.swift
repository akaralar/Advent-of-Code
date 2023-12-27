//
//  Parsing.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation
import CryptoKit

extension StringProtocol {
    public var lines: [Self.SubSequence] {
        self.split(separator: "\n")
    }
}

extension StringProtocol where Self.SubSequence == Substring {
    public func lines<Regex: RegexComponent>(matching regex: Regex) -> [Regex.RegexOutput] {
        self.lines.map { $0.firstMatch(of: regex)!.output }
    }
}

public func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
