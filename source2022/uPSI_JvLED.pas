unit uPSI_JvLED;
{

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
  TPSImport_JvLED = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvLED(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomLED(CL: TPSPascalCompiler);
procedure SIRegister_JvLED(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvLED(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomLED(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvLED(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,Forms
  ,Graphics
  ,ExtCtrls
  ,JvComponent
  ,JvLED
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvLED]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLED(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomLED', 'TJvLED') do
  with CL.AddClassN(CL.FindClass('TJvCustomLED'),'TJvLED') do begin
      RegisterPublishedProperties;
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomLED(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvCustomLED') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvCustomLED') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
    RegisterPublishedProperties;
    //CL
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvLED(CL: TPSPascalCompiler);
begin
  SIRegister_TJvCustomLED(CL);
  SIRegister_TJvLED(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLED(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLED) do begin
      //RegisterPublishedProperties;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomLED(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomLED) do begin
    //RegisterPublishedProperties;
    RegisterConstructor(@TJvCustomLED.Create, 'Create');
  RegisterMethod(@TJvCustomLED.Destroy, 'Free');
    RegisterMethod(@TJvCustomLED.SetBounds,'SetBounds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvLED(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCustomLED(CL);
  RIRegister_TJvLED(CL);
end;

 
 
{ TPSImport_JvLED }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvLED.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvLED(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvLED.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvLED(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
