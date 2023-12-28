// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

extension BinaryInteger {
    public func leastCommonMultiple(with other: Self) -> Self {
        self * (other / self.greatestCommonDivisor(with: other))
    }

    public func greatestCommonDivisor(with other: Self) -> Self {
        let (max, min) = (max(self, other), min(self, other))
        return other == 0 ? self : min.greatestCommonDivisor(with: max % min)
    }

    public func squareRoot() -> Self {
        Self(Double(self).squareRoot())
    }
}

extension Collection where Element: BinaryInteger {
    public func leastCommonMultiple() -> Element {
        guard let first = self.first else { return 0 }
        return dropFirst().reduce(first) { $0.leastCommonMultiple(with: $1) }
    }

    public func greatestCommonDivisor() -> Element {
        guard let first = self.first else { return 0 }
        return dropFirst().reduce(first) { $0.greatestCommonDivisor(with: $1) }
    }
}

extension Int {
    public func isPrime() -> Bool {
        if self == 2 { return true }
        return (2...(squareRoot() > 2 ? squareRoot() : 2))
            .lazy
            .filter({ self % $0 == 0 })
            .first == nil
    }

    public func divisors(_ predicate: ((Int, Int) -> Bool)? = nil) -> Set<Int> {
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

    public func primeFactors() -> [Int: Int] {
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


