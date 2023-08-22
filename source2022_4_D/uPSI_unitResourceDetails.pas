unit uPSI_unitResourceDetails;
{
   of XN Res editor
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
  TPSImport_unitResourceDetails = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TUnicodeResourceDetails(CL: TPSPascalCompiler);
procedure SIRegister_TAnsiResourceDetails(CL: TPSPascalCompiler);
procedure SIRegister_TResourceDetails(CL: TPSPascalCompiler);
procedure SIRegister_TResourceModule(CL: TPSPascalCompiler);
procedure SIRegister_unitResourceDetails(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_unitResourceDetails_Routines(S: TPSExec);
procedure RIRegister_TUnicodeResourceDetails(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnsiResourceDetails(CL: TPSRuntimeClassImporter);
procedure RIRegister_TResourceDetails(CL: TPSRuntimeClassImporter);
procedure RIRegister_TResourceModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_unitResourceDetails(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,unitResourceDetails
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_unitResourceDetails]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TUnicodeResourceDetails(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResourceDetails', 'TUnicodeResourceDetails') do
  with CL.AddClassN(CL.FindClass('TResourceDetails'),'TUnicodeResourceDetails') do
  begin
    RegisterProperty('Text', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnsiResourceDetails(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResourceDetails', 'TAnsiResourceDetails') do
  with CL.AddClassN(CL.FindClass('TResourceDetails'),'TAnsiResourceDetails') do
  begin
    RegisterProperty('Text', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TResourceDetails(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TResourceDetails') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TResourceDetails') do
  begin
    RegisterMethod('Function CreateResourceDetails( AParent : TResourceModule; ALanguage : Integer; const AName, AType : string; ASize : Integer; AData : pointer) : TResourceDetails');
    RegisterMethod('Function GetBaseType : string');
    RegisterMethod('Constructor CreateNew( AParent : TResourceModule; ALanguage : Integer; const AName : string)');
    RegisterMethod('Procedure BeforeDelete');
    RegisterMethod('Procedure ChangeData( newData : TMemoryStream)');
    RegisterProperty('Parent', 'TResourceModule', iptr);
    RegisterProperty('Data', 'TMemoryStream', iptr);
    RegisterProperty('ResourceName', 'string', iptrw);
    RegisterProperty('ResourceType', 'string', iptr);
    RegisterProperty('ResourceLanguage', 'LCID', iptrw);
    RegisterProperty('CodePage', 'Integer', iptrw);
    RegisterProperty('Characteristics', 'DWORD', iptrw);
    RegisterProperty('Version', 'DWORD', iptrw);
    RegisterProperty('DataVersion', 'DWORD', iptrw);
    RegisterProperty('MemoryFlags', 'WORD', iptrw);
    RegisterProperty('Dirty', 'Boolean', iptrw);
    RegisterProperty('Tag', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TResourceModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TResourceModule') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TResourceModule') do
  begin
    RegisterMethod('Procedure DeleteResource( idx : Integer)');
    RegisterMethod('Procedure InsertResource( idx : Integer; details : TResourceDetails)');
    RegisterMethod('Function AddResource( details : TResourceDetails) : Integer');
    RegisterMethod('Function IndexOfResource( details : TResourceDetails) : Integer');
    RegisterMethod('Function GetUniqueResourceName( const tp : string) : string');
    RegisterMethod('Procedure SaveToStream( stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SortResources');
    RegisterMethod('Function FindResource( const tp, Name : string; ALanguage : Integer) : TResourceDetails');
    RegisterProperty('ResourceCount', 'Integer', iptr);
    RegisterProperty('ResourceDetails', 'TResourceDetails Integer', iptr);
    RegisterProperty('Dirty', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_unitResourceDetails(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TResourceDetails');
  //CL.AddTypeS('TResourceDetailsClass', 'class of TResourceDetails');
  SIRegister_TResourceModule(CL);
  SIRegister_TResourceDetails(CL);
  SIRegister_TAnsiResourceDetails(CL);
  SIRegister_TUnicodeResourceDetails(CL);
 //CL.AddDelphiFunction('Procedure RegisterResourceDetails( resourceClass : TResourceDetailsClass)');
 //CL.AddDelphiFunction('Procedure UnRegisterResourceDetails( resourceClass : TResourceDetailsClass)');
 CL.AddDelphiFunction('Function ResourceWideCharToStr( var wstr : PChar; codePage : Integer) : string');
 CL.AddDelphiFunction('Procedure ResourceStrToWideChar( const s : string; var p : PChar; codePage : Integer)');
 CL.AddDelphiFunction('Function ResourceNameToInt( const s : string) : Integer');
 CL.AddDelphiFunction('Function CompareDetails( p1, p2 : TObject) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUnicodeResourceDetailsText_W(Self: TUnicodeResourceDetails; const T: WideString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TUnicodeResourceDetailsText_R(Self: TUnicodeResourceDetails; var T: WideString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiResourceDetailsText_W(Self: TAnsiResourceDetails; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiResourceDetailsText_R(Self: TAnsiResourceDetails; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsTag_W(Self: TResourceDetails; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsTag_R(Self: TResourceDetails; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsDirty_W(Self: TResourceDetails; const T: Boolean);
begin Self.Dirty := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsDirty_R(Self: TResourceDetails; var T: Boolean);
begin T := Self.Dirty; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsMemoryFlags_W(Self: TResourceDetails; const T: WORD);
begin Self.MemoryFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsMemoryFlags_R(Self: TResourceDetails; var T: WORD);
begin T := Self.MemoryFlags; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsDataVersion_W(Self: TResourceDetails; const T: DWORD);
begin Self.DataVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsDataVersion_R(Self: TResourceDetails; var T: DWORD);
begin T := Self.DataVersion; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsVersion_W(Self: TResourceDetails; const T: DWORD);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsVersion_R(Self: TResourceDetails; var T: DWORD);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsCharacteristics_W(Self: TResourceDetails; const T: DWORD);
begin Self.Characteristics := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsCharacteristics_R(Self: TResourceDetails; var T: DWORD);
begin T := Self.Characteristics; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsCodePage_W(Self: TResourceDetails; const T: Integer);
begin Self.CodePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsCodePage_R(Self: TResourceDetails; var T: Integer);
begin T := Self.CodePage; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsResourceLanguage_W(Self: TResourceDetails; const T: LCID);
begin Self.ResourceLanguage := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsResourceLanguage_R(Self: TResourceDetails; var T: LCID);
begin T := Self.ResourceLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsResourceType_R(Self: TResourceDetails; var T: string);
begin T := Self.ResourceType; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsResourceName_W(Self: TResourceDetails; const T: string);
begin Self.ResourceName := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsResourceName_R(Self: TResourceDetails; var T: string);
begin T := Self.ResourceName; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsData_R(Self: TResourceDetails; var T: TMemoryStream);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TResourceDetailsParent_R(Self: TResourceDetails; var T: TResourceModule);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TResourceModuleDirty_W(Self: TResourceModule; const T: Boolean);
begin Self.Dirty := T; end;

(*----------------------------------------------------------------------------*)
procedure TResourceModuleDirty_R(Self: TResourceModule; var T: Boolean);
begin T := Self.Dirty; end;

(*----------------------------------------------------------------------------*)
procedure TResourceModuleResourceDetails_R(Self: TResourceModule; var T: TResourceDetails; const t1: Integer);
begin T := Self.ResourceDetails[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TResourceModuleResourceCount_R(Self: TResourceModule; var T: Integer);
begin T := Self.ResourceCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_unitResourceDetails_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterResourceDetails, 'RegisterResourceDetails', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterResourceDetails, 'UnRegisterResourceDetails', cdRegister);
 S.RegisterDelphiFunction(@ResourceWideCharToStr, 'ResourceWideCharToStr', cdRegister);
 S.RegisterDelphiFunction(@ResourceStrToWideChar, 'ResourceStrToWideChar', cdRegister);
 S.RegisterDelphiFunction(@ResourceNameToInt, 'ResourceNameToInt', cdRegister);
 S.RegisterDelphiFunction(@CompareDetails, 'CompareDetails', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUnicodeResourceDetails(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUnicodeResourceDetails) do
  begin
    RegisterPropertyHelper(@TUnicodeResourceDetailsText_R,@TUnicodeResourceDetailsText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnsiResourceDetails(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnsiResourceDetails) do
  begin
    RegisterPropertyHelper(@TAnsiResourceDetailsText_R,@TAnsiResourceDetailsText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResourceDetails(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResourceDetails) do
  begin
    RegisterMethod(@TResourceDetails.CreateResourceDetails, 'CreateResourceDetails');
    RegisterVirtualMethod(@TResourceDetails.GetBaseType, 'GetBaseType');
    RegisterVirtualConstructor(@TResourceDetails.CreateNew, 'CreateNew');
    RegisterVirtualMethod(@TResourceDetails.BeforeDelete, 'BeforeDelete');
    RegisterVirtualMethod(@TResourceDetails.ChangeData, 'ChangeData');
    RegisterPropertyHelper(@TResourceDetailsParent_R,nil,'Parent');
    RegisterPropertyHelper(@TResourceDetailsData_R,nil,'Data');
    RegisterPropertyHelper(@TResourceDetailsResourceName_R,@TResourceDetailsResourceName_W,'ResourceName');
    RegisterPropertyHelper(@TResourceDetailsResourceType_R,nil,'ResourceType');
    RegisterPropertyHelper(@TResourceDetailsResourceLanguage_R,@TResourceDetailsResourceLanguage_W,'ResourceLanguage');
    RegisterPropertyHelper(@TResourceDetailsCodePage_R,@TResourceDetailsCodePage_W,'CodePage');
    RegisterPropertyHelper(@TResourceDetailsCharacteristics_R,@TResourceDetailsCharacteristics_W,'Characteristics');
    RegisterPropertyHelper(@TResourceDetailsVersion_R,@TResourceDetailsVersion_W,'Version');
    RegisterPropertyHelper(@TResourceDetailsDataVersion_R,@TResourceDetailsDataVersion_W,'DataVersion');
    RegisterPropertyHelper(@TResourceDetailsMemoryFlags_R,@TResourceDetailsMemoryFlags_W,'MemoryFlags');
    RegisterPropertyHelper(@TResourceDetailsDirty_R,@TResourceDetailsDirty_W,'Dirty');
    RegisterPropertyHelper(@TResourceDetailsTag_R,@TResourceDetailsTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResourceModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResourceModule) do
  begin
    RegisterVirtualMethod(@TResourceModule.DeleteResource, 'DeleteResource');
    RegisterVirtualMethod(@TResourceModule.InsertResource, 'InsertResource');
    RegisterVirtualMethod(@TResourceModule.AddResource, 'AddResource');
    //RegisterVirtualAbstractMethod(@TResourceModule, @!.IndexOfResource, 'IndexOfResource');
    RegisterMethod(@TResourceModule.GetUniqueResourceName, 'GetUniqueResourceName');
    RegisterVirtualMethod(@TResourceModule.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TResourceModule.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TResourceModule.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TResourceModule.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TResourceModule.SortResources, 'SortResources');
    RegisterMethod(@TResourceModule.FindResource, 'FindResource');
    RegisterPropertyHelper(@TResourceModuleResourceCount_R,nil,'ResourceCount');
    RegisterPropertyHelper(@TResourceModuleResourceDetails_R,nil,'ResourceDetails');
    RegisterPropertyHelper(@TResourceModuleDirty_R,@TResourceModuleDirty_W,'Dirty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_unitResourceDetails(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResourceDetails) do
  RIRegister_TResourceModule(CL);
  RIRegister_TResourceDetails(CL);
  RIRegister_TAnsiResourceDetails(CL);
  RIRegister_TUnicodeResourceDetails(CL);
end;

 
 
{ TPSImport_unitResourceDetails }
(*----------------------------------------------------------------------------*)
procedure TPSImport_unitResourceDetails.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_unitResourceDetails(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_unitResourceDetails.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_unitResourceDetails(ri);
  RIRegister_unitResourceDetails_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
