//
//  Day04.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 04/08/2023.
//

import Foundation
import AOCKit

struct Day04: Solving {
    func solvePart1(_ input: String) -> String {
        return String(findFirstHash(from: input, with: "00000"))
    }
    
    func solvePart2(_ input: String) -> String {
        return String(findFirstHash(from: input, with: "000000"))
    }

    func findFirstHash(from input: String, with prefix: String) -> Int {
        var counter = 0
        while true {
            let hash = MD5(string: input + String(counter))
            if hash.hasPrefix(prefix) { break }
            counter += 1
        }

        return counter
    }
}
