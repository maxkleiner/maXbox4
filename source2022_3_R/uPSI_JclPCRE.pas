unit uPSI_JclPCRE;
{
a lst REX implement

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
  TPSImport_JclPCRE = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclAnsiRegEx(CL: TPSPascalCompiler);
procedure SIRegister_EPCREError(CL: TPSPascalCompiler);
procedure SIRegister_JclPCRE(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclPCRE_Routines(S: TPSExec);
procedure RIRegister_TJclAnsiRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_EPCREError(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclPCRE(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   pcre
  //,JclUnitVersioning
  ,Windows
  //,Libc
  ,JclBase
  ,JclPCRE
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclPCRE]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclAnsiRegEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclAnsiRegEx') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclAnsiRegEx') do begin
    RegisterProperty('Options', 'TJclAnsiRegExOptions', iptrw);
   RegisterMethod('Procedure Free');
      RegisterMethod('Function Compile( const Pattern : AnsiString; Study : Boolean; UserLocale : Boolean) : Boolean');
    RegisterProperty('Pattern', 'AnsiString', iptr);
    RegisterProperty('DfaMode', 'Boolean', iptrw);
    RegisterMethod('Function Match( const Subject : AnsiString; StartOffset : Cardinal) : Boolean');
    RegisterProperty('Subject', 'AnsiString', iptr);
    RegisterProperty('Result', 'AnsiString', iptr);
    RegisterProperty('ViewChanges', 'Boolean', iptrw);
    RegisterProperty('CaptureCount', 'Integer', iptrw);
    RegisterProperty('Captures', 'AnsiString Integer', iptrw);
    RegisterProperty('CaptureRanges', 'TJclAnsiCaptureRange Integer', iptr);
    RegisterProperty('NamedCaptures', 'AnsiString AnsiString', iptrw);
    RegisterProperty('CaptureNameCount', 'Integer', iptr);
    RegisterProperty('CaptureNames', 'AnsiString Integer', iptr);
    RegisterMethod('Function IndexOfName( const Name : String) : Integer');
    RegisterMethod('Function IsNameValid( const Name : String) : Boolean');
    RegisterProperty('ErrorCode', 'Integer', iptr);
    RegisterProperty('ErrorMessage', 'AnsiString', iptr);
    RegisterProperty('ErrorOffset', 'Integer', iptr);
    RegisterProperty('OnCallout', 'TJclAnsiRegExCallout', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EPCREError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclError', 'EPCREError') do
  with CL.AddClassN(CL.FindClass('EJclError'),'EPCREError') do
  begin
    RegisterMethod('Constructor CreateRes( ResStringRec : PResStringRec; ErrorCode : Integer)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclPCRE(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JCL_PCRE_CALLOUT_NOERROR','LongInt').SetInt( 0);
 CL.AddConstantN('JCL_PCRE_CALLOUT_FAILCONTINUE','LongInt').SetInt( 1);
 CL.AddConstantN('JCL_PCRE_ERROR_CALLOUTERROR','LongInt').SetInt( - 998);
 CL.AddConstantN('JCL_PCRE_ERROR_STUDYFAILED','LongInt').SetInt( - 999);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclAnsiRegEx');
  SIRegister_EPCREError(CL);
  //CL.AddTypeS('PPCREIntArray', '^TPCREIntArray // will not work');
  CL.AddTypeS('TJclAnsiRegExOption', '( roIgnoreCase, roMultiLine, roDotAll, ro'
   +'Extended, roAnchored, roDollarEndOnly, roExtra, roNotBOL, roNotEOL, roUnGr'
   +'eedy, roNotEmpty, roUTF8, roNoAutoCapture, roNoUTF8Check, roAutoCallout, r'
   +'oPartial, roDfaShortest, roDfaRestart, roDfaFirstLine, roDupNames, roNewLi'
   +'neCR, roNewLineLF, roNewLineCRLF, roNewLineAny, roBSRAnyCRLF, roBSRUnicode'
   +', roJavascriptCompat )');
  CL.AddTypeS('TJclAnsiRegExOptions', 'set of TJclAnsiRegExOption');
  CL.AddTypeS('TJclAnsiCaptureRange', 'record FirstPos : Integer; LastPos : Integer; end');
  CL.AddTypeS('TJclAnsiRegExCallout', 'Procedure ( Sender : TJclAnsiRegEx; Inde'
   +'x, MatchStart, SubjectPos, LastCapture, PatternPos, NextItemLength : Integer; var ErrorCode : Integer)');
  CL.AddTypeS('TPCRECalloutIndex', 'Integer');
  SIRegister_TJclAnsiRegEx(CL);
 CL.AddDelphiFunction('Procedure InitializeLocaleSupport');
 CL.AddDelphiFunction('Procedure TerminateLocaleSupport');
 CL.AddDelphiFunction('Function StrReplaceRegEx( const Subject, Pattern : AnsiString; Args : array of const) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExOnCallout_W(Self: TJclAnsiRegEx; const T: TJclAnsiRegExCallout);
begin Self.OnCallout := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExOnCallout_R(Self: TJclAnsiRegEx; var T: TJclAnsiRegExCallout);
begin T := Self.OnCallout; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExErrorOffset_R(Self: TJclAnsiRegEx; var T: Integer);
begin T := Self.ErrorOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExErrorMessage_R(Self: TJclAnsiRegEx; var T: AnsiString);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExErrorCode_R(Self: TJclAnsiRegEx; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptureNames_R(Self: TJclAnsiRegEx; var T: AnsiString; const t1: Integer);
begin T := Self.CaptureNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptureNameCount_R(Self: TJclAnsiRegEx; var T: Integer);
begin T := Self.CaptureNameCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExNamedCaptures_W(Self: TJclAnsiRegEx; const T: AnsiString; const t1: AnsiString);
begin Self.NamedCaptures[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExNamedCaptures_R(Self: TJclAnsiRegEx; var T: AnsiString; const t1: AnsiString);
begin T := Self.NamedCaptures[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptureRanges_R(Self: TJclAnsiRegEx; var T: TJclAnsiCaptureRange; const t1: Integer);
begin T := Self.CaptureRanges[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptures_W(Self: TJclAnsiRegEx; const T: AnsiString; const t1: Integer);
begin Self.Captures[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptures_R(Self: TJclAnsiRegEx; var T: AnsiString; const t1: Integer);
begin T := Self.Captures[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptureCount_W(Self: TJclAnsiRegEx; const T: Integer);
begin Self.CaptureCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExCaptureCount_R(Self: TJclAnsiRegEx; var T: Integer);
begin T := Self.CaptureCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExViewChanges_W(Self: TJclAnsiRegEx; const T: Boolean);
begin Self.ViewChanges := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExViewChanges_R(Self: TJclAnsiRegEx; var T: Boolean);
begin T := Self.ViewChanges; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExResult_R(Self: TJclAnsiRegEx; var T: AnsiString);
begin T := Self.Result; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExSubject_R(Self: TJclAnsiRegEx; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExDfaMode_W(Self: TJclAnsiRegEx; const T: Boolean);
begin Self.DfaMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExDfaMode_R(Self: TJclAnsiRegEx; var T: Boolean);
begin T := Self.DfaMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExPattern_R(Self: TJclAnsiRegEx; var T: AnsiString);
begin T := Self.Pattern; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExOptions_W(Self: TJclAnsiRegEx; const T: TJclAnsiRegExOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAnsiRegExOptions_R(Self: TJclAnsiRegEx; var T: TJclAnsiRegExOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure EPCREErrorErrorCode_R(Self: EPCREError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclPCRE_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitializeLocaleSupport, 'InitializeLocaleSupport', cdRegister);
 S.RegisterDelphiFunction(@TerminateLocaleSupport, 'TerminateLocaleSupport', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceRegEx, 'StrReplaceRegEx', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclAnsiRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclAnsiRegEx) do begin
    RegisterPropertyHelper(@TJclAnsiRegExOptions_R,@TJclAnsiRegExOptions_W,'Options');
    RegisterMethod(@TJclAnsiRegEx.Compile, 'Compile');
      RegisterMethod(@TJclAnsiRegEx.Destroy, 'Free');

    RegisterPropertyHelper(@TJclAnsiRegExPattern_R,nil,'Pattern');
    RegisterPropertyHelper(@TJclAnsiRegExDfaMode_R,@TJclAnsiRegExDfaMode_W,'DfaMode');
    RegisterMethod(@TJclAnsiRegEx.Match, 'Match');
    RegisterPropertyHelper(@TJclAnsiRegExSubject_R,nil,'Subject');
    RegisterPropertyHelper(@TJclAnsiRegExResult_R,nil,'Result');
    RegisterPropertyHelper(@TJclAnsiRegExViewChanges_R,@TJclAnsiRegExViewChanges_W,'ViewChanges');
    RegisterPropertyHelper(@TJclAnsiRegExCaptureCount_R,@TJclAnsiRegExCaptureCount_W,'CaptureCount');
    RegisterPropertyHelper(@TJclAnsiRegExCaptures_R,@TJclAnsiRegExCaptures_W,'Captures');
    RegisterPropertyHelper(@TJclAnsiRegExCaptureRanges_R,nil,'CaptureRanges');
    RegisterPropertyHelper(@TJclAnsiRegExNamedCaptures_R,@TJclAnsiRegExNamedCaptures_W,'NamedCaptures');
    RegisterPropertyHelper(@TJclAnsiRegExCaptureNameCount_R,nil,'CaptureNameCount');
    RegisterPropertyHelper(@TJclAnsiRegExCaptureNames_R,nil,'CaptureNames');
    RegisterMethod(@TJclAnsiRegEx.IndexOfName, 'IndexOfName');
    RegisterMethod(@TJclAnsiRegEx.IsNameValid, 'IsNameValid');
    RegisterPropertyHelper(@TJclAnsiRegExErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TJclAnsiRegExErrorMessage_R,nil,'ErrorMessage');
    RegisterPropertyHelper(@TJclAnsiRegExErrorOffset_R,nil,'ErrorOffset');
    RegisterPropertyHelper(@TJclAnsiRegExOnCallout_R,@TJclAnsiRegExOnCallout_W,'OnCallout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EPCREError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPCREError) do
  begin
    RegisterConstructor(@EPCREError.CreateRes, 'CreateRes');
    RegisterPropertyHelper(@EPCREErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclPCRE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclAnsiRegEx) do
  RIRegister_EPCREError(CL);
  RIRegister_TJclAnsiRegEx(CL);
end;

 
 
{ TPSImport_JclPCRE }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPCRE.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclPCRE(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPCRE.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclPCRE(ri);
  RIRegister_JclPCRE_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
