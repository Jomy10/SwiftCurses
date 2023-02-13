import SwiftCurses

func main() throws {
	let program = CommandLine.arguments[0]

	switch program {
		case "mouse":
			try mouse()
		default:
			print("Invalid program \(program)")
	}
}

do {
	try main()
} catch {
	print("Oops, that's an error:")
	print(error)
}

// struct Err: Error {
// 	let str: String

// 	init(_ str: String) { self.str = str }
// }

// // ncurses only checks for "xterm-256color", not e.g. "screen-256color"
// Color.forceXTerm256Color()
// do {
// 	try initScreen(keys)
// } catch {
// 	print("oops, that's an error.\n\(error)")
// }

// func colors(scr: inout Window) throws {
// 	if !Color.hasColors {
// 		throw Err("Terminal does not support color")
// 	}

// 	try Color.define(Color.red, r: 0, g: 700, b: 0) // redefine color
// 	try ColorPair.define(1, fg: Color.red, bg: Color.black)

// 	// same as surrounding with attrOn and attrOff
// 	try scr.withAttrs(.colorPair(1)) {
// 		try scr.print("Now also in color!")
// 	}

// 	try scr.getChar()
// }

// func windows(scr: inout Window) throws {
// 	let (maxY, maxX) = scr.maxYX.tuple
// 	let wH: Int32 = 3
// 	let wW: Int32 = 10
// 	var startY = (maxY +  wH) / 2
// 	var startX = (maxX + wW) / 2
	
// 	try scr.print("Press F1 to exit")
// 	scr.refresh()

// 	var win: BorderedWindow = try newWindow(lines: wH, cols: wW, begin: (startY, startX))

// 	var ch: Int32 = try scr.getCharCode()
// 	while (ch != KeyCode.f(1)) {
// 		switch (ch) {
// 			case KeyCode.left:
// 				startX -= 1
// 				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
// 				win.refresh()
// 			case KeyCode.right:
// 				startX += 1
// 				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
// 				win.refresh()
// 			case KeyCode.up:
// 				startY -= 1
// 				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
// 				win.refresh()
// 			case KeyCode.down:
// 				startY += 1
// 				win = try newWindow(lines: wH, cols: wW, begin: (startY, startX))
// 				win.refresh()
// 			default:
// 				try scr.print("Key code not found")
// 		}
// 		scr.refresh()
		
// 		ch = try scr.getCharCode()
// 	}
// }

// func keys(scr: inout Window) throws {
// 	let H: Int32 = 10
// 	let W: Int32 = 30
// 	var highlight = 1
// 	var choice = 0
// 	let choices = [
// 		"Choice 1",
// 		"Choice 2",
// 		"Choice 3",
// 		"Choice 4",
// 		"Exit"
// 	]
// 	let n_choices = choices.count

// 	let menuWin = try newWindow(lines: H, cols: W, begin: ((80 - W) / 2, (24 - H) / 2))
// 	try scr.print(row: 0, col: 0, "Usa arrow keys to go up and down. Presss enter to select a choice")
// 	scr.refresh()
// 	try keys_printMenu(menuWin, highlight: highlight, n_choices, choices: choices)
// 	var c: Int32 = 0
// 	// loop: while true {
// 	// 	c = try menuWin.getCharCode()
// 	// 	switch c {
// 	// 		case KeyEvent.mouse:
// 	// 			if let event = MouseEvent.get() {
// 	// 				if event.pressed(.button1) {
// 	// 					keys_reportChoice(event.position.x + 1, event.position.y + 1, &choice)
// 	// 					if choice == -1 {// exit chosen
// 	// 						break loop
// 	// 					}
// 	// 					scr.print(row: 22, col: 1, "Choice made is: \(choice). String chosen is: \(choices[choice - 1])")
// 	// 					scr.refresh()
// 	// 				}
// 	// 			}
// 	// 	}
// 	// 	try keys_printMenu(menuWin, highlight: highlight, n_choices, choices: choices)
// 	// 	if choice != 0 {
// 	// 		break
// 	// 	}
// 	// }
// 	try scr.print(row: 23, col: 0, "Your choice \(choice) with choice string \(choices[choice - 1])")
// 	try scr.getCharCode()
	
// 	scr.refresh()
// }

// func keys_printMenu<W: WindowProtocol>(_ win: W, highlight: Int, _ n_choices: Int, choices: [String]) throws {
// 	let x: Int32 = 2
// 	var y: Int32 = 2
// 	win.box(0, 0)
// 	for i in 0..<n_choices {
// 		if highlight == i + 1 {
// 			win.attrOn(.reverse)
// 			try win.print(row: y, col: x, choices[i])
// 			win.attrOff(.reverse)
// 		} else {
// 			try win.print(row: y, col: x, choices[i])
// 		}
// 		y += 1
// 	}
// 	win.refresh()
// }

// func keys_reportChoice(_ mx: Int32, _ my: Int32, _ choice: inout Int) {
// }

// class BorderedWindow: ManagedWindow {
// 	override func onInit() {
// 		self.box(0, 0)
// 	}

// 	override func onDeinit() {
// 		self.clearBorder()
// 		self.refresh()
// 	}
// }
