import ncurses
#if canImport(Foundation)
import Foundation
#endif

// Detect system encoding -> used for wide characters
let string32Encoding: String.Encoding = (1.littleEndian == 1) ? .utf32LittleEndian : .utf32BigEndian

public enum WideChar: Sendable, Hashable {
    /// A UTF-8 characer
    case char(Character)
    /// A KeyCode
    case code(Int32)
}

func wcharToCharacter(_ wc: wchar_t) throws -> Character {
    #if canImport(Foundation)
    return withUnsafePointer(to: wc) { ptr in
        let data = Data(bytes: ptr, count: MemoryLayout<wchar_t>.stride)
        return String(data: data, encoding: string32Encoding)!.first.unsafelyUnwrapped // should always return a valid character (todo check)
    }
    #else
    guard let bytes = wcharToBytes(wc) else {
        throw CursesError(.error)
    }

    return String(cString: bytes).first.unsafelyUnwrapped
    #endif
}

extension WindowProtocol {
    //=======
    // getch
    //=======

    /// Get a UTF-8 character from the user.
    ///
    /// - Returns:
    ///     - a `WideChar`: this is either a key code or a UTF-8 encoded character
    @discardableResult
    public func getChar() throws -> WideChar {
        var c: wchar_t = wchar_t.init()
        return try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) in
            let returnCode = ncurses.swift_wget_wch(self.window, ptr)
            switch (returnCode) {
                case ERR:
                    throw CursesError(.getCharError)
                case 256: // function keys
                    return .code(ptr.pointee)
                default: // OK > character
                    return .char(try wcharToCharacter(ptr.pointee))
            }
        }
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
        loop: while (true) {
            switch c {
                case .code(_): continue loop
                case .char(let char):
                    if char == terminator {
                        break loop
                    }
                    s.append(char)
            }
            c = try self.getChar()
        }
        return s
    }
}
