import ncurses
import C_ncursesBinds

// https://invisible-island.net/ncurses/man/curs_border.3x.html
// X/Open does not define any error conditions. This implementation returns an error if the window pointer is null.
extension WindowProtocol {
	//=========
	// Borders
	//=========

	// TODO: UTF-8 support
	@inlinable
	public func box(_ vertCh: Character = "\u{0}", _ horCh: Character = "\u{0}") {
		// X/Open does not define any error conditions. This implementation returns an error if the window pointer is null.
		ncurses.box(self.window, UInt32(vertCh.asciiValue!), UInt32(horCh.asciiValue!))
	}

	@inlinable
	public func box(_ vertCh: UInt32, _ horCh: UInt32) {
		// X/Open does not define any error conditions. This implementation returns an error if the window pointer is null.
		ncurses.box(self.window, vertCh, horCh)
	}

	// TODO: UTF-8 support
	/// - fatal error:
	///		- If the character cannot be converted to an ASCII value
	@inlinable
	public func border(
		// sides
		left ls: Character = "\u{0}",
		right rs: Character = "\u{0}",
		top ts: Character = "\u{0}",
		bottom bs: Character = "\u{0}",
		// corners
		topLeft tl: Character = "\u{0}",
		topRight tr: Character = "\u{0}",
		bottomLeft bl: Character = "\u{0}",
		bottomRight br: Character = "\u{0}"
	) {
		self.border(
			left: UInt32(ls.asciiValue!),
			right: UInt32(rs.asciiValue!),
			top: UInt32(ts.asciiValue!),
			bottom: UInt32(bs.asciiValue!),
			topLeft: UInt32(tl.asciiValue!),
			topRight: UInt32(tr.asciiValue!),
			bottomLeft: UInt32(bl.asciiValue!),
			bottomRight: UInt32(br.asciiValue!)
		)
	}

	/// If any values are zero, then the default values are used
	public func border(
		// sides
		left ls: UInt32,
		right rs: UInt32,
		top ts: UInt32,
		bottom bs: UInt32,
		// corners
		topLeft tl: UInt32,
		topRight tr: UInt32,
		bottomLeft bl: UInt32,
		bottomRight br: UInt32
	) {
		ncurses.wborder(self.window, ls, rs, ts, bs, tl, tr, bl, br)
	}

	@inlinable
	public func clearBorder() {
		self.border(
			left: " ",
			right: " ",
			top: " ",
			bottom: " ",
			topLeft: " ",
			topRight: " ",
			bottomLeft: " ",
			bottomRight: " "
		)
	}

	//=======
	// Lines
	//=======

	@inlinable
	public func horLine(_ ch: Character = "\u{0}", _ n: Int32) {
		self.horLine(UInt32(ch.asciiValue!), n)
	}

	public func horLine(_ ch: UInt32, _ n: Int32) {
		ncurses.whline(self.window, ch, n)
	}

	@inlinable
	public func horLine(row y: Int32, col x: Int32, _ ch: Character = "\u{0}", _ n: Int32) throws {
		try self.horLine(row: y, col: x, UInt32(ch.asciiValue!), n)
	}

	@inlinable
	public func horLine(row y: Int32, col x: Int32, _ ch: UInt32, _ n: Int32) throws {
		try self.move(row: y, col: x)
		self.horLine(ch, n)
	}

	@inlinable
	public func vertLine(_ ch: Character = "\u{0}", _ n: Int32) {
		self.vertLine(UInt32(ch.asciiValue!), n)
	}

	public func vertLine(_ ch: UInt32, _ n: Int32) {
		ncurses.wvline(self.window, ch, n)
	}

	@inlinable
	public func vertLine(row y: Int32, col x: Int32, _ ch: Character = "\u{0}", _ n: Int32) throws {
		try self.vertLine(row: y, col: x, UInt32(ch.asciiValue!), n)
	}

	@inlinable
	public func vertLine(row y: Int32, col x: Int32, _ ch: UInt32, _ n: Int32) throws {
		try self.move(row: y, col: x)
		self.vertLine(ch, n)
	}
}
