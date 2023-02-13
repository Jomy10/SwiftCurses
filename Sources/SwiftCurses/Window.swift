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

open class ManagedWindow: WindowProtocol {
    private var __window: OpaquePointer?

    public var window: OpaquePointer {
        return self.__window!
    }

    public required init(_ window: OpaquePointer) {
        self.__window = window
        self.onInit()
    }

    open func onInit() {}
    open func onDeinit() {}

    deinit {
        onDeinit()
        ncurses.delwin(self.__window)
    }
}

/// Create a new ncurses window
@inlinable
internal func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings) throws -> OpaquePointer {
    guard let win = ncurses.newwin(lines, cols, begin.0, begin.1) else {
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

    settings.forEach { $0.apply(win) }

    return win
}

/// Create a new window
@inlinable
public func newWindow(lines: Int32, cols: Int32, begin: Coordinate, settings: [WindowSetting] = WindowSetting.defaultSettings, _ body: (inout Window) -> ()) throws {
    try newWindow(lines: lines, cols: cols, begin: begin.tuple, settings: settings, body)
}

/// Create a new window
public func newWindow(lines: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings, _ body: (inout Window) -> ()) throws {
    let win: OpaquePointer = try newWindow(lines: lines, cols: cols, begin: begin, settings: settings)
    var window = Window(win)
    body(&window)
    delwin(win)
}

// Generic function allows the user to define their own window types (e.g. window with borders)
/// Returns a managed class object that can be passed around.
@inlinable
public func newWindow<ManagedWindowType: ManagedWindow>(lines: Int32, cols: Int32, begin: Coordinate, settings: [WindowSetting] = WindowSetting.defaultSettings) throws -> ManagedWindowType {
    return try newWindow(lines: lines, cols: cols, begin: begin.tuple, settings: settings)
}

/// Returns a managed class object that can be passed around.
public func newWindow<ManagedWindowType: ManagedWindow>(lines: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings) throws -> ManagedWindowType {
    let win: OpaquePointer = try newWindow(lines: lines, cols: cols, begin: begin, settings: settings)
    let window = ManagedWindowType(win)
    return window
}
