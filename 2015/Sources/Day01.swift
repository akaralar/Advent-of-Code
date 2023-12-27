//
//  Day01.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation
import AOCKit

public struct Day01: Solving {
    public func solvePart1(_ input: String) -> String {
        String(
            input.reduce(0) { partialResult, char in
                return char == "(" ? partialResult + 1 : partialResult - 1
            }
        )
    }
    
    public func solvePart2(_ input: String) -> String {
        var floor = 0
        for (idx, char) in input.enumerated() {
            floor = char == "(" ? floor + 1 : floor - 1
            if floor < 0 { return String(idx+1) }
        }

        return ""
    }
}
