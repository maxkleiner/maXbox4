unit uPSI_WDosPlcUtils;
{
   SPS RealTime
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
  TPSImport_WDosPlcUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WDosPlcUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WDosPlcUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   WDosPlcUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosPlcUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosPlcUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TErrorCode', 'Byte');
 CL.AddConstantN('ecmNoError','LongInt').SetInt( 0);
 CL.AddConstantN('ecmWatchdogTime','LongInt').SetInt( 1);
 CL.AddConstantN('ecmInOutBase','LongInt').SetInt( 10);
 CL.AddConstantN('ecmNext','LongInt').SetInt( 18);
 CL.AddConstantN('ecsNoError','LongInt').SetInt( 0);
 CL.AddConstantN('ecsEmergencyStop','LongInt').SetInt( 1);
 CL.AddConstantN('ecsHardware','LongInt').SetInt( 2);
 CL.AddConstantN('ecsSoftware','LongInt').SetInt( 3);
 CL.AddConstantN('ecsParameter','LongInt').SetInt( 4);
 CL.AddConstantN('ecsShortCircuit','LongInt').SetInt( 5);
 CL.AddConstantN('ecsProtocol','LongInt').SetInt( 6);
 CL.AddConstantN('ecsReport','LongInt').SetInt( 7);
 CL.AddConstantN('ecsNext','LongInt').SetInt( 8);
 CL.AddConstantN('BitNum','LongInt').SetInt( 8);
 CL.AddConstantN('StationNum','LongInt').SetInt( 32);
 CL.AddConstantN('StByteNum','LongInt').SetInt( 8);
 CL.AddConstantN('InOutNum','LongInt').SetInt( 8);
  CL.AddTypeS('TBitNo', 'Integer');
  CL.AddTypeS('TStByteNo', 'Integer');
  CL.AddTypeS('TStationNo', 'Integer');
  CL.AddTypeS('TInOutNo', 'Integer');
  CL.AddTypeS('TIo', '(EE, AA, NE, NA )');
  CL.AddTypeS('TBitSet', 'integer');
  CL.AddTypeS('TAddrKinds', '( akBit0, akBit1, akBit2, akOut, akNot, akBus )');
  CL.AddTypeS('TAddrKind', 'set of TAddrKinds');
  CL.AddTypeS('TBitAddrRec', 'record Kind : TAddrKind; InOutNo : TInOutNo; ByteNo : Byte; end');
  CL.AddTypeS('TBitAddr', 'LongInt');
  CL.AddTypeS('TByteAddrRec', 'record Kind : TAddrKind; ByteNo : Byte; end');
  CL.AddTypeS('TByteAddr', 'SmallInt');
  CL.AddTypeS('TInOutState', '( iosInit, iosHalt, iosRun, iosError )');
 CL.AddDelphiFunction('Function BitAddr( aIo : TIo; aInOutNo : TInOutNo; aByteNo : Byte; aBitNo : TBitNo) : TBitAddr');
 CL.AddDelphiFunction('Function BusBitAddr( aIo : TIo; aInOutNo : TInOutNo; aStation : TStationNo; aStByteNo : TStByteNo; aBitNo : TBitNo) : TBitAddr');
 CL.AddDelphiFunction('Procedure BitAddrToValues( aBitAddr : TBitAddr; var aIo : TIo; var aInOutNo : TInOutNo; var aByteNo : Byte; var aBitNo : TBitNo)');
 CL.AddDelphiFunction('Function BitAddrToStr( Value : TBitAddr) : string');
 CL.AddDelphiFunction('Function StrToBitAddr( const Value : string) : TBitAddr');
 CL.AddDelphiFunction('Function ByteAddr( aIo : TIo; aInOutNo : TInOutNo; aByteNo : Byte) : TByteAddr');
 CL.AddDelphiFunction('Function BusByteAddr( aIo : TIo; aInOutNo : TInOutNo; aStation : TStationNo; aStByteNo : TStByteNo) : TByteAddr');
 CL.AddDelphiFunction('Procedure ByteAddrToValues( aByteAddr : TByteAddr; var aIo : TIo; var aInOutNo : TInOutNo; var aByteNo : Byte)');
 CL.AddDelphiFunction('Function ByteAddrToStr( Value : TByteAddr) : string');
 CL.AddDelphiFunction('Function StrToByteAddr( const Value : string) : TByteAddr');
 CL.AddDelphiFunction('Procedure IncByteAddr( var ByteAddr : TByteAddr; Increment : Integer)');
 CL.AddDelphiFunction('Procedure DecByteAddr( var ByteAddr : TByteAddr; Decrement : Integer)');
 CL.AddDelphiFunction('Function InOutStateToStr( State : TInOutState) : string');
 CL.AddDelphiFunction('Function MasterErrorToStr( ErrorCode : TErrorCode) : string');
 CL.AddDelphiFunction('Function SlaveErrorToStr( ErrorCode : TErrorCode) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosPlcUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BitAddr, 'BitAddr', cdRegister);
 S.RegisterDelphiFunction(@BusBitAddr, 'BusBitAddr', cdRegister);
 S.RegisterDelphiFunction(@BitAddrToValues, 'BitAddrToValues', cdRegister);
 S.RegisterDelphiFunction(@BitAddrToStr, 'BitAddrToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToBitAddr, 'StrToBitAddr', cdRegister);
 S.RegisterDelphiFunction(@ByteAddr, 'ByteAddr', cdRegister);
 S.RegisterDelphiFunction(@BusByteAddr, 'BusByteAddr', cdRegister);
 S.RegisterDelphiFunction(@ByteAddrToValues, 'ByteAddrToValues', cdRegister);
 S.RegisterDelphiFunction(@ByteAddrToStr, 'ByteAddrToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToByteAddr, 'StrToByteAddr', cdRegister);
 S.RegisterDelphiFunction(@IncByteAddr, 'IncByteAddr', cdRegister);
 S.RegisterDelphiFunction(@DecByteAddr, 'DecByteAddr', cdRegister);
 S.RegisterDelphiFunction(@InOutStateToStr, 'InOutStateToStr', cdRegister);
 S.RegisterDelphiFunction(@MasterErrorToStr, 'MasterErrorToStr', cdRegister);
 S.RegisterDelphiFunction(@SlaveErrorToStr, 'SlaveErrorToStr', cdRegister);
end;

 
 
{ TPSImport_WDosPlcUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosPlcUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosPlcUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosPlcUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WDosPlcUtils(ri);
  RIRegister_WDosPlcUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
