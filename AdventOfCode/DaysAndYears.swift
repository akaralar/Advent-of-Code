//
//  DaysAndYears.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 01/12/2023.
//

import Foundation

protocol YearProtocol { }
protocol DayProtocol { }

protocol Solving {
    var input: String { get }
    func solvePart1() -> String
    func solvePart2() -> String
}


enum Y2023: YearProtocol { }

enum D01: DayProtocol { }

struct Solution<Day: DayProtocol, Year: YearProtocol> { }
