public protocol Interval: Comparable, Hashable, CustomStringConvertible {
    var start: Int { get set }
    var end: Int { get set }
    var size: Int { get }
}

extension Interval {
    public var size: Int {
        return end - start + 1
    }

    func overlaps<T: Interval>(with other: T) -> Bool {
        return start <= other.end &&
            end >= other.start
    }

    func overlaps(with point: Int) -> Bool {
        return start <= point && point <= end
    }
}

public extension Interval {
    var description: String {
        return "\(start):\(end)"
    }
}

public func == <T: Interval, U: Interval>(lhs: T, rhs: U) -> Bool {
    return lhs.start == rhs.start &&
        lhs.end == rhs.end
}

public extension Interval {
    var hashValue: Int {
        return start % 100 + end % 100
    }
}

public func < <T: Interval, U: Interval>(lhs: T, rhs: U) -> Bool {
    if lhs.start == rhs.start {
        return lhs.end < rhs.end
    } else {
        return lhs.start < rhs.start
    }
}
