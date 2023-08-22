unit uPSI_ftptsend;
{
   synapse ftp2
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
  TPSImport_ftptsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTFTPSend(CL: TPSPascalCompiler);
procedure SIRegister_ftptsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTFTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_ftptsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,ftptsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ftptsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTFTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TTFTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TTFTPSend') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function SendFile( const Filename : string) : Boolean');
    RegisterMethod('Function RecvFile( const Filename : string) : Boolean');
    RegisterMethod('Function WaitForRequest( var Req : word; var filename : string) : Boolean');
    RegisterMethod('Procedure ReplyError( Error : word; Description : string)');
    RegisterMethod('Function ReplyRecv : Boolean');
    RegisterMethod('Function ReplySend : Boolean');
    RegisterProperty('ErrorCode', 'integer', iptr);
    RegisterProperty('ErrorString', 'string', iptr);
    RegisterProperty('Data', 'TMemoryStream', iptr);
    RegisterProperty('RequestIP', 'string', iptrw);
    RegisterProperty('RequestPort', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ftptsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cTFTPProtocol','String').SetString( '69');
 CL.AddConstantN('cTFTP_RRQ','LongInt').SetInt( word ( 1 ));
 CL.AddConstantN('cTFTP_WRQ','LongInt').SetInt( word ( 2 ));
 CL.AddConstantN('cTFTP_DTA','LongInt').SetInt( word ( 3 ));
 CL.AddConstantN('cTFTP_ACK','LongInt').SetInt( word ( 4 ));
 CL.AddConstantN('cTFTP_ERR','LongInt').SetInt( word ( 5 ));
  SIRegister_TTFTPSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTFTPSendRequestPort_W(Self: TTFTPSend; const T: string);
begin Self.RequestPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendRequestPort_R(Self: TTFTPSend; var T: string);
begin T := Self.RequestPort; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendRequestIP_W(Self: TTFTPSend; const T: string);
begin Self.RequestIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendRequestIP_R(Self: TTFTPSend; var T: string);
begin T := Self.RequestIP; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendData_R(Self: TTFTPSend; var T: TMemoryStream);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendErrorString_R(Self: TTFTPSend; var T: string);
begin T := Self.ErrorString; end;

(*----------------------------------------------------------------------------*)
procedure TTFTPSendErrorCode_R(Self: TTFTPSend; var T: integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTFTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTFTPSend) do begin
    RegisterConstructor(@TTFTPSend.Create, 'Create');
      RegisterMethod(@TTFTPSend.Destroy, 'Free');
      RegisterMethod(@TTFTPSend.SendFile, 'SendFile');
    RegisterMethod(@TTFTPSend.RecvFile, 'RecvFile');
    RegisterMethod(@TTFTPSend.WaitForRequest, 'WaitForRequest');
    RegisterMethod(@TTFTPSend.ReplyError, 'ReplyError');
    RegisterMethod(@TTFTPSend.ReplyRecv, 'ReplyRecv');
    RegisterMethod(@TTFTPSend.ReplySend, 'ReplySend');
    RegisterPropertyHelper(@TTFTPSendErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TTFTPSendErrorString_R,nil,'ErrorString');
    RegisterPropertyHelper(@TTFTPSendData_R,nil,'Data');
    RegisterPropertyHelper(@TTFTPSendRequestIP_R,@TTFTPSendRequestIP_W,'RequestIP');
    RegisterPropertyHelper(@TTFTPSendRequestPort_R,@TTFTPSendRequestPort_W,'RequestPort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ftptsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTFTPSend(CL);
end;

 
 
{ TPSImport_ftptsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ftptsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ftptsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ftptsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ftptsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
