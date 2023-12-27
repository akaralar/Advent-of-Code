//
//  Day15.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 18/08/2023.
//

import Foundation
import RegexBuilder
import AOCKit

class Day15: Solving {
    let regex = Regex {
        /^/
        Capture {
            OneOrMore(.word)
        }
        ": capacity "
        TryCapture {
            Optionally {
                "-"
            }
            One(.digit)
        } transform: { w in
            Int(w)
        }
        ", durability "
        TryCapture {
            Optionally {
                "-"
            }
            One(.digit)
        } transform: { w in
            Int(w)
        }
        ", flavor "
        TryCapture {
            Optionally {
                "-"
            }
            One(.digit)
        } transform: { w in
            Int(w)
        }
        ", texture "
        TryCapture {
            Optionally {
                "-"
            }
            One(.digit)
        } transform: { w in
            Int(w)
        }
        ", calories "
        TryCapture {
            Optionally {
                "-"
            }
            One(.digit)
        } transform: { w in
            Int(w)
        }
        /$/
    }
        .anchorsMatchLineEndings()

    func solvePart1(_ input: String) -> String {
        let ingredients = input.lines(matching: regex)
        let totaling100: [[Int]] = cartesianProduct(
            values: Array(1...100),
            count: ingredients.count,
            sum: 100
        )

        let maxScore = maxScore(
            amounts: totaling100,
            ingredients: ingredients
        ) { capacity, durability, flavor, texture, _ in
            capacity > 0 && durability > 0 && flavor > 0 && texture > 0
        }
        return "\(maxScore)"
    }

    func solvePart2(_ input: String) -> String {
        let ingredients = input.lines(matching: regex)
        let totaling100: [[Int]] = cartesianProduct(
            values: Array(1...100),
            count: ingredients.count,
            sum: 100
        )

        let maxScore = maxScore(
            amounts: totaling100,
            ingredients: ingredients
        ) { capacity, durability, flavor, texture, calories in
            capacity > 0 && durability > 0 && flavor > 0 && texture > 0 && calories == 500
        }
        return "\(maxScore)"
    }

    func cartesianProduct(values: [Int], count: Int, sum: Int) -> [[Int]] {
        var array: [[Int]] = []

        for _ in (0..<count) {
            if array.isEmpty {
                array = values.map { [$0] }
            } else {
                var result: [[Int]] = []
                for prev in array where prev.reduce(0, +) <= sum {
                    for value in values where prev.reduce(0, +) + value <= sum {
                        result.append(prev + [value])
                    }
                }

                array = result
            }
        }

        return array.filter { $0.reduce(0, +) == sum }
    }

    func maxScore(
        amounts: [[Int]],
        ingredients: [(Substring, Substring, Int, Int, Int, Int, Int)],
        predicate: (Int, Int, Int, Int, Int) -> Bool
    ) -> Int {

        var maxScore = 0
        for distribution in amounts {
            var capacity = 0, durability = 0, flavor = 0, texture = 0, calories = 0
            for i in 0..<ingredients.count {
                capacity += distribution[i] * ingredients[i].2
                durability += distribution[i] * ingredients[i].3
                flavor += distribution[i] * ingredients[i].4
                texture += distribution[i] * ingredients[i].5
                calories += distribution[i] * ingredients[i].6
            }

            guard predicate(capacity, durability, flavor, texture, calories) else {
                continue
            }
            maxScore = max(maxScore, capacity*durability*flavor*texture)
        }

        return maxScore
    }    
}
