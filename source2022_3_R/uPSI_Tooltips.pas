unit uPSI_Tooltips;
{
   dx7
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
  TPSImport_Tooltips = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TControlTooltip(CL: TPSPascalCompiler);
procedure SIRegister_Tooltips(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TControlTooltip(CL: TPSRuntimeClassImporter);
procedure RIRegister_Tooltips(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Types
  ,Graphics
  ,Controls
  ,Tooltips
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Tooltips]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlTooltip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TControlTooltip') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TControlTooltip') do begin
    RegisterMethod('Constructor Create( UnderWnd : THandle; const Title, Text : WideString)');
        RegisterMethod('Procedure Free');
    RegisterMethod('Procedure MoveTo( const Point : TPoint);');
    RegisterMethod('Procedure MoveTo1( Control : TControl);');
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('UnderWnd', 'THandle', iptr);
    RegisterProperty('Info', 'TToolInfo', iptr);
    RegisterProperty('Icon', 'TToolTipIcon', iptrw);
    RegisterProperty('BkColor', 'TColor', iptrw);
    RegisterProperty('TextColor', 'TColor', iptrw);
    RegisterProperty('Title', 'WideString', iptrw);
    RegisterProperty('Text', 'WideString', iptrw);
    RegisterProperty('AutoHide', 'Boolean', iptrw);
    RegisterProperty('CenterTail', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Tooltips(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TToolTipIcon', '( tiNone, tiInfo, tiWarning, tiError, tiInfoLarg'
   +'e, tiWarningLarge, tiErrorLarge )');
  CL.AddTypeS('TToolInfo', 'record cbSize : Integer; uFlags : Integer; hwnd : T'
   +'Handle; uId : Integer; rect : TRect; hinst : THandle; lpszText : PChar; lParam : Integer; end');
  SIRegister_TControlTooltip(CL);
 CL.AddConstantN('TOOLTIPS_CLASS','String').SetString( 'tooltips_class32');
 CL.AddConstantN('TTS_ALWAYSTIP','LongInt').SetInt( 1);
 CL.AddConstantN('TTS_NOPREFIX','LongInt').SetInt( 2);
 CL.AddConstantN('TTS_NOANIMATE','LongWord').SetUInt( $10);
 CL.AddConstantN('TTS_NOFADE','LongWord').SetUInt( $20);
 CL.AddConstantN('TTS_BALLOON','LongWord').SetUInt( $40);
 CL.AddConstantN('TTS_CLOSE','LongWord').SetUInt( $80);
 CL.AddConstantN('TTF_IDISHWND','LongInt').SetInt( 1);
 CL.AddConstantN('TTF_RTLREADING','LongInt').SetInt( 4);
 CL.AddConstantN('TTF_CENTERTIP','LongWord').SetUInt( $0002);
 CL.AddConstantN('TTF_SUBCLASS','LongWord').SetUInt( $0010);
 CL.AddConstantN('TTF_TRACK','LongWord').SetUInt( $0020);
 CL.AddConstantN('TTF_ABSOLUTE','LongWord').SetUInt( $0080);
 CL.AddConstantN('TTF_TRANSPARENT','LongWord').SetUInt( $0100);
 CL.AddConstantN('TTF_DI_SETITEM','LongWord').SetUInt( $8000);
 CL.AddConstantN('TTF_PARSELINKS','LongWord').SetUInt( $1000);
 CL.AddConstantN('TTM_ACTIVATE','LongInt').SetInt( WM_USER + 1);
 CL.AddConstantN('TTM_SETDELAYTIME','LongInt').SetInt( WM_USER + 3);
 CL.AddConstantN('TTM_ADDTOOLA','LongInt').SetInt( WM_USER + 4);
 CL.AddConstantN('TTM_ADDTOOLW','LongInt').SetInt( WM_USER + 50);
 CL.AddConstantN('TTM_DELTOOLA','LongInt').SetInt( WM_USER + 5);
 CL.AddConstantN('TTM_DELTOOLW','LongInt').SetInt( WM_USER + 51);
 CL.AddConstantN('TTM_NEWTOOLRECTA','LongInt').SetInt( WM_USER + 6);
 CL.AddConstantN('TTM_NEWTOOLRECTW','LongInt').SetInt( WM_USER + 52);
 CL.AddConstantN('TTM_RELAYEVENT','LongInt').SetInt( WM_USER + 7);
 CL.AddConstantN('TTM_GETTOOLINFOA','LongInt').SetInt( WM_USER + 8);
 CL.AddConstantN('TTM_GETTOOLINFOW','LongInt').SetInt( WM_USER + 53);
 CL.AddConstantN('TTM_SETTOOLINFOA','LongInt').SetInt( WM_USER + 9);
 CL.AddConstantN('TTM_SETTOOLINFOW','LongInt').SetInt( WM_USER + 54);
 CL.AddConstantN('TTM_HITTESTA','LongInt').SetInt( WM_USER + 10);
 CL.AddConstantN('TTM_HITTESTW','LongInt').SetInt( WM_USER + 55);
 CL.AddConstantN('TTM_GETTEXTA','LongInt').SetInt( WM_USER + 11);
 CL.AddConstantN('TTM_GETTEXTW','LongInt').SetInt( WM_USER + 56);
 CL.AddConstantN('TTM_UPDATETIPTEXTA','LongInt').SetInt( WM_USER + 12);
 CL.AddConstantN('TTM_UPDATETIPTEXTW','LongInt').SetInt( WM_USER + 57);
 CL.AddConstantN('TTM_GETTOOLCOUNT','LongInt').SetInt( WM_USER + 13);
 CL.AddConstantN('TTM_ENUMTOOLSA','LongInt').SetInt( WM_USER + 14);
 CL.AddConstantN('TTM_ENUMTOOLSW','LongInt').SetInt( WM_USER + 58);
 CL.AddConstantN('TTM_GETCURRENTTOOLA','LongInt').SetInt( WM_USER + 15);
 CL.AddConstantN('TTM_GETCURRENTTOOLW','LongInt').SetInt( WM_USER + 59);
 CL.AddConstantN('TTM_WINDOWFROMPOINT','LongInt').SetInt( WM_USER + 16);
 CL.AddConstantN('TTM_TRACKACTIVATE','LongInt').SetInt( WM_USER + 17);
 CL.AddConstantN('TTM_TRACKPOSITION','LongInt').SetInt( WM_USER + 18);
 CL.AddConstantN('TTM_SETTIPBKCOLOR','LongInt').SetInt( WM_USER + 19);
 CL.AddConstantN('TTM_SETTIPTEXTCOLOR','LongInt').SetInt( WM_USER + 20);
 CL.AddConstantN('TTM_GETDELAYTIME','LongInt').SetInt( WM_USER + 21);
 CL.AddConstantN('TTM_GETTIPBKCOLOR','LongInt').SetInt( WM_USER + 22);
 CL.AddConstantN('TTM_GETTIPTEXTCOLOR','LongInt').SetInt( WM_USER + 23);
 CL.AddConstantN('TTM_SETMAXTIPWIDTH','LongInt').SetInt( WM_USER + 24);
 CL.AddConstantN('TTM_GETMAXTIPWIDTH','LongInt').SetInt( WM_USER + 25);
 CL.AddConstantN('TTM_SETMARGIN','LongInt').SetInt( WM_USER + 26);
 CL.AddConstantN('TTM_GETMARGIN','LongInt').SetInt( WM_USER + 27);
 CL.AddConstantN('TTM_POP','LongInt').SetInt( WM_USER + 28);
 CL.AddConstantN('TTM_UPDATE','LongInt').SetInt( WM_USER + 29);
 CL.AddConstantN('TTM_GETBUBBLESIZE','LongInt').SetInt( WM_USER + 30);
 CL.AddConstantN('TTM_ADJUSTRECT','LongInt').SetInt( WM_USER + 31);
 CL.AddConstantN('TTM_SETTITLEA','LongInt').SetInt( WM_USER + 32);
 CL.AddConstantN('TTM_SETTITLEW','LongInt').SetInt( WM_USER + 33);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TControlTooltipCenterTail_W(Self: TControlTooltip; const T: Boolean);
begin Self.CenterTail := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipCenterTail_R(Self: TControlTooltip; var T: Boolean);
begin T := Self.CenterTail; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipAutoHide_W(Self: TControlTooltip; const T: Boolean);
begin Self.AutoHide := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipAutoHide_R(Self: TControlTooltip; var T: Boolean);
begin T := Self.AutoHide; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipText_W(Self: TControlTooltip; const T: WideString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipText_R(Self: TControlTooltip; var T: WideString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipTitle_W(Self: TControlTooltip; const T: WideString);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipTitle_R(Self: TControlTooltip; var T: WideString);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipTextColor_W(Self: TControlTooltip; const T: TColor);
begin Self.TextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipTextColor_R(Self: TControlTooltip; var T: TColor);
begin T := Self.TextColor; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipBkColor_W(Self: TControlTooltip; const T: TColor);
begin Self.BkColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipBkColor_R(Self: TControlTooltip; var T: TColor);
begin T := Self.BkColor; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipIcon_W(Self: TControlTooltip; const T: TToolTipIcon);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipIcon_R(Self: TControlTooltip; var T: TToolTipIcon);
begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipInfo_R(Self: TControlTooltip; var T: TToolInfo);
begin T := Self.Info; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipUnderWnd_R(Self: TControlTooltip; var T: THandle);
begin T := Self.UnderWnd; end;

(*----------------------------------------------------------------------------*)
procedure TControlTooltipHandle_R(Self: TControlTooltip; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Procedure TControlTooltipMoveTo1_P(Self: TControlTooltip;  Control : TControl);
Begin Self.MoveTo(Control); END;

(*----------------------------------------------------------------------------*)
Procedure TControlTooltipMoveTo_P(Self: TControlTooltip;  const Point : TPoint);
Begin Self.MoveTo(Point); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlTooltip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlTooltip) do begin
    RegisterConstructor(@TControlTooltip.Create, 'Create');
        RegisterMethod(@TControlTooltip.Destroy, 'Free');

    RegisterMethod(@TControlTooltipMoveTo_P, 'MoveTo');
    RegisterMethod(@TControlTooltipMoveTo1_P, 'MoveTo1');
    RegisterPropertyHelper(@TControlTooltipHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TControlTooltipUnderWnd_R,nil,'UnderWnd');
    RegisterPropertyHelper(@TControlTooltipInfo_R,nil,'Info');
    RegisterPropertyHelper(@TControlTooltipIcon_R,@TControlTooltipIcon_W,'Icon');
    RegisterPropertyHelper(@TControlTooltipBkColor_R,@TControlTooltipBkColor_W,'BkColor');
    RegisterPropertyHelper(@TControlTooltipTextColor_R,@TControlTooltipTextColor_W,'TextColor');
    RegisterPropertyHelper(@TControlTooltipTitle_R,@TControlTooltipTitle_W,'Title');
    RegisterPropertyHelper(@TControlTooltipText_R,@TControlTooltipText_W,'Text');
    RegisterPropertyHelper(@TControlTooltipAutoHide_R,@TControlTooltipAutoHide_W,'AutoHide');
    RegisterPropertyHelper(@TControlTooltipCenterTail_R,@TControlTooltipCenterTail_W,'CenterTail');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Tooltips(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TControlTooltip(CL);
end;

 
 
{ TPSImport_Tooltips }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Tooltips.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Tooltips(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Tooltips.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Tooltips(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
