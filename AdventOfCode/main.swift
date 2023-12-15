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
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
"""

let solution = S2314()

let clock = ContinuousClock()
let timePart1 = clock.measure {
    print("Part 1 answer: \(solution.solvePart1(testInput1))")
}

let timePart2 = clock.measure {
    print("Part 2 answer: \(solution.solvePart2(testInput1))")
}

print("Part 1 time: \(format(time: timePart1))")
print("Part 2 time: \(format(time: timePart2))")
