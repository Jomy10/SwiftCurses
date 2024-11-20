import ncurses

#if SWIFTCURSES_OPAQUE
// We define NCURSES_OPAQUE
public typealias WindowPointer = OpaquePointer
#else
public typealias WindowPointer = UnsafeMutablePointer<WINDOW>
#endif

public typealias wchar_t = Int32
