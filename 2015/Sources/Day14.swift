//
//  Day14.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 17/08/2023.
//

import Foundation
import RegexBuilder
import AOCKit

class Day14: Solving {
    let regex = Regex {
        /^/
        Capture {
            OneOrMore(.word)
        }
        " can fly "
        TryCapture {
            OneOrMore(.digit)
        } transform: { w in
            Int(w)
        }
        " km/s for "
        TryCapture {
            OneOrMore(.digit)
        } transform: { w in
            Int(w)
        }
        " seconds, but then must rest for "
        TryCapture {
            OneOrMore(.digit)
        } transform: { w in
            Int(w)
        }
        " seconds"
        /./
        /$/
    }
        .anchorsMatchLineEndings()

    let seconds = 2503


    func solvePart1(_ input: String) -> String {
        let max = distances(
            after: seconds,
            reindeers: input.lines(matching: regex)
        )
        .values
        .max()!

        return String(max)
    }
    func solvePart2(_ input: String) -> String {
        var points: [String: Int] = [:]
        for i in (1...seconds) {
            let distances = distances(after: i, reindeers: input.lines(matching: regex))
            let max = distances.values.max()!
            let leaders = distances
                .sorted { $0.value > $1.value }
                .prefix { $0.value == max }
                .map { $0.key }
            leaders.forEach { points[$0, default: 0] += 1 }
        }

        return String(points.values.max()!)
    }

    func distances(
        after seconds: Int,
        reindeers: [(Substring, Substring, Int, Int, Int)]
    ) -> [String: Int] {
        reindeers.reduce(into: [:]) { total, next in
            let (_, name, speed, duration, rest) = next
            let (quotient, remainder) = seconds.quotientAndRemainder(dividingBy: duration + rest)
            total[String(name)] = quotient * (speed * duration) + (speed * min(remainder, duration))
        }
    }
}
