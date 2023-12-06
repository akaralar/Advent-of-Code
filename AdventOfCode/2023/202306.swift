// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation
import RegexBuilder

struct S2306: Solving {
    let regex = Regex { Capture { OneOrMore(.digit) } transform: { w in Int(w)! } }

    func solvePart1() -> String {
        func countOfWaysToBeat(_ time: Int, _ distance: Int) -> Int {
            let firstOver = (1...(time/2)).first { $0 * (time-$0) > distance }!
            let ways = 2 * ((time/2) - firstOver + 1)
            return time % 2 == 0 ? ways - 1 : ways
        }

        let timesAndDistances = input.lines.map { $0.matches(of: regex).map(\.output.1) }

        return zip(timesAndDistances[0], timesAndDistances[1])
            .map(countOfWaysToBeat)
            .reduce(1, *)
            .asString
    }

    func solvePart2() -> String {
        func calculateRoots(_ time: Double, _ distance: Double) -> (Double, Double) {
           /* Quadratic solution
             ax^2 + bx + c = 0
             solving for x,
             x1 = (-b + sqrt(b^2 - 4*a*c))/2*a
             x2 = (-b - sqrt(b^2 - 4*a*c))/2*a

             bt = button time, time = total time available, dist = current record

             dist = bt * (time - bt)
             dist = bt*time - bt^2
             - bt^2 + bt*time - dist = 0 (our quadratic equation)

             for time = 7, dist = 9 (first test input)
             a = -1, b = time = 7, c = -dist = -9

             (see https://www.desmos.com/calculator/jlq9jbvsiz for a graph)
            */

            let x1 = (-time + sqrt(pow(time, 2) - (4 * -1 * -distance))) / -2
            let x2 = (-time - sqrt(pow(time, 2) - (4 * -1 * -distance))) / -2

            return (x1, x2)
        }

        let timeAndDistance = input.lines
            .map { $0.matches(of: regex).map(\.output.0).joined()}
            .compactMap(Int.init)

        let (x1, x2) = calculateRoots(Double(timeAndDistance[0]), Double(timeAndDistance[1]))
        return String(Int(floor(max(x1, x2)) - ceil(min(x1, x2))) + 1)
    }

    var input: String {
        """
        Time:        42     68     69     85
        Distance:   284   1005   1122   1341
        """
    }
}
