import ncurses

public protocol WindowProtocol {
    var window: WindowPointer { get }
}

public struct Window: WindowProtocol {
    public let window: WindowPointer

    init(_ window: WindowPointer) {
        // screen is not a null pointer => we can negate some error checks in our functions
        self.window = window
    }
}

open class ManagedWindow: WindowProtocol {
    public let window: WindowPointer
    private var __rows: Int32? = nil
    private var __cols: Int32? = nil
    private var destroyed = false
    
    /// will not be known when loading a window from a file
    public var rows: Int32? { self.__rows }
    /// will not be known when loading a window from a file
    public var cols: Int32? { self.__cols }

    public required init(_ window: WindowPointer, rows: Int32? = nil, cols: Int32? = nil) {
        self.__rows = rows
        self.__cols = cols
        self.window = window
        self.onInit()
    }

    public convenience init(rows: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings) throws {
        let winPtr: WindowPointer = try newWindow(rows: rows, cols: cols, begin: begin, settings: settings)
        self.init(winPtr, rows: rows, cols: cols)
    }

    open func onInit() {}
    open func onDeinit() {}

    private func destroy() {
        onDeinit()
        if rows != nil {
            for r in 0..<rows! {
                for c in 0..<cols! {
                    try? self.addChar(row: r, col: c, " ")
                }
            }
        } else {
            var r: Int32 = 0
            var c: Int32 = 0
            var prevFailed = false
            loop: while true {
                do {
                    try self.addChar(row: r, col: c, " ")
                    r += 1
                    prevFailed = false
                } catch {
                    if prevFailed { break loop }
                    r = 0
                    c += 1
                    prevFailed = true
                }
            
            }
        }
        self.refresh()
        
        ncurses.delwin(self.window)

        self.destroyed = true
    }

    deinit {
        if self.destroyed { return }
        self.destroy()
    }
}

/// Create a new ncurses window
@inlinable
internal func newWindow(rows: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings) throws -> WindowPointer {
    guard let win = ncurses.newwin(rows, cols, begin.0, begin.1) else {
        if begin.0 < 0 || begin.1 < 1 {
            throw CursesError(.negativeCoordinate, help: "The beginning coordinates of the window cannot be negative")
        } else if rows < 0 {
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
public func newWindow(rows: Int32, cols: Int32, begin: Coordinate, settings: [WindowSetting] = WindowSetting.defaultSettings, _ body: (inout Window) -> ()) throws {
    try newWindow(rows: rows, cols: cols, begin: begin.tuple, settings: settings, body)
}

/// Create a new window
public func newWindow(rows: Int32, cols: Int32, begin: (Int32, Int32), settings: [WindowSetting] = WindowSetting.defaultSettings, _ body: (inout Window) -> ()) throws {
    let win: WindowPointer = try newWindow(rows: rows, cols: cols, begin: begin, settings: settings)
    var window = Window(win)
    body(&window)
    delwin(win)
}
