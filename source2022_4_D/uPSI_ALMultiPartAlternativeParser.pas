unit uPSI_ALMultiPartAlternativeParser;
{
   from base parser
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
  TPSImport_ALMultiPartAlternativeParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALMultipartAlternativeDecoder(CL: TPSPascalCompiler);
procedure SIRegister_TALMultipartAlternativeEncoder(CL: TPSPascalCompiler);
procedure SIRegister_TAlMultiPartAlternativeStream(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartAlternativeContents(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartAlternativeContent(CL: TPSPascalCompiler);
procedure SIRegister_ALMultiPartAlternativeParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALMultipartAlternativeDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultipartAlternativeEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMultiPartAlternativeStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartAlternativeContents(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartAlternativeContent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALMultiPartAlternativeParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALMultiPartBaseParser
  ,ALMultiPartAlternativeParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALMultiPartAlternativeParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartAlternativeDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseDecoder', 'TALMultipartAlternativeDecoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseDecoder'),'TALMultipartAlternativeDecoder') do
  begin
    RegisterProperty('Contents', 'TALMultiPartAlternativeContents', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartAlternativeEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseEncoder', 'TALMultipartAlternativeEncoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseEncoder'),'TALMultipartAlternativeEncoder') do
  begin
    RegisterProperty('DataStream', 'TAlMultiPartAlternativeStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMultiPartAlternativeStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAlMultiPartBaseStream', 'TAlMultiPartAlternativeStream') do
  with CL.AddClassN(CL.FindClass('TAlMultiPartBaseStream'),'TAlMultiPartAlternativeStream') do
  begin
    RegisterMethod('Procedure AddContent( aContent : TALMultiPartAlternativeContent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartAlternativeContents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContents', 'TALMultiPartAlternativeContents') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContents'),'TALMultiPartAlternativeContents') do
  begin
    RegisterMethod('Function Add : TALMultiPartAlternativeContent;');
    RegisterMethod('Function Add1( AObject : TALMultiPartAlternativeContent) : Integer;');
    RegisterMethod('Function Remove( AObject : TALMultiPartAlternativeContent) : Integer');
    RegisterMethod('Function IndexOf( AObject : TALMultiPartAlternativeContent) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TALMultiPartAlternativeContent)');
    RegisterProperty('Items', 'TALMultiPartAlternativecontent Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartAlternativeContent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContent', 'TALMultiPartAlternativeContent') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContent'),'TALMultiPartAlternativeContent') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALMultiPartAlternativeParser(CL: TPSPascalCompiler);
begin
  SIRegister_TALMultiPartAlternativeContent(CL);
  SIRegister_TALMultiPartAlternativeContents(CL);
  SIRegister_TAlMultiPartAlternativeStream(CL);
  SIRegister_TALMultipartAlternativeEncoder(CL);
  SIRegister_TALMultipartAlternativeDecoder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALMultipartAlternativeDecoderContents_R(Self: TALMultipartAlternativeDecoder; var T: TALMultiPartAlternativeContents);
begin T := Self.Contents; end;

(*----------------------------------------------------------------------------*)
procedure TALMultipartAlternativeEncoderDataStream_R(Self: TALMultipartAlternativeEncoder; var T: TAlMultiPartAlternativeStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartAlternativeContentsItems_W(Self: TALMultiPartAlternativeContents; const T: TALMultiPartAlternativecontent; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartAlternativeContentsItems_R(Self: TALMultiPartAlternativeContents; var T: TALMultiPartAlternativecontent; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALMultiPartAlternativeContentsAdd1_P(Self: TALMultiPartAlternativeContents;  AObject : TALMultiPartAlternativeContent) : Integer;
Begin Result := Self.Add(AObject); END;

(*----------------------------------------------------------------------------*)
Function TALMultiPartAlternativeContentsAdd_P(Self: TALMultiPartAlternativeContents) : TALMultiPartAlternativeContent;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartAlternativeDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartAlternativeDecoder) do
  begin
    RegisterPropertyHelper(@TALMultipartAlternativeDecoderContents_R,nil,'Contents');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartAlternativeEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartAlternativeEncoder) do
  begin
    RegisterPropertyHelper(@TALMultipartAlternativeEncoderDataStream_R,nil,'DataStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMultiPartAlternativeStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMultiPartAlternativeStream) do
  begin
    RegisterMethod(@TAlMultiPartAlternativeStream.AddContent, 'AddContent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartAlternativeContents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartAlternativeContents) do
  begin
    RegisterMethod(@TALMultiPartAlternativeContentsAdd_P, 'Add');
    RegisterMethod(@TALMultiPartAlternativeContentsAdd1_P, 'Add1');
    RegisterMethod(@TALMultiPartAlternativeContents.Remove, 'Remove');
    RegisterMethod(@TALMultiPartAlternativeContents.IndexOf, 'IndexOf');
    RegisterMethod(@TALMultiPartAlternativeContents.Insert, 'Insert');
    RegisterPropertyHelper(@TALMultiPartAlternativeContentsItems_R,@TALMultiPartAlternativeContentsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartAlternativeContent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartAlternativeContent) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMultiPartAlternativeParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALMultiPartAlternativeContent(CL);
  RIRegister_TALMultiPartAlternativeContents(CL);
  RIRegister_TAlMultiPartAlternativeStream(CL);
  RIRegister_TALMultipartAlternativeEncoder(CL);
  RIRegister_TALMultipartAlternativeDecoder(CL);
end;

 
 
{ TPSImport_ALMultiPartAlternativeParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartAlternativeParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALMultiPartAlternativeParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartAlternativeParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALMultiPartAlternativeParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
