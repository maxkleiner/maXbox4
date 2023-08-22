unit uPSI_ALGSMComm;
{
  GSM Module
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
  TPSImport_ALGSMComm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlGSMComm(CL: TPSPascalCompiler);
procedure SIRegister_ALGSMComm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALGSMComm_Routines(S: TPSExec);
procedure RIRegister_TAlGSMComm(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALGSMComm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,AlStringList
  ,ALGSMComm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALGSMComm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlGSMComm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TAlGSMComm') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TAlGSMComm') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Connect( Serial : AnsiString)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure SendCmd( aCmd : AnsiString)');
    RegisterMethod('Function GetResponse : AnsiString');
    RegisterMethod('Procedure GetATCmdOkResponse( const ErrorMsg : AnsiString);');
    RegisterMethod('Procedure GetATCmdOkResponse1( var Response : AnsiString; const ErrorMsg : AnsiString);');
    RegisterMethod('Procedure GetATCmdlinefeedResponse( const ErrorMsg : AnsiString)');
    RegisterMethod('Procedure SendSMSinPDUMode( aSMSCenter, aSMSAddress, aMessage : AnsiString; const EncodeMessageInPDU : Boolean)');
    RegisterMethod('Procedure SendSMSinTextMode( aSMSCenter, aSMSAddress, aMessage, aCharset : AnsiString)');
    RegisterMethod('Procedure ListAllSMSinPDUMode( aLstMessage : TALStrings; MemStorage : AnsiString)');
    RegisterMethod('Procedure DeleteSMS( aIndex : integer; MemStorage : AnsiString)');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('BaudRate', 'Dword', iptrw);
    RegisterProperty('Timeout', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALGSMComm(CL: TPSPascalCompiler);
begin
  SIRegister_TAlGSMComm(CL);
 CL.AddDelphiFunction('Function AlGSMComm_BuildPDUMessage( aSMSCenter, aSMSAddress, aMessage : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure AlGSMComm_DecodePDUMessage( aPDUMessage : AnsiString; var aSMSCenter, aSMSAddress, AMessage : AnsiString)');
 CL.AddDelphiFunction('Function AlGSMComm_UnicodeToGSM7BitDefaultAlphabet( aMessage : WideString) : AnsiString');
 CL.AddDelphiFunction('Function AlGSMComm_GSM7BitDefaultAlphabetToUnicode( aMessage : AnsiString; const UseGreekAlphabet : Boolean) : Widestring');
 CL.AddDelphiFunction('function ALMatchesMask(const Filename, Mask: AnsiString): Boolean;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAlGSMCommTimeout_W(Self: TAlGSMComm; const T: Cardinal);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlGSMCommTimeout_R(Self: TAlGSMComm; var T: Cardinal);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlGSMCommBaudRate_W(Self: TAlGSMComm; const T: Dword);
begin Self.BaudRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlGSMCommBaudRate_R(Self: TAlGSMComm; var T: Dword);
begin T := Self.BaudRate; end;

(*----------------------------------------------------------------------------*)
procedure TAlGSMCommConnected_R(Self: TAlGSMComm; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TAlGSMCommGetATCmdOkResponse1_P(Self: TAlGSMComm;  var Response : AnsiString; const ErrorMsg : AnsiString);
Begin Self.GetATCmdOkResponse(Response, ErrorMsg); END;

(*----------------------------------------------------------------------------*)
Procedure TAlGSMCommGetATCmdOkResponse_P(Self: TAlGSMComm;  const ErrorMsg : AnsiString);
Begin Self.GetATCmdOkResponse(ErrorMsg); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALGSMComm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlGSMComm_BuildPDUMessage, 'AlGSMComm_BuildPDUMessage', cdRegister);
 S.RegisterDelphiFunction(@AlGSMComm_DecodePDUMessage, 'AlGSMComm_DecodePDUMessage', cdRegister);
 S.RegisterDelphiFunction(@AlGSMComm_UnicodeToGSM7BitDefaultAlphabet, 'AlGSMComm_UnicodeToGSM7BitDefaultAlphabet', cdRegister);
 S.RegisterDelphiFunction(@AlGSMComm_GSM7BitDefaultAlphabetToUnicode, 'AlGSMComm_GSM7BitDefaultAlphabetToUnicode', cdRegister);
 S.RegisterDelphiFunction(@ALMatchesMask, 'ALMatchesMask', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlGSMComm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlGSMComm) do begin
    RegisterVirtualConstructor(@TAlGSMComm.Create, 'Create');
    RegisterVirtualMethod(@TAlGSMComm.Connect, 'Connect');
    RegisterMethod(@TAlGSMComm.Destroy, 'Free');

    RegisterVirtualMethod(@TAlGSMComm.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TAlGSMComm.SendCmd, 'SendCmd');
    RegisterVirtualMethod(@TAlGSMComm.GetResponse, 'GetResponse');
    RegisterMethod(@TAlGSMCommGetATCmdOkResponse_P, 'GetATCmdOkResponse');
    RegisterMethod(@TAlGSMCommGetATCmdOkResponse1_P, 'GetATCmdOkResponse1');
    RegisterMethod(@TAlGSMComm.GetATCmdlinefeedResponse, 'GetATCmdlinefeedResponse');
    RegisterMethod(@TAlGSMComm.SendSMSinPDUMode, 'SendSMSinPDUMode');
    RegisterMethod(@TAlGSMComm.SendSMSinTextMode, 'SendSMSinTextMode');
    RegisterMethod(@TAlGSMComm.ListAllSMSinPDUMode, 'ListAllSMSinPDUMode');
    RegisterMethod(@TAlGSMComm.DeleteSMS, 'DeleteSMS');
    RegisterPropertyHelper(@TAlGSMCommConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TAlGSMCommBaudRate_R,@TAlGSMCommBaudRate_W,'BaudRate');
    RegisterPropertyHelper(@TAlGSMCommTimeout_R,@TAlGSMCommTimeout_W,'Timeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALGSMComm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAlGSMComm(CL);
end;

 
 
{ TPSImport_ALGSMComm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALGSMComm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALGSMComm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALGSMComm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALGSMComm(ri);
  RIRegister_ALGSMComm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
