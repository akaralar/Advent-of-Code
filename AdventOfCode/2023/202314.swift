// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import Algorithms

class S2314: Solving {
    func solvePart1(_ input: String) -> Int {
        var dish: [[Character]] = input.lines.map { Array($0) }
        tilt(&dish, towards: "N")
        return totalLoadOnNorthBeams(dish)
    }

    func solvePart2(_ input: String) -> Int {
        var dish: [[Character]] = input.lines.map { Array($0) }
        let (idx, freq) = repeatingFrequency(of: &dish)
        let x = (1_000_000_000 - idx) % freq
        ["N", "W", "S", "E"].cycled(times: x).forEach { tilt(&dish, towards: $0) }
        return totalLoadOnNorthBeams(dish)
    }

    func totalLoadOnNorthBeams(_ dish: [[Character]]) -> Int {
        dish.enumerated()
            .reduce(0) { $0 + ((dish.count-$1.offset) * $1.element.filter { $0 == "O" }.count) }
    }

    func repeatingFrequency(of dish: inout [[Character]]) -> (idx: Int, cycleLength: Int) {
        var dishes: Set<[[Character]]> = []
        var lastIndex = -1
        var cyclePeriod = 0
        for i in 1... {
            ["N", "W", "S", "E"].forEach { tilt(&dish, towards: $0) }
            if !dishes.insert(dish).inserted {
                if i - lastIndex > 1 {
                    if cyclePeriod == i-(lastIndex+1) { return (idx: i, cycleLength: cyclePeriod) }
                    cyclePeriod = i-(lastIndex+1)
                }
                lastIndex = i
                dishes.remove(dish)
            }
        }

        fatalError()
    }

    func tilt(_ dish: inout [[Character]], towards direction: Character) {
        func parameters(for direction: Character, dish d: [[Character]]) -> (
            Range<Int>,
            Range<Int>,
            Int,
            (Int, Int) -> (Int, Int),
            (Int, Int, Int) -> (Int, Int)
        ) {
            switch direction {
            case "N": (d[0].indices, d.indices, 1, { i, j in (i, j) }, { x, y, p in (x, p)})
            case "W": (d.indices, d[0].indices, 1, { i, j in (j, i) }, { x, y, p in (p, y)})
            case "S": (d[0].indices, d.indices, -1, { i, j in (i, j) }, { x, y, p in (x, p)})
            case "E": (d.indices, d[0].indices, -1, { i, j in (j, i) }, { x, y, p in (p, y)})
            default: fatalError()
            }
        }
        let (outer, inner, diff, xy, xyp) = parameters(for: direction, dish: dish)
        let inn = diff < 0 ? Array(inner.reversed()) : Array(inner)
        for i in outer {
            var previousRock = inn.first! - diff
            for j in inn {
                let (x, y) = xy(i, j)
                if dish[y][x] == "#" {
                    previousRock = j
                } else if dish[y][x] == "O" {
                    let (xp, yp) = xyp(x, y, previousRock + diff)
                    let swap = dish[yp][xp]
                    dish[yp][xp] = dish[y][x]
                    dish[y][x] = swap
                    previousRock += diff
                }
            }
        }
    }
}
