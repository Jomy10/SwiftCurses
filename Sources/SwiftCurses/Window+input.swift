import ncurses
#if canImport(Foundation)
import Foundation
#endif

// Detect system encoding -> used for wide characters
let string32Encoding: String.Encoding = (1.littleEndian == 1) ? .utf32LittleEndian : .utf32BigEndian

public typealias WideChar = wchar_t

extension WideChar {
    /// Get the character value
    public var char: Character {
        #if canImport(Foundation)
        withUnsafePointer(to: self) { ptr in
            let data = Data(bytes: ptr, count: MemoryLayout<wchar_t>.stride)
            return String(data: data, encoding: string32Encoding)!.first.unsafelyUnwrapped // should always return a valid character (todo check)
        }
        #else
        guard let bytes = wcharToBytes(self) else {
            return Character("\0")
        }

        return String(cString: bytes).first.unsafelyUnwrapped
        #endif
    }

    /// Get the KeyCode value
    public var code: Int32 {
        guard let bytes = wcharToBytes(self) else {
            return -1
        }

        return Int32(bytes[0])
    }

    public static func ==(lhs: WideChar, rhs: Character) -> Bool {
        return lhs.char == rhs
    }

    public static func !=(lhs: WideChar, rhs: Character) -> Bool {
        return lhs.char != rhs
    }

    // will wchar_t ever be invalid causing the c function to fail?
    // public func code() throws -> Int32 {
        
    // }
}

extension WindowProtocol {
    //=======
    // getch
    //=======

    /// Get a UTF-8 character from the user.
    ///
    /// - Returns:
    ///    - A `WideChar`, the KeyCode can be gotten using `WideChar.code` and
    ///      the the Character itelf can be gotten with `WideChar.char`
    @discardableResult
    public func getChar() throws -> WideChar {
        var c: wchar_t = wchar_t.init()
        try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) throws in
            if ncurses.swift_get_wch(ptr) == ERR {
                throw CursesError(.getCharError)
            }
        }
        return c
    }

    /// Get the ASCII value of the character or keypress (when using keypad mode)
    @discardableResult
    public func getCharCode() throws -> Int32 {
        let c = ncurses.wgetch(self.window)
        if c != OK {
            if c == ERR {
                throw CursesError(.timeoutWithoutData)
            } else if c == EINTR {
                throw CursesError(.interrupted)
            }
        }
        return c
    }

    /// Get a `WideChar`. This can then be converted to either a `Character` using `.char` or a CharCode (of type `Int32`) uing `.code`
    @discardableResult
    @available(*, deprecated, message: "Use getChar instead")
    public func getWChar() throws -> WideChar {
        var c: wchar_t = wchar_t.init()
        try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) throws in
            if ncurses.swift_get_wch(ptr) == ERR {
                throw CursesError(.getCharError)
            }
        }
        return c
    }

    //=======
    // scanw
    //=======

    // TODO: fix
    @available(*, unavailable)
    public func scan(_ format: String, _ args: UnsafeMutableRawPointer...) throws {
        if (withVaList(args.map { OpaquePointer($0) as CVarArg }) { valist in
            let cString = format.cString(using: .utf8)!
            return withUnsafePointer(to: cString[0]) { formatPtr in
                let mutFormatPtr = UnsafeMutablePointer(mutating: formatPtr)
                return ncurses.vwscanw(self.window, mutFormatPtr, valist)
            }
        }) == ERR {
            throw CursesError(.error)
        }
    }

    //========
    // getstr
    //========

    /// Read until a new line or carriage return is encountered.
    /// the terminating character is not included in the returned string.
    /// The pointer returned should be deallocated manually.
    @discardableResult
    public func getStrPtr() throws -> UnsafePointer<CChar> {
        let c: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: Int(self.maxYX.x) + 1)
        let errno = ncurses.wgetstr(self.window, c) 
        if errno != OK {
            if errno == ERR {
                throw CursesError(.timeoutWithoutData)
            } else if errno == KEY_RESIZE {
                throw CursesError(.SIGWINCH)
            }
        }
        return UnsafePointer(c)
    }

    @discardableResult
    public func getStr() throws -> String {
        let ptr: UnsafePointer<CChar> = try self.getStrPtr()
        let s = String(cString: ptr)
        ptr.deallocate()
        return s
    }

    @discardableResult
    public func getStr(terminator: Character) throws -> String {
        var c = try self.getChar()
        var s = String()
        while (c != terminator) {
            s.append(c.char)
            c = try self.getChar()
        }
        return s
    }
}
