//
//  Day19.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 19/08/2023.
//

import Foundation
//
extension String {
    func ranges(of other: String) -> [Range<Index>] {
        ranges(of: Regex<String>(verbatim: other))
    }

    func replacingSubrange(_ range: Range<Index>, with replacement: String) -> Self {
        var replaced = self
        replaced.replaceSubrange(range, with: replacement)
        return String(replaced)
    }
}

struct Matter: Equatable, Hashable {
    let symbol: String
}

struct Molecule: Collection, Equatable, Hashable {
    func index(after i: Int) -> Int {
        elements.index(after: i)
    }

    var elements: [Matter]

    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }

    subscript(position: Int) -> Matter {
        get {
            elements[position]
        }
        set {
            elements[position] = newValue
        }
    }


    //    mutating func replaceSubrange(_ range: Range<Int>, with replacement: [Matter]) {
    //        elements.replaceSubrange(range, with: replacement)
    //    }
    //
    //    func ranges(of: Matter) -> Range<Int> {
    ////        elements.filter { }
    //    }
    //
    func replacingElement(_ index: Int, with replacement: Molecule) -> Molecule {
        var elem = elements
        elem.replaceSubrange(index..<index+1, with: replacement)
        return Molecule(elements: elem)
    }
}

extension Array where Element == Matter {

}

class Day19: Solving {
    var regex1 = /^(\w+) => ([A-Z][a-z]?)([A-Z][a-z]?)$/
    var regex2 = /([A-Z][a-z]?)/
    lazy var replacementsAndMolecule: (replacements: [(Matter, Molecule)], molecule: Molecule) = {
        var lines = input.lines
        let start = lines.removeLast()
            .matches(of: regex2)
            .map(\.output)
            .map { String($0.1) }
            .map(Matter.init(symbol:))

        let result = lines
            .map {
                let inputAndOutput = $0.components(separatedBy: " => ")
                let output = inputAndOutput.last!.matches(of: regex2)
                    .map(\.output)
                    .map { String($0.1) }
                    .map(Matter.init(symbol:))

                return (Matter(symbol: inputAndOutput.first!), Molecule(elements: output))
            }
        return (result, Molecule(elements: start))
    }()

    var replacements: [(Matter, Molecule)] { replacementsAndMolecule.replacements }
    var molecule: Molecule { replacementsAndMolecule.molecule }

    var input: String = ""

    func solvePart1(_ input: String) -> String {
        self.input = input

        let result: Set<Molecule> = replacements
            .flatMap { (input, output) in
                zip(molecule.indices, molecule)
                    .filter { (idx, elem) in elem == input }
                    .map { (idx, elem) in molecule.replacingElement(idx, with: output) }
            }
            .reduce(into: []) { partialResult, replaced in
                partialResult.insert(replaced)
            }

        return "\(result.count)"
    }

    func solvePart2(_ input: String) -> String {
        self.input = input
        dump(replacements)
        return ""
    }
}
