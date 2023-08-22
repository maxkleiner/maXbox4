unit uPSI_XSBuiltIns;
{
  utilities for XML Soap and XML Data
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
  TPSImport_XSBuiltIns = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXMLData(CL: TPSPascalCompiler);
procedure SIRegister_TXSLong(CL: TPSPascalCompiler);
procedure SIRegister_TXSInteger(CL: TPSPascalCompiler);
procedure SIRegister_TXSBoolean(CL: TPSPascalCompiler);
procedure SIRegister_TXSString(CL: TPSPascalCompiler);
procedure SIRegister_TXSDecimal(CL: TPSPascalCompiler);
procedure SIRegister_TXSHexBinary(CL: TPSPascalCompiler);
procedure SIRegister_TXSDuration(CL: TPSPascalCompiler);
procedure SIRegister_TXSDateTime(CL: TPSPascalCompiler);
procedure SIRegister_TXSCustomDateTime(CL: TPSPascalCompiler);
procedure SIRegister_TXSDate(CL: TPSPascalCompiler);
procedure SIRegister_TXSTime(CL: TPSPascalCompiler);
procedure SIRegister_XSBuiltIns(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XSBuiltIns_Routines(S: TPSExec);
procedure RIRegister_TXMLData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSLong(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSInteger(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSBoolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSDecimal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSHexBinary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSDuration(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSDateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSCustomDateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSDate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXSTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_XSBuiltIns(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   InvokeRegistry
  ,FMTBcd
  ,Types
  ,XmlIntf
  ,XSBuiltIns
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XSBuiltIns]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotable', 'TXMLData') do
  with CL.AddClassN(CL.FindClass('TRemotable'),'TXMLData') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function ObjectToSOAP( RootNode, ParentNode : IXMLNode; const ObjConverter : IObjConverter; const Name, URI : InvString; ObjConvOpts : TObjectConvertOptions; out RefID : InvString) : IXMLNode');
    RegisterMethod('Procedure SOAPToObject( const RootNode, Node : IXMLNode; const ObjConverter : IObjConverter)');
    RegisterMethod('Procedure LoadFomXML( const XML : string)');
    RegisterMethod('Procedure LoadFromXML( const XML : WideString)');
    RegisterProperty('XMLNode', 'IXMLNode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSLong(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSLong') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSLong') do
  begin
    RegisterMethod('Function NativeToXS : WideString');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterProperty('AsLong', 'Int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSInteger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSInteger') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSInteger') do
  begin
    RegisterMethod('Function NativeToXS : WideString');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterProperty('AsInteger', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSBoolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSBoolean') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSBoolean') do
  begin
    RegisterMethod('Function NativeToXS : WideString');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterProperty('AsBoolean', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSString') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSString') do
  begin
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterMethod('Function NativeToXS : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSDecimal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSDecimal') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSDecimal') do
  begin
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterMethod('Function NativeToXS : WideString');
    RegisterProperty('DecimalString', 'string', iptrw);
    RegisterProperty('AsBcd', 'TBcd', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSHexBinary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSHexBinary') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSHexBinary') do
  begin
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterMethod('Function NativeToXS : WideString');
    RegisterProperty('HexBinaryString', 'string', iptrw);
    RegisterProperty('AsByteArray', 'TByteDynArray', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSDuration(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXSCustomDateTime', 'TXSDuration') do
  with CL.AddClassN(CL.FindClass('TXSCustomDateTime'),'TXSDuration') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterMethod('Function NativeToXS : WideString');
    RegisterProperty('DecimalSecond', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSDateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXSCustomDateTime', 'TXSDateTime') do
  with CL.AddClassN(CL.FindClass('TXSCustomDateTime'),'TXSDateTime') do
  begin
    RegisterMethod('Function Clone : TXSDateTime');
    RegisterMethod('Function CompareDateTimeParam( const Value1, Value2 : TXSDateTime) : TXSDuration');
    RegisterMethod('Function NativeToXS : WideString');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterProperty('Millisecond', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSCustomDateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSCustomDateTime') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSCustomDateTime') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterProperty('AsDateTime', 'TDateTime', iptrw);
    RegisterProperty('AsUTCDateTime', 'TDateTime', iptrw);
    RegisterProperty('FractionalSeconds', 'Double', iptrw);
    RegisterProperty('Hour', 'Word', iptrw);
    RegisterProperty('HourOffset', 'SmallInt', iptrw);
    RegisterProperty('Minute', 'Word', iptrw);
    RegisterProperty('MinuteOffset', 'SmallInt', iptrw);
    RegisterProperty('Second', 'Word', iptrw);
    RegisterProperty('Month', 'Word', iptrw);
    RegisterProperty('Day', 'Word', iptrw);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterProperty('UseZeroMilliseconds', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSDate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSDate') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSDate') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Month', 'Word', iptrw);
    RegisterProperty('Day', 'Word', iptrw);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterMethod('Function Clone : TXSDate');
    RegisterMethod('Procedure XSToNative( const Value : WideString)');
    RegisterMethod('Procedure XSToNative( Value : WideString)');
    RegisterMethod('Function NativeToXS : WideString');
    RegisterProperty('AsDate', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXSTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRemotableXS', 'TXSTime') do
  with CL.AddClassN(CL.FindClass('TRemotableXS'),'TXSTime') do
  begin
    RegisterProperty('AsTime', 'TDateTime', iptrw);
    RegisterProperty('FractionalSeconds', 'Double', iptrw);
    RegisterProperty('Hour', 'Word', iptrw);
    RegisterProperty('HourOffset', 'SmallInt', iptrw);
    RegisterProperty('Millisecond', 'Word', iptrw);
    RegisterProperty('Minute', 'Word', iptrw);
    RegisterProperty('MinuteOffset', 'SmallInt', iptrw);
    RegisterProperty('Second', 'Word', iptrw);
    RegisterProperty('UseZeroMilliseconds', 'Boolean', iptrw);
    RegisterMethod('Function Clone : TXSTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XSBuiltIns(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SHexMarker','String').SetString( '$');
 CL.AddConstantN('SoapTimePrefix','String').SetString( 'T');
 CL.AddConstantN('XMLDateSeparator','String').SetString( '-');
 CL.AddConstantN('XMLHourOffsetMinusMarker','String').SetString( '-');
 CL.AddConstantN('XMLHourOffsetPlusMarker','String').SetString( '+');
 CL.AddConstantN('XMLTimeSeparator','String').SetString( ':');
 CL.AddConstantN('XMLMonthPos','LongInt').SetInt( 6);
 CL.AddConstantN('XMLDayPos','LongInt').SetInt( 9);
 CL.AddConstantN('XMLYearPos','LongInt').SetInt( 1);
 CL.AddConstantN('XMLMilSecPos','LongInt').SetInt( 10);
 CL.AddConstantN('XMLDefaultYearDigits','LongInt').SetInt( 4);
 CL.AddConstantN('XMLDurationStart','String').SetString( 'P');
 CL.AddConstantN('XMLDurationYear','String').SetString( 'Y');
 CL.AddConstantN('XMLDurationMonth','String').SetString( 'M');
 CL.AddConstantN('XMLDurationDay','String').SetString( 'D');
 CL.AddConstantN('XMLDurationHour','String').SetString( 'H');
 CL.AddConstantN('XMLDurationMinute','String').SetString( 'M');
 CL.AddConstantN('XMLDurationSecond','String').SetString( 'S');
 CL.AddConstantN('SNAN','String').SetString( 'NAN');
 CL.AddConstantN('SSciNotationMarker','Char').SetString( 'E');
 CL.AddConstantN('SDecimal','Char').SetString( '.');
 CL.AddConstantN('SNegative','Char').SetString( '-');
 CL.AddConstantN('SPlus','Char').SetString( '+');
 CL.AddConstantN('SLocalTimeMarker','String').SetString( 'Z');
 CL.AddConstantN('MaxMonth','LongInt').SetInt( 12);
 CL.AddConstantN('MinMonth','LongInt').SetInt( 1);
 CL.AddConstantN('MaxDay','LongInt').SetInt( 31);
 CL.AddConstantN('MinDay','LongInt').SetInt( 1);
 CL.AddConstantN('SoapDecimalSeparator','String').SetString( '.');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXSDuration');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXSTime');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXSDate');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXSDateTime');
  SIRegister_TXSTime(CL);
  SIRegister_TXSDate(CL);
  SIRegister_TXSCustomDateTime(CL);
  SIRegister_TXSDateTime(CL);
  SIRegister_TXSDuration(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXSDateTimeException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXSDecimalException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXSHexBinaryException');
  SIRegister_TXSHexBinary(CL);
  SIRegister_TXSDecimal(CL);
  SIRegister_TXSString(CL);
  CL.AddTypeS('TXSTimeInstant', 'TXSDateTime');
  SIRegister_TXSBoolean(CL);
  SIRegister_TXSInteger(CL);
  SIRegister_TXSLong(CL);
  SIRegister_TXMLData(CL);
 CL.AddDelphiFunction('Function DateTimeToXMLTime( Value : TDateTime; ApplyLocalBias : Boolean) : WideString');
 CL.AddDelphiFunction('Function XMLTimeToDateTime( const XMLDateTime : WideString; AsUTCTime : Boolean) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToXSDateTime( const Value : TDateTime; ApplyLocalBias : Boolean) : TXSDateTime');
 CL.AddDelphiFunction('Function GetDataFromFile( AFileName : string) : string');
 CL.AddDelphiFunction('Function SoapFloatToStr( Value : double) : string');
 CL.AddDelphiFunction('Function SoapStrToFloat( Value : string) : double');
 CL.AddDelphiFunction('Procedure InitXSTypes');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXMLDataXMLNode_R(Self: TXMLData; var T: IXMLNode);
begin T := Self.XMLNode; end;

(*----------------------------------------------------------------------------*)
procedure TXSLongAsLong_W(Self: TXSLong; const T: Int64);
begin Self.AsLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSLongAsLong_R(Self: TXSLong; var T: Int64);
begin T := Self.AsLong; end;

(*----------------------------------------------------------------------------*)
procedure TXSIntegerAsInteger_W(Self: TXSInteger; const T: Integer);
begin Self.AsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSIntegerAsInteger_R(Self: TXSInteger; var T: Integer);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure TXSBooleanAsBoolean_W(Self: TXSBoolean; const T: Boolean);
begin Self.AsBoolean := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSBooleanAsBoolean_R(Self: TXSBoolean; var T: Boolean);
begin T := Self.AsBoolean; end;

(*----------------------------------------------------------------------------*)
procedure TXSDecimalAsBcd_W(Self: TXSDecimal; const T: TBcd);
begin Self.AsBcd := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDecimalAsBcd_R(Self: TXSDecimal; var T: TBcd);
begin T := Self.AsBcd; end;

(*----------------------------------------------------------------------------*)
procedure TXSDecimalDecimalString_W(Self: TXSDecimal; const T: string);
begin Self.DecimalString := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDecimalDecimalString_R(Self: TXSDecimal; var T: string);
begin T := Self.DecimalString; end;

(*----------------------------------------------------------------------------*)
procedure TXSHexBinaryAsByteArray_W(Self: TXSHexBinary; const T: TByteDynArray);
begin Self.AsByteArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSHexBinaryAsByteArray_R(Self: TXSHexBinary; var T: TByteDynArray);
begin T := Self.AsByteArray; end;

(*----------------------------------------------------------------------------*)
procedure TXSHexBinaryHexBinaryString_W(Self: TXSHexBinary; const T: string);
begin Self.HexBinaryString := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSHexBinaryHexBinaryString_R(Self: TXSHexBinary; var T: string);
begin T := Self.HexBinaryString; end;

(*----------------------------------------------------------------------------*)
procedure TXSDurationDecimalSecond_W(Self: TXSDuration; const T: Double);
begin Self.DecimalSecond := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDurationDecimalSecond_R(Self: TXSDuration; var T: Double);
begin T := Self.DecimalSecond; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateTimeMillisecond_W(Self: TXSDateTime; const T: Word);
begin Self.Millisecond := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateTimeMillisecond_R(Self: TXSDateTime; var T: Word);
begin T := Self.Millisecond; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeUseZeroMilliseconds_W(Self: TXSCustomDateTime; const T: Boolean);
begin Self.UseZeroMilliseconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeUseZeroMilliseconds_R(Self: TXSCustomDateTime; var T: Boolean);
begin T := Self.UseZeroMilliseconds; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeYear_W(Self: TXSCustomDateTime; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeYear_R(Self: TXSCustomDateTime; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeDay_W(Self: TXSCustomDateTime; const T: Word);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeDay_R(Self: TXSCustomDateTime; var T: Word);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMonth_W(Self: TXSCustomDateTime; const T: Word);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMonth_R(Self: TXSCustomDateTime; var T: Word);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeSecond_W(Self: TXSCustomDateTime; const T: Word);
begin Self.Second := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeSecond_R(Self: TXSCustomDateTime; var T: Word);
begin T := Self.Second; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMinuteOffset_W(Self: TXSCustomDateTime; const T: SmallInt);
begin Self.MinuteOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMinuteOffset_R(Self: TXSCustomDateTime; var T: SmallInt);
begin T := Self.MinuteOffset; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMinute_W(Self: TXSCustomDateTime; const T: Word);
begin Self.Minute := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeMinute_R(Self: TXSCustomDateTime; var T: Word);
begin T := Self.Minute; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeHourOffset_W(Self: TXSCustomDateTime; const T: SmallInt);
begin Self.HourOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeHourOffset_R(Self: TXSCustomDateTime; var T: SmallInt);
begin T := Self.HourOffset; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeHour_W(Self: TXSCustomDateTime; const T: Word);
begin Self.Hour := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeHour_R(Self: TXSCustomDateTime; var T: Word);
begin T := Self.Hour; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeFractionalSeconds_W(Self: TXSCustomDateTime; const T: Double);
begin Self.FractionalSeconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeFractionalSeconds_R(Self: TXSCustomDateTime; var T: Double);
begin T := Self.FractionalSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeAsUTCDateTime_W(Self: TXSCustomDateTime; const T: TDateTime);
begin Self.AsUTCDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeAsUTCDateTime_R(Self: TXSCustomDateTime; var T: TDateTime);
begin T := Self.AsUTCDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeAsDateTime_W(Self: TXSCustomDateTime; const T: TDateTime);
begin Self.AsDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSCustomDateTimeAsDateTime_R(Self: TXSCustomDateTime; var T: TDateTime);
begin T := Self.AsDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateAsDate_W(Self: TXSDate; const T: TDateTime);
begin Self.AsDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateAsDate_R(Self: TXSDate; var T: TDateTime);
begin T := Self.AsDate; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateYear_W(Self: TXSDate; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateYear_R(Self: TXSDate; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateDay_W(Self: TXSDate; const T: Word);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateDay_R(Self: TXSDate; var T: Word);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateMonth_W(Self: TXSDate; const T: Word);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSDateMonth_R(Self: TXSDate; var T: Word);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeUseZeroMilliseconds_W(Self: TXSTime; const T: Boolean);
begin Self.UseZeroMilliseconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeUseZeroMilliseconds_R(Self: TXSTime; var T: Boolean);
begin T := Self.UseZeroMilliseconds; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeSecond_W(Self: TXSTime; const T: Word);
begin Self.Second := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeSecond_R(Self: TXSTime; var T: Word);
begin T := Self.Second; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMinuteOffset_W(Self: TXSTime; const T: SmallInt);
begin Self.MinuteOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMinuteOffset_R(Self: TXSTime; var T: SmallInt);
begin T := Self.MinuteOffset; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMinute_W(Self: TXSTime; const T: Word);
begin Self.Minute := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMinute_R(Self: TXSTime; var T: Word);
begin T := Self.Minute; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMillisecond_W(Self: TXSTime; const T: Word);
begin Self.Millisecond := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeMillisecond_R(Self: TXSTime; var T: Word);
begin T := Self.Millisecond; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeHourOffset_W(Self: TXSTime; const T: SmallInt);
begin Self.HourOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeHourOffset_R(Self: TXSTime; var T: SmallInt);
begin T := Self.HourOffset; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeHour_W(Self: TXSTime; const T: Word);
begin Self.Hour := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeHour_R(Self: TXSTime; var T: Word);
begin T := Self.Hour; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeFractionalSeconds_W(Self: TXSTime; const T: Double);
begin Self.FractionalSeconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeFractionalSeconds_R(Self: TXSTime; var T: Double);
begin T := Self.FractionalSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeAsTime_W(Self: TXSTime; const T: TDateTime);
begin Self.AsTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXSTimeAsTime_R(Self: TXSTime; var T: TDateTime);
begin T := Self.AsTime; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XSBuiltIns_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DateTimeToXMLTime, 'DateTimeToXMLTime', cdRegister);
 S.RegisterDelphiFunction(@XMLTimeToDateTime, 'XMLTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToXSDateTime, 'DateTimeToXSDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetDataFromFile, 'GetDataFromFile', cdRegister);
 S.RegisterDelphiFunction(@SoapFloatToStr, 'SoapFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@SoapStrToFloat, 'SoapStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@InitXSTypes, 'InitXSTypes', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLData) do begin
    RegisterConstructor(@TXMLData.Create, 'Create');
    RegisterMethod(@TXMLData.Destroy, 'Free');
     RegisterMethod(@TXMLData.ObjectToSOAP, 'ObjectToSOAP');
    RegisterMethod(@TXMLData.SOAPToObject, 'SOAPToObject');
    RegisterMethod(@TXMLData.LoadFomXML, 'LoadFomXML');
    RegisterMethod(@TXMLData.LoadFromXML, 'LoadFromXML');
    RegisterPropertyHelper(@TXMLDataXMLNode_R,nil,'XMLNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSLong(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSLong) do
  begin
    RegisterMethod(@TXSLong.NativeToXS, 'NativeToXS');
    RegisterMethod(@TXSLong.XSToNative, 'XSToNative');
    RegisterMethod(@TXSLong.XSToNative, 'XSToNative');
    RegisterPropertyHelper(@TXSLongAsLong_R,@TXSLongAsLong_W,'AsLong');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSInteger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSInteger) do
  begin
    RegisterMethod(@TXSInteger.NativeToXS, 'NativeToXS');
    RegisterMethod(@TXSInteger.XSToNative, 'XSToNative');
    RegisterMethod(@TXSInteger.XSToNative, 'XSToNative');
    RegisterPropertyHelper(@TXSIntegerAsInteger_R,@TXSIntegerAsInteger_W,'AsInteger');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSBoolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSBoolean) do
  begin
    RegisterMethod(@TXSBoolean.NativeToXS, 'NativeToXS');
    RegisterMethod(@TXSBoolean.XSToNative, 'XSToNative');
    RegisterMethod(@TXSBoolean.XSToNative, 'XSToNative');
    RegisterPropertyHelper(@TXSBooleanAsBoolean_R,@TXSBooleanAsBoolean_W,'AsBoolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSString) do
  begin
    RegisterMethod(@TXSString.XSToNative, 'XSToNative');
    RegisterMethod(@TXSString.XSToNative, 'XSToNative');
    RegisterMethod(@TXSString.NativeToXS, 'NativeToXS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSDecimal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSDecimal) do
  begin
    RegisterMethod(@TXSDecimal.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDecimal.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDecimal.NativeToXS, 'NativeToXS');
    RegisterPropertyHelper(@TXSDecimalDecimalString_R,@TXSDecimalDecimalString_W,'DecimalString');
    RegisterPropertyHelper(@TXSDecimalAsBcd_R,@TXSDecimalAsBcd_W,'AsBcd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSHexBinary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSHexBinary) do
  begin
    RegisterMethod(@TXSHexBinary.XSToNative, 'XSToNative');
    RegisterMethod(@TXSHexBinary.XSToNative, 'XSToNative');
    RegisterMethod(@TXSHexBinary.NativeToXS, 'NativeToXS');
    RegisterPropertyHelper(@TXSHexBinaryHexBinaryString_R,@TXSHexBinaryHexBinaryString_W,'HexBinaryString');
    RegisterPropertyHelper(@TXSHexBinaryAsByteArray_R,@TXSHexBinaryAsByteArray_W,'AsByteArray');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSDuration(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSDuration) do
  begin
    RegisterConstructor(@TXSDuration.Create, 'Create');
    RegisterMethod(@TXSDuration.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDuration.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDuration.NativeToXS, 'NativeToXS');
    RegisterPropertyHelper(@TXSDurationDecimalSecond_R,@TXSDurationDecimalSecond_W,'DecimalSecond');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSDateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSDateTime) do
  begin
    RegisterMethod(@TXSDateTime.Clone, 'Clone');
    RegisterMethod(@TXSDateTime.CompareDateTimeParam, 'CompareDateTimeParam');
    RegisterMethod(@TXSDateTime.NativeToXS, 'NativeToXS');
    RegisterMethod(@TXSDateTime.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDateTime.XSToNative, 'XSToNative');
    RegisterPropertyHelper(@TXSDateTimeMillisecond_R,@TXSDateTimeMillisecond_W,'Millisecond');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSCustomDateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSCustomDateTime) do begin
    RegisterConstructor(@TXSCustomDateTime.Create, 'Create');
    RegisterMethod(@TXSCustomDateTime.Destroy, 'Free');
     RegisterPropertyHelper(@TXSCustomDateTimeAsDateTime_R,@TXSCustomDateTimeAsDateTime_W,'AsDateTime');
    RegisterPropertyHelper(@TXSCustomDateTimeAsUTCDateTime_R,@TXSCustomDateTimeAsUTCDateTime_W,'AsUTCDateTime');
    RegisterPropertyHelper(@TXSCustomDateTimeFractionalSeconds_R,@TXSCustomDateTimeFractionalSeconds_W,'FractionalSeconds');
    RegisterPropertyHelper(@TXSCustomDateTimeHour_R,@TXSCustomDateTimeHour_W,'Hour');
    RegisterPropertyHelper(@TXSCustomDateTimeHourOffset_R,@TXSCustomDateTimeHourOffset_W,'HourOffset');
    RegisterPropertyHelper(@TXSCustomDateTimeMinute_R,@TXSCustomDateTimeMinute_W,'Minute');
    RegisterPropertyHelper(@TXSCustomDateTimeMinuteOffset_R,@TXSCustomDateTimeMinuteOffset_W,'MinuteOffset');
    RegisterPropertyHelper(@TXSCustomDateTimeSecond_R,@TXSCustomDateTimeSecond_W,'Second');
    RegisterPropertyHelper(@TXSCustomDateTimeMonth_R,@TXSCustomDateTimeMonth_W,'Month');
    RegisterPropertyHelper(@TXSCustomDateTimeDay_R,@TXSCustomDateTimeDay_W,'Day');
    RegisterPropertyHelper(@TXSCustomDateTimeYear_R,@TXSCustomDateTimeYear_W,'Year');
    RegisterPropertyHelper(@TXSCustomDateTimeUseZeroMilliseconds_R,@TXSCustomDateTimeUseZeroMilliseconds_W,'UseZeroMilliseconds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSDate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSDate) do
  begin
    RegisterConstructor(@TXSDate.Create, 'Create');
    RegisterPropertyHelper(@TXSDateMonth_R,@TXSDateMonth_W,'Month');
    RegisterPropertyHelper(@TXSDateDay_R,@TXSDateDay_W,'Day');
    RegisterPropertyHelper(@TXSDateYear_R,@TXSDateYear_W,'Year');
    RegisterMethod(@TXSDate.Clone, 'Clone');
    RegisterMethod(@TXSDate.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDate.XSToNative, 'XSToNative');
    RegisterMethod(@TXSDate.NativeToXS, 'NativeToXS');
    RegisterPropertyHelper(@TXSDateAsDate_R,@TXSDateAsDate_W,'AsDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXSTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSTime) do
  begin
    RegisterPropertyHelper(@TXSTimeAsTime_R,@TXSTimeAsTime_W,'AsTime');
    RegisterPropertyHelper(@TXSTimeFractionalSeconds_R,@TXSTimeFractionalSeconds_W,'FractionalSeconds');
    RegisterPropertyHelper(@TXSTimeHour_R,@TXSTimeHour_W,'Hour');
    RegisterPropertyHelper(@TXSTimeHourOffset_R,@TXSTimeHourOffset_W,'HourOffset');
    RegisterPropertyHelper(@TXSTimeMillisecond_R,@TXSTimeMillisecond_W,'Millisecond');
    RegisterPropertyHelper(@TXSTimeMinute_R,@TXSTimeMinute_W,'Minute');
    RegisterPropertyHelper(@TXSTimeMinuteOffset_R,@TXSTimeMinuteOffset_W,'MinuteOffset');
    RegisterPropertyHelper(@TXSTimeSecond_R,@TXSTimeSecond_W,'Second');
    RegisterPropertyHelper(@TXSTimeUseZeroMilliseconds_R,@TXSTimeUseZeroMilliseconds_W,'UseZeroMilliseconds');
    RegisterMethod(@TXSTime.Clone, 'Clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XSBuiltIns(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXSDuration) do
  with CL.Add(TXSTime) do
  with CL.Add(TXSDate) do
  with CL.Add(TXSDateTime) do
  RIRegister_TXSTime(CL);
  RIRegister_TXSDate(CL);
  RIRegister_TXSCustomDateTime(CL);
  RIRegister_TXSDateTime(CL);
  RIRegister_TXSDuration(CL);
  with CL.Add(EXSDateTimeException) do
  with CL.Add(EXSDecimalException) do
  with CL.Add(EXSHexBinaryException) do
  RIRegister_TXSHexBinary(CL);
  RIRegister_TXSDecimal(CL);
  RIRegister_TXSString(CL);
  RIRegister_TXSBoolean(CL);
  RIRegister_TXSInteger(CL);
  RIRegister_TXSLong(CL);
  RIRegister_TXMLData(CL);
end;

 
 
{ TPSImport_XSBuiltIns }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XSBuiltIns.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XSBuiltIns(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XSBuiltIns.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XSBuiltIns(ri);
  RIRegister_XSBuiltIns_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
