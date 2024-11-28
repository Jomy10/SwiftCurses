#ifndef _SWIFTCURSES_BINDS
#define _SWIFTCURSES_BINDS

#define NCURSES_WIDECHAR 1
#include <ncurses.h>
#include <wchar.h>

int swift_wget_wch(WINDOW* win, wchar_t* ch);
int swift_waddwstr(WINDOW* win, const wchar_t* ch);

struct swift_YX {
  int y, x;
};

struct swift_YX swift_getbegyx(WINDOW* win);
struct swift_YX swift_getmaxyx(WINDOW* win);
struct swift_YX swift_getyx(WINDOW* win);
struct swift_YX swift_getparyx(WINDOW* win);

//============
// Attributes
//============

extern const int swift_A_NORMAL;
extern const int swift_A_STANDOUT;
extern const int swift_A_UNDERLINE;
extern const int swift_A_REVERSE;
extern const int swift_A_BLINK;
extern const int swift_A_DIM;
extern const int swift_A_BOLD;
extern const int swift_A_PROTECT;
extern const int swift_A_INVIS;
extern const int swift_A_ALTCHARSET;
extern const int swift_A_CHARTEXT;
int swift_COLOR_PAIR(int n);
extern const int swift_A_ITALIC;

//====================
// Wide char function
//====================

struct swift_wcharBytesReturnType {
  const int8_t* bytes;
  int len;
};

struct swift_wcharBytesReturnType wcharToBytes(wchar_t wc);

//======
// Keys
//======

int swift_key_f(int n);

extern const mmask_t swift_button1Pressed;              // mouse button 1 down
extern const mmask_t swift_button1Released;            // mouse button 1 up
extern const mmask_t swift_button1Clicked;              // mouse button 1 clicked
extern const mmask_t swift_button1DoubleClicked; // mouse button 1 double clicked
extern const mmask_t swift_button1TripleClicked; // mouse button 1 triple clicked
extern const mmask_t swift_button2Pressed;              // mouse button 2 down
extern const mmask_t swift_button2Released;            // mouse button 2 up
extern const mmask_t swift_button2Clicked;              // mouse button 2 clicked
extern const mmask_t swift_button2DoubleClicked; // mouse button 2 double clicked
extern const mmask_t swift_button2TripleClicked; // mouse button 2 triple clicked
extern const mmask_t swift_button3Pressed;              // mouse button 3 down
extern const mmask_t swift_button3Released;            // mouse button 3 up
extern const mmask_t swift_button3Clicked;              // mouse button 3 clicked
extern const mmask_t swift_button3DoubleClicked; // mouse button 3 double clicked
extern const mmask_t swift_button3TripleClicked; // mouse button 3 triple clicked
extern const mmask_t swift_button4Pressed;              // mouse button 4 down
extern const mmask_t swift_button4Released;            // mouse button 4 up
extern const mmask_t swift_button4Clicked;              // mouse button 4 clicked
extern const mmask_t swift_button4DoubleClicked; // mouse button 4 double clicked
extern const mmask_t swift_button4TripleClicked; // mouse button 4 triple clicked
extern const mmask_t swift_buttonShift;                    // shift was down during button state change
extern const mmask_t swift_buttonCtrl;                      // control was down during button state change
extern const mmask_t swift_buttonAlt;                        // alt was down during button state change
extern const mmask_t swift_allMouseEvents;             // report all button state changes
extern const mmask_t swift_reportMousePosition;   // report mouse movement

#endif
