(*
 * StdConsts -
 *   A file chock-full of constants that are mostly annoying,
 *      like CRLF, TAB, etc...
 *)
unit StdConsts;

interface

const
  // Stupid character constants
  CRLF = #13 + #10;
  CR   = #13;
  LF   = #10;
  TAB  = #9;
  NULL_TERMINATOR = #0;
  WHITE_SPACE = CR + LF + TAB + ' ';
  // Standard DOS filename 8 + . + 3 + #0 = 13
  EIGHT_PLUS_THREE = 13;
  // Easily convert Boolean to 'Y', 'N'
  BoolYesNo: array[Boolean] of Char = ('N', 'Y');

implementation

end.
