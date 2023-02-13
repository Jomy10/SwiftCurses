//=======================================================================
// Init Usage Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html
//=======================================================================

import SwiftCurses

/// Example 2. Initialization Function Usage Example
func initUsage() throws {
	try initScreen(
		settings: [.raw, .noEcho],
		windowSettings: [.keypad(true)]
	) { scr in
		try scr.print("Type any character to see it in bold\n")
		let ch = try scr.getCharCode()

		if (ch == KeyCode.f(1)) {
			try scr.print("F1 key pressed")
		} else {
			try scr.print("The pressed key is ")
			try scr.withAttrs(.bold) {
				try scr.print(Character(UnicodeScalar(Int(ch))!))
			}
		}

		try scr.refresh()
		try scr.getChar()
	}
}
