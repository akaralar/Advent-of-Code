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

protocol Solving {
    var input: String { get }
    func solvePart1() async -> String
    func solvePart2() async -> String
}

struct Problem {
    let day: Int
    let year: Int
    let input: String
}

let day = Day09()
let resultPart1 =  await day.solvePart1()

print("Part 1: \(resultPart1)")

let resultPart2 = await day.solvePart2()
print("Part 2: \(resultPart2)")
//var years: [Year] = []
//for year in (2015...2022) {
//    years.append(Year(year: year))
//}
