// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation


extension Direction {
    func directions(after object: Character) -> Set<Direction> {
        switch object {
        case "/" where isHorizontal: [counterClockwiseAdjacent]
        case "/" where isVertical: [clockwiseAdjacent]
        case "\\" where isHorizontal: [clockwiseAdjacent]
        case "\\" where isVertical: [counterClockwiseAdjacent]
        case "|" where isHorizontal: [clockwiseAdjacent, counterClockwiseAdjacent]
        case "-" where isVertical: [clockwiseAdjacent, counterClockwiseAdjacent]
        default: [self]
        }
    }
}

class S2316: Solving {
    struct Reflection: Equatable, Hashable {
        var point: Point
        var direction: Direction
    }

    func solvePart1(_ input: String) -> Int {
        let grid = Grid(from: input)
        return energizedTiles(in: grid, entry: Point(x: 0, y: 0), direction: .right).count
    }

    func energizedTiles(in grid: Grid<Character>, entry point: Point, direction: Direction) -> Set<Point> {
        var toVisit: Set<Reflection> = [Reflection(point: point, direction: direction)]
        var visited: Set<Reflection> = []

        while !toVisit.isEmpty {
            let ref = toVisit.removeFirst()
            let (p, dir) = (ref.point, ref.direction)
            guard grid.indices.contains(p), visited.insert(ref).inserted else { continue }

            dir.directions(after: grid[p])
                .forEach { toVisit.insert(Reflection(point: p.moving(in: $0), direction: $0)) }
        }

        return Set(visited.map { $0.point })
    }

    func solvePart2(_ input: String) -> Int {
        let grid = Grid(from: input)

        return Direction.allCases
            .flatMap { d in grid.edgeIndices(for: d).map { (d, $0) } }
            .map { energizedTiles(in: grid, entry: $0.1, direction: $0.0).count }
            .max()!
    }
}
