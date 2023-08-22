unit uPSI_IdQOTDUDP;
{
  quote
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
  TPSImport_IdQOTDUDP = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdQOTDUDP(CL: TPSPascalCompiler);
procedure SIRegister_IdQOTDUDP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdQOTDUDP(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdQOTDUDP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdUDPBase
  ,IdUDPClient
  ,IdQOTDUDP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdQOTDUDP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdQOTDUDP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPClient', 'TIdQOTDUDP') do
  with CL.AddClassN(CL.FindClass('TIdUDPClient'),'TIdQOTDUDP') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterProperty('Quote', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdQOTDUDP(CL: TPSPascalCompiler);
begin
  SIRegister_TIdQOTDUDP(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdQOTDUDPQuote_R(Self: TIdQOTDUDP; var T: String);
begin T := Self.Quote; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdQOTDUDP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdQOTDUDP) do begin
    RegisterConstructor(@TIdQOTDUDP.Create, 'Create');
       RegisterMethod(@TIdQOTDUDP.Destroy, 'Free');
    RegisterPropertyHelper(@TIdQOTDUDPQuote_R,nil,'Quote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdQOTDUDP(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdQOTDUDP(CL);
end;

 
 
{ TPSImport_IdQOTDUDP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdQOTDUDP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdQOTDUDP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdQOTDUDP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdQOTDUDP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
