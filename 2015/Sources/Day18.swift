//
//  Day18.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 19/08/2023.
//

import Foundation
import AOCKit

class Day18: Solving {
    func solvePart1(_ input: String) -> String {
        var grid = input.lines.map { Array($0) }
        state(after: 100, grid: &grid)
        return String(grid.map { $0.filter { $0 == "#" }.count }.reduce(0, +))
    }

    func solvePart2(_ input: String) -> String {
        var grid = input.lines.map { Array($0) }
        state(after: 100, grid: &grid, areCornersAlwaysOn: true)
        return String(grid.map { $0.filter { $0 == "#" }.count }.reduce(0, +))
    }

    func state(
        after turns: Int,
        grid: inout [[Character]],
        areCornersAlwaysOn: Bool = false
    ) {
        if areCornersAlwaysOn {
            for y in [grid.startIndex, grid.endIndex - 1] {
                for x in [grid[y].startIndex, grid[y].endIndex - 1] {
                    grid[y][x] = "#"
                }
            }
        }
        for _ in 0 ..< turns {
            stateAfterOneTurn(grid: &grid, areCornersAlwaysOn: areCornersAlwaysOn)
        }
    }

    func stateAfterOneTurn(
        grid: inout [[Character]],
        areCornersAlwaysOn: Bool = false
    ) {
        let snapshot = grid
        for (row, y) in zip(snapshot, snapshot.indices) {
            for (light, x) in zip(row, row.indices) {
                if areCornersAlwaysOn
                    && (x == row.startIndex || x == row.endIndex - 1)
                    && (y == snapshot.startIndex || y == snapshot.endIndex - 1)
                { continue }

                let turnedOnCount = numberOfTurnedOnNeighbors(
                    x: x,
                    y: y,
                    grid: snapshot,
                    areCornersAlwaysOn: areCornersAlwaysOn
                )
                switch light {
                case "#" where turnedOnCount != 2 && turnedOnCount != 3: grid[y][x] = "."
                case "." where turnedOnCount == 3: grid[y][x] = "#"
                default: break
                }
            }
        }
    }

    func numberOfTurnedOnNeighbors(
        x: Int,
        y: Int,
        grid: [[Character]],
        areCornersAlwaysOn: Bool = false
    ) -> Int {
        var neighbors: [Character] = []
        for yDiff in -1 ... 1 where y + yDiff >= 0 && y + yDiff < grid.endIndex {
            for xDiff in -1 ... 1 where x + xDiff >= 0 && x + xDiff < grid[y].endIndex {
                if xDiff == 0 && yDiff == 0 { continue }
                let neighborX = x + xDiff
                let neighborY = y + yDiff
                if areCornersAlwaysOn
                    && (neighborX == grid[y].startIndex || neighborX == grid[y].endIndex - 1)
                    && (neighborY == grid.startIndex || neighborY == grid.endIndex - 1)
                {
                    neighbors.append("#")
                } else {
                    neighbors.append(grid[neighborY][neighborX])
                }
            }
        }

        return neighbors.filter { $0 == "#" }.count
    }
}
