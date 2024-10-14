import ncurses

public enum CursorVisibility: Int32, Sendable, Hashable {
	case invisible = 0
	case normal = 1
	case veryVisible = 2
}

@inlinable
public func cursorSet(_ visibility: CursorVisibility) {
	ncurses.curs_set(visibility.rawValue) // no error, because controlled visibility values
}

/// Save the program, exit it to return to shell mode. Afterwards, restore the program
public func shellMode(_ body: () throws -> ()) rethrows {
	ncurses.def_prog_mode()
	ncurses.endwin()
	// cooked mode
	try body()
	ncurses.reset_prog_mode()
	ncurses.refresh()
}
