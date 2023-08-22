unit uPSI_MaxUtils;
{
    64 units of V4
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
  TPSImport_MaxUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MaxUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MaxUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   MaxUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxUtils]);
end;

function HTMLEncode3(const Data: string): string;
var
  iPos, i: Integer;

  procedure Encode(const AStr: String);
  begin
    Move(AStr[1], result[iPos], Length(AStr) * SizeOf(Char));
    Inc(iPos, Length(AStr));
  end;

begin
  SetLength(result, Length(Data) * 6);
  iPos := 1;
  for i := 1 to length(Data) do
    case Data[i] of
      '<': Encode('&lt;');
      '>': Encode('&gt;');
      '&': Encode('&amp;');
      '"': Encode('&quot;');
    else
      result[iPos] := Data[i];
      Inc(iPos);
    end;
  SetLength(result, iPos - 1);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('MaxCharSet', 'set of Char');
 CL.AddDelphiFunction('Function GetMachineNamemax : String');
 CL.AddDelphiFunction('Function GetModuleNamemax( HModule : THandle) : String');
 CL.AddDelphiFunction('Function TrimChars( const S : string; Chars : MaxCharSet) : string');
 CL.AddDelphiFunction('Function TickCountToDateTime( Ticks : Cardinal) : TDateTime');
 CL.AddDelphiFunction('Procedure OutputDebugStringmax( const S : String)');
 CL.AddDelphiFunction('Procedure OutputDebugFormat( const FmtStr : String; Args : array of const)');
 CL.AddDelphiFunction('Function IsAppRunningInDelphi : Boolean');
 CL.AddDelphiFunction('function HTMLEncode3(const Data: string): string;');



end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetMachineName, 'GetMachineNamemax', cdRegister);
 S.RegisterDelphiFunction(@GetModuleName, 'GetModuleNamemax', cdRegister);
 S.RegisterDelphiFunction(@TrimChars, 'TrimChars', cdRegister);
 S.RegisterDelphiFunction(@TickCountToDateTime, 'TickCountToDateTime', cdRegister);
 S.RegisterDelphiFunction(@OutputDebugString, 'OutputDebugStringmax', cdRegister);
 S.RegisterDelphiFunction(@OutputDebugFormat, 'OutputDebugFormat', cdRegister);
 S.RegisterDelphiFunction(@IsAppRunningInDelphi, 'IsAppRunningInDelphi', cdRegister);
  S.RegisterDelphiFunction(@HTMLEncode3, 'HTMLEncode3', cdRegister);

 end;



{ TPSImport_MaxUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
