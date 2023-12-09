//
//  main.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation

let input = """
"""

let testInput1 = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
"""

let solution = S2309()

let clock = ContinuousClock()
let timePart1 = clock.measure {
    print("Part 1 answer: \(solution.solvePart1(input))")
}

let timePart2 = clock.measure {
    print("Part 2 answer: \(solution.solvePart2(input))")
}

print("Part 1 time: \(format(time: timePart1))")
print("Part 2 time: \(format(time: timePart2))")
