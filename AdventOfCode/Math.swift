// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

extension BinaryInteger {
    func leastCommonMultiple(with other: Self) -> Self {
        self * (other / self.greatestCommonDivisor(with: other))
    }

    func greatestCommonDivisor(with other: Self) -> Self {
        let (max, min) = (max(self, other), min(self, other))
        return other == 0 ? self : min.greatestCommonDivisor(with: max % min)
    }
}

extension Collection where Element: BinaryInteger {
    func leastCommonMultiple() -> Element {
        guard let first = self.first else { return 0 }
        return dropFirst().reduce(first) { $0.leastCommonMultiple(with: $1) }
    }

    func greatestCommonDivisor() -> Element {
        guard let first = self.first else { return 0 }
        return dropFirst().reduce(first) { $0.greatestCommonDivisor(with: $1) }
    }
}
