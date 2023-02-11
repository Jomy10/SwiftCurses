import ncurses

public struct Window {
    @usableFromInline
    let window: OpaquePointer

    init(_ window: OpaquePointer) {
        // screen is not a null pointer => we can negate some error checks in our functions
        self.window = window
    }

    // @inlinable
    // public func newWindow(lines: Int32, cols: Int32, begin: Coordinate) throws -> Window {
    //     return try self.newWindow(lines: lines, cols: cols, begin: begin.tuple)
    // }

    // public func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32)) throws -> Window {
    //     guard let win = ncurses.newwin(lines, cols, begin.0, begin.1) else {
    //         throw CursesError(.cannotCreateWindow)
    //     }
    //     self.subwindows.append(win)
    // }

}

public class ManagedWindow {
    public var win: Window

    init(_ window: Window) {
        self.win = window
    }

    deinit {
        ncurses.delwin(self.win.window)
    }
}

@inlinable
public func newWindow(lines: Int32, cols: Int32, begin: Coordinate, _ body: (inout Window) -> ()) {}
public func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32), _ body: (inout Window) -> ()) {}
/// Returns a managed class object that can be passed around. Functions need to
/// be called on the `win` variable
// TODO: Window protocol -> Have struct and class version
public func newWindow(/*params*/) -> ManagedWindow {
    // TODO
}
    
