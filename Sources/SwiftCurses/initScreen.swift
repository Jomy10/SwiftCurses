import ncurses

/// Start a new curses mode terminal
///
/// - Parameters:
///     - `settings`: NCurses settings
///     - `body`: The paramater passed to the `body` function can be used to call ncures functions on the screen that was created
public func initScreen(
    settings: [TermSetting] = TermSetting.defaultSettings,
    windowSettings: [WindowSetting] = WindowSetting.defaultSettings,
    _ body: (inout Window) throws -> ()
) throws {
    guard let _scr = initscr() else { // start curses mode
        throw CursesError(.cannotCreateWindow)
    }
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply() }
    windowSettings.forEach { $0.apply(_scr) }
    ncurses.setlocale(LC_ALL, "") // support for wide chars

    var scr = Window(_scr)
    try body(&scr)
}


// https://invisible-island.net/ncurses/man/curs_scr_dump.3x.html //

@inlinable
public func scrDump(filename: String) {
    ncurses.scr_dump(filename)
}

@inlinable
public func scrRestore(filename: String) {
    ncurses.scr_restore(filename)
}

@inlinable
public func scrInit(filename: String) {
    ncurses.scr_init(filename)
} 

@inlinable
public func scrSet(filename: String) {
    ncurses.scr_set(filename)
}
