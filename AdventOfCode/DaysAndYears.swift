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
    associatedtype Year: YearProtocol
    associatedtype Day: DayProtocol
    
    var input: String { get }
    func solvePart1() -> String
    func solvePart2() -> String
}

enum Y2015: YearProtocol { }
enum Y2023: YearProtocol { }


enum D01: DayProtocol { }
enum D02: DayProtocol { }
enum D03: DayProtocol { }
enum D04: DayProtocol { }
enum D05: DayProtocol { }
enum D06: DayProtocol { }
enum D07: DayProtocol { }
enum D08: DayProtocol { }
enum D09: DayProtocol { }
enum D10: DayProtocol { }
enum D11: DayProtocol { }
enum D12: DayProtocol { }
enum D13: DayProtocol { }
enum D14: DayProtocol { }
enum D15: DayProtocol { }
enum D16: DayProtocol { }
enum D17: DayProtocol { }
enum D18: DayProtocol { }
enum D19: DayProtocol { }
enum D20: DayProtocol { }


struct Solution<Day: DayProtocol, Year: YearProtocol>: Solving {
    var input: String {
        fatalError()
    }

    func solvePart1() -> String {
        fatalError()
    }

    func solvePart2() -> String {
        fatalError()
    }
}
