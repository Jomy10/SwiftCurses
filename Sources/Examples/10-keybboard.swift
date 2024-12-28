//=======================================================================
// Keyboard Example
//
// Written by: Jonas Everaert
// Based on: https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/keys.html
//=======================================================================

import SwiftCurses

fileprivate let choices = [
 	"Choice1",
 	"Choice2",
 	"Choice3",
 	"Choice 4",
 	"Exit",
]
fileprivate let nChoices = Int32(choices.count)

/// Example 10. A Simple Key Usage example
func keyboardExample() throws {
  let WIDTH: Int32 = 30
  let HEIGHT: Int32 = 10

  var startx: Int32 = 0
  var starty: Int32 = 0

  ////////

	var highlight: Int32 = 1
	var choice: Int32 = 0

	try initScreen(
		settings: [.noEcho, .cbreak],
		windowSettings: []
	) { scr in
		scr.clear()

		startx = (80 - WIDTH) / 2
		starty = (24 - HEIGHT) / 2

		// WindowSettings.default returns [.keypad(true)], so it can be left out
		let menuWin = try ManagedWindow(rows: HEIGHT, cols: WIDTH, begin: (starty, startx))
		try scr.print(row: 0, col: 0, "Use arrow key to go up and down. Press enter to select a choice.")
		scr.refresh()
		try printMenu(menuWin, highlight)
		loop: while true {
			let c = try menuWin.getChar()
			// try scr.print(row: 1, col: 0, "[\(c)]")
			switch c {
				case .code(let code):
					switch code {
						case KeyCode.up:
							if highlight == 1 {
								highlight = nChoices
							} else {
								highlight -= 1
							}
						case KeyCode.down:
							if highlight == nChoices {
								highlight = 1
							} else {
								highlight += 1
							}
						default:
							try scr.move(row: 24, col: 0)
							try scr.clear(until: .endOfLine)
							try scr.print(row: 24, col: 0, "Function key pressed is \(code)")
							scr.refresh()
					} // switch code
					try printMenu(menuWin, highlight)
				case .char(let char):
					if char == "\n" { // enter pressed = user choice an option
						choice = highlight
 						break loop
					}
					try scr.move(row: 24, col: 0)
					try scr.clear(until: .endOfLine)
					try scr.print(row: 24, col: 0, "Character pressed is \(char)")
					scr.refresh()
			}
		}
		try scr.print(row: 23, col: 0, "You chose choice \(choice) with choice string \(choices[Int(choice) - 1])\n")
		try scr.clear(until: .endOfLine)
		try scr.getChar()
		scr.refresh()
	}
}

fileprivate func printMenu(_ menuWin: ManagedWindow, _ highlight: Int32) throws {
	let x: Int32 = 2
	var y: Int32 = 2
	menuWin.box()
	for i in 0..<nChoices {
		if highlight == i + 1 { // highlight present choice
			try menuWin.withAttrs(.reverse) {
				try menuWin.print(row: y, col: x, choices[Int(i)])
			}
		} else {
			try menuWin.print(row: y, col: x, choices[Int(i)])
		}
		y += 1
	}
	menuWin.refresh()
}
