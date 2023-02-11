import ncurses

extension NCursesScreen {
	/// move the cursor to `row`th row and `col`th column
	@inlinable
	public func move(row: Int32, col: Int32) throws {
		if ncurses.wmove(self.screen, row, col) == ERR {
			throw CursesError(.MoveOutsideOfWindow)
		}
	}
}
