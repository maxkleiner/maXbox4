unit uPSI_IBUtils;
{
  name prefix is IB
  renaming to standard additional cause no namespace conflict
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
  TPSImport_IBUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIBTimer(CL: TPSPascalCompiler);
procedure SIRegister_IBUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIBTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IBUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Types
  //,ThreadedTimer
  ,DB
  ,DBCommon
  ,IBUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IBUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIBTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIBTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CRLF','string').SetString(#13#10);
 //CL.AddConstantN('CRLF','Char').SetString( #10);
 CL.AddConstantN('CR','Char').SetString(#13);
 CL.AddConstantN('LF','Char').SetString(#10);
 CL.AddConstantN('TAB','Char').SetString(#9);
 CL.AddConstantN('NULL_TERMINATOR','Char').SetString(#0);
 CL.AddDelphiFunction('Function IBMax( n1, n2 : Integer) : Integer');
 CL.AddDelphiFunction('Function IBMin( n1, n2 : Integer) : Integer');
 CL.AddDelphiFunction('Function IBRandomString( iLength : Integer) : String');
 CL.AddDelphiFunction('Function IBRandomInteger( iLow, iHigh : Integer) : Integer');
 CL.AddDelphiFunction('Function IBStripString( st : String; CharsToStrip : String) : String');
 CL.AddDelphiFunction('Function IBFormatIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function IBFormatIdentifierValue( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function IBExtractIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function IBQuoteIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function IBAddIBParamSQLForDetail( Params : TParams; SQL : string; Native : Boolean; Dialect : Integer) : string');
 CL.AddDelphiFunction('Procedure IBDecomposeDatabaseName( DatabaseName : String; var ServerName, Protocol, DatabasePath : String)');
 CL.AddDelphiFunction('Function RandomString( iLength : Integer) : String');
 CL.AddDelphiFunction('Function RandomInteger( iLow, iHigh : Integer) : Integer');
 CL.AddDelphiFunction('Function StripString( st : String; CharsToStrip : String) : String');
 CL.AddDelphiFunction('Function FormatIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function FormatIdentifierValue( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function ExtractIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function QuoteIdentifier( Dialect : Integer; Value : String) : String');
 CL.AddDelphiFunction('Function AddIBParamSQLForDetail( Params : TParams; SQL : string; Native : Boolean; Dialect : Integer) : string');
 CL.AddDelphiFunction('Procedure DecomposeDatabaseName( DatabaseName : String; var ServerName, Protocol, DatabasePath : String)');
 CL.AddDelphiFunction('function NextSQLToken(var p: PChar; var Token: String; CurSection: TSQLToken): TSQLToken;');

 //procedure IBError(ErrMess: TIBClientError; const Args: array of const);

  SIRegister_TIBTimer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBTimer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBTimerOnTimer_W(Self: TIBTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTimerOnTimer_R(Self: TIBTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TIBTimerInterval_W(Self: TIBTimer; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTimerInterval_R(Self: TIBTimer; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TIBTimerEnabled_W(Self: TIBTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTimerEnabled_R(Self: TIBTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBTimer) do begin
    RegisterConstructor(@TIBTimer.Create, 'Create');
    RegisterPropertyHelper(@TIBTimerEnabled_R,@TIBTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TIBTimerInterval_R,@TIBTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TIBTimerOnTimer_R,@TIBTimerOnTimer_W,'OnTimer');
  end;

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Max, 'IBMax', cdRegister);
 S.RegisterDelphiFunction(@Min, 'IBMin', cdRegister);
 S.RegisterDelphiFunction(@RandomString, 'IBRandomString', cdRegister);
 S.RegisterDelphiFunction(@RandomInteger, 'IBRandomInteger', cdRegister);
 S.RegisterDelphiFunction(@StripString, 'IBStripString', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifier, 'IBFormatIdentifier', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifierValue, 'IBFormatIdentifierValue', cdRegister);
 S.RegisterDelphiFunction(@ExtractIdentifier, 'IBExtractIdentifier', cdRegister);
 S.RegisterDelphiFunction(@QuoteIdentifier, 'IBQuoteIdentifier', cdRegister);
 S.RegisterDelphiFunction(@AddIBParamSQLForDetail, 'IBAddIBParamSQLForDetail', cdRegister);
 S.RegisterDelphiFunction(@DecomposeDatabaseName, 'IBDecomposeDatabaseName', cdRegister);
 S.RegisterDelphiFunction(@RandomString, 'RandomString', cdRegister);
 S.RegisterDelphiFunction(@RandomInteger, 'RandomInteger', cdRegister);
 S.RegisterDelphiFunction(@StripString, 'StripString', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifier, 'FormatIdentifier', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifierValue, 'FormatIdentifierValue', cdRegister);
 S.RegisterDelphiFunction(@ExtractIdentifier, 'ExtractIdentifier', cdRegister);
 S.RegisterDelphiFunction(@QuoteIdentifier, 'QuoteIdentifier', cdRegister);
 S.RegisterDelphiFunction(@AddIBParamSQLForDetail, 'AddIBParamSQLForDetail', cdRegister);
 S.RegisterDelphiFunction(@DecomposeDatabaseName, 'DecomposeDatabaseName', cdRegister);
 S.RegisterDelphiFunction(@NextSQLToken, 'NextSQLToken', cdRegister);


  //RIRegister_TIBTimer(CL);
  //with CL.Add(TIBTimer) do
end;

 
 
{ TPSImport_IBUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IBUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IBUtils(ri);
  RIRegister_IBUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
