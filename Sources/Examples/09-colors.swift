//=======================================================================
// Colors Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/color.html
//=======================================================================

import SwiftCurses

/// Example 9. A Simple Color example
func colorsExample() throws {
	try initScreen(
		settings: [
			.colors // enable colors
		], 
		windowSettings: []
	) { scr in
		let (row, _) = scr.maxYX.tuple
		try ColorPair.define(1, fg: Color.red, bg: Color.black)

		try scr.withAttrs(.colorPair(1)) {
			try printInMiddle(scr, row / 2, 0, 0, "Voila !!! In color ...")
		}
		try scr.getChar()
	}
}

fileprivate func printInMiddle(_ win: some WindowProtocol, _ starty: Int32, _ startx: Int32, _ _width: Int32, _ string: String) throws {
	var width = _width
	var (y, x) = win.yx.tuple
	if startx != 0 {
		x = startx
	}
	if starty != 0 {
		y = starty
	}
	if width == 0 {
		width = 80
	}

	let length = Int32(string.count)
	let temp = (width - length) / 2
	x = startx + temp
	try win.print(row: y, col: x, string)
	win.refresh()
}
