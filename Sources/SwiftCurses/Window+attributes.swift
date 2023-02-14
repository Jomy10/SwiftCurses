import ncurses

public enum Attribute {
	case normal
	case standout
	case underline
	case reverse
	case blink
	case dim
	case bold
	case protect
	case invisible
	case altCharset
	case chartext
	case colorPair(_ n: Int32)
	case italic
}

extension Attribute {
	@inlinable
	var value: Int32 {
		switch self {
		case .normal:
			return ncurses.swift_A_NORMAL
		case .standout:
			return ncurses.swift_A_STANDOUT
		case .underline:
			return ncurses.swift_A_UNDERLINE
		case .reverse:
			return ncurses.swift_A_REVERSE
		case .blink:
			return ncurses.swift_A_BLINK
		case .dim:
			return ncurses.swift_A_DIM
		case .bold:
			return ncurses.swift_A_BOLD
		case .protect:
			return ncurses.swift_A_PROTECT
		case .invisible:
			return ncurses.swift_A_INVIS
		case .altCharset:
			return ncurses.swift_A_ALTCHARSET
		case .chartext:
			return ncurses.swift_A_CHARTEXT
		case .colorPair(let n):
			return swift_COLOR_PAIR(n)
		case .italic:
			return ncurses.swift_A_ITALIC
		}
	}
}

extension [Attribute] {
	@usableFromInline
	func combine() -> Int32 {
		if self.count == 1 {
			return self[0].value
		} else {
			return self.reduce(0) { $0 | $1.value }
		}
	}
}

extension WindowProtocol {
	@inlinable
	public func attrOn(_ attrs: Attribute...) {
		self.attrOn(attrs)
	}

	@inlinable
	public func attrOn(_ attrs: [Attribute]) {
		ncurses.wattron(self.window, attrs.combine())
	}

	@inlinable
	public func attrSet(_ attrs: Attribute...) {
		ncurses.wattrset(self.window, attrs.combine())
	}

	@inlinable
	public func attrOff(_ attrs: Attribute...) {
		self.attrOff(attrs)
	}

	@inlinable
	public func attrOff(_ attrs: [Attribute]) {
		ncurses.wattroff(self.window, attrs.combine())
	}

	public func withAttrs(_ attrs: Attribute..., body: () throws -> ()) rethrows {
		self.attrOn(attrs)

		try body()

		// TODO: resotre previous intead of turning off
		self.attrOff(attrs)
	}

	@inlinable
	public func standEnd() {
		ncurses.wstandend(self.window)
	}

	@available(*, unavailable)
	public func attrGet() -> Int32 {
		// TODO
		return 0
	}

	@inlinable
	func chgat(_ n: Int32, _ attrs: [Attribute], color pair: Int16, opts: UnsafeRawPointer? = nil) {
		ncurses.wchgat(self.window, n, attr_t(attrs.combine()), pair, opts)
	}

	@inlinable
	public func chgat(row: Int32, col: Int32, _ n: Int32, _ attrs: Attribute..., color pair: Int16, opts: UnsafeRawPointer? = nil) throws {
		try self.move(row: row, col: col)
		self.chgat(n, attrs, color: pair, opts: opts)
	}

	/// change the attributes of already printed text
	// TODO: better documentation/more expressive
	@inlinable
	public func chgat(_ n: Int32, _ attrs: Attribute..., color pair: Int16, opts: UnsafeRawPointer? = nil) {
		self.chgat(n, attrs, color: pair, opts: opts)
	}
}
