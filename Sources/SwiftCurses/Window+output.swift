import ncurses
import C_ncursesBinds

extension WindowProtocol {
    //========
    // printw
    //========

    @inlinable
    internal func printArgs(_ items: [Any], _ separator: String) throws {
        try self.addStr(items.map { String(describing: $0) }.joined(separator: separator))
    }

    public func print(_ items: Any..., separator: String = " ") throws {
        try self.printArgs(items, separator)
    }

    @inlinable
    public func print(row: Int32, col: Int32, _ items: Any..., separator: String = " ") throws {
        try self.move(row: row, col: col)
        try self.printArgs(items, separator)
    }

    @inlinable
    public func print(at pos: Coordinate, _ items: Any..., separator: String = " ") throws {
        try self.move(row: pos.y, col: pos.x)
        try self.printArgs(items, separator)
    }

    //========
    // addstr
    //========

    @inlinable
    public func addStr(_ str: String) throws {
        if ncurses.waddstr(self.window, str) == ERR {
            throw CursesError(.error, help: "https://invisible-island.net/ncurses/man/curs_addstr.3x.html#h2-RETURN-VALUE")
        }
    }

    @inlinable
    public func addStr(row: Int32, col: Int32, _ str: String) throws {
        try self.move(row: row, col: col)
        try self.addStr(str)
    }

    @inlinable
    public func addStr(at pos: Coordinate, _ str: String) throws {
        try self.addStr(row: pos.y, col: pos.x, str)
    }

    //======
    // adch
    //======

    public func addChar(_ ch: Character) throws {
        let u32 = ch.unicodeScalars.map { wchar_t(bitPattern: $0.value) } + [0] // null-terminated UTF-8 character
        if swift_waddwstr(
            self.window,
            u32.withUnsafeBufferPointer { $0.baseAddress! }
        ) == ERR {
            if !ncurses.is_scrollok(self.window) {
                throw CursesError(.unableToAddCompleteCharToScreen, help: "This may be due to adding a character to the bottom right corner: https://invisible-island.net/ncurses/man/curs_add_wch.3x.html#h2-RETURN-VALUE")
            } else {
                throw CursesError(.unableToAddCompleteCharToScreen, help: "https://invisible-island.net/ncurses/man/curs_add_wch.3x.html#h2-RETURN-VALUE")
            }
        }
    }

    /// - `mvaddch`
    @inlinable
    public func addChar(row: Int32, col: Int32, _ ch: Character) throws {
        try self.move(row: row, col: col)
        try self.addChar(ch)
    }

    @inlinable
    public func addChar(at pos: Coordinate, _ ch: Character) throws {
        try self.addChar(row: pos.y, col: pos.x, ch)
    }
}
