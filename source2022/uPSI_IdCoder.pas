unit uPSI_IdCoder;
{
   code mode
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
  TPSImport_IdCoder = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDecoder(CL: TPSPascalCompiler);
procedure SIRegister_TIdEncoder(CL: TPSPascalCompiler);
procedure SIRegister_IdCoder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdCoder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdBaseComponent
  ,IdGlobal
  ,IdCoder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdCoder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdDecoder') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdDecoder') do begin
    RegisterMethod('Function DecodeString( AIn : string) : string');
    RegisterMethod('Function DecodeToString( const AIn : string) : string');
    RegisterMethod('Procedure DecodeToStream( AIn : string; ADest : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdEncoder') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdEncoder') do begin
    RegisterMethod('Function Encode( const ASrc : string) : string;');
    RegisterMethod('Function Encode1( ASrcStream : TStream; const ABytes : integer) : string;');
    RegisterMethod('Function EncodeString( const AIn : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdCoder(CL: TPSPascalCompiler);
begin
  SIRegister_TIdEncoder(CL);
  SIRegister_TIdDecoder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TIdEncoderEncode1_P(Self: TIdEncoder;  ASrcStream : TStream; const ABytes : integer) : string;
Begin Result := Self.Encode(ASrcStream, ABytes); END;

(*----------------------------------------------------------------------------*)
Function TIdEncoderEncode_P(Self: TIdEncoder;  const ASrc : string) : string;
Begin Result := Self.Encode(ASrc); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDecoder) do begin
    RegisterMethod(@TIdDecoder.DecodeString, 'DecodeString');
    RegisterMethod(@TIdDecoder.DecodeToString, 'DecodeToString');
    //RegisterVirtualAbstractMethod(@TIdDecoder, @!.DecodeToStream, 'DecodeToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdEncoder) do begin
    RegisterMethod(@TIdEncoderEncode_P, 'Encode');
    RegisterMethod(@TIdEncoderEncode1_P, 'Encode1');

    //RegisterVirtualAbstractMethod(@TIdEncoder, @!.Encode1, 'Encode1');
    RegisterMethod(@TIdEncoder.EncodeString, 'EncodeString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCoder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdEncoder(CL);
  RIRegister_TIdDecoder(CL);
end;

 
 
{ TPSImport_IdCoder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdCoder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdCoder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
