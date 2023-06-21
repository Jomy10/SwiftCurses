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

	/// Move the cursor `x` step(s) into the specified direction
	@inlinable
	public func move(_ direction: Direction, times steps: Int32 = 1) throws {
		let (y, x) = self.yx.tuple
		switch direction {
			case .up: try self.move(row: y - steps, col: x)
			case .down: try self.move(row: y + steps, col: x)
			case .right: try self.move(row: y, col: x + steps)
			case .left: try self.move(row: y, col: x - steps)
		}
	}

	/// Move the cursor to the specified coordinate
	@inlinable
	public func move(to positon: Coordinate) throws {
		try self.move(row: position.y, col: position.x)
	}

	// TODO: in some implementations, refresh might be a macro
	/// Refreshes the screen, drawing anything that hasn't been drawn yet
	@inlinable
	public func refresh() {
		// X/Open does not define any error conditions.
		ncurses.wrefresh(self.window)
	}
}
