@usableFromInline
internal let ERR = -1

public enum ErrorKind {
	case halfdelayParameterOutsideOfRange
	/// Window pointer is NULL
	case CannotCreateWindow 
	case MoveOutsideOfWindow
	/// Generic error
	case Error
}

public struct CursesError: Error {
	public let kind: ErrorKind

	@usableFromInline
	init(_ kind: ErrorKind) {
		self.kind = kind
	}
}
