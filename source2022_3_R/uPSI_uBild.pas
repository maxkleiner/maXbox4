unit uPSI_uBild;
{
stagano 4

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
  TPSImport_uBild = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBild(CL: TPSPascalCompiler);
procedure SIRegister_uBild(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBild(CL: TPSRuntimeClassImporter);
procedure RIRegister_uBild(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   graphics
  ,uBild
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uBild]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBild(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBitmap', 'TBild') do
  with CL.AddClassN(CL.FindClass('TBitmap'),'TBild') do begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Procedure FirstZeile');
    RegisterMethod('Procedure NextZeile');
    RegisterMethod('Procedure SetAktZeile');
    RegisterMethod('Procedure First');
    RegisterMethod('Procedure Next');
    RegisterMethod('Function GetBreite : integer');
    RegisterMethod('Function GetHoehe : integer');
    RegisterMethod('Function GetZeilenEnde : integer');
    RegisterMethod('Function GetAktPos : integer');
    RegisterMethod('Function IsLastZeile : boolean');
    RegisterMethod('Procedure SetBitNum( bn : integer)');
    RegisterMethod('Function GetBitNum : integer');
    RegisterMethod('Procedure PutByte( b : byte)');
    RegisterMethod('Function GetByte : byte');
    RegisterMethod('Procedure Load( Dateiname : string)');
    RegisterMethod('Procedure Store( Dateiname : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uBild(CL: TPSPascalCompiler);
begin
  SIRegister_TBild(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TBild(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBild) do
  begin
    RegisterVirtualMethod(@TBild.Init, 'Init');
    RegisterVirtualMethod(@TBild.FirstZeile, 'FirstZeile');
    RegisterVirtualMethod(@TBild.NextZeile, 'NextZeile');
    RegisterVirtualMethod(@TBild.SetAktZeile, 'SetAktZeile');
    RegisterVirtualMethod(@TBild.First, 'First');
    RegisterVirtualMethod(@TBild.Next, 'Next');
    RegisterVirtualMethod(@TBild.GetBreite, 'GetBreite');
    RegisterVirtualMethod(@TBild.GetHoehe, 'GetHoehe');
    RegisterVirtualMethod(@TBild.GetZeilenEnde, 'GetZeilenEnde');
    RegisterVirtualMethod(@TBild.GetAktPos, 'GetAktPos');
    RegisterVirtualMethod(@TBild.IsLastZeile, 'IsLastZeile');
    RegisterVirtualMethod(@TBild.SetBitNum, 'SetBitNum');
    RegisterVirtualMethod(@TBild.GetBitNum, 'GetBitNum');
    RegisterVirtualMethod(@TBild.PutByte, 'PutByte');
    RegisterMethod(@TBild.GetByte, 'GetByte');
    RegisterVirtualMethod(@TBild.Load, 'Load');
    RegisterVirtualMethod(@TBild.Store, 'Store');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uBild(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBild(CL);
end;

 
 
{ TPSImport_uBild }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uBild.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uBild(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uBild.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uBild(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
