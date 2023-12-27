// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import Algorithms
import AOCKit

extension Range where Bound == Int {
    func mappedAndUnmapped(with mapping: [Bound]) -> (mapped: Set<Self>, unmapped: Set<Self>) {
        let (destination, source, length) = (mapping[0], mapping[1], mapping[2])

        guard overlaps(source ..< (source + length)) else { return ([], [self]) }

        let rangeToMap = Swift.max(lowerBound, source) ..< Swift.min(upperBound, source + length)
        let mapDiff = source - destination
        let mappedRange = rangeToMap.lowerBound - mapDiff ..< rangeToMap.upperBound - mapDiff

        var unmappedRanges: Set<Range<Int>> = []
        if lowerBound < rangeToMap.lowerBound {
            unmappedRanges.insert(lowerBound ..< rangeToMap.lowerBound)
        }

        if upperBound > rangeToMap.upperBound {
            unmappedRanges.insert(rangeToMap.upperBound ..< upperBound)
        }

        return ([mappedRange], unmappedRanges)
    }
}

struct S2305: Solving {
    func solvePart1(_ input: String) -> String {
        var seedsAndMaps = input.split(separator: "\n\n")
        let seeds = seedsAndMaps.removeFirst().split(separator: " ").compactMap { Int($0) }
        let maps = seedsAndMaps.map {
            $0.lines[1...]
                .map { $0.split(separator: " ").map { Int($0)! } }
                .sorted { $0[1] > $1[1] }
        }

        var minLocation = Int.max
        for seed in seeds {
            var mappedNumber = seed
            for map in maps {
                let range = map.first(where: { mappedNumber > $0[1] })!
                mappedNumber = mappedNumber - range[1] + range[0]
            }

            minLocation = min(mappedNumber, minLocation)
        }
        return String(minLocation)
    }

    func solvePart2(_ input: String) -> String {
        var seedsAndCategories = input.split(separator: "\n\n")
        let seedRanges = seedsAndCategories
            .removeFirst()
            .split(separator: " ")
            .compactMap { Int($0) }
            .chunks(ofCount: 2)
            .map { $0.first! ..< ($0.first! + $0.last!) }

        let categories = seedsAndCategories.map {
            $0.lines[1...].map { $0.split(separator: " ").map { Int($0)! } }
        }

        var nextRound: Set<Range<Int>> = Set(seedRanges)
        for category in categories {
            var mapped: Set<Range<Int>> = []
            for map in category {
                var unmapped: Set<Range<Int>> = []
                for range in nextRound {
                    let (m, u) = range.mappedAndUnmapped(with: map)
                    mapped.formUnion(m)
                    unmapped.formUnion(u)
                }
                nextRound = unmapped
            }
            nextRound = nextRound.union(mapped).joinedIfContinuous()
        }

        return String(nextRound.map(\.lowerBound).min()!)
    }
}
