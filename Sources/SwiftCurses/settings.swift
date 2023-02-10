import ncurses

// TODO: documentation > https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html
public enum ScreenSetting {
    case raw
    case cbreak
    case noEcho
    case echo
	case keypad
    case halfdelay(Int32)
    // TODO: add other options: https://linux.die.net/man/3/raw
}

extension ScreenSetting {
    public static var defaultSettings: [ScreenSetting] {
        [.raw, .noEcho, .keypad]
    }

    // TODO: error handling of options
	@usableFromInline
    func apply(_ scr: OpaquePointer) throws {
        switch self {
            case .raw:
                ncurses.raw()
            case .cbreak:
                ncurses.cbreak()
            case .noEcho:
                ncurses.noecho()
            case .echo:
                ncurses.echo()
			case .keypad:
				ncurses.keypad(scr, true)
            case .halfdelay(let delay):
                if ncurses.halfdelay(delay) == ERR {
                    throw CursesError(.halfdelayParameterOutsideOfRange)
                }
        }
    }
}

