//
//  DaysAndYears.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 01/12/2023.
//

import Foundation

public protocol Solving {
    associatedtype Input
    associatedtype Output: CustomStringConvertible

    func solvePart1(_ input: Input) -> Output
    func solvePart2(_ input: Input) -> Output
}
