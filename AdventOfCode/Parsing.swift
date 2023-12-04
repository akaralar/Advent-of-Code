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

let timeFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.maximumFractionDigits = 3
    return f
}()

func format(time: Duration) -> String {
  var time = Double(time.components.seconds) + (Double(time.components.attoseconds) / 1.0e18)
  let unit: String
  if time > 1.0 {
    unit = "s"
  } else if time > 0.001 {
    unit = "ms"
    time *= 1_000
  } else if time > 0.000_001 {
    unit = "µs"
    time *= 1_000_000
  } else {
    unit = "ns"
    time *= 1_000_000_000
  }
  return timeFormatter.string(from: NSNumber(value: time))! + unit
}
