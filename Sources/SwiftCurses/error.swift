public enum ErrorKind {
	case halfdelayParameterOutsideOfRange
	/// Window pointer is NULL
	case cannotCreateWindow 
	case moveOutsideOfWindow
	case getCharError
	case timeoutWithoutData
	case SIGWINCH
	case interrupted
	case negativeCoordinate
	case negativeNumber
	case colorTableCannotBeAllocated
	case colorPairOutsideOfRange
	case colorOutsideOfRange
	case rgbValueOutOfRange
	case colorUnsupported
	case colorChangeUnsupported
	case uninitializedColorPair
	case cursorAboutToWrap
	case mouseEventRegisterError
	case queueFull
	case couldNotOpenFile
	/// Terminal does not support moue as indicated by `MouseEvent.hasMouse`
	case noMouseSupport
	/// Generic error
	case error

	var help: String? {
		switch self {
			case .cannotCreateWindow: return "The window returned was a null pointer"
			case .getCharError: return "Timeout expired without having any data, or the eecution was interrupted by a signal (errno will be set to EINTR)"
			case .timeoutWithoutData: return "Timeout expired without having any data"
			case .SIGWINCH: return "SIGWINCH interrupt"
			case .interrupted: return "The execution was interrupted by a signal"
			case .colorUnsupported: return "Color.define: the terminal does not support this feature, e.g., the initialize_color capability is absent from the terminal description."
			case .colorChangeUnsupported: return "The terminal does not support changing color"
			case .uninitializedColorPair: return "The pair was not initialized using `init_pairs`"
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
