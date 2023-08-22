unit uPSI_KEditCommon;
{
base and type class   - retype
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
  TPSImport_KEditCommon = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKEditKeyMapping(CL: TPSPascalCompiler);
procedure SIRegister_KEditCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KEditCommon_Routines(S: TPSExec);
procedure RIRegister_TKEditKeyMapping(CL: TPSRuntimeClassImporter);
procedure RIRegister_KEditCommon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { LCLType
  ,LCLIntf
  ,LCLProc
  ,LResources }
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,KEditCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KEditCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKEditKeyMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKEditKeyMapping') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKEditKeyMapping') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TKEditKeyMapping)');
    RegisterMethod('Procedure AddKey( Command : TKEditCommand; Key : Word; Shift : TShiftState)');
    RegisterMethod('Function EmptyMap : TKEditCommandAssignment');
    RegisterMethod('Function FindCommand( AKey : Word; AShift : TShiftState) : TKEditCommand');
    RegisterProperty('Assignment', 'TKEditCommandAssignment Integer', iptr);
    RegisterProperty('Key', 'TKEditKey TKEditCommand', iptrw);
    RegisterProperty('Map', 'TKEditCommandMap', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KEditCommon(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cCharMappingSize','LongInt').SetInt( 256);
 (* CL.AddTypeS('TKEditCommand', '( ecNone, ecLeft, ecRight, ecUp, ecDown, ecLine'
   +'Start, ecLineEnd, ecPageUp, ecPageDown, ecPageLeft, ecPageRight, ecPageTop'
   +', ecPageBottom, ecEditorTop, ecEditorBottom, ecGotoXY, ecSelLeft, ecSelRig'
   +'ht, ecSelUp, ecSelDown, ecSelLineStart, ecSelLineEnd, ecSelPageUp, ecSelPa'
   +'geDown, ecSelPageLeft, ecSelPageRight, ecSelPageTop, ecSelPageBottom, ecSe'
   +'lEditorTop, ecSelEditorBottom, ecSelGotoXY, ecScrollUp, ecScrollDown, ecSc'
   +'rollLeft, ecScrollRight, ecScrollCenter, ecUndo, ecRedo, ecCopy, ecCut, ec'
   +'Paste, ecInsertChar, ecInsertDigits, ecInsertString, ecInsertNewLine, ecDe'
   +'leteLastChar, ecDeleteChar, ecDeleteBOL, ecDeleteEOL, ecDeleteLine, ecSele'
   +'ctAll, ecClearAll, ecClearIndexSelection, ecClearSelection, ecSearch, ecRe'
   +'place, ecInsertMode, ecOverwriteMode, ecToggleMode, ecGotFocus, ecLostFocu'
   +'s )'); *)

   CL.AddTypeS('TKEditKey', 'record key:word; shift: TShiftState; end;');
    CL.AddTypeS('TKEditCommand','(ecNonek, ecLeftk, ecRightk, ecUpk, ecDownk, ecLineStartk, ecLineEndk, ecPageUpk,'+
    'ecPageDownk,  ecPageLeftk,  ecPageRightk, ecPageTopk,  ecPageBottomk,  ecEditorTopk,  ecEditorBottomk,'+
    { Move caret to specific coordinates, Data = ^TPoint }
    'ecGotoXYk,  ecSelLeftk, ecSelRightk, ecSelUpk, ecSelDownk, ecSelLineStartk, ecSelLineEndk, ecSelPageUpk,'+
    { Move caret down one page, affecting selection }
    'ecSelPageDownk, ecSelPageLeftk, ecSelPageRightk, ecSelPageTopk, ecSelPageBottomk, ecSelEditorTopk, ecSelEditorBottomk,'+
    'ecSelGotoXYk, ecScrollUpk, ecScrollDownk,  ecScrollLeftk,  ecScrollRightk, ecScrollCenterk, ecUndok,'+
    'ecRedok, ecCopyk, ecCutk, ecPastek,ecInsertChark,ecInsertDigitsk,ecInsertStringk,ecInsertNewLinek,ecDeleteLastChark,'+
    'ecDeleteChark,ecDeleteBOLk,ecDeleteEOLk,ecDeleteLinek,ecSelectAllk,ecClearAllk,ecClearIndexSelectionk,'+
    'ecClearSelectionk,ecSearchk,ecReplacek,ecInsertModek,ecOverwriteModek,ecToggleModek,ecGotFocusk,ecLostFocusk)');
   CL.AddTypeS('TKEditDisabledDrawStyle', '( eddBright, eddGrayed, eddNormal )');
  CL.AddTypeS('TKEditKey', 'record Key : Word; Shift : TShiftState; end');
  CL.AddTypeS('TKEditCommandAssignment', 'record Key : TKEditKey; Command : TKEditCommand; end');
  CL.AddTypeS('TKEditCommandMap', 'array of TKEditCommandAssignment');

 { CL.AddTypeS('TKEditDisabledDrawStyle', '( eddBright, eddGrayed, eddNormal )'); }
  //CL.AddTypeS('TKEditKey', 'record Key : Word; Shift : TShiftState; end');
  //CL.AddTypeS('TKEditCommandAssignment', 'record Key : TKEditKey; Command : TKEditCommand; end');
  //CL.AddTypeS('TKEditCommandMap', 'array of TKEditCommandAssignment');
  //}

  //CL.AddTypeS('TKEditDropFilesEvent', 'Procedure ( Sender : TObject; X, Y : int'
   //+'eger; Files : TStrings)');
  SIRegister_TKEditKeyMapping(CL);
  CL.AddTypeS('TKEditCharMapping', 'array of AnsiChar');
  //CL.AddTypeS('PKEditCharMapping', '^TKEditCharMapping // will not work');
  //CL.AddTypeS('TKEditOption', '( eoDropFiles, eoGroupUndo, eoUndoAfterSave, eoS'
   //+'howFormatting, eoWantTab )');
  //CL.AddTypeS('TKEditOptions', 'set of TKEditOption');
  CL.AddTypeS('TKEditReplaceAction', '( eraCancel, eraYes, eraNo, eraAll )');
  CL.AddTypeS('TKEditReplaceTextEvent', 'Procedure ( Sender : TObject; const Te'
   +'xtToFind, TextToReplace : string; var Action : TKEditReplaceAction)');
  CL.AddTypeS('TKEditSearchError', '( eseOk, eseNoDigitsFind, eseNoDigitsReplace, eseNoMatch )');
  CL.AddTypeS('TKEditSearchOption', '( esoAll, esoBackwards, esoEntireScope, es'
   +'oFirstSearch, esoMatchCase, esoPrompt, esoSelectedOnly, esoTreatAsDigits, esoWereDigits )');
  CL.AddTypeS('TKEditSearchOptions', 'set of TKEditSearchOption');
  CL.AddTypeS('TKEditSearchData', 'record ErrorReason : TKEditSearchError; Opti'
   +'ons : TKEditSearchOptions; SelStart: integer; SelEnd : Integer; TextToFind: string; TextToReplace : string; end');
 // CL.AddTypeS('PKEditSearchData', '^TKEditSearchData // will not work');
 //CL.AddConstantN('cEditDisabledDrawStyleDef','').SetString( eddBright);
 CL.AddDelphiFunction('Function CreateDefaultKeyMapping : TKEditKeyMapping');
 CL.AddDelphiFunction('Function DefaultCharMapping : TKEditCharMapping');
 CL.AddDelphiFunction('Function DefaultSearchData : TKEditSearchData');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKEditKeyMappingMap_R(Self: TKEditKeyMapping; var T: TKEditCommandMap);
begin T := Self.Map; end;

(*----------------------------------------------------------------------------*)
procedure TKEditKeyMappingKey_W(Self: TKEditKeyMapping; const T: TKEditKey; const t1: TKEditCommand);
begin Self.Key[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKEditKeyMappingKey_R(Self: TKEditKeyMapping; var T: TKEditKey; const t1: TKEditCommand);
begin T := Self.Key[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKEditKeyMappingAssignment_R(Self: TKEditKeyMapping; var T: TKEditCommandAssignment; const t1: Integer);
begin T := Self.Assignment[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KEditCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateDefaultKeyMapping, 'CreateDefaultKeyMapping', cdRegister);
 S.RegisterDelphiFunction(@DefaultCharMapping, 'DefaultCharMapping', cdRegister);
 S.RegisterDelphiFunction(@DefaultSearchData, 'DefaultSearchData', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKEditKeyMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKEditKeyMapping) do
  begin
    RegisterConstructor(@TKEditKeyMapping.Create, 'Create');
    RegisterVirtualMethod(@TKEditKeyMapping.Assign, 'Assign');
    RegisterMethod(@TKEditKeyMapping.AddKey, 'AddKey');
    RegisterMethod(@TKEditKeyMapping.EmptyMap, 'EmptyMap');
    RegisterMethod(@TKEditKeyMapping.FindCommand, 'FindCommand');
    RegisterPropertyHelper(@TKEditKeyMappingAssignment_R,nil,'Assignment');
    RegisterPropertyHelper(@TKEditKeyMappingKey_R,@TKEditKeyMappingKey_W,'Key');
    RegisterPropertyHelper(@TKEditKeyMappingMap_R,nil,'Map');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KEditCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TKEditKeyMapping(CL);
end;

 
 
{ TPSImport_KEditCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KEditCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KEditCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KEditCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KEditCommon(ri);
  RIRegister_KEditCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
