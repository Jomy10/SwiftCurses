//=======================================================================
// Border Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/windows.html
//=======================================================================

import SwiftCurses

/// Example 8. More border functions
func borderExample() throws {
	try initScreen(
		settings: [.colors, .cbreak, .noEcho],
		windowSettings: [.keypad(true)]
	) { scr in
		try ColorPair.define(1, fg: Color.cyan, bg: Color.black)

		let (row, col): (Int32, Int32) = scr.maxYX.tuple
		// Initialize the window parameters
		var win = Win(row, col)
		try win.printParams(scr)

		try scr.withAttrs(.colorPair(1)) {
			try scr.print("Press F1 to exit")
			scr.refresh()
		}

		try win.createBox(scr, flag: true)
		var ch = try scr.getChar()
		while ch.code != KeyCode.f(1) {
			switch ch.code {
				case KeyCode.left:
					try win.createBox(scr, flag: false)
					win.startx -= 1
					try win.createBox(scr, flag: true)
				case KeyCode.right:
					try win.createBox(scr, flag: false)
					win.startx += 1
					try win.createBox(scr, flag: true)
				case KeyCode.up:
					try win.createBox(scr, flag: false)
					win.starty -= 1
					try win.createBox(scr, flag: true)
				case KeyCode.down:
					try win.createBox(scr, flag: false)
					win.starty += 1
					try win.createBox(scr, flag: true)
				default:
					break
			}
		
			ch = try scr.getChar()
		}
	}
}

fileprivate struct Win {
	var startx: Int32
	var starty: Int32
	var height: Int32
	var width:  Int32
	let border: WinBorder

	init(_ maxLines: Int32, _ maxCols: Int32) {
		self.height = 3
		self.width = 10
		self.starty = (maxLines - self.height) / 2
		self.startx = (maxCols - self.width) / 2
		self.border = WinBorder()
	}

	func printParams(_ win: some WindowProtocol) throws {
		#if DEBUG
		try win.print(row: 25, col: 0, self.startx, self.starty, self.width, self.height)
		win.refresh()
		#endif
	}

	/// - `win`: the window to draw the box on
	func createBox(_ win: some WindowProtocol, flag: Bool) throws {
		let x = self.startx
		let y = self.starty
		let w = self.width
		let h = self.height

		if flag == true {
			try win.addChar(row: y, col: x, self.border.tl)
			try win.addChar(row: y, col: x + w, self.border.tr)
			try win.addChar(row: y + h, col: x, self.border.bl)
			try win.addChar(row: y + h, col: x + w, self.border.br)
			try win.horLine(row: y, col: x + 1, self.border.ts, w - 1)
			try win.horLine(row: y + h, col: x + 1, self.border.bs, w - 1)
			try win.vertLine(row: y + 1, col: x, self.border.ls, h - 1)
			try win.vertLine(row: y + 1, col: x + w, self.border.rs, h - 1)
		} else {
			for j in y...(y + h) {
				for i in x...(x + w) {
					try win.addChar(row: j, col: i, " ")
				}
			}
		}
	}
}

fileprivate struct WinBorder {
	let ls: Character = "|"
	let rs: Character = "|"
	let ts: Character = "-"
	let bs: Character = "-"
	let tl: Character = "+"
	let tr: Character = "+"
	let bl: Character = "+"
	let br: Character = "+"
}
