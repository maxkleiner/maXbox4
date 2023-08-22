unit uPSI_PJPipeFilters;
{
   pipes&filter pattern
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
  TPSImport_PJPipeFilters = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJAnsiSBCSPipeFilter(CL: TPSPascalCompiler);
procedure SIRegister_TPJUnicodeBMPPipeFilter(CL: TPSPascalCompiler);
procedure SIRegister_TPJPipeFilter(CL: TPSPascalCompiler);
procedure SIRegister_PJPipeFilters(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJAnsiSBCSPipeFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJUnicodeBMPPipeFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJPipeFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJPipeFilters(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PJPipe
  ,PJPipeFilters
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJPipeFilters]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJAnsiSBCSPipeFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJPipeFilter', 'TPJAnsiSBCSPipeFilter') do
  with CL.AddClassN(CL.FindClass('TPJPipeFilter'),'TPJAnsiSBCSPipeFilter') do
  begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterProperty('EOLMarker', 'AnsiString', iptrw);
    RegisterProperty('OnText', 'TPJAnsiTextReadEvent', iptrw);
    RegisterProperty('OnLineEnd', 'TPJAnsiTextReadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJUnicodeBMPPipeFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJPipeFilter', 'TPJUnicodeBMPPipeFilter') do
  with CL.AddClassN(CL.FindClass('TPJPipeFilter'),'TPJUnicodeBMPPipeFilter') do
  begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterProperty('EOLMarker', 'UnicodeString', iptrw);
    RegisterProperty('OnText', 'TPJUnicodeTextReadEvent', iptrw);
    RegisterProperty('OnLineEnd', 'TPJUnicodeTextReadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJPipeFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPJPipeFilter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPJPipeFilter') do begin
    RegisterMethod('Constructor Create( const APipe : TPJPipe; const AOwnsPipe : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ReadPipe');
    RegisterMethod('Procedure Flush');
    RegisterMethod('Function HaveUnprocessedData : Boolean');
    RegisterProperty('Pipe', 'TPJPipe', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJPipeFilters(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('UnicodeString', 'WideString');
  SIRegister_TPJPipeFilter(CL);
  CL.AddTypeS('TPJUnicodeTextReadEvent', 'Procedure(Sender : TObject; const Text : UnicodeString)');
  SIRegister_TPJUnicodeBMPPipeFilter(CL);
  CL.AddTypeS('TPJAnsiTextReadEvent', 'Procedure ( Sender : TObject; const Text'
   +' : AnsiString)');
  SIRegister_TPJAnsiSBCSPipeFilter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterOnLineEnd_W(Self: TPJAnsiSBCSPipeFilter; const T: TPJAnsiTextReadEvent);
begin Self.OnLineEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterOnLineEnd_R(Self: TPJAnsiSBCSPipeFilter; var T: TPJAnsiTextReadEvent);
begin T := Self.OnLineEnd; end;

(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterOnText_W(Self: TPJAnsiSBCSPipeFilter; const T: TPJAnsiTextReadEvent);
begin Self.OnText := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterOnText_R(Self: TPJAnsiSBCSPipeFilter; var T: TPJAnsiTextReadEvent);
begin T := Self.OnText; end;

(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterEOLMarker_W(Self: TPJAnsiSBCSPipeFilter; const T: AnsiString);
begin Self.EOLMarker := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJAnsiSBCSPipeFilterEOLMarker_R(Self: TPJAnsiSBCSPipeFilter; var T: AnsiString);
begin T := Self.EOLMarker; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterOnLineEnd_W(Self: TPJUnicodeBMPPipeFilter; const T: TPJUnicodeTextReadEvent);
begin Self.OnLineEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterOnLineEnd_R(Self: TPJUnicodeBMPPipeFilter; var T: TPJUnicodeTextReadEvent);
begin T := Self.OnLineEnd; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterOnText_W(Self: TPJUnicodeBMPPipeFilter; const T: TPJUnicodeTextReadEvent);
begin Self.OnText := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterOnText_R(Self: TPJUnicodeBMPPipeFilter; var T: TPJUnicodeTextReadEvent);
begin T := Self.OnText; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterEOLMarker_W(Self: TPJUnicodeBMPPipeFilter; const T: UnicodeString);
begin Self.EOLMarker := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJUnicodeBMPPipeFilterEOLMarker_R(Self: TPJUnicodeBMPPipeFilter; var T: UnicodeString);
begin T := Self.EOLMarker; end;

(*----------------------------------------------------------------------------*)
procedure TPJPipeFilterPipe_R(Self: TPJPipeFilter; var T: TPJPipe);
begin T := Self.Pipe; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJAnsiSBCSPipeFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJAnsiSBCSPipeFilter) do
  begin
    RegisterMethod(@TPJAnsiSBCSPipeFilter.AfterConstruction, 'AfterConstruction');
    RegisterPropertyHelper(@TPJAnsiSBCSPipeFilterEOLMarker_R,@TPJAnsiSBCSPipeFilterEOLMarker_W,'EOLMarker');
    RegisterPropertyHelper(@TPJAnsiSBCSPipeFilterOnText_R,@TPJAnsiSBCSPipeFilterOnText_W,'OnText');
    RegisterPropertyHelper(@TPJAnsiSBCSPipeFilterOnLineEnd_R,@TPJAnsiSBCSPipeFilterOnLineEnd_W,'OnLineEnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJUnicodeBMPPipeFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJUnicodeBMPPipeFilter) do
  begin
    RegisterMethod(@TPJUnicodeBMPPipeFilter.AfterConstruction, 'AfterConstruction');
    RegisterPropertyHelper(@TPJUnicodeBMPPipeFilterEOLMarker_R,@TPJUnicodeBMPPipeFilterEOLMarker_W,'EOLMarker');
    RegisterPropertyHelper(@TPJUnicodeBMPPipeFilterOnText_R,@TPJUnicodeBMPPipeFilterOnText_W,'OnText');
    RegisterPropertyHelper(@TPJUnicodeBMPPipeFilterOnLineEnd_R,@TPJUnicodeBMPPipeFilterOnLineEnd_W,'OnLineEnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJPipeFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJPipeFilter) do begin
    RegisterConstructor(@TPJPipeFilter.Create, 'Create');
    RegisterMethod(@TPJPipeFilter.Destroy, 'Free');
    RegisterMethod(@TPJPipeFilter.ReadPipe, 'ReadPipe');
    RegisterMethod(@TPJPipeFilter.Flush, 'Flush');
    RegisterMethod(@TPJPipeFilter.HaveUnprocessedData, 'HaveUnprocessedData');
    RegisterPropertyHelper(@TPJPipeFilterPipe_R,nil,'Pipe');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJPipeFilters(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPJPipeFilter(CL);
  RIRegister_TPJUnicodeBMPPipeFilter(CL);
  RIRegister_TPJAnsiSBCSPipeFilter(CL);
end;

 
 
{ TPSImport_PJPipeFilters }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJPipeFilters.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJPipeFilters(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJPipeFilters.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PJPipeFilters(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
