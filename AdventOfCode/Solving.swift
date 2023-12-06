//
//  DaysAndYears.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 01/12/2023.
//

import Foundation

protocol Solving {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    func solvePart1() -> Output
    func solvePart2() -> Output
}
