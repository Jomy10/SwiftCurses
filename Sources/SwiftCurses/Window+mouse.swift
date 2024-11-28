import ncurses
import C_ncursesBinds

public enum TrafoKind: Sendable, Hashable {
	/// x and y are window-relative coordinates and will be converted to
	/// stdscr-relative coordinates
	case toStdScrn
	case toWindow

	@usableFromInline
	var rawValue: Bool {
		switch self {
			case .toStdScrn: return false
			case .toWindow: return true
		}
	}
}

extension WindowProtocol {
	/// The trafo function transforms a given pir of coordinates from stdscr-relative
	/// coordinates to coordinates relative to the given window or vice versa. The
	/// The resulting stdscr-relative coordinates are  not  always  identical  to window-relative coordinates due to the mechanism to
	/// reserve lines on top or bottom of the screen for  other  purposes  (see the ripoffline and slk_init(3x) calls, for example).
	///
	/// - Returns:
	///		- false:
	///			- when kind `.toStdScrn`; if the location is not inside the window
	///			- when kind `.toWindow`; always returns true
	@inlinable
	public func mouseTrafo(y: inout Int32, x: inout Int32, kind: TrafoKind) -> Bool {
		return ncurses.wmouse_trafo(self.window, &y, &x, kind.rawValue)
	}

	/// The trafo function transforms a given pir of coordinates from stdscr-relative
	/// coordinates to coordinates relative to the given window or vice versa. The
	/// The resulting stdscr-relative coordinates are  not  always  identical  to window-relative coordinates due to the mechanism to
	/// reserve lines on top or bottom of the screen for  other  purposes  (see the ripoffline and slk_init(3x) calls, for example).
	///
	/// - Returns:
	///		- false:
	///			- when kind `.toStdScrn`; if the location is not inside the window
	///			- when kind `.toWindow`; always returns true
	public func mouseTrafo(y: Int32, x: Int32, kind: TrafoKind) -> (Bool, y: Int32, x: Int32) {
		var (lx, ly) = (x, y)
		let b = ncurses.wmouse_trafo(self.window, &ly, &lx, kind.rawValue)
		return (b, ly, lx)
	}

	/// `wenclose`
	public func encloses(y: Int32, x: Int32) -> Bool {
		ncurses.wenclose(self.window, y, x)
	}
}
