public struct MatchToken: ACToken {
    public var fragment: String
    public var emit: ACEmit?
    public var isMatch: Bool { return true }
}
