unit uPSI_CPortEsc;
{
 for arduino com, free method
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
  TPSImport_CPortEsc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TEscapeCodesVT100(CL: TPSPascalCompiler);
procedure SIRegister_TEscapeCodesVT52(CL: TPSPascalCompiler);
procedure SIRegister_TEscapeCodes(CL: TPSPascalCompiler);
procedure SIRegister_CPortEsc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TEscapeCodesVT100(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEscapeCodesVT52(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEscapeCodes(CL: TPSRuntimeClassImporter);
procedure RIRegister_CPortEsc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   CPortEsc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CPortEsc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TEscapeCodesVT100(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEscapeCodes', 'TEscapeCodesVT100') do
  with CL.AddClassN(CL.FindClass('TEscapeCodes'),'TEscapeCodesVT100') do begin
    RegisterMethod('Function ProcessChar( Ch : Char) : TEscapeResult');
    RegisterMethod('Function EscCodeToStr( Code : TEscapeCode; AParams : TStrings) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEscapeCodesVT52(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEscapeCodes', 'TEscapeCodesVT52') do
  with CL.AddClassN(CL.FindClass('TEscapeCodes'),'TEscapeCodesVT52') do begin
    RegisterMethod('Function ProcessChar( Ch : Char) : TEscapeResult');
    RegisterMethod('Function EscCodeToStr( Code : TEscapeCode; AParams : TStrings) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEscapeCodes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TEscapeCodes') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TEscapeCodes') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ProcessChar( Ch : Char) : TEscapeResult');
    RegisterMethod('Function EscCodeToStr( Code : TEscapeCode; AParams : TStrings) : string');
    RegisterMethod('Function GetParam( Num : Integer; AParams : TStrings) : Integer');
    RegisterProperty('Data', 'string', iptr);
    RegisterProperty('Code', 'TEscapeCode', iptr);
    RegisterProperty('character', 'Char', iptr);
    RegisterProperty('Params', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CPortEsc(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEscapeResult', '( erChar, erCode, erNothing )');
  CL.AddTypeS('TEscapeCode', '( ecUnknown, ecNotCompleted, ecCursorUp, ecCursor'
   +'Down, ecCursorLeft, ecCursorRight, ecCursorHome, ecCursorMove, ecReverseLi'
   +'neFeed, ecAppCursorLeft, ecAppCursorRight, ecAppCursorUp, ecAppCursorDown,'
   +' ecEraseLineFrom, ecEraseScreenFrom, ecEraseLine, ecEraseScreen, ecSetTab,'
   +' ecClearTab, ecClearAllTabs, ecIdentify, ecIdentResponse, ecQueryDevice, e'
   +'cReportDeviceOK, ecReportDeviceFailure, ecQueryCursorPos, ecReportCursorPo'
   +'s, ecAttributes, ecSetMode, ecResetMode, ecReset, ecSaveCaretAndAttr, ecRe'
   +'storeCaretAndAttr, ecSaveCaret, ecRestoreCaret, ecTest )');
  SIRegister_TEscapeCodes(CL);
  SIRegister_TEscapeCodesVT52(CL);
  SIRegister_TEscapeCodesVT100(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TEscapeCodesParams_R(Self: TEscapeCodes; var T: TStrings);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TEscapeCodescharacter_R(Self: TEscapeCodes; var T: Char);
begin T := Self.character; end;

(*----------------------------------------------------------------------------*)
procedure TEscapeCodesCode_R(Self: TEscapeCodes; var T: TEscapeCode);
begin T := Self.Code; end;

(*----------------------------------------------------------------------------*)
procedure TEscapeCodesData_R(Self: TEscapeCodes; var T: string);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEscapeCodesVT100(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEscapeCodesVT100) do
  begin
    RegisterMethod(@TEscapeCodesVT100.ProcessChar, 'ProcessChar');
    RegisterMethod(@TEscapeCodesVT100.EscCodeToStr, 'EscCodeToStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEscapeCodesVT52(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEscapeCodesVT52) do begin
    RegisterMethod(@TEscapeCodesVT52.ProcessChar, 'ProcessChar');
    RegisterMethod(@TEscapeCodesVT52.EscCodeToStr, 'EscCodeToStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEscapeCodes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEscapeCodes) do begin
    RegisterConstructor(@TEscapeCodes.Create, 'Create');
   RegisterMethod(@TEscapeCodes.Destroy, 'Free');
    //RegisterVirtualAbstractMethod(@TEscapeCodes, @!.ProcessChar, 'ProcessChar');
    //RegisterVirtualAbstractMethod(@TEscapeCodes, @!.EscCodeToStr, 'EscCodeToStr');
    RegisterMethod(@TEscapeCodes.GetParam, 'GetParam');
    RegisterPropertyHelper(@TEscapeCodesData_R,nil,'Data');
    RegisterPropertyHelper(@TEscapeCodesCode_R,nil,'Code');
    RegisterPropertyHelper(@TEscapeCodescharacter_R,nil,'character');
    RegisterPropertyHelper(@TEscapeCodesParams_R,nil,'Params');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortEsc(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TEscapeCodes(CL);
  RIRegister_TEscapeCodesVT52(CL);
  RIRegister_TEscapeCodesVT100(CL);
end;

 
 
{ TPSImport_CPortEsc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortEsc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CPortEsc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortEsc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CPortEsc(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
