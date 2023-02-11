import ncurses

extension WindowProtocol {
	/// move the cursor to `row`th row and `col`th column
	@inlinable
	public func move(row: Int32, col: Int32) throws {
		if ncurses.wmove(self.window, row, col) == ERR {
			throw CursesError(.moveOutsideOfWindow)
		}
	}

	// TODO: in some implementations, refresh might be a macro
	@inlinable
	public func refresh() {
		// X/Open does not define any error conditions.
		ncurses.wrefresh(self.window)
	}
}
