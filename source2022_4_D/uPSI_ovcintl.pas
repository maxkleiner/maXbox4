unit uPSI_ovcintl;
{
  datetimeclass
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
  TPSImport_ovcintl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcIntlSup(CL: TPSPascalCompiler);
procedure SIRegister_ovcintl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcIntlSup(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcintl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,Forms
  ,Messages
  ,OvcConst
  ,OvcData
  ,OvcStr
  ,OvcDate
  ,ovcintl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcintl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcIntlSup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOvcIntlSup') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOvcIntlSup') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function CurrentDateString( const Picture : string; Pack : Boolean) : string');
    RegisterMethod('Function CurrentDatePChar( Dest : PChar; Picture : PChar; Pack : Boolean) : PChar');
    RegisterMethod('Function CurrentTimeString( const Picture : string; Pack : Boolean) : string');
    RegisterMethod('Function CurrentTimePChar( Dest : PChar; Picture : PChar; Pack : Boolean) : PChar');
    RegisterMethod('Function DateToDateString( const Picture : string; Julian : TStDate; Pack : Boolean) : string');
    RegisterMethod('Function DateToDatePChar( Dest : PChar; Picture : PChar; Julian : TStDate; Pack : Boolean) : PChar');
    RegisterMethod('Function DateTimeToDatePChar( Dest : PChar; Picture : PChar; DT : TDateTime; Pack : Boolean) : PChar');
    RegisterMethod('Function DateStringToDMY( const Picture, S : string; var Day, Month, Year : Integer; Epoch : Integer) : Boolean');
    RegisterMethod('Function DatePCharToDMY( Picture, S : PChar; var Day, Month, Year : Integer; Epoch : Integer) : Boolean');
    RegisterMethod('Function DateStringIsBlank( const Picture, S : string) : Boolean');
    RegisterMethod('Function DatePCharIsBlank( Picture, S : PChar) : Boolean');
    RegisterMethod('Function DateStringToDate( const Picture, S : string; Epoch : Integer) : TStDate');
    RegisterMethod('Function DatePCharToDate( Picture, S : PChar; Epoch : Integer) : TStDate');
    RegisterMethod('Function DayOfWeekToString( WeekDay : TDayType) : string');
    RegisterMethod('Function DayOfWeekToPChar( Dest : PChar; WeekDay : TDayType) : PChar');
    RegisterMethod('Function DMYtoDateString( const Picture : string; Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : string');
    RegisterMethod('Function DMYtoDatePChar( Dest : PChar; Picture : PChar; Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : PChar');
    RegisterMethod('Function InternationalCurrency( FormChar : Char; MaxDigits : Byte; Float, AddCommas, IsNumeric : Boolean) : string');
    RegisterMethod('Function InternationalCurrencyPChar( Dest : PChar; FormChar : Char; MaxDigits : Byte; Float, AddCommas, IsNumeric : Boolean) : PChar');
    RegisterMethod('Function InternationalDate( ForceCentury : Boolean) : string');
    RegisterMethod('Function InternationalDatePChar( Dest : PChar; ForceCentury : Boolean) : PChar');
    RegisterMethod('Function InternationalLongDate( ShortNames : Boolean; ExcludeDOW : Boolean) : string');
    RegisterMethod('Function InternationalLongDatePChar( Dest : PChar; ShortNames : Boolean; ExcludeDOW : Boolean) : PChar');
    RegisterMethod('Function InternationalTime( ShowSeconds : Boolean) : string');
    RegisterMethod('Function InternationalTimePChar( Dest : PChar; ShowSeconds : Boolean) : PChar');
    RegisterMethod('Function MonthStringToMonth( const S : string; Width : Byte) : Byte');
    RegisterMethod('Function MonthPCharToMonth( S : PChar; Width : Byte) : Byte');
    RegisterMethod('Function MonthToString( Month : Integer) : string');
    RegisterMethod('Function MonthToPChar( Dest : PChar; Month : Integer) : PChar');
    RegisterMethod('Procedure ResetInternationalInfo');
    RegisterMethod('Function TimeStringToHMS( const Picture, S : string; var Hour, Minute, Second : Integer) : Boolean');
    RegisterMethod('Function TimePCharToHMS( Picture, S : PChar; var Hour, Minute, Second : Integer) : Boolean');
    RegisterMethod('Function TimeStringToTime( const Picture, S : string) : TStTime');
    RegisterMethod('Function TimePCharToTime( Picture, S : PChar) : TStTime');
    RegisterMethod('Function TimeToTimeString( const Picture : string; T : TStTime; Pack : Boolean) : string');
    RegisterMethod('Function TimeToTimePChar( Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar');
    RegisterMethod('Function TimeToAmPmString( const Picture : string; T : TStTime; Pack : Boolean) : string');
    RegisterMethod('Function TimeToAmPmPChar( Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar');
    RegisterProperty('AutoUpdate', 'Boolean', iptrw);
    RegisterProperty('CurrencyLtStr', 'string', iptrw);
    RegisterProperty('CurrencyRtStr', 'string', iptrw);
    RegisterProperty('DecimalChar', 'Char', iptrw);
    RegisterProperty('CommaChar', 'Char', iptrw);
    RegisterProperty('Country', 'string', iptr);
    RegisterProperty('CurrencyDigits', 'Byte', iptrw);
    RegisterProperty('ListChar', 'Char', iptrw);
    RegisterProperty('SlashChar', 'Char', iptrw);
    RegisterProperty('TrueChar', 'Char', iptrw);
    RegisterProperty('FalseChar', 'Char', iptrw);
    RegisterProperty('YesChar', 'Char', iptrw);
    RegisterProperty('NoChar', 'Char', iptrw);
    RegisterProperty('OnWinIniChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcintl(CL: TPSPascalCompiler);
begin
  //TCurrencySt = array[0..5] of Char;
 CL.AddTypeS('TCurrencySt', 'array[0..5] of Char;');
  CL.AddTypeS('TIntlData', 'record CurrencyLtStr : TCurrencySt; CurrencyRtStr :'
   +' TCurrencySt; DecimalChar : Char; CommaChar : Char; CurrDigits : Byte; Sla'
   +'shChar : Char; TrueChar: Char; FalseChar: Char; YesChar: Char; NoChar: Char; end');
  SIRegister_TOvcIntlSup(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupOnWinIniChange_W(Self: TOvcIntlSup; const T: TNotifyEvent);
begin Self.OnWinIniChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupOnWinIniChange_R(Self: TOvcIntlSup; var T: TNotifyEvent);
begin T := Self.OnWinIniChange; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupNoChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.NoChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupNoChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.NoChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupYesChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.YesChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupYesChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.YesChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupFalseChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.FalseChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupFalseChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.FalseChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupTrueChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.TrueChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupTrueChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.TrueChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupSlashChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.SlashChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupSlashChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.SlashChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupListChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.ListChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupListChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.ListChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyDigits_W(Self: TOvcIntlSup; const T: Byte);
begin Self.CurrencyDigits := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyDigits_R(Self: TOvcIntlSup; var T: Byte);
begin T := Self.CurrencyDigits; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCountry_R(Self: TOvcIntlSup; var T: string);
begin T := Self.Country; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCommaChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.CommaChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCommaChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.CommaChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupDecimalChar_W(Self: TOvcIntlSup; const T: Char);
begin Self.DecimalChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupDecimalChar_R(Self: TOvcIntlSup; var T: Char);
begin T := Self.DecimalChar; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyRtStr_W(Self: TOvcIntlSup; const T: string);
begin Self.CurrencyRtStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyRtStr_R(Self: TOvcIntlSup; var T: string);
begin T := Self.CurrencyRtStr; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyLtStr_W(Self: TOvcIntlSup; const T: string);
begin Self.CurrencyLtStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupCurrencyLtStr_R(Self: TOvcIntlSup; var T: string);
begin T := Self.CurrencyLtStr; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupAutoUpdate_W(Self: TOvcIntlSup; const T: Boolean);
begin Self.AutoUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIntlSupAutoUpdate_R(Self: TOvcIntlSup; var T: Boolean);
begin T := Self.AutoUpdate; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcIntlSup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcIntlSup) do begin
    RegisterConstructor(@TOvcIntlSup.Create, 'Create');
     RegisterMethod(@TOvcIntlSup.Destroy, 'Free');
     RegisterMethod(@TOvcIntlSup.CurrentDateString, 'CurrentDateString');
    RegisterMethod(@TOvcIntlSup.CurrentDatePChar, 'CurrentDatePChar');
    RegisterMethod(@TOvcIntlSup.CurrentTimeString, 'CurrentTimeString');
    RegisterMethod(@TOvcIntlSup.CurrentTimePChar, 'CurrentTimePChar');
    RegisterMethod(@TOvcIntlSup.DateToDateString, 'DateToDateString');
    RegisterMethod(@TOvcIntlSup.DateToDatePChar, 'DateToDatePChar');
    RegisterMethod(@TOvcIntlSup.DateTimeToDatePChar, 'DateTimeToDatePChar');
    RegisterMethod(@TOvcIntlSup.DateStringToDMY, 'DateStringToDMY');
    RegisterMethod(@TOvcIntlSup.DatePCharToDMY, 'DatePCharToDMY');
    RegisterMethod(@TOvcIntlSup.DateStringIsBlank, 'DateStringIsBlank');
    RegisterMethod(@TOvcIntlSup.DatePCharIsBlank, 'DatePCharIsBlank');
    RegisterMethod(@TOvcIntlSup.DateStringToDate, 'DateStringToDate');
    RegisterMethod(@TOvcIntlSup.DatePCharToDate, 'DatePCharToDate');
    RegisterMethod(@TOvcIntlSup.DayOfWeekToString, 'DayOfWeekToString');
    RegisterMethod(@TOvcIntlSup.DayOfWeekToPChar, 'DayOfWeekToPChar');
    RegisterMethod(@TOvcIntlSup.DMYtoDateString, 'DMYtoDateString');
    RegisterMethod(@TOvcIntlSup.DMYtoDatePChar, 'DMYtoDatePChar');
    RegisterMethod(@TOvcIntlSup.InternationalCurrency, 'InternationalCurrency');
    RegisterMethod(@TOvcIntlSup.InternationalCurrencyPChar, 'InternationalCurrencyPChar');
    RegisterMethod(@TOvcIntlSup.InternationalDate, 'InternationalDate');
    RegisterMethod(@TOvcIntlSup.InternationalDatePChar, 'InternationalDatePChar');
    RegisterMethod(@TOvcIntlSup.InternationalLongDate, 'InternationalLongDate');
    RegisterMethod(@TOvcIntlSup.InternationalLongDatePChar, 'InternationalLongDatePChar');
    RegisterMethod(@TOvcIntlSup.InternationalTime, 'InternationalTime');
    RegisterMethod(@TOvcIntlSup.InternationalTimePChar, 'InternationalTimePChar');
    RegisterMethod(@TOvcIntlSup.MonthStringToMonth, 'MonthStringToMonth');
    RegisterMethod(@TOvcIntlSup.MonthPCharToMonth, 'MonthPCharToMonth');
    RegisterMethod(@TOvcIntlSup.MonthToString, 'MonthToString');
    RegisterMethod(@TOvcIntlSup.MonthToPChar, 'MonthToPChar');
    RegisterMethod(@TOvcIntlSup.ResetInternationalInfo, 'ResetInternationalInfo');
    RegisterMethod(@TOvcIntlSup.TimeStringToHMS, 'TimeStringToHMS');
    RegisterMethod(@TOvcIntlSup.TimePCharToHMS, 'TimePCharToHMS');
    RegisterMethod(@TOvcIntlSup.TimeStringToTime, 'TimeStringToTime');
    RegisterMethod(@TOvcIntlSup.TimePCharToTime, 'TimePCharToTime');
    RegisterMethod(@TOvcIntlSup.TimeToTimeString, 'TimeToTimeString');
    RegisterMethod(@TOvcIntlSup.TimeToTimePChar, 'TimeToTimePChar');
    RegisterMethod(@TOvcIntlSup.TimeToAmPmString, 'TimeToAmPmString');
    RegisterMethod(@TOvcIntlSup.TimeToAmPmPChar, 'TimeToAmPmPChar');
    RegisterPropertyHelper(@TOvcIntlSupAutoUpdate_R,@TOvcIntlSupAutoUpdate_W,'AutoUpdate');
    RegisterPropertyHelper(@TOvcIntlSupCurrencyLtStr_R,@TOvcIntlSupCurrencyLtStr_W,'CurrencyLtStr');
    RegisterPropertyHelper(@TOvcIntlSupCurrencyRtStr_R,@TOvcIntlSupCurrencyRtStr_W,'CurrencyRtStr');
    RegisterPropertyHelper(@TOvcIntlSupDecimalChar_R,@TOvcIntlSupDecimalChar_W,'DecimalChar');
    RegisterPropertyHelper(@TOvcIntlSupCommaChar_R,@TOvcIntlSupCommaChar_W,'CommaChar');
    RegisterPropertyHelper(@TOvcIntlSupCountry_R,nil,'Country');
    RegisterPropertyHelper(@TOvcIntlSupCurrencyDigits_R,@TOvcIntlSupCurrencyDigits_W,'CurrencyDigits');
    RegisterPropertyHelper(@TOvcIntlSupListChar_R,@TOvcIntlSupListChar_W,'ListChar');
    RegisterPropertyHelper(@TOvcIntlSupSlashChar_R,@TOvcIntlSupSlashChar_W,'SlashChar');
    RegisterPropertyHelper(@TOvcIntlSupTrueChar_R,@TOvcIntlSupTrueChar_W,'TrueChar');
    RegisterPropertyHelper(@TOvcIntlSupFalseChar_R,@TOvcIntlSupFalseChar_W,'FalseChar');
    RegisterPropertyHelper(@TOvcIntlSupYesChar_R,@TOvcIntlSupYesChar_W,'YesChar');
    RegisterPropertyHelper(@TOvcIntlSupNoChar_R,@TOvcIntlSupNoChar_W,'NoChar');
    RegisterPropertyHelper(@TOvcIntlSupOnWinIniChange_R,@TOvcIntlSupOnWinIniChange_W,'OnWinIniChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcintl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcIntlSup(CL);
end;

 
 
{ TPSImport_ovcintl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcintl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcintl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcintl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcintl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
