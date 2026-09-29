import Testing

@testable import Loader_Vocabulary

@Suite
struct `Loader boundaries` {
    @Test
    func `symbol scopes compare by case and handle`() {
        var first = 0
        var second = 0
        unsafe withUnsafeMutablePointer(to: &first) { a in
            unsafe withUnsafeMutablePointer(to: &second) { b in
                let handleA = unsafe Loader.Library.Handle(rawValue: UnsafeMutableRawPointer(a))
                let handleB = unsafe Loader.Library.Handle(rawValue: UnsafeMutableRawPointer(b))

                #expect(unsafe Loader.Symbol.Scope.default == .default)
                #expect(unsafe Loader.Symbol.Scope.next == .next)
                #expect(unsafe Loader.Symbol.Scope.default != .next)
                #expect(unsafe Loader.Symbol.Scope.handle(handleA) == .handle(handleA))
                #expect(unsafe Loader.Symbol.Scope.handle(handleA) != .handle(handleB))
                #expect(unsafe Loader.Symbol.Scope.handle(handleA) != .default)
            }
        }
    }

    @Test
    func `empty section bounds expose no bytes`() {
        let bounds = unsafe Loader.Section.Bounds(imageAddress: nil, buffer: UnsafeRawBufferPointer(start: nil, count: 0))

        #expect(bounds.withBytes { $0.count } == 0)
        #expect(bounds.withSpan { $0.byteCount } == 0)
    }

    @Test
    func `section bounds expose every byte of the buffer in order`() {
        let bytes: [UInt8] = [0x00, 0x7F, 0x80, 0xFF]
        unsafe bytes.withUnsafeBytes { buffer in
            let bounds = unsafe Loader.Section.Bounds(imageAddress: nil, buffer: buffer)

            #expect(bounds.withBytes { span in (0..<span.count).map { span[$0] } } == bytes)
            #expect(bounds.withSpan { $0.byteCount } == 4)
        }
    }

    @Test
    func `a name with no platform identifiers equals only itself`() {
        let empty = Loader.Section.Name()

        #expect(empty == Loader.Section.Name())
        #expect(empty.hashValue == Loader.Section.Name().hashValue)
        #expect(empty != .swiftTestContentFallback)
    }
}
