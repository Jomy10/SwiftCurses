#define NCURSES_WIDECHAR 1
#include <ncurses.h>

// Swift does not pick up the `get_wch` method
static inline int swift_get_wch(wchar_t* ch) {
  return get_wch(ch);
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

//======
// Keys
//======

static inline int swift_key_f(int n) {
  return KEY_F(n);
}
