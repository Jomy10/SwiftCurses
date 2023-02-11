import ncurses

public protocol WindowProtocol {
    var window: OpaquePointer { get }
}

public struct Window: WindowProtocol {
    public let window: OpaquePointer

    init(_ window: OpaquePointer) {
        // screen is not a null pointer => we can negate some error checks in our functions
        self.window = window
    }
}

public class ManagedWindow: WindowProtocol {
    public var window: OpaquePointer

    init(_ window: OpaquePointer) {
        self.window = window
    }

    deinit {
        ncurses.delwin(self.window)
    }
}

/// Create a new ncurses window
@inlinable
fileprivate func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32)) throws -> OpaquePointer {
    guard let win = newwin(lines, cols, begin.0, begin.1) else {
        if begin.0 < 0 || begin.1 < 1 {
            throw CursesError(.negativeCoordinate, help: "The beginning coordinates of the window cannot be negative")
        } else if lines < 0 {
            throw CursesError(.negativeNumber, help: "The lines cannot be negative")
        } else if cols < 0 {
            throw CursesError(.negativeNumber, help: "The cols cannot be negative")
        } else {
            throw CursesError(.cannotCreateWindow)
        }
    }

    return win
}

@inlinable
public func newWindow(lines: Int32, cols: Int32, begin: Coordinate, _ body: (inout Window) -> ()) throws {
    try newWindow(lines: lines, cols: cols, begin: begin.tuple, body)
}
public func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32), _ body: (inout Window) -> ()) throws {
    let win: OpaquePointer = try newWindow(lines: lines, cols: cols, begin: begin)
    var window = Window(win)
    body(&window)
    delwin(win)
}

/// Returns a managed class object that can be passed around.
@inlinable
public func newWindow(lines: Int32, cols: Int32, begin: Coordinate) throws -> ManagedWindow {
    return try newWindow(lines: lines, cols: cols, begin: begin.tuple)
}

/// Returns a managed class object that can be passed around.
public func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32)) throws -> ManagedWindow {
    let win: OpaquePointer = try newWindow(lines: lines, cols: cols, begin: begin)
    let window = ManagedWindow(win)
    return window
}
