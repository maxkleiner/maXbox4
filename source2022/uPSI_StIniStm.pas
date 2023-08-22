unit uPSI_StIniStm;
{

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
  TPSImport_StIniStm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStIniStream(CL: TPSPascalCompiler);
procedure SIRegister_StIniStm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StIniStm_Routines(S: TPSExec);
procedure RIRegister_TStIniStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_StIniStm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StStrms
  ,StIniStm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StIniStm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStIniStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStIniStream') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStIniStream') do begin
    RegisterMethod('Constructor Create( aStream : TStream)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function SectionExists( const Section : AnsiString) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : AnsiString) : AnsiString');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : AnsiString)');
    RegisterMethod('Procedure WriteSection( const Section : AnsiString; Strings : TStrings)');
    RegisterMethod('Procedure ReadSection( const Section : AnsiString; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : AnsiString; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : AnsiString)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : AnsiString)');
    RegisterMethod('Function ValueExists( const Section, Ident : AnsiString) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StIniStm(CL: TPSPascalCompiler);
begin
  SIRegister_TStIniStream(CL);
 CL.AddDelphiFunction('Procedure SplitNameValue( const Line : string; var Name, Value : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StIniStm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SplitNameValue, 'SplitNameValue', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStIniStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStIniStream) do begin
    RegisterConstructor(@TStIniStream.Create, 'Create');
    RegisterMethod(@TStIniStream.Destroy, 'Free');
    RegisterMethod(@TStIniStream.SectionExists, 'SectionExists');
    RegisterMethod(@TStIniStream.ReadString, 'ReadString');
    RegisterMethod(@TStIniStream.WriteString, 'WriteString');
    RegisterMethod(@TStIniStream.WriteSection, 'WriteSection');
    RegisterMethod(@TStIniStream.ReadSection, 'ReadSection');
    RegisterMethod(@TStIniStream.ReadSections, 'ReadSections');
    RegisterMethod(@TStIniStream.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TStIniStream.EraseSection, 'EraseSection');
    RegisterMethod(@TStIniStream.DeleteKey, 'DeleteKey');
    RegisterMethod(@TStIniStream.ValueExists, 'ValueExists');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StIniStm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStIniStream(CL);
end;

 
 
{ TPSImport_StIniStm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StIniStm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StIniStm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StIniStm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StIniStm(ri);
  RIRegister_StIniStm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
