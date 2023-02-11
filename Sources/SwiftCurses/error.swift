// @usableFromInline
// internal let ERR = -1

public enum ErrorKind {
	case halfdelayParameterOutsideOfRange
	/// Window pointer is NULL
	case cannotCreateWindow 
	case moveOutsideOfWindow
	case getCharError
	case timeoutWithoutData
	case SIGWINCH
	case interrupted
	/// Generic error
	case error

	var help: String? {
		switch self {
			case .cannotCreateWindow: return "The window returned was a null pointer"
			case .getCharError: return "Timeout expired without having any data, or the eecution was interrupted by a signal (errno will be set to EINTR)"
			case .timeoutWithoutData: return "Timeout expired without having any data"
			case .SIGWINCH: return "SIGWINCH interrupt"
			case .interrupted: return "the execution was interrupted by a signal"
			default: return nil
		}
	}
}

public struct CursesError: Error & CustomDebugStringConvertible {
	public let kind: ErrorKind
	public let help: String?

	@usableFromInline
	init(_ kind: ErrorKind, help: String? = nil) {
		self.kind = kind
		self.help = help ?? kind.help
	}

	var description: String {
		"Error: \(self.kind)\n\(self.help == nil ? "" : "Help: \(self.help!)")"
	}

	public var debugDescription: String {
		self.description
	}
}
