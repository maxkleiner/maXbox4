unit uPSI_IdHeaderList;
{
  for custom headers
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
  TPSImport_IdHeaderList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdHeaderList(CL: TPSPascalCompiler);
procedure SIRegister_IdHeaderList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdHeaderList(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdHeaderList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdHeaderList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdHeaderList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHeaderList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TIdHeaderList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TIdHeaderList') do begin
    RegisterMethod('Procedure AddStdValues( ASrc : TStrings)');
    RegisterMethod('Procedure ConvertToStdValues( ADest : TStrings)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Extract( const AName : string; ADest : TStrings)');
    RegisterMethod('Function IndexOfName( const AName : string) : Integer');
    RegisterProperty('Names', 'string Integer', iptr);
    RegisterProperty('Values', 'string string', iptrw);
    RegisterProperty('NameValueSeparator', 'String', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('UnfoldLines', 'Boolean', iptrw);
    RegisterProperty('FoldLines', 'Boolean', iptrw);
    RegisterProperty('FoldLength', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdHeaderList(CL: TPSPascalCompiler);
begin
  SIRegister_TIdHeaderList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdHeaderListFoldLength_W(Self: TIdHeaderList; const T: Integer);
begin Self.FoldLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListFoldLength_R(Self: TIdHeaderList; var T: Integer);
begin T := Self.FoldLength; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListFoldLines_W(Self: TIdHeaderList; const T: Boolean);
begin Self.FoldLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListFoldLines_R(Self: TIdHeaderList; var T: Boolean);
begin T := Self.FoldLines; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListUnfoldLines_W(Self: TIdHeaderList; const T: Boolean);
begin Self.UnfoldLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListUnfoldLines_R(Self: TIdHeaderList; var T: Boolean);
begin T := Self.UnfoldLines; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListCaseSensitive_W(Self: TIdHeaderList; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListCaseSensitive_R(Self: TIdHeaderList; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListNameValueSeparator_W(Self: TIdHeaderList; const T: String);
begin Self.NameValueSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListNameValueSeparator_R(Self: TIdHeaderList; var T: String);
begin T := Self.NameValueSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListValues_W(Self: TIdHeaderList; const T: string; const t1: string);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListValues_R(Self: TIdHeaderList; var T: string; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdHeaderListNames_R(Self: TIdHeaderList; var T: string; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHeaderList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHeaderList) do begin
    RegisterMethod(@TIdHeaderList.AddStdValues, 'AddStdValues');
    RegisterMethod(@TIdHeaderList.ConvertToStdValues, 'ConvertToStdValues');
    RegisterConstructor(@TIdHeaderList.Create, 'Create');
    RegisterMethod(@TIdHeaderList.Extract, 'Extract');
    RegisterMethod(@TIdHeaderList.IndexOfName, 'IndexOfName');
    RegisterPropertyHelper(@TIdHeaderListNames_R,nil,'Names');
    RegisterPropertyHelper(@TIdHeaderListValues_R,@TIdHeaderListValues_W,'Values');
    RegisterPropertyHelper(@TIdHeaderListNameValueSeparator_R,@TIdHeaderListNameValueSeparator_W,'NameValueSeparator');
    RegisterPropertyHelper(@TIdHeaderListCaseSensitive_R,@TIdHeaderListCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TIdHeaderListUnfoldLines_R,@TIdHeaderListUnfoldLines_W,'UnfoldLines');
    RegisterPropertyHelper(@TIdHeaderListFoldLines_R,@TIdHeaderListFoldLines_W,'FoldLines');
    RegisterPropertyHelper(@TIdHeaderListFoldLength_R,@TIdHeaderListFoldLength_W,'FoldLength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdHeaderList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdHeaderList(CL);
end;



{ TPSImport_IdHeaderList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHeaderList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdHeaderList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHeaderList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdHeaderList(ri);
end;
(*----------------------------------------------------------------------------*)


end.
