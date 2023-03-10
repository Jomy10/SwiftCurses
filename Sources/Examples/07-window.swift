//=======================================================================
// Window Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/windows.html
//=======================================================================

import SwiftCurses

/// Example 7. Window Border example
///
/// Use arrow keys to move the window, press f1 to exit
/// (simple, unoptimized example)
func windowExample() throws {
	try initScreen(
		settings: [.cbreak],
		windowSettings: [.keypad(true)]
	) { scr in
		let height: Int32 = 3
		let width: Int32 = 10
		let (row, col) = scr.maxYX.tuple
		var starty = (row - height) / 2
		var startx = (col - width) / 2
		try scr.print("Press F1 to exit")
		scr.refresh()

		// Create our custom window defined below
		var myWin: BorderedWindow? = try BorderedWindow(rows: height, cols: width, begin: (starty, startx), settings: [])
		_ = myWin // supress Swift warning
		var ch = try scr.getChar()
		var keyCode: Int32?
		if case .code(let code) = ch {
			keyCode = code
		}
		while (keyCode ?? -1) != KeyCode.f(1) {
			switch keyCode ?? -1 {
				case KeyCode.left:
					startx -= 1
					myWin = nil 	// destroy the old window
					myWin = try BorderedWindow(rows: height, cols: width, begin: (starty, startx), settings: [])
				case KeyCode.right:
					startx += 1
					myWin = nil
					myWin = try BorderedWindow(rows: height, cols: width, begin: (starty, startx), settings: [])
				case KeyCode.up:
					starty -= 1
					myWin = nil
					myWin = try BorderedWindow(rows: height, cols: width, begin: (starty, startx), settings: [])
				case KeyCode.down:
					starty += 1
					myWin = nil
					myWin = try BorderedWindow(rows: height, cols: width, begin: (starty, startx), settings: [])
				default:
					break
			}

			ch = try scr.getChar()
			if case .code(let code) = ch {
				keyCode = code
			} else {
				keyCode = nil
			}
		}
	}
}

fileprivate class BorderedWindow: ManagedWindow {
	override func onInit() {
		self.box()		// 0, 0 gives the default characters, or leaving the parameters empty, for the vertical and horizontal lines
		self.refresh()	// show the box
	}

	override func onDeinit() {
		// the following code is not necessary as SwiftCurses cleans up windows
		// completely, including setting all of its cells to " "
		// set all border characters to be a space
		// self.border(
		// 	left: " ",
		// 	right: " ",
		// 	top: " ",
		// 	bottom: " ",
		// 	topLeft: " ",
		// 	topRight: " ",
		// 	bottomLeft: " ",
		// 	bottomRight: " "
		// )
		// self.refresh()
		// delwin is done when this object is deallocated
	}
}
