//=======================================================================
// Mouse Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/mouse.html
//=======================================================================

import SwiftCurses

fileprivate let WIDTH: Int32 = 30
fileprivate let HEIGHT: Int32 = 10

fileprivate var starty: Int32 = 0
fileprivate var startx: Int32 = 0

fileprivate let choices = [
	"Choice 1",
	"Choice 2",
	"Choice 3",
	"Choice 4",
	"Exit",
]
fileprivate let nChoices = choices.count

/// Example 11. Access the menu with mouse !!!
func mouse() throws {
	var choice = 0

	// Initialize ncurses
	try initScreen(settings: [
		.noEcho,
		.cbreak, // line buffering disabled. pass on everything
	]) { scr in
		scr.clear()

		// Try to put the window in the middle of screen
		startx = (80 - WIDTH) / 2
		starty = (24 - HEIGHT) / 2

		try scr.withAttrs(.reverse) {
			try scr.print(row: 23, col: 1, "Click on Exit to quit (works best in a virtual console)")
			scr.refresh()
		}

		// Print the menu for the first time
		let menuWin: ManagedWindow = try newWindow(lines: HEIGHT, cols: WIDTH, begin: (starty, startx))
		try printMenu(menuWin, 1)

		// Get all the mouse events
		try MouseEvent.register(.allMouseEvents)

		var c: Int32 = -1
		loop: while true {
			c = try menuWin.getCharCode()
			switch c {
				case KeyCode.mouse:
					if let event = MouseEvent.get() {
						// when the user clicks the left mouse button
						if event.isPressed(.button1) {
							reportChoice(event.x + 1, event.y + 1, &choice)
							if choice == -1 { // Exit chosen
								break loop
							}
							try scr.print(row: 22, col: 1, "Choice made is : \(choice). String chosen is \(choices[choice - 1])")
							scr.refresh()
						}
					}
					try printMenu(menuWin, choice)
				default:
					continue
			}
		} // end loop
	} // end screen
}

fileprivate func printMenu<W: WindowProtocol>(_ win: W, _ highlight: Int) throws {
	let x: Int32 = 2
	var y: Int32 = 2
	win.box(0, 0)
	for i in 0..<nChoices {
		win.refresh()
		if highlight == i + 1 {
			try win.withAttrs(.reverse) {
				try win.print(row: y, col: x, choices[i])
			}
		} else {
			try win.print(row: y, col: x, choices[i])
		}
		y += 1
	}
	win.refresh()
}

/// Report the choice according to mouse position
fileprivate func reportChoice(_ mouseX: Int32, _ mouseY: Int32, _ pChoice: inout Int) {
	let i = startx + 2
	let j = starty + 3

	for choice: Int32 in 0..<Int32(nChoices) {
		if mouseY == j + choice && mouseX >= i && mouseX <= i + Int32(choices[Int(choice)].count) {
			if choice == nChoices - 1 {
				pChoice = -1
			} else {
				pChoice = Int(choice + 1)
			}
		}
	}
}
