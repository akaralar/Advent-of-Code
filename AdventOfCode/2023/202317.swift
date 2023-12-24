// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

class S2317: Solving {

    func solvePart1(_ input: String) -> Int {
        let grid = Grid(from: input, mapping: { $0.wholeNumberValue! })

        let goal = grid.index(before: grid.endIndex)
        let (cameFrom, _) = aStar(grid, start: .origin, end: goal)
        let path = reconstructPath(in: cameFrom, start: .origin, goal: goal)

        return path.map { grid[$0] }.reduce(0, +)
    }

    func reconstructPath(
        in trail: [Point: Point],
        start: Point,
        goal: Point,
        maxNodes: Int = .max,
        includeStart: Bool = false
    ) -> [Point] {
        var current = goal
        var path: [Point] = []
        if trail[goal] == nil { return [] }

        while current != start && path.count < maxNodes {
            path.append(current)
            current = trail[current]!
        }

        if includeStart { path.append(start) }

        return path
    }

    func heuristic(_ goal: Point, _ next: Point) -> Int {
        0
    }

    func aStar(_ grid: Grid<Int>, start: Point, end: Point) -> ([Point: Point], [Point: Int]) {
        var frontier = PriorityQueue<Point, Int>(values: [], priorities: [])
        frontier.add(start, priority: grid[start])

        var cameFrom: [Point: Point] = [:]
        var costSoFar: [Point: Int] = [:]

        costSoFar[start] = 0
        while !frontier.isEmpty {
            let current = frontier.poll()!
            if current == end { break }

            var neighbors = grid.neighbors(of: current)

            let last4 = reconstructPath(in: cameFrom, start: start, goal: current, maxNodes: 4)
            if last4.count >= 4 && last4[1...].allSatisfy({ $0.x == last4[0].x }) {
                neighbors = neighbors.filter { $0.x != last4[0].x }
            }

            if last4.count >= 4 && last4[1...].allSatisfy({ $0.y == last4[0].y}) {
                neighbors = neighbors.filter { $0.y != last4[0].y }
            }

            if let previous = cameFrom[current], neighbors.contains(previous) {
                neighbors.remove(previous)
            }

            for next in neighbors {
                let newCost = costSoFar[current, default: 0] + grid[next]

                if costSoFar[next] == nil || newCost < costSoFar[next]! {
                    costSoFar[next] = newCost
                    frontier.add(next, priority: newCost + heuristic(end, next))
                    cameFrom[next] = current
                }
            }
        }

        return (cameFrom, costSoFar)
    }

    func solvePart2(_ input: String) -> Int {
        0
    }
}
