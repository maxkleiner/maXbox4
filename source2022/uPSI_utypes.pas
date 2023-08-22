unit uPSI_utypes;
{
  just the consts and types for the dmath.dll
  E:\maxbox\maxbox3\source\dmath_dll
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
  TPSImport_utypes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_utypes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_utypes_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_utypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_utypes(CL: TPSPascalCompiler);
begin

  CL.AddTypeS('FT_Result', 'Integer');        //of unit uPSI_D2XXUnit;
    //CL.AddTypeS('TDWordptr', '^DWord // will not work');
  CL.AddTypeS('TFT_Program_Data', 'record Signature1 : DWord; Signature2 : DWor'
   +'d; Version : DWord; VendorID : Word; ProductID : Word; Manufacturer : PCha'
   +'r; ManufacturerID : PChar; Description : PChar; SerialNumber : PChar; MaxP'
   +'ower : Word; PnP : Word; SelfPowered : Word; RemoteWakeup : Word; Rev4 : B'
   +'yte; IsoIn : Byte; IsoOut : Byte; PullDownEnable : Byte; SerNumEnable : By'
   +'te; USBVersionEnable : Byte; USBVersion : Word; Rev5 : Byte; IsoInA : Byte'
   +'; IsoInB : Byte; IsoOutA : Byte; IsoOutB : Byte; PullDownEnable5 : Byte; S'
   +'erNumEnable5 : Byte; USBVersionEnable5 : Byte; USBVersion5 : Word; AIsHigh'
   +'Current : Byte; BIsHighCurrent : Byte; IFAIsFifo : Byte; IFAIsFifoTar : By'
   +'te; IFAIsFastSer : Byte; AIsVCP : Byte; IFBIsFifo : Byte; IFBIsFifoTar : B'
   +'yte; IFBIsFastSer : Byte; BIsVCP : Byte; UseExtOsc : Byte; HighDriveIOs : '
   +'Byte; EndpointSize : Byte; PullDownEnableR : Byte; SerNumEnableR : Byte; I'
   +'nvertTXD : Byte; InvertRXD : Byte; InvertRTS : Byte; InvertCTS : Byte; Inv'
   +'ertDTR : Byte; InvertDSR : Byte; InvertDCD : Byte; InvertRI : Byte; Cbus0 '
   +': Byte; Cbus1 : Byte; Cbus2 : Byte; Cbus3 : Byte; Cbus4 : Byte; RIsVCP : B'
   +'yte; end');

  CL.AddConstantN('FT_OK','LongInt').SetInt( 0);
 CL.AddConstantN('FT_INVALID_HANDLE','LongInt').SetInt( 1);
 CL.AddConstantN('FT_DEVICE_NOT_FOUND','LongInt').SetInt( 2);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED','LongInt').SetInt( 3);
 CL.AddConstantN('FT_IO_ERROR','LongInt').SetInt( 4);
 CL.AddConstantN('FT_INSUFFICIENT_RESOURCES','LongInt').SetInt( 5);
 CL.AddConstantN('FT_INVALID_PARAMETER','LongInt').SetInt( 6);
 CL.AddConstantN('FT_SUCCESS','integer').SetInt(0);
 CL.AddConstantN('FT_INVALID_BAUD_RATE','LongInt').SetInt( 7);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED_FOR_ERASE','LongInt').SetInt( 8);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED_FOR_WRITE','LongInt').SetInt( 9);
 CL.AddConstantN('FT_FAILED_TO_WRITE_DEVICE','LongInt').SetInt( 10);
 CL.AddConstantN('FT_EEPROM_READ_FAILED','LongInt').SetInt( 11);
 CL.AddConstantN('FT_EEPROM_WRITE_FAILED','LongInt').SetInt( 12);
 CL.AddConstantN('FT_EEPROM_ERASE_FAILED','LongInt').SetInt( 13);
 CL.AddConstantN('FT_EEPROM_NOT_PRESENT','LongInt').SetInt( 14);
 CL.AddConstantN('FT_EEPROM_NOT_PROGRAMMED','LongInt').SetInt( 15);
 CL.AddConstantN('FT_INVALID_ARGS','LongInt').SetInt( 16);
 CL.AddConstantN('FT_OTHER_ERROR','LongInt').SetInt( 17);
 CL.AddConstantN('FT_OPEN_BY_SERIAL_NUMBER','LongInt').SetInt( 1);
 CL.AddConstantN('FT_OPEN_BY_DESCRIPTION','LongInt').SetInt( 2);
 CL.AddConstantN('FT_OPEN_BY_LOCATION','LongInt').SetInt( 4);
 CL.AddConstantN('FT_LIST_NUMBER_ONLY','LongWord').SetUInt( $80000000);
 CL.AddConstantN('FT_LIST_BY_INDEX','LongWord').SetUInt( $40000000);
 CL.AddConstantN('FT_LIST_ALL','LongWord').SetUInt( $20000000);
 CL.AddConstantN('FT_BAUD_300','LongInt').SetInt( 300);
 CL.AddConstantN('FT_BAUD_600','LongInt').SetInt( 600);
 CL.AddConstantN('FT_BAUD_1200','LongInt').SetInt( 1200);
 CL.AddConstantN('FT_BAUD_2400','LongInt').SetInt( 2400);
 CL.AddConstantN('FT_BAUD_4800','LongInt').SetInt( 4800);
 CL.AddConstantN('FT_BAUD_9600','LongInt').SetInt( 9600);
 CL.AddConstantN('FT_BAUD_14400','LongInt').SetInt( 14400);
 CL.AddConstantN('FT_BAUD_19200','LongInt').SetInt( 19200);
 CL.AddConstantN('FT_BAUD_38400','LongInt').SetInt( 38400);
 CL.AddConstantN('FT_BAUD_57600','LongInt').SetInt( 57600);
 CL.AddConstantN('FT_BAUD_115200','LongInt').SetInt( 115200);
 CL.AddConstantN('FT_BAUD_230400','LongInt').SetInt( 230400);
 CL.AddConstantN('FT_BAUD_460800','LongInt').SetInt( 460800);
 CL.AddConstantN('FT_BAUD_921600','LongInt').SetInt( 921600);
 CL.AddConstantN('FT_DATA_BITS_7','LongInt').SetInt( 7);
 CL.AddConstantN('FT_DATA_BITS_8','LongInt').SetInt( 8);
 CL.AddConstantN('FT_STOP_BITS_1','LongInt').SetInt( 0);
 CL.AddConstantN('FT_STOP_BITS_2','LongInt').SetInt( 2);
 CL.AddConstantN('FT_PARITY_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('FT_PARITY_ODD','LongInt').SetInt( 1);
 CL.AddConstantN('FT_PARITY_EVEN','LongInt').SetInt( 2);
 CL.AddConstantN('FT_PARITY_MARK','LongInt').SetInt( 3);
 CL.AddConstantN('FT_PARITY_SPACE','LongInt').SetInt( 4);
 CL.AddConstantN('FT_FLOW_NONE','LongWord').SetUInt( $0000);
 CL.AddConstantN('FT_FLOW_RTS_CTS','LongWord').SetUInt( $0100);
 CL.AddConstantN('FT_FLOW_DTR_DSR','LongWord').SetUInt( $0200);
 CL.AddConstantN('FT_FLOW_XON_XOFF','LongWord').SetUInt( $0400);
 CL.AddConstantN('FT_PURGE_RX','LongInt').SetInt( 1);
 CL.AddConstantN('FT_PURGE_TX','LongInt').SetInt( 2);
 CL.AddConstantN('FT_EVENT_RXCHAR','LongInt').SetInt( 1);
 CL.AddConstantN('FT_EVENT_MODEM_STATUS','LongInt').SetInt( 2);
 CL.AddConstantN('CTS','LongWord').SetUInt( $10);
 CL.AddConstantN('DSR','LongWord').SetUInt( $20);
 CL.AddConstantN('RI','LongWord').SetUInt( $40);
 CL.AddConstantN('DCD','LongWord').SetUInt( $80);
 CL.AddConstantN('FT_In_Buffer_Size','LongWord').SetUInt( $10000);
 CL.AddConstantN('FT_In_Buffer_Index','LongInt').SetInt($10000 - 1);
 CL.AddConstantN('FT_Out_Buffer_Size','LongWord').SetUInt( $10000);
 CL.AddConstantN('FT_Out_Buffer_Index','LongInt').SetInt($10000 - 1);
 CL.AddConstantN('FT_DLL_Name','String').SetString( 'FTD2XX.DLL');


 { CL.AddTypeS('Float', 'Single');
  CL.AddTypeS('Float', 'Extended');
  CL.AddTypeS('Float', 'Double');
 CL.AddConstantN('Pi','Extended').setExtended( 3.14159265358979323846);
 CL.AddConstantN('Ln2','Extended').setExtended( 0.69314718055994530942);
 CL.AddConstantN('Ln10','Extended').setExtended( 2.30258509299404568402);
 CL.AddConstantN('LnPi','Extended').setExtended( 1.14472988584940017414);
 CL.AddConstantN('InvLn2','Extended').setExtended( 1.44269504088896340736);
 CL.AddConstantN('InvLn10','Extended').setExtended( 0.43429448190325182765);}
 CL.AddConstantN('TwoPi','Extended').setExtended( 6.28318530717958647693);
 CL.AddConstantN('PiDiv2','Extended').setExtended( 1.57079632679489661923);
 CL.AddConstantN('SqrtPi','Extended').setExtended( 1.77245385090551602730);
 CL.AddConstantN('Sqrt2Pi','Extended').setExtended( 2.50662827463100050242);
 CL.AddConstantN('InvSqrt2Pi','Extended').setExtended( 0.39894228040143267794);
 CL.AddConstantN('LnSqrt2Pi','Extended').setExtended( 0.91893853320467274178);
 CL.AddConstantN('Ln2PiDiv2','Extended').setExtended( 0.91893853320467274178);
 CL.AddConstantN('Sqrt2','Extended').setExtended( 1.41421356237309504880);
 CL.AddConstantN('Sqrt2Div2','Extended').setExtended( 0.70710678118654752440);
 CL.AddConstantN('Gold','Extended').setExtended( 1.61803398874989484821);
 CL.AddConstantN('CGold','Extended').setExtended( 0.38196601125010515179);
 CL.AddConstantN('MachEp','Extended').setExtended( 1.192093E-7);
 CL.AddConstantN('MaxNum','Extended').setExtended( 3.402823E+38);
 CL.AddConstantN('MinNum','Extended').setExtended( 1.175495E-38);
 CL.AddConstantN('MaxLog','Extended').setExtended( 88.72283);
 CL.AddConstantN('MinLog','Extended').setExtended( - 87.33655);
 CL.AddConstantN('MaxFac','LongInt').SetInt( 33);
 CL.AddConstantN('MaxGam','Extended').setExtended( 34.648);
 CL.AddConstantN('MaxLgm','Extended').setExtended( 1.0383E+36);
 CL.AddConstantN('MachEp','Extended').setExtended( 2.220446049250313E-16);
 CL.AddConstantN('MaxNum','Extended').setExtended( 1.797693134862315E+308);
 CL.AddConstantN('MinNum','Extended').setExtended( 2.225073858507202E-308);
 CL.AddConstantN('MaxLog','Extended').setExtended( 709.7827128933840);
 CL.AddConstantN('MinLog','Extended').setExtended( - 708.3964185322641);
 CL.AddConstantN('MaxFac','LongInt').SetInt( 170);
 CL.AddConstantN('MaxGam','Extended').setExtended( 171.624376956302);
 CL.AddConstantN('MaxLgm','Extended').setExtended( 2.556348E+305);
 CL.AddConstantN('MachEp','Extended').setExtended( 1.08420217248550444E-19);
 CL.AddConstantN('MaxNum','Extended').setExtended( 5.9486574767861588254E+4931);
 CL.AddConstantN('MinNum','Extended').setExtended( 6.7242062862241870125E-4932);
 CL.AddConstantN('MaxLog','Extended').setExtended( 11355.830259113584004);
 CL.AddConstantN('MinLog','Extended').setExtended( - 11354.443964752464114);
 CL.AddConstantN('MaxFac','LongInt').SetInt( 1754);
 CL.AddConstantN('MaxGam','Extended').setExtended( 1755.455);
 CL.AddConstantN('MaxLgm','Extended').setExtended( 1.04848146839019521E+4928);
 CL.AddConstantN('FOk','LongInt').SetInt( 0);
 CL.AddConstantN('FDomain','LongInt').SetInt( - 1);
 CL.AddConstantN('FSing','LongInt').SetInt( - 2);
 CL.AddConstantN('FOverflow','LongInt').SetInt( - 3);
 CL.AddConstantN('FUnderflow','LongInt').SetInt( - 4);
 CL.AddConstantN('FTLoss','LongInt').SetInt( - 5);
 CL.AddConstantN('FPLoss','LongInt').SetInt( - 6);
 CL.AddConstantN('MatOk','LongInt').SetInt( 0);
 CL.AddConstantN('MatNonConv','LongInt').SetInt( - 1);
 CL.AddConstantN('MatSing','LongInt').SetInt( - 2);
 CL.AddConstantN('MatErrDim','LongInt').SetInt( - 3);
 CL.AddConstantN('MatNotPD','LongInt').SetInt( - 4);
 CL.AddConstantN('OptOk','LongInt').SetInt( 0);
 CL.AddConstantN('OptNonConv','LongInt').SetInt( - 1);
 CL.AddConstantN('OptSing','LongInt').SetInt( - 2);
 CL.AddConstantN('OptBigLambda','LongInt').SetInt( - 5);
 CL.AddConstantN('NLMaxPar','LongInt').SetInt( - 6);
 CL.AddConstantN('NLNullPar','LongInt').SetInt( - 7);
  CL.AddTypeS('Complex', 'record X : Float; Y : Float; end');
 //CL.AddConstantN('MaxSize','LongInt').SetInt( 32767);
 CL.AddConstantN('MaxSize','LongInt').SetInt( 2147483647);
  CL.AddTypeS('TVector', 'array of Float');
  CL.AddTypeS('TIntVector', 'array of Integer');
  CL.AddTypeS('TCompVector', 'array of Complex');
  CL.AddTypeS('TBoolVector', 'array of Boolean');
  CL.AddTypeS('TStrVector', 'array of String');
  CL.AddTypeS('TMatrix', 'array of TVector');
  CL.AddTypeS('TIntMatrix', 'array of TIntVector');
  CL.AddTypeS('TCompMatrix', 'array of TCompVector');
  CL.AddTypeS('TBoolMatrix', 'array of TBoolVector');
  CL.AddTypeS('TStrMatrix', 'array of TStrVector');

  //type TDiffEqs = procedure(X : Float; Y, Yp : TVector);
  CL.AddTypeS('RNG_Type', '( RNG_MWC, RNG_MT, RNG_UVAG )');
  CL.AddTypeS('RNG_IntType', 'Integer');
  CL.AddTypeS('RNG_LongType', 'Cardinal');
  CL.AddTypeS('StatClass', 'record Inf : Float; Sup : Float; N : Integer; F : Float; D : Float; end');
  CL.AddTypeS('TStatClassVector', 'array of StatClass');
  CL.AddTypeS('TRegMode', '( OLS, WLS )');
  CL.AddTypeS('TRegTest', 'record Vr : Float; R2 : Float; R2a : Float; F : Float; Nu1 : integer; Nu2 : Integer; end');
  CL.AddTypeS('TOptAlgo', '( NL_MARQ, NL_SIMP, NL_BFGS, NL_SA, NL_GA )');
  CL.AddTypeS('TMintVar', '( Var_T, Var_S, Var_E )');
  CL.AddTypeS('TScale', '( LinScale, LogScale )');
  CL.AddTypeS('TGrid', '( NoGrid, HorizGrid, VertiGrid, BothGrid )');
  //CL.AddTypeS('Str30', '(String[30];)');

  // Str30  = String[30];

 CL.AddConstantN('MaxArg','LongInt').SetInt( 26);
  CL.AddTypeS('TArgC', 'Integer');
  CL.AddTypeS('TFunc', 'function(X : double): double;)');
  CL.AddTypeS('TEquations', 'procedure(X, F : TVector);)');
 CL.AddTypeS('TJacobian', 'procedure(X : TVector; D : TMatrix);)');
 CL.AddTypeS('TGradient', 'procedure(X, G : TVector);)');
 CL.AddTypeS('THessGrad', 'procedure(X, G : TVector; H : TMatrix);)');
 CL.AddTypeS('TFuncNVar', 'function(X : TVector) : Float;)');
 (*type
  TOptAlgo = (
    NL_MARQ,       { Marquardt algorithm }
    NL_SIMP,       { Simplex algorithm }
    NL_BFGS,       { BFGS algorithm }
    NL_SA,         { Simulated annealing }
    NL_GA);        { Genetic algorithm } *)


 CL.AddTypeS('TRegFunc', 'function(X : Float; B : TVector) : Float;)');
 CL.AddTypeS('TDerivProc', 'procedure(X, Y : Float; B, D : TVector);)');
 CL.AddTypeS('TMintVar', '(Var_T, Var_S, Var_E);)');
 CL.AddTypeS('TDiffEqs', 'procedure(X : Float; Y, Yp : TVector);');

{ Procedure to compute the derivatives of the regression function
  with respect to the regression parameters }
{ Variable of the integrated Michaelis equation:
  Time, Substrate conc., Enzyme conc. }

 //CL.AddTypeS('TArgC', '1..26');
 CL.AddTypeS('TWrapper','function(ArgC : Byte; ArgV : TVector) : Float;)');

 CL.AddDelphiFunction('Procedure SetErrCode( ErrCode : Integer)');
 CL.AddDelphiFunction('Function DefaultVal( ErrCode : Integer; DefVal : Float) : Float');
 CL.AddDelphiFunction('Function MathErr : Integer');
 CL.AddDelphiFunction('Procedure SetAutoInit( AutoInit : Boolean)');
 CL.AddDelphiFunction('Procedure DimVector( var V : TVector; Ub : Integer)');
 CL.AddDelphiFunction('Procedure DimIntVector( var V : TIntVector; Ub : Integer)');
 CL.AddDelphiFunction('Procedure DimCompVector( var V : TCompVector; Ub : Integer)');
 CL.AddDelphiFunction('Procedure DimBoolVector( var V : TBoolVector; Ub : Integer)');
 CL.AddDelphiFunction('Procedure DimStrVector( var V : TStrVector; Ub : Integer)');
 CL.AddDelphiFunction('Procedure DimMatrix( var A : TMatrix; Ub1, Ub2 : Integer)');
 CL.AddDelphiFunction('Procedure DimIntMatrix( var A : TIntMatrix; Ub1, Ub2 : Integer)');
 CL.AddDelphiFunction('Procedure DimCompMatrix( var A : TCompMatrix; Ub1, Ub2 : Integer)');
 CL.AddDelphiFunction('Procedure DimBoolMatrix( var A : TBoolMatrix; Ub1, Ub2 : Integer)');
 CL.AddDelphiFunction('Procedure DimStrMatrix( var A : TStrMatrix; Ub1, Ub2 : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_utypes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetErrCode, 'SetErrCode', cdRegister);
 S.RegisterDelphiFunction(@DefaultVal, 'DefaultVal', cdRegister);
 S.RegisterDelphiFunction(@MathErr, 'MathErr', cdRegister);
 S.RegisterDelphiFunction(@SetAutoInit, 'SetAutoInit', cdRegister);
 S.RegisterDelphiFunction(@DimVector, 'DimVector', cdRegister);
 S.RegisterDelphiFunction(@DimIntVector, 'DimIntVector', cdRegister);
 S.RegisterDelphiFunction(@DimCompVector, 'DimCompVector', cdRegister);
 S.RegisterDelphiFunction(@DimBoolVector, 'DimBoolVector', cdRegister);
 S.RegisterDelphiFunction(@DimStrVector, 'DimStrVector', cdRegister);
 S.RegisterDelphiFunction(@DimMatrix, 'DimMatrix', cdRegister);
 S.RegisterDelphiFunction(@DimIntMatrix, 'DimIntMatrix', cdRegister);
 S.RegisterDelphiFunction(@DimCompMatrix, 'DimCompMatrix', cdRegister);
 S.RegisterDelphiFunction(@DimBoolMatrix, 'DimBoolMatrix', cdRegister);
 S.RegisterDelphiFunction(@DimStrMatrix, 'DimStrMatrix', cdRegister);
end;

 
 
{ TPSImport_utypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_utypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_utypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_utypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_utypes(ri);
  RIRegister_utypes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
