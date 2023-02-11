import SwiftCurses

var char: Character?
do {
	try initScreen() { scr in
		try scr.print("hello\n")

		let (my, mx) = scr.maxYX.tuple
		try scr.print("max:   X = \(mx), Y = \(my)\n")
		let (y, x) = scr.yx.tuple
		try scr.print("cur:   X = \(x), Y = \(y)\n")
		let (by, bx) = scr.begYX.tuple
		try scr.print("start: X = \(bx), Y = \(by)\n")

		scr.refresh()

		let c = try scr.getCharCode()
		if c == KeyCode.up {
			try scr.print("Up pressed!")
		}

		let s: String = try scr.getStr()
		try scr.print(s)

		char = try scr.getChar()
	}
} catch {
	print("oops, that's an error: \(error)")
}

print(char ?? "No character read")
