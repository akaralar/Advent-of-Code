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
    typealias Year = Y2015
    typealias Day = D19

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

    func solvePart1() -> String {
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

    func solvePart2() -> String {
        dump(replacements)
        return ""
    }

    // N -> N N
    // N -> N 'Rn' N 'Ar'
    // N -> N 'Rn' N 'Y' N 'Ar'
    // N -> N 'Rn' N 'Y' N 'Y' N 'Ar'
    var input: String {
        """
        Al => ThF
        Al => ThRnFAr
        B => BCa
        B => TiB
        B => TiRnFAr
        Ca => CaCa
        Ca => PB
        Ca => PRnFAr
        Ca => SiRnFYFAr
        Ca => SiRnMgAr
        Ca => SiTh
        F => CaF
        F => PMg
        F => SiAl
        H => CRnAlAr
        H => CRnFYFYFAr
        H => CRnFYMgAr
        H => CRnMgYFAr
        H => HCa
        H => NRnFYFAr
        H => NRnMgAr
        H => NTh
        H => OB
        H => ORnFAr
        Mg => BF
        Mg => TiMg
        N => CRnFAr
        N => HSi
        O => CRnFYFAr
        O => CRnMgAr
        O => HP
        O => NRnFAr
        O => OTi
        P => CaP
        P => PTi
        P => SiRnFAr
        Si => CaSi
        Th => ThCa
        Ti => BP
        Ti => TiTi
        e => HF
        e => NAl
        e => OMg

        CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl
        """
    }

}
//
//class Day19: Solving {
//
//    var regex1 = /^(\w+) => ([A-Z][a-z]?)([A-Z][a-z]?)$/
//    var regex2 = /([A-Z][a-z]?)/
//    lazy var replacementsAndMolecule: (replacements: [(Element, [Element])], molecule: [Element]) = {
//        var lines = input.lines
//        let start = lines.removeLast()
//            .matches(of: regex2)
//            .map(\.output)
//            .map { String($0.1) }
//            .map(Element.init(symbol:))
//
//
//        let result = lines
//            .map {
//                let inputAndOutput = $0.components(separatedBy: " => ")
//                let output = inputAndOutput.last!.matches(of: regex2)
//                    .map(\.output)
//                    .map { String($0.1) }
//                    .map(Element.init(symbol:))
//                return (Element(symbol: inputAndOutput.first!), output)
//            }
//        return (result, start)
//    }()
//
//    var replacements: [(Element, [Element])] { replacementsAndMolecule.replacements }
//    var molecule: [Element] { replacementsAndMolecule.molecule }
//
//    func solvePart1() -> String {
//        let result: Set<String> = replacements
//            .flatMap { (input, output) in
//                molecule
//                    .ranges(of: input)
//                    .map { molecule.replacingSubrange($0, with: output) }
//            }
//            .reduce(into: []) { partialResult, replaced in
//                partialResult.insert(replaced)
//            }
//
//        return "\(molecule.count)"
//    }
//
//
//
//    func solvePart2() -> String {
////        var start = [molecule: 0]
////        let path = expand(
////            startingValues: &start,
////            until: "e",
////            replacements: replacements.sorted(by: { $0.1 > $1.1 } ),
////            evolutions: 0
////        )
////        return String(path)
//
//        return ""
//    }
//
//    func expand(
//        startingValues: inout [String: Int],
//        until: String,
//        replacements: [(String, String)],
//        evolutions: Int
//    ) -> Int {
//        if let value = startingValues[until] { return value }
//
//        for (input, output) in replacements {
//            for (key, value) in startingValues where value == evolutions {
//                for range in key.ranges(of: output).reversed() {
//                    let replaced =  key.replacingSubrange(range, with: input)
//                    if replaced == until { return evolutions + 1 }
//                    guard startingValues[replaced] == nil else { continue }
//                    startingValues[replaced] = evolutions + 1
//                }
//            }
//        }
//
//        return expand(
//            startingValues: &startingValues,
//            until: until,
//            replacements: replacements,
//            evolutions: evolutions + 1
//        )
//    }
//
//    func findPath(from initial: String, to final: String, currentPath: [Int]) -> [Int] {
//        if initial == final {
//            return currentPath
//        }
//        let (replacements, _) = replacementsAndMolecule
//        var paths: [[Int]] = []
//        for (replacement, index) in zip(replacements, replacements.indices) {
//            for range in initial.ranges(of: replacement.1) {
//                let replaced = initial.replacingSubrange(range, with: replacement.0)
//                paths.append(findPath(from: replaced, to: final, currentPath: currentPath + [index] ))
//            }
//        }
//
//        return paths.filter { !$0.isEmpty }.min { $0.count < $1.count } ?? []
//    }
//
////    var input: String {
////        """
////        e => H
////        e => O
////        H => HO
////        H => OH
////        O => HH
////
////        HOH
////        """
////    }
//
//    // XX
//    // XRnXAr
//    // XRnXYXAr
//    // XRnXYXYXAr
//
//    var input: String {
//        """
//        Al => ThF
//        Al => ThRnFAr
//        B => BCa
//        B => TiB
//        B => TiRnFAr
//        Ca => CaCa
//        Ca => PB
//        Ca => PRnFAr
//        Ca => SiRnFYFAr
//        Ca => SiRnMgAr
//        Ca => SiTh
//        F => CaF
//        F => PMg
//        F => SiAl
//        H => CRnAlAr
//        H => CRnFYFYFAr
//        H => CRnFYMgAr
//        H => CRnMgYFAr
//        H => HCa
//        H => NRnFYFAr
//        H => NRnMgAr
//        H => NTh
//        H => OB
//        H => ORnFAr
//        Mg => BF
//        Mg => TiMg
//        N => CRnFAr
//        N => HSi
//        O => CRnFYFAr
//        O => CRnMgAr
//        O => HP
//        O => NRnFAr
//        O => OTi
//        P => CaP
//        P => PTi
//        P => SiRnFAr
//        Si => CaSi
//        Th => ThCa
//        Ti => BP
//        Ti => TiTi
//        e => HF
//        e => NAl
//        e => OMg
//
//        CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl
//        """
//    }
//}
