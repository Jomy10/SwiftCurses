import ncurses

// TODO: extended colors extension and other extensions

public typealias ColorPairId = Int16
public typealias ColorId = Int16
public typealias ColorRGB = Int16

// TODO: conform to OptionSet
public struct Color {
	/// Whether the terminal can manipulate colors.
	///
	/// This routine facilitates writing terminal-independent programs.
	/// For example, a programmer can use it to decide whether to use color or
	/// some other video attribute.
	public static let hasColors: Bool = has_colors()

	public static let black		= ColorId(COLOR_BLACK)
	public static let red		= ColorId(COLOR_RED)
	public static let green		= ColorId(COLOR_GREEN)
	public static let yellow	= ColorId(COLOR_YELLOW)
	public static let blue		= ColorId(COLOR_BLUE)
	public static let magenta	= ColorId(COLOR_MAGENTA)
	public static let cyan		= ColorId(COLOR_CYAN)
	public static let white		= ColorId(COLOR_WHITE)

	/// Whether the terminal supports color and can change their definition.
	///
	/// This routine facilitates writing terminal-independent programs.
	public static let canChangeColor: Bool = can_change_color()

	public static let maxColors = COLORS

	public static func forceXTerm256Color() {
		setenv("TERM","xterm-256color", 1)
	}

	public static func define(_ id: ColorId, r: ColorRGB, g: ColorRGB, b: ColorRGB) throws {
		if ncurses.init_color(id, r, g, b) == ERR {
			if !(0...1000).contains(r) {
				throw CursesError(
					.rgbValueOutOfRange,
					help: "red value out of range"
				)
			} else if !(0...1000).contains(g) {
				throw CursesError(
					.rgbValueOutOfRange,
					help: "green value out of range"
				)
			} else if !(0...1000).contains(b) {
				throw CursesError(
					.rgbValueOutOfRange,
					help: "blue value out of range"
				)
			} else {
				throw CursesError(
					.colorUnsupported
				)
			}
		}
	}

	public struct Content {
		public var r, g, b: ColorRGB
		init() {
			self.r = -1
			self.g = -1
			self.b = -1
		}
	}

	public static func content(for id: ColorId) throws -> Color.Content {
		var content = Content()
		ncurses.color_content(id, &content.r, &content.g, &content.b)
		if [content.r, content.g, content.b].contains(-1) {
			throw CursesError(.colorChangeUnsupported)
		}
		return content
	}
}

public struct ColorPair {
	public static let maxPairs = COLOR_PAIRS

	/// changes the definition of a color-pair
	///
	/// equal to the `init_pair` subroutine
	public static func define(_ id: ColorPairId, fg: ColorId, bg: ColorId) throws {
		if ncurses.init_pair(id, fg, bg) == ERR {
			if !(0..<Int16(ColorPair.maxPairs)).contains(id) {
				throw CursesError(
					.colorPairOutsideOfRange,
					help: "Color pair outside of the range 0 to \(ColorPair.maxPairs - 1)"
				)
			} else if !(0..<Int16(Color.maxColors)).contains(fg) {
				throw CursesError(
					.colorOutsideOfRange,
					help: "Foreground color outside of range 0 to \(Color.maxColors - 1)"
				)
			} else if !(0..<Int16(Color.maxColors)).contains(bg) {
				throw CursesError(
					.colorOutsideOfRange,
					help: "Background color outside of range 0 to \(Color.maxColors - 1)"
				)
			} else {
				throw CursesError(.error)
			}
		}
	}

	public struct Content {
		public var fg, bg: ColorId
		init() {
			self.fg = -1
			self.bg = -1
		}
	}

	public static func content(for id: ColorPairId) throws -> ColorPair.Content {
		var content = Content()
		ncurses.pair_content(id, &content.fg, &content.bg)
		if [content.fg, content.bg].contains(-1) {
			throw CursesError(.uninitializedColorPair)
		}
		return content
	}
}
