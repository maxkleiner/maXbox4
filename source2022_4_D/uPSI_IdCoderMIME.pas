unit uPSI_IdCoderMIME;
{
T code the mode with base64

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
  TPSImport_IdCoderMIME = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDecoderMIME(CL: TPSPascalCompiler);
procedure SIRegister_TIdEncoderMIME(CL: TPSPascalCompiler);
procedure SIRegister_IdCoderMIME(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDecoderMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdEncoderMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdCoderMIME(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdCoder3to4
  ,IdCoderMIME
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdCoderMIME]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDecoderMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdDecoder4to3', 'TIdDecoderMIME') do
  with CL.AddClassN(CL.FindClass('TIdDecoder4to3'),'TIdDecoderMIME') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdEncoderMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdEncoder3to4', 'TIdEncoderMIME') do
  with CL.AddClassN(CL.FindClass('TIdEncoder3to4'),'TIdEncoderMIME') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdCoderMIME(CL: TPSPascalCompiler);
begin
  SIRegister_TIdEncoderMIME(CL);
  SIRegister_TIdDecoderMIME(CL);
 CL.AddConstantN('GBase64CodeTable','string').SetString( 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDecoderMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDecoderMIME) do
  begin
    RegisterConstructor(@TIdDecoderMIME.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdEncoderMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdEncoderMIME) do
  begin
    RegisterConstructor(@TIdEncoderMIME.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCoderMIME(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdEncoderMIME(CL);
  RIRegister_TIdDecoderMIME(CL);
end;

 
 
{ TPSImport_IdCoderMIME }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoderMIME.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdCoderMIME(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoderMIME.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdCoderMIME(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
