unit uPSI_DataSendToWeb;
{
   direct test to web
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
  TPSImport_DataSendToWeb = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDataSendToWeb(CL: TPSPascalCompiler);
procedure SIRegister_DataSendToWeb(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DataSendToWeb_Routines(S: TPSExec);
procedure RIRegister_TDataSendToWeb(CL: TPSRuntimeClassImporter);
procedure RIRegister_DataSendToWeb(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ShellAPI
  ,DataSendToWeb
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DataSendToWeb]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSendToWeb(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDataSendToWeb') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDataSendToWeb') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DataSend( rS : String)');
    RegisterProperty('WebAddress', 'String', iptrw);
    RegisterProperty('ProtocolDirectory', 'String', iptrw);
    RegisterProperty('ProtocolFilename', 'String', iptrw);
    RegisterProperty('Station', 'Integer', iptrw);
    RegisterProperty('TestOn', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DataSendToWeb(CL: TPSPascalCompiler);
begin
  SIRegister_TDataSendToWeb(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDataSendToWebTestOn_W(Self: TDataSendToWeb; const T: Boolean);
begin Self.TestOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebTestOn_R(Self: TDataSendToWeb; var T: Boolean);
begin T := Self.TestOn; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebStation_W(Self: TDataSendToWeb; const T: Integer);
begin Self.Station := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebStation_R(Self: TDataSendToWeb; var T: Integer);
begin T := Self.Station; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebProtocolFilename_W(Self: TDataSendToWeb; const T: String);
begin Self.ProtocolFilename := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebProtocolFilename_R(Self: TDataSendToWeb; var T: String);
begin T := Self.ProtocolFilename; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebProtocolDirectory_W(Self: TDataSendToWeb; const T: String);
begin Self.ProtocolDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebProtocolDirectory_R(Self: TDataSendToWeb; var T: String);
begin T := Self.ProtocolDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebWebAddress_W(Self: TDataSendToWeb; const T: String);
begin Self.WebAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSendToWebWebAddress_R(Self: TDataSendToWeb; var T: String);
begin T := Self.WebAddress; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DataSendToWeb_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSendToWeb(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSendToWeb) do begin
    RegisterConstructor(@TDataSendToWeb.Create, 'Create');
    RegisterMethod(@TDataSendToWeb.Destroy, 'Free');
    RegisterMethod(@TDataSendToWeb.DataSend, 'DataSend');
    RegisterPropertyHelper(@TDataSendToWebWebAddress_R,@TDataSendToWebWebAddress_W,'WebAddress');
    RegisterPropertyHelper(@TDataSendToWebProtocolDirectory_R,@TDataSendToWebProtocolDirectory_W,'ProtocolDirectory');
    RegisterPropertyHelper(@TDataSendToWebProtocolFilename_R,@TDataSendToWebProtocolFilename_W,'ProtocolFilename');
    RegisterPropertyHelper(@TDataSendToWebStation_R,@TDataSendToWebStation_W,'Station');
    RegisterPropertyHelper(@TDataSendToWebTestOn_R,@TDataSendToWebTestOn_W,'TestOn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DataSendToWeb(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDataSendToWeb(CL);
end;

 
 
{ TPSImport_DataSendToWeb }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DataSendToWeb.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DataSendToWeb(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DataSendToWeb.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DataSendToWeb(ri);
  RIRegister_DataSendToWeb_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
