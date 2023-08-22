unit uPSI_BlockSocket;
{
   blocks for externals  rename to blocksocket2
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
  TPSImport_BlockSocket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_BlockSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_BlockSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SocketsDelphi
  ,BlockSocket
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BlockSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBlockSocket') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBlockSocket2') do begin
    RegisterMethod('Constructor Create( S : integer)');
    RegisterMethod('Procedure Bind( pPort, BackLog : word)');
    RegisterMethod('Function Accept( Timeout : integer) : integer');
    RegisterMethod('Procedure Connect( Host : string; pPort : word)');
    RegisterMethod('Procedure Purge');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function RecvPacket : AnsiString');
    RegisterMethod('Function RecvString( Timeout : integer) : AnsiString');
    RegisterMethod('Procedure SendString( const Data : AnsiString)');
    RegisterMethod('Function WaitingData : cardinal');
    RegisterMethod('Function CanRead( Timeout : Integer) : Boolean');
    RegisterMethod('Function Error : integer');
    RegisterMethod('Function GetHostAddress : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BlockSocket(CL: TPSPascalCompiler);
begin
  SIRegister_TBlockSocket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockSocket2) do begin
    RegisterConstructor(@TBlockSocket2.Create, 'Create');
    RegisterMethod(@TBlockSocket2.Bind, 'Bind');
    RegisterMethod(@TBlockSocket2.Accept, 'Accept');
    RegisterMethod(@TBlockSocket2.Connect, 'Connect');
    RegisterMethod(@TBlockSocket2.Purge, 'Purge');
    RegisterMethod(@TBlockSocket2.Close, 'Close');
    RegisterMethod(@TBlockSocket2.RecvPacket, 'RecvPacket');
    RegisterMethod(@TBlockSocket2.RecvString, 'RecvString');
    RegisterMethod(@TBlockSocket2.SendString, 'SendString');
    RegisterMethod(@TBlockSocket2.WaitingData, 'WaitingData');
    RegisterMethod(@TBlockSocket2.CanRead, 'CanRead');
    RegisterMethod(@TBlockSocket2.Error, 'Error');
    RegisterMethod(@TBlockSocket2.GetHostAddress, 'GetHostAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BlockSocket(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlockSocket(CL);
end;

 
 
{ TPSImport_BlockSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlockSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BlockSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlockSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BlockSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
