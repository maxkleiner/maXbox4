unit uPSI_DBXCharDecoder;
{
  to decode with TBytes
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
  TPSImport_DBXCharDecoder = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TDBXCharDecoder(CL: TPSPascalCompiler);
procedure SIRegister_DBXCharDecoder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBXCharDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBXCharDecoder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBXPlatform
  ,DBXCharDecoder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBXCharDecoder]);
end;


(*function DecodeChars(const Buf: TBytes; BufOff: Integer; MaxOff: Integer): Boolean;
var
  Ch: WideChar;
begin
  ;
  DecrAfter(BufOff);
  MaxOff := MaxOff - 2;
  if FHasHalfChar then
  begin
    Ch := WideChar(((Integer((FHalfChar)) shl 8) or ((Buf[Incr(BufOff)] and 255))));
    if Incr(FDecodeOff) >= FDecodeLength then
      if not GrowDecodeBufTo(FDecodeLength * 2) then
      begin
        Result := False;
        exit;
      end;
    FDecodeBuf[FDecodeOff] := Ch;
    FHasHalfChar := False;
  end;
  while BufOff < MaxOff do
  begin
    Ch := WideChar((((Integer((Buf[Incr(BufOff)] and 255))) shl 8) or (Integer(Buf[Incr(BufOff)]) and 255)));
    if (Ch = #$0) and FNullTerminated then
    begin
      Result := True;
      exit;
    end;
    if Incr(FDecodeOff) >= FDecodeLength then
      if not GrowDecodeBufTo(FDecodeLength * 2) then
      begin
        Result := False;
        exit;
      end;
    FDecodeBuf[FDecodeOff] := Ch;
  end;
  if BufOff = MaxOff then
  begin
    FHalfChar := Buf[Incr(BufOff)];
    FHasHalfChar := True;
  end;
  Result := True;
end; *)


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXCharDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDBXCharDecoder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXCharDecoder') do
  begin
    RegisterMethod('Procedure InitDecoder');
    RegisterMethod('Function GrowDecodeBufTo( NewSize : Integer) : Boolean');
    RegisterMethod('Function Decode( const Buf : TBytes; BufOff : Integer; MaxBytes : Integer) : Boolean');
    RegisterMethod('Procedure AddNullChar');
    RegisterMethod('Function DecodeChars( const Buf : TBytes; BufOff : Integer; MaxOff : Integer) : Boolean');
    RegisterProperty('DecodeOff', 'Integer', iptr);
    RegisterProperty('DecodeBuf', 'TDBXWideChars', iptr);
    RegisterProperty('PreventGrowth', 'Boolean', iptw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBXCharDecoder(CL: TPSPascalCompiler);
begin
  SIRegister_TDBXCharDecoder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBXCharDecoderPreventGrowth_W(Self: TDBXCharDecoder; const T: Boolean);
begin Self.PreventGrowth := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCharDecoderDecodeBuf_R(Self: TDBXCharDecoder; var T: TDBXWideChars);
begin T := Self.DecodeBuf; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCharDecoderDecodeOff_R(Self: TDBXCharDecoder; var T: Integer);
begin T := Self.DecodeOff; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXCharDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXCharDecoder) do
  begin
    RegisterMethod(@TDBXCharDecoder.InitDecoder, 'InitDecoder');
    RegisterMethod(@TDBXCharDecoder.GrowDecodeBufTo, 'GrowDecodeBufTo');
    RegisterVirtualMethod(@TDBXCharDecoder.Decode, 'Decode');
    RegisterMethod(@TDBXCharDecoder.AddNullChar, 'AddNullChar');
    //RegisterMethod(@TDBXCharDecoder.DecodeChars, 'DecodeChars');
    RegisterPropertyHelper(@TDBXCharDecoderDecodeOff_R,nil,'DecodeOff');
    RegisterPropertyHelper(@TDBXCharDecoderDecodeBuf_R,nil,'DecodeBuf');
    RegisterPropertyHelper(nil,@TDBXCharDecoderPreventGrowth_W,'PreventGrowth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBXCharDecoder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDBXCharDecoder(CL);
end;

 
 
{ TPSImport_DBXCharDecoder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXCharDecoder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBXCharDecoder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXCharDecoder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBXCharDecoder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
