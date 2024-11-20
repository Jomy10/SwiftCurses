#define NCURSES_WIDECHAR 1
#define NCURSES_OPAQUE
#include <ncurses.h>
#include <stdlib.h> // Required for wctomb

// Swift does not pick up the `get_wch` method
static inline int swift_wget_wch(WINDOW* win, wchar_t* ch) {
  return wget_wch(win, ch);
}

static inline int swift_waddwstr(WINDOW* win, const wchar_t* ch) {
  return waddwstr(win, ch);
}

struct swift_YX {
  int y, x;
};

static inline struct swift_YX swift_getbegyx(WINDOW* win) {
  struct swift_YX yx;
  getbegyx(win, yx.y, yx.x);
  return yx;
}

static inline struct swift_YX swift_getmaxyx(WINDOW* win) {
  struct swift_YX yx;
  getmaxyx(win, yx.y, yx.x);
  return yx;
}

static inline struct swift_YX swift_getyx(WINDOW* win) {
  struct swift_YX yx;
  getyx(win, yx.y, yx.x);
  return yx;
}

static inline struct swift_YX swift_getparyx(WINDOW* win) {
  struct swift_YX yx;
  getparyx(win, yx.y, yx.x);
  return yx;
}

//============
// Attributes
//============

const int swift_A_NORMAL = A_NORMAL;
const int swift_A_STANDOUT = A_STANDOUT;
const int swift_A_UNDERLINE = A_UNDERLINE;
const int swift_A_REVERSE = A_REVERSE;
const int swift_A_BLINK = A_BLINK;
const int swift_A_DIM = A_DIM;
const int swift_A_BOLD = A_BOLD;
const int swift_A_PROTECT = A_PROTECT;
const int swift_A_INVIS = A_INVIS;
const int swift_A_ALTCHARSET = A_ALTCHARSET;
const int swift_A_CHARTEXT = A_CHARTEXT;
static inline int swift_COLOR_PAIR(int n) {
  return COLOR_PAIR(n);
}
#ifdef A_ITALIC
const int swift_A_ITALIC = A_ITALIC;
#else
const int swift_A_ITALIC = NCURSES_BITS(1U,23);
#endif

//====================
// Wide char function
//====================

struct swift_wcharBytesReturnType {
  const int8_t* bytes;
  int len;
};

struct swift_wcharBytesReturnType wcharToBytes(wchar_t wc) {
  static char charBuffer[10];
  int len = wctomb(charBuffer, wc);
  return (struct swift_wcharBytesReturnType) {
    (int8_t*) charBuffer,
    len
  };
}

//======
// Keys
//======

// fn keys
static inline int swift_key_f(int n) {
  return KEY_F(n);
}

// Mouse events (macros not being picked uup by swift)
const mmask_t swift_button1Pressed = BUTTON1_PRESSED;              // mouse button 1 down
const mmask_t swift_button1Released = BUTTON1_RELEASED;            // mouse button 1 up
const mmask_t swift_button1Clicked = BUTTON1_CLICKED;              // mouse button 1 clicked
const mmask_t swift_button1DoubleClicked = BUTTON1_DOUBLE_CLICKED; // mouse button 1 double clicked
const mmask_t swift_button1TripleClicked = BUTTON1_TRIPLE_CLICKED; // mouse button 1 triple clicked
const mmask_t swift_button2Pressed = BUTTON2_PRESSED;              // mouse button 2 down
const mmask_t swift_button2Released = BUTTON2_RELEASED;            // mouse button 2 up
const mmask_t swift_button2Clicked = BUTTON2_CLICKED;              // mouse button 2 clicked
const mmask_t swift_button2DoubleClicked = BUTTON2_DOUBLE_CLICKED; // mouse button 2 double clicked
const mmask_t swift_button2TripleClicked = BUTTON2_TRIPLE_CLICKED; // mouse button 2 triple clicked
const mmask_t swift_button3Pressed = BUTTON3_PRESSED;              // mouse button 3 down
const mmask_t swift_button3Released = BUTTON3_RELEASED;            // mouse button 3 up
const mmask_t swift_button3Clicked = BUTTON3_CLICKED;              // mouse button 3 clicked
const mmask_t swift_button3DoubleClicked = BUTTON3_DOUBLE_CLICKED; // mouse button 3 double clicked
const mmask_t swift_button3TripleClicked = BUTTON3_TRIPLE_CLICKED; // mouse button 3 triple clicked
const mmask_t swift_button4Pressed = BUTTON4_PRESSED;              // mouse button 4 down
const mmask_t swift_button4Released = BUTTON4_RELEASED;            // mouse button 4 up
const mmask_t swift_button4Clicked = BUTTON4_CLICKED;              // mouse button 4 clicked
const mmask_t swift_button4DoubleClicked = BUTTON4_DOUBLE_CLICKED; // mouse button 4 double clicked
const mmask_t swift_button4TripleClicked = BUTTON4_TRIPLE_CLICKED; // mouse button 4 triple clicked
const mmask_t swift_buttonShift = BUTTON_SHIFT;                    // shift was down during button state change
const mmask_t swift_buttonCtrl = BUTTON_CTRL;                      // control was down during button state change
const mmask_t swift_buttonAlt = BUTTON_ALT;                        // alt was down during button state change
const mmask_t swift_allMouseEvents = ALL_MOUSE_EVENTS;             // report all button state changes
const mmask_t swift_reportMousePosition = REPORT_MOUSE_POSITION;   // report mouse movement

// TODO: ACS (https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/misc.html)
