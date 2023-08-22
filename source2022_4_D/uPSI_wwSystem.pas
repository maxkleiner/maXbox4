unit uPSI_wwSystem;
{
   woll2woll big remainder of that time
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
  TPSImport_wwSystem = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_wwSystem(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_wwSystem_Routines(S: TPSExec);

procedure Register;

implementation


uses
   stdctrls
  ,wwSystem
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_wwSystem]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_wwSystem(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TwwDateOrder', '( doMDY, doDMY, doYMD )');
  CL.AddTypeS('TwwDateTimeSelection', '( wwdsDay, wwdsMonth, wwdsYear, wwdsHour'
   +', wwdsMinute, wwdsSecond, wwdsAMPM )');
 CL.AddDelphiFunction('Function wwStrToDate( const S : string) : boolean');
 CL.AddDelphiFunction('Function wwStrToTime( const S : string) : boolean');
 CL.AddDelphiFunction('Function wwStrToDateTime( const S : string) : boolean');
 CL.AddDelphiFunction('Function wwStrToTimeVal( const S : string) : TDateTime');
 CL.AddDelphiFunction('Function wwStrToDateVal( const S : string) : TDateTime');
 CL.AddDelphiFunction('Function wwStrToDateTimeVal( const S : string) : TDateTime');
 CL.AddDelphiFunction('Function wwStrToInt( const S : string) : boolean');
 CL.AddDelphiFunction('Function wwStrToFloat( const S : string) : boolean');
 CL.AddDelphiFunction('Function wwGetDateOrder( const DateFormat : string) : TwwDateOrder');
 CL.AddDelphiFunction('Function wwNextDay( Year, Month, Day : Word) : integer');
 CL.AddDelphiFunction('Function wwPriorDay( Year, Month, Day : Word) : integer');
 CL.AddDelphiFunction('Function wwDoEncodeDate( Year, Month, Day : Word; var Date : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function wwDoEncodeTime( Hour, Min, Sec, MSec : Word; var Time : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function wwGetDateTimeCursorPosition( SelStart : integer; Text : string; TimeOnly : Boolean) : TwwDateTimeSelection');
 CL.AddDelphiFunction('Function wwGetTimeCursorPosition( SelStart : integer; Text : string) : TwwDateTimeSelection');
 CL.AddDelphiFunction('Function wwScanDate( const S : string; var Date : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function wwScanDateEpoch( const S : string; var Date : TDateTime; Epoch : integer) : Boolean');
 CL.AddDelphiFunction('Procedure wwSetDateTimeCursorSelection( dateCursor : TwwDateTimeSelection; edit : TCustomEdit; TimeOnly : Boolean)');
 CL.AddDelphiFunction('Function wwStrToFloat2( const S : string; var FloatValue : Extended; DisplayFormat : string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_wwSystem_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@wwStrToDate, 'wwStrToDate', cdRegister);
 S.RegisterDelphiFunction(@wwStrToTime, 'wwStrToTime', cdRegister);
 S.RegisterDelphiFunction(@wwStrToDateTime, 'wwStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@wwStrToTimeVal, 'wwStrToTimeVal', cdRegister);
 S.RegisterDelphiFunction(@wwStrToDateVal, 'wwStrToDateVal', cdRegister);
 S.RegisterDelphiFunction(@wwStrToDateTimeVal, 'wwStrToDateTimeVal', cdRegister);
 S.RegisterDelphiFunction(@wwStrToInt, 'wwStrToInt', cdRegister);
 S.RegisterDelphiFunction(@wwStrToFloat, 'wwStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@wwGetDateOrder, 'wwGetDateOrder', cdRegister);
 S.RegisterDelphiFunction(@wwNextDay, 'wwNextDay', cdRegister);
 S.RegisterDelphiFunction(@wwPriorDay, 'wwPriorDay', cdRegister);
 S.RegisterDelphiFunction(@wwDoEncodeDate, 'wwDoEncodeDate', cdRegister);
 S.RegisterDelphiFunction(@wwDoEncodeTime, 'wwDoEncodeTime', cdRegister);
 S.RegisterDelphiFunction(@wwGetDateTimeCursorPosition, 'wwGetDateTimeCursorPosition', cdRegister);
 S.RegisterDelphiFunction(@wwGetTimeCursorPosition, 'wwGetTimeCursorPosition', cdRegister);
 S.RegisterDelphiFunction(@wwScanDate, 'wwScanDate', cdRegister);
 S.RegisterDelphiFunction(@wwScanDateEpoch, 'wwScanDateEpoch', cdRegister);
 S.RegisterDelphiFunction(@wwSetDateTimeCursorSelection, 'wwSetDateTimeCursorSelection', cdRegister);
 S.RegisterDelphiFunction(@wwStrToFloat2, 'wwStrToFloat2', cdRegister);
end;

 
 
{ TPSImport_wwSystem }
(*----------------------------------------------------------------------------*)
procedure TPSImport_wwSystem.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_wwSystem(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_wwSystem.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_wwSystem(ri);
  RIRegister_wwSystem_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
