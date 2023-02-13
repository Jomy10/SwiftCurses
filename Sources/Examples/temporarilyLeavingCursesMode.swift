//=======================================================================
// Temporarily leaving curses Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/misc.html
//=======================================================================

import SwiftCurses

/// Example 12. Temporarily Leaving Curses Mode
func temporarilyLeavingCurses() throws {
	try initScreen(settings: [], windowSettings: []) { scr in
		try scr.print("Hello world !!!\n")
		scr.refresh()
		shellMode { 
			// do whatever you want in shell mode
			print("Hello from shell mode!")
		}
		try scr.print("Another String\n")
		scr.refresh()
	}
}
