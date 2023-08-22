unit uPSI_KLibUtils;
{
maxTrack unit 1486

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
  TPSImport_KLibUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_KLibUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KLibUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   KLibUtils, KLibtypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KLibUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_KLibUtils(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TResourceklib', 'record name : string; _type : string; end');

 CL.AddTypeS('TAnonymousMethodklib',{reference to} 'procedure');
 CL.AddTypeS('TCallBackklib', 'procedure(msg: string)');

 CL.AddDelphiFunction('Procedure deleteFilesInDirklib( pathDir : string; const filesToKeep : array of string)');
 CL.AddDelphiFunction('Procedure deleteFilesInDirWithStartingFileNameklib( dirName : string; startingFileName : string; fileType : string)');
 CL.AddDelphiFunction('Function checkIfFileExistsAndEmptyklib( fileName : string) : boolean');
 CL.AddDelphiFunction('Procedure deleteFileIfExistsklib( fileName : string)');
 CL.AddDelphiFunction('Function getTextFromFileklib( fileName : string) : string');
 CL.AddDelphiFunction('Function checkIfThereIsSpaceAvailableOnDriveklib( drive : char; requiredSpaceInBytes : int64) : boolean');
 CL.AddDelphiFunction('Function getFreeSpaceOnDriveklib( drive : char) : int64');
 CL.AddDelphiFunction('Function getIndexOfDriveklib( drive : char) : integer');
 CL.AddDelphiFunction('Function getDriveExeklib : char');
 CL.AddDelphiFunction('Function getDirSizeklib( path : string) : int64');
 CL.AddDelphiFunction('Function getCombinedPathWithCurrentDirklib( pathToCombine : string) : string');
 CL.AddDelphiFunction('Function getDirExeklib : string');
 CL.AddDelphiFunction('Procedure createDirIfNotExistsklib( dirName : string)');
 CL.AddDelphiFunction('Function checkIfIsLinuxSubDirklib( subDir : string; mainDir : string) : boolean');
 CL.AddDelphiFunction('Function getPathInLinuxStyleklib( path : string) : string');
 CL.AddDelphiFunction('Function checkIfIsSubDirklib( subDir : string; mainDir : string; trailingPathDelimiter : char) : boolean');
 CL.AddDelphiFunction('Function getValidFullPathklib( fileName : string) : string');
 CL.AddDelphiFunction('Function checkMD5Fileklib( fileName : string; MD5 : string) : boolean');
 CL.AddDelphiFunction('Procedure unzipResourceklib( nameResource : string; destinationDir : string)');
 //CL.AddDelphiFunction('Function getPNGResource( nameResource : string) : TPngImage');
 CL.AddDelphiFunction('Procedure getResourceAsEXEFileklib( nameResource : string; destinationFileName : string)');
 CL.AddDelphiFunction('Procedure getResourceAsZIPFileklib( nameResource : string; destinationFileName : string)');
 CL.AddDelphiFunction('Procedure getResourceAsFileklib( resource : TResourceklib; destinationFileName : string)');
 CL.AddDelphiFunction('Function getResourceAsString( resource : TResourceklib) : string');
 CL.AddDelphiFunction('Function getResourceAsStringklib( resource : TResourceklib) : string');
 CL.AddDelphiFunction('Function getResourceAsStreamklib( resource : TResourceklib) : TResourceStream');
 CL.AddDelphiFunction('Procedure unzipklib( zipFileName : string; destinationDir : string; deleteZipAfterUnzip : boolean)');
 //CL.AddDelphiFunction('Function checkRequiredFTPProperties( FTPCredentials : TFTPCredentials) : boolean');
 CL.AddDelphiFunction('Function getValidItalianTelephoneNumberklib( number : string) : string');
 CL.AddDelphiFunction('Function getValidTelephoneNumberklib( number : string) : string');
 CL.AddDelphiFunction('Function getRandStringklib( size : integer) : string');
 CL.AddDelphiFunction('Function getFirstFileNameInDirklib( dirName : string; fileType : string; fullPath : boolean) : string');
 CL.AddDelphiFunction('Function getFileNamesListInDirklib( dirName : string; fileType : string; fullPath : boolean) : TStringList');
 CL.AddDelphiFunction('Procedure saveToFileklib( source : string; fileName : string)');
 CL.AddDelphiFunction('Function getCombinedPathklib( path1 : string; path2 : string) : string');
 CL.AddDelphiFunction('Function getCurrentDayOfWeekAsStringklib : string');
 CL.AddDelphiFunction('Function getDayOfWeekAsStringklib( date : TDateTime) : string');
 CL.AddDelphiFunction('Function getCurrentDateTimeAsStringklib : string');
 CL.AddDelphiFunction('Function getDateTimeAsStringklib( date : TDateTime) : string');
 CL.AddDelphiFunction('Function getCurrentDateAsStringklib : string');
 CL.AddDelphiFunction('Function getDateAsStringklib( date : TDateTime) : string');
 CL.AddDelphiFunction('Function getCurrentTimeStampklib : string');
 CL.AddDelphiFunction('Function getCurrentDateTimeAsStringWithFormattingklib( formatting : string) : string');
 CL.AddDelphiFunction('Function getDateTimeAsStringWithFormattingklib( value : TDateTime; formatting : string) : string');
 CL.AddDelphiFunction('Function getCurrentDateTimeklib : TDateTime');
 CL.AddDelphiFunction('Function getParsedXMLstringklib( mainString : string) : string');
 CL.AddDelphiFunction('Function getDoubleQuotedStringklib( mainString : string) : string');
 CL.AddDelphiFunction('Function getSingleQuotedStringklib( mainString : string) : string');
 CL.AddDelphiFunction('Function getMainStringWithSubStringInsertedklib( mainString : string; insertedString : string; index : integer) : string');
 CL.AddDelphiFunction('Function getStringWithoutLineBreaksklib( mainString : string; substituteString : string) : string');
 CL.AddDelphiFunction('Function getCSVFieldFromStringAsDateklib( mainString : string; index : integer; delimiter : Char) : TDate;');
 CL.AddDelphiFunction('Function getCSVFieldFromStringAsDate1klib( mainString : string; index : integer; formatSettings : TFormatSettings; delimiter : Char) : TDate;');
 CL.AddDelphiFunction('Function getCSVFieldFromStringAsDoubleklib( mainString : string; index : integer; delimiter : Char) : Double;');
 CL.AddDelphiFunction('Function getCSVFieldFromStringAsDouble2klib( mainString : string; index : integer; formatSettings : TFormatSettings; delimiter : Char) : Double;');
 CL.AddDelphiFunction('Function getCSVFieldFromStringAsIntegerklib( mainString : string; index : integer; delimiter : Char) : integer');
 CL.AddDelphiFunction('Function getCSVFieldFromStringklib( mainString : string; index : integer; delimiter : Char) : string');
 CL.AddDelphiFunction('Function getNumberOfLinesInStrFixedWordWrapklib( source : string) : integer');
 CL.AddDelphiFunction('Function stringToStrFixedWordWrapklib( source : string; fixedLen : Integer) : string');
 CL.AddDelphiFunction('Function stringToStringListWithFixedLenklib( source : string; fixedLen : Integer) : TStringList');
 CL.AddDelphiFunction('Function stringToStringListWithDelimiterklib( value : string; delimiter : Char) : TStringList');
 CL.AddDelphiFunction('Function stringToTStringListklib( source : string) : TStringList');
 CL.AddDelphiFunction('Function arrayOfStringToTStringListklib( arrayOfStrings : array of string) : TStringList');
 CL.AddDelphiFunction('Procedure splitStringsklib( source : string; delimiter : string; var destFirstString : string; var destSecondString : string);');
 CL.AddDelphiFunction('Procedure splitStrings2klib( source : string; delimiterPosition : integer; var destFirstString : string; var destSecondString : string);');
 CL.AddDelphiFunction('Function getMergedStringsklib( firstString : string; secondString : string; delimiter : string) : string');
 CL.AddDelphiFunction('Function checkIfEmailIsValidklib( email : string) : boolean');
 CL.AddDelphiFunction('Function checkIfMainStringContainsSubStringNoCaseSensitiveklib( mainString : string; subString : string) : boolean');
 CL.AddDelphiFunction('Function checkIfMainStringContainsSubStringklib( mainString : string; subString : string; caseSensitiveSearch : boolean) : boolean');
 CL.AddDelphiFunction('Function getDoubleAsStringklib( value : Double; decimalSeparator : char) : string');
 CL.AddDelphiFunction('Function getFloatToStrDecimalSeparatorklib : char');
 CL.AddDelphiFunction('Procedure tryToExecuteProcedureklib( myProcedure : TAnonymousMethodklib; raiseExceptionEnabled : boolean);');
 CL.AddDelphiFunction('Procedure tryToExecuteProcedure2klib( myProcedure : TCallBackklib; raiseExceptionEnabled : boolean);');
 //CL.AddDelphiFunction('Procedure tryToExecuteProcedure3( myProcedure : TProcedure; raiseExceptionEnabled : boolean);');
 CL.AddDelphiFunction('Procedure executeProcedureklib( myProcedure : TAnonymousMethodklib);');
 CL.AddDelphiFunction('Procedure executeProcedure2klib( myProcedure : TCallBackklib);');
 CL.AddDelphiFunction('function setResourceHInstanceklib(aresource: longword): longword;');

 CL.AddDelphiFunction('function executeAndWaitExe(fileName: string; params: string; exceptionIfReturnCodeIsNot0: boolean): LongInt;');
 CL.AddDelphiFunction('function getIPFromHostName(hostName: string): string;');
 CL.AddDelphiFunction('function getLastSysErrorMessage: string;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure executeProcedure2_P( myProcedure : TCallBack);
Begin KLibUtils.executeProcedure(myProcedure); END;

(*----------------------------------------------------------------------------*)
Procedure executeProcedure_P( myProcedure : TAnonymousMethod);
Begin KLibUtils.executeProcedure(myProcedure); END;

(*----------------------------------------------------------------------------*)
Procedure tryToExecuteProcedure3_P( myProcedure : TProcedure; raiseExceptionEnabled : boolean);
Begin //KLibUtils.tryToExecuteProcedure(myProcedure, raiseExceptionEnabled);
END;

(*----------------------------------------------------------------------------*)
Procedure tryToExecuteProcedure2_P( myProcedure : TCallBack; raiseExceptionEnabled : boolean);
Begin KLibUtils.tryToExecuteProcedure(myProcedure, raiseExceptionEnabled); END;

(*----------------------------------------------------------------------------*)
Procedure tryToExecuteProcedure_P( myProcedure : TAnonymousMethod; raiseExceptionEnabled : boolean);
Begin //KLibUtils.tryToExecuteProcedure(myProcedure, raiseExceptionEnabled);
END;

(*----------------------------------------------------------------------------*)
Procedure splitStrings2_P( source : string; delimiterPosition : integer; var destFirstString : string; var destSecondString : string);
Begin KLibUtils.splitStrings(source, delimiterPosition, destFirstString, destSecondString); END;

(*----------------------------------------------------------------------------*)
Procedure splitStrings_P( source : string; delimiter : string; var destFirstString : string; var destSecondString : string);
Begin KLibUtils.splitStrings(source, delimiter, destFirstString, destSecondString); END;

(*----------------------------------------------------------------------------*)
Function getCSVFieldFromStringAsDouble2_P( mainString : string; index : integer; formatSettings : TFormatSettings; delimiter : Char) : Double;
Begin Result := KLibUtils.getCSVFieldFromStringAsDouble(mainString, index, formatSettings, delimiter); END;

(*----------------------------------------------------------------------------*)
Function getCSVFieldFromStringAsDouble_P( mainString : string; index : integer; delimiter : Char) : Double;
Begin Result := KLibUtils.getCSVFieldFromStringAsDouble(mainString, index, delimiter); END;

(*----------------------------------------------------------------------------*)
Function getCSVFieldFromStringAsDate1_P( mainString : string; index : integer; formatSettings : TFormatSettings; delimiter : Char) : TDatetime;
Begin Result := KLibUtils.getCSVFieldFromStringAsDate(mainString, index, formatSettings, delimiter); END;

(*----------------------------------------------------------------------------*)
Function getCSVFieldFromStringAsDate_P( mainString : string; index : integer; delimiter : Char) : TDatetime;
Begin Result := KLibUtils.getCSVFieldFromStringAsDate(mainString, index, delimiter); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KLibUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@deleteFilesInDir, 'deleteFilesInDirklib', cdRegister);
 S.RegisterDelphiFunction(@deleteFilesInDirWithStartingFileName, 'deleteFilesInDirWithStartingFileNameklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfFileExistsAndEmpty, 'checkIfFileExistsAndEmptyklib', cdRegister);
 S.RegisterDelphiFunction(@deleteFileIfExists, 'deleteFileIfExistsklib', cdRegister);
 S.RegisterDelphiFunction(@getTextFromFile, 'getTextFromFileklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfThereIsSpaceAvailableOnDrive, 'checkIfThereIsSpaceAvailableOnDriveklib', cdRegister);
 S.RegisterDelphiFunction(@getFreeSpaceOnDrive, 'getFreeSpaceOnDriveklib', cdRegister);
 S.RegisterDelphiFunction(@getIndexOfDrive, 'getIndexOfDriveklib', cdRegister);
 S.RegisterDelphiFunction(@getDriveExe, 'getDriveExeklib', cdRegister);
 S.RegisterDelphiFunction(@getDirSize, 'getDirSizeklib', cdRegister);
 S.RegisterDelphiFunction(@getCombinedPathWithCurrentDir, 'getCombinedPathWithCurrentDirklib', cdRegister);
 S.RegisterDelphiFunction(@getDirExe, 'getDirExeklib', cdRegister);
 S.RegisterDelphiFunction(@createDirIfNotExists, 'createDirIfNotExistsklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfIsLinuxSubDir, 'checkIfIsLinuxSubDirklib', cdRegister);
 S.RegisterDelphiFunction(@getPathInLinuxStyle, 'getPathInLinuxStyleklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfIsSubDir, 'checkIfIsSubDirklib', cdRegister);
 S.RegisterDelphiFunction(@getValidFullPath, 'getValidFullPathklib', cdRegister);
 S.RegisterDelphiFunction(@checkMD5File, 'checkMD5Fileklib', cdRegister);
 S.RegisterDelphiFunction(@unzipResource, 'unzipResourceklib', cdRegister);
 //S.RegisterDelphiFunction(@getPNGResource, 'getPNGResource', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsEXEFile, 'getResourceAsEXEFileklib', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsZIPFile, 'getResourceAsZIPFileklib', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsFile, 'getResourceAsFileklib', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsString, 'getResourceAsString', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsString, 'getResourceAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getResourceAsStream, 'getResourceAsStreamklib', cdRegister);
 S.RegisterDelphiFunction(@unzip, 'unzipklib', cdRegister);
 S.RegisterDelphiFunction(@checkRequiredFTPProperties, 'checkRequiredFTPPropertiesklib', cdRegister);
 S.RegisterDelphiFunction(@getValidItalianTelephoneNumber, 'getValidItalianTelephoneNumberklib', cdRegister);
 S.RegisterDelphiFunction(@getValidTelephoneNumber, 'getValidTelephoneNumberklib', cdRegister);
 S.RegisterDelphiFunction(@getRandString, 'getRandStringklib', cdRegister);
 S.RegisterDelphiFunction(@getFirstFileNameInDir, 'getFirstFileNameInDirklib', cdRegister);
 S.RegisterDelphiFunction(@getFileNamesListInDir, 'getFileNamesListInDirklib', cdRegister);
 S.RegisterDelphiFunction(@saveToFile, 'saveToFileklib', cdRegister);
 S.RegisterDelphiFunction(@getCombinedPath, 'getCombinedPathklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentDayOfWeekAsString, 'getCurrentDayOfWeekAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getDayOfWeekAsString, 'getDayOfWeekAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentDateTimeAsString, 'getCurrentDateTimeAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getDateTimeAsString, 'getDateTimeAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentDateAsString, 'getCurrentDateAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getDateAsString, 'getDateAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentTimeStamp, 'getCurrentTimeStampklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentDateTimeAsStringWithFormatting, 'getCurrentDateTimeAsStringWithFormattingklib', cdRegister);
 S.RegisterDelphiFunction(@getDateTimeAsStringWithFormatting, 'getDateTimeAsStringWithFormattingklib', cdRegister);
 S.RegisterDelphiFunction(@getCurrentDateTime, 'getCurrentDateTimeklib', cdRegister);
 S.RegisterDelphiFunction(@getParsedXMLstring, 'getParsedXMLstringklib', cdRegister);
 S.RegisterDelphiFunction(@getDoubleQuotedString, 'getDoubleQuotedStringklib', cdRegister);
 S.RegisterDelphiFunction(@getSingleQuotedString, 'getSingleQuotedStringklib', cdRegister);
 S.RegisterDelphiFunction(@getMainStringWithSubStringInserted, 'getMainStringWithSubStringInsertedklib', cdRegister);
 S.RegisterDelphiFunction(@getStringWithoutLineBreaks, 'getStringWithoutLineBreaksklib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromStringAsDate, 'getCSVFieldFromStringAsDateklib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromStringAsDate1_P, 'getCSVFieldFromStringAsDate1klib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromStringAsDouble, 'getCSVFieldFromStringAsDoubleklib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromStringAsDouble2_P, 'getCSVFieldFromStringAsDouble2klib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromStringAsInteger, 'getCSVFieldFromStringAsIntegerklib', cdRegister);
 S.RegisterDelphiFunction(@getCSVFieldFromString, 'getCSVFieldFromStringklib', cdRegister);
 S.RegisterDelphiFunction(@getNumberOfLinesInStrFixedWordWrap, 'getNumberOfLinesInStrFixedWordWrapklib', cdRegister);
 S.RegisterDelphiFunction(@stringToStrFixedWordWrap, 'stringToStrFixedWordWrapklib', cdRegister);
 S.RegisterDelphiFunction(@stringToStringListWithFixedLen, 'stringToStringListWithFixedLenklib', cdRegister);
 S.RegisterDelphiFunction(@stringToStringListWithDelimiter, 'stringToStringListWithDelimiterklib', cdRegister);
 S.RegisterDelphiFunction(@stringToTStringList, 'stringToTStringListklib', cdRegister);
 S.RegisterDelphiFunction(@arrayOfStringToTStringList, 'arrayOfStringToTStringListklib', cdRegister);
 S.RegisterDelphiFunction(@splitStrings, 'splitStringsklib', cdRegister);
 S.RegisterDelphiFunction(@splitStrings2_P, 'splitStrings2klib', cdRegister);
 S.RegisterDelphiFunction(@getMergedStrings, 'getMergedStringsklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfEmailIsValid, 'checkIfEmailIsValidklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfMainStringContainsSubStringNoCaseSensitive, 'checkIfMainStringContainsSubStringNoCaseSensitiveklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfMainStringContainsSubString, 'checkIfMainStringContainsSubStringklib', cdRegister);
 S.RegisterDelphiFunction(@getDoubleAsString, 'getDoubleAsStringklib', cdRegister);
 S.RegisterDelphiFunction(@getFloatToStrDecimalSeparator, 'getFloatToStrDecimalSeparatorklib', cdRegister);
 S.RegisterDelphiFunction(@tryToExecuteProcedure, 'tryToExecuteProcedureklib', cdRegister);
 S.RegisterDelphiFunction(@tryToExecuteProcedure2_P, 'tryToExecuteProcedure2klib', cdRegister);
 S.RegisterDelphiFunction(@tryToExecuteProcedure3_P, 'tryToExecuteProcedure3klib', cdRegister);
 S.RegisterDelphiFunction(@executeProcedure, 'executeProcedureklib', cdRegister);
 S.RegisterDelphiFunction(@executeProcedure2_P, 'executeProcedure2klib', cdRegister);
 S.RegisterDelphiFunction(@setResourceHInstance, 'setResourceHInstanceklib', cdRegister);
 S.RegisterDelphiFunction(@executeAndWaitExe, 'executeAndWaitExe', cdRegister);
 S.RegisterDelphiFunction(@getIPFromHostName, 'getIPFromHostName', cdRegister);
 S.RegisterDelphiFunction(@getLastSysErrorMessage, 'getLastSysErrorMessage', cdRegister);


 end;



{ TPSImport_KLibUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLibUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KLibUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLibUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KLibUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
