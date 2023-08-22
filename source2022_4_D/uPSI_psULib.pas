unit uPSI_psULib;
{
the last battle at prometheus  - with psufinancial unit
 [DCC Error] uPSI_psULib.pas(325): F2084 Internal Error: AV00000000-R00000000-0
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
  TPSImport_psULib = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_psULib(CL: TPSPascalCompiler);
procedure SIRegister_psUFinancial(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_psULib_Routines(S: TPSExec);
procedure RIRegister_psUFinancial_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Db
  ,Controls
  ,Dialogs
  ,ActnList
  ,Printers
  ,psULib, psUFinancial
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_psULib]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_psULib(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('clMoneyGreenps','LongWord').SetUInt( TColor ( $00C0DCC0 ));
 CL.AddConstantN('clMedGrayps','LongWord').SetUInt( TColor ( $00A4A0A0 ));
 CL.AddConstantN('clRxCreamps','LongWord').SetUInt( TColor ( $00A6CAF0 ));
 CL.AddConstantN('clCreamps','LongWord').SetUInt( TColor ( $00F0FBFF ));
 CL.AddConstantN('clRxSkyBlueps','LongWord').SetUInt( TColor ( $00FFFBF0 ));
 CL.AddConstantN('clSkyBlueps','LongWord').SetUInt( TColor ( $00F0CAA6 ));
 CL.AddConstantN('clInfoBkps','LongWord').SetUInt( TColor ( $02E1FFFF ));
 CL.AddConstantN('clNoneps','LongWord').SetUInt( TColor ( $02FFFFFF ));
 CL.AddConstantN('clSystemColor','LongWord').SetUInt( $FF000000);
 CL.AddConstantN('MinutesPerDay','LongInt').SetInt( 24 * 60);
 CL.AddConstantN('DefaultBeepDelay','LongInt').SetInt( 500);
 CL.AddConstantN('cDoNotBringToTop','String').SetString( '-LaunchInBackground');
  CL.AddTypeS('TFilenameEvent', 'Procedure ( Sender : TObject; var Filename : string)');
 // CL.AddTypeS('TWriteDebugProc', 'Procedure ( const LogName, RoutineName, Comment : string; DebugData : array of string)');
  CL.AddTypeS('TMaxIntSize', '( mbsInt8, mbsWord8, mbsInt16, mbsWord16, mbsInt32, mbsWord32 )');

 CL.AddDelphiFunction('Procedure WriteDebugps( const LogName, RoutineName, Comment : string; DebugData : array of string)');
 CL.AddDelphiFunction('Function Betweenps( Value, BoundA, BoundB : integer; AllowFlip : boolean) : boolean');
 CL.AddDelphiFunction('Function BooleanMatchsp( Value1 : boolean; Value2 : integer) : boolean;');
 CL.AddDelphiFunction('Function BooleanMatch1ps( Value1 : integer; Value2 : boolean) : boolean;');
 CL.AddDelphiFunction('Function BooleanMatch2ps( Value1, Value2 : integer) : boolean;');
 CL.AddDelphiFunction('Function IDMatchps( RequiredID, TestID : integer) : boolean;');
 CL.AddDelphiFunction('Function IDMatch1ps( RequiredID : TField; TestID : integer) : boolean;');
 CL.AddDelphiFunction('Function IDMatch2ps( RequiredID, TestID : TField) : boolean;');
 CL.AddDelphiFunction('Function Blendps( Color1, Color2 : TColor; Weight1 : integer; Weight2 : integer) : TColor');
 CL.AddDelphiFunction('Function MergeRGBps( Red, Green, Blue : integer) : TColor');
 CL.AddDelphiFunction('Procedure SplitRGBps( Color : TColor; var Red, Green, Blue : integer)');
 CL.AddDelphiFunction('Function VisibleContrastps( BackgroundColor : TColor) : TColor');
 CL.AddDelphiFunction('Function SortedStrps( Value : string) : string');
 CL.AddDelphiFunction('Function IntSortStrps( const Value : integer) : string');
 //CL.AddDelphiFunction('Function AllAssignedps( Values : array of pointer) : boolean');
 CL.AddDelphiFunction('Function GetTokenps( var SourceStr : string; Delim : string) : string');
 CL.AddDelphiFunction('Function URLizeps( SourceStr : string) : string');
 CL.AddDelphiFunction('Function UnURLizeps( const SourceStr : string) : string');
 CL.AddDelphiFunction('Function UnQuoteStrps( const Value : string; QuoteChar : char) : string');
 CL.AddDelphiFunction('Procedure SetAndSaveBoolps( var OldVar : boolean; Value : boolean; var SaveVar : boolean)');
 CL.AddDelphiFunction('Procedure SetAndSaveIntps( var OldVar : integer; Value : integer; var SaveVar : integer)');
 CL.AddDelphiFunction('Procedure SetAndSaveStrps( var OldVar : string; const Value : string; var SaveVar : string)');
 CL.AddDelphiFunction('Function GetCharFromVKeyps( VKey : word) : string');
 CL.AddDelphiFunction('Function IsControlKeyDownps : boolean');
 CL.AddDelphiFunction('Procedure PushScreenCursorps( const aCursor : TCursor)');
 CL.AddDelphiFunction('Procedure PopScreenCursorps');
 CL.AddDelphiFunction('Function PeekScreenCursorps : TCursor');
 CL.AddDelphiFunction('Function CharIsNumericSymbolps( aChar : char) : boolean');
 CL.AddDelphiFunction('Function PrecisionMultiplierps( DecimalPrecision : byte) : cardinal');
 CL.AddDelphiFunction('Function TextToFloatValps( const aText : string; const DecimalPrecision : byte; const DefaultValue : extended) : extended');
 CL.AddDelphiFunction('Function TextToWordValps( const aText : string; const DefaultValue : cardinal; const MaxIntSize : TMaxIntSize) : cardinal');
 CL.AddDelphiFunction('Function TextToIntValps( const aText : string; const DefaultValue : integer; const MaxIntSize : TMaxIntSize) : integer');
 CL.AddDelphiFunction('Function BankersRoundingps( const Num : currency; const DecimalPrecision : byte) : currency');
 CL.AddDelphiFunction('Function RoundDownps( const Num : Extended; const DecimalPrecision : byte) : Extended');
 CL.AddDelphiFunction('Function RoundUpps( const Num : Extended; const DecimalPrecision : byte) : Extended');
 CL.AddDelphiFunction('Function RoundNearestps( const Num : Extended; const DecimalPrecision : byte) : Extended');
 CL.AddDelphiFunction('Function NumDigitsps( const aNum : integer) : integer');
 CL.AddDelphiFunction('Function ZeroToMaxps( Value : integer) : integer');
 CL.AddDelphiFunction('Procedure CopyIfPrefixMatchps( Source, Dest : TStrings; Prefix : string; ClearDest : boolean; ValuesOnly : boolean)');
 CL.AddDelphiFunction('Function HexToCharps( const aValue : byte) : AnsiChar');
 CL.AddDelphiFunction('Function CharToHexps( const aValue : AnsiChar) : byte');
 CL.AddDelphiFunction('Function HexToTextps( const Source : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function TextToHexps( const Source : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure SaveGraphicToStreamps( aGraphic : TGraphic; aStream : TStream)');
 CL.AddDelphiFunction('Function LoadGraphicFromStreamps( aStream : TStream) : TGraphic');
 CL.AddDelphiFunction('Function GraphicToTextps( aGraphic : TGraphic) : string');
 CL.AddDelphiFunction('Function TextToGraphicps( aGraphicAsText : string) : TGraphic');
 CL.AddDelphiFunction('Function GetCustNameStrps( aFirstName, aLastName : string) : string');
 CL.AddDelphiFunction('Function GetLongCustNameStrps( aTitle, aFirstName, aLastName : string) : string');
 CL.AddDelphiFunction('Function GetPriceFromMarginps( const aMargin : string; aCost : currency) : currency');
 CL.AddDelphiFunction('Function GetMarginFromPriceps( aPrice, aCost : currency) : string');
 CL.AddDelphiFunction('Function GetDriveSerialNumps( Path : string) : longint');
 CL.AddDelphiFunction('Function GetCCCardTypeFromNameps( aCardName : string) : integer');
 CL.AddDelphiFunction('Function GetItemMarginPercentps( Price, Cost : Currency) : double');
 CL.AddDelphiFunction('Function ValidateCreditCardps( aCardNum : string) : boolean');
 CL.AddDelphiFunction('Function ValidateCreditCardRangeps( const aCardNum, aLowNum, aHighNum : string) : boolean');
 CL.AddDelphiFunction('Function HHMMToTimeps( Value : string) : TTime');
 CL.AddDelphiFunction('Function MMDDToDateps( Value : string) : TDate');
 CL.AddDelphiFunction('Function TimeToHHMMSSps( Value : TTime) : string');
 CL.AddDelphiFunction('Function DateToYYYYMMDDps( Value : TDate) : string');
 CL.AddDelphiFunction('Function FontColorToStringps( SourceFont : TFont; SourceColor : TColor) : string');
 CL.AddDelphiFunction('Procedure StringToFontps( aStr : string; DestFont : TFont)');
 CL.AddDelphiFunction('Procedure StringToFontColorps( aStr : string; DestFont : TFont; var DestColor : TColor)');
 CL.AddDelphiFunction('Procedure ShowDebugStringsps( DebugStrings : TStrings)');
 CL.AddDelphiFunction('Procedure ShowStackDumpps');
 CL.AddDelphiFunction('Procedure RegisterFileExtensionps( const Extension, Description, DefaultActionName, DefaultActionDescription, DefaultActionCommand : string; IconIndex : integer)');
 CL.AddDelphiFunction('Function LaunchCommandps( aCommand : string; aParams : string; WaitForTerminate : boolean) : boolean');
 CL.AddDelphiFunction('Function GetWindowsDirectoryStrps : string');
 CL.AddDelphiFunction('Function IsRemoteSessionps : boolean');
 CL.AddDelphiFunction('Function IsWinXPps : boolean');
 CL.AddDelphiFunction('Procedure AssignTextFileToStreamps( var ATextFile : TextFile; AStream : TStream)');
 CL.AddDelphiFunction('Function DeleteFileMaskps( const Mask : string) : boolean');
 CL.AddDelphiFunction('Function FileMaskCountps( const Mask : string) : integer');
 CL.AddDelphiFunction('Function FileMaskExistsps( const Mask : string) : boolean');
 CL.AddDelphiFunction('Function FileMaskListps( const Mask : string) : string;');
 CL.AddDelphiFunction('Function FileMaskList1ps( const Mask : string; Dest : TStrings; ClearList : boolean) : boolean;');
 CL.AddDelphiFunction('Function GetSafeNumericVariantps( Value : Variant) : Variant');
 CL.AddDelphiFunction('Function GetPasswordCharStrps( aStr : string) : string');
 CL.AddDelphiFunction('Function GetDriversLicenseHeightDisplayTextps( aStr : string) : string');
 CL.AddDelphiFunction('Function IncludePathDelimiterps( const aFilePath : string) : string');
 CL.AddDelphiFunction('Function ExcludePathDelimiterps( const aFilePath : string) : string');
 //CL.AddDelphiFunction('Function GetEnvironmentVariable( const Name : string) : string');
 CL.AddDelphiFunction('Function ArrayToStrps( SourceArray : array of string; Separator : AnsiChar) : string');
 CL.AddDelphiFunction('Function psStrReplaceps( var S : AnsiString; const Search, Replace : AnsiString; Flags : TReplaceFlags) : boolean');
 CL.AddDelphiFunction('Function StrReplaceInStringsps( StrObject : TStrings; const Search, Replace : AnsiString; Flags : TReplaceFlags) : boolean');
 CL.AddDelphiFunction('Procedure ShowMessageps( aMsg : string)');
 CL.AddDelphiFunction('Procedure ShowErrorMessageps( aMsg : string)');
 CL.AddDelphiFunction('Function StandardUserQueryps( aMsg : string; DialogType : cardinal; DialogCaption : string) : cardinal');
 CL.AddDelphiFunction('Function ParamValueps( ParamName : string) : string');
 CL.AddDelphiFunction('Function ParamFlagSetps( ParamName : string) : boolean');
 CL.AddDelphiFunction('Function ConcatenateNonBlanksps( Strings : array of string) : string');
 CL.AddDelphiFunction('Function ConcatenateWithDelimiterps( Strings : array of string; Delimiter : PChar) : string');
 CL.AddDelphiFunction('Function GetMaxStringLengthps( Strings : array of string) : integer');
 CL.AddDelphiFunction('Procedure PlayBeepps( BeepActionType : TMsgDlgType; NumBeeps : integer; MSDelay : integer)');
 CL.AddDelphiFunction('Function DelTreeps( const DirectoryName : string) : Boolean');
 CL.AddDelphiFunction('Procedure UpdateActionCaptionps( anAction : TAction; aCaption : string)');
 CL.AddDelphiFunction('Procedure GetDirectoryListps( const DirectoryName : string; StringList : TStrings)');
 CL.AddDelphiFunction('Function DecodePathps( const Path : string; PathVars : TStrings) : string');
 CL.AddDelphiFunction('Function KillEXEps( ExeName : String) : Boolean');
 CL.AddDelphiFunction('Function GetWindowsDefaultPrinterNameps : string');
 CL.AddDelphiFunction('Function GetBackupFilenameps( const OrigFilename : string) : string');
 CL.AddDelphiFunction('Function GetRestoreFilenameps( const BackupFilename : string) : string');
 CL.AddDelphiFunction('Function MakeBackupFileps( const OrigFilename : string; OverwriteExisting : boolean) : string');
 CL.AddDelphiFunction('Function RestoreBackupFileps( const BackupFilename : string; OverwriteExisting : boolean) : string');
 CL.AddDelphiFunction('Function CalcDistanceps( Lat1, Long1, Lat2, Long2 : double) : double');
 CL.AddDelphiFunction('Function GetDelimiterCountps( aString, aDelimiter : string) : integer');   //}
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_psUFinancial(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLoanType', '( ltAmortized, ltSimple )');
  CL.AddTypeS('TLoanPayType', '( lptMonthly, lptBiMonthly, lptBiWeekly )');
  CL.AddTypeS('TLoanPaymentEvent', 'Procedure ( PayDate : TDate; PayNum : integ'
   +'er; PaymentAmt, Balance, InterestAmt, TotalInterestAmt, AmortizedAmt, TotalAmortizedAmt : currency; var ExtraPayment : currency)');
 CL.AddDelphiFunction('Function LoanPaymentAmt( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Function LoanNumPayments( Principal, PaymentAmt : currency; InterestRate : extended; PayType : TLoanPayType; LoanType : TLoanType) : integer');
 CL.AddDelphiFunction('Function LoanTotalEstimate( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Function LoanInterestEstimate( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Procedure AmortizationSchedule( OnLoanPayment : TLoanPaymentEvent; StartDate : TDate; Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType)');
 CL.AddDelphiFunction('Procedure AmortizationSchedulePaymentAmt( OnLoanPayment : TLoanPaymentEvent; StartDate : TDate; Principal, PaymentAmt : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType)');
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FileMaskList1_P( const Mask : string; Dest : TStrings; ClearList : boolean) : boolean;
Begin Result := psULib.FileMaskList(Mask, Dest, ClearList); END;

(*----------------------------------------------------------------------------*)
Function FileMaskList_P( const Mask : string) : string;
Begin Result := psULib.FileMaskList(Mask); END;

(*----------------------------------------------------------------------------*)
Function IDMatch2_P( RequiredID, TestID : TField) : boolean;
Begin Result := psULib.IDMatch(RequiredID, TestID); END;

(*----------------------------------------------------------------------------*)
Function IDMatch1_P( RequiredID : TField; TestID : integer) : boolean;
Begin Result := psULib.IDMatch(RequiredID, TestID); END;

(*----------------------------------------------------------------------------*)
Function IDMatch_P( RequiredID, TestID : integer) : boolean;
Begin Result := psULib.IDMatch(RequiredID, TestID); END;

(*----------------------------------------------------------------------------*)
Function BooleanMatch2_P( Value1, Value2 : integer) : boolean;
Begin Result := psULib.BooleanMatch(Value1, Value2); END;

(*----------------------------------------------------------------------------*)
Function BooleanMatch1_P( Value1 : integer; Value2 : boolean) : boolean;
Begin Result := psULib.BooleanMatch(Value1, Value2); END;

(*----------------------------------------------------------------------------*)
Function BooleanMatch_P( Value1 : boolean; Value2 : integer) : boolean;
Begin Result := psULib.BooleanMatch(Value1, Value2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_psULib_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WriteDebug, 'WriteDebugps', cdRegister);
 S.RegisterDelphiFunction(@Between, 'Betweenps', cdRegister);
 S.RegisterDelphiFunction(@BooleanMatch_P, 'BooleanMatchps', cdRegister);
 S.RegisterDelphiFunction(@BooleanMatch1_P, 'BooleanMatch1ps', cdRegister);
 S.RegisterDelphiFunction(@BooleanMatch2_P, 'BooleanMatch2ps', cdRegister);
 S.RegisterDelphiFunction(@IDMatch_P, 'IDMatchps', cdRegister);
 S.RegisterDelphiFunction(@IDMatch1_P, 'IDMatch1ps', cdRegister);
 S.RegisterDelphiFunction(@IDMatch2_P, 'IDMatch2ps', cdRegister);
 S.RegisterDelphiFunction(@Blend, 'Blendps', cdRegister);
 S.RegisterDelphiFunction(@MergeRGB, 'MergeRGBps', cdRegister);
 S.RegisterDelphiFunction(@SplitRGB, 'SplitRGBps', cdRegister);
 S.RegisterDelphiFunction(@VisibleContrast, 'VisibleContrastps', cdRegister);
 S.RegisterDelphiFunction(@SortedStr, 'SortedStrps', cdRegister);
 S.RegisterDelphiFunction(@IntSortStr, 'IntSortStrps', cdRegister);
 //S.RegisterDelphiFunction(@AllAssigned, 'AllAssignedps', cdRegister);
 S.RegisterDelphiFunction(@GetToken, 'GetTokenps', cdRegister);
 S.RegisterDelphiFunction(@URLize, 'URLizeps', cdRegister);
 S.RegisterDelphiFunction(@UnURLize, 'UnURLizeps', cdRegister);
 S.RegisterDelphiFunction(@UnQuoteStr, 'UnQuoteStrps', cdRegister);
 S.RegisterDelphiFunction(@SetAndSaveBool, 'SetAndSaveBoolps', cdRegister);
 S.RegisterDelphiFunction(@SetAndSaveInt, 'SetAndSaveIntps', cdRegister);
 S.RegisterDelphiFunction(@SetAndSaveStr, 'SetAndSaveStrps', cdRegister);
 S.RegisterDelphiFunction(@GetCharFromVKey, 'GetCharFromVKeyps', cdRegister);
 S.RegisterDelphiFunction(@IsControlKeyDown, 'IsControlKeyDownps', cdRegister);
 S.RegisterDelphiFunction(@PushScreenCursor, 'PushScreenCursorps', cdRegister);
 S.RegisterDelphiFunction(@PopScreenCursor, 'PopScreenCursorps', cdRegister);
 S.RegisterDelphiFunction(@PeekScreenCursor, 'PeekScreenCursorps', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumericSymbol, 'CharIsNumericSymbolps', cdRegister);
 S.RegisterDelphiFunction(@PrecisionMultiplier, 'PrecisionMultiplierps', cdRegister);
 S.RegisterDelphiFunction(@TextToFloatVal, 'TextToFloatValps', cdRegister);
 S.RegisterDelphiFunction(@TextToWordVal, 'TextToWordValps', cdRegister);
 S.RegisterDelphiFunction(@TextToIntVal, 'TextToIntValps', cdRegister);
 S.RegisterDelphiFunction(@BankersRounding, 'BankersRoundingps', cdRegister);
 S.RegisterDelphiFunction(@RoundDown, 'RoundDownps', cdRegister);
 S.RegisterDelphiFunction(@RoundUp, 'RoundUpps', cdRegister);
 S.RegisterDelphiFunction(@RoundNearest, 'RoundNearestps', cdRegister);
 S.RegisterDelphiFunction(@NumDigits, 'NumDigitsps', cdRegister);
 S.RegisterDelphiFunction(@ZeroToMax, 'ZeroToMaxps', cdRegister);
 S.RegisterDelphiFunction(@CopyIfPrefixMatch, 'CopyIfPrefixMatchps', cdRegister);
 S.RegisterDelphiFunction(@HexToChar, 'HexToCharps', cdRegister);
 S.RegisterDelphiFunction(@CharToHex, 'CharToHexps', cdRegister);
 S.RegisterDelphiFunction(@HexToText, 'HexToTextps', cdRegister);
 S.RegisterDelphiFunction(@TextToHex, 'TextToHexps', cdRegister);
 S.RegisterDelphiFunction(@SaveGraphicToStream, 'SaveGraphicToStreamps', cdRegister);
 S.RegisterDelphiFunction(@LoadGraphicFromStream, 'LoadGraphicFromStreamps', cdRegister);
 S.RegisterDelphiFunction(@GraphicToText, 'GraphicToTextps', cdRegister);
 S.RegisterDelphiFunction(@TextToGraphic, 'TextToGraphicps', cdRegister);
 S.RegisterDelphiFunction(@GetCustNameStr, 'GetCustNameStrps', cdRegister);
 S.RegisterDelphiFunction(@GetLongCustNameStr, 'GetLongCustNameStrps', cdRegister);
 S.RegisterDelphiFunction(@GetPriceFromMargin, 'GetPriceFromMarginps', cdRegister);
 S.RegisterDelphiFunction(@GetMarginFromPrice, 'GetMarginFromPriceps', cdRegister);
 S.RegisterDelphiFunction(@GetDriveSerialNum, 'GetDriveSerialNumps', cdRegister);
 S.RegisterDelphiFunction(@GetCCCardTypeFromName, 'GetCCCardTypeFromNameps', cdRegister);
 S.RegisterDelphiFunction(@GetItemMarginPercent, 'GetItemMarginPercentps', cdRegister);
 S.RegisterDelphiFunction(@ValidateCreditCard, 'ValidateCreditCardps', cdRegister);
 S.RegisterDelphiFunction(@ValidateCreditCardRange, 'ValidateCreditCardRangeps', cdRegister);
 S.RegisterDelphiFunction(@HHMMToTime, 'HHMMToTimeps', cdRegister);
 S.RegisterDelphiFunction(@MMDDToDate, 'MMDDToDateps', cdRegister);
 S.RegisterDelphiFunction(@TimeToHHMMSS, 'TimeToHHMMSSps', cdRegister);
 S.RegisterDelphiFunction(@DateToYYYYMMDD, 'DateToYYYYMMDDps', cdRegister);
 S.RegisterDelphiFunction(@FontColorToString, 'FontColorToStringps', cdRegister);
 S.RegisterDelphiFunction(@StringToFont, 'StringToFontps', cdRegister);
 S.RegisterDelphiFunction(@StringToFontColor, 'StringToFontColorps', cdRegister);
 S.RegisterDelphiFunction(@ShowDebugStrings, 'ShowDebugStringsps', cdRegister);
 S.RegisterDelphiFunction(@ShowStackDump, 'ShowStackDumpps', cdRegister);
 S.RegisterDelphiFunction(@RegisterFileExtension, 'RegisterFileExtensionps', cdRegister);
 S.RegisterDelphiFunction(@LaunchCommand, 'LaunchCommandps', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDirectoryStr, 'GetWindowsDirectoryStrps', cdRegister);
 S.RegisterDelphiFunction(@IsRemoteSession, 'IsRemoteSessionps', cdRegister);
 S.RegisterDelphiFunction(@IsWinXP, 'IsWinXPps', cdRegister);
 S.RegisterDelphiFunction(@AssignTextFileToStream, 'AssignTextFileToStreamps', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileMask, 'DeleteFileMaskps', cdRegister);
 S.RegisterDelphiFunction(@FileMaskCount, 'FileMaskCountps', cdRegister);
 S.RegisterDelphiFunction(@FileMaskExists, 'FileMaskExistsps', cdRegister);
 S.RegisterDelphiFunction(@FileMaskList_P, 'FileMaskListps', cdRegister);
 S.RegisterDelphiFunction(@FileMaskList1_P, 'FileMaskList1ps', cdRegister);
 S.RegisterDelphiFunction(@GetSafeNumericVariant, 'GetSafeNumericVariantps', cdRegister);
 S.RegisterDelphiFunction(@GetPasswordCharStr, 'GetPasswordCharStrps', cdRegister);
 S.RegisterDelphiFunction(@GetDriversLicenseHeightDisplayText, 'GetDriversLicenseHeightDisplayTextps', cdRegister);
 S.RegisterDelphiFunction(@IncludePathDelimiter, 'IncludePathDelimiterps', cdRegister);
 S.RegisterDelphiFunction(@ExcludePathDelimiter, 'ExcludePathDelimiterps', cdRegister);
 //S.RegisterDelphiFunction(@GetEnvironmentVariable, 'GetEnvironmentVariable', cdRegister);
 S.RegisterDelphiFunction(@ArrayToStr, 'ArrayToStrps', cdRegister);
 S.RegisterDelphiFunction(@psStrReplace, 'psStrReplaceps', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceInStrings, 'StrReplaceInStringsps', cdRegister);
 S.RegisterDelphiFunction(@ShowMessage, 'ShowMessageps', cdRegister);
 S.RegisterDelphiFunction(@ShowErrorMessage, 'ShowErrorMessageps', cdRegister);
 S.RegisterDelphiFunction(@StandardUserQuery, 'StandardUserQueryps', cdRegister);
 S.RegisterDelphiFunction(@ParamValue, 'ParamValueps', cdRegister);
 S.RegisterDelphiFunction(@ParamFlagSet, 'ParamFlagSetps', cdRegister);
 S.RegisterDelphiFunction(@ConcatenateNonBlanks, 'ConcatenateNonBlanksps', cdRegister);
 S.RegisterDelphiFunction(@ConcatenateWithDelimiter, 'ConcatenateWithDelimiterps', cdRegister);
 S.RegisterDelphiFunction(@GetMaxStringLength, 'GetMaxStringLengthps', cdRegister);
 S.RegisterDelphiFunction(@PlayBeep, 'PlayBeepps', cdRegister);
 S.RegisterDelphiFunction(@DelTree, 'DelTreeps', cdRegister);
 S.RegisterDelphiFunction(@UpdateActionCaption, 'UpdateActionCaptionps', cdRegister);
 S.RegisterDelphiFunction(@GetDirectoryList, 'GetDirectoryListps', cdRegister);
 S.RegisterDelphiFunction(@DecodePath, 'DecodePathps', cdRegister);
 S.RegisterDelphiFunction(@KillEXE, 'KillEXEps', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDefaultPrinterName, 'GetWindowsDefaultPrinterNameps', cdRegister);
 S.RegisterDelphiFunction(@GetBackupFilename, 'GetBackupFilenameps', cdRegister);
 S.RegisterDelphiFunction(@GetRestoreFilename, 'GetRestoreFilenameps', cdRegister);
 S.RegisterDelphiFunction(@MakeBackupFile, 'MakeBackupFileps', cdRegister);
 S.RegisterDelphiFunction(@RestoreBackupFile, 'RestoreBackupFileps', cdRegister);
 S.RegisterDelphiFunction(@CalcDistance, 'CalcDistanceps', cdRegister);
 S.RegisterDelphiFunction(@GetDelimiterCount, 'GetDelimiterCountps', cdRegister);   //}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_psUFinancial_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoanPaymentAmt, 'LoanPaymentAmt', cdRegister);
 S.RegisterDelphiFunction(@LoanNumPayments, 'LoanNumPayments', cdRegister);
 S.RegisterDelphiFunction(@LoanTotalEstimate, 'LoanTotalEstimate', cdRegister);
 S.RegisterDelphiFunction(@LoanInterestEstimate, 'LoanInterestEstimate', cdRegister);
 S.RegisterDelphiFunction(@AmortizationSchedule, 'AmortizationSchedule', cdRegister);
 S.RegisterDelphiFunction(@AmortizationSchedulePaymentAmt, 'AmortizationSchedulePaymentAmt', cdRegister);
end;



{ TPSImport_psULib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_psULib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_psULib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_psULib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_psULib_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
