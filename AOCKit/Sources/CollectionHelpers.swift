// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

extension Set where Element == Range<Int> {
    public func joinedIfContinuous() -> Self {
        if count < 2 { return self }
        return Self(
            self.sorted { $0.lowerBound < $1.lowerBound }
                .reduce(into: Array<Range<Int>>()) { partial, next in
                    if let last = partial.last, last.upperBound == next.lowerBound {
                        partial[partial.endIndex - 1] = last.lowerBound ..< next.upperBound
                    } else {
                        partial.append(next)
                    }
                }
        )
    }
}

extension Array where Element == Range<Int> {
    public func joinedRanges() -> Self {
        if count < 2 { return self }
        return Self(
            self.sorted { $0.lowerBound < $1.lowerBound }
                .reduce(into: Array<Range<Int>>()) { partial, next in
                    if let last = partial.last, last.upperBound == next.lowerBound {
                        partial[partial.endIndex - 1] = last.lowerBound ..< next.upperBound
                    } else {
                        partial.append(next)
                    }
                }
        )
    }
}
