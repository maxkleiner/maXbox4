unit uPSI_ovcmisc;
{
   first orpheus
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_ovcmisc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ovcmisc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovcmisc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Buttons
  ,Controls
  ,ExtCtrls
  ,Forms
  ,Graphics
  ,Messages
  ,Consts
  ,OvcData
  ,ovcmisc
  ,ovcutils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcmisc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcmisc(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcHdc', 'Integer');
  CL.AddTypeS('TOvcHWND', 'Cardinal');
  CL.AddTypeS('TOvcHdc', 'HDC');
  CL.AddTypeS('TOvcHWND', 'HWND');
 CL.AddDelphiFunction('Function GetGuiResources( hProcess : THandle; uiFlags : DWORD) : DWORD');
 CL.AddConstantN('SPI_GETBEEP','LongInt').SetInt( 1);
 CL.AddConstantN('SPI_SETBEEP','LongInt').SetInt( 2);
 CL.AddConstantN('SPI_GETMOUSE','LongInt').SetInt( 3);
 CL.AddConstantN('SPI_SETMOUSE','LongInt').SetInt( 4);
 CL.AddConstantN('SPI_GETBORDER','LongInt').SetInt( 5);
 CL.AddConstantN('SPI_SETBORDER','LongInt').SetInt( 6);
 CL.AddConstantN('SPI_GETKEYBOARDSPEED','LongInt').SetInt( 10);
 CL.AddConstantN('SPI_SETKEYBOARDSPEED','LongInt').SetInt( 11);
 CL.AddConstantN('SPI_LANGDRIVER','LongInt').SetInt( 12);
 CL.AddConstantN('SPI_ICONHORIZONTALSPACING','LongInt').SetInt( 13);
 CL.AddConstantN('SPI_GETSCREENSAVETIMEOUT','LongInt').SetInt( 14);
 CL.AddConstantN('SPI_SETSCREENSAVETIMEOUT','LongInt').SetInt( 15);
 CL.AddConstantN('SPI_GETSCREENSAVEACTIVE','LongWord').SetUInt( $10);
 CL.AddConstantN('SPI_SETSCREENSAVEACTIVE','LongInt').SetInt( 17);
 CL.AddConstantN('SPI_GETGRIDGRANULARITY','LongInt').SetInt( 18);
 CL.AddConstantN('SPI_SETGRIDGRANULARITY','LongInt').SetInt( 19);
 CL.AddConstantN('SPI_SETDESKWALLPAPER','LongInt').SetInt( 20);
 CL.AddConstantN('SPI_SETDESKPATTERN','LongInt').SetInt( 21);
 CL.AddConstantN('SPI_GETKEYBOARDDELAY','LongInt').SetInt( 22);
 CL.AddConstantN('SPI_SETKEYBOARDDELAY','LongInt').SetInt( 23);
 CL.AddConstantN('SPI_ICONVERTICALSPACING','LongInt').SetInt( 24);
 CL.AddConstantN('SPI_GETICONTITLEWRAP','LongInt').SetInt( 25);
 CL.AddConstantN('SPI_SETICONTITLEWRAP','LongInt').SetInt( 26);
 CL.AddConstantN('SPI_GETMENUDROPALIGNMENT','LongInt').SetInt( 27);
 CL.AddConstantN('SPI_SETMENUDROPALIGNMENT','LongInt').SetInt( 28);
 CL.AddConstantN('SPI_SETDOUBLECLKWIDTH','LongInt').SetInt( 29);
 CL.AddConstantN('SPI_SETDOUBLECLKHEIGHT','LongInt').SetInt( 30);
 CL.AddConstantN('SPI_GETICONTITLELOGFONT','LongInt').SetInt( 31);
 CL.AddConstantN('SPI_SETDOUBLECLICKTIME','LongWord').SetUInt( $20);
 CL.AddConstantN('SPI_SETMOUSEBUTTONSWAP','LongInt').SetInt( 33);
 CL.AddConstantN('SPI_SETICONTITLELOGFONT','LongInt').SetInt( 34);
 CL.AddConstantN('SPI_GETFASTTASKSWITCH','LongInt').SetInt( 35);
 CL.AddConstantN('SPI_SETFASTTASKSWITCH','LongInt').SetInt( 36);
 CL.AddConstantN('SPI_SETDRAGFULLWINDOWS','LongInt').SetInt( 37);
 CL.AddConstantN('SPI_GETDRAGFULLWINDOWS','LongInt').SetInt( 38);
 CL.AddConstantN('SPI_GETNONCLIENTMETRICS','LongInt').SetInt( 41);
 CL.AddConstantN('SPI_SETNONCLIENTMETRICS','LongInt').SetInt( 42);
 CL.AddConstantN('SPI_GETMINIMIZEDMETRICS','LongInt').SetInt( 43);
 CL.AddConstantN('SPI_SETMINIMIZEDMETRICS','LongInt').SetInt( 44);
 CL.AddConstantN('SPI_GETICONMETRICS','LongInt').SetInt( 45);
 CL.AddConstantN('SPI_SETICONMETRICS','LongInt').SetInt( 46);
 CL.AddConstantN('SPI_SETWORKAREA','LongInt').SetInt( 47);
 CL.AddConstantN('SPI_GETWORKAREA','LongInt').SetInt( 48);
 CL.AddConstantN('SPI_SETPENWINDOWS','LongInt').SetInt( 49);
 CL.AddConstantN('SPI_GETHIGHCONTRAST','LongInt').SetInt( 66);
 CL.AddConstantN('SPI_SETHIGHCONTRAST','LongInt').SetInt( 67);
 CL.AddConstantN('SPI_GETKEYBOARDPREF','LongInt').SetInt( 68);
 CL.AddConstantN('SPI_SETKEYBOARDPREF','LongInt').SetInt( 69);
 CL.AddConstantN('SPI_GETSCREENREADER','LongInt').SetInt( 70);
 CL.AddConstantN('SPI_SETSCREENREADER','LongInt').SetInt( 71);
 CL.AddConstantN('SPI_GETANIMATION','LongInt').SetInt( 72);
 CL.AddConstantN('SPI_SETANIMATION','LongInt').SetInt( 73);
 CL.AddConstantN('SPI_GETFONTSMOOTHING','LongInt').SetInt( 74);
 CL.AddConstantN('SPI_SETFONTSMOOTHING','LongInt').SetInt( 75);
 CL.AddConstantN('SPI_SETDRAGWIDTH','LongInt').SetInt( 76);
 CL.AddConstantN('SPI_SETDRAGHEIGHT','LongInt').SetInt( 77);
 CL.AddConstantN('SPI_SETHANDHELD','LongInt').SetInt( 78);
 CL.AddConstantN('SPI_GETLOWPOWERTIMEOUT','LongInt').SetInt( 79);
 CL.AddConstantN('SPI_GETPOWEROFFTIMEOUT','LongInt').SetInt( 80);
 CL.AddConstantN('SPI_SETLOWPOWERTIMEOUT','LongInt').SetInt( 81);
 CL.AddConstantN('SPI_SETPOWEROFFTIMEOUT','LongInt').SetInt( 82);
 CL.AddConstantN('SPI_GETLOWPOWERACTIVE','LongInt').SetInt( 83);
 CL.AddConstantN('SPI_GETPOWEROFFACTIVE','LongInt').SetInt( 84);
 CL.AddConstantN('SPI_SETLOWPOWERACTIVE','LongInt').SetInt( 85);
 CL.AddConstantN('SPI_SETPOWEROFFACTIVE','LongInt').SetInt( 86);
 CL.AddConstantN('SPI_SETCURSORS','LongInt').SetInt( 87);
 CL.AddConstantN('SPI_SETICONS','LongInt').SetInt( 88);
 CL.AddConstantN('SPI_GETDEFAULTINPUTLANG','LongInt').SetInt( 89);
 CL.AddConstantN('SPI_SETDEFAULTINPUTLANG','LongInt').SetInt( 90);
 CL.AddConstantN('SPI_SETLANGTOGGLE','LongInt').SetInt( 91);
 CL.AddConstantN('SPI_GETWINDOWSEXTENSION','LongInt').SetInt( 92);
 CL.AddConstantN('SPI_SETMOUSETRAILS','LongInt').SetInt( 93);
 CL.AddConstantN('SPI_GETMOUSETRAILS','LongInt').SetInt( 94);
 CL.AddConstantN('SPI_SCREENSAVERRUNNING','LongInt').SetInt( 97);
 CL.AddConstantN('SPI_GETFILTERKEYS','LongInt').SetInt( 50);
 CL.AddConstantN('SPI_SETFILTERKEYS','LongInt').SetInt( 51);
 CL.AddConstantN('SPI_GETTOGGLEKEYS','LongInt').SetInt( 52);
 CL.AddConstantN('SPI_SETTOGGLEKEYS','LongInt').SetInt( 53);
 CL.AddConstantN('SPI_GETMOUSEKEYS','LongInt').SetInt( 54);
 CL.AddConstantN('SPI_SETMOUSEKEYS','LongInt').SetInt( 55);
 CL.AddConstantN('SPI_GETSHOWSOUNDS','LongInt').SetInt( 56);
 CL.AddConstantN('SPI_SETSHOWSOUNDS','LongInt').SetInt( 57);
 CL.AddConstantN('SPI_GETSTICKYKEYS','LongInt').SetInt( 58);
 CL.AddConstantN('SPI_SETSTICKYKEYS','LongInt').SetInt( 59);
 CL.AddConstantN('SPI_GETACCESSTIMEOUT','LongInt').SetInt( 60);
 CL.AddConstantN('SPI_SETACCESSTIMEOUT','LongInt').SetInt( 61);
 CL.AddConstantN('SPI_GETSERIALKEYS','LongInt').SetInt( 62);
 CL.AddConstantN('SPI_SETSERIALKEYS','LongInt').SetInt( 63);
 CL.AddConstantN('SPI_GETSOUNDSENTRY','LongInt').SetInt( 64);
 CL.AddConstantN('SPI_SETSOUNDSENTRY','LongInt').SetInt( 65);
 CL.AddConstantN('SPI_GETSNAPTODEFBUTTON','LongInt').SetInt( 95);
 CL.AddConstantN('SPI_SETSNAPTODEFBUTTON','LongInt').SetInt( 96);
 CL.AddConstantN('SPI_GETMOUSEHOVERWIDTH','LongInt').SetInt( 98);
 CL.AddConstantN('SPI_SETMOUSEHOVERWIDTH','LongInt').SetInt( 99);
 CL.AddConstantN('SPI_GETMOUSEHOVERHEIGHT','LongInt').SetInt( 100);
 CL.AddConstantN('SPI_SETMOUSEHOVERHEIGHT','LongInt').SetInt( 101);
 CL.AddConstantN('SPI_GETMOUSEHOVERTIME','LongInt').SetInt( 102);
 CL.AddConstantN('SPI_SETMOUSEHOVERTIME','LongInt').SetInt( 103);
 CL.AddConstantN('SPI_GETWHEELSCROLLLINES','LongInt').SetInt( 104);
 CL.AddConstantN('SPI_SETWHEELSCROLLLINES','LongInt').SetInt( 105);
 CL.AddConstantN('SPI_GETMENUSHOWDELAY','LongInt').SetInt( 106);
 CL.AddConstantN('SPI_SETMENUSHOWDELAY','LongInt').SetInt( 107);
 CL.AddConstantN('SPI_GETSHOWIMEUI','LongInt').SetInt( 110);
 CL.AddConstantN('SPI_SETSHOWIMEUI','LongInt').SetInt( 111);
 CL.AddConstantN('SPI_GETMOUSESPEED','LongInt').SetInt( 112);
 CL.AddConstantN('SPI_SETMOUSESPEED','LongInt').SetInt( 113);
 CL.AddConstantN('SPI_GETSCREENSAVERRUNNING','LongInt').SetInt( 114);
 CL.AddConstantN('SPI_GETACTIVEWINDOWTRACKING','LongWord').SetUInt( $1000);
 CL.AddConstantN('SPI_SETACTIVEWINDOWTRACKING','LongWord').SetUInt( $1001);
 CL.AddConstantN('SPI_GETMENUANIMATION','LongWord').SetUInt( $1002);
 CL.AddConstantN('SPI_SETMENUANIMATION','LongWord').SetUInt( $1003);
 CL.AddConstantN('SPI_GETCOMBOBOXANIMATION','LongWord').SetUInt( $1004);
 CL.AddConstantN('SPI_SETCOMBOBOXANIMATION','LongWord').SetUInt( $1005);
 CL.AddConstantN('SPI_GETLISTBOXSMOOTHSCROLLING','LongWord').SetUInt( $1006);
 CL.AddConstantN('SPI_SETLISTBOXSMOOTHSCROLLING','LongWord').SetUInt( $1007);
 CL.AddConstantN('SPI_GETGRADIENTCAPTIONS','LongWord').SetUInt( $1008);
 CL.AddConstantN('SPI_SETGRADIENTCAPTIONS','LongWord').SetUInt( $1009);
 CL.AddConstantN('SPI_GETKEYBOARDCUES','LongWord').SetUInt( $100A);
 CL.AddConstantN('SPI_SETKEYBOARDCUES','LongWord').SetUInt( $100B);
 CL.AddConstantN('SPI_GETMENUUNDERLINES','longword').SetUint( $100B);
 CL.AddConstantN('SPI_SETMENUUNDERLINES','longword').SetUint( $100B);
 CL.AddConstantN('SPI_GETACTIVEWNDTRKZORDER','LongWord').SetUInt( $100C);
 CL.AddConstantN('SPI_SETACTIVEWNDTRKZORDER','LongWord').SetUInt( $100D);
 CL.AddConstantN('SPI_GETHOTTRACKING','LongWord').SetUInt( $100E);
 CL.AddConstantN('SPI_SETHOTTRACKING','LongWord').SetUInt( $100F);
 CL.AddConstantN('SPI_GETMENUFADE','LongWord').SetUInt( $1012);
 CL.AddConstantN('SPI_SETMENUFADE','LongWord').SetUInt( $1013);
 CL.AddConstantN('SPI_GETSELECTIONFADE','LongWord').SetUInt( $1014);
 CL.AddConstantN('SPI_SETSELECTIONFADE','LongWord').SetUInt( $1015);
 CL.AddConstantN('SPI_GETTOOLTIPANIMATION','LongWord').SetUInt( $1016);
 CL.AddConstantN('SPI_SETTOOLTIPANIMATION','LongWord').SetUInt( $1017);
 CL.AddConstantN('SPI_GETTOOLTIPFADE','LongWord').SetUInt( $1018);
 CL.AddConstantN('SPI_SETTOOLTIPFADE','LongWord').SetUInt( $1019);
 CL.AddConstantN('SPI_GETCURSORSHADOW','LongWord').SetUInt( $101A);
 CL.AddConstantN('SPI_SETCURSORSHADOW','LongWord').SetUInt( $101B);
 CL.AddConstantN('SPI_GETMOUSESONAR','LongWord').SetUInt( $101C);
 CL.AddConstantN('SPI_SETMOUSESONAR','LongWord').SetUInt( $101D);
 CL.AddConstantN('SPI_GETMOUSECLICKLOCK','LongWord').SetUInt( $101E);
 CL.AddConstantN('SPI_SETMOUSECLICKLOCK','LongWord').SetUInt( $101F);
 CL.AddConstantN('SPI_GETMOUSEVANISH','LongWord').SetUInt( $1020);
 CL.AddConstantN('SPI_SETMOUSEVANISH','LongWord').SetUInt( $1021);
 CL.AddConstantN('SPI_GETFLATMENU','LongWord').SetUInt( $1022);
 CL.AddConstantN('SPI_SETFLATMENU','LongWord').SetUInt( $1023);
 CL.AddConstantN('SPI_GETDROPSHADOW','LongWord').SetUInt( $1024);
 CL.AddConstantN('SPI_SETDROPSHADOW','LongWord').SetUInt( $1025);
 CL.AddConstantN('SPI_GETUIEFFECTS','LongWord').SetUInt( $103E);
 CL.AddConstantN('SPI_SETUIEFFECTS','LongWord').SetUInt( $103F);
 CL.AddConstantN('SPI_GETFOREGROUNDLOCKTIMEOUT','LongWord').SetUInt( $2000);
 CL.AddConstantN('SPI_SETFOREGROUNDLOCKTIMEOUT','LongWord').SetUInt( $2001);
 CL.AddConstantN('SPI_GETACTIVEWNDTRKTIMEOUT','LongWord').SetUInt( $2002);
 CL.AddConstantN('SPI_SETACTIVEWNDTRKTIMEOUT','LongWord').SetUInt( $2003);
 CL.AddConstantN('SPI_GETFOREGROUNDFLASHCOUNT','LongWord').SetUInt( $2004);
 CL.AddConstantN('SPI_SETFOREGROUNDFLASHCOUNT','LongWord').SetUInt( $2005);
 CL.AddConstantN('SPI_GETCARETWIDTH','LongWord').SetUInt( $2006);
 CL.AddConstantN('SPI_SETCARETWIDTH','LongWord').SetUInt( $2007);
 CL.AddConstantN('SPI_GETMOUSECLICKLOCKTIME','LongWord').SetUInt( $2008);
 CL.AddConstantN('SPI_SETMOUSECLICKLOCKTIME','LongWord').SetUInt( $2009);
 CL.AddConstantN('SPI_GETFONTSMOOTHINGTYPE','LongWord').SetUInt( $200A);
 CL.AddConstantN('SPI_SETFONTSMOOTHINGTYPE','LongWord').SetUInt( $200B);
 CL.AddConstantN('FE_FONTSMOOTHINGSTANDARD','LongWord').SetUInt( $0001);
 CL.AddConstantN('FE_FONTSMOOTHINGCLEARTYPE','LongWord').SetUInt( $0002);
 CL.AddConstantN('FE_FONTSMOOTHINGDOCKING','LongWord').SetUInt( $8000);
 CL.AddConstantN('SPI_GETFONTSMOOTHINGCONTRAST','LongWord').SetUInt( $200C);
 CL.AddConstantN('SPI_SETFONTSMOOTHINGCONTRAST','LongWord').SetUInt( $200D);
 CL.AddConstantN('SPI_GETFOCUSBORDERWIDTH','LongWord').SetUInt( $200E);
 CL.AddConstantN('SPI_SETFOCUSBORDERWIDTH','LongWord').SetUInt( $200F);
 CL.AddConstantN('SPI_GETFOCUSBORDERHEIGHT','LongWord').SetUInt( $2010);
 CL.AddConstantN('SPI_SETFOCUSBORDERHEIGHT','LongWord').SetUInt( $2011);
 CL.AddConstantN('SPIF_UPDATEINIFILE','LongInt').SetInt( 1);
 CL.AddConstantN('SPIF_SENDWININICHANGE','LongInt').SetInt( 2);
 CL.AddConstantN('SPIF_SENDCHANGE','longint').SetInt(2);
 CL.AddConstantN('METRICS_USEDEFAULT','LongInt').SetInt( LongWord ( - 1 ));
  CL.AddConstantN('LF_FACESIZE','Byte').SetInt(32);
  CL.AddConstantN('DT_TOP','LongInt').SetInt( 0);
 CL.AddConstantN('DT_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('DT_CENTER','LongInt').SetInt( 1);
 CL.AddConstantN('DT_RIGHT','LongInt').SetInt( 2);
 CL.AddConstantN('DT_VCENTER','LongInt').SetInt( 4);
 CL.AddConstantN('DT_BOTTOM','LongInt').SetInt( 8);
 CL.AddConstantN('DT_WORDBREAK','LongWord').SetUInt( $10);
 CL.AddConstantN('DT_SINGLELINE','LongWord').SetUInt( $20);
 CL.AddConstantN('DT_EXPANDTABS','LongWord').SetUInt( $40);
 CL.AddConstantN('DT_TABSTOP','LongWord').SetUInt( $80);
 CL.AddConstantN('DT_NOCLIP','LongWord').SetUInt( $100);
 CL.AddConstantN('DT_EXTERNALLEADING','LongWord').SetUInt( $200);
 CL.AddConstantN('DT_CALCRECT','LongWord').SetUInt( $400);
 CL.AddConstantN('DT_NOPREFIX','LongWord').SetUInt( $800);
 CL.AddConstantN('DT_INTERNAL','LongWord').SetUInt( $1000);
 CL.AddConstantN('DT_HIDEPREFIX','LongWord').SetUInt( $00100000);
 CL.AddConstantN('DT_PREFIXONLY','LongWord').SetUInt( $00200000);
 CL.AddConstantN('DT_EDITCONTROL','LongWord').SetUInt( $2000);
 CL.AddConstantN('DT_PATH_ELLIPSIS','LongWord').SetUInt( $4000);
 CL.AddConstantN('DT_END_ELLIPSIS','LongWord').SetUInt( $8000);
 CL.AddConstantN('DT_MODIFYSTRING','LongWord').SetUInt( $10000);
 CL.AddConstantN('DT_RTLREADING','LongWord').SetUInt( $20000);
 CL.AddConstantN('DT_WORD_ELLIPSIS','LongWord').SetUInt( $40000);


 //LF_FACESIZE = 32;

 CL.AddTypeS('tagLOGFONTA', 'record lfHeight: UINT; lfwidth : Int'
   +'eger; lfEscapement : Integer; lfOrientation: Integer; lfWeight : Int'
   +'eger; lfItalic : byte; lfUnderline: byte; lfStrikeOut'
   +' : byte; lfCharSet : Byte; lfOutPrecision: byte; lfClipPrecision'
   +': byte; lfQuality: byte; lfPitchAndFamily: byte;'
   +' lfFaceName : array[0..LF_FACESIZE - 1] of Char; end');


{tagLOGFONTA = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
  end;}


 CL.AddTypeS('tagLOGFONT', 'tagLOGFONTA');
  CL.AddTypeS('TLogFontA', 'tagLOGFONTA');
  CL.AddTypeS('TLogFont', 'TLogFontA');

 CL.AddTypeS('tagNONCLIENTMETRICSA', 'record cbSize : UINT; iBorderWidth : Int'
   +'eger; iScrollWidth : Integer; iScrollHeight : Integer; iCaptionWidth : Int'
   +'eger; iCaptionHeight : Integer; lfCaptionFont : TLogFontA; iSmCaptionWidth'
   +' : Integer; iSmCaptionHeight : Integer; lfSmCaptionFont : TLogFontA; iMenu'
   +'Width : Integer; iMenuHeight : Integer; lfMenuFont : TLogFontA; lfStatusFo'
   +'nt : TLogFontA; lfMessageFont : TLogFontA; end');

 CL.AddTypeS('TNonClientMetricsA', 'tagNONCLIENTMETRICSA');
 CL.AddTypeS('TNonClientMetrics', 'TNonClientMetricsA');

   CL.AddTypeS('tagPIXELFORMATDESCRIPTOR', 'record nSize : Word; nVersion : Word'
   +'; dwFlags : DWORD; iPixelType : Byte; cColorBits : Byte; cRedBits : Byte; '
   +'cRedShift : Byte; cGreenBits : Byte; cGreenShift : Byte; cBlueBits : Byte;'
   +' cBlueShift : Byte; cAlphaBits : Byte; cAlphaShift : Byte; cAccumBits : By'
   +'te; cAccumRedBits : Byte; cAccumGreenBits : Byte; cAccumBlueBits : Byte; c'
   +'AccumAlphaBits : Byte; cDepthBits : Byte; cStencilBits : Byte; cAuxBuffers'
   +' : Byte; iLayerType : Byte; bReserved : Byte; dwLayerMask : DWORD; dwVisib'
   +'leMask : DWORD; dwDamageMask : DWORD; end');
  CL.AddTypeS('TPixelFormatDescriptor', 'tagPIXELFORMATDESCRIPTOR');
  CL.AddTypeS('PIXELFORMATDESCRIPTOR', 'tagPIXELFORMATDESCRIPTOR');
   
  CL.AddTypeS('COLOR16', 'Word');
  CL.AddTypeS('_TRIVERTEX', 'record x : Longint; y : Longint; Red : COLOR16; Gr'
   +'een : COLOR16; Blue : COLOR16; Alpha : COLOR16; end');
  CL.AddTypeS('TTriVertex', '_TRIVERTEX');
  CL.AddTypeS('TRIVERTEX', '_TRIVERTEX');
  //CL.AddTypeS('PGradientTriangle', '^TGradientTriangle // will not work');
  CL.AddTypeS('_GRADIENT_TRIANGLE', 'record Vertex1 : ULONG; Vertex2 : ULONG; Vertex3 : ULONG; end');
  CL.AddTypeS('TGradientTriangle', '_GRADIENT_TRIANGLE');
  CL.AddTypeS('GRADIENT_TRIANGLE', '_GRADIENT_TRIANGLE');
  //CL.AddTypeS('PGradientRect', '^TGradientRect // will not work');
  CL.AddTypeS('_GRADIENT_RECT', 'record UpperLeft : ULONG; LowerRight : ULONG; end');
  CL.AddTypeS('TGradientRect', '_GRADIENT_RECT');
  CL.AddTypeS('GRADIENT_RECT', '_GRADIENT_RECT');
   CL.AddTypeS('tagBITMAPINFOHEADER', 'record biSize : DWORD; biWidth : Longint;'
   +' biHeight : Longint; biPlanes : Word; biBitCount : Word; biCompression : D'
   +'WORD; biSizeImage : DWORD; biXPelsPerMeter : Longint; biYPelsPerMeter : Lo'
   +'ngint; biClrUsed : DWORD; biClrImportant : DWORD; end');
  CL.AddTypeS('TBitmapInfoHeader', 'tagBITMAPINFOHEADER');
  CL.AddTypeS('BITMAPINFOHEADER', 'tagBITMAPINFOHEADER');
  CL.AddTypeS('TRGBQuad', 'record rgbBlue, rgbGreen, rgbRed, rgbReserved: byte; end');

  CL.AddTypeS('tagBITMAPINFO', 'record bmiheader: TBITMAPINFOHEADER; bmicolors: array[0..0] of TRGBQuad; end');

  { tagBITMAPINFO = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;  end; }

  CL.AddTypeS('TBitmapInfo', 'tagBITMAPINFO');
  CL.AddTypeS('BITMAPINFO', 'tagBITMAPINFO');
  CL.AddTypeS('TPoints2', 'array[0..2] of TPoint');

  //type TPoints = array[0..2] of TPoint;

 CL.AddDelphiFunction('Function SystemParametersInfo( uiAction, uiParam : UINT; pvParam : UINT; fWinIni : UINT) : BOOL');
 CL.AddDelphiFunction('Function SystemParametersInfoNCM( uiAction, uiParam : UINT; pvParam: TNonClientMetrics; fWinIni : UINT) : BOOL');
 CL.AddDelphiFunction('Function SystemParametersInfoA( uiAction, uiParam : UINT; pvParam : UINT; fWinIni : UINT) : BOOL');
 CL.AddDelphiFunction('Function CreateEllipticRgn( p1, p2, p3, p4 : Integer) : HRGN');
 CL.AddDelphiFunction('Function CreateEllipticRgnIndirect( const p1 : TRect) : HRGN');
 CL.AddDelphiFunction('Function CreateFontIndirect( const p1 : TLogFont) : HFONT');
 CL.AddDelphiFunction('Function CreateMetaFile( p1 : PChar) : HDC');
 CL.AddDelphiFunction('Function DescribePixelFormat( DC : HDC; p2 : Integer; p3 : UINT; var p4 : TPixelFormatDescriptor) : BOOL');
 CL.AddDelphiFunction('Function DrawText( hDC : HDC; lpString : PChar; nCount : Integer; var lpRect : TRect; uFormat : UINT) : Integer');
 CL.AddDelphiFunction('Function DrawTextS( hDC : HDC; lpString : string; nCount : Integer; var lpRect : TRect; uFormat : UINT) : Integer');
 CL.AddDelphiFunction('Function SetMapperFlags( DC : HDC; Flag : DWORD) : DWORD');
 CL.AddDelphiFunction('Function SetGraphicsMode( hdc : HDC; iMode : Integer) : Integer');
 CL.AddDelphiFunction('Function SetMapMode( DC : HDC; p2 : Integer) : Integer');
 CL.AddDelphiFunction('Function SetMetaFileBitsEx( Size : UINT; const Data : PChar) : HMETAFILE');
 //CL.AddDelphiFunction('Function SetPaletteEntries( Palette : HPALETTE; StartIndex, NumEntries : UINT; var PaletteEntries) : UINT');
 CL.AddDelphiFunction('Function SetPixel( DC : HDC; X, Y : Integer; Color : COLORREF) : COLORREF');
 CL.AddDelphiFunction('Function SetPixelV( DC : HDC; X, Y : Integer; Color : COLORREF) : BOOL');
 //CL.AddDelphiFunction('Function SetPixelFormat( DC : HDC; PixelFormat : Integer; FormatDef : PPixelFormatDescriptor) : BOOL');
 CL.AddDelphiFunction('Function SetPolyFillMode( DC : HDC; PolyFillMode : Integer) : Integer');
 CL.AddDelphiFunction('Function StretchBlt( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc, SrcWidth, SrcHeight : Integer; Rop : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetRectRgn( Rgn : HRgn; X1, Y1, X2, Y2 : Integer) : BOOL');
 CL.AddDelphiFunction('Function StretchDIBits( DC : HDC; DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight : Integer; Bits : integer; var BitsInfo : TBitmapInfo; Usage : UINT; Rop : DWORD) : Integer');
 CL.AddDelphiFunction('Function SetROP2( DC : HDC; p2 : Integer) : Integer');
 CL.AddDelphiFunction('Function SetStretchBltMode( DC : HDC; StretchMode : Integer) : Integer');
 CL.AddDelphiFunction('Function SetSystemPaletteUse( DC : HDC; p2 : UINT) : UINT');
 CL.AddDelphiFunction('Function SetTextCharacterExtra( DC : HDC; CharExtra : Integer) : Integer');
 CL.AddDelphiFunction('Function SetTextColor( DC : HDC; Color : COLORREF) : COLORREF');
 CL.AddDelphiFunction('Function SetTextAlign( DC : HDC; Flags : UINT) : UINT');
 CL.AddDelphiFunction('Function SetTextJustification( DC : HDC; BreakExtra, BreakCount : Integer) : Integer');
 CL.AddDelphiFunction('Function UpdateColors( DC : HDC) : BOOL');
 CL.AddDelphiFunction('Function GetViewportExtEx( DC : HDC; var Size : TSize) : BOOL');
 CL.AddDelphiFunction('Function GetViewportOrgEx( DC : HDC; var Point : TPoint) : BOOL');
 CL.AddDelphiFunction('Function GetWindowExtEx( DC : HDC; var Size : TSize) : BOOL');
 CL.AddDelphiFunction('Function GetWindowOrgEx( DC : HDC; var Point : TPoint) : BOOL');
 CL.AddDelphiFunction('Function IntersectClipRect( DC : HDC; X1, Y1, X2, Y2 : Integer) : Integer');
 CL.AddDelphiFunction('Function InvertRgn( DC : HDC; p2 : HRGN) : BOOL');
 CL.AddDelphiFunction('Function MaskBlt( DestDC : HDC; XDest, YDest, Width, Height : Integer; SrcDC : HDC; XScr, YScr : Integer; Mask : HBITMAP; xMask, yMask : Integer; Rop : DWORD) : BOOL');
 CL.AddDelphiFunction('Function PlgBlt( DestDC : HDC; const PointsArray, SrcDC : HDC; XSrc, YSrc, Width, Height : Integer; Mask : HBITMAP; xMask, yMask : Integer) : BOOL');
 CL.AddDelphiFunction('Function PlgBlt2( DestDC : HDC; var PointsArray: TPoints2; SrcDC : HDC; XSrc, YSrc, Width, Height : Integer; Mask : HBITMAP; xMask, yMask : Integer) : BOOL');
 CL.AddDelphiFunction('Function PlgBlt3( DestDC : HDC; const PointsArray: TPoints2; SrcDC : HDC; XSrc, YSrc, Width, Height : Integer; Mask : HBITMAP; xMask, yMask : Integer) : BOOL');

 CL.AddDelphiFunction('Function OffsetClipRgn( DC : HDC; XOffset, YOffset : Integer) : Integer');
 CL.AddDelphiFunction('Function OffsetRgn( RGN : HRGN; XOffset, YOffset : Integer) : Integer');
 CL.AddDelphiFunction('Function PatBlt( DC : HDC; X, Y, Width, Height : Integer; Rop : DWORD) : BOOL');
 CL.AddDelphiFunction('Function Pie( DC : HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer) : BOOL');
 CL.AddDelphiFunction('Function PlayMetaFile( DC : HDC; MF : HMETAFILE) : BOOL');
 CL.AddDelphiFunction('Function PaintRgn( DC : HDC; RGN : HRGN) : BOOL');
 CL.AddDelphiFunction('Function PtInRegion( RGN : HRGN; X, Y : Integer) : BOOL');
 CL.AddDelphiFunction('Function PtVisible( DC : HDC; X, Y : Integer) : BOOL');
 CL.AddDelphiFunction('Function RectInRegion( RGN : HRGN; const Rect : TRect) : BOOL');
 CL.AddDelphiFunction('Function RectVisible( DC : HDC; const Rect : TRect) : BOOL');
 CL.AddDelphiFunction('Function Rectangle( DC : HDC; X1, Y1, X2, Y2 : Integer) : BOOL');
CL.AddDelphiFunction('Function RestoreDC( DC : HDC; SavedDC : Integer) : BOOL');
//CL.AddDelphiFunction('Function CreateDirectory( lpPathName : PChar; lpSecurityAttributes : PSecurityAttributes) : BOOL');
CL.AddDelphiFunction('Procedure SetFileApisToOEM');
 CL.AddDelphiFunction('Procedure SetFileApisToANSI');
 CL.AddDelphiFunction('Function AreFileApisANSI : BOOL');
CL.AddDelphiFunction('Function CancelIo( hFile : THandle) : BOOL');
 CL.AddDelphiFunction('Function ClearEventLog( hEventLog : THandle; lpBackupFileName : PChar) : BOOL');
 
//orig ovc
 CL.AddDelphiFunction('Function LoadBaseBitmap( lpBitmapName : PChar) : HBITMAP');
 CL.AddDelphiFunction('Function LoadBaseCursor( lpCursorName : PChar) : HCURSOR');
 CL.AddDelphiFunction('Function ovCompStruct( const S1, S2, Size : Cardinal) : Integer');
 CL.AddDelphiFunction('Function DefaultEpoch : Integer');
 CL.AddDelphiFunction('Function DrawButtonFrame( Canvas : TCanvas; const Client : TRect; IsDown, IsFlat : Boolean; Style : TButtonStyle) : TRect');
 CL.AddDelphiFunction('Procedure FixRealPrim( P : PChar; DC : Char)');
 CL.AddDelphiFunction('Function GetDisplayString( Canvas : TCanvas; const S : string; MinChars, MaxWidth : Integer) : string');
 CL.AddDelphiFunction('Function GetLeftButton : Byte');
 CL.AddDelphiFunction('Function GetNextDlgItem( Ctrl : TOvcHWnd) : hWnd');
 CL.AddDelphiFunction('Procedure GetRGB( Clr : TColor; var IR, IG, IB : Byte)');
 CL.AddDelphiFunction('Function GetShiftFlags : Byte');
 CL.AddDelphiFunction('Function ovCreateRotatedFont( F : TFont; Angle : Integer) : hFont');
 CL.AddDelphiFunction('Function GetTopTextMargin( Font : TFont; BorderStyle : TBorderStyle; Height : Integer; Ctl3D : Boolean) : Integer');
 CL.AddDelphiFunction('Function ovExtractWord( N : Integer; const S : string; WordDelims : TCharSet) : string');
 CL.AddDelphiFunction('Function ovIsForegroundTask : Boolean');
 CL.AddDelphiFunction('Function ovTrimLeft( const S : string) : string');
 CL.AddDelphiFunction('Function ovTrimRight( const S : string) : string');
 CL.AddDelphiFunction('Function ovQuotedStr( const S : string) : string');
 CL.AddDelphiFunction('Function ovWordCount( const S : string; const WordDelims : TCharSet) : Integer');
 CL.AddDelphiFunction('Function ovWordPosition( const N : Integer; const S : string; const WordDelims : TCharSet) : Integer');
 CL.AddDelphiFunction('Function PtrDiff( const P1, P2 : PChar) : Word');
 CL.AddDelphiFunction('Procedure PtrInc( var P, Delta : Word)');
 CL.AddDelphiFunction('Procedure PtrDec( var P, Delta : Word)');
 CL.AddDelphiFunction('Procedure FixTextBuffer( InBuf, OutBuf : PChar; OutSize : Integer)');
 CL.AddDelphiFunction('Procedure TransStretchBlt( DstDC : TOvcHdc; DstX, DstY, DstW, DstH : Integer; SrcDC : TOvcHdc; SrcX, SrcY, SrcW, SrcH : Integer; MaskDC : TOvcHdc; MaskX, MaskY : Integer)');
 CL.AddDelphiFunction('Function ovMinI( X, Y : Integer) : Integer');
 CL.AddDelphiFunction('Function ovMaxI( X, Y : Integer) : Integer');
 CL.AddDelphiFunction('Function ovMinL( X, Y : LongInt) : LongInt');
 CL.AddDelphiFunction('Function ovMaxL( X, Y : LongInt) : LongInt');
 CL.AddDelphiFunction('Function GenerateComponentName( PF : TWinControl; const Root : string) : string');
 CL.AddDelphiFunction('Function PartialCompare( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function PathEllipsis( const S : string; MaxWidth : Integer) : string');
 CL.AddDelphiFunction('Function ovCreateDisabledBitmap( FOriginal : TBitmap; OutlineColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Procedure ovCopyParentImage( Control : TControl; Dest : TCanvas)');
 CL.AddDelphiFunction('Procedure ovDrawTransparentBitmap( Dest : TCanvas; X, Y, W, H : Integer; Rect : TRect; Bitmap : TBitmap; TransparentColor : TColor)');
 CL.AddDelphiFunction('Function ovWidthOf( const R : TRect) : Integer');
 CL.AddDelphiFunction('Function ovHeightOf( const R : TRect) : Integer');
 CL.AddDelphiFunction('Procedure ovDebugOutput( const S : string)');
 CL.AddDelphiFunction('Function GetArrowWidth( Width, Height : Integer) : Integer');
 CL.AddDelphiFunction('Procedure StripCharSeq( CharSeq : string; var Str : string)');
 CL.AddDelphiFunction('Procedure StripCharFromEnd( aChr : Char; var Str : string)');
 CL.AddDelphiFunction('Procedure StripCharFromFront( aChr : Char; var Str : string)');
 CL.AddDelphiFunction('Procedure DrawTransparentBitmapPrim(DC: TOvcHdc; Bitmap : HBitmap; xStart, yStart, Width, Height : Integer; Rect : TRect;'+
                           ' TransparentColor : TColorRef)');




end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcmisc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoadBaseBitmap, 'LoadBaseBitmap', cdRegister);
 S.RegisterDelphiFunction(@LoadBaseCursor, 'LoadBaseCursor', cdRegister);
 S.RegisterDelphiFunction(@CompStruct, 'ovCompStruct', cdRegister);
 S.RegisterDelphiFunction(@DefaultEpoch, 'DefaultEpoch', cdRegister);
 S.RegisterDelphiFunction(@DrawButtonFrame, 'DrawButtonFrame', cdRegister);
 S.RegisterDelphiFunction(@FixRealPrim, 'FixRealPrim', cdRegister);
 S.RegisterDelphiFunction(@GetDisplayString, 'GetDisplayString', cdRegister);
 S.RegisterDelphiFunction(@GetLeftButton, 'GetLeftButton', cdRegister);
 S.RegisterDelphiFunction(@GetNextDlgItem, 'GetNextDlgItem', cdRegister);
 S.RegisterDelphiFunction(@GetRGB, 'GetRGB', cdRegister);
 S.RegisterDelphiFunction(@GetShiftFlags, 'GetShiftFlags', cdRegister);
 S.RegisterDelphiFunction(@CreateRotatedFont, 'ovCreateRotatedFont', cdRegister);
 S.RegisterDelphiFunction(@GetTopTextMargin, 'GetTopTextMargin', cdRegister);
 S.RegisterDelphiFunction(@ExtractWord, 'ovExtractWord', cdRegister);
 S.RegisterDelphiFunction(@IsForegroundTask, 'ovIsForegroundTask', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft, 'ovTrimLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimRight, 'ovTrimRight', cdRegister);
 S.RegisterDelphiFunction(@QuotedStr, 'ovQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@WordCount, 'ovWordCount', cdRegister);
 S.RegisterDelphiFunction(@WordPosition, 'ovWordPosition', cdRegister);
 S.RegisterDelphiFunction(@PtrDiff, 'PtrDiff', cdRegister);
 S.RegisterDelphiFunction(@PtrInc, 'PtrInc', cdRegister);
 S.RegisterDelphiFunction(@PtrDec, 'PtrDec', cdRegister);
 S.RegisterDelphiFunction(@FixTextBuffer, 'FixTextBuffer', cdRegister);
 S.RegisterDelphiFunction(@TransStretchBlt, 'TransStretchBlt', cdRegister);
 S.RegisterDelphiFunction(@MinI, 'ovMinI', cdRegister);
 S.RegisterDelphiFunction(@MaxI, 'ovMaxI', cdRegister);
 S.RegisterDelphiFunction(@MinL, 'ovMinL', cdRegister);
 S.RegisterDelphiFunction(@MaxL, 'ovMaxL', cdRegister);
 S.RegisterDelphiFunction(@GenerateComponentName, 'GenerateComponentName', cdRegister);
 S.RegisterDelphiFunction(@PartialCompare, 'PartialCompare', cdRegister);
 S.RegisterDelphiFunction(@PathEllipsis, 'PathEllipsis', cdRegister);
 S.RegisterDelphiFunction(@CreateDisabledBitmap, 'ovCreateDisabledBitmap', cdRegister);
 S.RegisterDelphiFunction(@CopyParentImage, 'ovCopyParentImage', cdRegister);
 S.RegisterDelphiFunction(@DrawTransparentBitmap, 'ovDrawTransparentBitmap', cdRegister);
 S.RegisterDelphiFunction(@DrawTransparentBitmapPrim, 'DrawTransparentBitmapPrim', cdRegister);

 S.RegisterDelphiFunction(@WidthOf, 'ovWidthOf', cdRegister);
 S.RegisterDelphiFunction(@HeightOf, 'ovHeightOf', cdRegister);
 S.RegisterDelphiFunction(@DebugOutput, 'ovDebugOutput', cdRegister);
 S.RegisterDelphiFunction(@GetArrowWidth, 'GetArrowWidth', cdRegister);
 S.RegisterDelphiFunction(@StripCharSeq, 'StripCharSeq', cdRegister);
 S.RegisterDelphiFunction(@StripCharFromEnd, 'StripCharFromEnd', cdRegister);
 S.RegisterDelphiFunction(@StripCharFromFront, 'StripCharFromFront', cdRegister);
 S.RegisterDelphiFunction(@GetGuiResources, 'GetGuiResources', CdStdCall);
 S.RegisterDelphiFunction(@SystemParametersInfoA, 'SystemParametersInfoA', CdStdCall);
 S.RegisterDelphiFunction(@SystemParametersInfoW, 'SystemParametersInfoW', CdStdCall);
 S.RegisterDelphiFunction(@SystemParametersInfoA, 'SystemParametersInfoNCM', CdStdCall);

 S.RegisterDelphiFunction(@CreateEllipticRgn, 'CreateEllipticRgn', CdStdCall);
 S.RegisterDelphiFunction(@CreateEllipticRgnIndirect, 'CreateEllipticRgnIndirect', CdStdCall);
 S.RegisterDelphiFunction(@CreateFontIndirect, 'CreateFontIndirect', CdStdCall);
 S.RegisterDelphiFunction(@ChoosePixelFormat, 'ChoosePixelFormat', CdStdCall);
 S.RegisterDelphiFunction(@CreateMetaFile, 'CreateMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@DescribePixelFormat, 'DescribePixelFormat', CdStdCall);
 S.RegisterDelphiFunction(@DrawText, 'DrawText', CdStdCall);
 S.RegisterDelphiFunction(@DrawText, 'DrawTextS', CdStdCall);
  S.RegisterDelphiFunction(@SetPixel, 'SetPixel', CdStdCall);
 S.RegisterDelphiFunction(@SetPixelV, 'SetPixelV', CdStdCall);
// S.RegisterDelphiFunction(@SetPixelFormat, 'SetPixelFormat', CdStdCall);
 //S.RegisterDelphiFunction(@SetDIBitsToDevice, 'SetDIBitsToDevice', CdStdCall);
 S.RegisterDelphiFunction(@SetMapperFlags, 'SetMapperFlags', CdStdCall);
 S.RegisterDelphiFunction(@SetGraphicsMode, 'SetGraphicsMode', CdStdCall);
 S.RegisterDelphiFunction(@SetMapMode, 'SetMapMode', CdStdCall);
  S.RegisterDelphiFunction(@SetMetaFileBitsEx, 'SetMetaFileBitsEx', CdStdCall);
 S.RegisterDelphiFunction(@SetPolyFillMode, 'SetPolyFillMode', CdStdCall);
 S.RegisterDelphiFunction(@StretchBlt, 'StretchBlt', CdStdCall);
 S.RegisterDelphiFunction(@SetRectRgn, 'SetRectRgn', CdStdCall);
 //S.RegisterDelphiFunction(@StretchDIBits, 'StretchDIBits', CdStdCall);
 S.RegisterDelphiFunction(@SetROP2, 'SetROP2', CdStdCall);
 S.RegisterDelphiFunction(@SetStretchBltMode, 'SetStretchBltMode', CdStdCall);
 S.RegisterDelphiFunction(@SetSystemPaletteUse, 'SetSystemPaletteUse', CdStdCall);
 S.RegisterDelphiFunction(@SetTextCharacterExtra, 'SetTextCharacterExtra', CdStdCall);
 S.RegisterDelphiFunction(@SetTextColor, 'SetTextColor', CdStdCall);
 S.RegisterDelphiFunction(@SetTextAlign, 'SetTextAlign', CdStdCall);
 S.RegisterDelphiFunction(@SetTextJustification, 'SetTextJustification', CdStdCall);
 S.RegisterDelphiFunction(@UpdateColors, 'UpdateColors', CdStdCall);
  S.RegisterDelphiFunction(@GetViewportExtEx, 'GetViewportExtEx', CdStdCall);
 S.RegisterDelphiFunction(@GetViewportOrgEx, 'GetViewportOrgEx', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowExtEx, 'GetWindowExtEx', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowOrgEx, 'GetWindowOrgEx', CdStdCall);
 S.RegisterDelphiFunction(@IntersectClipRect, 'IntersectClipRect', CdStdCall);
 S.RegisterDelphiFunction(@InvertRgn, 'InvertRgn', CdStdCall);
 S.RegisterDelphiFunction(@LineDDA, 'LineDDA', CdStdCall);
 S.RegisterDelphiFunction(@LineTo, 'LineTo', CdStdCall);
 S.RegisterDelphiFunction(@MaskBlt, 'MaskBlt', CdStdCall);
 S.RegisterDelphiFunction(@PlgBlt, 'PlgBlt', CdStdCall);
 S.RegisterDelphiFunction(@PlgBlt, 'PlgBlt2', CdStdCall);
 S.RegisterDelphiFunction(@PlgBlt, 'PlgBlt3', CdStdCall);
 S.RegisterDelphiFunction(@OffsetClipRgn, 'OffsetClipRgn', CdStdCall);
 S.RegisterDelphiFunction(@OffsetRgn, 'OffsetRgn', CdStdCall);
 S.RegisterDelphiFunction(@PatBlt, 'PatBlt', CdStdCall);
 S.RegisterDelphiFunction(@Pie, 'Pie', CdStdCall);
 S.RegisterDelphiFunction(@PlayMetaFile, 'PlayMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@PaintRgn, 'PaintRgn', CdStdCall);
 S.RegisterDelphiFunction(@PtInRegion, 'PtInRegion', CdStdCall);
 S.RegisterDelphiFunction(@PtVisible, 'PtVisible', CdStdCall);
 S.RegisterDelphiFunction(@RectInRegion, 'RectInRegion', CdStdCall);
 S.RegisterDelphiFunction(@RectVisible, 'RectVisible', CdStdCall);
 S.RegisterDelphiFunction(@Rectangle, 'Rectangle', CdStdCall);
 S.RegisterDelphiFunction(@RestoreDC, 'RestoreDC', CdStdCall);
 S.RegisterDelphiFunction(@ResetDC, 'ResetDC', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToOEM, 'SetFileApisToOEM', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToANSI, 'SetFileApisToANSI', CdStdCall);
 S.RegisterDelphiFunction(@AreFileApisANSI, 'AreFileApisANSI', CdStdCall);
 S.RegisterDelphiFunction(@CancelIo, 'CancelIo', CdStdCall);
 S.RegisterDelphiFunction(@ClearEventLog, 'ClearEventLog', CdStdCall);


end;

 
 
{ TPSImport_ovcmisc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmisc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcmisc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmisc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ovcmisc(ri);
  RIRegister_ovcmisc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
