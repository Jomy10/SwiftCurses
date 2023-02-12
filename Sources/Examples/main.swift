import SwiftCurses

struct Err: Error {
	let str: String

	init(_ str: String) { self.str = str }
}

// ncurses only checks for "xterm-256color", not e.g. "screen-256color"
Color.forceXTerm256Color()
do {
	try initScreen(colors)
} catch {
	print("oops, that's an error.\n\(error)")
}

func colors(scr: inout Window) throws {
	if !Color.hasColors {
		throw Err("Terminal does not support color")
	}

	try Color.define(Color.red, r: 0, g: 700, b: 0) // redefine color
	try ColorPair.define(1, fg: Color.red, bg: Color.black)

	// same as surrounding with attrOn and attrOff
	try scr.withAttrs(.colorPair(1)) {
		try scr.print("Now also in color!")
	}

	try scr.getChar()
}

func windows(scr: inout Window) throws {
	let (maxY, maxX) = scr.maxYX.tuple
	let wH: Int32 = 3
	let wW: Int32 = 10
	var startY = (maxY +  wH) / 2
	var startX = (maxX + wW) / 2
	
	try scr.print("Press F1 to exit")
	scr.refresh()

	var win: BorderedWindow = try newWindow(lines: wH, cols: wW, begin: (startY, startX))

	var ch: Int32 = try scr.getCharCode()
	while (ch != KeyCode.f(1)) {
		switch (ch) {
			case KeyCode.left:
				startX -= 1
				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
				win.refresh()
			case KeyCode.right:
				startX += 1
				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
				win.refresh()
			case KeyCode.up:
				startY -= 1
				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
				win.refresh()
			case KeyCode.down:
				startY += 1
				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
				win.refresh()
			default:
				try scr.print("Key code not found")
		}
		scr.refresh()
		
		ch = try scr.getCharCode()
	}
}

func keys(scr: inout Window) throws {
	let H: Int32 = 10
	let W: Int32 = 30

	let menuWin = try newWindow(lines: H, cols: W, begin: ((80 - W) / 2, (24 - H) / 2))
	menuWin.sett
}

class BorderedWindow: ManagedWindow {
	override func onInit() {
		self.box(0, 0)
	}

	override func onDeinit() {
		self.clearBorder()
		self.refresh()
	}
}
