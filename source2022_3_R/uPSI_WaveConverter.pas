unit uPSI_WaveConverter;
{
  wave to mp3
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
  TPSImport_WaveConverter = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWaveConverter(CL: TPSPascalCompiler);
procedure SIRegister_WaveConverter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TWaveConverter(CL: TPSRuntimeClassImporter);
procedure RIRegister_WaveConverter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,MMSystem
  ,MSAcm
  ,WaveConverter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WaveConverter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWaveConverter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TWaveConverter') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TWaveConverter') do begin
    RegisterProperty('CurrentFormat', 'TACMWaveFormat', iptrw);
     RegisterMethod('Procedure Free');
     RegisterProperty('NewFormat', 'TACMWaveFormat', iptrw);
    RegisterMethod('Function LoadStream( Stream : TStream) : integer');
    RegisterMethod('Function Convert : integer');
    RegisterMethod('Function SaveWavToStream( MS : TStream) : Integer');
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WaveConverter(CL: TPSPascalCompiler);
begin

//type
  //TRiffID = array[0..3] of char;
  CL.AddTypeS('TRiffID', 'array[0..3] of char;');
  CL.AddTypeS('TRiffHeader', 'record ID : TRiffID; BytesFollowing : DWord; end');
  CL.AddTypeS('TACMWaveFormat', 'record Format : TWaveFormatEx; end');
  CL.AddTypeS('TACMWaveFormat2', 'record RawData: Array[0..128] of byte; end');

  SIRegister_TWaveConverter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWaveConverterNewFormat_W(Self: TWaveConverter; const T: TACMWaveFormat);
Begin Self.NewFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveConverterNewFormat_R(Self: TWaveConverter; var T: TACMWaveFormat);
Begin T := Self.NewFormat; end;

(*----------------------------------------------------------------------------*)
procedure TWaveConverterCurrentFormat_W(Self: TWaveConverter; const T: TACMWaveFormat);
Begin Self.CurrentFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveConverterCurrentFormat_R(Self: TWaveConverter; var T: TACMWaveFormat);
Begin T := Self.CurrentFormat; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWaveConverter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWaveConverter) do begin
    RegisterPropertyHelper(@TWaveConverterCurrentFormat_R,@TWaveConverterCurrentFormat_W,'CurrentFormat');
    RegisterPropertyHelper(@TWaveConverterNewFormat_R,@TWaveConverterNewFormat_W,'NewFormat');
    RegisterMethod(@TWaveConverter.LoadStream, 'LoadStream');
    RegisterMethod(@TWaveConverter.Convert, 'Convert');
    RegisterMethod(@TWaveConverter.SaveWavToStream, 'SaveWavToStream');
    RegisterConstructor(@TWaveConverter.Create, 'Create');
    RegisterMethod(@TWaveConverter.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WaveConverter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWaveConverter(CL);
end;

 
 
{ TPSImport_WaveConverter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveConverter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WaveConverter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveConverter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WaveConverter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
