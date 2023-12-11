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
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
"""

let testInput2 = """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
"""

let testInput3 = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""

let testInput4 = """
..........
.S------7.
.|F----7|.
.||OOOO||.
.||OOOO||.
.|L-7F-J|.
.|II||II|.
.L--JL--J.
..........
"""

let testInput5 = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""

let testInput6 = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""

let solution = S2310()

let clock = ContinuousClock()
let timePart1 = clock.measure {
    print("Part 1 answer: \(solution.solvePart1(input))")
}

let timePart2 = clock.measure {
    print("Part 2 answer: \(solution.solvePart2(input))")
}

print("Part 1 time: \(format(time: timePart1))")
print("Part 2 time: \(format(time: timePart2))")
