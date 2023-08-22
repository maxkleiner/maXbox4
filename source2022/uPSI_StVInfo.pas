unit uPSI_StVInfo;
{
  version vision
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
  TPSImport_StVInfo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStVersionInfo(CL: TPSPascalCompiler);
procedure SIRegister_TStCustomVersionInfo(CL: TPSPascalCompiler);
procedure SIRegister_StVInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStVersionInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStCustomVersionInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_StVInfo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StConst
  ,StVInfo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StVInfo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStVersionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStCustomVersionInfo', 'TStVersionInfo') do
  with CL.AddClassN(CL.FindClass('TStCustomVersionInfo'),'TStVersionInfo') do begin
    RegisterPublishedProperties;
      RegisterProperty('FileName', 'string', iptrw);
      RegisterProperty('FileDescription', 'string', iptrw);
   // property FileDescription;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStCustomVersionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStCustomVersionInfo') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStCustomVersionInfo') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function GetKeyValue( const Key : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StVInfo(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('STVERMAJOR','LongInt').SetInt( 0);
 CL.AddConstantN('STVERMINOR','LongInt').SetInt( 1);
 CL.AddConstantN('STVERBUILD','LongInt').SetInt( 2);
 CL.AddConstantN('STVERRELEASE','LongInt').SetInt( 3);
  //CL.AddTypeS('PVerTranslation', '^TVerTranslation // will not work');
  CL.AddTypeS('TVerTranslation', 'record Language : Word; CharSet : Word; end');
  SIRegister_TStCustomVersionInfo(CL);
  SIRegister_TStVersionInfo(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TStVersionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStVersionInfo) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStCustomVersionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStCustomVersionInfo) do begin
    RegisterConstructor(@TStCustomVersionInfo.Create, 'Create');
    RegisterMethod(@TStCustomVersionInfo.Destroy, 'Free');
    RegisterMethod(@TStCustomVersionInfo.GetKeyValue, 'GetKeyValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StVInfo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStCustomVersionInfo(CL);
  RIRegister_TStVersionInfo(CL);
end;

 
 
{ TPSImport_StVInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StVInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StVInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StVInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StVInfo(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
