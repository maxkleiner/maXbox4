unit uPSI_JvgWinMask;
{
   the mask
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
  TPSImport_JvgWinMask = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgWinMask(CL: TPSPascalCompiler);
procedure SIRegister_JvgWinMask(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgWinMask(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgWinMask(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,Graphics
  ,Controls
  {,Forms
  ,Dialogs
  ,ComCtrls
  ,ExtCtrls
  ,CommCtrl
  ,ImgList }
  ,JvComponent
  ,JvgTypes
  //,JvgCommClasses
  ,JvgWinMask
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgWinMask]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgWinMask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomPanel', 'TJvgWinMask') do
  with CL.AddClassN(CL.FindClass('TJvCustomPanel'),'TJvgWinMask') do begin
    RegisterProperty('Control', 'TWinControl', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Mask', 'TBitmap', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgWinMask(CL: TPSPascalCompiler);
begin
  SIRegister_TJvgWinMask(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgWinMaskMask_W(Self: TJvgWinMask; const T: TBitmap);
begin Self.Mask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgWinMaskMask_R(Self: TJvgWinMask; var T: TBitmap);
begin T := Self.Mask; end;

(*----------------------------------------------------------------------------*)
procedure TJvgWinMaskControl_W(Self: TJvgWinMask; const T: TWinControl);
Begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgWinMaskControl_R(Self: TJvgWinMask; var T: TWinControl);
Begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgWinMask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgWinMask) do begin
    RegisterPropertyHelper(@TJvgWinMaskControl_R,@TJvgWinMaskControl_W,'Control');
    RegisterConstructor(@TJvgWinMask.Create, 'Create');
    RegisterMethod(@TJvgWinMask.Destroy, 'Free');
    RegisterPropertyHelper(@TJvgWinMaskMask_R,@TJvgWinMaskMask_W,'Mask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgWinMask(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvgWinMask(CL);
end;

 
 
{ TPSImport_JvgWinMask }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgWinMask.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgWinMask(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgWinMask.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgWinMask(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
