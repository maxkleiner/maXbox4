unit uPSI_StDbBarC;
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
  TPSImport_StDbBarC = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStDbBarCode(CL: TPSPascalCompiler);
procedure SIRegister_StDbBarC(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStDbBarCode(CL: TPSRuntimeClassImporter);
procedure RIRegister_StDbBarC(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ClipBrd
  ,Controls
  ,Graphics
  ,Messages
  ,Db
  ,DbCtrls
  ,DbTables
  ,StConst
  ,StBarc
  ,StDbBarC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDbBarC]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDbBarCode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStBarCode', 'TStDbBarCode') do
  with CL.AddClassN(CL.FindClass('TStBarCode'),'TStDbBarCode') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StDbBarC(CL: TPSPascalCompiler);
begin
  SIRegister_TStDbBarCode(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStDbBarCodeDataSource_W(Self: TStDbBarCode; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbBarCodeDataSource_R(Self: TStDbBarCode; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TStDbBarCodeDataField_W(Self: TStDbBarCode; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbBarCodeDataField_R(Self: TStDbBarCode; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDbBarCode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDbBarCode) do
  begin
    RegisterConstructor(@TStDbBarCode.Create, 'Create');
    RegisterPropertyHelper(@TStDbBarCodeDataField_R,@TStDbBarCodeDataField_W,'DataField');
    RegisterPropertyHelper(@TStDbBarCodeDataSource_R,@TStDbBarCodeDataSource_W,'DataSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StDbBarC(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDbBarCode(CL);
end;

 
 
{ TPSImport_StDbBarC }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDbBarC.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDbBarC(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDbBarC.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StDbBarC(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
