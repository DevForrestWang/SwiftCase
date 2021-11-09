public class ACState {
    public var depth: Int

    private var rootState: ACState?

    private var success: [Character: ACState] = [:]

    public var failure: ACState?
    public var emits: Set<String> = []

    convenience init() {
        self.init(depth: 0)
    }

    init(depth: Int) {
        self.depth = depth
        rootState = depth == 0 ? self : nil
    }

    public func nextState(for character: Character, ignoreRootState: Bool) -> ACState? {
        var nextState = success[character]

        if !ignoreRootState, nextState == nil, rootState != nil {
            nextState = rootState
        }

        return nextState
    }

    public func addState(for character: Character) -> ACState {
        return nextState(for: character, ignoreRootState: true) ?? {
            let nextState = ACState(depth: depth + 1)
            success[character] = nextState

            return nextState
        }()
    }

    public func addEmit(_ keyword: String) {
        emits.insert(keyword)
    }

    public func addEmit(_ emits: [String]) {
        for emit in emits {
            addEmit(emit)
        }
    }

    var states: [ACState] {
        return Array(success.values)
    }

    var transitions: [Character] {
        return Array(success.keys)
    }
}
