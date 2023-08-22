unit uPSI_Glut;
{
   another opengl
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
  TPSImport_Glut = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Glut(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Glut_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  //,GL
  ,Glut
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Glut]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Glut(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PInteger', '^Integer // will not work');
  //CL.AddTypeS('PPChar', '^PChar // will not work');
 CL.AddConstantN('GLUT_API_VERSION','LongInt').SetInt( 3);
 CL.AddConstantN('GLUT_XLIB_IMPLEMENTATION','LongInt').SetInt( 12);
 CL.AddConstantN('GLUT_RGB','LongInt').SetInt( 0);
 //CL.AddConstantN('GLUT_RGBA','').SetString( GLUT_RGB);
 CL.AddConstantN('GLUT_INDEX','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_SINGLE','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_DOUBLE','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_ACCUM','LongInt').SetInt( 4);
 CL.AddConstantN('GLUT_ALPHA','LongInt').SetInt( 8);
 CL.AddConstantN('GLUT_DEPTH','LongInt').SetInt( 16);
 CL.AddConstantN('GLUT_STENCIL','LongInt').SetInt( 32);
 CL.AddConstantN('GLUT_MULTISAMPLE','LongInt').SetInt( 128);
 CL.AddConstantN('GLUT_STEREO','LongInt').SetInt( 256);
 CL.AddConstantN('GLUT_LUMINANCE','LongInt').SetInt( 512);
 CL.AddConstantN('GLUT_LEFT_BUTTON','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_MIDDLE_BUTTON','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_RIGHT_BUTTON','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_DOWN','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_UP','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_KEY_F1','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_KEY_F2','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_KEY_F3','LongInt').SetInt( 3);
 CL.AddConstantN('GLUT_KEY_F4','LongInt').SetInt( 4);
 CL.AddConstantN('GLUT_KEY_F5','LongInt').SetInt( 5);
 CL.AddConstantN('GLUT_KEY_F6','LongInt').SetInt( 6);
 CL.AddConstantN('GLUT_KEY_F7','LongInt').SetInt( 7);
 CL.AddConstantN('GLUT_KEY_F8','LongInt').SetInt( 8);
 CL.AddConstantN('GLUT_KEY_F9','LongInt').SetInt( 9);
 CL.AddConstantN('GLUT_KEY_F10','LongInt').SetInt( 10);
 CL.AddConstantN('GLUT_KEY_F11','LongInt').SetInt( 11);
 CL.AddConstantN('GLUT_KEY_F12','LongInt').SetInt( 12);
 CL.AddConstantN('GLUT_KEY_LEFT','LongInt').SetInt( 100);
 CL.AddConstantN('GLUT_KEY_UP','LongInt').SetInt( 101);
 CL.AddConstantN('GLUT_KEY_RIGHT','LongInt').SetInt( 102);
 CL.AddConstantN('GLUT_KEY_DOWN','LongInt').SetInt( 103);
 CL.AddConstantN('GLUT_KEY_PAGE_UP','LongInt').SetInt( 104);
 CL.AddConstantN('GLUT_KEY_PAGE_DOWN','LongInt').SetInt( 105);
 CL.AddConstantN('GLUT_KEY_HOME','LongInt').SetInt( 106);
 CL.AddConstantN('GLUT_KEY_END','LongInt').SetInt( 107);
 CL.AddConstantN('GLUT_KEY_INSERT','LongInt').SetInt( 108);
 CL.AddConstantN('GLUT_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_ENTERED','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_MENU_NOT_IN_USE','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_MENU_IN_USE','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_NOT_VISIBLE','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_VISIBLE','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_HIDDEN','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_FULLY_RETAINED','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_PARTIALLY_RETAINED','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_FULLY_COVERED','LongInt').SetInt( 3);
 CL.AddConstantN('GLUT_RED','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_GREEN','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_BLUE','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_NORMAL','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_OVERLAY','LongInt').SetInt( 1);
 {CL.AddConstantN('GLUT_STROKE_ROMAN','LongInt').SetInt( Pointer ( 0 ));
 CL.AddConstantN('GLUT_STROKE_MONO_ROMAN','LongInt').SetInt( Pointer ( 1 ));
 CL.AddConstantN('GLUT_BITMAP_9_BY_15','LongInt').SetInt( Pointer ( 2 ));
 CL.AddConstantN('GLUT_BITMAP_8_BY_13','LongInt').SetInt( Pointer ( 3 ));
 CL.AddConstantN('GLUT_BITMAP_TIMES_ROMAN_10','LongInt').SetInt( Pointer ( 4 ));
 CL.AddConstantN('GLUT_BITMAP_TIMES_ROMAN_24','LongInt').SetInt( Pointer ( 5 ));
 CL.AddConstantN('GLUT_BITMAP_HELVETICA_10','LongInt').SetInt( Pointer ( 6 ));
 CL.AddConstantN('GLUT_BITMAP_HELVETICA_12','LongInt').SetInt( Pointer ( 7 ));
 CL.AddConstantN('GLUT_BITMAP_HELVETICA_18','LongInt').SetInt( Pointer ( 8 ));}
 CL.AddConstantN('GLUT_WINDOW_X','LongInt').SetInt( 100);
 CL.AddConstantN('GLUT_WINDOW_Y','LongInt').SetInt( 101);
 CL.AddConstantN('GLUT_WINDOW_WIDTH','LongInt').SetInt( 102);
 CL.AddConstantN('GLUT_WINDOW_HEIGHT','LongInt').SetInt( 103);
 CL.AddConstantN('GLUT_WINDOW_BUFFER_SIZE','LongInt').SetInt( 104);
 CL.AddConstantN('GLUT_WINDOW_STENCIL_SIZE','LongInt').SetInt( 105);
 CL.AddConstantN('GLUT_WINDOW_DEPTH_SIZE','LongInt').SetInt( 106);
 CL.AddConstantN('GLUT_WINDOW_RED_SIZE','LongInt').SetInt( 107);
 CL.AddConstantN('GLUT_WINDOW_GREEN_SIZE','LongInt').SetInt( 108);
 CL.AddConstantN('GLUT_WINDOW_BLUE_SIZE','LongInt').SetInt( 109);
 CL.AddConstantN('GLUT_WINDOW_ALPHA_SIZE','LongInt').SetInt( 110);
 CL.AddConstantN('GLUT_WINDOW_ACCUM_RED_SIZE','LongInt').SetInt( 111);
 CL.AddConstantN('GLUT_WINDOW_ACCUM_GREEN_SIZE','LongInt').SetInt( 112);
 CL.AddConstantN('GLUT_WINDOW_ACCUM_BLUE_SIZE','LongInt').SetInt( 113);
 CL.AddConstantN('GLUT_WINDOW_ACCUM_ALPHA_SIZE','LongInt').SetInt( 114);
 CL.AddConstantN('GLUT_WINDOW_DOUBLEBUFFER','LongInt').SetInt( 115);
 CL.AddConstantN('GLUT_WINDOW_RGBA','LongInt').SetInt( 116);
 CL.AddConstantN('GLUT_WINDOW_PARENT','LongInt').SetInt( 117);
 CL.AddConstantN('GLUT_WINDOW_NUM_CHILDREN','LongInt').SetInt( 118);
 CL.AddConstantN('GLUT_WINDOW_COLORMAP_SIZE','LongInt').SetInt( 119);
 CL.AddConstantN('GLUT_WINDOW_NUM_SAMPLES','LongInt').SetInt( 120);
 CL.AddConstantN('GLUT_WINDOW_STEREO','LongInt').SetInt( 121);
 CL.AddConstantN('GLUT_WINDOW_CURSOR','LongInt').SetInt( 122);
 CL.AddConstantN('GLUT_SCREEN_WIDTH','LongInt').SetInt( 200);
 CL.AddConstantN('GLUT_SCREEN_HEIGHT','LongInt').SetInt( 201);
 CL.AddConstantN('GLUT_SCREEN_WIDTH_MM','LongInt').SetInt( 202);
 CL.AddConstantN('GLUT_SCREEN_HEIGHT_MM','LongInt').SetInt( 203);
 CL.AddConstantN('GLUT_MENU_NUM_ITEMS','LongInt').SetInt( 300);
 CL.AddConstantN('GLUT_DISPLAY_MODE_POSSIBLE','LongInt').SetInt( 400);
 CL.AddConstantN('GLUT_INIT_WINDOW_X','LongInt').SetInt( 500);
 CL.AddConstantN('GLUT_INIT_WINDOW_Y','LongInt').SetInt( 501);
 CL.AddConstantN('GLUT_INIT_WINDOW_WIDTH','LongInt').SetInt( 502);
 CL.AddConstantN('GLUT_INIT_WINDOW_HEIGHT','LongInt').SetInt( 503);
 CL.AddConstantN('GLUT_INIT_DISPLAY_MODE','LongInt').SetInt( 504);
 CL.AddConstantN('GLUT_ELAPSED_TIME','LongInt').SetInt( 700);
 CL.AddConstantN('GLUT_HAS_KEYBOARD','LongInt').SetInt( 600);
 CL.AddConstantN('GLUT_HAS_MOUSE','LongInt').SetInt( 601);
 CL.AddConstantN('GLUT_HAS_SPACEBALL','LongInt').SetInt( 602);
 CL.AddConstantN('GLUT_HAS_DIAL_AND_BUTTON_BOX','LongInt').SetInt( 603);
 CL.AddConstantN('GLUT_HAS_TABLET','LongInt').SetInt( 604);
 CL.AddConstantN('GLUT_NUM_MOUSE_BUTTONS','LongInt').SetInt( 605);
 CL.AddConstantN('GLUT_NUM_SPACEBALL_BUTTONS','LongInt').SetInt( 606);
 CL.AddConstantN('GLUT_NUM_BUTTON_BOX_BUTTONS','LongInt').SetInt( 607);
 CL.AddConstantN('GLUT_NUM_DIALS','LongInt').SetInt( 608);
 CL.AddConstantN('GLUT_NUM_TABLET_BUTTONS','LongInt').SetInt( 609);
 CL.AddConstantN('GLUT_OVERLAY_POSSIBLE','LongInt').SetInt( 800);
 CL.AddConstantN('GLUT_LAYER_IN_USE','LongInt').SetInt( 801);
 CL.AddConstantN('GLUT_HAS_OVERLAY','LongInt').SetInt( 802);
 CL.AddConstantN('GLUT_TRANSPARENT_INDEX','LongInt').SetInt( 803);
 CL.AddConstantN('GLUT_NORMAL_DAMAGED','LongInt').SetInt( 804);
 CL.AddConstantN('GLUT_OVERLAY_DAMAGED','LongInt').SetInt( 805);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_POSSIBLE','LongInt').SetInt( 900);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_IN_USE','LongInt').SetInt( 901);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_X_DELTA','LongInt').SetInt( 902);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_Y_DELTA','LongInt').SetInt( 903);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_WIDTH_DELTA','LongInt').SetInt( 904);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_HEIGHT_DELTA','LongInt').SetInt( 905);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_X','LongInt').SetInt( 906);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_Y','LongInt').SetInt( 907);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_WIDTH','LongInt').SetInt( 908);
 CL.AddConstantN('GLUT_VIDEO_RESIZE_HEIGHT','LongInt').SetInt( 909);
 CL.AddConstantN('GLUT_ACTIVE_SHIFT','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_ACTIVE_CTRL','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_ACTIVE_ALT','LongInt').SetInt( 4);
 CL.AddConstantN('GLUT_CURSOR_RIGHT_ARROW','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_CURSOR_LEFT_ARROW','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_CURSOR_INFO','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_CURSOR_DESTROY','LongInt').SetInt( 3);
 CL.AddConstantN('GLUT_CURSOR_HELP','LongInt').SetInt( 4);
 CL.AddConstantN('GLUT_CURSOR_CYCLE','LongInt').SetInt( 5);
 CL.AddConstantN('GLUT_CURSOR_SPRAY','LongInt').SetInt( 6);
 CL.AddConstantN('GLUT_CURSOR_WAIT','LongInt').SetInt( 7);
 CL.AddConstantN('GLUT_CURSOR_TEXT','LongInt').SetInt( 8);
 CL.AddConstantN('GLUT_CURSOR_CROSSHAIR','LongInt').SetInt( 9);
 CL.AddConstantN('GLUT_CURSOR_UP_DOWN','LongInt').SetInt( 10);
 CL.AddConstantN('GLUT_CURSOR_LEFT_RIGHT','LongInt').SetInt( 11);
 CL.AddConstantN('GLUT_CURSOR_TOP_SIDE','LongInt').SetInt( 12);
 CL.AddConstantN('GLUT_CURSOR_BOTTOM_SIDE','LongInt').SetInt( 13);
 CL.AddConstantN('GLUT_CURSOR_LEFT_SIDE','LongInt').SetInt( 14);
 CL.AddConstantN('GLUT_CURSOR_RIGHT_SIDE','LongInt').SetInt( 15);
 CL.AddConstantN('GLUT_CURSOR_TOP_LEFT_CORNER','LongInt').SetInt( 16);
 CL.AddConstantN('GLUT_CURSOR_TOP_RIGHT_CORNER','LongInt').SetInt( 17);
 CL.AddConstantN('GLUT_CURSOR_BOTTOM_RIGHT_CORNER','LongInt').SetInt( 18);
 CL.AddConstantN('GLUT_CURSOR_BOTTOM_LEFT_CORNER','LongInt').SetInt( 19);
 CL.AddConstantN('GLUT_CURSOR_INHERIT','LongInt').SetInt( 100);
 CL.AddConstantN('GLUT_CURSOR_NONE','LongInt').SetInt( 101);
 CL.AddConstantN('GLUT_CURSOR_FULL_CROSSHAIR','LongInt').SetInt( 102);
 CL.AddConstantN('GLUT_GAME_MODE_ACTIVE','LongInt').SetInt( 0);
 CL.AddConstantN('GLUT_GAME_MODE_POSSIBLE','LongInt').SetInt( 1);
 CL.AddConstantN('GLUT_GAME_MODE_WIDTH','LongInt').SetInt( 2);
 CL.AddConstantN('GLUT_GAME_MODE_HEIGHT','LongInt').SetInt( 3);
 CL.AddConstantN('GLUT_GAME_MODE_PIXEL_DEPTH','LongInt').SetInt( 4);
 CL.AddConstantN('GLUT_GAME_MODE_REFRESH_RATE','LongInt').SetInt( 5);
 CL.AddConstantN('GLUT_GAME_MODE_DISPLAY_CHANGED','LongInt').SetInt( 6);
 CL.AddDelphiFunction('Procedure LoadGlut( const dll : String)');
 CL.AddDelphiFunction('Procedure FreeGlut');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Glut_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoadGlut, 'LoadGlut', cdRegister);
 S.RegisterDelphiFunction(@FreeGlut, 'FreeGlut', cdRegister);
end;



{ TPSImport_Glut }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Glut.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Glut(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Glut.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Glut(ri);
  RIRegister_Glut_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
