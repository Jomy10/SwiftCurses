#define NCURSES_WIDECHAR 1
#include <ncurses.h>

static inline int swift_get_wch(WINDOW* win) {
  return get_wch(win);
}

int swift_printw(const char* fmt, va_list args) {
  int ret;
  ret = vw_printw(stdscr, fmt, args);
  va_end(args);
  return (ret);
}
