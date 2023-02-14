//=======================================================================
// Hello World Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/helloworld.html
//=======================================================================

import SwiftCurses

/// Example 1: The Hello World !!! Program
func helloWorld() throws {
	try initScreen() { scr in
		try scr.print("Hello world !!!")
		scr.refresh()
		try scr.getChar()
	}
}
