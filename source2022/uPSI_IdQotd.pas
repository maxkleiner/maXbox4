unit uPSI_IdQotd;
{
   qotd
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
  TPSImport_IdQotd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdQOTD(CL: TPSPascalCompiler);
procedure SIRegister_IdQotd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdQOTD(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdQotd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPClient
  ,IdQotd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdQotd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdQOTD(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdQOTD') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdQOTD') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Quote', 'String', iptr);
    RegisterProperty('Host', 'String', iptrw);
    RegisterProperty('UserName', 'String', iptrw);
    RegisterProperty('Password', 'String', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('UserId', 'String', iptrw);
    //RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure Free;');


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdQotd(CL: TPSPascalCompiler);
begin
  SIRegister_TIdQOTD(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdQOTDQuote_R(Self: TIdQOTD; var T: String);
begin T := Self.Quote; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdQOTD(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdQOTD) do
  begin
    RegisterConstructor(@TIdQOTD.Create, 'Create');
    //RegisterConstructor(@TIdQOTD.Connect, 'Connect');
    RegisterPropertyHelper(@TIdQOTDQuote_R,nil,'Quote');
    RegisterMethod(@TIdQOTD.Destroy, 'Free');
    RegisterMethod(@TIdQOTD.Disconnect, 'Disconnect');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdQotd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdQOTD(CL);
end;

 
 
{ TPSImport_IdQotd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdQotd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdQotd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdQotd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdQotd(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
