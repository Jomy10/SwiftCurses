import ncurses

extension ncurses.swift_YX {
	@inlinable public var row: Int32 { self.x }
	@inlinable public var col: Int32 { self.y }
	/// Convert the `Coordinate` struct to a tuple of the form `(y, x)`
	@inlinable public var tuple: (Int32, Int32) { (self.y, self.x) }
}

public typealias Coordinate = ncurses.swift_YX

extension Window {
	/// Beginning coordinates
	public var begYX: Coordinate {
		return ncurses.swift_getbegyx(self.window)
	}

	/// Size of the window
	public var maxYX: Coordinate {
		return ncurses.swift_getmaxyx(self.window)
	}

	/// Current cursor position
	public var yx: Coordinate {
		return ncurses.swift_getyx(self.window)
	}

	/// Get the position of the cursor in the parent window
	/// If the window is not a subwindow, nil is returned
	public var parentYX: Coordinate? {
		let yx: ncurses.swift_YX = ncurses.swift_getparyx(self.window)
		return yx.y == -1 ? nil : yx
	}
}
