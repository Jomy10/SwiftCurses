import ncurses

#if canImport(Foundation)
import Foundation
#endif

extension WindowProtocol {
	#if canImport(Foundation)
	
	@inlinable
	public func get<WinType: ManagedWindow>(file: URL) throws -> WinType {
		guard let filePtr = file.withUnsafeFileSystemRepresentation( { fopen($0, "w") } ) else {
			throw CursesError(.couldNotOpenFile)
		}
		return WinType(ncurses.getwin(filePtr))
	}

	@inlinable
	public func put(file: URL) throws {
		guard let filePtr = file.withUnsafeFileSystemRepresentation( { fopen($0, "w") } ) else {
			throw CursesError(.couldNotOpenFile)
		}
		if ncurses.putwin(self.window, filePtr) == ERR {
			throw CursesError(.couldNotOpenFile)
		}
	}
	
	#else
	
	@inlinable
	public func get(file: UnsafePointer<FILE>) -> OpaquePointer {
		ncurses.getwin(file)
	}

	@inlinable
	public func put(file: UnsafePoiter<FILE>) -> Int32 {
		ncurses.putwin(self.window, file)
	}
	
	#endif
}
