//
//  Day12.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 10/08/2023.
//

import Foundation

class Day12: Solving {
    func solvePart1(_ input: String) -> String {
        do {
            let serialized = try JSONSerialization.jsonObject(with: input.data(using: .utf16)!)
            let total = calculateTotal(for: serialized, predicate: { _ in true })
            return String(total)
        } catch {
            print(error)
        }

        return ""
    }

    func solvePart2(_ input: String) -> String {
        do {
            let serialized = try JSONSerialization.jsonObject(with: input.data(using: .utf16)!)
            let total = calculateTotal(for: serialized, predicate: {
                if let s = $0 as? String, s == "red" {
                    return false
                }
                return true
            })
            return String(total)
        } catch {
            print(error)
        }

        return ""
    }

    func calculateTotal(for node: Any, predicate: (Any) -> Bool) -> Int {
        if let number = node as? Int {
            return number
        } else if let _ = node as? String {
            return 0
        } else if let array = node as? [Any] {
            return array.map { calculateTotal(for: $0, predicate: predicate) }.reduce(0, +)
        } else if let dict = node as? [String: Any] {
            guard dict.values.allSatisfy({ predicate($0) }) else { return 0 }
            return dict.values.map { calculateTotal(for: $0, predicate: predicate) }.reduce(0, +)
        } else {
            fatalError()
        }
    }
}
