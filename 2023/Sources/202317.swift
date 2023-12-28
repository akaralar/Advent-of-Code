// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import AOCKit

public class S2317: Solving {
    public init() { }

    public func solvePart1(_ input: String) -> Int {
        let grid = Grid(input.lines, mapping: { $0.wholeNumberValue! })

        let goal = grid.index(before: grid.endIndex)
        let (trail, costSoFar) = AStar.findShortestPath(grid, start: .origin, goal: goal)
        let path = AStar.reconstructPath(in: trail, start: .origin, goal: goal)
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

    public func solvePart2(_ input: String) -> Int {
        0
    }
}
