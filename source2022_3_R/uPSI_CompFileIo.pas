unit uPSI_CompFileIo;
{
   for stream component frame
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
  TPSImport_CompFileIo = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TComponentStream(CL: TPSPascalCompiler);
procedure SIRegister_CompFileIo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CompFileIo_Routines(S: TPSExec);
procedure RIRegister_TComponentStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_CompFileIo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  ,StdCtrls
  ,TypInfo
  //,CodUtils
  ,CompFileIo
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CompFileIo]);
end;

function getallEvents(aform: TForm): TStringlist;
var
  x, y, z: Word;
  pl: PPropList;
begin
  result:= TStringlist.Create;
  y := GetPropList(aform, pl);
  for x := 0 to y - 1 do begin
    if Copy(pl[x].Name, 1, 2) <> 'On' then Continue;
    if GetMethodProp(aform, pl[x].Name).Code <> nil then
      result.Add(aform.Name + ' - ' + pl[x].Name);
  end;
  for z := 0 to aform.ComponentCount - 1 do begin
    y := GetPropList(aform.Components[z], pl);
    for x := 0 to y - 1 do begin
      if Copy(pl[x].Name, 1, 2) <> 'On' then Continue;
      if GetMethodProp(aform.Components[z], pl[x].Name).Code <> nil then
        result.Add(aform.Components[z].Name + ' - ' + pl[x].Name);
    end;
  end;
  //result.Free;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComponentStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TComponentStream') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TComponentStream') do
  begin
    RegisterMethod('Procedure SaveToFile( FileName : string)');
    RegisterMethod('Procedure LoadFromFile( FileName : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CompFileIo(CL: TPSPascalCompiler);
begin
  SIRegister_TComponentStream(CL);
  CL.AddTypeS('TComponentStream', 'TMemoryStream');
  //CL.AddTypeS('TPInt32', '^LongInt // will not work');
  //CL.AddTypeS('TFormClass', 'class of TCustomForm');
  //CL.AddTypeS('TComponentClass', 'class of TComponent');
  CL.AddTypeS('TComponentFileFormat', '( cffText, cffBinary )');
  //CL.AddTypeS('TPComponent', '^TComponent // will not work');
  CL.AddTypeS('TComponentArray', 'array of TComponent');
  //CL.AddTypeS('TPComponentArray', '^TComponentArray // will not work');
  CL.AddTypeS('TResourceNaming', '( rnClassNameTag, rnClassName, rnClassTag, rnNameTag, rnClass, rnName, rnTag )');
 CL.AddDelphiFunction('Function VOID_COMP : ___Pointer');
 CL.AddDelphiFunction('Function VOID_FORM : ___Pointer');
 CL.AddDelphiFunction('Function CreateIoForm( AForm : TCustomForm; ClassType : TFormClass) : TCustomForm');
 CL.AddDelphiFunction('Function GetComponentTree( Component : TComponent; pComponents : TComponentArray; bAddSelf : Boolean) : LongInt');
 CL.AddDelphiFunction('Function pPosEx( SearchStr : PChar; Str : PChar; var Pos : LongInt) : PChar');
 CL.AddDelphiFunction('Function pGetTextBetween( pBuff : PChar; bSearchCode : string; eSearchCode : string; Container : TStrings) : LongInt');
 CL.AddDelphiFunction('Function pComponentToString( Component : TComponent) : string');
 //CL.AddDelphiFunction('Function StringToComponent( Value : string; ComponentClass : TComponentClass) : TComponent');
 CL.AddDelphiFunction('Function StringToObjectBinaryStream( Value : string; BinStream : TMemoryStream; ResName : string) : Boolean');
 CL.AddDelphiFunction('Function ObjectBinaryStreamToString( BinStream : TMemoryStream; var sResult : string; bResource : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ObjectTextToBinaryStream( StrStream, BinStream : TComponentStream; ObjCount : LongInt) : LongInt');
 CL.AddDelphiFunction('Function ObjectBinaryStreamToObjectTextStream( BinStream : TMemoryStream; StrStream : TMemoryStream; bResource : Boolean) : Boolean');
 CL.AddDelphiFunction('Function GetResHeaderInfo( Stream : TMemoryStream; sl : TStrings) : Boolean');
 CL.AddDelphiFunction('Function pGetResourceName( Component : TComponent; NamingMethod : TResourceNaming) : string');
 CL.AddDelphiFunction('Function GetFormResourceStream( Form : TCustomForm; ResName : string; var ResourceStream : TMemoryStream) : Boolean');
 CL.AddDelphiFunction('Function WriteComponentsToFile( FormsAndComponents : array of TComponent; FileName : string; Format : TComponentFileFormat; StoreComponentNames : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ReadComponentsFromFile( FormsAndComponents : array of TComponent; FileName : string) : Boolean;');
 //CL.AddDelphiFunction('Function ReadComponentsFromFile1( FileName : string; pComponents : array of TPComponent; ComponentClasses : array of TComponentClass) : Boolean;');
 CL.AddDelphiFunction('Function ReadComponentTreeFromFile( FormOrComponent : TComponent; FileName : string) : Boolean');
 //CL.AddDelphiFunction('Function ReadObjectsFromFile( pObjects : array of TComponent; FormClasses : array of TFormClass; ComponentClasses : array of TComponentClass; FileName : string) : Boolean');
 CL.AddDelphiFunction('Function WriteComponentToFile( Component : TComponent; FileName : string; Format : TComponentFileFormat; StoreComponentName : Boolean) : Boolean');
 CL.AddDelphiFunction('Function WriteComponentTreeToFile( FormOrComponent : TComponent; FileName : string; Format : TComponentFileFormat; StoreComponentName : Boolean) : Boolean');
 //CL.AddDelphiFunction('Function ReadComponentFromFile2( pComponent : TComponent; ComponentClass : TComponentClass; FileName : string) : Boolean;');
 //CL.AddDelphiFunction('Function ReadComponentFromFile3( pForm : TComponent; FormClass : TFormClass; FileName : string) : Boolean;');
 CL.AddDelphiFunction('Function ReadComponentFromFile4( FormOrComponent : TComponent; FileName : string) : Boolean;');
 CL.AddDelphiFunction('Function ReadFormFromFile( pInstance : TComponent; FormClass : TFormClass; FileName : string) : Boolean');
 CL.AddDelphiFunction('Function ReadComponentResourceFile5( Instance : TObject; FileName : string) : Boolean;');
 CL.AddDelphiFunction('Function WriteComponentResourceFile( Instance : TObject; FileName : string; StoreFormAsVisible : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function ReadComponentsResourceFile( Components : array of TComponent; FileName : string; NamingMethod : TResourceNaming; bLoadTotalForm : Boolean) : Boolean');
 CL.AddDelphiFunction('Function WriteComponentsResourceFile( Components : array of TComponent; FileName : string; NamingMethod : TResourceNaming) : Boolean');
 CL.AddDelphiFunction('Function ReadComponentResourceHeader( sHeaderInfo : TStrings; pSize : Integer; FileName : string; NamingMethod : TResourceNaming) : Boolean');
 CL.AddDelphiFunction('Function ConvertComponentResourceToTextFile( SourceFileName : string; TargetFileName : string; bStoreResNames : Boolean) : Boolean');
 CL.AddDelphiFunction('Function CheckComponentInResourceFile( Component : TComponent; FileName : string; NamingMethod : TResourceNaming) : Boolean');
 CL.AddDelphiFunction('Function DeleteComponentFromResourceFile( ResourceName : string; FileName : string) : Boolean;');
 CL.AddDelphiFunction('Function DeleteComponentFromResourceFile8( Component : TComponent; FileName : string; NamingMethod : TResourceNaming) : Boolean;');
 //CL.AddDelphiFunction('Function CreateFormFromResFile( AOwner : TComponent; NewClassType : TFormClass; FileName : string) : Pointer');
 //CL.AddDelphiFunction('Function CreateComponentFromResFile( AOwner : TComponent; NewClassType : TComponentClass; FileName : string) : Pointer');
  CL.AddDelphiFunction('function getallEvents(aform: TForm): TStringlist;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function DeleteComponentFromResourceFile8_P( Component : TComponent; FileName : string; NamingMethod : TResourceNaming) : Boolean;
Begin Result := CompFileIo.DeleteComponentFromResourceFile(Component, FileName, NamingMethod); END;

(*----------------------------------------------------------------------------*)
Function DeleteComponentFromResourceFile_P( ResourceName : string; FileName : string) : Boolean;
Begin Result := CompFileIo.DeleteComponentFromResourceFile(ResourceName, FileName); END;

(*----------------------------------------------------------------------------*)
Function WriteComponentResourceFile_P( Instance : TObject; FileName : string; StoreFormAsVisible : Boolean) : Boolean;
Begin Result := CompFileIo.WriteComponentResourceFile(Instance, FileName, StoreFormAsVisible); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentResourceFile5_P( Instance : TObject; FileName : string) : Boolean;
Begin Result := CompFileIo.ReadComponentResourceFile(Instance, FileName); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentFromFile4_P( FormOrComponent : TComponent; FileName : string) : Boolean;
Begin Result := CompFileIo.ReadComponentFromFile(FormOrComponent, FileName); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentFromFile3_P( pForm : TPComponent; FormClass : TFormClass; FileName : string) : Boolean;
Begin Result := CompFileIo.ReadComponentFromFile(pForm, FormClass, FileName); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentFromFile2_P( pComponent : TPComponent; ComponentClass : TComponentClass; FileName : string) : Boolean;
Begin Result := CompFileIo.ReadComponentFromFile(pComponent, ComponentClass, FileName); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentsFromFile1_P( FileName : string; pComponents : array of TPComponent; ComponentClasses : array of TComponentClass) : Boolean;
Begin Result := CompFileIo.ReadComponentsFromFile(FileName, pComponents, ComponentClasses); END;

(*----------------------------------------------------------------------------*)
Function ReadComponentsFromFile_P( FormsAndComponents : array of TComponent; FileName : string) : Boolean;
Begin Result := CompFileIo.ReadComponentsFromFile(FormsAndComponents, FileName); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CompFileIo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VOID_COMP, 'VOID_COMP', cdRegister);
 S.RegisterDelphiFunction(@VOID_FORM, 'VOID_FORM', cdRegister);
 S.RegisterDelphiFunction(@CreateIoForm, 'CreateIoForm', cdRegister);
 S.RegisterDelphiFunction(@GetComponentTree, 'GetComponentTree', cdRegister);
 S.RegisterDelphiFunction(@pPosEx, 'pPosEx', cdRegister);
 S.RegisterDelphiFunction(@pGetTextBetween, 'pGetTextBetween', cdRegister);
 S.RegisterDelphiFunction(@ComponentToString, 'pComponentToString', cdRegister);
 S.RegisterDelphiFunction(@StringToComponent, 'StringToComponent', cdRegister);
 S.RegisterDelphiFunction(@StringToObjectBinaryStream, 'StringToObjectBinaryStream', cdRegister);
 S.RegisterDelphiFunction(@ObjectBinaryStreamToString, 'ObjectBinaryStreamToString', cdRegister);
 S.RegisterDelphiFunction(@ObjectTextToBinaryStream, 'ObjectTextToBinaryStream', cdRegister);
 S.RegisterDelphiFunction(@ObjectBinaryStreamToObjectTextStream, 'ObjectBinaryStreamToObjectTextStream', cdRegister);
 S.RegisterDelphiFunction(@GetResHeaderInfo, 'GetResHeaderInfo', cdRegister);
 S.RegisterDelphiFunction(@GetResourceName, 'pGetResourceName', cdRegister);
 S.RegisterDelphiFunction(@GetFormResourceStream, 'GetFormResourceStream', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentsToFile, 'WriteComponentsToFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentsFromFile, 'ReadComponentsFromFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentsFromFile1_P, 'ReadComponentsFromFile1', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentTreeFromFile, 'ReadComponentTreeFromFile', cdRegister);
 S.RegisterDelphiFunction(@ReadObjectsFromFile, 'ReadObjectsFromFile', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentToFile, 'WriteComponentToFile', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentTreeToFile, 'WriteComponentTreeToFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentFromFile2_P, 'ReadComponentFromFile2', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentFromFile3_P, 'ReadComponentFromFile3', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentFromFile4_P, 'ReadComponentFromFile4', cdRegister);
 S.RegisterDelphiFunction(@ReadFormFromFile, 'ReadFormFromFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentResourceFile5_P, 'ReadComponentResourceFile5', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentResourceFile, 'WriteComponentResourceFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentsResourceFile, 'ReadComponentsResourceFile', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentsResourceFile, 'WriteComponentsResourceFile', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentResourceHeader, 'ReadComponentResourceHeader', cdRegister);
 S.RegisterDelphiFunction(@ConvertComponentResourceToTextFile, 'ConvertComponentResourceToTextFile', cdRegister);
 S.RegisterDelphiFunction(@CheckComponentInResourceFile, 'CheckComponentInResourceFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteComponentFromResourceFile, 'DeleteComponentFromResourceFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteComponentFromResourceFile8_P, 'DeleteComponentFromResourceFile8', cdRegister);
 S.RegisterDelphiFunction(@CreateFormFromResFile, 'CreateFormFromResFile', cdRegister);
 S.RegisterDelphiFunction(@CreateComponentFromResFile, 'CreateComponentFromResFile', cdRegister);
  S.RegisterDelphiFunction(@getallEvents, 'getallEvents', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComponentStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComponentStream) do
  begin
    RegisterMethod(@TComponentStream.SaveToFile, 'SaveToFile');
    RegisterMethod(@TComponentStream.LoadFromFile, 'LoadFromFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CompFileIo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TComponentStream(CL);
end;

 
 
{ TPSImport_CompFileIo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CompFileIo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CompFileIo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CompFileIo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CompFileIo(ri);
  RIRegister_CompFileIo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
