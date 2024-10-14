import ncurses

#if canImport(FoundationNetworking)
public typealias WindowPointer = UnsafeMutablePointer<WINDOW>
#else
public typealias WindowPointer = OpaquePointer
#endif

public typealias wchar_t = Int32
