<div align="center">
  <h1>SwiftCurses</h1>
  ❰[examples](/Sources/Examples) | [ncurses tutorial](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)❱
</div>

SwiftCurses is a Swifty wrapper for ncurses.

> ncurses - CRT screen handling and optimization package

## Hello World

```swift
import SwiftCurses

func helloWorld() throws {
	try initScreen() { scr in
		try scr.print("Hello world !!!")
		scr.refresh()
		try scr.getChar()
	}
}
```

## Installation

[ncuses](https://invisible-island.net/ncurses#packages) must be installed on the system.

In you swift package:

```swift
dependencies: [
  .package(name: "SwiftCurses", url: "https://github.com/jomy10/SwiftCurses.git", branch: .main)
]
```

In a swift target:

```swift
.target(
  name: "MyTarget",
  dependencies: ["SwiftCurses"]
)
```

## Documentation / tutorials / links

There is a great ncurses tutorial you can find [here](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/),
the [examples in this repository](/Sources/Examples) show the examples seen in the tutorial.

NCurses documentation can be found [here](https://invisible-island.net/ncurses/man/ncurses.3x.html),
though keep in mind some functions may be missing/have a different name.

[ncurses info](https://invisible-island.net/ncurses/)

## Quetions

Feel free to ask any questions.

## Contributing

Always looking at improving this library, feel free to leave suggestions/pull requests.

## TODO

- [x] border: https://invisible-island.net/ncurses/man/curs_border.3x.html
- [x] scr_dump: https://invisible-island.net/ncurses/man/curs_scr_dump.3x.html
- https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/otherlib.html
- fill in the todos

## License

Since the original is licensed under the MIT license, this library is also
licensed under the [MIT license](LICENSE).
