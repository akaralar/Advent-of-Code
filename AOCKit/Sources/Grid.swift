// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

public struct Point: Equatable, Hashable {
    public static let origin: Point = Point(x: 0, y: 0)

    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public mutating func apply(_ v: Vector) {
        x += v.xDifference
        y += v.yDifference
    }

    public func applying(_ v: Vector) -> Point {
        var p = self
        p.apply(v)
        return p
    }

    public mutating func move(in direction: Direction, by distance: UInt = 1) {
        apply(direction.unitVector.multiplied(by: Int(distance)))
    }

    public func moving(in direction: Direction, by distance: UInt = 1) -> Point {
        var p = self
        p.move(in: direction, by: distance)
        return p
    }

    public func manhattanDistance(to point: Point) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }
}

extension Point: Comparable {
    public static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y < rhs.y { true }
        else if lhs.y > rhs.y { false }
        else { rhs.x < rhs.x }
    }
}

extension Point: CustomStringConvertible {
    public var description: String { "\(x), \(y)" }
}

/// Origin is top left
public enum Direction: CaseIterable {
    case up
    case down
    case left
    case right

    public var unitVector: Vector {
        switch self {
        case .up: Vector(end: Point(x: 0, y: -1))
        case .down: Vector(end: Point(x: 0, y: 1))
        case .left: Vector(end: Point(x: -1, y: 0))
        case .right: Vector(end: Point(x: 1, y: 0))
        }
    }

    public var clockwiseAdjacent: Direction {
        switch self {
        case .up: .right
        case .down: .left
        case .left: .up
        case .right: .down
        }
    }

    public var counterClockwiseAdjacent: Direction {
        switch self {
        case .up: .left
        case .down: .right
        case .left: .down
        case .right: .up
        }
    }

    public var opposite: Direction {
        switch self {
        case .up: .down
        case .down: .up
        case .left: .right
        case .right: .left
        }
    }

    public var isHorizontal: Bool { self == .left || self == .right }
    public var isVertical: Bool { !isHorizontal }
}

public struct Vector: Equatable, Hashable {
    public var start: Point
    public var end: Point

    var xDifference: Int { end.x - start.x }
    var yDifference: Int { end.y - start.y }

    init(start: Point = .origin, end: Point) {
        self.start = start
        self.end = end
    }

    mutating func multiply(by scalar: Int) {
        start.x *= scalar
        start.y *= scalar
        end.x *= scalar
        end.y *= scalar
    }

    func multiplied(by scalar: Int) -> Vector {
        var v = self
        v.multiply(by: scalar)
        return v
    }
}

public struct Grid<Element>: RandomAccessCollection {
    private var elements: [[Element]]

    public var xCount: Int { elements[0].count }
    public var yCount: Int { elements.count }

    public var xEndIndex: Int { elements[0].endIndex }
    public var yEndIndex: Int { elements.endIndex }

    public init(from string: String, mapping: (Character) -> Element = { $0 }) {
        elements = string.lines.map { Array($0).map(mapping) }
    }

    public init<C: Collection>(_ collection: [C], mapping: (C.Element) -> Element) {
        elements = collection.map { Array($0).map(mapping) }
    }

    public subscript(p: Point) -> Element {
        get { elements[p.y][p.x] }
        set { elements[p.y][p.x] = newValue }
    }

    public var startIndex: Point { .origin }
    public var endIndex: Point { Point(x: elements[0].endIndex, y: elements.endIndex - 1)}

    public func index(after p: Point) -> Point {
        if p.x + 1 < xEndIndex { Point(x: p.x + 1, y: p.y) }
        else if p.y + 1 < yEndIndex { Point(x: 0, y: p.y + 1) }
        else { endIndex }
    }

    public func index(before p: Point) -> Point {
        if p.x - 1 >= 0 { Point(x: p.x - 1, y: p.y) }
        else if p.y - 1 >= 0 { Point(x: xEndIndex - 1, y: p.y - 1) }
        else { startIndex }
    }
}

extension Grid {
    public func edgeIndices(for edge: Direction) -> [Point] {
        switch edge {
        case .up: (0..<xEndIndex).map { Point(x: $0, y: 0) }
        case .down: (0..<xEndIndex).map { Point(x: $0, y: yEndIndex-1) }
        case .left: (0..<yEndIndex).map { Point(x: 0, y: $0) }
        case .right: (0..<yEndIndex).map { Point(x: xEndIndex-1, y: $0) }
        }
    }

    public func contains(point p: Point) -> Bool {
        (0..<xEndIndex).contains(p.x) && (0..<yEndIndex).contains(p.y)
    }

    public func neighbors(of p: Point) -> Set<Point> {
        Direction.allCases
            .lazy
            .map(\.unitVector)
            .map(p.applying(_:))
            .filter(contains(point:))
            .reduce(into: Set<Point>()) { $0.insert($1) }
    }

    public func rows() -> [[Element]] {
        var rows: [[Element]] = []
        for y in 0..<yEndIndex {
            rows.append([])
            for x in 0..<xEndIndex {
                rows[y].append(self[Point(x: x, y: y)])
            }
        }

        return rows
    }

    public func columns() -> [[Element]] {
        var columns: [[Element]] = []
        for x in 0..<xEndIndex {
            columns.append([])
            for y in 0..<yEndIndex {
                columns[x].append(self[Point(x: x, y: y)])
            }
        }

        return columns
    }
}

struct GridIndices: Collection, BidirectionalCollection, RandomAccessCollection {
    let xRange: Range<Int>
    let yRange: Range<Int>

    var startIndex: Point { .origin }
    var endIndex: Point { Point(x: xRange.upperBound, y: yRange.upperBound) }

    subscript(position: Point) -> Point {
        return position
    }

    func index(after p: Point) -> Point {
        if p.x + 1 < xRange.upperBound { Point(x: p.x + 1, y: p.y) }
        else if p.y + 1 < yRange.upperBound { Point(x: 0, y: p.y + 1) }
        else { endIndex }
    }

    func index(before p: Point) -> Point {
        if p.x - 1 >= 0 { Point(x: p.x - 1, y: p.y) }
        else if p.y - 1 >= 0 { Point(x: xRange.upperBound - 1, y: p.y - 1) }
        else { startIndex }
    }
}
