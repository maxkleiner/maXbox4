unit uPSI_GR32_OrdinalMaps;
{
  the last in serie 3.9  add overrides
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
  TPSImport_GR32_OrdinalMaps = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFloatMap(CL: TPSPascalCompiler);
procedure SIRegister_TIntegerMap(CL: TPSPascalCompiler);
procedure SIRegister_TWordMap(CL: TPSPascalCompiler);
procedure SIRegister_TByteMap(CL: TPSPascalCompiler);
procedure SIRegister_TBooleanMap(CL: TPSPascalCompiler);
procedure SIRegister_GR32_OrdinalMaps(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFloatMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIntegerMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWordMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TByteMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBooleanMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_OrdinalMaps(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Graphics
  ,Windows
  ,GR32
  ,GR32_OrdinalMaps
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_OrdinalMaps]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFloatMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TFloatMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TFloatMap') do begin
    RegisterMethod('Procedure Free');
     RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Clear( FillValue : TFloat)');
    RegisterProperty('ValPtr', 'PFloat Integer Integer', iptr);
    RegisterProperty('Value', 'TFloat Integer Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('Bits', 'PFloatArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntegerMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TIntegerMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TIntegerMap') do begin
   RegisterMethod('Procedure Free');
     RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear( FillValue : Integer)');
    RegisterProperty('ValPtr', 'PInteger Integer Integer', iptr);
    RegisterProperty('Value', 'Integer Integer Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('Bits', 'PIntegerArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWordMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TWordMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TWordMap') do begin
   RegisterMethod('Procedure Free');
     RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear( FillValue : Word)');
    RegisterProperty('ValPtr', 'PWord Integer Integer', iptr);
    RegisterProperty('Value', 'Word Integer Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('Bits', 'PWordArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TByteMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TByteMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TByteMap') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear( FillValue : Byte)');
    RegisterMethod('Procedure ReadFrom( Source : TCustomBitmap32; Conversion : TConversionType)');
    RegisterMethod('Procedure WriteTo( Dest : TCustomBitmap32; Conversion : TConversionType)');
    RegisterMethod('Procedure WriteTo( Dest : TCustomBitmap32; const Palette : TPalette32)');
    RegisterProperty('Bits', 'PByteArray', iptr);
    RegisterProperty('ValPtr', 'PByte Integer Integer', iptr);
    RegisterProperty('Value', 'Byte Integer Integer', iptrw);
    SetDefaultPropery('Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBooleanMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TBooleanMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TBooleanMap') do begin
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear( FillValue : Byte)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ToggleBit( X, Y : Integer)');
    RegisterProperty('Value', 'Boolean Integer Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('Bits', 'PByteArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_OrdinalMaps(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TConversionType', '( ctRed, ctGreen, ctBlue, ctAlpha, ctUniformRGB, ctWeightedRGB )');
  SIRegister_TBooleanMap(CL);
  SIRegister_TByteMap(CL);
  SIRegister_TWordMap(CL);
  SIRegister_TIntegerMap(CL);
  SIRegister_TFloatMap(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFloatMapBits_R(Self: TFloatMap; var T: PFloatArray);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TFloatMapValue_W(Self: TFloatMap; const T: TFloat; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TFloatMapValue_R(Self: TFloatMap; var T: TFloat; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TFloatMapValPtr_R(Self: TFloatMap; var T: PFloat; const t1: Integer; const t2: Integer);
begin T := Self.ValPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerMapBits_R(Self: TIntegerMap; var T: PIntegerArray);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerMapValue_W(Self: TIntegerMap; const T: Integer; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerMapValue_R(Self: TIntegerMap; var T: Integer; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerMapValPtr_R(Self: TIntegerMap; var T: PInteger; const t1: Integer; const t2: Integer);
begin T := Self.ValPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TWordMapBits_R(Self: TWordMap; var T: PWordArray);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TWordMapValue_W(Self: TWordMap; const T: Word; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TWordMapValue_R(Self: TWordMap; var T: Word; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TWordMapValPtr_R(Self: TWordMap; var T: PWord; const t1: Integer; const t2: Integer);
begin T := Self.ValPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TByteMapValue_W(Self: TByteMap; const T: Byte; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteMapValue_R(Self: TByteMap; var T: Byte; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TByteMapValPtr_R(Self: TByteMap; var T: PByte; const t1: Integer; const t2: Integer);
begin T := Self.ValPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TByteMapBits_R(Self: TByteMap; var T: PByteArray);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TBooleanMapBits_R(Self: TBooleanMap; var T: PByteArray);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TBooleanMapValue_W(Self: TBooleanMap; const T: Boolean; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBooleanMapValue_R(Self: TBooleanMap; var T: Boolean; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFloatMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFloatMap) do begin
    RegisterMethod(@TFloatMap.Empty, 'Empty');
    RegisterMethod(@TFloatMap.Clear, 'Clear');
    RegisterMethod(@TFloatMap.Clear, 'Clear');
    RegisterMethod(@TFloatMap.Destroy, 'Free');
     RegisterPropertyHelper(@TFloatMapValPtr_R,nil,'ValPtr');
    RegisterPropertyHelper(@TFloatMapValue_R,@TFloatMapValue_W,'Value');
    RegisterPropertyHelper(@TFloatMapBits_R,nil,'Bits');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntegerMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntegerMap) do begin
    RegisterMethod(@TIntegerMap.Empty, 'Empty');
     RegisterMethod(@TIntegerMap.Destroy, 'Free');
     RegisterMethod(@TIntegerMap.Clear, 'Clear');
    RegisterPropertyHelper(@TIntegerMapValPtr_R,nil,'ValPtr');
    RegisterPropertyHelper(@TIntegerMapValue_R,@TIntegerMapValue_W,'Value');
    RegisterPropertyHelper(@TIntegerMapBits_R,nil,'Bits');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWordMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWordMap) do begin
    RegisterMethod(@TWordMap.Empty, 'Empty');
   RegisterMethod(@TWordMap.Destroy, 'Free');
     RegisterMethod(@TWordMap.Clear, 'Clear');
    RegisterPropertyHelper(@TWordMapValPtr_R,nil,'ValPtr');
    RegisterPropertyHelper(@TWordMapValue_R,@TWordMapValue_W,'Value');
    RegisterPropertyHelper(@TWordMapBits_R,nil,'Bits');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TByteMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TByteMap) do begin
    RegisterMethod(@TByteMap.Assign, 'Assign');
   RegisterMethod(@TByteMap.Destroy, 'Free');
     RegisterMethod(@TByteMap.Empty, 'Empty');
    RegisterMethod(@TByteMap.Clear, 'Clear');
    RegisterMethod(@TByteMap.ReadFrom, 'ReadFrom');
    RegisterMethod(@TByteMap.WriteTo, 'WriteTo');
    RegisterMethod(@TByteMap.WriteTo, 'WriteTo');
    RegisterPropertyHelper(@TByteMapBits_R,nil,'Bits');
    RegisterPropertyHelper(@TByteMapValPtr_R,nil,'ValPtr');
    RegisterPropertyHelper(@TByteMapValue_R,@TByteMapValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBooleanMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBooleanMap) do begin
    RegisterMethod(@TBooleanMap.Empty, 'Empty');
   RegisterMethod(@TBooleanMap.Destroy, 'Free');
     RegisterMethod(@TBooleanMap.Clear, 'Clear');
    RegisterMethod(@TBooleanMap.ToggleBit, 'ToggleBit');
    RegisterPropertyHelper(@TBooleanMapValue_R,@TBooleanMapValue_W,'Value');
    RegisterPropertyHelper(@TBooleanMapBits_R,nil,'Bits');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_OrdinalMaps(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBooleanMap(CL);
  RIRegister_TByteMap(CL);
  RIRegister_TWordMap(CL);
  RIRegister_TIntegerMap(CL);
  RIRegister_TFloatMap(CL);
end;



{ TPSImport_GR32_OrdinalMaps }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_OrdinalMaps.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_OrdinalMaps(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_OrdinalMaps.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_OrdinalMaps(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
