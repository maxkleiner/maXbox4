unit uPSI_xrtl_util_COMCat;
{
  more COM on win
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
  TPSImport_xrtl_util_COMCat = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_COMCat(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_COMCat_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,COMObj
  ,xrtl_util_COMCat
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_COMCat]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_COMCat(CL: TPSPascalCompiler);
begin

 // TLCID = DWORD;

 CL.AddTypeS('TLCID', 'DWORD');

 CL.AddDelphiFunction('Function XRTLDefaultCategoryManager : IUnknown');
 CL.AddDelphiFunction('Function XRTLIsCategoryEmpty( CatID : TGUID; const CategoryManager : IUnknown) : Boolean');
 CL.AddDelphiFunction('Function XRTLCreateComponentCategory( CatID : TGUID; CatDescription : WideString; LocaleID : TLCID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLRemoveComponentCategory( CatID : TGUID; CatDescription : WideString; LocaleID : TLCID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLRegisterCLSIDInCategory( ClassID : TGUID; CatID : TGUID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLUnRegisterCLSIDInCategory( ClassID : TGUID; CatID : TGUID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLGetCategoryDescription( CatID : TGUID; var CatDescription : WideString; LocaleID : TLCID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLGetCategoryList( Strings : TStrings; LocaleID : TLCID; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLGetCategoryCLSIDList( CatID : TGUID; Strings : TStrings; const CategoryManager : IUnknown) : HResult');
 CL.AddDelphiFunction('Function XRTLGetCategoryProgIDList( CatID : TGUID; Strings : TStrings; const CategoryManager : IUnknown) : HResult');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_COMCat_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLDefaultCategoryManager, 'XRTLDefaultCategoryManager', cdRegister);
 S.RegisterDelphiFunction(@XRTLIsCategoryEmpty, 'XRTLIsCategoryEmpty', cdRegister);
 S.RegisterDelphiFunction(@XRTLCreateComponentCategory, 'XRTLCreateComponentCategory', cdRegister);
 S.RegisterDelphiFunction(@XRTLRemoveComponentCategory, 'XRTLRemoveComponentCategory', cdRegister);
 S.RegisterDelphiFunction(@XRTLRegisterCLSIDInCategory, 'XRTLRegisterCLSIDInCategory', cdRegister);
 S.RegisterDelphiFunction(@XRTLUnRegisterCLSIDInCategory, 'XRTLUnRegisterCLSIDInCategory', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetCategoryDescription, 'XRTLGetCategoryDescription', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetCategoryList, 'XRTLGetCategoryList', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetCategoryCLSIDList, 'XRTLGetCategoryCLSIDList', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetCategoryProgIDList, 'XRTLGetCategoryProgIDList', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_COMCat }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_COMCat.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_COMCat(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_COMCat.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_COMCat(ri);
  RIRegister_xrtl_util_COMCat_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
