import ncurses
import Foundation

extension NCursesScreen {
    //=======
    // getch
    //=======

    /// Get a UTF-8 character from the user
    @discardableResult
    public func getChar() throws -> Character {
        var c: wchar_t = wchar_t.init()
        return try withUnsafeMutablePointer(to: &c) { (ptr: UnsafeMutablePointer<wchar_t>) throws in
            if ncurses.swift_get_wch(ptr) == ERR {
                throw CursesError(.Error)
            }
            // https://developer.apple.com/forums/thread/655947
            let data = Data(bytes: ptr, count: MemoryLayout<wchar_t>.stride)
            return String(data: data, encoding: self.string32Encoding)!.first.unsafelyUnwrapped // should always return a valid character (todo check)
        }
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
                return ncurses.vwscanw(self.screen, mutFormatPtr, valist)
            }
        }) == ERR {
            throw CursesError(.Error)
        }
    }

    //========
    // getstr
    //========

    /// Read until a new line or carriage return is encountered
    /// the terminating character is not included in the returned string
    public func getStr() throws -> String {
        var c: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: Int(self.maxYX.x) + 1)
        ncurses.wgetstr(self.screen, c)
    }

    public func getStr(terminator: Character) {
        
    }
}
