import ncurses

/// Start a new curses mode terminal
///
/// - Parameters:
///     - `settings`: NCurses settings
///     - `update`: ran everytime it is finished
///         - When `update` returns true, it is ran again
///         - When `update` returns false, the ncurses screen is closed
///         - The paramater passed to the `update` function can be used to call ncures functions on the screen that was created
public func initScreen(settings: [ScreenSetting] = ScreenSetting.defaultSettings, _ update: (inout NCursesScreen) throws -> Bool) throws {
    guard let _scr = initscr() else { // start curses mode
        throw CursesError(.CannotCreateWindow)
    }
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply(_scr) }
    ncurses.setlocale(LC_ALL, "")

    var scr = NCursesScreen(screen: _scr)
    while (try update(&scr)) {
        refresh()
    }
}

// TODO:
// - getmaxyx
