//
//  Day06.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation
import RegexBuilder

struct Day06: Solving {
    let regex = Regex {
        TryCapture {
            ChoiceOf {
                Action.turnOn.rawValue
                Action.turnOff.rawValue
                Action.toggle.rawValue
            }
        } transform: { w in
            Action(rawValue: String(w))
        }
        " "
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        " through "
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
    }

    func solvePart1(_ input: String) -> String {
        var result: Set<Point> = []

        for line in input.lines {
            for match in line.matches(of: regex) {
                let (_, action, x1, y1, x2, y2) = match.output

                let grid = Grid(
                    corners: (Point(x: x1, y: y1), Point(x: x2, y: y2))
                )
                switch action {
                case .turnOn:
                    grid.points.forEach { result.insert($0) }
                case .turnOff:
                    grid.points.forEach { result.remove($0) }
                case .toggle:
                    grid.points.forEach { point in
                        if result.contains(point) {
                            result.remove(point)
                        } else {
                            result.insert(point)
                        }
                    }
                }
            }
        }

        return "\(result.count)"
    }

    func solvePart2(_ input: String) -> String {
        var result: Dictionary<Point, Int> = [:]

        for line in input.lines {
            for match in line.matches(of: regex) {
                let (_, action, x1, y1, x2, y2) = match.output

                let grid = Grid(
                    corners: (Point(x: x1, y: y1), Point(x: x2, y: y2))
                )
                switch action {
                case .turnOn:
                    grid.points.forEach { result[$0, default: 0] += 1 }
                case .turnOff:
                    grid.points.forEach {
                        result[$0] = max(result[$0, default: 0] - 1, 0)
                    }
                case .toggle:
                    grid.points.forEach { result[$0, default: 0] += 2 }
                }
            }
        }

        return "\(result.values.reduce(0, +))"

    }

    enum Action: String {
        case turnOn = "turn on"
        case toggle = "toggle"
        case turnOff = "turn off"
    }

    struct Point: Equatable, Hashable {
        let x: Int
        let y: Int

        init<X: StringProtocol, Y: StringProtocol>(x: X, y: Y) {
            self.x = Int(x)!
            self.y = Int(y)!
        }

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    struct Grid {
        let points: Set<Point>
        init(corners: (Point, Point)) {
            var p: Set<Point> = []
            for x in corners.0.x...corners.1.x {
                for y in corners.0.y...corners.1.y {
                    p.insert(Point(x: x, y: y))
                }
            }
            points = p
        }
    }
}
