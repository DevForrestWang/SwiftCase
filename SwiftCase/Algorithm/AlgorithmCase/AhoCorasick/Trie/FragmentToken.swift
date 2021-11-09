public struct FragmentToken: ACToken {
    public var fragment: String
    public var emit: ACEmit? { return nil }
    public var isMatch: Bool { return false }
}
