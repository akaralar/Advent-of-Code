//
//  Day20.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 07/09/2023.
//

import Foundation
import AOCKit

class Day20: Solving {
    func runSolution1(_ input: String) -> Int? {
        let target = Int(input)! / 10
        for i in 1...Int.max {
            let presents = i.divisors().reduce(0, +)
//            print(divisorsSum)
            if presents > target {
                print(presents)
                return i
            }
        }

        return nil
    }

    func runSolution2(_ input: String) -> Int? {
        let target = Int(input)! / 10

        var notFound = true
        var max = 1
        var house = 1
        while notFound {
            var presents: [Int: Int] = [:]
            for house in 1...target {
                for visit in stride(from: house, through: target, by: house) {
                    presents[visit, default: 0] += house
                }
            }

            let (maxHouse, maxValue) = presents.max { $0.value < $1.value } ?? (0, 0)
            if maxValue > Int(input)! {
                return maxHouse
            }

            print("max: \(maxHouse): \(maxValue)")

            max += 1
        }
    }

    func solvePart1(_ input: String) -> String {
        return String(runSolution1(input)!)
    }

    func solvePart2(_ input: String) -> String {
        let target = Int(input)!

        for i in 1...Int.max {
            let divisors = i.divisors({ q, r in q <= 50})
            print("\(i): \(divisors)")
            let presents = divisors.reduce(0, +) * 11


            if presents > target {
                print(presents)
                return String(i)
            }
        }

        return ""
    }
}
