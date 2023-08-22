unit uPSI_CmnFunc;
{
   add to two  inno setup
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
  TPSImport_CmnFunc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWindowDisabler(CL: TPSPascalCompiler);
procedure SIRegister_CmnFunc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CmnFunc_Routines(S: TPSExec);
procedure RIRegister_TWindowDisabler(CL: TPSRuntimeClassImporter);
procedure RIRegister_CmnFunc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Graphics
  ,Controls
  ,StdCtrls
  ,CmnFunc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CmnFunc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWindowDisabler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TWindowDisabler') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TWindowDisabler') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CmnFunc(CL: TPSPascalCompiler);
begin
  SIRegister_TWindowDisabler(CL);
  CL.AddTypeS('TMsgBoxType', '( mbInformation, mbConfirmation, mbError, mbCriticalError )');
  CL.AddTypeS('TMsgBoxCallbackFunc', 'procedure(const Flags: LongInt; const After: Boolean; const Param: LongInt);');

 //TMsgBoxCallbackFunc = procedure(const Flags: LongInt; const After: Boolean; const Param: LongInt);

 CL.AddDelphiFunction('Procedure UpdateHorizontalExtent( const ListBox : TCustomListBox)');
 CL.AddDelphiFunction('Function MinimizePathName( const Filename : String; const Font : TFont; MaxLen : Integer) : String');
 CL.AddDelphiFunction('Function AppMessageBox( const Text, Caption : PChar; Flags : Longint) : Integer');
 CL.AddDelphiFunction('Function MsgBoxP( const Text, Caption : PChar; const Typ : TMsgBoxType; const Buttons : Cardinal) : Integer');
 CL.AddDelphiFunction('Function inMsgBox( const Text, Caption : String; const Typ : TMsgBoxType; const Buttons : Cardinal) : Integer');
 CL.AddDelphiFunction('Function MsgBoxFmt( const Text : String; const Args : array of const; const Caption : String; const Typ : TMsgBoxType; const Buttons : Cardinal) : Integer');
 CL.AddDelphiFunction('Procedure ReactivateTopWindow');
 CL.AddDelphiFunction('Procedure SetMessageBoxCaption( const Typ : TMsgBoxType; const NewCaption : PChar)');
 CL.AddDelphiFunction('Procedure SetMessageBoxRightToLeft( const ARightToLeft : Boolean)');
 CL.AddDelphiFunction('Procedure SetMessageBoxCallbackFunc( const AFunc : TMsgBoxCallbackFunc; const AParam : LongInt)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_CmnFunc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UpdateHorizontalExtent, 'UpdateHorizontalExtent', cdRegister);
 S.RegisterDelphiFunction(@MinimizePathName, 'MinimizePathName', cdRegister);
 S.RegisterDelphiFunction(@AppMessageBox, 'AppMessageBox', cdRegister);
 S.RegisterDelphiFunction(@MsgBoxP, 'MsgBoxP', cdRegister);
 S.RegisterDelphiFunction(@MsgBox, 'inMsgBox', cdRegister);
 S.RegisterDelphiFunction(@MsgBoxFmt, 'MsgBoxFmt', cdRegister);
 S.RegisterDelphiFunction(@ReactivateTopWindow, 'ReactivateTopWindow', cdRegister);
 S.RegisterDelphiFunction(@SetMessageBoxCaption, 'SetMessageBoxCaption', cdRegister);
 S.RegisterDelphiFunction(@SetMessageBoxRightToLeft, 'SetMessageBoxRightToLeft', cdRegister);
 S.RegisterDelphiFunction(@SetMessageBoxCallbackFunc, 'SetMessageBoxCallbackFunc', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWindowDisabler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWindowDisabler) do
  begin
    RegisterConstructor(@TWindowDisabler.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CmnFunc(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWindowDisabler(CL);
end;

 
 
{ TPSImport_CmnFunc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmnFunc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CmnFunc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmnFunc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CmnFunc(ri);
  RIRegister_CmnFunc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
