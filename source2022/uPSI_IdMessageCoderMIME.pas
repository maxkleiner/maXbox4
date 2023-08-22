unit uPSI_IdMessageCoderMIME;
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
  TPSImport_IdMessageCoderMIME = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMessageEncoderInfoMIME(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageEncoderMIME(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageDecoderInfoMIME(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageDecoderMIME(CL: TPSPascalCompiler);
procedure SIRegister_IdMessageCoderMIME(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMessageEncoderInfoMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageEncoderMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageDecoderInfoMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageDecoderMIME(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMessageCoderMIME(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdMessageCoder
  ,IdMessage
  ,IdMessageCoderMIME
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMessageCoderMIME]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageEncoderInfoMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMessageEncoderInfo', 'TIdMessageEncoderInfoMIME') do
  with CL.AddClassN(CL.FindClass('TIdMessageEncoderInfo'),'TIdMessageEncoderInfoMIME') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitializeHeaders( AMsg : TIdMessage)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageEncoderMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMessageEncoder', 'TIdMessageEncoderMIME') do
  with CL.AddClassN(CL.FindClass('TIdMessageEncoder'),'TIdMessageEncoderMIME') do begin
    RegisterMethod('Procedure Encode( ASrc : TStream; ADest : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageDecoderInfoMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMessageDecoderInfo', 'TIdMessageDecoderInfoMIME') do
  with CL.AddClassN(CL.FindClass('TIdMessageDecoderInfo'),'TIdMessageDecoderInfoMIME') do
  begin
    RegisterMethod('Function CheckForStart( ASender : TIdMessage; ALine : string) : TIdMessageDecoder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageDecoderMIME(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMessageDecoder', 'TIdMessageDecoderMIME') do
  with CL.AddClassN(CL.FindClass('TIdMessageDecoder'),'TIdMessageDecoderMIME') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent);');
    RegisterMethod('Constructor Create1( AOwner : TComponent; ALine : string);');
    RegisterMethod('Function ReadBody( ADestStream : TStream; var VMsgEnd : Boolean) : TIdMessageDecoder');
    RegisterMethod('Procedure ReadHeader');
    RegisterProperty('MIMEBoundary', 'string', iptrw);
    RegisterProperty('BodyEncoded', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMessageCoderMIME(CL: TPSPascalCompiler);
begin
  SIRegister_TIdMessageDecoderMIME(CL);
  SIRegister_TIdMessageDecoderInfoMIME(CL);
  SIRegister_TIdMessageEncoderMIME(CL);
  SIRegister_TIdMessageEncoderInfoMIME(CL);
 CL.AddConstantN('IndyMIMEBoundary','String').SetString( '=_MoreStuf_2zzz1234sadvnqw3nerasdf');
 CL.AddConstantN('IndyMultiPartAlternativeBoundary','String').SetString( '=_MoreStuf_2altzzz1234sadvnqw3nerasdf');
 CL.AddConstantN('IndyMultiPartRelatedBoundary','String').SetString( '=_MoreStuf_2relzzzsadvnq1234w3nerasdf');
 CL.AddConstantN('MIMEGenericText','String').SetString( 'text/');
 CL.AddConstantN('MIME7Bit','String').SetString( '7bit');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderMIMEBodyEncoded_W(Self: TIdMessageDecoderMIME; const T: Boolean);
begin Self.BodyEncoded := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderMIMEBodyEncoded_R(Self: TIdMessageDecoderMIME; var T: Boolean);
begin T := Self.BodyEncoded; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderMIMEMIMEBoundary_W(Self: TIdMessageDecoderMIME; const T: string);
begin Self.MIMEBoundary := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderMIMEMIMEBoundary_R(Self: TIdMessageDecoderMIME; var T: string);
begin T := Self.MIMEBoundary; end;

(*----------------------------------------------------------------------------*)
Function TIdMessageDecoderMIMECreate1_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent; ALine : string):TObject;
Begin Result := TIdMessageDecoderMIME.Create(AOwner, ALine); END;

(*----------------------------------------------------------------------------*)
Function TIdMessageDecoderMIMECreate_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TIdMessageDecoderMIME.Create(AOwner); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageEncoderInfoMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageEncoderInfoMIME) do
  begin
    RegisterConstructor(@TIdMessageEncoderInfoMIME.Create, 'Create');
    RegisterMethod(@TIdMessageEncoderInfoMIME.InitializeHeaders, 'InitializeHeaders');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageEncoderMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageEncoderMIME) do
  begin
    RegisterMethod(@TIdMessageEncoderMIME.Encode, 'Encode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageDecoderInfoMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageDecoderInfoMIME) do
  begin
    RegisterMethod(@TIdMessageDecoderInfoMIME.CheckForStart, 'CheckForStart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageDecoderMIME(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageDecoderMIME) do
  begin
    RegisterConstructor(@TIdMessageDecoderMIMECreate_P, 'Create');
    RegisterConstructor(@TIdMessageDecoderMIMECreate1_P, 'Create1');
    RegisterMethod(@TIdMessageDecoderMIME.ReadBody, 'ReadBody');
    RegisterMethod(@TIdMessageDecoderMIME.ReadHeader, 'ReadHeader');
    RegisterPropertyHelper(@TIdMessageDecoderMIMEMIMEBoundary_R,@TIdMessageDecoderMIMEMIMEBoundary_W,'MIMEBoundary');
    RegisterPropertyHelper(@TIdMessageDecoderMIMEBodyEncoded_R,@TIdMessageDecoderMIMEBodyEncoded_W,'BodyEncoded');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMessageCoderMIME(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdMessageDecoderMIME(CL);
  RIRegister_TIdMessageDecoderInfoMIME(CL);
  RIRegister_TIdMessageEncoderMIME(CL);
  RIRegister_TIdMessageEncoderInfoMIME(CL);
end;

 
 
{ TPSImport_IdMessageCoderMIME }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCoderMIME.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMessageCoderMIME(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCoderMIME.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMessageCoderMIME(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
