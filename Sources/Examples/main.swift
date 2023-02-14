//=======================
// Swift Curses Examples
//=======================


func main() throws {
	if CommandLine.arguments.count <= 1 {
		fatalError("Not enough arguments")
		// TODO: TUI for examples
	}

	let program = CommandLine.arguments[1]

	switch program {
		case "helloWorld":
			try helloWorld()
		case "init":
			try initUsage()
		case "mouse":
			try mouse()
		case "tempLeaveCurses":
			try temporarilyLeavingCurses()
		case "print":
			try printExample()
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
