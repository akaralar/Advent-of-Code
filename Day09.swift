//
//  Day09.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 08/08/2023.
//

import Foundation
import RegexBuilder

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

    func solvePart1() async -> String {
        return String(findDistance(startingValue: .max, min))
    }

    func solvePart2() async -> String {
        return String(findDistance(startingValue: .min, max))
    }

    var input: String {
        """
Faerun to Norrath = 129
Faerun to Tristram = 58
Faerun to AlphaCentauri = 13
Faerun to Arbre = 24
Faerun to Snowdin = 60
Faerun to Tambi = 71
Faerun to Straylight = 67
Norrath to Tristram = 142
Norrath to AlphaCentauri = 15
Norrath to Arbre = 135
Norrath to Snowdin = 75
Norrath to Tambi = 82
Norrath to Straylight = 54
Tristram to AlphaCentauri = 118
Tristram to Arbre = 122
Tristram to Snowdin = 103
Tristram to Tambi = 49
Tristram to Straylight = 97
AlphaCentauri to Arbre = 116
AlphaCentauri to Snowdin = 12
AlphaCentauri to Tambi = 18
AlphaCentauri to Straylight = 91
Arbre to Snowdin = 129
Arbre to Tambi = 53
Arbre to Straylight = 40
Snowdin to Tambi = 15
Snowdin to Straylight = 99
Tambi to Straylight = 70
"""
    }
}
