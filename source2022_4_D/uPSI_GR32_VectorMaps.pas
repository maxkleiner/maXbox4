unit uPSI_GR32_VectorMaps;
{
   gPS demo , free add
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
  TPSImport_GR32_VectorMaps = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVectorMap(CL: TPSPascalCompiler);
procedure SIRegister_GR32_VectorMaps(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TVectorMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_VectorMaps(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,GR32
  ,GR32_VectorMaps
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_VectorMaps]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TVectorMap') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TVectorMap') do begin
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Merge( DstLeft, DstTop : Integer; Src : TVectorMap; SrcRect : TRect)');
    RegisterProperty('Vectors', 'PFixedPointArray', iptr);
    RegisterMethod('Function BoundsRect : TRect');
    RegisterMethod('Function GetTrimmedBounds : TRect');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterProperty('FixedVector', 'TFixedVector Integer Integer', iptrw);
    SetDefaultPropery('FixedVector');
    RegisterProperty('FixedVectorS', 'TFixedVector Integer Integer', iptrw);
    RegisterProperty('FixedVectorX', 'TFixedVector TFixed TFixed', iptrw);
    RegisterProperty('FixedVectorXS', 'TFixedVector TFixed TFixed', iptrw);
    RegisterProperty('FloatVector', 'TFloatVector Integer Integer', iptrw);
    RegisterProperty('FloatVectorS', 'TFloatVector Integer Integer', iptrw);
    RegisterProperty('FloatVectorF', 'TFloatVector Single Single', iptrw);
    RegisterProperty('FloatVectorFS', 'TFloatVector Single Single', iptrw);
    RegisterProperty('VectorCombineMode', 'TVectorCombineMode', iptrw);
    RegisterProperty('OnVectorCombine', 'TVectorCombineEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_VectorMaps(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TFixedVector', 'TFixedPoint');
  //CL.AddTypeS('PFixedVector', '^TFixedVector // will not work');
  CL.AddTypeS('TFloatVector', 'TFloatPoint');
  //CL.AddTypeS('PFloatVector', '^TFloatVector // will not work');
  CL.AddTypeS('TArrayOfFixedVector', 'array of TFixedVector');
  //CL.AddTypeS('PArrayOfFixedVector', '^TArrayOfFixedVector // will not work');
  CL.AddTypeS('TArrayOfFloatVector', 'array of TFloatVector');
  //CL.AddTypeS('PArrayOfFloatVector', '^TArrayOfFixedVector // will not work');
  CL.AddTypeS('TVectorCombineMode', '( vcmAdd, vcmReplace, vcmCustom )');
  CL.AddTypeS('TVectorCombineEvent', 'Procedure ( F, P : TFixedVector; var B : TFixedVector)');
  SIRegister_TVectorMap(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVectorMapOnVectorCombine_W(Self: TVectorMap; const T: TVectorCombineEvent);
begin Self.OnVectorCombine := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapOnVectorCombine_R(Self: TVectorMap; var T: TVectorCombineEvent);
begin T := Self.OnVectorCombine; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapVectorCombineMode_W(Self: TVectorMap; const T: TVectorCombineMode);
begin Self.VectorCombineMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapVectorCombineMode_R(Self: TVectorMap; var T: TVectorCombineMode);
begin T := Self.VectorCombineMode; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorFS_W(Self: TVectorMap; const T: TFloatVector; const t1: Single; const t2: Single);
begin Self.FloatVectorFS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorFS_R(Self: TVectorMap; var T: TFloatVector; const t1: Single; const t2: Single);
begin T := Self.FloatVectorFS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorF_W(Self: TVectorMap; const T: TFloatVector; const t1: Single; const t2: Single);
begin Self.FloatVectorF[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorF_R(Self: TVectorMap; var T: TFloatVector; const t1: Single; const t2: Single);
begin T := Self.FloatVectorF[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorS_W(Self: TVectorMap; const T: TFloatVector; const t1: Integer; const t2: Integer);
begin Self.FloatVectorS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVectorS_R(Self: TVectorMap; var T: TFloatVector; const t1: Integer; const t2: Integer);
begin T := Self.FloatVectorS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVector_W(Self: TVectorMap; const T: TFloatVector; const t1: Integer; const t2: Integer);
begin Self.FloatVector[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFloatVector_R(Self: TVectorMap; var T: TFloatVector; const t1: Integer; const t2: Integer);
begin T := Self.FloatVector[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorXS_W(Self: TVectorMap; const T: TFixedVector; const t1: TFixed; const t2: TFixed);
begin Self.FixedVectorXS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorXS_R(Self: TVectorMap; var T: TFixedVector; const t1: TFixed; const t2: TFixed);
begin T := Self.FixedVectorXS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorX_W(Self: TVectorMap; const T: TFixedVector; const t1: TFixed; const t2: TFixed);
begin Self.FixedVectorX[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorX_R(Self: TVectorMap; var T: TFixedVector; const t1: TFixed; const t2: TFixed);
begin T := Self.FixedVectorX[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorS_W(Self: TVectorMap; const T: TFixedVector; const t1: Integer; const t2: Integer);
begin Self.FixedVectorS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVectorS_R(Self: TVectorMap; var T: TFixedVector; const t1: Integer; const t2: Integer);
begin T := Self.FixedVectorS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVector_W(Self: TVectorMap; const T: TFixedVector; const t1: Integer; const t2: Integer);
begin Self.FixedVector[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapFixedVector_R(Self: TVectorMap; var T: TFixedVector; const t1: Integer; const t2: Integer);
begin T := Self.FixedVector[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TVectorMapVectors_R(Self: TVectorMap; var T: PFixedPointArray);
begin T := Self.Vectors; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorMap) do begin
      RegisterMethod(@TVectorMap.Destroy, 'Free');
     RegisterMethod(@TVectorMap.Clear, 'Clear');
    RegisterMethod(@TVectorMap.Merge, 'Merge');
    RegisterPropertyHelper(@TVectorMapVectors_R,nil,'Vectors');
    RegisterMethod(@TVectorMap.BoundsRect, 'BoundsRect');
    RegisterMethod(@TVectorMap.GetTrimmedBounds, 'GetTrimmedBounds');
    RegisterMethod(@TVectorMap.Empty, 'Empty');
    RegisterMethod(@TVectorMap.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TVectorMap.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TVectorMapFixedVector_R,@TVectorMapFixedVector_W,'FixedVector');
    RegisterPropertyHelper(@TVectorMapFixedVectorS_R,@TVectorMapFixedVectorS_W,'FixedVectorS');
    RegisterPropertyHelper(@TVectorMapFixedVectorX_R,@TVectorMapFixedVectorX_W,'FixedVectorX');
    RegisterPropertyHelper(@TVectorMapFixedVectorXS_R,@TVectorMapFixedVectorXS_W,'FixedVectorXS');
    RegisterPropertyHelper(@TVectorMapFloatVector_R,@TVectorMapFloatVector_W,'FloatVector');
    RegisterPropertyHelper(@TVectorMapFloatVectorS_R,@TVectorMapFloatVectorS_W,'FloatVectorS');
    RegisterPropertyHelper(@TVectorMapFloatVectorF_R,@TVectorMapFloatVectorF_W,'FloatVectorF');
    RegisterPropertyHelper(@TVectorMapFloatVectorFS_R,@TVectorMapFloatVectorFS_W,'FloatVectorFS');
    RegisterPropertyHelper(@TVectorMapVectorCombineMode_R,@TVectorMapVectorCombineMode_W,'VectorCombineMode');
    RegisterPropertyHelper(@TVectorMapOnVectorCombine_R,@TVectorMapOnVectorCombine_W,'OnVectorCombine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_VectorMaps(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TVectorMap(CL);
end;

 
 
{ TPSImport_GR32_VectorMaps }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_VectorMaps.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_VectorMaps(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_VectorMaps.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_VectorMaps(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
