unit uPSI_IdTrivialFTPBase;
{

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
  TPSImport_IdTrivialFTPBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdTrivialFTPBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdTrivialFTPBase_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdGlobal
  ,IdUDPBase
  ,IdUDPClient
  ,IdTrivialFTPBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdTrivialFTPBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdTrivialFTPBase(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdTFTPMode', '( tfNetAscii, tfOctet )');
  CL.AddTypeS('WordStr', 'string');
 CL.AddDelphiFunction('Function MakeAckPkt( const BlockNumber : Word) : string');
 CL.AddDelphiFunction('Procedure SendError( UDPBase : TIdUDPBase; APeerIP : string; const APort : Integer; const ErrNumber : Word; ErrorString : string);');
 CL.AddDelphiFunction('Procedure SendError1( UDPClient : TIdUDPClient; const ErrNumber : Word; ErrorString : string);');
 CL.AddDelphiFunction('Procedure SendError2( UDPBase : TIdUDPBase; APeerIP : string; const APort : Integer; E : Exception);');
 CL.AddDelphiFunction('Procedure SendError3( UDPClient : TIdUDPClient; E : Exception);');
 CL.AddDelphiFunction('Function IdStrToWord( const Value : String) : Word');
 CL.AddDelphiFunction('Function IdWordToStr( const Value : Word) : WordStr');
 CL.AddConstantN('TFTP_RRQ','LongInt').SetInt( 1);
 CL.AddConstantN('TFTP_WRQ','LongInt').SetInt( 2);
 CL.AddConstantN('TFTP_DATA','LongInt').SetInt( 3);
 CL.AddConstantN('TFTP_ACK','LongInt').SetInt( 4);
 CL.AddConstantN('TFTP_ERROR','LongInt').SetInt( 5);
 CL.AddConstantN('TFTP_OACK','LongInt').SetInt( 6);
 CL.AddConstantN('hdrsize','LongInt').SetInt( 4);
 //CL.AddConstantN('sBlockSize','Char').SetString( 'blksize' #0);
 CL.AddConstantN('ErrUndefined','LongInt').SetInt( 0);
 CL.AddConstantN('ErrFileNotFound','LongInt').SetInt( 1);
 CL.AddConstantN('ErrAccessViolation','LongInt').SetInt( 2);
 CL.AddConstantN('ErrAllocationExceeded','LongInt').SetInt( 3);
 CL.AddConstantN('ErrIllegalOperation','LongInt').SetInt( 4);
 CL.AddConstantN('ErrUnknownTransferID','LongInt').SetInt( 5);
 CL.AddConstantN('ErrFileAlreadyExists','LongInt').SetInt( 6);
 CL.AddConstantN('ErrNoSuchUser','LongInt').SetInt( 7);
 CL.AddConstantN('ErrOptionNegotiationFailed','LongInt').SetInt( 8);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SendError3_P( UDPClient : TIdUDPClient; E : Exception);
Begin IdTrivialFTPBase.SendError(UDPClient, E); END;

(*----------------------------------------------------------------------------*)
Procedure SendError2_P( UDPBase : TIdUDPBase; APeerIP : string; const APort : Integer; E : Exception);
Begin IdTrivialFTPBase.SendError(UDPBase, APeerIP, APort, E); END;

(*----------------------------------------------------------------------------*)
Procedure SendError1_P( UDPClient : TIdUDPClient; const ErrNumber : Word; ErrorString : string);
Begin IdTrivialFTPBase.SendError(UDPClient, ErrNumber, ErrorString); END;

(*----------------------------------------------------------------------------*)
Procedure SendError_P( UDPBase : TIdUDPBase; APeerIP : string; const APort : Integer; const ErrNumber : Word; ErrorString : string);
Begin IdTrivialFTPBase.SendError(UDPBase, APeerIP, APort, ErrNumber, ErrorString); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdTrivialFTPBase_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MakeAckPkt, 'MakeAckPkt', cdRegister);
 S.RegisterDelphiFunction(@SendError, 'SendError', cdRegister);
 S.RegisterDelphiFunction(@SendError1_P, 'SendError1', cdRegister);
 S.RegisterDelphiFunction(@SendError2_P, 'SendError2', cdRegister);
 S.RegisterDelphiFunction(@SendError3_P, 'SendError3', cdRegister);
 S.RegisterDelphiFunction(@StrToWord, 'IdStrToWord', cdRegister);
 S.RegisterDelphiFunction(@WordToStr, 'IdWordToStr', cdRegister);
end;

 
 
{ TPSImport_IdTrivialFTPBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTrivialFTPBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdTrivialFTPBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTrivialFTPBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdTrivialFTPBase(ri);
  RIRegister_IdTrivialFTPBase_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
