//=======================================================================
// Chgat Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/attrib.html
//=======================================================================

import SwiftCurses

/// Example 6. Chgat() Usage Example
func chgatExample() throws {
	try initScreen(
		settings: [.colors],
		windowSettings: []
	) { scr in
		try ColorPair.define(1, fg: Color.cyan, bg: Color.black)		// init_pair in ncurses
		try scr.print("A Big string which i didn't care to type fully ")
		try scr.chgat(row: 0, col: 0, -1, .blink, color: 1)
		/* 
		 * First two parameters specify the position at which to start 
		 * Third parameter number of characters to update. -1 means till 
		 * end of line
		 * Forth parameter is the normal attribute you wanted to give 
		 * to the charcter
		 * Fifth is the color index. It is the index given during init_pair()
		 * use 0 if you didn't want color
		 * Sixth one is always NULL (has a default value in this implementation)
		 */
		scr.refresh()
		try scr.getChar()
	}
}

