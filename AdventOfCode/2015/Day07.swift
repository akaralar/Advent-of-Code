//
//  Day07.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation
import RegexBuilder

struct Wire {
    let id: String
    let input: Input

    init(id: String, input: Input) {
        self.id = id
        self.input = input
    }
}

enum Input {
    case custom(UInt16)
    case direct(String)
    case gate(Gate)
}

enum Gate {
    case and(String, String)
    case or(String, String)
    case lShift(String, UInt16)
    case rShift(String, UInt16)
    case not(String)
}

class Day07: Solving {
    let valueRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.digit)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let wireRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }


    let andOrRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " "
        TryCapture {
            ChoiceOf {
                "AND"
                "OR"
            }
        } transform: { w in
            Command(rawValue: String(w))
        }
        " "
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let shiftRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " "
        TryCapture {
            ChoiceOf {
                "LSHIFT"
                "RSHIFT"
            }
        } transform: { w in
            Command(rawValue: String(w))
        }
        " "
        Capture {
            OneOrMore(.digit)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let notRegex = Regex {
        Anchor.startOfLine
        "NOT "
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
    }

    func schema(input: String) -> [String: Wire] {
        var wires: [String: Wire] = [:]
        for line in input.lines {
            if !line.matches(of: valueRegex).isEmpty {
                let (_, signal, outWire) = line.matches(of: valueRegex).first!.output
                let wire = Wire(id: String(outWire), input: .custom(UInt16(signal)!))
                wires[wire.id] = wire
            } else if !line.matches(of: wireRegex).isEmpty {
                let (_, inWire, outWire) = line.matches(of: wireRegex).first!.output
                let wire = Wire(id: String(outWire), input: .direct(String(inWire)))
                wires[wire.id] = wire
            } else if !line.matches(of: andOrRegex).isEmpty {
                let (_, leftWire, action, rightWire, outWire) = line.matches(of: andOrRegex).first!.output

                let gate: Gate = switch action {
                case .and: .and(String(leftWire), String(rightWire))
                case .or: .or(String(leftWire), String(rightWire))
                default: fatalError()
                }

                let wire = Wire(id: String(outWire), input: .gate(gate))
                wires[wire.id] = wire
            } else if !line.matches(of: shiftRegex).isEmpty {
                let (_, inWire, action, shift, outWire) = line.matches(of: shiftRegex).first!.output

                let gate: Gate = switch action {
                case .lShift: .lShift(String(inWire), UInt16(shift)!)
                case .rShift: .rShift(String(inWire), UInt16(shift)!)
                default: fatalError()
                }

                let wire = Wire(id: String(outWire), input: .gate(gate))
                wires[wire.id] = wire
            } else if !line.matches(of: notRegex).isEmpty {
                let (_, inWire, outWire) = line.matches(of: notRegex).first!.output
                let wire = Wire(id: String(outWire), input: .gate(.not(String(inWire))))
                wires[wire.id] = wire
            } else {
                print(line)
                fatalError()
            }
        }

        return wires
    }

    var signalCache: [String: UInt16] = [:]
    func signal(for wireID: String, wires: [String: Wire]) -> UInt16 {
        if let cached = signalCache[wireID] { return cached }
        guard let wire = wires[wireID] else { fatalError() }
        let signal: UInt16 = switch wire.input {
        case let .custom(signal): signal
        case let .direct(inWire): signal(for: inWire, wires: wires)
        case let .gate(gate):
            switch gate {
            case let .and(left, right):
                if let value = UInt16(left) {
                    value & signal(for: right, wires: wires)
                } else {
                    signal(for: left, wires: wires) & signal(for: right, wires: wires)
                }
            case let .or(left, right):
                if let value = UInt16(left) {
                    value | signal(for: right, wires: wires)
                } else {
                    signal(for: left, wires: wires) | signal(for: right, wires: wires)
                }
            case let .not(inWire):
                if let value = UInt16(inWire) {
                    ~value
                } else {
                    ~signal(for: inWire, wires: wires)
                }
            case let .lShift(inWire, shift): signal(for: inWire, wires: wires) << shift
            case let .rShift(inwire, shift): signal(for: inwire, wires: wires) >> shift
            }
        }
        signalCache[wireID] = signal
        return signal
    }

    func solvePart1(_ input: String) -> String {
        return String(signal(for: "a", wires: schema(input: input)))
    }

    func solvePart2(_ input: String) -> String {
        var wires = schema(input: input)
        let signalA = signal(for: "a", wires: wires)
        wires["b"] = Wire(id: "b", input: .custom(signalA))
        signalCache = [:]
        return String(signal(for: "a", wires: wires))
    }

    enum Command: String {
        case value
        case and = "AND"
        case lShift = "LSHIFT"
        case rShift = "RSHIFT"
        case not = "NOT"
        case or = "OR"
    }
}

