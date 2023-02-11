import ncurses

extension WindowProtocol {
    //========
    // printw 
    //========

    public func print(_ items: Any..., separator: String = " ") throws {
        try self.addStr(items.map { String(describing: $0) }.joined(separator: separator))
    }

    @inlinable
    public func print(row: Int32, col: Int32, _ items: Any..., separator: String = " ") throws {
        try self.move(row: row, col: col)
        try self.print(items, separator)
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

    //======
    // adch
    //======
    
    public func addChar(_ ch: Character) throws {
        let u32 = ch.unicodeScalars.map { wchar_t(bitPattern: $0.value) } + [0] // null-terminated UTF-8 character
        if ncurses.swift_waddwstr(
            self.window,
            u32.withUnsafeBufferPointer { $0.baseAddress! }
        ) == ERR {
            throw CursesError(.error, help: "https://invisible-island.net/ncurses/man/curs_addch.3x.html#h2-RETURN-VALUE")
        }
    }

    /// - `mvaddch`
    @inlinable
    public func addChar(row: Int32, col: Int32, ch: Character) throws {
        try self.move(row: row, col: col)
        try self.addChar(ch)
    }
}
