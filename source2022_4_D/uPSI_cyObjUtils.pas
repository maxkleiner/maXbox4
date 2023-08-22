unit uPSI_cyObjUtils;
{
   obj to class
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
  TPSImport_cyObjUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyObjUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyObjUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,Windows
  ,Graphics
  ,Forms
  ,ComCtrls
  ,Controls
  ,RichEdit
  ,cyStrUtils
  ,cyObjUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyObjUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyObjUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStringsSortType', '( stNone, stStringSensitive, stStringInsensitive, stExtended )');
  CL.AddTypeS('TStringsValueKind', '( skStringSensitive, skStringInsensitive, skExtended )');
  CL.AddTypeS('TcyLocateOption', '( lCaseInsensitive, lPartialKey )');
  CL.AddTypeS('TcyLocateOptions', 'set of TcyLocateOption');
 CL.AddDelphiFunction('Function StringsLocate( aList : TStrings; Value : String; Options : TcyLocateOptions) : Integer;');
 CL.AddDelphiFunction('Function StringsLocate1( aList : TStrings; Value : String; ValueKind : TStringsValueKind) : Integer;');
 CL.AddDelphiFunction('Function StringsAdd( aList : TStrings; Value : String; Unique : Boolean; SortType : TStringsSortType) : Integer');
 CL.AddDelphiFunction('Procedure StringsReplace( aList : TStrings; OldStr : String; NewStr : String; ValueKind : TStringsValueKind)');
 CL.AddDelphiFunction('Procedure StringsSort( aList : TStrings; SortType : TStringsSortType)');
 CL.AddDelphiFunction('Function TreeNodeLocate( ParentNode : TTreeNode; Value : String) : TTreeNode');
 CL.AddDelphiFunction('Function TreeNodeLocateOnLevel( TreeView : TTreeView; OnLevel : Integer; Value : String) : TTreeNode');
 CL.AddDelphiFunction('Function TreeNodeGetChildFromIndex( TreeView : TTreeView; ParentNode : TTreeNode; ChildIndex : Integer) : TTreeNode');
 CL.AddDelphiFunction('Function TreeNodeGetParentOnLevel( ChildNode : TTreeNode; ParentLevel : Integer) : TTreeNode');
 CL.AddDelphiFunction('Procedure TreeNodeCopy( FromNode : TTreeNode; ToNode : TTreeNode; const CopyChildren : Boolean; const CopySubChildren : Boolean)');
 CL.AddDelphiFunction('Procedure RichEditSetStr( aRichEdit : TRichEdit; FormatedString : String)');
 CL.AddDelphiFunction('Procedure RichEditStringReplace( aRichEdit : TRichEdit; OldPattern, NewPattern : string; Flags : TReplaceFlags)');
 CL.AddDelphiFunction('Function GetTopMostControlAtPos( FromControl : TWinControl; aControlPoint : TPoint) : TControl');
 CL.AddDelphiFunction('Procedure cyCenterControl( aControl : TControl)');
 CL.AddDelphiFunction('Function GetLastParent( aControl : TControl) : TWinControl');
 CL.AddDelphiFunction('Function GetControlBitmap( aControl : TWinControl) : TBitmap');
 CL.AddDelphiFunction('Function GetRichEditBitmap( aRichEdit : TRichEdit) : TBitmap');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function StringsLocate1_P( aList : TStrings; Value : String; ValueKind : TStringsValueKind) : Integer;
Begin Result := cyObjUtils.StringsLocate(aList, Value, ValueKind); END;

(*----------------------------------------------------------------------------*)
Function StringsLocate_P( aList : TStrings; Value : String; Options : TcyLocateOptions) : Integer;
Begin Result := cyObjUtils.StringsLocate(aList, Value, Options); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyObjUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StringsLocate, 'StringsLocate', cdRegister);
 S.RegisterDelphiFunction(@StringsLocate1_P, 'StringsLocate1', cdRegister);
 S.RegisterDelphiFunction(@StringsAdd, 'StringsAdd', cdRegister);
 S.RegisterDelphiFunction(@StringsReplace, 'StringsReplace', cdRegister);
 S.RegisterDelphiFunction(@StringsSort, 'StringsSort', cdRegister);
 S.RegisterDelphiFunction(@TreeNodeLocate, 'TreeNodeLocate', cdRegister);
 S.RegisterDelphiFunction(@TreeNodeLocateOnLevel, 'TreeNodeLocateOnLevel', cdRegister);
 S.RegisterDelphiFunction(@TreeNodeGetChildFromIndex, 'TreeNodeGetChildFromIndex', cdRegister);
 S.RegisterDelphiFunction(@TreeNodeGetParentOnLevel, 'TreeNodeGetParentOnLevel', cdRegister);
 S.RegisterDelphiFunction(@TreeNodeCopy, 'TreeNodeCopy', cdRegister);
 S.RegisterDelphiFunction(@RichEditSetStr, 'RichEditSetStr', cdRegister);
 S.RegisterDelphiFunction(@RichEditStringReplace, 'RichEditStringReplace', cdRegister);
 S.RegisterDelphiFunction(@GetTopMostControlAtPos, 'GetTopMostControlAtPos', cdRegister);
 S.RegisterDelphiFunction(@CenterControl, 'cyCenterControl', cdRegister);
 S.RegisterDelphiFunction(@GetLastParent, 'GetLastParent', cdRegister);
 S.RegisterDelphiFunction(@GetControlBitmap, 'GetControlBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetRichEditBitmap, 'GetRichEditBitmap', cdRegister);
end;



{ TPSImport_cyObjUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyObjUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyObjUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyObjUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyObjUtils(ri);
  RIRegister_cyObjUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
