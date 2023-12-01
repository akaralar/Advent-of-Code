//
//  Day04.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 04/08/2023.
//

import Foundation
import CryptoKit

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

struct Day04: Solving {
    func solvePart1() -> String {
        return String(findFirstHash(with: "00000"))
    }
    
    func solvePart2() -> String {
        return String(findFirstHash(with: "000000"))
    }

    func findFirstHash(with prefix: String) -> Int {
        var counter = 0
        while true {
            let hash = MD5(string: input + String(counter))
            if hash.hasPrefix(prefix) { break }
            counter += 1
        }

        return counter
    }


    var input: String { "bgvyzdsv" }
}
