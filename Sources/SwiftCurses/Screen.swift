public struct NCursesScreen {
    @usableFromInline
    let screen: OpaquePointer
    let string32Encoding: String.Encoding

    public init(screen: OpaquePointer) {
        self.screen = screen
        // Detect system encoding -> used for wide characters
        self.string32Encoding = (1.littleEndian == 1) ? .utf32LittleEndian : .utf32BigEndian
    }
}
