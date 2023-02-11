import ncurses

extension ncurses.swift_YX {
	@inlinable public var row: Int32 { self.x }
	@inlinable public var col: Int32 { self.y }
}

public typealias Coordinate = ncurses.swift_YX

extension NCursesScreen {
	/// Beginning coordinates
	public var begYX: Coordinate {
		return ncurses.swift_getbegyx(self.screen)
	}

	/// Size of the window
	public var maxYX: Coordinate {
		return ncurses.swift_getmaxyx(self.screen)
	}

	/// Current cursor position
	public var yx: Coordinate {
		return ncurses.swift_getyx(self.screen)
	}

	/// Get the position of the cursor in the parent window
	/// If the window is not a subwindow, nil is returned
	public var parentYX: Coordinate? {
		let yx: ncurses.swift_YX = ncurses.swift_paryx(self.screen)
		return yx.y == -1 ? nil : yx
	}
}
