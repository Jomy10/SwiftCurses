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

// static inline int swift_printw(const char* fmt, va_list args) {
//   int ret;
//   ret = vw_printw(stdscr, fmt, args);
//   va_end(args);
//   return (ret);
// }
