unit uPSI_BarCodeScaner;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_BarCodeScaner = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBarCodeScaner(CL: TPSPascalCompiler);
procedure SIRegister_BarCodeScaner(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BarCodeScaner_Routines(S: TPSExec);
procedure RIRegister_TBarCodeScaner(CL: TPSRuntimeClassImporter);
procedure RIRegister_BarCodeScaner(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // Windows
  //,Messages
  //,Graphics
  //,Controls
  //,Forms
  //Dialogs
  CPort
  ,BarCodeScaner
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BarCodeScaner]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBarCodeScaner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComPort', 'TBarCodeScaner') do
  with CL.AddClassN(CL.FindClass('TCustomComPort'),'TBarCodeScaner') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('TermChar', 'Char', iptrw);
    RegisterProperty('OnBarCode', 'TBarCodeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BarCodeScaner(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBarCodeEvent', 'Procedure ( var BarCode : String)');
  SIRegister_TBarCodeScaner(CL);
 CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBarCodeScanerOnBarCode_W(Self: TBarCodeScaner; const T: TBarCodeEvent);
begin Self.OnBarCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBarCodeScanerOnBarCode_R(Self: TBarCodeScaner; var T: TBarCodeEvent);
begin T := Self.OnBarCode; end;

(*----------------------------------------------------------------------------*)
procedure TBarCodeScanerTermChar_W(Self: TBarCodeScaner; const T: Char);
begin Self.TermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TBarCodeScanerTermChar_R(Self: TBarCodeScaner; var T: Char);
begin T := Self.TermChar; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BarCodeScaner_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBarCodeScaner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBarCodeScaner) do
  begin
    RegisterConstructor(@TBarCodeScaner.Create, 'Create');
    RegisterPropertyHelper(@TBarCodeScanerTermChar_R,@TBarCodeScanerTermChar_W,'TermChar');
    RegisterPropertyHelper(@TBarCodeScanerOnBarCode_R,@TBarCodeScanerOnBarCode_W,'OnBarCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BarCodeScaner(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBarCodeScaner(CL);
end;

 
 
{ TPSImport_BarCodeScaner }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BarCodeScaner.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BarCodeScaner(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BarCodeScaner.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BarCodeScaner(ri);
  RIRegister_BarCodeScaner_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
