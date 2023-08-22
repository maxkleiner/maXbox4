unit uPSI_TokenLibrary2;
{
a second on to scanline    of C++

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
  TPSImport_TokenLibrary2 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTokens2(CL: TPSPascalCompiler);
procedure SIRegister_TokenLibrary2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTokens2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TokenLibrary2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   TokenLibrary2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TokenLibrary2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTokens2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTokens2') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTokens2') do begin
    RegisterMethod('Constructor Create( const OriginalString : STRING; const separators : STRING; const LeftMark : CHAR; const RightMark : CHAR; const Escape : CHAR; const SeparatorBetweenTokens : TTokenSeparator)');
    RegisterProperty('Token', 'STRING INTEGER', iptr);
    SetDefaultPropery('Token');
    RegisterProperty('OriginalString', 'STRING', iptr);
    RegisterProperty('Count', 'WORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TokenLibrary2(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTokenSeparator', '( tsSingleSeparatorBetweenTokens, tsMultipleSeparatorsBetweenTokens )');
  SIRegister_TTokens2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTokens2Count_R(Self: TTokens2; var T: WORD);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TTokens2OriginalString_R(Self: TTokens2; var T: STRING);
begin T := Self.OriginalString; end;

(*----------------------------------------------------------------------------*)
procedure TTokens2Token_R(Self: TTokens2; var T: STRING; const t1: INTEGER);
begin T := Self.Token[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTokens2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTokens2) do
  begin
    RegisterConstructor(@TTokens2.Create, 'Create');
    RegisterPropertyHelper(@TTokens2Token_R,nil,'Token');
    RegisterPropertyHelper(@TTokens2OriginalString_R,nil,'OriginalString');
    RegisterPropertyHelper(@TTokens2Count_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TokenLibrary2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTokens2(CL);
end;

 
 
{ TPSImport_TokenLibrary2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TokenLibrary2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TokenLibrary2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TokenLibrary2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TokenLibrary2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
