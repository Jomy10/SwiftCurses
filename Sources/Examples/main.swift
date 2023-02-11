import SwiftCurses

var char: Character?
do {
	try initScreen() { (scr: inout NCursesScreen) in
		try scr.print("hello\n")
		// char = try scr.getChar()
		// try scr.move(row: 10, col: 10)
		// try scr.print("value:", char!, "hello")
		// try scr.addStr("test")
		// try scr.addChar("é")

		let (my, mx) = scr.maxYX
		try scr.print("max:   X = \(mx), Y = \(my)\n")
		let (y, x) = scr.yx
		try scr.print("cur:   X = \(x), Y = \(y)\n")
		let (by, bx) = scr.begYX
		try scr.print("start: X = \(bx), Y = \(by)\n")

		char = try scr.getChar()
		return false
	}
} catch {
	print("oops, that's an error: \(error)")
}

print(char!)
