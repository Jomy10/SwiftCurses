import ncurses

// TODO: documentation > https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html
/// https://invisible-island.net/ncurses/man/curs_inopts.3x.html
public enum TermSetting {
    case cbreak
    case noCbreak
    case echo
    case noEcho
    case nl
    case noNl
    /// Raw is similar to `cbreak`, the difference is that in raw mode, the interrupt,
    /// quit, suspend and flow control characters are passed through uninterreted instead
    /// of generating a signal
    case raw
    case noRaw
    case qiFlush
    case noQiFlush
    case halfdelay(_ tenths: Int32)
    case timeout(_ delay: Int32)
    case typeahead(_ fd: Int32)
    
    /// enable color support (equal to calling `start_color` in ncurses)
    case colors
}

/// https://invisible-island.net/ncurses/man/curs_inopts.3x.html
public enum WindowSetting {
    /// If this option is enabled and an interrupt key is passed on the keyboard (interrupt, break, quit),
    /// all output in the tty driver queue will be flushed, giving the effect of faster response to the interrupt,
    /// but causing curses to have the wrong idea of what is on the screen. The default setting for this
    /// option is inherited from the tty driver settings
    case intrflush(Bool)
    case keypad(Bool)
    case meta(Bool)
    case nodelay(Bool)
    case notimeout(Bool)
    case timeout(_ delay: Int32)
}

extension TermSetting {
    public static let defaultSettings: [TermSetting] = [.cbreak, .noEcho, .colors]
}

extension WindowSetting {
    public static let defaultSettings: [WindowSetting] = [.keypad(true)]
}

extension TermSetting {
    // TODO: error handling of options
	@usableFromInline
    func apply() throws {
        switch self {
            case .cbreak: ncurses.cbreak()
            case .noCbreak: ncurses.nocbreak()
            case .echo: ncurses.echo()
            case .noEcho: ncurses.noecho()
            case .nl: ncurses.nl()
            case .noNl: ncurses.nonl()
            case .raw: ncurses.raw()
            case .noRaw: ncurses.noraw()
            case .qiFlush: ncurses.qiflush()
            case .noQiFlush: ncurses.noqiflush()
            case .halfdelay(let delay):
                if ncurses.halfdelay(delay) == ERR {
                    throw CursesError(.halfdelayParameterOutsideOfRange)
                }
            case .timeout(let delay): ncurses.timeout(delay)
            case .typeahead(let fd): ncurses.typeahead(fd)
            case .colors:
                if ncurses.start_color() == ERR {
                    throw CursesError(.colorTableCannotBeAllocated)
                }
        }
    }
}

extension WindowSetting {
    @usableFromInline
    func apply(_ win: OpaquePointer) {
        switch self {
            case .intrflush(let bf): ncurses.intrflush(win, bf)
            case .keypad(let bf): ncurses.keypad(win, bf)
            case .meta(let bf): ncurses.meta(win, bf)
            case .nodelay(let bf): ncurses.nodelay(win, bf)
            case .notimeout(let bf): ncurses.notimeout(win, bf)
            case .timeout(let delay): ncurses.wtimeout(win, delay)
        }
    }
}
