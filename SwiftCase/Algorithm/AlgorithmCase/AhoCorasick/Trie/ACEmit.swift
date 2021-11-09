public struct ACEmit: Interval {
    public var start: Int
    public var end: Int
    public var keyword: String
}

extension ACEmit: CustomStringConvertible {
    public var description: String {
        return "\(start):\(end)=\(keyword)"
    }
}

extension ACEmit: Equatable {}
