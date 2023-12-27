// Created by Ahmet Karalar for AdventOfCode in 2023
// Using Swift 5.0


import Foundation

public struct PriorityQueue<Element: Hashable, Priority: Comparable>: Collection {
    private var heap: [Element] = []
    private var map: [Element: Set<Int>] = [:]
    private var priorities: [Priority] = []

    // Initialize a priority queue using heapify in O(n) time, a great explanation can be found at:
    // http://www.cs.umd.edu/~meesh/351/mount/lectures/lect14-heapsort-analysis-part.pdf
    public init(values: [Element], priorities: [Priority]) {
        heap = values
        self.priorities = priorities

        // Place all element in map
        values.enumerated().forEach { map[$0.element, default: []].insert($0.offset) }

        // Heapify process, O(n)
        for idx in (0...Swift.max(0, (values.count / 2) - 1)).reversed() { sink(idx) }
    }

    // Clears everything inside the heap, O(1)
    public mutating func clear() {
        heap = []
        priorities = []
        map = [:]
    }

    // Returns the value of the element with the lowest
    // priority in this priority queue. If the priority
    // queue is empty null is returned.
    public func peek() -> Element? {
        isEmpty ? nil : heap[0]
    }

    // Removes the root of the heap, O(log(n))
    public mutating func poll() -> Element? {
        return remove(at: 0)
    }

    // Test if an element is in heap, O(1)
    public func contains(_ value: Element) -> Bool {
        map[value] != nil
    }
    // Adds an element to the priority queue, O(log(n))
    public mutating func add(_ value: Element, priority: Priority) {
        heap.append(value)
        priorities.append(priority)

        let lastIndex = heap.count - 1
        map[value, default: []].insert(lastIndex)

        swim(lastIndex)
    }

    // Tests the value against the predicate given at initialization.
    // This method assumes index1 & index2 are valid indices
    private func isLess(_ index1: Int, _ index2: Int) -> Bool {
        priorities[index1] <= priorities[index2]
    }

    // Perform bottom up node swim, O(log(n))
    private mutating func swim(_ index: Int) {
        // Grab the index of the next parent node WRT to given index
        var parent = (index - 1) / 2
        var i = index

        // Keep swimming while we have not reached the
        // root and while we're less than our parent.
        while i > 0 && isLess(i, parent) {
            // Exchange i with the parent
            swap(parent, i)
            i = parent

            // Grab the index of the next parent node WRT to k
            parent = (i - 1) / 2
        }
    }

    // Top down node sink, O(log(n))
    private mutating func sink(_ index: Int) {
        var i = index
        while true {
            let left = 2 * i + 1
            let right = 2 * i + 2
            var smallest = left // Assume left is smallest node of the two children

            // Find which is smaller left or right
            // If right is smaller set smallest to be right
            if right < heap.count && isLess(right, left) { smallest = right }

            // Stop if we're outside the bounds of the tree
            // stop early if we cannot sink index anymore
            if left >= heap.count || isLess(i, smallest) { return }

            // Move down the tree following the smallest node
            swap(smallest, i)
            i = smallest
        }
    }

    // Swap two nodes. Assumes index1 & index2 are valid, O(1)
    private mutating func swap(_ index1: Int, _ index2: Int) {
        let value1 = heap[index1]
        let value2 = heap[index2]
        
        heap[index1] = value2
        heap[index2] = value1

        // Swap the priority of two nodes internally within the priorities array
        let p1 = priorities[index1]
        let p2 = priorities[index2]
        
        priorities[index1] = p2
        priorities[index2] = p1

        // Swap the index of two nodes internally within the map
        map[value1]?.remove(index1)
        map[value2]?.remove(index2)

        map[value1]?.insert(index2)
        map[value2]?.insert(index1)
    }

    // Logarithmic removal with map, O(log(n))
    public mutating func remove(value: Element) {
        guard let i = map[value]?.first else { return }
        remove(at: i)
    }

    // Removes a node at particular index, O(log(n))
    @discardableResult
    private mutating func remove(at index: Int) -> Element? {
        if isEmpty { return nil }

        let lastIndex = count - 1
        let removed = heap[index]
        swap(index, lastIndex)

        // Obliterate the value
        heap.removeLast()
        priorities.removeLast()
        // Removes the index at a given value, O(log(n))
        if var set = map[removed] {
            set.remove(index)
            map[removed] = set.isEmpty ? nil : set
        }

        // Removed last element
        if index == lastIndex { return removed }

        let elem = heap[index]

        // Try sinking element
        sink(index)

        // If sinking did not work try swimming
        if heap[index] == elem { swim(index) }

        return removed
    }

    // Recursively checks if this heap is a min heap
    // This method is just for testing purposes to make
    // sure the heap invariant is still being maintained
    // Called this method with index=0 to start at the root
    private func isMinHeap(_ index: Int) -> Bool {

        // If we are outside the bounds of the heap return true
        if index >= count { return true }

        let left = (2 * index) + 1
        let right = (2 * index) + 2

        // Make sure that the current node k is less than
        // both of its children left, and right if they exist
        // return false otherwise to indicate an invalid heap
        if left < count && !isLess(index, left) { return false }
        if right < count && !isLess(index, right) { return false }

        // Recurse on both children to make sure they're also valid heaps
        return isMinHeap(left) && isMinHeap(right)
    }

    // MARK: - Collection Conformance
    public subscript(index: Int) -> Element {
        get { heap[index] }
        set { heap[index] = newValue }
    }

    public var startIndex: Int { 0 }
    public var endIndex: Int { heap.count }

    public func index(after index: Int) -> Int {
        heap.index(after: index)
    }

    public func index(before index: Int) -> Int {
        heap.index(before: index)
    }
}

extension PriorityQueue where Element == Priority {
    public init(values: [Element]) {
        self.init(values: values, priorities: values)
    }

    public mutating func add(_ value: Element) {
        add(value, priority: value)
    }
}
