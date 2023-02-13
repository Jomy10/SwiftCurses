import ncurses

/// Clear until option for `WindowProtocol.clear(until: ClearUntil)` method
public enum ClearUntil {
	/// erase the current line to the right of the cursor, inclusive, to the end
	/// of the current line.
	case endOfLine
	/// erase from the cursor to the end of screen.  That is, they erase all lines
	/// below the cursor in the window. Also, the current line to the right of the
	/// cursor, inclusive, is erased.
	case endOfScreen
}


extension WindowProtocol {
	@inlinable
	public func erase() {
		ncurses.werase(self.window)
	}

	@inlinable
	public func clear() {
		ncurses.wclear(self.window)
	}

	@inlinable
	/// when `unitl` is `.endOfLine`, this function can throw if the cursor
	/// is about to wrap.
	public func clear(until: ClearUntil) throws {
		switch until {
			case .endOfLine:
				if ncurses.wclrtoeol(self.window) == ERR {
					throw CursesError(.cursorAboutToWrap)
				}
			case .endOfScreen:
				ncurses.wclrtobot(self.window)
		}
	}
}
