// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import Algorithms
import AOCKit

struct S2310: Solving {
    func solvePart1(_ input: String) -> Int {
        let map = input.lines.map { Array($0) }
        var entrance = startingPoint(of: map)
        var nextStep = [(0, 1), (0, -1), (1, 0), (-1, 0)]
            .map { (entrance.x + $0.0, entrance.y + $0.1) }
            .first { exitCoordinate(ofPipeAt: $0, entrance: entrance, map: map) != nil}!

        var steps = 0
        repeat {
            guard let temp = exitCoordinate(ofPipeAt: nextStep, entrance: entrance, map: map)
            else { fatalError() }
            entrance = nextStep
            nextStep = temp
            steps += 1
        } while map[nextStep.1][nextStep.0] != "S"

        return (steps / 2) + 1
    }

    func solvePart2(_ input: String) -> Int {
        var map = input.lines.map { Array($0) }
        var entrance = startingPoint(of: map)
        let (east, west, south, north) = ([0, 1], [0, -1], [1, 0], [-1, 0])
        let possibleFirstSteps = [east, west, south, north]
            .filter { exitCoordinate(ofPipeAt: (entrance.x + $0[0], entrance.y + $0[1]), entrance: entrance, map: map) != nil }

        let startingPipe: Character = switch (possibleFirstSteps.first!, possibleFirstSteps.last!) {
        case (east, west): "-"
        case (east, south): "F"
        case (east, north): "7"
        case (west, south): "L"
        case (west, north): "J"
        case (south, north): "|"
        default: fatalError()
        }
        
        map[entrance.y][entrance.x] = startingPipe
        var nextStep = (entrance.x + possibleFirstSteps.first![0], entrance.y + possibleFirstSteps.first![1])
        var loop: [Int: [Int: Character]] = [:]
        repeat {
            guard let temp = exitCoordinate(ofPipeAt: nextStep, entrance: entrance, map: map)
            else { fatalError() }
            if map[nextStep.1][nextStep.0] != "-" {
                loop[nextStep.1, default: [:]][nextStep.0] = map[nextStep.1][nextStep.0]
            }
            entrance = nextStep
            nextStep = temp
        } while loop[nextStep.1]?[nextStep.0] == nil

        var insideCount = 0
        for y in loop.keys.sorted() {
            guard let row = loop[y] else { continue }
            var lastBoundaryIndex: Int? = nil
            var previousBendPipe: Character? = nil
            for x in row.keys.sorted() {
                let char = map[y][x]
                switch char {
                case "-": fatalError()
                case "|":
                    if let index = lastBoundaryIndex {
                        let sum = (x - index - 1)
                        insideCount += sum
                        lastBoundaryIndex = nil
                    } else {
                        lastBoundaryIndex = x
                    }
                case "F":
                    if let index = lastBoundaryIndex {
                        let sum = (x - index - 1)
                        insideCount += sum
                    }
                    previousBendPipe = "F"
                case "L":
                    if let index = lastBoundaryIndex {
                        let sum = (x - index - 1)
                        insideCount += sum
                    }
                    previousBendPipe = "L"
                case "7":
                    if previousBendPipe == "L" {
                        if lastBoundaryIndex == nil {
                            lastBoundaryIndex = x
                        } else {
                            lastBoundaryIndex = nil
                        }
                    } else {
                        if lastBoundaryIndex != nil {
                            lastBoundaryIndex = x
                        }
                    }
                case "J":
                    if previousBendPipe == "F" {
                        if lastBoundaryIndex == nil {
                            lastBoundaryIndex = x
                        } else {
                            lastBoundaryIndex = nil
                        }
                    } else {
                        if lastBoundaryIndex != nil {
                            lastBoundaryIndex = x
                        }
                    }
                default: fatalError()
                }
            }
        }

        return insideCount
    }

    func startingPoint(of map: [[Character]]) -> (x: Int, y: Int) {
        for (y, row) in map.enumerated() {
            if let x = row.firstIndex(of: "S") {
                return (x, y)
            }
        }
        fatalError()
    }

    func exitCoordinate(
        ofPipeAt coordinate: (x: Int, y: Int),
        entrance: (x: Int, y: Int),
        map: [[Character]]
    ) -> (x: Int, y: Int)? {
        if coordinate.x < 0 || coordinate.y < 0 || coordinate.y >= map.count || coordinate.x >= map[coordinate.y].count { return nil }
        let pipe = map[coordinate.y][coordinate.x]
        let (xDiff, yDiff) = (coordinate.x - entrance.x, coordinate.y - entrance.y)
        switch pipe {
        case "|" where yDiff != 0: return (coordinate.x, coordinate.y + yDiff)
        case "-" where xDiff != 0: return (coordinate.x + xDiff, coordinate.y)
            // entrance 1,1 coordinate 1,2 exit 2,2
            // entrance 2,2 coordinate 1,2 exit 1,1
        case "L" where yDiff == 1 || xDiff == -1: return (coordinate.x + yDiff, coordinate.y + xDiff)
            // entrance 1,1 coordinate 1,2 exit 0,2
            // entrance 0,2 coordinate 1,2 exit 1,1
        case "J" where yDiff == 1 || xDiff == 1: return (coordinate.x - yDiff, coordinate.y - xDiff)
            // entrance 1,2 coordinate 1,1 exit 0,1
            // entrance 0,1 coordinate 1,1 exit 1,2
        case "7" where yDiff == -1 || xDiff == 1: return (coordinate.x + yDiff, coordinate.y + xDiff)
            // entrance 1,2 coordinate 1,1 exit 2,1
            // entrance 2,1 coordinate 1,1 exit 1,2
        case "F" where yDiff == -1 || xDiff == -1: return (coordinate.x - yDiff, coordinate.y - xDiff)
        default:
            return nil
        }
    }
}
