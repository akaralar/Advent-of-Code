// Created by Ahmet Karalar for  in 2023
// Using Swift 5.0


import Foundation

public enum AStar {
    public static func reconstructPath(
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

    private static func heuristic(_ goal: Point, _ next: Point) -> Int {
        goal.manhattanDistance(to: next)
//        0
    }

    public static func findShortestPath(
        _ grid: Grid<Int>,
        start: Point,
        goal: Point
    ) -> ([Point: Point], [Point: (Int, Int)]) {
        var frontier = PriorityQueue<Point, Double>(values: [], priorities: [])
        frontier.add(start, priority: Double(grid[start]))

        var trail: [Point: Point] = [:]
        var costSoFar: [Point: (steps: Int, total: Int)] = [start: (0, 0)]

        let average: Double = Double(grid.reduce(0, +)) / Double(grid.count)
        let sortedGrid: [Int] = grid.sorted(by: <)
        while let current = frontier.poll() {
            print("---checking new point---")
            print("cost: \(costSoFar[current]!), point: \(current)")
            let last5 = reconstructPath(in: trail, start: start, goal: current, maxNodes: 5)
//            if current == end { break }
            if last5.count >= 5 && last5[1...].allSatisfy({ $0.x == last5[0].x }) {
                continue
            }
            if last5.count >= 5 && last5[1...].allSatisfy({ $0.y == last5[0].y}) {
                continue
            }

            var neighbors = grid.neighbors(of: current)
            let last4 = last5.prefix(4)
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
                    frontier.add(next, priority: Double(newCost) + (average * Double(heuristic(goal, next))))
                    trail[next] = current
                }
            }
        }

        return (trail, costSoFar)
    }
}

extension AStar {
    public struct Box: Hashable, Equatable {
        var point: Point
        var cost: Int
    }

    public struct HistoryStep {
        var current: Box
        var neighbors: Set<Box>
        var trail: [Point: Point]
        var costSoFar: [Point: (Int, Int)]
        var queue: PriorityQueue<Point, Double>

        public init(
            current: Box,
            neighbors: Set<Box>,
            trail: [Point : Point],
            costSoFar: [Point : (Int, Int)],
            queue: PriorityQueue<Point, Double>
        ) {
            self.current = current
            self.neighbors = neighbors
            self.trail = trail
            self.costSoFar = costSoFar
            self.queue = queue
        }

        public static let empty = HistoryStep(
            current: .init(point: .origin, cost: 0),
            neighbors: [],
            trail: [:],
            costSoFar: [:],
            queue: .init(values: [], priorities: [])
        )
    }

    public static func findShortestPathWithHistory(
        _ grid: Grid<Int>,
        start: Point,
        goal: Point
    ) -> [HistoryStep] {
        var history: [HistoryStep] = []

        var frontier = PriorityQueue<Point, Double>(values: [], priorities: [])
        frontier.add(start, priority: Double(grid[start]))

        var trail: [Point: Point] = [:]
        var costSoFar: [Point: (steps: Int, total: Int)] = [start: (0, 0)]
        
        let average: Double = Double(grid.reduce(0, +)) / Double(grid.count)
        let sortedGrid: [Int] = grid.sorted(by: <)
        while let current = frontier.poll() {
            print("---checking new point---")
            print("cost: \(costSoFar[current]!), point: \(current)")
            let last5 = reconstructPath(in: trail, start: start, goal: current, maxNodes: 5)
//            if current == end { break }
            if last5.count >= 5 && last5[1...].allSatisfy({ $0.x == last5[0].x }) {
                continue
            }
            if last5.count >= 5 && last5[1...].allSatisfy({ $0.y == last5[0].y}) {
                continue
            }

            var neighbors = grid.neighbors(of: current)
            let last4 = last5.prefix(4)
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
                    frontier.add(next, priority: Double(newCost) + (average * Double(heuristic(goal, next))))
                    trail[next] = current
                }
            }

            history.append(
                HistoryStep(
                    current: Box(point: current, cost: grid[current]),
                    neighbors: Set(neighbors.map { Box(point: $0, cost: grid[$0])}),
                    trail: trail,
                    costSoFar: costSoFar, 
                    queue: frontier
                )
            )
        }

        return history
    }
}
