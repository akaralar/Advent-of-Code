//
//  Day14.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 17/08/2023.
//

import Foundation
import RegexBuilder

class Day14: Solving {
    typealias Year = Y2015
    typealias Day = D14

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
    lazy var reindeers = input.lines(matching: regex)

    func solvePart1() -> String {
        let max = distances(
            after: seconds,
            reindeers: reindeers
        )
        .values
        .max()!

        return String(max)
    }
    func solvePart2() -> String {
        var points: [String: Int] = [:]
        for i in (1...seconds) {
            let distances = distances(after: i, reindeers: reindeers)
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

    var input: String {
        """
        Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
        Rudolph can fly 3 km/s for 15 seconds, but then must rest for 28 seconds.
        Donner can fly 19 km/s for 9 seconds, but then must rest for 164 seconds.
        Blitzen can fly 19 km/s for 9 seconds, but then must rest for 158 seconds.
        Comet can fly 13 km/s for 7 seconds, but then must rest for 82 seconds.
        Cupid can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
        Dasher can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
        Dancer can fly 3 km/s for 16 seconds, but then must rest for 37 seconds.
        Prancer can fly 25 km/s for 6 seconds, but then must rest for 143 seconds.
        """
    }
}
