public protocol ACToken {
    var fragment: String { get set }
    var isMatch: Bool { get }
    var emit: ACEmit? { get }
}
