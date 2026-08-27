internal import ASCII
public import Ownership
public import String

extension Loader {

    public struct Message: Sendable {

        public let text: Ownership.Immutable<String.String>

        public init(_ text: consuming String.String) {
            self.text = Ownership.Immutable(text)
        }

        @inlinable
        public init(ascii literal: StaticString) {
            self.text = Ownership.Immutable(String.String(ascii: literal))
        }

        @unsafe
        public init(copying view: borrowing String.String.Borrowed) {
            self.text = Ownership.Immutable(String.String(copying: view))
        }
    }
}
