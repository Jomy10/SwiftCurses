import ncurses

public enum Direction {
	case up
	case down
	case left
	case right
}

extension WindowProtocol {
	/// move the cursor to `row`th row and `col`th column
	@inlinable
	public func move(row: Int32, col: Int32) throws {
		if ncurses.wmove(self.window, row, col) == ERR {
			throw CursesError(.moveOutsideOfWindow)
		}
	}

	@inlinable
	public func move(_ direction: Direction) throws {
		let (y, x) = self.yx.tuple
		switch direction {
			case .up: try self.move(row: y - 1, col: x)
			case .down: try self.move(row: y + 1, col: x)
			case .right: try self.move(row: y, col: x + 1)
			case .left: try self.move(row: y, col: x - 1)
		}
	}

	// TODO: in some implementations, refresh might be a macro
	@inlinable
	public func refresh() {
		// X/Open does not define any error conditions.
		ncurses.wrefresh(self.window)
	}
}
