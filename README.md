<div align="center">
  <h1>SwiftCurses</h1>
  ❰
  <a href="/Sources/Examples">examples</a>
  |
  <a href="https://swiftpackageindex.com/Jomy10/SwiftCurses/master/documentation/swiftcurses">documentation</a>
  ❱
</div><br/>
<div align="center">
  <a href="https://swiftpackageindex.com/Jomy10/SwiftCurses"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJomy10%2FSwiftCurses%2Fbadge%3Ftype%3Dplatforms"></img></a>
  <a href="https://swiftpackageindex.com/Jomy10/SwiftCurses"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJomy10%2FSwiftCurses%2Fbadge%3Ftype%3Dswift-versions"></img></a>
</div><br/>

SwiftCurses is a Swifty wrapper for ncurses.

> ncurses - CRT screen handling and optimization package

## Hello World

```swift
import SwiftCurses

try initScreen() { scr in
    try scr.print("Hello world !!!")
    scr.refresh()
    try scr.getChar()
}
```

## Installation

[ncurses](https://invisible-island.net/ncurses#packages) must be installed on the system.

In your swift package:

```swift
dependencies: [
  .package(url: "https://github.com/jomy10/SwiftCurses.git", branch: "master")
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

### Running the examples

```sh
swift run Examples [name of the example (see main.swift)]
```

## Questions

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
