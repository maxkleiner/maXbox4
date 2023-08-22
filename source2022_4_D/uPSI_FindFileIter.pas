unit uPSI_FindFileIter;
{
  iterator interface as service locator
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
  TPSImport_FindFileIter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IFindFileIterator(CL: TPSPascalCompiler);
procedure SIRegister_FindFileIter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FindFileIter_Routines(S: TPSExec);

procedure Register;

implementation


uses
   FindFileIter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FindFileIter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IFindFileIterator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IFindFileIterator') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IFindFileIterator, 'IFindFileIterator') do
  begin
    RegisterMethod('Function Next : Boolean', cdRegister);
    RegisterMethod('Function SearchRec : TSearchRec', cdRegister);
    RegisterMethod('Function Time : TDateTime', cdRegister);
    RegisterMethod('Function Size : Int64', cdRegister);
    RegisterMethod('Function Attr : Integer', cdRegister);
    RegisterMethod('Function Name : TFileName', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FindFileIter(CL: TPSPascalCompiler);
begin
  SIRegister_IFindFileIterator(CL);
 CL.AddDelphiFunction('Function CreateFindFile( const Path : string; IncludeAttr : Integer; out iffi : IFindFileIterator) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_FindFileIter_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateFindFile, 'CreateFindFile', cdRegister);
end;

 
 
{ TPSImport_FindFileIter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FindFileIter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FindFileIter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FindFileIter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FindFileIter_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
