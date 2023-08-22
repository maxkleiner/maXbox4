unit uPSI_simplecomport;
{
   from async pro
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
  TPSImport_simplecomport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleComPort(CL: TPSPascalCompiler);
procedure SIRegister_simplecomport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimpleComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_simplecomport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,AfComPortCore
  ,simplecomport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_simplecomport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSimpleComPort') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSimpleComPort') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Open( PortNumber : Integer; const Parameters : String)');
    RegisterMethod('Procedure WriteString( const S : String)');
    RegisterMethod('Procedure ReadString( var S : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_simplecomport(CL: TPSPascalCompiler);
begin
  SIRegister_TSimpleComPort(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleComPort) do begin
    RegisterConstructor(@TSimpleComPort.Create, 'Create');
    RegisterMethod(@TSimpleComPort.Destroy, 'Free');
    RegisterMethod(@TSimpleComPort.Open, 'Open');
    RegisterMethod(@TSimpleComPort.WriteString, 'WriteString');
    RegisterMethod(@TSimpleComPort.ReadString, 'ReadString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_simplecomport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleComPort(CL);
end;

 
 
{ TPSImport_simplecomport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_simplecomport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_simplecomport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_simplecomport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_simplecomport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
