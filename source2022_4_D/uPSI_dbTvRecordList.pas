unit uPSI_dbTvRecordList;
{
   a rec to dbtreeview
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
  TPSImport_dbTvRecordList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTVRecordList(CL: TPSPascalCompiler);
procedure SIRegister_TTVParentList(CL: TPSPascalCompiler);
procedure SIRegister_TTVTextList(CL: TPSPascalCompiler);
procedure SIRegister_TTvRecordInfo(CL: TPSPascalCompiler);
procedure SIRegister_dbTvRecordList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTVRecordList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTVParentList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTVTextList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTvRecordInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_dbTvRecordList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   dbTvRecordList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dbTvRecordList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTVRecordList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TTVRecordList') do
  with CL.AddClassN(CL.FindClass('TList'),'TTVRecordList') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddRecord( const AID, AParent, AText : String)');
    RegisterMethod('Function FindID( const ID : String; var Index : Integer) : Boolean');
    RegisterMethod('Function FindParent( const Parent : String; var ParentIndex : Integer) : Boolean');
    RegisterMethod('Function FindTextID( const S : string; var ID : String; InternalTVFindTextOptions : TInternalTVFindTextOptions) : Boolean');
    RegisterMethod('Function TextIDList( const S : string; InternalTVFindTextOptions : TInternalTVFindTextOptions) : TStringList');
    RegisterMethod('Function GetDifference( TVRecordList : TTVRecordList) : TTVRecordListDifference');
    RegisterMethod('Procedure ChangeParent( const AID, NewParent : String)');
    RegisterMethod('Procedure ChangeText( const AID, NewText : String)');
    RegisterProperty('UpperCaseTextList', 'TTVTextList', iptr);
    RegisterProperty('TextList', 'TTVTextList', iptr);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('Parent', 'TTvRecordInfo Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTVParentList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TTVParentList') do
  with CL.AddClassN(CL.FindClass('TList'),'TTVParentList') do
  begin
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterMethod('Function FindParent( const Parent : String; var Index : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTVTextList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TTVTextList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TTVTextList') do
  begin
    RegisterMethod('Function PartialFind( const S : string; var Index : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTvRecordInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTvRecordInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTvRecordInfo') do begin
    RegisterProperty('ID', 'String', iptrw);
    RegisterProperty('Parent', 'String', iptrw);
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('WasExpanded', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( const AID, AParent, AText : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dbTvRecordList(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTVRecordListDifference', '( tvrldNone, tvrldText, tvrldCount, tvrldNodeMoved )');
  CL.AddTypeS('TInternalTVFindTextOption', '( itvftCaseInsensitive, itvftPartial )');
  CL.AddTypeS('TInternalTVFindTextOptions', 'set of TInternalTVFindTextOption');
  SIRegister_TTvRecordInfo(CL);
  SIRegister_TTVTextList(CL);
  SIRegister_TTVParentList(CL);
  SIRegister_TTVRecordList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTVRecordListParent_R(Self: TTVRecordList; var T: TTvRecordInfo; const t1: Integer);
begin T := Self.Parent[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTVRecordListSorted_W(Self: TTVRecordList; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TTVRecordListSorted_R(Self: TTVRecordList; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TTVRecordListTextList_R(Self: TTVRecordList; var T: TTVTextList);
begin T := Self.TextList; end;

(*----------------------------------------------------------------------------*)
procedure TTVRecordListUpperCaseTextList_R(Self: TTVRecordList; var T: TTVTextList);
begin T := Self.UpperCaseTextList; end;

(*----------------------------------------------------------------------------*)
procedure TTVParentListSorted_W(Self: TTVParentList; const T: Boolean);
Begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TTVParentListSorted_R(Self: TTVParentList; var T: Boolean);
Begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoWasExpanded_W(Self: TTvRecordInfo; const T: Boolean);
Begin Self.WasExpanded := T; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoWasExpanded_R(Self: TTvRecordInfo; var T: Boolean);
Begin T := Self.WasExpanded; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoText_W(Self: TTvRecordInfo; const T: String);
Begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoText_R(Self: TTvRecordInfo; var T: String);
Begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoParent_W(Self: TTvRecordInfo; const T: String);
Begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoParent_R(Self: TTvRecordInfo; var T: String);
Begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoID_W(Self: TTvRecordInfo; const T: String);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TTvRecordInfoID_R(Self: TTvRecordInfo; var T: String);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTVRecordList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTVRecordList) do begin
    RegisterConstructor(@TTVRecordList.Create, 'Create');
             RegisterMethod(@TTVRecordList.Destroy, 'Free');
    RegisterMethod(@TTVRecordList.AddRecord, 'AddRecord');
    RegisterMethod(@TTVRecordList.FindID, 'FindID');
    RegisterMethod(@TTVRecordList.FindParent, 'FindParent');
    RegisterMethod(@TTVRecordList.FindTextID, 'FindTextID');
    RegisterMethod(@TTVRecordList.TextIDList, 'TextIDList');
    RegisterMethod(@TTVRecordList.GetDifference, 'GetDifference');
    RegisterMethod(@TTVRecordList.ChangeParent, 'ChangeParent');
    RegisterMethod(@TTVRecordList.ChangeText, 'ChangeText');
    RegisterPropertyHelper(@TTVRecordListUpperCaseTextList_R,nil,'UpperCaseTextList');
    RegisterPropertyHelper(@TTVRecordListTextList_R,nil,'TextList');
    RegisterPropertyHelper(@TTVRecordListSorted_R,@TTVRecordListSorted_W,'Sorted');
    RegisterPropertyHelper(@TTVRecordListParent_R,nil,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTVParentList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTVParentList) do
  begin
    RegisterPropertyHelper(@TTVParentListSorted_R,@TTVParentListSorted_W,'Sorted');
    RegisterMethod(@TTVParentList.FindParent, 'FindParent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTVTextList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTVTextList) do
  begin
    RegisterMethod(@TTVTextList.PartialFind, 'PartialFind');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTvRecordInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTvRecordInfo) do
  begin
    RegisterPropertyHelper(@TTvRecordInfoID_R,@TTvRecordInfoID_W,'ID');
    RegisterPropertyHelper(@TTvRecordInfoParent_R,@TTvRecordInfoParent_W,'Parent');
    RegisterPropertyHelper(@TTvRecordInfoText_R,@TTvRecordInfoText_W,'Text');
    RegisterPropertyHelper(@TTvRecordInfoWasExpanded_R,@TTvRecordInfoWasExpanded_W,'WasExpanded');
    RegisterConstructor(@TTvRecordInfo.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dbTvRecordList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTvRecordInfo(CL);
  RIRegister_TTVTextList(CL);
  RIRegister_TTVParentList(CL);
  RIRegister_TTVRecordList(CL);
end;

 
 
{ TPSImport_dbTvRecordList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTvRecordList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dbTvRecordList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTvRecordList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dbTvRecordList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
