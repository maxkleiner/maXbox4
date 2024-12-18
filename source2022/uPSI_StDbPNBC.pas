unit uPSI_StDbPNBC;
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
  TPSImport_StDbPNBC = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStDbPNBarCode(CL: TPSPascalCompiler);
procedure SIRegister_StDbPNBC(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStDbPNBarCode(CL: TPSRuntimeClassImporter);
procedure RIRegister_StDbPNBC(CL: TPSRuntimeClassImporter);

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
  ,StBarPN
  ,StDbPNBC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDbPNBC]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDbPNBarCode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStPNBarCode', 'TStDbPNBarCode') do
  with CL.AddClassN(CL.FindClass('TStPNBarCode'),'TStDbPNBarCode') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StDbPNBC(CL: TPSPascalCompiler);
begin
  SIRegister_TStDbPNBarCode(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStDbPNBarCodeDataSource_W(Self: TStDbPNBarCode; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbPNBarCodeDataSource_R(Self: TStDbPNBarCode; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TStDbPNBarCodeDataField_W(Self: TStDbPNBarCode; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbPNBarCodeDataField_R(Self: TStDbPNBarCode; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDbPNBarCode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDbPNBarCode) do
  begin
    RegisterConstructor(@TStDbPNBarCode.Create, 'Create');
    RegisterPropertyHelper(@TStDbPNBarCodeDataField_R,@TStDbPNBarCodeDataField_W,'DataField');
    RegisterPropertyHelper(@TStDbPNBarCodeDataSource_R,@TStDbPNBarCodeDataSource_W,'DataSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StDbPNBC(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDbPNBarCode(CL);
end;

 
 
{ TPSImport_StDbPNBC }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDbPNBC.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDbPNBC(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDbPNBC.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StDbPNBC(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
