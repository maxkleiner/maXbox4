unit uPSI_DBPlatform;
{
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_DBPlatform = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPlatformField(CL: TPSPascalCompiler);
procedure SIRegister_TPlatformPSResult(CL: TPSPascalCompiler);
procedure SIRegister_TPlatformValueBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TPlatformRecordBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TPlatformBytes(CL: TPSPascalCompiler);
procedure SIRegister_DBPlatform(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPlatformField(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPlatformPSResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPlatformValueBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPlatformRecordBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPlatformBytes(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBPlatform(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FMTBcd
  ,DB
  ,DBPlatform
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBPlatform]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlatformField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlatformField') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlatformField') do
  begin
    RegisterMethod('Function AsWideString( Field : TField) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlatformPSResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlatformPSResult') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlatformPSResult') do
  begin
    RegisterMethod('Procedure SetPSResult( var PSResult : TPSResult; Value : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlatformValueBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlatformValueBuffer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlatformValueBuffer') do begin
    RegisterMethod('Function CreateValueBuffer( Length : Integer) : TValueBuffer');
    RegisterMethod('Procedure Free( Buffer : TValueBuffer)');
    RegisterMethod('Procedure Copy( Buffer : TValueBuffer; Dest : TBytes; Offset : Integer; Count : Integer);');
    RegisterMethod('Procedure Copy1( Source : TBytes; Offset : Integer; Buffer : TValueBuffer; Count : Integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlatformRecordBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlatformRecordBuffer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlatformRecordBuffer') do begin
    RegisterMethod('Function CreateRecordBuffer( Length : Integer) : TRecordBuffer');
    RegisterMethod('Procedure Free( Buffer : TRecordBuffer)');
    RegisterMethod('Procedure SetFMTBcd( Buffer : TRecordBuffer; value : TBcd)');
    RegisterMethod('Procedure GetFMTBcd( Buffer : TRecordBuffer; var value : TBcd)');
    RegisterMethod('Procedure FillChar( Buffer : TRecordBuffer; Length : Integer; value : Byte)');
    RegisterMethod('Procedure Copy( Buffer : TRecordBuffer; Dest : TBytes; Offset : Integer; Length : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlatformBytes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlatformBytes') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlatformBytes') do begin
    RegisterMethod('Procedure StringToBytes( Value : String; Bytes : array of byte)');
    RegisterMethod('Procedure WideStringToBytes( Value : WideString; Bytes : array of byte)');
    RegisterMethod('Procedure Int16ToBytes( Value : SmallInt; Bytes : array of byte)');
    RegisterMethod('Procedure Int32ToBytes( Value : Integer; Bytes : array of byte)');
    RegisterMethod('Procedure Int64ToBytes( Value : Int64; Bytes : array of byte)');
    RegisterMethod('Procedure DoubleToBytes( Value : Double; Bytes : array of byte)');
    RegisterMethod('Procedure BcdToBytes( Value : TBcd; Bytes : array of byte)');
    RegisterMethod('Procedure TimeStampToBytes( Value : TBcd; Bytes : array of byte)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBPlatform(CL: TPSPascalCompiler);
begin
  SIRegister_TPlatformBytes(CL);
  //CL.AddTypeS('TRecordBuffer', 'IntPtr');
  //CL.AddTypeS('TValueBuffer', 'IntPtr');
  CL.AddTypeS('TPSResult', 'TObject');
  CL.AddTypeS('TRecordBuffer', 'PChar');
  //CL.AddTypeS('TValueBuffer', 'Pointer');
  //CL.AddTypeS('TPSResult', 'Pointer');
  SIRegister_TPlatformRecordBuffer(CL);
  SIRegister_TPlatformValueBuffer(CL);
  SIRegister_TPlatformPSResult(CL);
  SIRegister_TPlatformField(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TPlatformValueBufferCopy1_P(Self: TPlatformValueBuffer;  Source : TBytes; Offset : Integer; Buffer : TValueBuffer; Count : Integer);
Begin Self.Copy(Source, Offset, Buffer, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TPlatformValueBufferCopy_P(Self: TPlatformValueBuffer;  Buffer : TValueBuffer; Dest : TBytes; Offset : Integer; Count : Integer);
Begin Self.Copy(Buffer, Dest, Offset, Count); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlatformField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlatformField) do
  begin
    RegisterMethod(@TPlatformField.AsWideString, 'AsWideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlatformPSResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlatformPSResult) do
  begin
    RegisterMethod(@TPlatformPSResult.SetPSResult, 'SetPSResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlatformValueBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlatformValueBuffer) do
  begin
    RegisterMethod(@TPlatformValueBuffer.CreateValueBuffer, 'CreateValueBuffer');
    RegisterMethod(@TPlatformValueBuffer.Free, 'Free');
    RegisterMethod(@TPlatformValueBufferCopy_P, 'Copy');
    RegisterMethod(@TPlatformValueBufferCopy1_P, 'Copy1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlatformRecordBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlatformRecordBuffer) do
  begin
    RegisterMethod(@TPlatformRecordBuffer.CreateRecordBuffer, 'CreateRecordBuffer');
    RegisterMethod(@TPlatformRecordBuffer.Free, 'Free');
    RegisterMethod(@TPlatformRecordBuffer.SetFMTBcd, 'SetFMTBcd');
    RegisterMethod(@TPlatformRecordBuffer.GetFMTBcd, 'GetFMTBcd');
    RegisterMethod(@TPlatformRecordBuffer.FillChar, 'FillChar');
    RegisterMethod(@TPlatformRecordBuffer.Copy, 'Copy');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlatformBytes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlatformBytes) do
  begin
    RegisterMethod(@TPlatformBytes.StringToBytes, 'StringToBytes');
    RegisterMethod(@TPlatformBytes.WideStringToBytes, 'WideStringToBytes');
    RegisterMethod(@TPlatformBytes.Int16ToBytes, 'Int16ToBytes');
    RegisterMethod(@TPlatformBytes.Int32ToBytes, 'Int32ToBytes');
    RegisterMethod(@TPlatformBytes.Int64ToBytes, 'Int64ToBytes');
    RegisterMethod(@TPlatformBytes.DoubleToBytes, 'DoubleToBytes');
    RegisterMethod(@TPlatformBytes.BcdToBytes, 'BcdToBytes');
    RegisterMethod(@TPlatformBytes.TimeStampToBytes, 'TimeStampToBytes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBPlatform(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPlatformBytes(CL);
  RIRegister_TPlatformRecordBuffer(CL);
  RIRegister_TPlatformValueBuffer(CL);
  RIRegister_TPlatformPSResult(CL);
  RIRegister_TPlatformField(CL);
end;

 
 
{ TPSImport_DBPlatform }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBPlatform.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBPlatform(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBPlatform.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBPlatform(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
