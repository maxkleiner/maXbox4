unit uPSI_SockTransport;
{
  experimental
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
  TPSImport_SockTransport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSendDataBlock(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDataBlockInterpreter(CL: TPSPascalCompiler);
procedure SIRegister_TDataBlock(CL: TPSPascalCompiler);
procedure SIRegister_ITransport(CL: TPSPascalCompiler);
procedure SIRegister_ISendDataBlock(CL: TPSPascalCompiler);
procedure SIRegister_IDataBlock(CL: TPSPascalCompiler);
procedure SIRegister_SockTransport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SockTransport_Routines(S: TPSExec);
procedure RIRegister_TSendDataBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDataBlockInterpreter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_SockTransport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,SockTransport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SockTransport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSendDataBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TSendDataBlock') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TSendDataBlock') do
  begin
    RegisterMethod('Constructor Create( ATransport : ITransport)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomDataBlockInterpreter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomDataBlockInterpreter') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomDataBlockInterpreter') do
  begin
    RegisterMethod('Procedure InterpretData( const Data : IDataBlock)');
    RegisterMethod('Constructor Create( ASendDataBlock : ISendDataBlock)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TDataBlock') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TDataBlock') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ITransport(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ITransport') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ITransport, 'ITransport') do
  begin
    RegisterMethod('Function GetWaitEvent : THandle', cdRegister);
    RegisterMethod('Function GetConnected : Boolean', cdRegister);
    RegisterMethod('Procedure SetConnected( Value : Boolean)', cdRegister);
    RegisterMethod('Function Receive( WaitForInput : Boolean; Context : Integer) : IDataBlock', cdRegister);
    RegisterMethod('Function Send( const Data : IDataBlock) : Integer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISendDataBlock(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ISendDataBlock') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISendDataBlock, 'ISendDataBlock') do
  begin
    RegisterMethod('Function Send( const Data : IDataBlock; WaitForResult : Boolean) : IDataBlock', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDataBlock(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IDataBlock') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IDataBlock, 'IDataBlock') do begin
    RegisterMethod('Function GetBytesReserved : Integer', cdRegister);
    RegisterMethod('Function GetMemory : Pointer', cdRegister);
    RegisterMethod('Function GetSize : Integer', cdRegister);
    RegisterMethod('Procedure SetSize( Value : Integer)', cdRegister);
    RegisterMethod('Function GetStream : TStream', cdRegister);
    RegisterMethod('Function GetSignature : Integer', cdRegister);
    RegisterMethod('Procedure SetSignature( Value : Integer)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Write( const Buffer, Count : Integer) : Integer', cdRegister);
    RegisterMethod('Function Read( var Buffer, Count : Integer) : Integer', cdRegister);
    RegisterMethod('Procedure IgnoreStream', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SockTransport(CL: TPSPascalCompiler);
begin
  SIRegister_IDataBlock(CL);
  SIRegister_ISendDataBlock(CL);
  SIRegister_ITransport(CL);
  SIRegister_TDataBlock(CL);
  //CL.AddTypeS('PIntArray', '^TIntArray // will not work');
  //CL.AddTypeS('PVariantArray', '^TVariantArray // will not work');
  CL.AddTypeS('TVarFlag', '( vfByRef, vfVariant )');
  CL.AddTypeS('TVarFlags', 'set of TVarFlag');
  SIRegister_TCustomDataBlockInterpreter(CL);
  SIRegister_TSendDataBlock(CL);
  CL.AddConstantN('CallSig','LongWord').SetUInt( $D800);
  CL.AddConstantN('ResultSig','LongWord').SetUInt( $D400);
  CL.AddConstantN('asMask','LongWord').SetUInt( $00FF);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInterpreterError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESocketConnectionError');
 CL.AddDelphiFunction('Procedure CheckSignature( Sig : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SockTransport_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckSignature, 'CheckSignature', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSendDataBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSendDataBlock) do
  begin
    RegisterConstructor(@TSendDataBlock.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomDataBlockInterpreter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDataBlockInterpreter) do
  begin
    RegisterVirtualMethod(@TCustomDataBlockInterpreter.InterpretData, 'InterpretData');
    RegisterConstructor(@TCustomDataBlockInterpreter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataBlock) do
  begin
    RegisterConstructor(@TDataBlock.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SockTransport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDataBlock(CL);
  RIRegister_TCustomDataBlockInterpreter(CL);
  RIRegister_TSendDataBlock(CL);
  with CL.Add(EInterpreterError) do
  with CL.Add(ESocketConnectionError) do
end;

 
 
{ TPSImport_SockTransport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockTransport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SockTransport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockTransport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SockTransport_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
