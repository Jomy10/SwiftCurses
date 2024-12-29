import ncurses
#if os(Linux)
import ncursesw
#endif

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

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
    setlocale(LC_ALL, "") // support for wide chars

    guard let _scr = initscr() else { // start curses mode
        throw CursesError(.cannotCreateWindow)
    }
    // Assure cleanup on interrupt
    #if !os(Windows)
    signal(SIGINT, { _ in
        endwin()
        exit(0)
    })
    #endif
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply() }
    windowSettings.forEach { $0.apply(_scr) }

    var scr = Window(_scr)
    try body(&scr)
}

#if !os(Windows)
fileprivate nonisolated(unsafe) var originalTermios = termios()
#endif

/// Start a new curses mode terminal
///
/// This version of the `initScreen` function supports an asynchronous body function
///
/// - Parameters:
///     - `settings`: NCurses settings
///     - `body`: The paramater passed to the `body` function can be used to call ncures functions on the screen that was created
@available(macOS 10.15.0, *)
public func initScreenAsync(
    settings: [TermSetting] = TermSetting.defaultSettings,
    windowSettings: [WindowSetting] = WindowSetting.defaultSettings,
    _ body: @Sendable (inout Window) async throws -> ()
) async throws {
    setlocale(LC_ALL, "") // support fr wide chars

    var scr: Window? = nil
   	#if !os(Windows)
	if (tcgetattr(STDIN_FILENO, &originalTermios) == -1) {
		// err
	}
   	#endif
    guard let _scr = initscr() else { // start curses mode
        throw CursesError(.cannotCreateWindow)
    }
    // Assure cleanup on interrupt
    #if !os(Windows)
    signal(SIGINT, { _ in
        endwin()
        if (tcsetattr(STDIN_FILENO, 0, &originalTermios) == -1) {
           	//print("error restoring termios")
        }
        exit(0)
    })
    #endif
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply() }
    windowSettings.forEach { $0.apply(_scr) }

    scr = Window(_scr)
    try await body(&scr!)
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
