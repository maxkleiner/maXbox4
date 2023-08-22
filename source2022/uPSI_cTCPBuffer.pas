unit uPSI_cTCPBuffer;
{
   as a research
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
  TPSImport_cTCPBuffer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cTCPBuffer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cTCPBuffer_Routines(S: TPSExec);
procedure RIRegister_cTCPBuffer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cTCPBuffer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cTCPBuffer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cTCPBuffer(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETCPBuffer');
  CL.AddTypeS('TTCPBuffer', 'record Ptr : TObject; Size : Integer; Max : Integer; Head : Integer; Used : Integer; end');
 CL.AddConstantN('ETHERNET_MTU_100MBIT','LongInt').SetInt( 1500);
 CL.AddConstantN('ETHERNET_MTU_1GBIT','LongInt').SetInt( 9000);
 CL.AddConstantN('TCP_BUFFER_DEFAULTMAXSIZE','LongInt').SetInt( ETHERNET_MTU_1GBIT * 4);
 CL.AddConstantN('TCP_BUFFER_DEFAULTBUFSIZE','LongInt').SetInt( ETHERNET_MTU_100MBIT * 4);
 CL.AddDelphiFunction('Procedure TCPBufferInitialise( var TCPBuf : TTCPBuffer; const TCPBufMaxSize : Integer; const TCPBufSize : Integer)');
 CL.AddDelphiFunction('Procedure TCPBufferFinalise( var TCPBuf : TTCPBuffer)');
 CL.AddDelphiFunction('Procedure TCPBufferPack( var TCPBuf : TTCPBuffer)');
 CL.AddDelphiFunction('Procedure TCPBufferResize( var TCPBuf : TTCPBuffer; const TCPBufSize : Integer)');
 CL.AddDelphiFunction('Procedure TCPBufferExpand( var TCPBuf : TTCPBuffer; const Size : Integer)');
 CL.AddDelphiFunction('Procedure TCPBufferShrink( var TCPBuf : TTCPBuffer)');
 CL.AddDelphiFunction('Function TCPBufferAddPtr( var TCPBuf : TTCPBuffer; const Size : Integer) : TObject');
 CL.AddDelphiFunction('Procedure TCPBufferAddBuf( var TCPBuf : TTCPBuffer; const Buf : string; const Size : Integer)');
 CL.AddDelphiFunction('Function TCPBufferPeekPtr( const TCPBuf : TTCPBuffer; var BufPtr : TObject) : Integer');
 CL.AddDelphiFunction('Function TCPBufferPeek( var TCPBuf : TTCPBuffer; var Buf : string; const Size : Integer) : Integer');
 CL.AddDelphiFunction('Function TCPBufferRemove( var TCPBuf : TTCPBuffer; var Buf : string; const Size : Integer) : Integer');
 CL.AddDelphiFunction('Procedure TCPBufferClear( var TCPBuf : TTCPBuffer)');
 CL.AddDelphiFunction('Function TCPBufferDiscard( var TCPBuf : TTCPBuffer; const Size : Integer) : Integer');
 CL.AddDelphiFunction('Function TCPBufferUsed( const TCPBuf : TTCPBuffer) : Integer');
 CL.AddDelphiFunction('Function TCPBufferEmpty( const TCPBuf : TTCPBuffer) : Boolean');
 CL.AddDelphiFunction('Function TCPBufferAvailable( const TCPBuf : TTCPBuffer) : Integer');
 CL.AddDelphiFunction('Function TCPBufferPtr( const TCPBuf : TTCPBuffer) : TObject');
 CL.AddDelphiFunction('Procedure TCPBufferSetMaxSize( var TCPBuf : TTCPBuffer; const MaxSize : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cTCPBuffer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TCPBufferInitialise, 'TCPBufferInitialise', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferFinalise, 'TCPBufferFinalise', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferPack, 'TCPBufferPack', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferResize, 'TCPBufferResize', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferExpand, 'TCPBufferExpand', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferShrink, 'TCPBufferShrink', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferAddPtr, 'TCPBufferAddPtr', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferAddBuf, 'TCPBufferAddBuf', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferPeekPtr, 'TCPBufferPeekPtr', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferPeek, 'TCPBufferPeek', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferRemove, 'TCPBufferRemove', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferClear, 'TCPBufferClear', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferDiscard, 'TCPBufferDiscard', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferUsed, 'TCPBufferUsed', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferEmpty, 'TCPBufferEmpty', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferAvailable, 'TCPBufferAvailable', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferPtr, 'TCPBufferPtr', cdRegister);
 S.RegisterDelphiFunction(@TCPBufferSetMaxSize, 'TCPBufferSetMaxSize', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cTCPBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETCPBuffer) do
end;

 
 
{ TPSImport_cTCPBuffer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTCPBuffer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cTCPBuffer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTCPBuffer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cTCPBuffer(ri);
  RIRegister_cTCPBuffer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
