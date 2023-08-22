unit uPSI_IdTrivialFTP;
{
  octet
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
  TPSImport_IdTrivialFTP = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdTrivialFTP(CL: TPSPascalCompiler);
procedure SIRegister_IdTrivialFTP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdTrivialFTP(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdTrivialFTP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTrivialFTPBase
  ,IdUDPClient
  ,IdTrivialFTP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdTrivialFTP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTrivialFTP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPClient', 'TIdTrivialFTP') do
  with CL.AddClassN(CL.FindClass('TIdUDPClient'),'TIdTrivialFTP') do begin
    RegisterMethod('Constructor Create( AnOwner : TComponent)');
    RegisterMethod('Procedure Get( const ServerFile : String; DestinationStream : TStream);');
    RegisterMethod('Procedure Get1( const ServerFile, LocalFile : String);');
    RegisterMethod('Procedure Put( SourceStream : TStream; const ServerFile : String);');
    RegisterMethod('Procedure Put1( const LocalFile, ServerFile : String);');
    RegisterProperty('TransferMode', 'TIdTFTPMode', iptrw);
    RegisterProperty('RequestedBlockSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdTrivialFTP(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('TIdTFTPMode', '( tfNetAscii, tfOctet )');
 //CL.AddConstantN('GTransferMode','TIdTFTPMode').SetSet('tfOctet');
 CL.AddConstantN('GTransferMode','TIdTFTPMode').SetInt(1);
 CL.AddConstantN('GFRequestedBlockSize','LongInt').SetInt( 1500);
 CL.AddConstantN('GReceiveTimeout','LongInt').SetInt( 4000);
  SIRegister_TIdTrivialFTP(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdTrivialFTPRequestedBlockSize_W(Self: TIdTrivialFTP; const T: Integer);
begin Self.RequestedBlockSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTrivialFTPRequestedBlockSize_R(Self: TIdTrivialFTP; var T: Integer);
begin T := Self.RequestedBlockSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdTrivialFTPTransferMode_W(Self: TIdTrivialFTP; const T: TIdTFTPMode);
begin Self.TransferMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTrivialFTPTransferMode_R(Self: TIdTrivialFTP; var T: TIdTFTPMode);
begin T := Self.TransferMode; end;

(*----------------------------------------------------------------------------*)
Procedure TIdTrivialFTPPut1_P(Self: TIdTrivialFTP;  const LocalFile, ServerFile : String);
Begin Self.Put(LocalFile, ServerFile); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTrivialFTPPut_P(Self: TIdTrivialFTP;  SourceStream : TStream; const ServerFile : String);
Begin Self.Put(SourceStream, ServerFile); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTrivialFTPGet1_P(Self: TIdTrivialFTP;  const ServerFile, LocalFile : String);
Begin Self.Get(ServerFile, LocalFile); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTrivialFTPGet_P(Self: TIdTrivialFTP;  const ServerFile : String; DestinationStream : TStream);
Begin Self.Get(ServerFile, DestinationStream); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTrivialFTP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTrivialFTP) do
  begin
    RegisterConstructor(@TIdTrivialFTP.Create, 'Create');
    RegisterMethod(@TIdTrivialFTPGet_P, 'Get');
    RegisterMethod(@TIdTrivialFTPGet1_P, 'Get1');
    RegisterMethod(@TIdTrivialFTPPut_P, 'Put');
    RegisterMethod(@TIdTrivialFTPPut1_P, 'Put1');
    RegisterPropertyHelper(@TIdTrivialFTPTransferMode_R,@TIdTrivialFTPTransferMode_W,'TransferMode');
    RegisterPropertyHelper(@TIdTrivialFTPRequestedBlockSize_R,@TIdTrivialFTPRequestedBlockSize_W,'RequestedBlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdTrivialFTP(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdTrivialFTP(CL);
end;

 
 
{ TPSImport_IdTrivialFTP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTrivialFTP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdTrivialFTP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTrivialFTP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdTrivialFTP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
