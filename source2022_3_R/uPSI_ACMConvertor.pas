unit uPSI_ACMConvertor;
{
   second wave
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
  TPSImport_ACMConvertor = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TACMConvertor(CL: TPSPascalCompiler);
procedure SIRegister_ACMConvertor(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TACMConvertor(CL: TPSRuntimeClassImporter);
procedure RIRegister_ACMConvertor(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Windows
  ,Forms
  ,Controls
  ,MSACM
  ,MMSystem
  ,ACMConvertor
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ACMConvertor]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TACMConvertor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TACMConvertor') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TACMConvertor') do begin
    RegisterProperty('FormatIn', 'TACMWaveFormat', iptrw);
    RegisterProperty('FormatOut', 'TACMWaveFormat', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ChooseFormat( var Format : TACMWaveFormat; const UseDefault : Boolean) : Boolean');
    RegisterMethod('Function ChooseFormatIn( const UseDefault : Boolean) : Boolean');
    RegisterMethod('Function ChooseFormatOut( const UseDefault : Boolean) : Boolean');
    RegisterMethod('Function Convert : DWord');
    RegisterMethod('Procedure RaiseException( aMessage : String; Result : MMResult)');
    RegisterMethod('Function SuggestFormat( aFormat : TACMWaveFormat) : TACMWaveFormat');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('BufferIn', 'Pointer', iptr);
    RegisterProperty('BufferOut', 'Pointer', iptr);
    RegisterProperty('OutputBufferSize', 'DWord', iptr);
    RegisterProperty('InputBufferSize', 'DWord', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ACMConvertor(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EACMConvertor');
  SIRegister_TACMConvertor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TACMConvertorInputBufferSize_W(Self: TACMConvertor; const T: DWord);
begin Self.InputBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorInputBufferSize_R(Self: TACMConvertor; var T: DWord);
begin T := Self.InputBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorOutputBufferSize_R(Self: TACMConvertor; var T: DWord);
begin T := Self.OutputBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorBufferOut_R(Self: TACMConvertor; var T: Pointer);
begin T := Self.BufferOut; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorBufferIn_R(Self: TACMConvertor; var T: Pointer);
begin T := Self.BufferIn; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorActive_W(Self: TACMConvertor; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorActive_R(Self: TACMConvertor; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorFormatOut_W(Self: TACMConvertor; const T: TACMWaveFormat);
Begin Self.FormatOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorFormatOut_R(Self: TACMConvertor; var T: TACMWaveFormat);
Begin T := Self.FormatOut; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorFormatIn_W(Self: TACMConvertor; const T: TACMWaveFormat);
Begin Self.FormatIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TACMConvertorFormatIn_R(Self: TACMConvertor; var T: TACMWaveFormat);
Begin T := Self.FormatIn; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TACMConvertor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TACMConvertor) do begin
    RegisterPropertyHelper(@TACMConvertorFormatIn_R,@TACMConvertorFormatIn_W,'FormatIn');
    RegisterPropertyHelper(@TACMConvertorFormatOut_R,@TACMConvertorFormatOut_W,'FormatOut');
    RegisterConstructor(@TACMConvertor.Create, 'Create');
        RegisterMethod(@TACMConvertor.Destroy, 'Free');
    RegisterMethod(@TACMConvertor.ChooseFormat, 'ChooseFormat');
    RegisterMethod(@TACMConvertor.ChooseFormatIn, 'ChooseFormatIn');
    RegisterMethod(@TACMConvertor.ChooseFormatOut, 'ChooseFormatOut');
    RegisterMethod(@TACMConvertor.Convert, 'Convert');
    RegisterMethod(@TACMConvertor.RaiseException, 'RaiseException');
    RegisterMethod(@TACMConvertor.SuggestFormat, 'SuggestFormat');
    RegisterPropertyHelper(@TACMConvertorActive_R,@TACMConvertorActive_W,'Active');
    RegisterPropertyHelper(@TACMConvertorBufferIn_R,nil,'BufferIn');
    RegisterPropertyHelper(@TACMConvertorBufferOut_R,nil,'BufferOut');
    RegisterPropertyHelper(@TACMConvertorOutputBufferSize_R,nil,'OutputBufferSize');
    RegisterPropertyHelper(@TACMConvertorInputBufferSize_R,@TACMConvertorInputBufferSize_W,'InputBufferSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ACMConvertor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EACMConvertor) do
  RIRegister_TACMConvertor(CL);
end;

 
 
{ TPSImport_ACMConvertor }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ACMConvertor.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ACMConvertor(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ACMConvertor.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ACMConvertor(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
