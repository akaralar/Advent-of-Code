// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import Algorithms
import AOCKit

struct S2311: Solving {
    func solvePart1(_ input: String) -> Int {
        totalDistance(input.lines.map(Array.init), expandingEmptyBy: 2)
    }

    func solvePart2(_ input: String) -> Int {
        totalDistance(input.lines.map(Array.init), expandingEmptyBy: 1_000_000)
    }

    func totalDistance(_ galaxies: [[Character]], expandingEmptyBy multiplier: Int) -> Int {
        struct Point: Hashable {
            let x: Int
            let y: Int
        }

        let galaxyCoordinates: Set<Point> = galaxies.enumerated()
            .reduce(into: []) { coordinates, next in
                next.element.indices
                    .filter { next.element[$0] == "#" }
                    .map { Point(x: $0, y: next.offset) }
                    .forEach { coordinates.insert($0) }
            }

        let (emptyX, emptyY) = galaxyCoordinates
            .reduce(into: (Set(galaxies[0].indices), Set(galaxies.indices))) { partial, next in
                partial.0.remove(next.x)
                partial.1.remove(next.y)
        }

        return galaxyCoordinates.combinations(ofCount: 2)
            .reduce(0) { sum, pair in
                let (left, right) = (pair[0], pair[1])
                let steps = abs(left.x - right.x) + abs(left.y - right.y)
                let emptyXCross = emptyX.intersection(min(left.x, right.x)..<max(left.x, right.x))
                let emptyYCross = emptyY.intersection(min(left.y, right.y)..<max(left.y, right.y))
                return sum + steps + (emptyXCross.count + emptyYCross.count) * (multiplier - 1)
            }
    }
}
