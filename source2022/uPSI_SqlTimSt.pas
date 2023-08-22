unit uPSI_SqlTimSt;
{
DB Extensions for 3.9
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
  TPSImport_SqlTimSt = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SqlTimSt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SqlTimSt_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,SqlTimSt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SqlTimSt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SqlTimSt(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PSQLTimeStamp', '^TSQLTimeStamp // will not work');
  CL.AddTypeS('TSQLTimeStamp','record Year:SmallInt; Month:Word; Day:Word; Hour:Word; Minute:Word; Second:Word; Fractions:LongWord; end');
  {TIME_ZONE_INFORMATION = record
    Bias: Longint;
    StandardName: array[0..31] of WCHAR;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WCHAR;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;}

 {  CL.AddTypeS('_SYSTEMTIME', 'record wYear : Word; wMonth : Word; wDayOfWeek : '
   +'Word; wDay : Word; wHour : Word; wMinute : Word; wSecond : Word; wMillisec'
   +'onds : Word; end');
  CL.AddTypeS('TSystemTime', '_SYSTEMTIME');}

  CL.AddTypeS('_TIME_ZONE_INFORMATION','record Bias:Integer;StandardName: array[0..31] of PCHAR;'+
    'StandardDate: TSystemTime;StandardBias: Integer;DaylightName: array[0..31]of PCHAR;DaylightDate: TSystemTime;DaylightBias: Integer; end');

  CL.AddTypeS('TTimeZoneInformation','_TIME_ZONE_INFORMATION');
  CL.AddTypeS('TIME_ZONE_INFORMATION', '_TIME_ZONE_INFORMATION');
  CL.AddTypeS('TTimeZone', 'record FUsesDayligtSavings : Boolean; FInfo : TTime'
   +'ZoneInformation; end');
 CL.AddDelphiFunction('Procedure VarSQLTimeStampCreate4( var aDest : Variant; const ASQLTimeStamp : TSQLTimeStamp);');
 CL.AddDelphiFunction('Function VarSQLTimeStampCreate3: Variant;');
 CL.AddDelphiFunction('Function VarSQLTimeStampCreate2( const AValue : string) : Variant;');
 CL.AddDelphiFunction('Function VarSQLTimeStampCreate1( const AValue : TDateTime) : Variant;');
 CL.AddDelphiFunction('Function VarSQLTimeStampCreate( const ASQLTimeStamp : TSQLTimeStamp) : Variant;');
 CL.AddDelphiFunction('Function VarSQLTimeStamp : TVarType');
 CL.AddDelphiFunction('Function VarIsSQLTimeStamp( const aValue : Variant) : Boolean;');
 CL.AddDelphiFunction('Function LocalToUTC( var TZInfo : TTimeZone; var Value : TSQLTimeStamp) : TSQLTimeStamp');
 CL.AddDelphiFunction('Function UTCToLocal( var TZInfo : TTimeZone; var Value : TSQLTimeStamp) : TSQLTimeStamp');
 CL.AddDelphiFunction('Function VarToSQLTimeStamp( const aValue : Variant) : TSQLTimeStamp');
 CL.AddDelphiFunction('Function SQLTimeStampToStr( const Format : string; DateTime : TSQLTimeStamp) : string');
 CL.AddDelphiFunction('Function SQLDayOfWeek( const DateTime : TSQLTimeStamp) : integer');
 CL.AddDelphiFunction('Function DateTimeToSQLTimeStamp( const DateTime : TDateTime) : TSQLTimeStamp');
 CL.AddDelphiFunction('Function SQLTimeStampToDateTime( const DateTime : TSQLTimeStamp) : TDateTime');
 CL.AddDelphiFunction('Function TryStrToSQLTimeStamp( const S : string; var TimeStamp : TSQLTimeStamp) : Boolean');
 CL.AddDelphiFunction('Function StrToSQLTimeStamp( const S : string) : TSQLTimeStamp');
 CL.AddDelphiFunction('Procedure CheckSqlTimeStamp( const ASQLTimeStamp : TSQLTimeStamp)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function VarIsSQLTimeStamp_P( const aValue : Variant) : Boolean;
Begin Result := SqlTimSt.VarIsSQLTimeStamp(aValue); END;

(*----------------------------------------------------------------------------*)
Function VarSQLTimeStampCreate_P( const ASQLTimeStamp : TSQLTimeStamp) : Variant;
Begin Result := SqlTimSt.VarSQLTimeStampCreate(ASQLTimeStamp); END;

(*----------------------------------------------------------------------------*)
Function VarSQLTimeStampCreate_P1( const AValue : TDateTime) : Variant;
Begin Result := SqlTimSt.VarSQLTimeStampCreate(AValue); END;

(*----------------------------------------------------------------------------*)
Function VarSQLTimeStampCreate_P2( const AValue : string) : Variant;
Begin Result := SqlTimSt.VarSQLTimeStampCreate(AValue); END;

(*----------------------------------------------------------------------------*)
Function VarSQLTimeStampCreate_P3 : Variant;
Begin Result := SqlTimSt.VarSQLTimeStampCreate; END;

(*----------------------------------------------------------------------------*)
Procedure VarSQLTimeStampCreate_P4( var aDest : Variant; const ASQLTimeStamp : TSQLTimeStamp);
Begin SqlTimSt.VarSQLTimeStampCreate(aDest, ASQLTimeStamp); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SqlTimSt_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VarSQLTimeStampCreate_P, 'VarSQLTimeStampCreate', cdRegister);
 S.RegisterDelphiFunction(@VarSQLTimeStampCreate_P1, 'VarSQLTimeStampCreate1', cdRegister);
 S.RegisterDelphiFunction(@VarSQLTimeStampCreate_P2, 'VarSQLTimeStampCreate2', cdRegister);
 S.RegisterDelphiFunction(@VarSQLTimeStampCreate_P3, 'VarSQLTimeStampCreate3', cdRegister);
 S.RegisterDelphiFunction(@VarSQLTimeStampCreate_P4, 'VarSQLTimeStampCreate4', cdRegister);
 S.RegisterDelphiFunction(@VarSQLTimeStamp, 'VarSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@VarIsSQLTimeStamp, 'VarIsSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@LocalToUTC, 'LocalToUTC', cdRegister);
 S.RegisterDelphiFunction(@UTCToLocal, 'UTCToLocal', cdRegister);
 S.RegisterDelphiFunction(@VarToSQLTimeStamp, 'VarToSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@SQLTimeStampToStr, 'SQLTimeStampToStr', cdRegister);
 S.RegisterDelphiFunction(@SQLDayOfWeek, 'SQLDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToSQLTimeStamp, 'DateTimeToSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@SQLTimeStampToDateTime, 'SQLTimeStampToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryStrToSQLTimeStamp, 'TryStrToSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@StrToSQLTimeStamp, 'StrToSQLTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@CheckSqlTimeStamp, 'CheckSqlTimeStamp', cdRegister);
end;

 
 
{ TPSImport_SqlTimSt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SqlTimSt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SqlTimSt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SqlTimSt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SqlTimSt(ri);
  RIRegister_SqlTimSt_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
