# swift-loader-vocabulary

Use this package when you implement or consume a platform's dynamic loader binding and need the shared, platform-neutral values it speaks in: which binary section to read (`Loader.Section.Name`), the bytes found there (`Loader.Section.Bounds`), an opened library (`Loader.Library.Handle`), where a symbol lookup searches (`Loader.Symbol.Scope`), and why an operation failed (`Loader.Error`). It performs no loading itself. To discover types, enumerate sections or look up symbols in the running process, use the sibling `swift-loader` instead.

## Laws

- `Loader.Section.Name` holds one identifier per object format (Mach-O segment and section, ELF, PE), each optional. Two names are equal exactly when, for every format, both lack the identifier or both have identifiers with the same UTF-8 bytes. Equality and hashing compare content, never the `StaticString` storage, so names built from distinct literals or from scalar and pointer representations of the same text are equal and hash equal. A name with no identifiers equals only another name with none.
- `Loader.Section.Name.swiftTestContentFallback` names a Mach-O section only and has no ELF or PE identifier.
- `Loader.Library.Handle` equality is identity of the raw pointer. `Loader.Symbol.Scope` values are equal when they are the same case and, for `.handle`, carry equal handles.
- `Loader.Section.Bounds` does not own its bytes. `withBytes` and `withSpan` expose every byte of the buffer, in order, and an empty buffer with no base address yields an empty span. The image address is carried alongside and is not part of either view.
