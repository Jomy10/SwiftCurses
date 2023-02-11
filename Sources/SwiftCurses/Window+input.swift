import ncurses
import Foundation

extension Window {
    //=======
    // getch
    //=======

    /// Get a UTF-8 character from the user
    @discardableResult
    public func getChar() throws -> Character {
        var c: wchar_t = wchar_t.init()
        return try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) throws in
            if ncurses.swift_get_wch(ptr) == ERR {
                throw CursesError(.getCharError)
            }
            // https://developer.apple.com/forums/thread/655947
            let data = Data(bytes: ptr, count: MemoryLayout<wchar_t>.stride)
            return String(data: data, encoding: string32Encoding)!.first.unsafelyUnwrapped // should always return a valid character (todo check)
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
        while (c != terminator) {
            s.append(c)
            c = try self.getChar()
        }
        return s
    }
}
