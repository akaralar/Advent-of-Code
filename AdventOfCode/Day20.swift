//
//  Day20.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 07/09/2023.
//

import Foundation

extension Int {

    func squareRoot() -> Int {
        Int(Double(self).squareRoot())
    }

    func isPrime() -> Bool {
        if self == 2 { return true }
        return (2...(squareRoot() > 2 ? squareRoot() : 2))
            .lazy
            .filter({ self % $0 == 0 })
            .first == nil
    }

    func divisors(_ predicate: ((Int, Int) -> Bool)? = nil) -> Set<Int> {
        var divisors: Set<Int> = []
        for i in 1...squareRoot() {

            let (quotient, remainder) = self.quotientAndRemainder(dividingBy: i)
            if remainder == 0 {
                if predicate?(quotient, remainder) ?? true {
                    divisors.insert(i)
                }

                if predicate?(i, remainder) ?? true {
                    divisors.insert(quotient)
                }
            }
        }

        return divisors
    }

    func primeFactors() -> [Int: Int] {
        var primeFactors: [Int: Int] = [:]
        var number = self
        var dividingFinished = false
        for divisor in 2...squareRoot() where divisor.isPrime() && !dividingFinished {
            print("divisor: \(divisor)")
            var hasMore = true
            while hasMore {
                let (quotient, remainder) = number.quotientAndRemainder(dividingBy: divisor)
                print("quotient: \(quotient), remainder: \(remainder)")
                if remainder == 0 {
                    primeFactors[divisor, default: 0] += 1
                    number = quotient
                    if quotient == 1 {
                        dividingFinished = true
                        hasMore = false
                    }
                } else {
                    hasMore = false
                }
            }
        }

        return primeFactors
    }
}

class Day20: Solving {
    typealias Year = Y2015
    typealias Day = D20

    func runSolution1() -> Int? {
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

    func runSolution2() -> Int? {
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

    func solvePart1() -> String {
        return String(runSolution1()!)
    }

    func solvePart2() -> String {
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
    var input: String { "29000000" }
}
