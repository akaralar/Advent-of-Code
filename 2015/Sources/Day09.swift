//
//  Day09.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 08/08/2023.
//

import Foundation
import RegexBuilder
import AOCKit

class Day09: Solving {
    let regex = Regex {
        Capture {
            OneOrMore(CharacterClass(("a"..."z"), ("A"..."Z")))
        }
        " to "
        Capture {
            OneOrMore(CharacterClass(("a"..."z"), ("A"..."Z")))
        }
        " = "
        Capture {
            OneOrMore(.digit)
        }
    }

    struct Map {
        let cities: Set<String>
        let distances: [Set<String>: Int]
    }

    lazy var map: Map = {
        var cities: Set<String> = []
        var distances: [Set<String>: Int] = [:]
        for line in input.lines {
            let match = line.firstMatch(of: regex)!
            let (_, firstCity, secondCity, distance) = match.output
            cities.insert(String(firstCity))
            cities.insert(String(secondCity))
            distances[[String(firstCity), String(secondCity)]] = Int(distance)!
        }
        return Map(cities: cities, distances: distances)
    }()

    lazy var possiblePaths: Array<[String]> = {
        Array(self.map.cities.permutations(ofCount: self.map.cities.count))
    }()

    func findDistance(startingValue: Int, _ reducer: (Int, Int) -> Int) -> Int {
        var distance = startingValue
        for path in possiblePaths {
            var distanceForPermutation = 0
            for (firstCity, secondCity) in zip(path, path.dropFirst()) {
                distanceForPermutation += self.map.distances[[firstCity, secondCity]]!
            }

            distance = reducer(distance, distanceForPermutation)
        }
        return distance
    }

    var input: String = ""

    func solvePart1(_ input: String) -> String {
        self.input = input
        return String(findDistance(startingValue: .max, min))
    }

    func solvePart2(_ input: String) -> String {
        self.input = input
        return String(findDistance(startingValue: .min, max))
    }
}
