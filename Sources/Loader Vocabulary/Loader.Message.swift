internal import ASCII
public import Ownership
public import String

extension Loader {

    public struct Message: Sendable {

        public let text: Ownership.Immutable<String>

        public init(_ text: consuming String) {
            self.text = Ownership.Immutable(text)
        }

        @inlinable
        public init(ascii literal: StaticString) {
            self.text = Ownership.Immutable(String(ascii: literal))
        }

        @unsafe
        public init(copying view: borrowing String.Borrowed) {
            self.text = Ownership.Immutable(String(copying: view))
        }
    }
}
