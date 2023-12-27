// Created by Ahmet Karalar for  in 2023
// Using Swift 5.0


import Foundation
import AOC2023
import AOCKit

struct SolutionRunner<S: Solving> {
    let solution: S
    let input: S.Input

    let clock = ContinuousClock()
    func runBothParts() {
        let durationPart1 = clock.measure {
            print("Part 1 answer: \(solution.solvePart1(input))")
        }

        let durationPart2 = clock.measure {
            print("Part 2 answer: \(solution.solvePart2(input))")
        }

        print("Part 1 time: \(NumberFormatter.format(duration: durationPart1))")
        print("Part 2 time: \(NumberFormatter.format(duration: durationPart2))")
    }
}

extension NumberFormatter {
    static let runTimeFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 3
        return f
    }()

    static func format(duration: Duration) -> String {
        var time = Double(duration.components.seconds) + (Double(duration.components.attoseconds) / 1.0e18)
        let unit: String
        if time > 1.0 {
            unit = "s"
        } else if time > 0.001 {
            unit = "ms"
            time *= 1_000
        } else if time > 0.000_001 {
            unit = "µs"
            time *= 1_000_000
        } else {
            unit = "ns"
            time *= 1_000_000_000
        }
        return runTimeFormatter.string(from: NSNumber(value: time))! + unit
    }
}
