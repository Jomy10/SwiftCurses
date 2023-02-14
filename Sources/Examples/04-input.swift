//=======================================================================
// Input Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/scanw.html
//=======================================================================

import SwiftCurses

func inputExample() throws {
	let mesg = "Enter a string: "

	try initScreen(
		settings: [],
		windowSettings: []
	) { scr in
		let (row, col) = scr.maxYX.tuple
		try scr.print(row: row/2, col: (col - Int32(mesg.count))/2, mesg)

		let str = try scr.getStr()
		try scr.print(row: row - 2, col: 0, "You entered: \(str)")
		try scr.getChar()
	}
}
