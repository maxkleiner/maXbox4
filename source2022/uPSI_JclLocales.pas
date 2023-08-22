unit uPSI_JclLocales;
{
  the env service   add free
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
  TPSImport_JclLocales = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJclKeyboardLayoutList(CL: TPSPascalCompiler);
procedure SIRegister_TJclKeyboardLayout(CL: TPSPascalCompiler);
procedure SIRegister_TJclAvailableKeybLayout(CL: TPSPascalCompiler);
procedure SIRegister_TJclLocalesList(CL: TPSPascalCompiler);
procedure SIRegister_TJclLocaleInfo(CL: TPSPascalCompiler);
procedure SIRegister_JclLocales(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclLocales_Routines(S: TPSExec);
procedure RIRegister_TJclKeyboardLayoutList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclKeyboardLayout(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclAvailableKeybLayout(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclLocalesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclLocaleInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclLocales(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,JclBase
  ,JclWin32
  ,JclLocales
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclLocales]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclKeyboardLayoutList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclKeyboardLayoutList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclKeyboardLayoutList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
   RegisterMethod('Function ActivatePrevLayout( ActivateFlags : TJclKeybLayoutFlags) : Boolean');
    RegisterMethod('Function ActivateNextLayout( ActivateFlags : TJclKeybLayoutFlags) : Boolean');
    RegisterMethod('Function LoadLayout( const LayoutName : string; LoadFlags : TJclKeybLayoutFlags) : Boolean');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('ActiveLayout', 'TJclKeyboardLayout', iptr);
    RegisterProperty('AvailableLayouts', 'TJclAvailableKeybLayout Integer', iptr);
    RegisterProperty('AvailableLayoutCount', 'Integer', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('ItemFromHKL', 'TJclKeyboardLayout HKL', iptr);
    RegisterProperty('Items', 'TJclKeyboardLayout Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('LayoutFromLocaleID', 'TJclKeyboardLayout Word', iptr);
    RegisterProperty('OnRefresh', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclKeyboardLayout(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclKeyboardLayout') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclKeyboardLayout') do begin
    RegisterMethod('Constructor Create( AOwner : TJclKeyboardLayoutList; ALayout : HKL)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Activate( ActivateFlags : TJclKeybLayoutFlags) : Boolean');
    RegisterMethod('Function Unload : Boolean');
    RegisterProperty('DeviceHandle', 'Word', iptr);
    RegisterProperty('DisplayName', 'string', iptr);
    RegisterProperty('Layout', 'HKL', iptr);
    RegisterProperty('LocaleID', 'Word', iptr);
    RegisterProperty('LocaleInfo', 'TJclLocaleInfo', iptr);
    RegisterProperty('VariationName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclAvailableKeybLayout(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclAvailableKeybLayout') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclAvailableKeybLayout') do begin
    RegisterMethod('Function Load( const LoadFlags : TJclKeybLayoutFlags) : Boolean');
    RegisterProperty('Identifier', 'DWORD', iptr);
    RegisterProperty('IdentifierName', 'string', iptr);
    RegisterProperty('LayoutID', 'Word', iptr);
    RegisterProperty('LayoutFile', 'string', iptr);
    RegisterProperty('LayoutFileExists', 'Boolean', iptr);
    RegisterProperty('Name', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclLocalesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TJclLocalesList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TJclLocalesList') do begin
    RegisterMethod('Constructor Create( AKind : TJclLocalesKind)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure FillStrings( Strings : TStrings; InfoType : Integer)');
    RegisterProperty('CodePages', 'TStrings', iptr);
    RegisterProperty('ItemFromLangID', 'TJclLocaleInfo LANGID', iptr);
    RegisterProperty('ItemFromLangIDPrimary', 'TJclLocaleInfo Word', iptr);
    RegisterProperty('ItemFromLocaleID', 'TJclLocaleInfo LCID', iptr);
    RegisterProperty('Items', 'TJclLocaleInfo Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Kind', 'TJclLocalesKind', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclLocaleInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclLocaleInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclLocaleInfo') do begin
    RegisterMethod('Constructor Create( ALocaleID : LCID)');
        RegisterMethod('Procedure Free');
    RegisterProperty('CharInfo', 'Char Integer', iptrw);
    RegisterProperty('IntegerInfo', 'Integer Integer', iptrw);
    RegisterProperty('StringInfo', 'string Integer', iptrw);
    SetDefaultPropery('StringInfo');
    RegisterProperty('UseSystemACP', 'Boolean', iptrw);
    RegisterProperty('FontCharset', 'Byte', iptr);
    RegisterProperty('LangID', 'LANGID', iptr);
    RegisterProperty('LocaleID', 'LCID', iptr);
    RegisterProperty('LangIDPrimary', 'Word', iptr);
    RegisterProperty('LangIDSub', 'Word', iptr);
    RegisterProperty('SortID', 'Word', iptr);
    RegisterProperty('DateFormats', 'TStrings TJclLocaleDateFormats', iptr);
    RegisterProperty('TimeFormats', 'TStrings', iptr);
    RegisterProperty('LanguageIndentifier', 'string', iptr);
    RegisterProperty('LocalizedLangName', 'string', iptr);
    RegisterProperty('EnglishLangName', 'string', iptr);
    RegisterProperty('AbbreviatedLangName', 'string', iptr);
    RegisterProperty('NativeLangName', 'string', iptr);
    RegisterProperty('ISOAbbreviatedLangName', 'string', iptr);
    RegisterProperty('CountryCode', 'Integer', iptr);
    RegisterProperty('LocalizedCountryName', 'string', iptr);
    RegisterProperty('EnglishCountryName', 'string', iptr);
    RegisterProperty('AbbreviatedCountryName', 'string', iptr);
    RegisterProperty('NativeCountryName', 'string', iptr);
    RegisterProperty('ISOAbbreviatedCountryName', 'string', iptr);
    RegisterProperty('DefaultLanguageId', 'Integer', iptr);
    RegisterProperty('DefaultCountryCode', 'Integer', iptr);
    RegisterProperty('DefaultCodePageEBCDIC', 'Integer', iptr);
    RegisterProperty('CodePageOEM', 'Integer', iptr);
    RegisterProperty('CodePageANSI', 'Integer', iptr);
    RegisterProperty('CodePageMAC', 'Integer', iptr);
    RegisterProperty('ListItemSeparator', 'Char', iptrw);
    RegisterProperty('Measure', 'Integer', iptrw);
    RegisterProperty('DecimalSeparator', 'Char', iptrw);
    RegisterProperty('ThousandSeparator', 'Char', iptrw);
    RegisterProperty('DigitGrouping', 'string', iptrw);
    RegisterProperty('NumberOfFractionalDigits', 'Integer', iptrw);
    RegisterProperty('LeadingZeros', 'Integer', iptrw);
    RegisterProperty('NegativeNumberMode', 'Integer', iptrw);
    RegisterProperty('NativeDigits', 'string', iptr);
    RegisterProperty('DigitSubstitution', 'Integer', iptr);
    RegisterProperty('MonetarySymbolLocal', 'string', iptrw);
    RegisterProperty('MonetarySymbolIntl', 'string', iptr);
    RegisterProperty('MonetaryDecimalSeparator', 'Char', iptrw);
    RegisterProperty('MonetaryThousandsSeparator', 'Char', iptrw);
    RegisterProperty('MonetaryGrouping', 'string', iptrw);
    RegisterProperty('NumberOfLocalMonetaryDigits', 'Integer', iptrw);
    RegisterProperty('NumberOfIntlMonetaryDigits', 'Integer', iptr);
    RegisterProperty('PositiveCurrencyMode', 'string', iptrw);
    RegisterProperty('NegativeCurrencyMode', 'string', iptrw);
    RegisterProperty('EnglishCurrencyName', 'string', iptr);
    RegisterProperty('NativeCurrencyName', 'string', iptr);
    RegisterProperty('DateSeparator', 'Char', iptrw);
    RegisterProperty('TimeSeparator', 'Char', iptrw);
    RegisterProperty('ShortDateFormat', 'string', iptrw);
    RegisterProperty('LongDateFormat', 'string', iptrw);
    RegisterProperty('TimeFormatString', 'string', iptrw);
    RegisterProperty('ShortDateOrdering', 'Integer', iptr);
    RegisterProperty('LongDateOrdering', 'Integer', iptr);
    RegisterProperty('TimeFormatSpecifier', 'Integer', iptrw);
    RegisterProperty('TimeMarkerPosition', 'Integer', iptr);
    RegisterProperty('CenturyFormatSpecifier', 'Integer', iptr);
    RegisterProperty('LeadZerosInTime', 'Integer', iptr);
    RegisterProperty('LeadZerosInDay', 'Integer', iptr);
    RegisterProperty('LeadZerosInMonth', 'Integer', iptr);
    RegisterProperty('AMDesignator', 'string', iptrw);
    RegisterProperty('PMDesignator', 'string', iptrw);
    RegisterProperty('YearMonthFormat', 'string', iptrw);
    RegisterProperty('CalendarType', 'Integer', iptrw);
    RegisterProperty('AdditionalCaledarTypes', 'Integer', iptr);
    RegisterProperty('FirstDayOfWeek', 'Integer', iptrw);
    RegisterProperty('FirstWeekOfYear', 'Integer', iptrw);
    RegisterProperty('LongDayNames', 'string TJclLocalesDays', iptr);
    RegisterProperty('AbbreviatedDayNames', 'string TJclLocalesDays', iptr);
    RegisterProperty('LongMonthNames', 'string TJclLocalesMonths', iptr);
    RegisterProperty('AbbreviatedMonthNames', 'string TJclLocalesMonths', iptr);
    RegisterProperty('PositiveSign', 'string', iptrw);
    RegisterProperty('NegativeSign', 'string', iptrw);
    RegisterProperty('PositiveSignPos', 'Integer', iptr);
    RegisterProperty('NegativeSignPos', 'Integer', iptr);
    RegisterProperty('PosOfPositiveMonetarySymbol', 'Integer', iptr);
    RegisterProperty('SepOfPositiveMonetarySymbol', 'Integer', iptr);
    RegisterProperty('PosOfNegativeMonetarySymbol', 'Integer', iptr);
    RegisterProperty('SepOfNegativeMonetarySymbol', 'Integer', iptr);
    RegisterProperty('DefaultPaperSize', 'Integer', iptr);
    RegisterProperty('FontSignature', 'string', iptr);
    RegisterProperty('LocalizedSortName', 'string', iptr);
    RegisterProperty('Calendars', 'TStrings', iptr);
    RegisterProperty('CalendarIntegerInfo', 'Integer CALID Integer', iptr);
    RegisterProperty('CalendarStringInfo', 'string CALID Integer', iptr);
    RegisterProperty('CalTwoDigitYearMax', 'Integer CALID', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclLocales(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJclLocalesDays', 'Integer');
  CL.AddTypeS('TJclLocalesMonths', 'Integer');
  CL.AddTypeS('TJclLocaleDateFormats', '( ldShort, ldLong, ldYearMonth )');
  SIRegister_TJclLocaleInfo(CL);
  CL.AddTypeS('TJclLocalesKind', '( lkInstalled, lkSupported )');
  SIRegister_TJclLocalesList(CL);
  CL.AddTypeS('TJclKeybLayoutFlag', '( klReorder, klUnloadPrevious, klSetForPro'
   +'cess, klActivate, klNotEllShell, klReplaceLang, klSubstituteOK )');
  CL.AddTypeS('TJclKeybLayoutFlags', 'set of TJclKeybLayoutFlag');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclKeyboardLayoutList');
  SIRegister_TJclAvailableKeybLayout(CL);
  SIRegister_TJclKeyboardLayout(CL);
  SIRegister_TJclKeyboardLayoutList(CL);
 CL.AddDelphiFunction('Procedure JclLocalesInfoList( const Strings : TStrings; InfoType : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListOnRefresh_W(Self: TJclKeyboardLayoutList; const T: TNotifyEvent);
begin Self.OnRefresh := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListOnRefresh_R(Self: TJclKeyboardLayoutList; var T: TNotifyEvent);
begin T := Self.OnRefresh; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListLayoutFromLocaleID_R(Self: TJclKeyboardLayoutList; var T: TJclKeyboardLayout; const t1: Word);
begin T := Self.LayoutFromLocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListItems_R(Self: TJclKeyboardLayoutList; var T: TJclKeyboardLayout; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListItemFromHKL_R(Self: TJclKeyboardLayoutList; var T: TJclKeyboardLayout; const t1: HKL);
begin T := Self.ItemFromHKL[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListCount_R(Self: TJclKeyboardLayoutList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListAvailableLayoutCount_R(Self: TJclKeyboardLayoutList; var T: Integer);
begin T := Self.AvailableLayoutCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListAvailableLayouts_R(Self: TJclKeyboardLayoutList; var T: TJclAvailableKeybLayout; const t1: Integer);
begin T := Self.AvailableLayouts[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutListActiveLayout_R(Self: TJclKeyboardLayoutList; var T: TJclKeyboardLayout);
begin T := Self.ActiveLayout; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutVariationName_R(Self: TJclKeyboardLayout; var T: string);
begin T := Self.VariationName; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutLocaleInfo_R(Self: TJclKeyboardLayout; var T: TJclLocaleInfo);
begin T := Self.LocaleInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutLocaleID_R(Self: TJclKeyboardLayout; var T: Word);
begin T := Self.LocaleID; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutLayout_R(Self: TJclKeyboardLayout; var T: HKL);
begin T := Self.Layout; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutDisplayName_R(Self: TJclKeyboardLayout; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TJclKeyboardLayoutDeviceHandle_R(Self: TJclKeyboardLayout; var T: Word);
begin T := Self.DeviceHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutName_R(Self: TJclAvailableKeybLayout; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutLayoutFileExists_R(Self: TJclAvailableKeybLayout; var T: Boolean);
begin T := Self.LayoutFileExists; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutLayoutFile_R(Self: TJclAvailableKeybLayout; var T: string);
begin T := Self.LayoutFile; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutLayoutID_R(Self: TJclAvailableKeybLayout; var T: Word);
begin T := Self.LayoutID; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutIdentifierName_R(Self: TJclAvailableKeybLayout; var T: string);
begin T := Self.IdentifierName; end;

(*----------------------------------------------------------------------------*)
procedure TJclAvailableKeybLayoutIdentifier_R(Self: TJclAvailableKeybLayout; var T: DWORD);
begin T := Self.Identifier; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListKind_R(Self: TJclLocalesList; var T: TJclLocalesKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListItems_R(Self: TJclLocalesList; var T: TJclLocaleInfo; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListItemFromLocaleID_R(Self: TJclLocalesList; var T: TJclLocaleInfo; const t1: LCID);
begin T := Self.ItemFromLocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListItemFromLangIDPrimary_R(Self: TJclLocalesList; var T: TJclLocaleInfo; const t1: Word);
begin T := Self.ItemFromLangIDPrimary[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListItemFromLangID_R(Self: TJclLocalesList; var T: TJclLocaleInfo; const t1: LANGID);
begin T := Self.ItemFromLangID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocalesListCodePages_R(Self: TJclLocalesList; var T: TStrings);
begin T := Self.CodePages; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalTwoDigitYearMax_R(Self: TJclLocaleInfo; var T: Integer; const t1: CALID);
begin T := Self.CalTwoDigitYearMax[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalendarStringInfo_R(Self: TJclLocaleInfo; var T: string; const t1: CALID; const t2: Integer);
begin T := Self.CalendarStringInfo[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalendarIntegerInfo_R(Self: TJclLocaleInfo; var T: Integer; const t1: CALID; const t2: Integer);
begin T := Self.CalendarIntegerInfo[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalendars_R(Self: TJclLocaleInfo; var T: TStrings);
begin T := Self.Calendars; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLocalizedSortName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.LocalizedSortName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFontSignature_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.FontSignature; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDefaultPaperSize_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.DefaultPaperSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoSepOfNegativeMonetarySymbol_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.SepOfNegativeMonetarySymbol; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPosOfNegativeMonetarySymbol_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.PosOfNegativeMonetarySymbol; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoSepOfPositiveMonetarySymbol_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.SepOfPositiveMonetarySymbol; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPosOfPositiveMonetarySymbol_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.PosOfPositiveMonetarySymbol; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeSignPos_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.NegativeSignPos; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPositiveSignPos_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.PositiveSignPos; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeSign_W(Self: TJclLocaleInfo; const T: string);
begin Self.NegativeSign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeSign_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NegativeSign; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPositiveSign_W(Self: TJclLocaleInfo; const T: string);
begin Self.PositiveSign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPositiveSign_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.PositiveSign; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAbbreviatedMonthNames_R(Self: TJclLocaleInfo; var T: string; const t1: TJclLocalesMonths);
begin T := Self.AbbreviatedMonthNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLongMonthNames_R(Self: TJclLocaleInfo; var T: string; const t1: TJclLocalesMonths);
begin T := Self.LongMonthNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAbbreviatedDayNames_R(Self: TJclLocaleInfo; var T: string; const t1: TJclLocalesDays);
begin T := Self.AbbreviatedDayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLongDayNames_R(Self: TJclLocaleInfo; var T: string; const t1: TJclLocalesDays);
begin T := Self.LongDayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFirstWeekOfYear_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.FirstWeekOfYear := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFirstWeekOfYear_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.FirstWeekOfYear; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFirstDayOfWeek_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.FirstDayOfWeek := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFirstDayOfWeek_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.FirstDayOfWeek; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAdditionalCaledarTypes_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.AdditionalCaledarTypes; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalendarType_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.CalendarType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCalendarType_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CalendarType; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoYearMonthFormat_W(Self: TJclLocaleInfo; const T: string);
begin Self.YearMonthFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoYearMonthFormat_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.YearMonthFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPMDesignator_W(Self: TJclLocaleInfo; const T: string);
begin Self.PMDesignator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPMDesignator_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.PMDesignator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAMDesignator_W(Self: TJclLocaleInfo; const T: string);
begin Self.AMDesignator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAMDesignator_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.AMDesignator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLeadZerosInMonth_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.LeadZerosInMonth; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLeadZerosInDay_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.LeadZerosInDay; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLeadZerosInTime_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.LeadZerosInTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCenturyFormatSpecifier_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CenturyFormatSpecifier; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeMarkerPosition_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.TimeMarkerPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeFormatSpecifier_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.TimeFormatSpecifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeFormatSpecifier_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.TimeFormatSpecifier; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLongDateOrdering_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.LongDateOrdering; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoShortDateOrdering_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.ShortDateOrdering; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeFormatString_W(Self: TJclLocaleInfo; const T: string);
begin Self.TimeFormatString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeFormatString_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.TimeFormatString; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLongDateFormat_W(Self: TJclLocaleInfo; const T: string);
begin Self.LongDateFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLongDateFormat_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.LongDateFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoShortDateFormat_W(Self: TJclLocaleInfo; const T: string);
begin Self.ShortDateFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoShortDateFormat_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.ShortDateFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.TimeSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.TimeSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDateSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.DateSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDateSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.DateSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNativeCurrencyName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NativeCurrencyName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoEnglishCurrencyName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.EnglishCurrencyName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeCurrencyMode_W(Self: TJclLocaleInfo; const T: string);
begin Self.NegativeCurrencyMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeCurrencyMode_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NegativeCurrencyMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPositiveCurrencyMode_W(Self: TJclLocaleInfo; const T: string);
begin Self.PositiveCurrencyMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoPositiveCurrencyMode_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.PositiveCurrencyMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNumberOfIntlMonetaryDigits_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.NumberOfIntlMonetaryDigits; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNumberOfLocalMonetaryDigits_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.NumberOfLocalMonetaryDigits := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNumberOfLocalMonetaryDigits_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.NumberOfLocalMonetaryDigits; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryGrouping_W(Self: TJclLocaleInfo; const T: string);
begin Self.MonetaryGrouping := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryGrouping_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.MonetaryGrouping; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryThousandsSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.MonetaryThousandsSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryThousandsSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.MonetaryThousandsSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryDecimalSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.MonetaryDecimalSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetaryDecimalSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.MonetaryDecimalSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetarySymbolIntl_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.MonetarySymbolIntl; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetarySymbolLocal_W(Self: TJclLocaleInfo; const T: string);
begin Self.MonetarySymbolLocal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMonetarySymbolLocal_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.MonetarySymbolLocal; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDigitSubstitution_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.DigitSubstitution; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNativeDigits_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NativeDigits; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeNumberMode_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.NegativeNumberMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNegativeNumberMode_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.NegativeNumberMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLeadingZeros_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.LeadingZeros := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLeadingZeros_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.LeadingZeros; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNumberOfFractionalDigits_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.NumberOfFractionalDigits := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNumberOfFractionalDigits_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.NumberOfFractionalDigits; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDigitGrouping_W(Self: TJclLocaleInfo; const T: string);
begin Self.DigitGrouping := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDigitGrouping_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.DigitGrouping; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoThousandSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.ThousandSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoThousandSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.ThousandSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDecimalSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.DecimalSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDecimalSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.DecimalSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMeasure_W(Self: TJclLocaleInfo; const T: Integer);
begin Self.Measure := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoMeasure_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.Measure; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoListItemSeparator_W(Self: TJclLocaleInfo; const T: Char);
begin Self.ListItemSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoListItemSeparator_R(Self: TJclLocaleInfo; var T: Char);
begin T := Self.ListItemSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCodePageMAC_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CodePageMAC; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCodePageANSI_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CodePageANSI; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCodePageOEM_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CodePageOEM; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDefaultCodePageEBCDIC_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.DefaultCodePageEBCDIC; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDefaultCountryCode_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.DefaultCountryCode; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDefaultLanguageId_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.DefaultLanguageId; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoISOAbbreviatedCountryName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.ISOAbbreviatedCountryName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNativeCountryName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NativeCountryName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAbbreviatedCountryName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.AbbreviatedCountryName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoEnglishCountryName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.EnglishCountryName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLocalizedCountryName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.LocalizedCountryName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCountryCode_R(Self: TJclLocaleInfo; var T: Integer);
begin T := Self.CountryCode; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoISOAbbreviatedLangName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.ISOAbbreviatedLangName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoNativeLangName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.NativeLangName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoAbbreviatedLangName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.AbbreviatedLangName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoEnglishLangName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.EnglishLangName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLocalizedLangName_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.LocalizedLangName; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLanguageIndentifier_R(Self: TJclLocaleInfo; var T: string);
begin T := Self.LanguageIndentifier; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoTimeFormats_R(Self: TJclLocaleInfo; var T: TStrings);
begin T := Self.TimeFormats; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoDateFormats_R(Self: TJclLocaleInfo; var T: TStrings; const t1: TJclLocaleDateFormats);
begin T := Self.DateFormats[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoSortID_R(Self: TJclLocaleInfo; var T: Word);
begin T := Self.SortID; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLangIDSub_R(Self: TJclLocaleInfo; var T: Word);
begin T := Self.LangIDSub; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLangIDPrimary_R(Self: TJclLocaleInfo; var T: Word);
begin T := Self.LangIDPrimary; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLocaleID_R(Self: TJclLocaleInfo; var T: LCID);
begin T := Self.LocaleID; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoLangID_R(Self: TJclLocaleInfo; var T: LANGID);
begin T := Self.LangID; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoFontCharset_R(Self: TJclLocaleInfo; var T: Byte);
begin T := Self.FontCharset; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoUseSystemACP_W(Self: TJclLocaleInfo; const T: Boolean);
begin Self.UseSystemACP := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoUseSystemACP_R(Self: TJclLocaleInfo; var T: Boolean);
begin T := Self.UseSystemACP; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoStringInfo_W(Self: TJclLocaleInfo; const T: string; const t1: Integer);
begin Self.StringInfo[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoStringInfo_R(Self: TJclLocaleInfo; var T: string; const t1: Integer);
begin T := Self.StringInfo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoIntegerInfo_W(Self: TJclLocaleInfo; const T: Integer; const t1: Integer);
begin Self.IntegerInfo[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoIntegerInfo_R(Self: TJclLocaleInfo; var T: Integer; const t1: Integer);
begin T := Self.IntegerInfo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCharInfo_W(Self: TJclLocaleInfo; const T: Char; const t1: Integer);
begin Self.CharInfo[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLocaleInfoCharInfo_R(Self: TJclLocaleInfo; var T: Char; const t1: Integer);
begin T := Self.CharInfo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclLocales_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JclLocalesInfoList, 'JclLocalesInfoList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclKeyboardLayoutList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclKeyboardLayoutList) do begin
    RegisterConstructor(@TJclKeyboardLayoutList.Create, 'Create');
   RegisterMethod(@TJclKeyboardLayoutList.Destroy, 'Free');
     RegisterMethod(@TJclKeyboardLayoutList.ActivatePrevLayout, 'ActivatePrevLayout');
    RegisterMethod(@TJclKeyboardLayoutList.ActivateNextLayout, 'ActivateNextLayout');
    RegisterMethod(@TJclKeyboardLayoutList.LoadLayout, 'LoadLayout');
    RegisterMethod(@TJclKeyboardLayoutList.Refresh, 'Refresh');
    RegisterPropertyHelper(@TJclKeyboardLayoutListActiveLayout_R,nil,'ActiveLayout');
    RegisterPropertyHelper(@TJclKeyboardLayoutListAvailableLayouts_R,nil,'AvailableLayouts');
    RegisterPropertyHelper(@TJclKeyboardLayoutListAvailableLayoutCount_R,nil,'AvailableLayoutCount');
    RegisterPropertyHelper(@TJclKeyboardLayoutListCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclKeyboardLayoutListItemFromHKL_R,nil,'ItemFromHKL');
    RegisterPropertyHelper(@TJclKeyboardLayoutListItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclKeyboardLayoutListLayoutFromLocaleID_R,nil,'LayoutFromLocaleID');
    RegisterPropertyHelper(@TJclKeyboardLayoutListOnRefresh_R,@TJclKeyboardLayoutListOnRefresh_W,'OnRefresh');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclKeyboardLayout(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclKeyboardLayout) do begin
    RegisterConstructor(@TJclKeyboardLayout.Create, 'Create');
    RegisterMethod(@TJclKeyboardLayout.Destroy, 'Free');
     RegisterMethod(@TJclKeyboardLayout.Activate, 'Activate');
    RegisterMethod(@TJclKeyboardLayout.Unload, 'Unload');
    RegisterPropertyHelper(@TJclKeyboardLayoutDeviceHandle_R,nil,'DeviceHandle');
    RegisterPropertyHelper(@TJclKeyboardLayoutDisplayName_R,nil,'DisplayName');
    RegisterPropertyHelper(@TJclKeyboardLayoutLayout_R,nil,'Layout');
    RegisterPropertyHelper(@TJclKeyboardLayoutLocaleID_R,nil,'LocaleID');
    RegisterPropertyHelper(@TJclKeyboardLayoutLocaleInfo_R,nil,'LocaleInfo');
    RegisterPropertyHelper(@TJclKeyboardLayoutVariationName_R,nil,'VariationName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclAvailableKeybLayout(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclAvailableKeybLayout) do
  begin
    RegisterMethod(@TJclAvailableKeybLayout.Load, 'Load');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutIdentifier_R,nil,'Identifier');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutIdentifierName_R,nil,'IdentifierName');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutLayoutID_R,nil,'LayoutID');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutLayoutFile_R,nil,'LayoutFile');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutLayoutFileExists_R,nil,'LayoutFileExists');
    RegisterPropertyHelper(@TJclAvailableKeybLayoutName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclLocalesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclLocalesList) do begin
    RegisterConstructor(@TJclLocalesList.Create, 'Create');
      RegisterMethod(@TJclLocalesList.Destroy, 'Free');
     RegisterMethod(@TJclLocalesList.FillStrings, 'FillStrings');
    RegisterPropertyHelper(@TJclLocalesListCodePages_R,nil,'CodePages');
    RegisterPropertyHelper(@TJclLocalesListItemFromLangID_R,nil,'ItemFromLangID');
    RegisterPropertyHelper(@TJclLocalesListItemFromLangIDPrimary_R,nil,'ItemFromLangIDPrimary');
    RegisterPropertyHelper(@TJclLocalesListItemFromLocaleID_R,nil,'ItemFromLocaleID');
    RegisterPropertyHelper(@TJclLocalesListItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclLocalesListKind_R,nil,'Kind');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclLocaleInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclLocaleInfo) do begin
    RegisterConstructor(@TJclLocaleInfo.Create, 'Create');
       RegisterMethod(@TJclLocaleInfo.Destroy, 'Free');
     RegisterPropertyHelper(@TJclLocaleInfoCharInfo_R,@TJclLocaleInfoCharInfo_W,'CharInfo');
    RegisterPropertyHelper(@TJclLocaleInfoIntegerInfo_R,@TJclLocaleInfoIntegerInfo_W,'IntegerInfo');
    RegisterPropertyHelper(@TJclLocaleInfoStringInfo_R,@TJclLocaleInfoStringInfo_W,'StringInfo');
    RegisterPropertyHelper(@TJclLocaleInfoUseSystemACP_R,@TJclLocaleInfoUseSystemACP_W,'UseSystemACP');
    RegisterPropertyHelper(@TJclLocaleInfoFontCharset_R,nil,'FontCharset');
    RegisterPropertyHelper(@TJclLocaleInfoLangID_R,nil,'LangID');
    RegisterPropertyHelper(@TJclLocaleInfoLocaleID_R,nil,'LocaleID');
    RegisterPropertyHelper(@TJclLocaleInfoLangIDPrimary_R,nil,'LangIDPrimary');
    RegisterPropertyHelper(@TJclLocaleInfoLangIDSub_R,nil,'LangIDSub');
    RegisterPropertyHelper(@TJclLocaleInfoSortID_R,nil,'SortID');
    RegisterPropertyHelper(@TJclLocaleInfoDateFormats_R,nil,'DateFormats');
    RegisterPropertyHelper(@TJclLocaleInfoTimeFormats_R,nil,'TimeFormats');
    RegisterPropertyHelper(@TJclLocaleInfoLanguageIndentifier_R,nil,'LanguageIndentifier');
    RegisterPropertyHelper(@TJclLocaleInfoLocalizedLangName_R,nil,'LocalizedLangName');
    RegisterPropertyHelper(@TJclLocaleInfoEnglishLangName_R,nil,'EnglishLangName');
    RegisterPropertyHelper(@TJclLocaleInfoAbbreviatedLangName_R,nil,'AbbreviatedLangName');
    RegisterPropertyHelper(@TJclLocaleInfoNativeLangName_R,nil,'NativeLangName');
    RegisterPropertyHelper(@TJclLocaleInfoISOAbbreviatedLangName_R,nil,'ISOAbbreviatedLangName');
    RegisterPropertyHelper(@TJclLocaleInfoCountryCode_R,nil,'CountryCode');
    RegisterPropertyHelper(@TJclLocaleInfoLocalizedCountryName_R,nil,'LocalizedCountryName');
    RegisterPropertyHelper(@TJclLocaleInfoEnglishCountryName_R,nil,'EnglishCountryName');
    RegisterPropertyHelper(@TJclLocaleInfoAbbreviatedCountryName_R,nil,'AbbreviatedCountryName');
    RegisterPropertyHelper(@TJclLocaleInfoNativeCountryName_R,nil,'NativeCountryName');
    RegisterPropertyHelper(@TJclLocaleInfoISOAbbreviatedCountryName_R,nil,'ISOAbbreviatedCountryName');
    RegisterPropertyHelper(@TJclLocaleInfoDefaultLanguageId_R,nil,'DefaultLanguageId');
    RegisterPropertyHelper(@TJclLocaleInfoDefaultCountryCode_R,nil,'DefaultCountryCode');
    RegisterPropertyHelper(@TJclLocaleInfoDefaultCodePageEBCDIC_R,nil,'DefaultCodePageEBCDIC');
    RegisterPropertyHelper(@TJclLocaleInfoCodePageOEM_R,nil,'CodePageOEM');
    RegisterPropertyHelper(@TJclLocaleInfoCodePageANSI_R,nil,'CodePageANSI');
    RegisterPropertyHelper(@TJclLocaleInfoCodePageMAC_R,nil,'CodePageMAC');
    RegisterPropertyHelper(@TJclLocaleInfoListItemSeparator_R,@TJclLocaleInfoListItemSeparator_W,'ListItemSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoMeasure_R,@TJclLocaleInfoMeasure_W,'Measure');
    RegisterPropertyHelper(@TJclLocaleInfoDecimalSeparator_R,@TJclLocaleInfoDecimalSeparator_W,'DecimalSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoThousandSeparator_R,@TJclLocaleInfoThousandSeparator_W,'ThousandSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoDigitGrouping_R,@TJclLocaleInfoDigitGrouping_W,'DigitGrouping');
    RegisterPropertyHelper(@TJclLocaleInfoNumberOfFractionalDigits_R,@TJclLocaleInfoNumberOfFractionalDigits_W,'NumberOfFractionalDigits');
    RegisterPropertyHelper(@TJclLocaleInfoLeadingZeros_R,@TJclLocaleInfoLeadingZeros_W,'LeadingZeros');
    RegisterPropertyHelper(@TJclLocaleInfoNegativeNumberMode_R,@TJclLocaleInfoNegativeNumberMode_W,'NegativeNumberMode');
    RegisterPropertyHelper(@TJclLocaleInfoNativeDigits_R,nil,'NativeDigits');
    RegisterPropertyHelper(@TJclLocaleInfoDigitSubstitution_R,nil,'DigitSubstitution');
    RegisterPropertyHelper(@TJclLocaleInfoMonetarySymbolLocal_R,@TJclLocaleInfoMonetarySymbolLocal_W,'MonetarySymbolLocal');
    RegisterPropertyHelper(@TJclLocaleInfoMonetarySymbolIntl_R,nil,'MonetarySymbolIntl');
    RegisterPropertyHelper(@TJclLocaleInfoMonetaryDecimalSeparator_R,@TJclLocaleInfoMonetaryDecimalSeparator_W,'MonetaryDecimalSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoMonetaryThousandsSeparator_R,@TJclLocaleInfoMonetaryThousandsSeparator_W,'MonetaryThousandsSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoMonetaryGrouping_R,@TJclLocaleInfoMonetaryGrouping_W,'MonetaryGrouping');
    RegisterPropertyHelper(@TJclLocaleInfoNumberOfLocalMonetaryDigits_R,@TJclLocaleInfoNumberOfLocalMonetaryDigits_W,'NumberOfLocalMonetaryDigits');
    RegisterPropertyHelper(@TJclLocaleInfoNumberOfIntlMonetaryDigits_R,nil,'NumberOfIntlMonetaryDigits');
    RegisterPropertyHelper(@TJclLocaleInfoPositiveCurrencyMode_R,@TJclLocaleInfoPositiveCurrencyMode_W,'PositiveCurrencyMode');
    RegisterPropertyHelper(@TJclLocaleInfoNegativeCurrencyMode_R,@TJclLocaleInfoNegativeCurrencyMode_W,'NegativeCurrencyMode');
    RegisterPropertyHelper(@TJclLocaleInfoEnglishCurrencyName_R,nil,'EnglishCurrencyName');
    RegisterPropertyHelper(@TJclLocaleInfoNativeCurrencyName_R,nil,'NativeCurrencyName');
    RegisterPropertyHelper(@TJclLocaleInfoDateSeparator_R,@TJclLocaleInfoDateSeparator_W,'DateSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoTimeSeparator_R,@TJclLocaleInfoTimeSeparator_W,'TimeSeparator');
    RegisterPropertyHelper(@TJclLocaleInfoShortDateFormat_R,@TJclLocaleInfoShortDateFormat_W,'ShortDateFormat');
    RegisterPropertyHelper(@TJclLocaleInfoLongDateFormat_R,@TJclLocaleInfoLongDateFormat_W,'LongDateFormat');
    RegisterPropertyHelper(@TJclLocaleInfoTimeFormatString_R,@TJclLocaleInfoTimeFormatString_W,'TimeFormatString');
    RegisterPropertyHelper(@TJclLocaleInfoShortDateOrdering_R,nil,'ShortDateOrdering');
    RegisterPropertyHelper(@TJclLocaleInfoLongDateOrdering_R,nil,'LongDateOrdering');
    RegisterPropertyHelper(@TJclLocaleInfoTimeFormatSpecifier_R,@TJclLocaleInfoTimeFormatSpecifier_W,'TimeFormatSpecifier');
    RegisterPropertyHelper(@TJclLocaleInfoTimeMarkerPosition_R,nil,'TimeMarkerPosition');
    RegisterPropertyHelper(@TJclLocaleInfoCenturyFormatSpecifier_R,nil,'CenturyFormatSpecifier');
    RegisterPropertyHelper(@TJclLocaleInfoLeadZerosInTime_R,nil,'LeadZerosInTime');
    RegisterPropertyHelper(@TJclLocaleInfoLeadZerosInDay_R,nil,'LeadZerosInDay');
    RegisterPropertyHelper(@TJclLocaleInfoLeadZerosInMonth_R,nil,'LeadZerosInMonth');
    RegisterPropertyHelper(@TJclLocaleInfoAMDesignator_R,@TJclLocaleInfoAMDesignator_W,'AMDesignator');
    RegisterPropertyHelper(@TJclLocaleInfoPMDesignator_R,@TJclLocaleInfoPMDesignator_W,'PMDesignator');
    RegisterPropertyHelper(@TJclLocaleInfoYearMonthFormat_R,@TJclLocaleInfoYearMonthFormat_W,'YearMonthFormat');
    RegisterPropertyHelper(@TJclLocaleInfoCalendarType_R,@TJclLocaleInfoCalendarType_W,'CalendarType');
    RegisterPropertyHelper(@TJclLocaleInfoAdditionalCaledarTypes_R,nil,'AdditionalCaledarTypes');
    RegisterPropertyHelper(@TJclLocaleInfoFirstDayOfWeek_R,@TJclLocaleInfoFirstDayOfWeek_W,'FirstDayOfWeek');
    RegisterPropertyHelper(@TJclLocaleInfoFirstWeekOfYear_R,@TJclLocaleInfoFirstWeekOfYear_W,'FirstWeekOfYear');
    RegisterPropertyHelper(@TJclLocaleInfoLongDayNames_R,nil,'LongDayNames');
    RegisterPropertyHelper(@TJclLocaleInfoAbbreviatedDayNames_R,nil,'AbbreviatedDayNames');
    RegisterPropertyHelper(@TJclLocaleInfoLongMonthNames_R,nil,'LongMonthNames');
    RegisterPropertyHelper(@TJclLocaleInfoAbbreviatedMonthNames_R,nil,'AbbreviatedMonthNames');
    RegisterPropertyHelper(@TJclLocaleInfoPositiveSign_R,@TJclLocaleInfoPositiveSign_W,'PositiveSign');
    RegisterPropertyHelper(@TJclLocaleInfoNegativeSign_R,@TJclLocaleInfoNegativeSign_W,'NegativeSign');
    RegisterPropertyHelper(@TJclLocaleInfoPositiveSignPos_R,nil,'PositiveSignPos');
    RegisterPropertyHelper(@TJclLocaleInfoNegativeSignPos_R,nil,'NegativeSignPos');
    RegisterPropertyHelper(@TJclLocaleInfoPosOfPositiveMonetarySymbol_R,nil,'PosOfPositiveMonetarySymbol');
    RegisterPropertyHelper(@TJclLocaleInfoSepOfPositiveMonetarySymbol_R,nil,'SepOfPositiveMonetarySymbol');
    RegisterPropertyHelper(@TJclLocaleInfoPosOfNegativeMonetarySymbol_R,nil,'PosOfNegativeMonetarySymbol');
    RegisterPropertyHelper(@TJclLocaleInfoSepOfNegativeMonetarySymbol_R,nil,'SepOfNegativeMonetarySymbol');
    RegisterPropertyHelper(@TJclLocaleInfoDefaultPaperSize_R,nil,'DefaultPaperSize');
    RegisterPropertyHelper(@TJclLocaleInfoFontSignature_R,nil,'FontSignature');
    RegisterPropertyHelper(@TJclLocaleInfoLocalizedSortName_R,nil,'LocalizedSortName');
    RegisterPropertyHelper(@TJclLocaleInfoCalendars_R,nil,'Calendars');
    RegisterPropertyHelper(@TJclLocaleInfoCalendarIntegerInfo_R,nil,'CalendarIntegerInfo');
    RegisterPropertyHelper(@TJclLocaleInfoCalendarStringInfo_R,nil,'CalendarStringInfo');
    RegisterPropertyHelper(@TJclLocaleInfoCalTwoDigitYearMax_R,nil,'CalTwoDigitYearMax');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclLocales(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclLocaleInfo(CL);
  RIRegister_TJclLocalesList(CL);
  with CL.Add(TJclKeyboardLayoutList) do
  RIRegister_TJclAvailableKeybLayout(CL);
  RIRegister_TJclKeyboardLayout(CL);
  RIRegister_TJclKeyboardLayoutList(CL);
end;

 
 
{ TPSImport_JclLocales }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLocales.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclLocales(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLocales.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclLocales(ri);
  RIRegister_JclLocales_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
