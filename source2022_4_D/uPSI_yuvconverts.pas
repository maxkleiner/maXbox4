unit uPSI_yuvconverts;
{
   for micro camera
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
  TPSImport_yuvconverts = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_yuvconverts(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_yuvconverts_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,yuvconverts
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_yuvconverts]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_yuvconverts(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TVideoCodec', '( vcUnknown, vcRGB, vcYUY2, vcUYVY, vcBTYUV, vcYV'
   +'U9, vcYUV12, vcY8, vcY211 )');
 CL.AddConstantN('BI_YUY2','LongWord').SetUInt( $32595559);
 CL.AddConstantN('BI_UYVY','LongWord').SetUInt( $59565955);
 CL.AddConstantN('BI_BTYUV','LongWord').SetUInt( $50313459);
 CL.AddConstantN('BI_YVU9','LongWord').SetUInt( $39555659);
 CL.AddConstantN('BI_YUV12','LongWord').SetUInt( $30323449);
 CL.AddConstantN('BI_Y8','LongWord').SetUInt( $20203859);
 CL.AddConstantN('BI_Y211','LongWord').SetUInt( $31313259);
 CL.AddDelphiFunction('Function BICompressionToVideoCodec( Value : DWord) : TVideoCodec');
 CL.AddDelphiFunction('Function ConvertCodecToRGB1( Codec : TVideoCodec; Src, Dst : ___Pointer; AWidth, AHeight : Integer) : Boolean');
 CL.AddDelphiFunction('Function ConvertCodecToRGB( Codec : TVideoCodec; Src, Dst : TObject; AWidth, AHeight : Integer) : Boolean');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_yuvconverts_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BICompressionToVideoCodec, 'BICompressionToVideoCodec', cdRegister);
 S.RegisterDelphiFunction(@ConvertCodecToRGB, 'ConvertCodecToRGB', cdRegister);
 S.RegisterDelphiFunction(@ConvertCodecToRGB, 'ConvertCodecToRGB1', cdRegister);
end;

 
 
{ TPSImport_yuvconverts }
(*----------------------------------------------------------------------------*)
procedure TPSImport_yuvconverts.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_yuvconverts(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_yuvconverts.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_yuvconverts(ri);
  RIRegister_yuvconverts_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
