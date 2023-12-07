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
            .sorted { isStronger(lhs: $0, rhs: $1, cardStrengthMap: cardStrengthMap, joker: joker) }

        return zip(1...sortedHands.count, sortedHands.reversed())
            .reduce(0) { $0 + ($1.0 * bidsByHands[$1.1]!) }

    }

    func isStronger(
        lhs: Substring,
        rhs: Substring,
        cardStrengthMap: [Character: Int],
        joker: Character? = nil
    ) -> Bool {
        let l = cardCounts(of: lhs, with: joker)
        let r = cardCounts(of: rhs, with: joker)

        switch (l.count == r.count, l.max() == r.max()) {
        case (true, true):
            for (l, r) in zip(lhs, rhs) {
                if l == r { continue }
                return cardStrengthMap[l]! < cardStrengthMap[r]!
            }
        case (true, _): return l.max()! > r.max()!
        case (_, _): return l.count < r.count
        }
        return false
    }

    func cardCounts(of hand: Substring, with joker: Character?) -> [Int] {
        var cardsByCount = hand.reduce(into: [:]) { $0[$1, default: 0] += 1 }

        if let j = joker, let jCount = cardsByCount[j], jCount < hand.count {
            let maxCard = cardsByCount
                .filter { $0.key != j }
                .max { $0.value > $1.value }!
                .key
            cardsByCount[j] = 0
            cardsByCount[maxCard]! += jCount
        }

        return cardsByCount.values.sorted(by: >)
    }
}
