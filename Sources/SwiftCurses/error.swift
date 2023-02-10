@usableFromInline
internal let ERR = -1

public enum ErrorKind {
	case halfdelayParameterOutsideOfRange
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
