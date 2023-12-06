//
//  main.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 02/08/2023.
//

import Foundation

print("Hello, World!")
let kYear = 2015
let kDay = 01

let inputString = "https://adventofcode.com/2015/day/1/input"

let solution = S2306()

let clock = ContinuousClock()
var resultPart1: String = ""
let timePart1 = clock.measure {
    resultPart1 = solution.solvePart1()
}
print("Part 1: \(resultPart1)")
print("Time 1: \(format(time: timePart1))")

var resultPart2 = ""
let timePart2 = clock.measure {
    resultPart2 = solution.solvePart2()
}
print("Part 2: \(resultPart2)")
print("Time 2: \(format(time: timePart2))")
//var years: [Year] = []
//for year in (2015...2022) {
//    years.append(Year(year: year))
//}
