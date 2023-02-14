//=======================================================================
// Print Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/printw.html
//=======================================================================

import SwiftCurses

/// Example 3. A Simple printw example
func printExample() throws {
	let mesg = "Just a string"

	try initScreen(
		settings: [],
		windowSettings: []
	) { scr in
		// `maxYX` returns a `Coordinate` struct, which can be deconstructed by turning
		// it into a tuple using `.tuple`
		let (row, col) = scr.maxYX.tuple				 					// Get the number of rows and columns
		try scr.print(row: row/2, col: (col - Int32(mesg.count))/2, mesg)	// print the message at the center of the screen
		try scr.print(row: row-2, col: 0, "This screen has \(row) rows and \(col) columns\n")
		try scr.print("Try resizing the window (if possible and then run this program again)")
		scr.refresh()
		try scr.getChar()
	}
}
