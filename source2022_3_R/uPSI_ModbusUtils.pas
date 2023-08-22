unit uPSI_ModbusUtils;
{
  utils to modbus with hexbuffer
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
  TPSImport_ModbusUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ModbusUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ModbusUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ModbusUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ModbusUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ModbusUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function BufferToHex( const Buffer : array of Byte) : String');
 CL.AddDelphiFunction('Function CalculateCRC16( const Buffer : array of Byte) : Word');
 CL.AddDelphiFunction('Function CalculateLRC( const Buffer : array of Byte) : Byte');
 CL.AddDelphiFunction('Function Swap16( const DataToSwap : Word) : Word');
 //CL.AddDelphiFunction('Procedure GetCoilsFromBuffer( const Buffer : PByte; const Count : Word; var Data : array of Word)');
 //CL.AddDelphiFunction('Procedure PutCoilsIntoBuffer( const Buffer : PByte; const Count : Word; const Data : array of Word)');
 //CL.AddDelphiFunction('Procedure GetRegistersFromBuffer( const Buffer : PWord; const Count : Word; var Data : array of Word)');
 //CL.AddDelphiFunction('Procedure PutRegistersIntoBuffer( const Buffer : PWord; const Count : Word; const Data : array of Word)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ModbusUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BufferToHex, 'BufferToHex', cdRegister);
 S.RegisterDelphiFunction(@CalculateCRC16, 'CalculateCRC16', cdRegister);
 S.RegisterDelphiFunction(@CalculateLRC, 'CalculateLRC', cdRegister);
 S.RegisterDelphiFunction(@Swap16, 'Swap16', cdRegister);
 {S.RegisterDelphiFunction(@GetCoilsFromBuffer, 'GetCoilsFromBuffer', cdRegister);
 S.RegisterDelphiFunction(@PutCoilsIntoBuffer, 'PutCoilsIntoBuffer', cdRegister);
 S.RegisterDelphiFunction(@GetRegistersFromBuffer, 'GetRegistersFromBuffer', cdRegister);
 S.RegisterDelphiFunction(@PutRegistersIntoBuffer, 'PutRegistersIntoBuffer', cdRegister);}
end;

 
 
{ TPSImport_ModbusUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ModbusUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ModbusUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ModbusUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ModbusUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
