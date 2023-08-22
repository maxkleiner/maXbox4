unit uPSI_DepWalkUtils;
{
   borland support
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
  TPSImport_DepWalkUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DepWalkUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DepWalkUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Controls
  ,DepWalkUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DepWalkUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DepWalkUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AWaitCursor : IUnknown');
 CL.AddDelphiFunction('Function ChangeCursor( NewCursor : TCursor) : IUnknown');
 CL.AddDelphiFunction('Procedure SuspendRedraw( AControl : TWinControl; Suspend : boolean)');
 CL.AddDelphiFunction('Function YesNo( const ACaption, AMsg : string) : boolean');
 CL.AddDelphiFunction('Procedure strTokenize( const S : string; Delims : TSysCharSet; Results : TStrings)');
 CL.AddDelphiFunction('Function GetBorlandLibPath( Version : integer; ForDelphi : boolean) : string');
 CL.AddDelphiFunction('Function GetExpandedLibRoot( Version : integer; ForDelphi : boolean) : string');
 CL.AddDelphiFunction('Procedure GetPathList( Version : integer; ForDelphi : boolean; Strings : TStrings)');
 CL.AddDelphiFunction('Procedure GetSystemPaths( Strings : TStrings)');
 CL.AddDelphiFunction('Procedure MakeEditNumeric( EditHandle : integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_DepWalkUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WaitCursor, 'AWaitCursor', cdRegister);
 S.RegisterDelphiFunction(@ChangeCursor, 'ChangeCursor', cdRegister);
 S.RegisterDelphiFunction(@SuspendRedraw, 'SuspendRedraw', cdRegister);
 S.RegisterDelphiFunction(@YesNo, 'YesNo', cdRegister);
 S.RegisterDelphiFunction(@strTokenize, 'strTokenize', cdRegister);
 S.RegisterDelphiFunction(@GetBorlandLibPath, 'GetBorlandLibPath', cdRegister);
 S.RegisterDelphiFunction(@GetExpandedLibRoot, 'GetExpandedLibRoot', cdRegister);
 S.RegisterDelphiFunction(@GetPathList, 'GetPathList', cdRegister);
 S.RegisterDelphiFunction(@GetSystemPaths, 'GetSystemPaths', cdRegister);
 S.RegisterDelphiFunction(@MakeEditNumeric, 'MakeEditNumeric', cdRegister);
end;

 
 
{ TPSImport_DepWalkUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DepWalkUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DepWalkUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DepWalkUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_DepWalkUtils(ri);
  RIRegister_DepWalkUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
