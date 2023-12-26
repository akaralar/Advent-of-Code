// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
class S2317: Solving {

    func solvePart1(_ input: String) -> Int {
        let grid = Grid(input.lines, mapping: { $0.wholeNumberValue! })

        let goal = grid.index(before: grid.endIndex)
        let (trail, costSoFar) = aStar(grid, start: .origin, goal: goal)
        let path = reconstructPath(in: trail, start: .origin, goal: goal)
        paint(grid: grid, path: path)
        return costSoFar[goal]!.1
    }

    func paint(grid: Grid<Int>, path: [Point]) {

        var grid: Grid<String> = Grid(grid.rows(), mapping: { _ in "." })
        for point in path {
            grid[point] = "#"
        }

        print("\n-----GRID-----")
        print(grid.rows().map { $0.joined() }.joined(separator: "\n"))
    }

    func reconstructPath(
        in trail: [Point: Point],
        start: Point,
        goal: Point,
        maxNodes: Int = .max,
        includeStart: Bool = false
    ) -> [Point] {
        var path: [Point] = [goal]
        guard var current = trail[goal] else { return path }

        while current != start && path.count < maxNodes {
            path.append(current)
            current = trail[current]!
        }

        if includeStart || path.count < maxNodes { path.append(start) }

        return path
    }

    func heuristic(_ goal: Point, _ next: Point) -> Int {
        goal.manhattanDistance(to: next)
//        0
    }

    func aStar(_ grid: Grid<Int>, start: Point, goal: Point) -> ([Point: Point], [Point: (Int, Int)]) {
        var frontier = PriorityQueue<Point, Double>(values: [], priorities: [])
        frontier.add(start, priority: Double(grid[start]))

        var trail: [Point: Point] = [:]
        var costSoFar: [Point: (steps: Int, total: Int)] = [start: (0, 0)]

        let average: Double = Double(grid.reduce(0, +)) / Double(grid.count)
        let sortedGrid: [Int] = grid.sorted(by: <)
        while let current = frontier.poll() {
            print("---checking new point---")
            print("cost: \(costSoFar[current]!), point: \(current)")

//            if current == end { break }
            var neighbors = grid.neighbors(of: current)

            let last4 = reconstructPath(in: trail, start: start, goal: current, maxNodes: 4)
            print(last4.map(String.init(describing:)).joined(separator: ", "))
            if last4.count >= 4 {
                if last4[1...].allSatisfy({ $0.x == last4[0].x }) {
                    neighbors = neighbors.filter { $0.x != last4[0].x }
                }

                if last4[1...].allSatisfy({ $0.y == last4[0].y}) {
                    neighbors = neighbors.filter { $0.y != last4[0].y }
                }
            }

            if let previous = trail[current] {
                neighbors.remove(previous)
            }


            let (steps, currentTotal) = costSoFar[current]!
            for next in neighbors {
                print("-checking neighbor-")
                let newCost = currentTotal + grid[next]
                print("cost: \(newCost), point: \(next)")

                if costSoFar[next] == nil || newCost < costSoFar[next]!.total {
                    print("found lower cost")
                    costSoFar[next] = (steps+1, newCost)
//                    frontier.add(
//                        next,
//                        priority: Double(newCost) + Double(sortedGrid.prefix(heuristic(goal, next)).reduce(0, +))
//                    )
                    frontier.add(next, priority: Double(newCost) + (average * Double(heuristic(goal, next))))
                    trail[next] = current
                }
            }
        }

        return (trail, costSoFar)
    }

    func solvePart2(_ input: String) -> Int {
        0
    }
}
