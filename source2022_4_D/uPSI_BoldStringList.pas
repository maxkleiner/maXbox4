unit uPSI_BoldStringList;
{
   bold as bold can be
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
  TPSImport_BoldStringList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldStringList(CL: TPSPascalCompiler);
procedure SIRegister_BoldStringList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBoldStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldStringList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   BoldStringList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldStringList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TBoldStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TBoldStringList') do
  begin
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure AddMultipleStrings( StringArr : array of string)');
    RegisterMethod('Procedure AssignMultipleStrings( StringArr : array of string)');
    RegisterMethod('Function GetIndexOfName( const Name : String; var Index : integer) : Boolean');
    RegisterMethod('Function GetIndexOfprefix( const Name : String; var Index : integer) : Boolean');
    RegisterMethod('Procedure RemoveValue( const Name : String)');
    RegisterProperty('FastValues', 'String String', iptrw);
    RegisterProperty('ValueByIndex', 'string integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldStringList(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldStringList');
  SIRegister_TBoldStringList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBoldStringListValueByIndex_R(Self: TBoldStringList; var T: string; const t1: integer);
begin T := Self.ValueByIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBoldStringListFastValues_W(Self: TBoldStringList; const T: String; const t1: String);
begin Self.FastValues[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldStringListFastValues_R(Self: TBoldStringList; var T: String; const t1: String);
begin T := Self.FastValues[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldStringList) do
  begin
    RegisterMethod(@TBoldStringList.Sort, 'Sort');
    RegisterMethod(@TBoldStringList.AddMultipleStrings, 'AddMultipleStrings');
    RegisterMethod(@TBoldStringList.AssignMultipleStrings, 'AssignMultipleStrings');
    RegisterMethod(@TBoldStringList.GetIndexOfName, 'GetIndexOfName');
    RegisterMethod(@TBoldStringList.GetIndexOfprefix, 'GetIndexOfprefix');
    RegisterMethod(@TBoldStringList.RemoveValue, 'RemoveValue');
    RegisterPropertyHelper(@TBoldStringListFastValues_R,@TBoldStringListFastValues_W,'FastValues');
    RegisterPropertyHelper(@TBoldStringListValueByIndex_R,nil,'ValueByIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldStringList) do
  RIRegister_TBoldStringList(CL);
end;

 
 
{ TPSImport_BoldStringList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldStringList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldStringList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldStringList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldStringList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
