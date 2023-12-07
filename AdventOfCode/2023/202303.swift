//
//  202303.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 03/12/2023.
//

import Foundation

extension Range where Bound == Int {
    func stringRange(_ s: any StringProtocol) -> Range<String.Index> {
        s.index(s.startIndex, offsetBy: lowerBound) ..< s.index(s.startIndex, offsetBy: upperBound)
    }

    func expand(by value: Int, max maxValue: Int) -> Range<Int> {
        Swift.max(lowerBound - value, 0) ..< Swift.min(upperBound + value, maxValue)
    }
}

extension Range where Bound == String.Index {
    func intRange(_ s: any StringProtocol) -> Range<Int> {
        let lowerDistance = s.distance(from: s.startIndex, to: lowerBound)
        let upperDistance = s.distance(from: s.startIndex, to: upperBound)
        return lowerDistance ..< upperDistance
    }
}

struct GridRange: Equatable, Hashable {
    var range: Range<String.Index>
    var row: Int
}

struct S2303: Solving {
    let symbolRegex = /[^0-9.]/
    let numberRegex = /\d+/

    let gearRegex = /\*/

    func solvePart1(_ input: String) -> String {
        let lines = input.lines
        return itemsAndNeighbors(matching: numberRegex, withNeigborsMatching: symbolRegex, in: lines)
            .filter { !$0.value.isEmpty }
            .reduce(0) { sum, next in sum + Int(lines[next.key.row][next.key.range])! }
            .asString
    }

    func solvePart2(_ input: String) -> String {
        itemsAndNeighbors(matching: gearRegex, withNeigborsMatching: numberRegex, in: input.lines)
            .filter { $0.value.count == 2 }
            .reduce(0) { sum, next in sum + (Int(next.value[0])! * Int(next.value[1])!) }
            .asString
    }

    func itemsAndNeighbors<R1: RegexComponent, R2: RegexComponent>(
        matching regex: R1,
        withNeigborsMatching neighborRegex: R2,
        in lines: [Substring]
    ) -> [GridRange: [R2.RegexOutput]] {
        var result: [GridRange: [R2.RegexOutput]] = [:]
        for (idx, line) in zip(lines.indices, lines)  {
            for match in line.matches(of: regex) {
                var linesToCheck: [Substring] = [line]
                if idx > lines.startIndex { linesToCheck.append(lines[idx-1]) }
                if idx < lines.endIndex - 1 { linesToCheck.append(lines[idx+1]) }

                let matchedNeigbors = linesToCheck
                    .flatMap { lineToCheck in
                        let neighborRange = match.range
                            .intRange(line)
                            .expand(by: 1, max: line.count)
                            .stringRange(lineToCheck)

                        return lineToCheck.matches(of: neighborRegex)
                            .filter { $0.range.overlaps(neighborRange) }
                            .map { $0.output }
                    }
                let regexMatch = GridRange(range: match.range, row: idx)
                result[regexMatch] = matchedNeigbors
            }
        }
        return result
    }
}
