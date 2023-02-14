//=======================================================================
// Attributes Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/attrib.html
//=======================================================================

import SwiftCurses
import Foundation

/// Example 5. A Simple Attributes example
///
/// This example will show the contents of a file, and mark any multiline
/// comment (/**/) in bold (passed in as a parameter;
/// `swift run SwiftCursesExamples attributes [filename]`)
func attributesExample() throws {
	let arg: String
	if CommandLine.argc == 3 {
		arg = CommandLine.arguments[2]
	} else if CommandLine.argc == 2 {
		arg = CommandLine.arguments[1]
	} else {
		print("Usage: \(CommandLine.arguments[0]) <a c file name>")
		return
	}
	
	let url = URL(fileURLWithPath: arg)
	let contents = try String(contentsOf: url)
	try initScreen(
		settings: [],
		windowSettings: []
	) { scr in
		let (row, _) = scr.maxYX.tuple		// Boundary of the screen
		var prev: Character = "\0"
	
		try contents.forEach { ch in
			var (y, x) = scr.yx.tuple 		// current curser position
			if (y == (row - 1)) {			// are we at the end of the screen
				try scr.print("<-Press Any Key->")
				try scr.getChar()
				scr.clear()					// clear the screen
				try scr.move(row: 0, col: 0)// start at the beginning of the screen
			}
			if prev == "/" && ch == "*" { 	// if it is / and * then only switch bold on
				scr.attrOn(.bold)			// turn bold on
				(y, x) = scr.yx.tuple
				try scr.move(row: y, col: x - 1) // back up ine cursor position
				try scr.print("/\(ch)")		// the actual printing is done here
			} else {
				try scr.print(ch)
			}

			scr.refresh()
			if prev == "*" && ch == "/" {
				scr.attrOff(.bold)			// switch if off once we got * and then /
			}

			prev = ch
		}
		try scr.getChar()
	}
}
