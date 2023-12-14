// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

class S2314: Solving {
    func solvePart1(_ input: String) -> Int {
        var dish: [[Character]] = input.lines.map { Array($0) }
        tiltNorth(&dish)
        return totalLoadOnNorthBeams(dish)
    }

    func solvePart2(_ input: String) -> Int {
        var dish: [[Character]] = input.lines.map { Array($0) }
        let (idx, cycle) = repeatingCycle(of: &dish)
        let x = (1_000_000_000 - idx) % cycle
        tilt(&dish, cycles: x)
        return totalLoadOnNorthBeams(dish)
    }

    func totalLoadOnNorthBeams(_ dish: [[Character]]) -> Int {
        dish.enumerated()
            .reduce(0) { $0 + ((dish.count-$1.offset) * $1.element.filter { $0 == "O" }.count) }
    }

    func tilt(_ dish: inout [[Character]], cycles: Int) {
        for _ in 0..<cycles {
            tiltNorth(&dish)
            tiltWest(&dish)
            tiltSouth(&dish)
            tiltEast(&dish)
        }
    }

    func repeatingCycle(of dish: inout [[Character]]) -> (idx: Int, cycleLength: Int) {
        var dishes: Set<[[Character]]> = []
        var lastIndex = -1
        var cyclePeriod = 0
        for i in 1... {
            tiltNorth(&dish)
            tiltWest(&dish)
            tiltSouth(&dish)
            tiltEast(&dish)
            if !dishes.insert(dish).inserted {
                if i - lastIndex > 1 {
                    if cyclePeriod == i-(lastIndex+1) {
                        return (idx: i, cycleLength: cyclePeriod)
                    }
                    cyclePeriod = i-(lastIndex+1)
                }
                lastIndex = i
                dishes.remove(dish)
            }
        }

        fatalError()
    }

    func printDish(_ dish: [[Character]], _ message: String) {
        print(message + "\n")
        print(dish.map { String($0) }.joined(separator: "\n"))
        print("------------------")
    }

    func tiltNorth(_ dish: inout [[Character]]) {
        for x in dish[0].indices {
            var previousRock = -1
            for y in dish.indices {
                if dish[y][x] == "#" {
                    previousRock = y
                } else if dish[y][x] == "O" {
                    let temp = dish[previousRock + 1][x]
                    dish[previousRock + 1][x] = dish[y][x]
                    dish[y][x] = temp
                    previousRock = previousRock + 1
                }
            }
        }
    }

    func tiltWest(_ dish: inout [[Character]]) {
        for y in dish.indices {
            var previousRock = -1
            for x in dish[0].indices {
                if dish[y][x] == "#" {
                    previousRock = x
                } else if dish[y][x] == "O" {
                    let temp = dish[y][previousRock + 1]
                    dish[y][previousRock + 1] = dish[y][x]
                    dish[y][x] = temp
                    previousRock = previousRock + 1
                }
            }
        }
    }

    func tiltSouth(_ dish: inout [[Character]]) {
        for x in dish[0].indices {
            var previousRock = dish.endIndex
            for y in dish.indices.reversed() {
                if dish[y][x] == "#" {
                    previousRock = y
                } else if dish[y][x] == "O" {
                    let temp = dish[previousRock - 1][x]
                    dish[previousRock - 1][x] = dish[y][x]
                    dish[y][x] = temp
                    previousRock = previousRock - 1
                }
            }
        }
    }

    func tiltEast(_ dish: inout [[Character]]) {
        for y in dish.indices {
            var previousRock = dish[0].endIndex
            for x in dish[0].indices.reversed() {
                if dish[y][x] == "#" {
                    previousRock = x
                } else if dish[y][x] == "O" {
                    let temp = dish[y][previousRock - 1]
                    dish[y][previousRock - 1] = dish[y][x]
                    dish[y][x] = temp
                    previousRock = previousRock - 1
                }
            }
        }
    }
}
