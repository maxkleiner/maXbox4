unit uPSI_AxCtrls;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_AxCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TReflectorWindow(CL: TPSPascalCompiler);
procedure SIRegister_TStringsAdapter(CL: TPSPascalCompiler);
procedure SIRegister_TOleGraphic(CL: TPSPascalCompiler);
procedure SIRegister_TPictureAdapter(CL: TPSPascalCompiler);
procedure SIRegister_IPictureAccess(CL: TPSPascalCompiler);
procedure SIRegister_TFontAdapter(CL: TPSPascalCompiler);
procedure SIRegister_IFontAccess(CL: TPSPascalCompiler);
procedure SIRegister_TAdapterNotifier(CL: TPSPascalCompiler);
procedure SIRegister_TCustomAdapter(CL: TPSPascalCompiler);
procedure SIRegister_TActiveXPropertyPageFactory(CL: TPSPascalCompiler);
procedure SIRegister_TActiveXPropertyPage(CL: TPSPascalCompiler);
procedure SIRegister_TPropertyPageImpl(CL: TPSPascalCompiler);
procedure SIRegister_TPropertyPage(CL: TPSPascalCompiler);
procedure SIRegister_TActiveFormFactory(CL: TPSPascalCompiler);
procedure SIRegister_TActiveForm(CL: TPSPascalCompiler);
procedure SIRegister_TActiveFormControl(CL: TPSPascalCompiler);
procedure SIRegister_TActiveXControlFactory(CL: TPSPascalCompiler);
procedure SIRegister_TActiveXControl(CL: TPSPascalCompiler);
procedure SIRegister_TConnectionPoints(CL: TPSPascalCompiler);
procedure SIRegister_TConnectionPoint(CL: TPSPascalCompiler);
procedure SIRegister_TOleStream(CL: TPSPascalCompiler);
procedure SIRegister_AxCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AxCtrls_Routines(S: TPSExec);
procedure RIRegister_TReflectorWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringsAdapter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOleGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPictureAdapter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFontAdapter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAdapterNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomAdapter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveXPropertyPageFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveXPropertyPage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPropertyPageImpl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPropertyPage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveFormFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveFormControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveXControlFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActiveXControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnectionPoints(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnectionPoint(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOleStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_AxCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,Messages
  ,ActiveX
  ,WinUtils
  ,ComObj
  ,Graphics
  ,Controls
  ,Forms
  ,ExtCtrls
  ,StdVCL
  ,AxCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AxCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TReflectorWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TReflectorWindow') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TReflectorWindow') do
  begin
    RegisterMethod('Constructor Create( ParentWindow : HWND; Control : TControl)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringsAdapter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAutoIntfObject', 'TStringsAdapter') do
  with CL.AddClassN(CL.FindClass('TAutoIntfObject'),'TStringsAdapter') do
  begin
    RegisterMethod('Constructor Create( Strings : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOleGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TOleGraphic') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TOleGraphic') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
    RegisterProperty('MMHeight', 'Integer', iptr);
    RegisterProperty('MMWidth', 'Integer', iptr);
    RegisterProperty('Picture', 'IPicture', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPictureAdapter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAdapter', 'TPictureAdapter') do
  with CL.AddClassN(CL.FindClass('TCustomAdapter'),'TPictureAdapter') do
  begin
    RegisterMethod('Constructor Create( Picture : TPicture)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IPictureAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IPictureAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IPictureAccess, 'IPictureAccess') do
  begin
    RegisterMethod('Procedure GetOlePicture( var OlePicture : IPictureDisp)', cdRegister);
    RegisterMethod('Procedure SetOlePicture( const OlePicture : IPictureDisp)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFontAdapter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAdapter', 'TFontAdapter') do
  with CL.AddClassN(CL.FindClass('TCustomAdapter'),'TFontAdapter') do
  begin
    RegisterMethod('Constructor Create( Font : TFont)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IFontAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IFontAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IFontAccess, 'IFontAccess') do
  begin
    RegisterMethod('Procedure GetOleFont( var OleFont : IFontDisp)', cdRegister);
    RegisterMethod('Procedure SetOleFont( const OleFont : IFontDisp)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAdapterNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAdapterNotifier') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAdapterNotifier') do
  begin
    RegisterMethod('Constructor Create( Adapter : TCustomAdapter)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomAdapter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TCustomAdapter') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TCustomAdapter') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveXPropertyPageFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComObjectFactory', 'TActiveXPropertyPageFactory') do
  with CL.AddClassN(CL.FindClass('TComObjectFactory'),'TActiveXPropertyPageFactory') do
  begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; PropertyPageClass : TPropertyPageClass; const ClassID : TGUID)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveXPropertyPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComObject', 'TActiveXPropertyPage') do
  with CL.AddClassN(CL.FindClass('TComObject'),'TActiveXPropertyPage') do
  begin
    RegisterProperty('PropertyPageImpl', 'TPropertyPageImpl', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPropertyPageImpl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAggregatedObject', 'TPropertyPageImpl') do
  with CL.AddClassN(CL.FindClass('TAggregatedObject'),'TPropertyPageImpl') do
  begin
    RegisterMethod('Procedure InitPropertyPage');
    RegisterProperty('PropertyPage', 'TPropertyPage', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPropertyPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomForm', 'TPropertyPage') do
  with CL.AddClassN(CL.FindClass('TCustomForm'),'TPropertyPage') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Modified');
    RegisterMethod('Procedure UpdateObject');
    RegisterMethod('Procedure UpdatePropertyPage');
    RegisterProperty('OleObject', 'OleVariant', iptr);
    RegisterProperty('OleObjects', 'TInterfaceList', iptrw);
    RegisterMethod('Procedure EnumCtlProps( PropType : TGUID; PropNames : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveFormFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActiveXControlFactory', 'TActiveFormFactory') do
  with CL.AddClassN(CL.FindClass('TActiveXControlFactory'),'TActiveFormFactory') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomActiveForm', 'TActiveForm') do
  with CL.AddClassN(CL.FindClass('TCustomActiveForm'),'TActiveForm') do
  begin
    RegisterProperty('ActiveFormControl', 'TActiveFormControl', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveFormControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActiveXControl', 'TActiveFormControl') do
  with CL.AddClassN(CL.FindClass('TActiveXControl'),'TActiveFormControl') do
  begin
    RegisterMethod('Procedure FreeOnRelease');
    RegisterMethod('Function ObjQueryInterface( const IID : TGUID; out Obj) : HResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveXControlFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAutoObjectFactory', 'TActiveXControlFactory') do
  with CL.AddClassN(CL.FindClass('TAutoObjectFactory'),'TActiveXControlFactory') do
  begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; ActiveXControlClass : TActiveXControlClass; WinControlClass : TWinControlClass; const ClassID : TGUID; ToolboxBitmapID : Integer; const LicStr : string; MiscStatus : Integer; ThreadingModel : TThreadingModel)');
    RegisterMethod('Procedure AddVerb( Verb : Integer; const VerbName : string)');
    RegisterMethod('Procedure UpdateRegistry( Register : Boolean)');
    RegisterProperty('MiscStatus', 'Integer', iptr);
    RegisterProperty('ToolboxBitmapID', 'Integer', iptr);
    RegisterProperty('WinControlClass', 'TWinControlClass', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActiveXControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAutoObject', 'TActiveXControl') do
  with CL.AddClassN(CL.FindClass('TAutoObject'),'TActiveXControl') do
  begin
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Function ObjQueryInterface( const IID : TGUID; out Obj) : HResult');
    RegisterMethod('Procedure PropChanged( const PropertyName : WideString);');
    RegisterMethod('Procedure PropChanged1( DispID : TDispID);');
    RegisterMethod('Function PropRequestEdit( const PropertyName : WideString) : Boolean;');
    RegisterMethod('Function PropRequestEdit1( DispID : TDispID) : Boolean;');
    RegisterProperty('ClientSite', 'IOleClientSite', iptr);
    RegisterProperty('InPlaceSite', 'IOleInPlaceSite', iptr);
    RegisterProperty('Control', 'TWinControl', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectionPoints(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TConnectionPoints') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TConnectionPoints') do
  begin
    RegisterMethod('Constructor Create( const AController : IUnknown)');
    RegisterMethod('Function CreateConnectionPoint( const IID : TGUID; Kind : TConnectionKind; OnConnect : TConnectEvent) : TConnectionPoint');
    RegisterProperty('Controller', 'IUnknown', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectionPoint(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TContainedObject', 'TConnectionPoint') do
  with CL.AddClassN(CL.FindClass('TContainedObject'),'TConnectionPoint') do
  begin
    RegisterMethod('Constructor Create( Container : TConnectionPoints; const IID : TGUID; Kind : TConnectionKind; OnConnect : TConnectEvent)');
    RegisterProperty('SinkList', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOleStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TOleStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TOleStream') do
  begin
    RegisterMethod('Constructor Create( const Stream : IStream)');
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AxCtrls(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('Class_DColorPropPage','TGUID').SetString( '{5CFF5D59-5946-11D0-BDEF-00A024D1875C}');
 CL.AddConstantN('Class_DFontPropPage','TGUID').SetString( '{5CFF5D5B-5946-11D0-BDEF-00A024D1875C}');
 CL.AddConstantN('Class_DPicturePropPage','TGUID').SetString( '{5CFF5D5A-5946-11D0-BDEF-00A024D1875C}');
 CL.AddConstantN('Class_DStringPropPage','TGUID').SetString( '{F42D677E-754B-11D0-BDFB-00A024D1875C}');
  SIRegister_TOleStream(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TConnectionPoints');
  CL.AddTypeS('TConnectionKind', '( ckSingle, ckMulti )');
  SIRegister_TConnectionPoint(CL);
  SIRegister_TConnectionPoints(CL);
  CL.AddTypeS('TDefinePropertyPage', 'Procedure ( const GUID : TGUID)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActiveXControlFactory');
  SIRegister_TActiveXControl(CL);
  //CL.AddTypeS('TActiveXControlClass', 'class of TActiveXControl');
  SIRegister_TActiveXControlFactory(CL);
  SIRegister_TActiveFormControl(CL);
  SIRegister_TActiveForm(CL);
  //CL.AddTypeS('TActiveFormClass', 'class of TActiveForm');
  SIRegister_TActiveFormFactory(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPropertyPageImpl');
  SIRegister_TPropertyPage(CL);
  //CL.AddTypeS('TPropertyPageClass', 'class of TPropertyPage');
  SIRegister_TPropertyPageImpl(CL);
  SIRegister_TActiveXPropertyPage(CL);
  SIRegister_TActiveXPropertyPageFactory(CL);
  SIRegister_TCustomAdapter(CL);
  SIRegister_TAdapterNotifier(CL);
  SIRegister_IFontAccess(CL);
  SIRegister_TFontAdapter(CL);
  SIRegister_IPictureAccess(CL);
  SIRegister_TPictureAdapter(CL);
  SIRegister_TOleGraphic(CL);
  SIRegister_TStringsAdapter(CL);
  SIRegister_TReflectorWindow(CL);
 CL.AddDelphiFunction('Procedure EnumDispatchProperties( Dispatch : IDispatch; PropType : TGUID; VTCode : Integer; PropList : TStrings)');
 CL.AddDelphiFunction('Procedure GetOleFont( Font : TFont; var OleFont : IFontDisp)');
 CL.AddDelphiFunction('Procedure SetOleFont( Font : TFont; OleFont : IFontDisp)');
 CL.AddDelphiFunction('Procedure GetOlePicture( Picture : TPicture; var OlePicture : IPictureDisp)');
 CL.AddDelphiFunction('Procedure SetOlePicture( Picture : TPicture; OlePicture : IPictureDisp)');
 CL.AddDelphiFunction('Procedure GetOleStrings( Strings : TStrings; var OleStrings : IStrings)');
 CL.AddDelphiFunction('Procedure SetOleStrings( Strings : TStrings; OleStrings : IStrings)');
 CL.AddDelphiFunction('Function ParkingWindow : HWND');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOleGraphicPicture_W(Self: TOleGraphic; const T: IPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TOleGraphicPicture_R(Self: TOleGraphic; var T: IPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TOleGraphicMMWidth_R(Self: TOleGraphic; var T: Integer);
begin T := Self.MMWidth; end;

(*----------------------------------------------------------------------------*)
procedure TOleGraphicMMHeight_R(Self: TOleGraphic; var T: Integer);
begin T := Self.MMHeight; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXPropertyPagePropertyPageImpl_R(Self: TActiveXPropertyPage; var T: TPropertyPageImpl);
begin T := Self.PropertyPageImpl; end;

(*----------------------------------------------------------------------------*)
procedure TPropertyPageImplPropertyPage_W(Self: TPropertyPageImpl; const T: TPropertyPage);
begin Self.PropertyPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPropertyPageImplPropertyPage_R(Self: TPropertyPageImpl; var T: TPropertyPage);
begin T := Self.PropertyPage; end;

(*----------------------------------------------------------------------------*)
procedure TPropertyPageOleObjects_W(Self: TPropertyPage; const T: TInterfaceList);
begin Self.OleObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TPropertyPageOleObjects_R(Self: TPropertyPage; var T: TInterfaceList);
begin T := Self.OleObjects; end;

(*----------------------------------------------------------------------------*)
procedure TPropertyPageOleObject_R(Self: TPropertyPage; var T: OleVariant);
begin T := Self.OleObject; end;

(*----------------------------------------------------------------------------*)
procedure TActiveFormActiveFormControl_R(Self: TActiveForm; var T: TActiveFormControl);
begin T := Self.ActiveFormControl; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlFactoryWinControlClass_R(Self: TActiveXControlFactory; var T: TWinControlClass);
begin T := Self.WinControlClass; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlFactoryToolboxBitmapID_R(Self: TActiveXControlFactory; var T: Integer);
begin T := Self.ToolboxBitmapID; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlFactoryMiscStatus_R(Self: TActiveXControlFactory; var T: Integer);
begin T := Self.MiscStatus; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlControl_R(Self: TActiveXControl; var T: TWinControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlInPlaceSite_R(Self: TActiveXControl; var T: IOleInPlaceSite);
begin T := Self.InPlaceSite; end;

(*----------------------------------------------------------------------------*)
procedure TActiveXControlClientSite_R(Self: TActiveXControl; var T: IOleClientSite);
begin T := Self.ClientSite; end;

(*----------------------------------------------------------------------------*)
Function TActiveXControlPropRequestEdit1_P(Self: TActiveXControl;  DispID : TDispID) : Boolean;
Begin Result := Self.PropRequestEdit(DispID); END;

(*----------------------------------------------------------------------------*)
Function TActiveXControlPropRequestEdit_P(Self: TActiveXControl;  const PropertyName : WideString) : Boolean;
Begin Result := Self.PropRequestEdit(PropertyName); END;

(*----------------------------------------------------------------------------*)
Procedure TActiveXControlPropChanged1_P(Self: TActiveXControl;  DispID : TDispID);
Begin Self.PropChanged(DispID); END;

(*----------------------------------------------------------------------------*)
Procedure TActiveXControlPropChanged_P(Self: TActiveXControl;  const PropertyName : WideString);
Begin Self.PropChanged(PropertyName); END;

(*----------------------------------------------------------------------------*)
procedure TConnectionPointsController_R(Self: TConnectionPoints; var T: IUnknown);
begin T := Self.Controller; end;

(*----------------------------------------------------------------------------*)
procedure TConnectionPointSinkList_R(Self: TConnectionPoint; var T: TList);
begin T := Self.SinkList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AxCtrls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EnumDispatchProperties, 'EnumDispatchProperties', cdRegister);
 S.RegisterDelphiFunction(@GetOleFont, 'GetOleFont', cdRegister);
 S.RegisterDelphiFunction(@SetOleFont, 'SetOleFont', cdRegister);
 S.RegisterDelphiFunction(@GetOlePicture, 'GetOlePicture', cdRegister);
 S.RegisterDelphiFunction(@SetOlePicture, 'SetOlePicture', cdRegister);
 S.RegisterDelphiFunction(@GetOleStrings, 'GetOleStrings', cdRegister);
 S.RegisterDelphiFunction(@SetOleStrings, 'SetOleStrings', cdRegister);
 S.RegisterDelphiFunction(@ParkingWindow, 'ParkingWindow', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TReflectorWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TReflectorWindow) do
  begin
    RegisterConstructor(@TReflectorWindow.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringsAdapter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringsAdapter) do
  begin
    RegisterConstructor(@TStringsAdapter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOleGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOleGraphic) do
  begin
    RegisterMethod(@TOleGraphic.Assign, 'Assign');
    RegisterMethod(@TOleGraphic.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TOleGraphic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TOleGraphic.SaveToStream, 'SaveToStream');
    RegisterMethod(@TOleGraphic.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TOleGraphic.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterPropertyHelper(@TOleGraphicMMHeight_R,nil,'MMHeight');
    RegisterPropertyHelper(@TOleGraphicMMWidth_R,nil,'MMWidth');
    RegisterPropertyHelper(@TOleGraphicPicture_R,@TOleGraphicPicture_W,'Picture');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPictureAdapter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPictureAdapter) do
  begin
    RegisterConstructor(@TPictureAdapter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFontAdapter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFontAdapter) do
  begin
    RegisterConstructor(@TFontAdapter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAdapterNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAdapterNotifier) do
  begin
    RegisterConstructor(@TAdapterNotifier.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomAdapter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomAdapter) do
  begin
    RegisterConstructor(@TCustomAdapter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveXPropertyPageFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveXPropertyPageFactory) do
  begin
    RegisterConstructor(@TActiveXPropertyPageFactory.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveXPropertyPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveXPropertyPage) do
  begin
    RegisterPropertyHelper(@TActiveXPropertyPagePropertyPageImpl_R,nil,'PropertyPageImpl');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPropertyPageImpl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPropertyPageImpl) do
  begin
    RegisterVirtualMethod(@TPropertyPageImpl.InitPropertyPage, 'InitPropertyPage');
    RegisterPropertyHelper(@TPropertyPageImplPropertyPage_R,@TPropertyPageImplPropertyPage_W,'PropertyPage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPropertyPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPropertyPage) do
  begin
    RegisterConstructor(@TPropertyPage.Create, 'Create');
    RegisterMethod(@TPropertyPage.Modified, 'Modified');
    RegisterVirtualMethod(@TPropertyPage.UpdateObject, 'UpdateObject');
    RegisterVirtualMethod(@TPropertyPage.UpdatePropertyPage, 'UpdatePropertyPage');
    RegisterPropertyHelper(@TPropertyPageOleObject_R,nil,'OleObject');
    RegisterPropertyHelper(@TPropertyPageOleObjects_R,@TPropertyPageOleObjects_W,'OleObjects');
    RegisterMethod(@TPropertyPage.EnumCtlProps, 'EnumCtlProps');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveFormFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveFormFactory) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveForm) do
  begin
    RegisterPropertyHelper(@TActiveFormActiveFormControl_R,nil,'ActiveFormControl');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveFormControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveFormControl) do
  begin
    RegisterMethod(@TActiveFormControl.FreeOnRelease, 'FreeOnRelease');
    RegisterMethod(@TActiveFormControl.ObjQueryInterface, 'ObjQueryInterface');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveXControlFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveXControlFactory) do
  begin
    RegisterConstructor(@TActiveXControlFactory.Create, 'Create');
    RegisterMethod(@TActiveXControlFactory.AddVerb, 'AddVerb');
    RegisterMethod(@TActiveXControlFactory.UpdateRegistry, 'UpdateRegistry');
    RegisterPropertyHelper(@TActiveXControlFactoryMiscStatus_R,nil,'MiscStatus');
    RegisterPropertyHelper(@TActiveXControlFactoryToolboxBitmapID_R,nil,'ToolboxBitmapID');
    RegisterPropertyHelper(@TActiveXControlFactoryWinControlClass_R,nil,'WinControlClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActiveXControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActiveXControl) do
  begin
    RegisterMethod(@TActiveXControl.Initialize, 'Initialize');
    RegisterMethod(@TActiveXControl.ObjQueryInterface, 'ObjQueryInterface');
    RegisterMethod(@TActiveXControlPropChanged_P, 'PropChanged');
    RegisterMethod(@TActiveXControlPropChanged1_P, 'PropChanged1');
    RegisterMethod(@TActiveXControlPropRequestEdit_P, 'PropRequestEdit');
    RegisterMethod(@TActiveXControlPropRequestEdit1_P, 'PropRequestEdit1');
    RegisterPropertyHelper(@TActiveXControlClientSite_R,nil,'ClientSite');
    RegisterPropertyHelper(@TActiveXControlInPlaceSite_R,nil,'InPlaceSite');
    RegisterPropertyHelper(@TActiveXControlControl_R,nil,'Control');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectionPoints(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectionPoints) do
  begin
    RegisterConstructor(@TConnectionPoints.Create, 'Create');
    RegisterMethod(@TConnectionPoints.CreateConnectionPoint, 'CreateConnectionPoint');
    RegisterPropertyHelper(@TConnectionPointsController_R,nil,'Controller');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectionPoint(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectionPoint) do
  begin
    RegisterConstructor(@TConnectionPoint.Create, 'Create');
    RegisterPropertyHelper(@TConnectionPointSinkList_R,nil,'SinkList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOleStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOleStream) do
  begin
    RegisterConstructor(@TOleStream.Create, 'Create');
    RegisterMethod(@TOleStream.Read, 'Read');
    RegisterMethod(@TOleStream.Write, 'Write');
    RegisterMethod(@TOleStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AxCtrls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOleStream(CL);
  with CL.Add(TConnectionPoints) do
  RIRegister_TConnectionPoint(CL);
  RIRegister_TConnectionPoints(CL);
  with CL.Add(TActiveXControlFactory) do
  RIRegister_TActiveXControl(CL);
  RIRegister_TActiveXControlFactory(CL);
  RIRegister_TActiveFormControl(CL);
  RIRegister_TActiveForm(CL);
  RIRegister_TActiveFormFactory(CL);
  with CL.Add(TPropertyPageImpl) do
  RIRegister_TPropertyPage(CL);
  RIRegister_TPropertyPageImpl(CL);
  RIRegister_TActiveXPropertyPage(CL);
  RIRegister_TActiveXPropertyPageFactory(CL);
  RIRegister_TCustomAdapter(CL);
  RIRegister_TAdapterNotifier(CL);
  RIRegister_TFontAdapter(CL);
  RIRegister_TPictureAdapter(CL);
  RIRegister_TOleGraphic(CL);
  RIRegister_TStringsAdapter(CL);
  RIRegister_TReflectorWindow(CL);
end;

 
 
{ TPSImport_AxCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AxCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AxCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AxCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AxCtrls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
