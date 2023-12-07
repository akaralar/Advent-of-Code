// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

struct S2307: Solving {
    func solvePart1(_ input: String) -> Int {
        calculateTotalWinnings(input, cardOrder: "AKQJT98765432", joker: nil)
    }

    func solvePart2(_ input: String) -> Int {
        calculateTotalWinnings(input, cardOrder: "AKQT98765432J", joker: "J")
    }

    func calculateTotalWinnings(_ input: String, cardOrder: String, joker: Character?) -> Int {
        let bidsByHands = input.lines
            .map { $0.split(separator: " ") }
            .reduce(into: [:]) { $0[$1[0]] = Int($1[1]) }

        let cardStrengthMap: [Character: Int] = cardOrder
            .enumerated()
            .reduce(into: [:]) { $0[$1.element] = $1.offset }

        let sortedHands = bidsByHands
            .keys
            .sorted { isHigher(l: $0, r: $1, rank: cardStrengthMap, joker: joker) }

        return zip(1...sortedHands.count, sortedHands.reversed())
            .reduce(0) { $0 + ($1.0 * bidsByHands[$1.1]!) }

    }

    func isHigher(l: Substring, r: Substring, rank: [Character: Int], joker: Character?) -> Bool {
        let left = cardCounts(of: l, with: joker)
        let right = cardCounts(of: r, with: joker)

        switch (left.count == right.count, left[0] == right[0]) {
        case (true, true):
            for (leftCard, rightCard) in zip(l, r) {
                if leftCard == rightCard { continue }
                return rank[leftCard]! < rank[rightCard]!
            }
        case (true, _): return left[0] > right[0]
        case (_, _): return left.count < right.count
        }
        return false
    }

    func cardCounts(of hand: Substring, with joker: Character?) -> [Int] {
        let cardsByCount = hand.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        var countsArray = cardsByCount.filter { $0.key != joker }.values.sorted(by: >)
        if let j = joker, let jCount = cardsByCount[j] {
            if jCount == hand.count { return [jCount] }
            countsArray[0] = countsArray.first! + jCount
        }
        return countsArray
    }
}
