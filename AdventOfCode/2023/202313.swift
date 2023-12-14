// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

class S2313: Solving {
    func solvePart1(_ input: String) -> Int {
        let patterns = input.split(separator: "\n\n")
        var total = 0
        for pattern in patterns.map(\.lines)  {
            total += count(for: pattern.map({ Array($0) }))
                .filter { !$0.value.isEmpty }
                .reduce(0, { sum, elem in
                    switch elem.key {
                    case "v": return elem.value.first!
                    case "h": return elem.value.first! * 100
                    default: return 0
                    }
                })
        }

        return total
    }

    func solvePart2(_ input: String) -> Int {
        let patterns = input.split(separator: "\n\n")
        var total = 0
        for pattern in patterns.map(\.lines) {
            total += countFixingSmudge(of: pattern.map { Array($0) })
        }

        return total
    }

    func countFixingSmudge(of pattern: [[Character]]) -> Int {
        let oldTotal = count(for: pattern)
        for (y, line) in pattern.indexed() {
            for (x, char) in line.indexed() {
                var p = pattern
                p[y][x] = char == "#" ? "." : "#"
                var total = count(for: p)

                if total.count > 0 && total != oldTotal {
                    total[oldTotal.first!.key]!.subtract(oldTotal.first!.value)
                    return total.filter { !$0.value.isEmpty }.reduce(0) { sum, elem in
                        switch elem.key {
                        case "v": return elem.value.first!
                        case "h": return elem.value.first! * 100
                        default: return 0
                        }
                    }
                }
            }
        }
        return 0
    }

    func count(for pattern: [[Character]]) -> [Character: Set<Int>] {
        var possible: [Character: Set<Int>] = [
            "h": Set(1..<(pattern.count)),
            "v": Set(1..<(pattern[0].count))
        ]

        for (y, line) in pattern.enumerated() {
            for (x, char) in line.enumerated() {
                let hOffsets = (0..<((line.count - x) / 2)).map { $0 + x + 1 }
                for mirrorOffset in possible["v"]!.intersection(hOffsets) {
                    if char != line[(x+1)+(2*(mirrorOffset-x-1))] {
                        possible["v"]?.remove(mirrorOffset)
                    }
                }

                let vOffsets = (0..<((pattern.count - y) / 2)).map({ $0 + y + 1})
                for mirrorOffset in possible["h"]!.intersection(vOffsets) {
                    let reflectedLine = pattern[((y+1)+(2*(mirrorOffset - y - 1)))]
                    if char != reflectedLine[x] {
                        possible["h"]?.remove(mirrorOffset)
                    }
                }

                if possible["h"]!.isEmpty && possible["v"]!.isEmpty {
                    return [:]
                }
            }
        }
        return possible.filter { !$0.value.isEmpty }
    }
}
