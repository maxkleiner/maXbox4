{ Menus Import Unit }
Unit uPSC_menus;
{$I PascalScript.inc}
Interface
Uses uPSCompiler;

procedure SIRegisterTMENUITEMSTACK(CL: TPSPascalCompiler);
procedure SIRegisterTPOPUPLIST(CL: TPSPascalCompiler);
procedure SIRegisterTPOPUPMENU(CL: TPSPascalCompiler);
procedure SIRegisterTMAINMENU(CL: TPSPascalCompiler);
procedure SIRegisterTMENU(CL: TPSPascalCompiler);
procedure SIRegisterTMENUITEM(CL: TPSPascalCompiler);
procedure SIRegister_TMenuItemEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TMenuActionLink(CL: TPSPascalCompiler);
procedure SIRegister_Menus(Cl: TPSPascalCompiler);

implementation

procedure SIRegisterTMENUITEMSTACK(CL: TPSPascalCompiler);
begin
	With cl.AddClassN(Cl.FindClass('TSTACK'),'TMENUITEMSTACK') do
	begin
	  RegisterMethod('Procedure CLEARITEM( AITEM : TMENUITEM)');
	end;
end;

procedure SIRegisterTPOPUPLIST(CL: TPSPascalCompiler);
begin
	With cl.AddClassN(Cl.FindClass('TLIST'),'TPOPUPLIST') do
	begin
		RegisterProperty('WINDOW', 'HWND', iptr);
		RegisterMethod('Procedure ADD( POPUP : TPOPUPMENU)');
		RegisterMethod('Procedure REMOVE( POPUP : TPOPUPMENU)');
	end;
end;

procedure SIRegisterTPOPUPMENU(CL: TPSPascalCompiler);
var
	cc: TPSCompileTimeClass;
begin
	With cl.AddClassN(Cl.FindClass('TMENU'),'TPOPUPMENU') do
	begin
		cc := Cl.FindClass('TLabel');
		if cc <> nil then
			RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptRW);
		with Cl.FindClass('TForm') do
		begin
			RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptRW);
		end;
	RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
	RegisterMethod('Procedure POPUP( X, Y : INTEGER)');
	RegisterProperty('POPUPCOMPONENT', 'TCOMPONENT', iptrw);
	RegisterProperty('ALIGNMENT', 'TPOPUPALIGNMENT', iptrw);
	RegisterProperty('AUTOPOPUP', 'BOOLEAN', iptrw);
	RegisterProperty('HELPCONTEXT', 'THELPCONTEXT', iptrw);
    RegisterProperty('MENUANIMATION', 'TMENUANIMATION', iptrw);
    RegisterProperty('TRACKBUTTON', 'TTRACKBUTTON', iptrw);
    RegisterProperty('ONPOPUP', 'TNOTIFYEVENT', iptrw);
    //RegisterProperty('PARENT', 'TMENUITEM', iptrw);

  end;
end;

procedure SIRegisterTMAINMENU(CL: TPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TMENU'),'TMAINMENU') do begin
    RegisterMethod('Procedure MERGE( MENU : TMAINMENU)');
    RegisterMethod('Procedure UNMERGE( MENU : TMAINMENU)');
    RegisterMethod('Procedure POPULATEOLE2MENU( SHAREDMENU : HMENU; GROUPS : array of INTEGER; var WIDTHS : array of LONGINT)');
    RegisterMethod('Procedure GETOLE2ACCELERATORTABLE( var ACCELTABLE : HACCEL; var ACCELCOUNT : INTEGER; GROUPS : array of INTEGER)');
    RegisterMethod('Procedure SETOLE2MENUHANDLE( HANDLE : HMENU)');
    RegisterProperty('AUTOMERGE', 'BOOLEAN', iptrw);
  end;
end;

procedure SIRegisterTMENU(CL: TPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TCOMPONENT'),'TMENU') do begin
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
      RegisterMethod('Function CreateMenuItem : TMenuItem');
      RegisterMethod('Function DISPATCHCOMMAND( ACOMMAND : WORD) : BOOLEAN');
    RegisterMethod('Function DISPATCHPOPUP( AHANDLE : HMENU) : BOOLEAN');
    RegisterMethod('Function FINDITEM( VALUE : INTEGER; KIND : TFINDITEMKIND) : TMENUITEM');
    RegisterMethod('Function GETHELPCONTEXT( VALUE : INTEGER; BYCOMMAND : BOOLEAN) : THELPCONTEXT');
    RegisterProperty('IMAGES', 'TCUSTOMIMAGELIST', iptrw);
    RegisterMethod('Function ISRIGHTTOLEFT : BOOLEAN');
    RegisterMethod('Procedure PARENTBIDIMODECHANGED( ACONTROL : TOBJECT)');
    RegisterMethod('Procedure PROCESSMENUCHAR( var MESSAGE : TWMMENUCHAR)');
    RegisterProperty('AUTOHOTKEYS', 'TMENUAUTOFLAG', iptrw);
    RegisterProperty('AUTOLINEREDUCTION', 'TMENUAUTOFLAG', iptrw);
    RegisterProperty('BIDIMODE', 'TBIDIMODE', iptrw);
    RegisterProperty('HANDLE', 'HMENU', iptr);
    RegisterProperty('OWNERDRAW', 'BOOLEAN', iptrw);
    RegisterProperty('PARENTBIDIMODE', 'BOOLEAN', iptrw);
    RegisterProperty('WINDOWHANDLE', 'HWND', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ITEMS', 'TMENUITEM', iptr);
  end;
end;

procedure SIRegisterTMENUITEM(CL: TPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TCOMPONENT'),'TMENUITEM') do begin
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure INITIATEACTION');
    RegisterMethod('Procedure INSERT( INDEX : INTEGER; ITEM : TMENUITEM)');
    RegisterMethod('Procedure DELETE( INDEX : INTEGER)');
    RegisterMethod('Procedure CLEAR');
    RegisterMethod('Procedure CLICK');
    RegisterMethod('Function FIND( ACAPTION : String) : TMENUITEM');
    RegisterMethod('Function INDEXOF( ITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Function ISLINE : BOOLEAN');
    RegisterMethod('Function GETIMAGELIST : TCUSTOMIMAGELIST');
    RegisterMethod('Function GETPARENTCOMPONENT : TCOMPONENT');
    RegisterMethod('Function GETPARENTMENU : TMENU');
    RegisterMethod('Function HASPARENT : BOOLEAN');
    RegisterMethod('Function NEWTOPLINE : INTEGER');
    RegisterMethod('Function NEWBOTTOMLINE : INTEGER');
    RegisterMethod('Function INSERTNEWLINEBEFORE( AITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Function INSERTNEWLINEAFTER( AITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Procedure ADD( ITEM : TMENUITEM)');
    RegisterMethod('Procedure REMOVE( ITEM : TMENUITEM)');
    RegisterMethod('Function RETHINKHOTKEYS : BOOLEAN');
    RegisterMethod('Function RETHINKLINES : BOOLEAN');
    RegisterProperty('COMMAND', 'WORD', iptr);
    RegisterProperty('HANDLE', 'HMENU', iptr);
    RegisterProperty('COUNT', 'INTEGER', iptr);
    RegisterProperty('ITEMS', 'TMENUITEM INTEGER', iptr);
    RegisterProperty('MENUINDEX', 'INTEGER', iptrw);
    RegisterProperty('PARENT', 'TMENUITEM', iptrw);
    {$IFDEF DELPHI5UP}
    RegisterProperty('ACTION', 'TBASICACTION', iptrw);
    {$ENDIF}
    RegisterPublishedProperties;
    RegisterProperty('AUTOHOTKEYS', 'TMENUITEMAUTOFLAG', iptrw);
    RegisterProperty('AUTOLINEREDUCTION', 'TMENUITEMAUTOFLAG', iptrw);
    RegisterProperty('BITMAP', 'TBITMAP', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('SUBMENUIMAGES', 'TCUSTOMIMAGELIST', iptrw);
    RegisterProperty('DEFAULT', 'BOOLEAN', iptrw);
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('Autocheck', 'BOOLEAN', iptrw);
    RegisterProperty('GROUPINDEX', 'BYTE', iptrw);
    RegisterProperty('HELPCONTEXT', 'THELPCONTEXT', iptrw);
    RegisterProperty('HINT', 'String', iptrw);
    RegisterProperty('IMAGEINDEX', 'TIMAGEINDEX', iptrw);
    RegisterProperty('RADIOITEM', 'BOOLEAN', iptrw);
    RegisterProperty('SHORTCUT', 'TSHORTCUT', iptrw);
    RegisterProperty('VISIBLE', 'BOOLEAN', iptrw);
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
   {$IFNDEF FPC} RegisterProperty('ONDRAWITEM', 'TMENUDRAWITEMEVENT', iptrw);
    RegisterProperty('ONADVANCEDDRAWITEM', 'TADVANCEDMENUDRAWITEMEVENT', iptrw);
    RegisterProperty('ONMEASUREITEM', 'TMENUMEASUREITEMEVENT', iptrw);{$ENDIF}
       RegisterProperty('SubMenuImages', 'TCustomImageList', iptrw);
    RegisterProperty('OnDrawItem', 'TMenuDrawItemEvent', iptrw);
    //RegisterProperty('OnAdvancedDrawItem', 'TAdvancedMenuDrawItemEvent', iptrw);
    //RegisterProperty('OnMeasureItem', 'TMenuMeasureItemEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMenuItemEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMenuItemEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMenuItemEnumerator') do begin
    RegisterMethod('Constructor Create( AMenuItem : TMenuItem)');
    RegisterMethod('Function GetCurrent : TMenuItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TMenuItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMenuActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionLink', 'TMenuActionLink') do
  with CL.AddClassN(CL.FindClass('TActionLink'),'TMenuActionLink') do begin
  end;
end;


procedure SIRegister_Menus(Cl: TPSPascalCompiler);
begin
  Cl.AddTypeS('HMenu', 'Cardinal');
  Cl.AddTypeS('HACCEL', 'Cardinal');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMenuItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMenuError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMenu');
   cl.addClassN(cl.FindClass('EXCEPTION'),'EMENUERROR');
  Cl.addTypeS('TMENUBREAK', '( MBNONE, MBBREAK, MBBARBREAK )');
{$IFNDEF FPC}
  Cl.addTypeS('TMENUDRAWITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACANVAS : TC'
   +'ANVAS; ARECT : TRECT; SELECTED : BOOLEAN)');
  Cl.addTypeS('TADVANCEDMENUDRAWITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACAN'
   +'VAS : TCANVAS; ARECT : TRECT; STATE : TOWNERDRAWSTATE)');
  Cl.addTypeS('TMENUMEASUREITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACANVAS :'
   +' TCANVAS; var WIDTH, HEIGHT : INTEGER)');
{$ENDIF}
  Cl.addTypeS('TMENUITEMAUTOFLAG', '( MAAUTOMATIC, MAMANUAL, MAPARENT )');
  Cl.AddTypeS('TMenuAutoFlag', 'TMENUITEMAUTOFLAG');
  Cl.addTypeS('TSHORTCUT', 'WORD');
  cl.addClassN(cl.FindClass('TACTIONLINK'),'TMENUACTIONLINK');
  SIRegister_TMenuActionLink(CL);
  //CL.AddTypeS('TMenuActionLinkClass', 'class of TMenuActionLink');
  SIRegister_TMenuItemEnumerator(CL);
  SIRegisterTMENUITEM(Cl);
  Cl.addTypeS('TMENUCHANGEEVENT', 'Procedure ( SENDER : TOBJECT; SOURCE : TMENU'
   +'ITEM; REBUILD : BOOLEAN)');
  Cl.addTypeS('TFINDITEMKIND', '( FKCOMMAND, FKHANDLE, FKSHORTCUT )');
  SIRegisterTMENU(Cl);
  SIRegisterTMAINMENU(Cl);
  Cl.addTypeS('TPOPUPALIGNMENT', '( PALEFT, PARIGHT, PACENTER )');
  Cl.addTypeS('TTRACKBUTTON', '( TBRIGHTBUTTON, TBLEFTBUTTON )');
  Cl.addTypeS('TMENUANIMATIONS', '( MALEFTTORIGHT, MARIGHTTOLEFT, MATOPTOBOTTOM'
   +', MABOTTOMTOTOP, MANONE )');
  Cl.addTypeS('TMENUANIMATION', 'set of TMENUANIMATIONS');
  SIRegisterTPOPUPMENU(Cl);
  SIRegisterTPOPUPLIST(Cl);
  SIRegisterTMENUITEMSTACK(Cl);
  Cl.addTypeS('TCMENUITEM', 'TMENUITEM');
{$IFNDEF FPC}
//TODO: it should work,but somehow TShiftState is not defined
  Cl.AddDelphiFunction('Function SHORTCUT( KEY : WORD; SHIFT : TSHIFTSTATE) : TSHORTCUT');
  Cl.AddDelphiFunction('Procedure SHORTCUTTOKEY( SHORTCUT : TSHORTCUT; var KEY: WORD; var SHIFT : TSHIFTSTATE)');
{$ENDIF}
  Cl.AddDelphiFunction('Function SHORTCUTTOTEXT( SHORTCUT : TSHORTCUT) : String');
  Cl.AddDelphiFunction('Function TEXTTOSHORTCUT( TEXT : String) : TSHORTCUT');
  Cl.AddDelphiFunction('Function NEWMENU( OWNER : TCOMPONENT; const ANAME : STR'
   +'ING; ITEMS : array of TMenuItem) : TMAINMENU');
  Cl.AddDelphiFunction('Function NEWPOPUPMENU( OWNER : TCOMPONENT; const ANAME '
   +': String; ALIGNMENT : TPOPUPALIGNMENT; AUTOPOPUP : BOOLEAN; const ITEMS : array of TCMENUITEM) : TPOPUPMENU');
  Cl.AddDelphiFunction('Function NEWSUBMENU( const ACAPTION : String; HCTX : WO'
   +'RD; const ANAME : String; ITEMS : array of TMenuItem; AENABLED : BOOLEAN) : TMENUITEM');
  Cl.AddDelphiFunction('Function NEWITEM( const ACAPTION : String; ASHORTCUT : '
   +'TSHORTCUT; ACHECKED, AENABLED : BOOLEAN; AONCLICK : TNOTIFYEVENT; HCTX : W'
   +'ORD; const ANAME : String) : TMENUITEM');
  Cl.AddDelphiFunction('Function NEWLINE : TMENUITEM');
{$IFNDEF FPC}
  Cl.AddDelphiFunction('Procedure DRAWMENUITEM( MENUITEM : TMENUITEM; ACANVAS :'
   +' TCANVAS; ARECT : TRECT; STATE : TOWNERDRAWSTATE)');
{$ENDIF}

 CL.AddDelphiFunction('Function ShortCut( Key : Word; Shift : TShiftState) : TShortCut');
 CL.AddDelphiFunction('Procedure ShortCutToKey( ShortCut : TShortCut; var Key : Word; var Shift : TShiftState)');
 CL.AddDelphiFunction('Function ShortCutFromMessage( Message : TWMKey) : TShortCut');
 CL.AddDelphiFunction('Function NewMenu( Owner : TComponent; const AName : string; const Items : array of TMenuItem) : TMainMenu');
 CL.AddDelphiFunction('Function NewPopupMenu( Owner : TComponent; const AName : string; Alignment : TPopupAlignment; AutoPopup : Boolean; const Items : array of TMenuItem) : TPopupMenu');
 CL.AddDelphiFunction('Function NewSubMenu( const ACaption : string; hCtx : THelpContext; const AName : string; const Items : array of TMenuItem; AEnabled : Boolean) : TMenuItem');
 CL.AddDelphiFunction('Function NewItem( const ACaption : string; AShortCut : TShortCut; AChecked, AEnabled : Boolean; AOnClick : TNotifyEvent; hCtx : THelpContext; const AName : string) : TMenuItem');
 CL.AddDelphiFunction('Function NewLine : TMenuItem');
 CL.AddDelphiFunction('Procedure DrawMenuItem( MenuItem : TMenuItem; ACanvas : TCanvas; ARect : TRect; State : TOwnerDrawState)');
 CL.AddConstantN('cHotkeyPrefix','String').SetString( '&');
 CL.AddConstantN('cLineCaption','String').SetString( '-');
 CL.AddConstantN('cDialogSuffix','String').SetString( '...');
 CL.AddDelphiFunction('Function StripHotkey( const Text : string) : string');
 CL.AddDelphiFunction('Function GetHotkey( const Text : string) : string');
 CL.AddDelphiFunction('Function AnsiSameCaption( const Text1, Text2 : string) : Boolean');
 CL.AddDelphiFunction('Function IsAltGRPressed : boolean');

end;

end.
