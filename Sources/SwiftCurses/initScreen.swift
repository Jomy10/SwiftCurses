import ncurses
import Foundation

/// Start a new curses mode terminal
///
/// - Parameters:
///     - `settings`: NCurses settings
public func initScreen(settings: [ScreenSetting] = ScreenSetting.defaultSettings, update: (inout NCursesScreen) throws -> Bool) throws {
    let _scr = initscr()! // start curses mode
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply(_scr) }
    ncurses.setlocale(LC_ALL, "")

    var scr = NCursesScreen(screen: _scr)
    while (try update(&scr)) {
        refresh()
    }
}

public struct NCursesScreen {
    @usableFromInline
    let screen: OpaquePointer
    private let string32Encoding: String.Encoding

    public init(screen: OpaquePointer) {
        self.screen = screen
        // Detect system encoding -> used for wide characters
        self.string32Encoding = (1.littleEndian == 1) ? .utf32LittleEndian : .utf32BigEndian
    }

    /// printf-style printing to the screen
    public func printw(_ fmt: String, _ args: Any...) throws {
        if ncurses.swift_printw(fmt, getVaList(
            try args
                .map { if let arg = $0 as? CVarArg { return arg } else { throw CursesError(.Error) } }
        )) == ERR {
            throw CursesError(.Error)
        }
    }

    /// Get a UTF-8 character from the user
    @discardableResult
    public func getChar() throws -> Character {
        var c: wchar_t = wchar_t.init()
        return try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) throws in
            if ncurses.swift_get_wch(OpaquePointer(ptr)) == ERR {
                throw CursesError(.Error)
            }
            // https://developer.apple.com/forums/thread/655947
            let data = Data(bytes: ptr, count: MemoryLayout<wchar_t>.stride)
            return String(data: data, encoding: self.string32Encoding)!.first.unsafelyUnwrapped // should always return a valid character (todo check)
        }
    }

}
