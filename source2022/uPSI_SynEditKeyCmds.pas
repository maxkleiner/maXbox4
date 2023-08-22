unit uPSI_SynEditKeyCmds;
{
  to highlander highlight might
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
  TPSImport_SynEditKeyCmds = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEditKeyStrokes(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditKeyStroke(CL: TPSPascalCompiler);
procedure SIRegister_SynEditKeyCmds(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynEditKeyCmds_Routines(S: TPSExec);
procedure RIRegister_TSynEditKeyStrokes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditKeyStroke(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditKeyCmds(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // QMenus
  Menus
  ,SynEditKeyCmds
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditKeyCmds]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditKeyStrokes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TSynEditKeyStrokes') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TSynEditKeyStrokes') do begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TSynEditKeyStroke');
    RegisterMethod('Procedure AddKey( const ACmd : TSynEditorCommand; const AKey : word; const AShift : TShiftState)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function FindCommand( Cmd : TSynEditorCommand) : integer');
    RegisterMethod('Function FindKeycode( Code : word; SS : TShiftState) : integer');
    RegisterMethod('Function FindKeycode2( Code1 : word; SS1 : TShiftState; Code2 : word; SS2 : TShiftState) : integer');
    RegisterMethod('Function FindShortcut( SC : TShortcut) : integer');
    RegisterMethod('Function FindShortcut2( SC, SC2 : TShortcut) : integer');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure ResetDefaults');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Items', 'TSynEditKeyStroke Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditKeyStroke(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TSynEditKeyStroke') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TSynEditKeyStroke') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Key', 'word', iptrw);
    RegisterProperty('Key2', 'word', iptrw);
    RegisterProperty('Shift', 'TShiftState', iptrw);
    RegisterProperty('Shift2', 'TShiftState', iptrw);
    RegisterProperty('Command', 'TSynEditorCommand', iptrw);
    RegisterProperty('ShortCut', 'TShortCut', iptrw);
    RegisterProperty('ShortCut2', 'TShortCut', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditKeyCmds(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ecNone','LongInt').SetInt( 0);
 CL.AddConstantN('ecViewCommandFirst','LongInt').SetInt( 0);
 CL.AddConstantN('ecViewCommandLast','LongInt').SetInt( 500);
 CL.AddConstantN('ecEditCommandFirst','LongInt').SetInt( 501);
 CL.AddConstantN('ecEditCommandLast','LongInt').SetInt( 1000);
 CL.AddConstantN('ecLeft','LongInt').SetInt( 1);
 CL.AddConstantN('ecRight','LongInt').SetInt( 2);
 CL.AddConstantN('ecUp','LongInt').SetInt( 3);
 CL.AddConstantN('ecDown','LongInt').SetInt( 4);
 CL.AddConstantN('ecWordLeft','LongInt').SetInt( 5);
 CL.AddConstantN('ecWordRight','LongInt').SetInt( 6);
 CL.AddConstantN('ecLineStart','LongInt').SetInt( 7);
 CL.AddConstantN('ecLineEnd','LongInt').SetInt( 8);
 CL.AddConstantN('ecPageUp','LongInt').SetInt( 9);
 CL.AddConstantN('ecPageDown','LongInt').SetInt( 10);
 CL.AddConstantN('ecPageLeft','LongInt').SetInt( 11);
 CL.AddConstantN('ecPageRight','LongInt').SetInt( 12);
 CL.AddConstantN('ecPageTop','LongInt').SetInt( 13);
 CL.AddConstantN('ecPageBottom','LongInt').SetInt( 14);
 CL.AddConstantN('ecEditorTop','LongInt').SetInt( 15);
 CL.AddConstantN('ecEditorBottom','LongInt').SetInt( 16);
 CL.AddConstantN('ecGotoXY','LongInt').SetInt( 17);
 CL.AddConstantN('ecSelection','LongInt').SetInt( 100);
 CL.AddConstantN('ecSelWord','LongInt').SetInt( 198);
 CL.AddConstantN('ecSelectAll','LongInt').SetInt( 199);
 CL.AddConstantN('ecCopy','LongInt').SetInt( 201);
 CL.AddConstantN('ecScrollUp','LongInt').SetInt( 211);
 CL.AddConstantN('ecScrollDown','LongInt').SetInt( 212);
 CL.AddConstantN('ecScrollLeft','LongInt').SetInt( 213);
 CL.AddConstantN('ecScrollRight','LongInt').SetInt( 214);
 CL.AddConstantN('ecInsertMode','LongInt').SetInt( 221);
 CL.AddConstantN('ecOverwriteMode','LongInt').SetInt( 222);
 CL.AddConstantN('ecToggleMode','LongInt').SetInt( 223);
 CL.AddConstantN('ecNormalSelect','LongInt').SetInt( 231);
 CL.AddConstantN('ecColumnSelect','LongInt').SetInt( 232);
 CL.AddConstantN('ecLineSelect','LongInt').SetInt( 233);
 CL.AddConstantN('ecMatchBracket','LongInt').SetInt( 250);
 CL.AddConstantN('ecCommentBlock','LongInt').SetInt( 251);
 CL.AddConstantN('ecGotoMarker0','LongInt').SetInt( 301);
 CL.AddConstantN('ecGotoMarker1','LongInt').SetInt( 302);
 CL.AddConstantN('ecGotoMarker2','LongInt').SetInt( 303);
 CL.AddConstantN('ecGotoMarker3','LongInt').SetInt( 304);
 CL.AddConstantN('ecGotoMarker4','LongInt').SetInt( 305);
 CL.AddConstantN('ecGotoMarker5','LongInt').SetInt( 306);
 CL.AddConstantN('ecGotoMarker6','LongInt').SetInt( 307);
 CL.AddConstantN('ecGotoMarker7','LongInt').SetInt( 308);
 CL.AddConstantN('ecGotoMarker8','LongInt').SetInt( 309);
 CL.AddConstantN('ecGotoMarker9','LongInt').SetInt( 310);
 CL.AddConstantN('ecSetMarker0','LongInt').SetInt( 351);
 CL.AddConstantN('ecSetMarker1','LongInt').SetInt( 352);
 CL.AddConstantN('ecSetMarker2','LongInt').SetInt( 353);
 CL.AddConstantN('ecSetMarker3','LongInt').SetInt( 354);
 CL.AddConstantN('ecSetMarker4','LongInt').SetInt( 355);
 CL.AddConstantN('ecSetMarker5','LongInt').SetInt( 356);
 CL.AddConstantN('ecSetMarker6','LongInt').SetInt( 357);
 CL.AddConstantN('ecSetMarker7','LongInt').SetInt( 358);
 CL.AddConstantN('ecSetMarker8','LongInt').SetInt( 359);
 CL.AddConstantN('ecSetMarker9','LongInt').SetInt( 360);
 CL.AddConstantN('ecGotFocus','LongInt').SetInt( 480);
 CL.AddConstantN('ecLostFocus','LongInt').SetInt( 481);
 CL.AddConstantN('ecContextHelp','LongInt').SetInt( 490);
 CL.AddConstantN('ecDeleteLastChar','LongInt').SetInt( 501);
 CL.AddConstantN('ecDeleteChar','LongInt').SetInt( 502);
 CL.AddConstantN('ecDeleteWord','LongInt').SetInt( 503);
 CL.AddConstantN('ecDeleteLastWord','LongInt').SetInt( 504);
 CL.AddConstantN('ecDeleteBOL','LongInt').SetInt( 505);
 CL.AddConstantN('ecDeleteEOL','LongInt').SetInt( 506);
 CL.AddConstantN('ecDeleteLine','LongInt').SetInt( 507);
 CL.AddConstantN('ecClearAll','LongInt').SetInt( 508);
 CL.AddConstantN('ecLineBreak','LongInt').SetInt( 509);
 CL.AddConstantN('ecInsertLine','LongInt').SetInt( 510);
 CL.AddConstantN('ecChar','LongInt').SetInt( 511);
 CL.AddConstantN('ecImeStr','LongInt').SetInt( 550);
 CL.AddConstantN('ecUndo','LongInt').SetInt( 601);
 CL.AddConstantN('ecRedo','LongInt').SetInt( 602);
 CL.AddConstantN('ecCut','LongInt').SetInt( 603);
 CL.AddConstantN('ecPaste','LongInt').SetInt( 604);
 CL.AddConstantN('ecBlockIndent','LongInt').SetInt( 610);
 CL.AddConstantN('ecBlockUnindent','LongInt').SetInt( 611);
 CL.AddConstantN('ecTab','LongInt').SetInt( 612);
 CL.AddConstantN('ecShiftTab','LongInt').SetInt( 613);
 CL.AddConstantN('ecAutoCompletion','LongInt').SetInt( 650);
 CL.AddConstantN('ecUpperCase','LongInt').SetInt( 620);
 CL.AddConstantN('ecLowerCase','LongInt').SetInt( 621);
 CL.AddConstantN('ecToggleCase','LongInt').SetInt( 622);
 CL.AddConstantN('ecTitleCase','LongInt').SetInt( 623);
 CL.AddConstantN('ecUpperCaseBlock','LongInt').SetInt( 625);
 CL.AddConstantN('ecLowerCaseBlock','LongInt').SetInt( 626);
 CL.AddConstantN('ecToggleCaseBlock','LongInt').SetInt( 627);
 CL.AddConstantN('ecString','LongInt').SetInt( 630);
 CL.AddConstantN('ecUserFirst','LongInt').SetInt( 1001);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESynKeyError');
  CL.AddTypeS('TSynEditorCommand', 'word');
  SIRegister_TSynEditKeyStroke(CL);
  SIRegister_TSynEditKeyStrokes(CL);
 CL.AddDelphiFunction('Function EditorCommandToDescrString( Cmd : TSynEditorCommand) : string');
 CL.AddDelphiFunction('Function EditorCommandToCodeString( Cmd : TSynEditorCommand) : string');
 CL.AddDelphiFunction('Procedure GetEditorCommandValues( Proc : TGetStrProc)');
 CL.AddDelphiFunction('Procedure GetEditorCommandExtended( Proc : TGetStrProc)');
 CL.AddDelphiFunction('Function IdentToEditorCommand( const Ident : string; var Cmd : longint) : boolean');
 CL.AddDelphiFunction('Function EditorCommandToIdent( Cmd : longint; var Ident : string) : boolean');
 CL.AddDelphiFunction('Function ConvertCodeStringToExtended( AString : String) : String');
 CL.AddDelphiFunction('Function ConvertExtendedToCodeString( AString : String) : String');
 CL.AddDelphiFunction('Function ConvertExtendedToCommand( AString : String) : TSynEditorCommand');
 CL.AddDelphiFunction('Function ConvertCodeStringToCommand( AString : String) : TSynEditorCommand');
 CL.AddDelphiFunction('Function IndexToEditorCommand( const AIndex : Integer) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokesItems_W(Self: TSynEditKeyStrokes; const T: TSynEditKeyStroke; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokesItems_R(Self: TSynEditKeyStrokes; var T: TSynEditKeyStroke; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShortCut2_W(Self: TSynEditKeyStroke; const T: TShortCut);
begin Self.ShortCut2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShortCut2_R(Self: TSynEditKeyStroke; var T: TShortCut);
begin T := Self.ShortCut2; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShortCut_W(Self: TSynEditKeyStroke; const T: TShortCut);
begin Self.ShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShortCut_R(Self: TSynEditKeyStroke; var T: TShortCut);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeCommand_W(Self: TSynEditKeyStroke; const T: TSynEditorCommand);
begin Self.Command := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeCommand_R(Self: TSynEditKeyStroke; var T: TSynEditorCommand);
begin T := Self.Command; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShift2_W(Self: TSynEditKeyStroke; const T: TShiftState);
begin Self.Shift2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShift2_R(Self: TSynEditKeyStroke; var T: TShiftState);
begin T := Self.Shift2; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShift_W(Self: TSynEditKeyStroke; const T: TShiftState);
begin Self.Shift := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeShift_R(Self: TSynEditKeyStroke; var T: TShiftState);
begin T := Self.Shift; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeKey2_W(Self: TSynEditKeyStroke; const T: word);
begin Self.Key2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeKey2_R(Self: TSynEditKeyStroke; var T: word);
begin T := Self.Key2; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeKey_W(Self: TSynEditKeyStroke; const T: word);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditKeyStrokeKey_R(Self: TSynEditKeyStroke; var T: word);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditKeyCmds_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EditorCommandToDescrString, 'EditorCommandToDescrString', cdRegister);
 S.RegisterDelphiFunction(@EditorCommandToCodeString, 'EditorCommandToCodeString', cdRegister);
 S.RegisterDelphiFunction(@GetEditorCommandValues, 'GetEditorCommandValues', cdRegister);
 S.RegisterDelphiFunction(@GetEditorCommandExtended, 'GetEditorCommandExtended', cdRegister);
 S.RegisterDelphiFunction(@IdentToEditorCommand, 'IdentToEditorCommand', cdRegister);
 S.RegisterDelphiFunction(@EditorCommandToIdent, 'EditorCommandToIdent', cdRegister);
 S.RegisterDelphiFunction(@ConvertCodeStringToExtended, 'ConvertCodeStringToExtended', cdRegister);
 S.RegisterDelphiFunction(@ConvertExtendedToCodeString, 'ConvertExtendedToCodeString', cdRegister);
 S.RegisterDelphiFunction(@ConvertExtendedToCommand, 'ConvertExtendedToCommand', cdRegister);
 S.RegisterDelphiFunction(@ConvertCodeStringToCommand, 'ConvertCodeStringToCommand', cdRegister);
 S.RegisterDelphiFunction(@IndexToEditorCommand, 'IndexToEditorCommand', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditKeyStrokes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditKeyStrokes) do
  begin
    RegisterConstructor(@TSynEditKeyStrokes.Create, 'Create');
    RegisterMethod(@TSynEditKeyStrokes.Add, 'Add');
    RegisterMethod(@TSynEditKeyStrokes.AddKey, 'AddKey');
    RegisterMethod(@TSynEditKeyStrokes.Assign, 'Assign');
    RegisterMethod(@TSynEditKeyStrokes.FindCommand, 'FindCommand');
    RegisterMethod(@TSynEditKeyStrokes.FindKeycode, 'FindKeycode');
    RegisterMethod(@TSynEditKeyStrokes.FindKeycode2, 'FindKeycode2');
    RegisterMethod(@TSynEditKeyStrokes.FindShortcut, 'FindShortcut');
    RegisterMethod(@TSynEditKeyStrokes.FindShortcut2, 'FindShortcut2');
    RegisterMethod(@TSynEditKeyStrokes.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TSynEditKeyStrokes.ResetDefaults, 'ResetDefaults');
    RegisterMethod(@TSynEditKeyStrokes.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TSynEditKeyStrokesItems_R,@TSynEditKeyStrokesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditKeyStroke(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditKeyStroke) do
  begin
    RegisterMethod(@TSynEditKeyStroke.Assign, 'Assign');
    RegisterMethod(@TSynEditKeyStroke.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TSynEditKeyStroke.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TSynEditKeyStrokeKey_R,@TSynEditKeyStrokeKey_W,'Key');
    RegisterPropertyHelper(@TSynEditKeyStrokeKey2_R,@TSynEditKeyStrokeKey2_W,'Key2');
    RegisterPropertyHelper(@TSynEditKeyStrokeShift_R,@TSynEditKeyStrokeShift_W,'Shift');
    RegisterPropertyHelper(@TSynEditKeyStrokeShift2_R,@TSynEditKeyStrokeShift2_W,'Shift2');
    RegisterPropertyHelper(@TSynEditKeyStrokeCommand_R,@TSynEditKeyStrokeCommand_W,'Command');
    RegisterPropertyHelper(@TSynEditKeyStrokeShortCut_R,@TSynEditKeyStrokeShortCut_W,'ShortCut');
    RegisterPropertyHelper(@TSynEditKeyStrokeShortCut2_R,@TSynEditKeyStrokeShortCut2_W,'ShortCut2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditKeyCmds(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESynKeyError) do
  RIRegister_TSynEditKeyStroke(CL);
  RIRegister_TSynEditKeyStrokes(CL);
end;

 
 
{ TPSImport_SynEditKeyCmds }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditKeyCmds.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditKeyCmds(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditKeyCmds.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditKeyCmds(ri);
  RIRegister_SynEditKeyCmds_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
