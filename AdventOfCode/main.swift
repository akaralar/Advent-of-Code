//
//  main.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation

let solution = S2306()

let clock = ContinuousClock()
var resultPart1: String = ""
let timePart1 = clock.measure {
    print("Part 1 answer: \(solution.solvePart1())")
}

let timePart2 = clock.measure {
    print("Part 2 answer: \(solution.solvePart2())")
}

print("Part 1 time: \(format(time: timePart1))")
print("Part 2 time: \(format(time: timePart2))")
