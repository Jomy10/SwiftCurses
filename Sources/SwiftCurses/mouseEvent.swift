import ncurses

public enum MouseEventMask {
	case button1Pressed       // mouse button 1 down
	case button1Released      // mouse button 1 up
	case button1Clicked       // mouse button 1 clicked
	case button1DoubleClicked // mouse button 1 double clicked
	case button1TripleClicked // mouse button 1 triple clicked
	case button2Pressed       // mouse button 2 down
	case button2Released      // mouse button 2 up
	case button2Clicked       // mouse button 2 clicked
	case button2DoubleClicked // mouse button 2 double clicked
	case button2TripleClicked // mouse button 2 triple clicked
	case button3Pressed       // mouse button 3 down
	case button3Released      // mouse button 3 up
	case button3Clicked       // mouse button 3 clicked
	case button3DoubleClicked // mouse button 3 double clicked
	case button3TripleClicked // mouse button 3 triple clicked
	case button4Pressed       // mouse button 4 down
	case button4Released      // mouse button 4 up
	case button4Clicked       // mouse button 4 clicked
	case button4DoubleClicked // mouse button 4 double clicked
	case button4TripleClicked // mouse button 4 triple clicked
	case buttonShift          // shift was down during button state change
	case buttonCtrl           // control was down during button state change
	case buttonAlt            // alt was down during button state change
	case allMouseEvents       // report all button state changes
	case reportMousePosition  // report mouse movement

	var val: mmask_t {
		switch self {
			case .button1Pressed: return swift_button1Pressed
			case .button1Released: return swift_button1Released
			case .button1Clicked: return swift_button1Clicked
			case .button1DoubleClicked: return swift_button1DoubleClicked
			case .button1TripleClicked: return swift_button1TripleClicked
			case .button2Pressed: return swift_button2Pressed
			case .button2Released: return swift_button2Released
			case .button2Clicked: return swift_button2Clicked
			case .button2DoubleClicked: return swift_button2DoubleClicked
			case .button2TripleClicked: return swift_button2TripleClicked
			case .button3Pressed: return swift_button3Pressed
			case .button3Released: return swift_button3Released
			case .button3Clicked: return swift_button3Clicked
			case .button3DoubleClicked: return swift_button3DoubleClicked
			case .button3TripleClicked: return swift_button3TripleClicked
			case .button4Pressed: return swift_button4Pressed
			case .button4Released: return swift_button4Released
			case .button4Clicked: return swift_button4Clicked
			case .button4DoubleClicked: return swift_button4DoubleClicked
			case .button4TripleClicked: return swift_button4TripleClicked
			case .buttonShift: return swift_buttonShift
			case .buttonCtrl: return swift_buttonCtrl
			case .buttonAlt: return swift_buttonAlt
			case .allMouseEvents: return swift_allMouseEvents
			case .reportMousePosition: return swift_reportMousePosition
		}
	}
}

public typealias MouseEvent = ncurses.MEVENT

public enum MouseButton {
	case button1
	case button2
	case button3
	case button4
}

extension MouseButton {
	@inlinable
	func pressed(_ mask: mmask_t) -> Bool {
		switch self {
			case .button1: return mask & swift_button1Pressed != 0
			case .button2: return mask & swift_button2Pressed != 0
			case .button3: return mask & swift_button3Pressed != 0
			case .button4: return mask & swift_button4Pressed != 0
		}
	}

	@inlinable
	func released(_ mask: mmask_t) -> Bool {
		switch self {
			case .button1: return mask & swift_button1Released != 0
			case .button2: return mask & swift_button2Released != 0
			case .button3: return mask & swift_button3Released != 0
			case .button4: return mask & swift_button4Released != 0
		}
	}

	@inlinable
	func clicked(_ mask: mmask_t) -> Bool {
		switch self {
			case .button1: return mask & swift_button1Clicked != 0
			case .button2: return mask & swift_button2Clicked != 0
			case .button3: return mask & swift_button3Clicked != 0
			case .button4: return mask & swift_button4Clicked != 0
		}
	}

	@inlinable
	func doubleClicked(_ mask: mmask_t) -> Bool {
		switch self {
			case .button1: return mask & swift_button1DoubleClicked != 0
			case .button2: return mask & swift_button2DoubleClicked != 0
			case .button3: return mask & swift_button3DoubleClicked != 0
			case .button4: return mask & swift_button4DoubleClicked != 0
		}
	}

	@inlinable
	func tripleClicked(_ mask: mmask_t) -> Bool {
		switch self {
			case .button1: return mask & swift_button1TripleClicked != 0
			case .button2: return mask & swift_button2TripleClicked != 0
			case .button3: return mask & swift_button3TripleClicked != 0
			case .button4: return mask & swift_button4TripleClicked != 0
		}
	}
}

public enum ModifierKey {
	case shift
	case ctrl
	case alt
}

extension ModifierKey {
	@inlinable
	func active(_ mask: mmask_t) -> Bool {
		switch self {
			case .shift: return mask & swift_buttonShift != 0
			case .ctrl: return mask & swift_buttonCtrl != 0
			case .alt: return mask & swift_buttonAlt != 0
		}
	}
}

extension MouseEvent {
	/// Register the given mouse events
	public func register(_ events: MouseEventMask...) throws {
		if ncurses.mousemask(events.reduce(0) { $0 | $1.val }, nil) == 0 && events.count != 0 {
			throw CursesError(.mouseEventRegisterError) // TODO: help
		}
	}

	/// Once a class of mouse events has been made visible in a window, calling the
	/// GetCharCode function on that window may return `KeyEvent.mouse` as an indicator
	/// that a mouse event has been queued. To read the event data and op the event
	/// off the queue, call `MouseEvent.get()`. This function will a `MouseEvent` if a
	/// mouse event is actually visible in the given window, otherwise it might throw
	/// an error.
	///
	/// When this function returns an event, the `position.x` and `position.y` in the event
	/// struct coordinates will be screen-relative character-cell cooridnates. The
	/// event will have exactly one `MouseButton` event, which can be got with the `KeyEvent.pressed`
	/// and similar functions. The corresponding data in the queue is marked invalid. A
	/// subsequent call to `MouseEvent.get()` will retrieve the next older item from
	/// the queue.
	public static func get() -> MouseEvent? {
		// TODO: figure out if err because no mouse-event, or other reason
		// if no mouse-event in queue -> return nil instead
		var event = MouseEvent()
		if getmouse(&event) != OK {
			return nil
		}
		return event
	}

	/// button is down
	public func isPressed(_ btn: MouseButton) -> Bool {
		btn.pressed(self.bstate)
	}

	/// button is up
	public func isReleased(_ btn: MouseButton) -> Bool {
		btn.released(self.bstate)
	}

	/// button is clicked
	public func isClicked(_ btn: MouseButton) -> Bool {
		btn.clicked(self.bstate)
	}

	public func isDoubleClicked(_ btn: MouseButton) -> Bool {
		btn.doubleClicked(self.bstate)
	}

	public func isTripleClicked(_ btn: MouseButton) -> Bool {
		btn.tripleClicked(self.bstate)
	}

	/// Whether the given modifier key was down during the button state change
	public func modifierActive(_ modifier: ModifierKey) -> Bool {
		modifier.active(self.bstate)
	}

	/// even coordinates
	public var position: (x: Int32, y: Int32, z: Int32) {
		(self.x, self.y, self.z)
	}

	/// device id
	public var device: Int16 {
		self.id
	}
}
