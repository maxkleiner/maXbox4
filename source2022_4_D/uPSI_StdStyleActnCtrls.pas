unit uPSI_StdStyleActnCtrls;
{
   VCL
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
  TPSImport_StdStyleActnCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStandardStyleActionBars(CL: TPSPascalCompiler);
procedure SIRegister_StdStyleActnCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStandardStyleActionBars(CL: TPSRuntimeClassImporter);
procedure RIRegister_StdStyleActnCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActnMan
  ,ActnMenus
  ,ActnCtrls
  ,StdStyleActnCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StdStyleActnCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStandardStyleActionBars(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionBarStyleEx', 'TStandardStyleActionBars') do
  with CL.AddClassN(CL.FindClass('TActionBarStyleEx'),'TStandardStyleActionBars') do begin
    RegisterMethod('Function GetColorMapClass( ActionBar : TCustomActionBar) : TCustomColorMapClass');
    RegisterMethod('Function GetControlClass( ActionBar : TCustomActionBar; AnItem : TActionClientItem) : TCustomActionControlClass');
    RegisterMethod('Function GetPopupClass( ActionBar : TCustomActionBar) : TCustomPopupClass');
    RegisterMethod('Function GetAddRemoveItemClass( ActionBar : TCustomActionBar) : TCustomAddRemoveItemClass');
    RegisterMethod('Function GetStyleName : string');
    RegisterMethod('Function GetScrollBtnClass : TCustomToolScrollBtnClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StdStyleActnCtrls(CL: TPSPascalCompiler);
begin
  SIRegister_TStandardStyleActionBars(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TStandardStyleActionBars(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStandardStyleActionBars) do
  begin
    RegisterMethod(@TStandardStyleActionBars.GetColorMapClass, 'GetColorMapClass');
    RegisterMethod(@TStandardStyleActionBars.GetControlClass, 'GetControlClass');
    RegisterMethod(@TStandardStyleActionBars.GetPopupClass, 'GetPopupClass');
    RegisterMethod(@TStandardStyleActionBars.GetAddRemoveItemClass, 'GetAddRemoveItemClass');
    RegisterMethod(@TStandardStyleActionBars.GetStyleName, 'GetStyleName');
    RegisterMethod(@TStandardStyleActionBars.GetScrollBtnClass, 'GetScrollBtnClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StdStyleActnCtrls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStandardStyleActionBars(CL);
end;

 
 
{ TPSImport_StdStyleActnCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdStyleActnCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StdStyleActnCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdStyleActnCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StdStyleActnCtrls(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
