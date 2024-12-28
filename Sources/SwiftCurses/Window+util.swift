import ncurses
import C_ncursesBinds

extension swift_YX {
	@inlinable public var row: Int32 { self.x }
	@inlinable public var col: Int32 { self.y }
	/// Convert the `Coordinate` struct to a tuple of the form `(y, x)`
	@inlinable public var tuple: (Int32, Int32) { (self.y, self.x) }
}

extension swift_YX: @retroactive Equatable, @retroactive Hashable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.x)
    hasher.combine(self.y)
  }
}

extension swift_YX: @retroactive CustomStringConvertible {
  public var description: String {
    "(row: \(self.row), col: \(self.col))"
  }
}

public typealias Coordinate = swift_YX

extension WindowProtocol {
	/// Beginning coordinates
	public var begYX: Coordinate {
		return swift_getbegyx(self.window)
	}

	/// Size of the window
	public var maxYX: Coordinate {
		return swift_getmaxyx(self.window)
	}

	/// Current cursor position
	public var yx: Coordinate {
		return swift_getyx(self.window)
	}

	/// Get the position of the cursor in the parent window
	/// If the window is not a subwindow, nil is returned
	public var parentYX: Coordinate? {
		let yx: swift_YX = swift_getparyx(self.window)
		return yx.y == -1 ? nil : yx
	}
}
