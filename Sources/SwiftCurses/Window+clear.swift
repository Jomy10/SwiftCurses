import ncurses
import C_ncursesBinds

/// Clear until option for `WindowProtocol.clear(until: ClearUntil)` method
public enum ClearUntil: Sendable, Hashable {
	/// erase the current line to the right of the cursor, inclusive, to the end
	/// of the current line.
	case endOfLine
	/// erase from the cursor to the end of screen.  That is, they erase all lines
	/// below the cursor in the window. Also, the current line to the right of the
	/// cursor, inclusive, is erased.
	case endOfScreen
}

extension WindowProtocol {
  /// copy blanks to every position in the window, clearing the screen
	@inlinable
	public func erase() {
		ncurses.werase(self.window)
	}

	/// like `erase`, but also calls `clearok`, so that the screen is cleared
	/// completely on the next call to `refresh` for the window and repainted
	/// from scratch
	@inlinable
	public func clear() {
		ncurses.wclear(self.window)
	}

	/// Erases the screen from the position of the current cursor, to `until`
	///
	/// when `unitl` is `.endOfLine`, this function can throw if the cursor
	/// is about to wrap.
	@inlinable
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
