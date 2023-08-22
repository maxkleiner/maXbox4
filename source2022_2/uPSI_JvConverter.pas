unit uPSI_JvConverter;
{
   more space in time
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
  TPSImport_JvConverter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvConverter(CL: TPSPascalCompiler);
procedure SIRegister_TJvDateTimeFormat(CL: TPSPascalCompiler);
procedure SIRegister_JvConverter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvConverter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDateTimeFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvConverter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvComponentBase
  ,JvTypes
  ,JvConverter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvConverter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvConverter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvConverter') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvConverter2') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IsValidChar( Ch : Char) : Boolean');
    RegisterProperty('AsBoolean', 'Boolean', iptrw);
    RegisterProperty('AsDateTime', 'TDateTime', iptrw);
    RegisterProperty('AsDate', 'TDateTime', iptrw);
    RegisterProperty('AsTime', 'TDateTime', iptrw);
    RegisterProperty('AsFloat', 'Double', iptrw);
    RegisterProperty('AsInteger', 'Longint', iptrw);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('DataType', 'TDataType', iptrw);
    RegisterProperty('DateTimeFormat', 'TJvDateTimeFormat', iptrw);
    RegisterProperty('Digits', 'Integer', iptrw);
    RegisterProperty('DisplayFalse', 'string', iptrw);
    RegisterProperty('DisplayTrue', 'string', iptrw);
    RegisterProperty('FloatFormat', 'TFloatFormat', iptrw);
    RegisterProperty('Precision', 'Integer', iptrw);
    RegisterProperty('RaiseOnError', 'Boolean', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDateTimeFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvDateTimeFormat') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvDateTimeFormat2') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure ResetDefault');
    RegisterProperty('DateMask', 'string', iptr);
    RegisterProperty('TimeMask', 'string', iptr);
    RegisterProperty('Mask', 'string', iptr);
    RegisterProperty('AMString', 'string', iptrw);
    RegisterProperty('PMString', 'string', iptrw);
    RegisterProperty('DateOrder', 'TDateOrder', iptrw);
    RegisterProperty('TimeFormat', 'TTimeFormat', iptrw);
    RegisterProperty('TimeSeparator', 'Char', iptrw);
    RegisterProperty('DateSeparator', 'Char', iptrw);
    RegisterProperty('LongDate', 'Boolean', iptrw);
    RegisterProperty('FourDigitYear', 'Boolean', iptrw);
    RegisterProperty('LeadingZero', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvConverter(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDataType', '( dtString, dtInteger, dtFloat, dtDateTime, dtDate,'
   +' dtTime, dtBoolean )');
  CL.AddTypeS('TTimeFormat', '( tfHHMMSS, tfHMMSS, tfHHMM, tfHMM )');
  SIRegister_TJvDateTimeFormat(CL);
  SIRegister_TJvConverter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvConverterOnChange_W(Self: TJvConverter; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterOnChange_R(Self: TJvConverter; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterText_W(Self: TJvConverter; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterText_R(Self: TJvConverter; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterRaiseOnError_W(Self: TJvConverter; const T: Boolean);
begin Self.RaiseOnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterRaiseOnError_R(Self: TJvConverter; var T: Boolean);
begin T := Self.RaiseOnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterPrecision_W(Self: TJvConverter; const T: Integer);
begin Self.Precision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterPrecision_R(Self: TJvConverter; var T: Integer);
begin T := Self.Precision; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterFloatFormat_W(Self: TJvConverter; const T: TFloatFormat);
begin Self.FloatFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterFloatFormat_R(Self: TJvConverter; var T: TFloatFormat);
begin T := Self.FloatFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDisplayTrue_W(Self: TJvConverter; const T: string);
begin Self.DisplayTrue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDisplayTrue_R(Self: TJvConverter; var T: string);
begin T := Self.DisplayTrue; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDisplayFalse_W(Self: TJvConverter; const T: string);
begin Self.DisplayFalse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDisplayFalse_R(Self: TJvConverter; var T: string);
begin T := Self.DisplayFalse; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDigits_W(Self: TJvConverter; const T: Integer);
begin Self.Digits := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDigits_R(Self: TJvConverter; var T: Integer);
begin T := Self.Digits; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDateTimeFormat_W(Self: TJvConverter; const T: TJvDateTimeFormat);
begin Self.DateTimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDateTimeFormat_R(Self: TJvConverter; var T: TJvDateTimeFormat);
begin T := Self.DateTimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDataType_W(Self: TJvConverter; const T: TDataType);
begin Self.DataType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterDataType_R(Self: TJvConverter; var T: TDataType);
begin T := Self.DataType; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsString_W(Self: TJvConverter; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsString_R(Self: TJvConverter; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsInteger_W(Self: TJvConverter; const T: Longint);
begin Self.AsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsInteger_R(Self: TJvConverter; var T: Longint);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsFloat_W(Self: TJvConverter; const T: Double);
begin Self.AsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsFloat_R(Self: TJvConverter; var T: Double);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsTime_W(Self: TJvConverter; const T: TDateTime);
begin Self.AsTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsTime_R(Self: TJvConverter; var T: TDateTime);
begin T := Self.AsTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsDate_W(Self: TJvConverter; const T: TDateTime);
begin Self.AsDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsDate_R(Self: TJvConverter; var T: TDateTime);
begin T := Self.AsDate; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsDateTime_W(Self: TJvConverter; const T: TDateTime);
begin Self.AsDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsDateTime_R(Self: TJvConverter; var T: TDateTime);
begin T := Self.AsDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsBoolean_W(Self: TJvConverter; const T: Boolean);
begin Self.AsBoolean := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvConverterAsBoolean_R(Self: TJvConverter; var T: Boolean);
begin T := Self.AsBoolean; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatLeadingZero_W(Self: TJvDateTimeFormat; const T: Boolean);
begin Self.LeadingZero := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatLeadingZero_R(Self: TJvDateTimeFormat; var T: Boolean);
begin T := Self.LeadingZero; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatFourDigitYear_W(Self: TJvDateTimeFormat; const T: Boolean);
begin Self.FourDigitYear := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatFourDigitYear_R(Self: TJvDateTimeFormat; var T: Boolean);
begin T := Self.FourDigitYear; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatLongDate_W(Self: TJvDateTimeFormat; const T: Boolean);
begin Self.LongDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatLongDate_R(Self: TJvDateTimeFormat; var T: Boolean);
begin T := Self.LongDate; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatDateSeparator_W(Self: TJvDateTimeFormat; const T: Char);
begin Self.DateSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatDateSeparator_R(Self: TJvDateTimeFormat; var T: Char);
begin T := Self.DateSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatTimeSeparator_W(Self: TJvDateTimeFormat; const T: Char);
begin Self.TimeSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatTimeSeparator_R(Self: TJvDateTimeFormat; var T: Char);
begin T := Self.TimeSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatTimeFormat_W(Self: TJvDateTimeFormat; const T: TTimeFormat);
begin Self.TimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatTimeFormat_R(Self: TJvDateTimeFormat; var T: TTimeFormat);
begin T := Self.TimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatDateOrder_W(Self: TJvDateTimeFormat; const T: TDateOrder);
begin Self.DateOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatDateOrder_R(Self: TJvDateTimeFormat; var T: TDateOrder);
begin T := Self.DateOrder; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatPMString_W(Self: TJvDateTimeFormat; const T: string);
begin Self.PMString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatPMString_R(Self: TJvDateTimeFormat; var T: string);
begin T := Self.PMString; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatAMString_W(Self: TJvDateTimeFormat; const T: string);
begin Self.AMString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatAMString_R(Self: TJvDateTimeFormat; var T: string);
begin T := Self.AMString; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatMask_R(Self: TJvDateTimeFormat; var T: string);
begin T := Self.Mask; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatTimeMask_R(Self: TJvDateTimeFormat; var T: string);
begin T := Self.TimeMask; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimeFormatDateMask_R(Self: TJvDateTimeFormat; var T: string);
begin T := Self.DateMask; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvConverter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvConverter) do begin
    RegisterConstructor(@TJvConverter.Create, 'Create');
    RegisterMethod(@TJvConverter.Destroy, 'Free');
    RegisterMethod(@TJvConverter.Clear, 'Clear');
    RegisterVirtualMethod(@TJvConverter.IsValidChar, 'IsValidChar');
    RegisterPropertyHelper(@TJvConverterAsBoolean_R,@TJvConverterAsBoolean_W,'AsBoolean');
    RegisterPropertyHelper(@TJvConverterAsDateTime_R,@TJvConverterAsDateTime_W,'AsDateTime');
    RegisterPropertyHelper(@TJvConverterAsDate_R,@TJvConverterAsDate_W,'AsDate');
    RegisterPropertyHelper(@TJvConverterAsTime_R,@TJvConverterAsTime_W,'AsTime');
    RegisterPropertyHelper(@TJvConverterAsFloat_R,@TJvConverterAsFloat_W,'AsFloat');
    RegisterPropertyHelper(@TJvConverterAsInteger_R,@TJvConverterAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TJvConverterAsString_R,@TJvConverterAsString_W,'AsString');
    RegisterPropertyHelper(@TJvConverterDataType_R,@TJvConverterDataType_W,'DataType');
    RegisterPropertyHelper(@TJvConverterDateTimeFormat_R,@TJvConverterDateTimeFormat_W,'DateTimeFormat');
    RegisterPropertyHelper(@TJvConverterDigits_R,@TJvConverterDigits_W,'Digits');
    RegisterPropertyHelper(@TJvConverterDisplayFalse_R,@TJvConverterDisplayFalse_W,'DisplayFalse');
    RegisterPropertyHelper(@TJvConverterDisplayTrue_R,@TJvConverterDisplayTrue_W,'DisplayTrue');
    RegisterPropertyHelper(@TJvConverterFloatFormat_R,@TJvConverterFloatFormat_W,'FloatFormat');
    RegisterPropertyHelper(@TJvConverterPrecision_R,@TJvConverterPrecision_W,'Precision');
    RegisterPropertyHelper(@TJvConverterRaiseOnError_R,@TJvConverterRaiseOnError_W,'RaiseOnError');
    RegisterPropertyHelper(@TJvConverterText_R,@TJvConverterText_W,'Text');
    RegisterPropertyHelper(@TJvConverterOnChange_R,@TJvConverterOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDateTimeFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDateTimeFormat) do begin
    RegisterConstructor(@TJvDateTimeFormat.Create, 'Create');
    RegisterMethod(@TJvDateTimeFormat.Destroy, 'Free');
    RegisterMethod(@TJvDateTimeFormat.Assign, 'Assign');
    RegisterVirtualMethod(@TJvDateTimeFormat.ResetDefault, 'ResetDefault');
    RegisterPropertyHelper(@TJvDateTimeFormatDateMask_R,nil,'DateMask');
    RegisterPropertyHelper(@TJvDateTimeFormatTimeMask_R,nil,'TimeMask');
    RegisterPropertyHelper(@TJvDateTimeFormatMask_R,nil,'Mask');
    RegisterPropertyHelper(@TJvDateTimeFormatAMString_R,@TJvDateTimeFormatAMString_W,'AMString');
    RegisterPropertyHelper(@TJvDateTimeFormatPMString_R,@TJvDateTimeFormatPMString_W,'PMString');
    RegisterPropertyHelper(@TJvDateTimeFormatDateOrder_R,@TJvDateTimeFormatDateOrder_W,'DateOrder');
    RegisterPropertyHelper(@TJvDateTimeFormatTimeFormat_R,@TJvDateTimeFormatTimeFormat_W,'TimeFormat');
    RegisterPropertyHelper(@TJvDateTimeFormatTimeSeparator_R,@TJvDateTimeFormatTimeSeparator_W,'TimeSeparator');
    RegisterPropertyHelper(@TJvDateTimeFormatDateSeparator_R,@TJvDateTimeFormatDateSeparator_W,'DateSeparator');
    RegisterPropertyHelper(@TJvDateTimeFormatLongDate_R,@TJvDateTimeFormatLongDate_W,'LongDate');
    RegisterPropertyHelper(@TJvDateTimeFormatFourDigitYear_R,@TJvDateTimeFormatFourDigitYear_W,'FourDigitYear');
    RegisterPropertyHelper(@TJvDateTimeFormatLeadingZero_R,@TJvDateTimeFormatLeadingZero_W,'LeadingZero');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvConverter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDateTimeFormat(CL);
  RIRegister_TJvConverter(CL);
end;

 
 
{ TPSImport_JvConverter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvConverter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvConverter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvConverter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvConverter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
