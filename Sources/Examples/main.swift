import SwiftCurses

var char: Character?
try initScreen() { scr in
	try scr.printw("hello")
	char = try scr.getChar()
	try scr.printw("value: %c", char!.asciiValue!)
	char = try scr.getChar()
	return false
}

print(char!)
