import ncurses

public struct KeyCode {
	/// The type of the KeyCode values
	public typealias type = Int32

	public static let `break` = KEY_BREAK	// Break key
	public static let down = KEY_DOWN	// Arrow down
	public static let up = KEY_UP	// Arrow up
	public static let left = KEY_LEFT	// Arrow left
	public static let right = KEY_RIGHT	// Arrow right
	public static let home = KEY_HOME	// Home key
	public static let backspace = KEY_BACKSPACE	// Backspace
	public static let f0 = KEY_F0	// Function key zero
	public static let dl = KEY_DL	// Delete line
	public static let il = KEY_IL	// Insert line
	public static let dc = KEY_DC	// Delete character
	public static let ic = KEY_IC	// Insert char or enter insert mode
	public static let eic = KEY_EIC	// Exit insert char mode
	public static let clear = KEY_CLEAR	// Clear screen
	public static let eos = KEY_EOS	// Clear to end of screen
	public static let eol = KEY_EOL	// Clear to end of line
	public static let sf = KEY_SF	// Scroll 1 line forward
	public static let sr = KEY_SR	// Scroll 1 line backward (reverse)
	public static let npage = KEY_NPAGE	// Next page
	public static let ppage = KEY_PPAGE	// Previous page
	public static let stab = KEY_STAB	// Set tab
	public static let ctab = KEY_CTAB	// Clear tab
	public static let catab = KEY_CATAB	// Clear all tabs
	public static let enter = KEY_ENTER	// Enter or send
	public static let sreset = KEY_SRESET	// Soft (partial) reset
	public static let reset = KEY_RESET	// Reset or hard reset
	public static let print = KEY_PRINT	// Print or copy
	public static let ll = KEY_LL	// Home down or bottom (lower left)
	public static let a1 = KEY_A1	// Upper left of keypad
	public static let a3 = KEY_A3	// Upper right of keypad
	public static let b2 = KEY_B2	// Center of keypad
	public static let c1 = KEY_C1	// Lower left of keypad
	public static let c3 = KEY_C3	// Lower right of keypad
	public static let btab = KEY_BTAB	// Back tab key
	public static let beg = KEY_BEG	// Beg(inning) key
	public static let cancel = KEY_CANCEL	// Cancel key
	public static let close = KEY_CLOSE	// Close key
	public static let command = KEY_COMMAND	// Cmd (command) key
	public static let copy = KEY_COPY	// Copy key
	public static let create = KEY_CREATE	// Create key
	public static let end = KEY_END	// End key
	public static let exit = KEY_EXIT	// Exit key
	public static let find = KEY_FIND	// Find key
	public static let help = KEY_HELP	// Help key
	public static let mark = KEY_MARK	// Mark key
	public static let message = KEY_MESSAGE	// Message key

	// Table 5.3: the keypad constants, part 1
	public static let mouse = KEY_MOUSE	// Mouse event read
	public static let move = KEY_MOVE	// Move key
	public static let next = KEY_NEXT	// Next object key
	public static let open = KEY_OPEN	// Open key
	public static let options = KEY_OPTIONS	// Options key
	public static let previous = KEY_PREVIOUS	// Previous object key
	public static let redo = KEY_REDO	// Redo key
	public static let reference = KEY_REFERENCE	// Ref(erence) key
	public static let refresh = KEY_REFRESH	// Refresh key
	public static let replace = KEY_REPLACE	// Replace key
	public static let resize = KEY_RESIZE	// Screen resized
	public static let restart = KEY_RESTART	// Restart key
	public static let resume = KEY_RESUME	// Resume key
	public static let save = KEY_SAVE	// Save key
	public static let sbeg = KEY_SBEG	// Shifted beginning key
	public static let scancel = KEY_SCANCEL	// Shifted cancel key
	public static let scommand = KEY_SCOMMAND	// Shifted command key
	public static let scopy = KEY_SCOPY	// Shifted copy key
	public static let screate = KEY_SCREATE	// Shifted create key
	public static let sdc = KEY_SDC	// Shifted delete char key
	public static let sdl = KEY_SDL	// Shifted delete line key
	public static let select = KEY_SELECT	// Select key
	public static let send = KEY_SEND	// Shifted end key
	public static let seol = KEY_SEOL	// Shifted clear line key
	public static let sexit = KEY_SEXIT	// Shifted exit key
	public static let sfind = KEY_SFIND	// Shifted find key
	public static let shelp = KEY_SHELP	// Shifted help key
	public static let shome = KEY_SHOME	// Shifted home key
	public static let sic = KEY_SIC	// Shifted input key
	public static let sleft = KEY_SLEFT	// Shifted left arrow key
	public static let smessage = KEY_SMESSAGE	// Shifted message key
	public static let smove = KEY_SMOVE	// Shifted move key
	public static let snext = KEY_SNEXT	// Shifted next key
	public static let soptions = KEY_SOPTIONS	// Shifted options key
	public static let sprevious = KEY_SPREVIOUS	// Shifted prev key
	public static let sprint = KEY_SPRINT	// Shifted print key
	public static let sredo = KEY_SREDO	// Shifted redo key
	public static let sreplace = KEY_SREPLACE	// Shifted replace key
	public static let sright = KEY_SRIGHT	// Shifted right arrow
	// public static let sresume = KEY_SRESUME	// Shifted resume key
	public static let ssave = KEY_SSAVE	// Shifted save key
	public static let ssuspend = KEY_SSUSPEND	// Shifted suspend key
	public static let sundo = KEY_SUNDO	// Shifted undo key
	public static let suspend = KEY_SUSPEND	// Suspend key
	public static let undo = KEY_UNDO	// Undo key

	/// Fn keys
	public static func f(_ n: Int32) -> Int32 {
		return swift_key_f(n)
	}
}
