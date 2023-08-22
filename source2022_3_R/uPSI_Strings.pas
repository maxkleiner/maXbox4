unit uPSI_Strings;
{
just to please you

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
  TPSImport_Strings = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Strings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Strings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Strings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Strings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Strings(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function StrLenPchar( Str : PChar) : longint');
 CL.AddDelphiFunction('Function StrEndPchar( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrMovePchar( Dest, Source : Pchar; l : Longint) : pchar');
 CL.AddDelphiFunction('Function StrCopyPchar( Dest, Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrECopyPchar( Dest, Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLCopyPchar( Dest, Source : PChar; MaxLen : Longint) : PChar');
 CL.AddDelphiFunction('Function StrPCopyPchar( Dest : PChar; Source : String) : PChar');
 CL.AddDelphiFunction('Function StrCatPchar( Dest, Source : PChar) : PChar');
 CL.AddDelphiFunction('Function strlcatPchar( dest, source : pchar; l : Longint) : pchar');
 CL.AddDelphiFunction('Function StrCompPchar( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrICompPchar( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrLCompPchar( Str1, Str2 : PChar; MaxLen : Longint) : Integer');
 CL.AddDelphiFunction('Function StrLICompPchar( Str1, Str2 : PChar; MaxLen : Longint) : Integer');
 CL.AddDelphiFunction('Function StrScanPchar( Str : PChar; Ch : Char) : PChar');
 CL.AddDelphiFunction('Function StrRScanPchar( Str : PChar; Ch : Char) : PChar');
 CL.AddDelphiFunction('Function StrPosPchar( Str1, Str2 : PChar) : PChar');
 CL.AddDelphiFunction('Function StrUpperPchar( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLowerPchar( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrPasPchar( Str : PChar) : String');
 CL.AddDelphiFunction('Function StrNewPchar( P : PChar) : PChar');
 CL.AddDelphiFunction('Procedure StrDisposePchar( P : PChar)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Strings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StrLen, 'StrLenPchar', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'StrEndPchar', cdRegister);
 S.RegisterDelphiFunction(@StrMove, 'StrMovePchar', cdRegister);
 S.RegisterDelphiFunction(@StrCopy, 'StrCopyPchar', cdRegister);
 S.RegisterDelphiFunction(@StrECopy, 'StrECopyPchar', cdRegister);
 S.RegisterDelphiFunction(@StrLCopy, 'StrLCopyPchar', cdRegister);
 S.RegisterDelphiFunction(@StrPCopy, 'StrPCopyPchar', cdRegister);
 S.RegisterDelphiFunction(@StrCat, 'StrCatPchar', cdRegister);
 S.RegisterDelphiFunction(@strlcat, 'strlcatPchar', cdRegister);
 S.RegisterDelphiFunction(@StrComp, 'StrCompPchar', cdRegister);
 S.RegisterDelphiFunction(@StrIComp, 'StrICompPchar', cdRegister);
 S.RegisterDelphiFunction(@StrLComp, 'StrLCompPchar', cdRegister);
 S.RegisterDelphiFunction(@StrLIComp, 'StrLICompPchar', cdRegister);
 S.RegisterDelphiFunction(@StrScan, 'StrScanPchar', cdRegister);
 S.RegisterDelphiFunction(@StrRScan, 'StrRScanPchar', cdRegister);
 S.RegisterDelphiFunction(@StrPos, 'StrPosPchar', cdRegister);
 S.RegisterDelphiFunction(@StrUpper, 'StrUpperPchar', cdRegister);
 S.RegisterDelphiFunction(@StrLower, 'StrLowerPchar', cdRegister);
 S.RegisterDelphiFunction(@StrPas, 'StrPasPchar', cdRegister);
 S.RegisterDelphiFunction(@StrNew, 'StrNewPchar', cdRegister);
 S.RegisterDelphiFunction(@StrDispose, 'StrDisposePchar', cdRegister);
end;

 
 
{ TPSImport_Strings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Strings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Strings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Strings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Strings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
