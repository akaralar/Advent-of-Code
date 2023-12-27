//
//  Day03.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation
import AOCKit

struct Day03: Solving {
    typealias State = (Set<String>, CGPoint)

    func solvePart1(_ input: String) -> String {
        var initialState: State = ([], CGPoint(x: 0, y: 0))
        let finalState = input.reduce(into: initialState) { current, next in
            apply(direction: next, to: &current)
        }

        return String(finalState.0.count)
    }

    func apply(direction: Character, to state: inout State) {
        state.0.insert("\(state.1.x),\(state.1.y)")
        switch direction {
        case "^":
            state.1 = CGPoint(x: state.1.x, y: state.1.y - 1)
        case ">":
            state.1 = CGPoint(x: state.1.x + 1, y: state.1.y)
        case "v":
            state.1 = CGPoint(x: state.1.x, y: state.1.y + 1)
        case "<":
            state.1 = CGPoint(x: state.1.x - 1, y: state.1.y)
        default:
            fatalError("Shouldn't happen")
        }

        state.0.insert("\(state.1.x),\(state.1.y)")
    }

    func solvePart2(_ input: String) -> String {

        var santa: State = ([], CGPoint(x: 0, y: 0))
        var robo: State = ([], CGPoint(x: 0, y: 0))

        for (idx, direction) in input.enumerated() {
            idx % 2 == 0
                ? apply(direction: direction, to: &santa)
                : apply(direction: direction, to: &robo)
        }

        return String(santa.0.union(robo.0).count)
    }
}
