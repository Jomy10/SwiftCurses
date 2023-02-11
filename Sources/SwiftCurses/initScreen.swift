import ncurses

// Detect system encoding -> used for wide characters
let string32Encoding: String.Encoding = (1.littleEndian == 1) ? .utf32LittleEndian : .utf32BigEndian

/// Start a new curses mode terminal
///
/// - Parameters:
///     - `settings`: NCurses settings
///     - `body`:  The paramater passed to the `body` function can be used to call ncures functions on the screen that was created
public func initScreen(settings: [ScreenSetting] = ScreenSetting.defaultSettings, _ body: (inout Window) throws -> ()) throws {
    guard let _scr = initscr() else { // start curses mode
        throw CursesError(.cannotCreateWindow)
    }
    defer {
        endwin() // end curses mode
    }

    try settings.forEach { try $0.apply(_scr) }
    ncurses.setlocale(LC_ALL, "")

    var scr = Window(_scr)
    try body(&scr)
    // while (try update(&scr)) {
    //     refresh()
    // }
}

// TODO:
// - getmaxyx
