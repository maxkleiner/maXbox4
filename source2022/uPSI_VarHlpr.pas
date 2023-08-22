unit uPSI_VarHlpr;
{
just for variant
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
  TPSImport_VarHlpr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_VarHlpr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VarHlpr_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VarHlpr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VarHlpr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_VarHlpr(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure VariantClear( var V : Variant)');
 CL.AddDelphiFunction('Procedure VariantArrayRedim( var V : Variant; High : Integer)');
 CL.AddDelphiFunction('Procedure VariantCast( const src : Variant; var dst : Variant; vt : Integer)');
 CL.AddDelphiFunction('Procedure VariantCpy( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantAdd( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantSub( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantMul( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantDiv( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantMod( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantAnd( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantOr( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantXor( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantShl( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Procedure VariantShr( const src : Variant; var dst : Variant)');
 CL.AddDelphiFunction('Function VariantAdd2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantSub2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantMul2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantDiv2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantMod2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantAnd2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantOr2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantXor2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantShl2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantShr2( const V1 : Variant; const V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantNot( const V1 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantNeg( const V1 : Variant) : Variant');
 CL.AddDelphiFunction('Function VariantGetElement( const V : Variant; i1 : integer) : Variant;');
 CL.AddDelphiFunction('Function VariantGetElement1( const V : Variant; i1, i2 : integer) : Variant;');
 CL.AddDelphiFunction('Function VariantGetElement2( const V : Variant; i1, i2, i3 : integer) : Variant;');
 CL.AddDelphiFunction('Function VariantGetElement3( const V : Variant; i1, i2, i3, i4 : integer) : Variant;');
 CL.AddDelphiFunction('Function VariantGetElement4( const V : Variant; i1, i2, i3, i4, i5 : integer) : Variant;');
 CL.AddDelphiFunction('Procedure VariantPutElement( var V : Variant; const data : Variant; i1 : integer);');
 CL.AddDelphiFunction('Procedure VariantPutElement1( var V : Variant; const data : Variant; i1, i2 : integer);');
 CL.AddDelphiFunction('Procedure VariantPutElement2( var V : Variant; const data : Variant; i1, i2, i3 : integer);');
 CL.AddDelphiFunction('Procedure VariantPutElement3( var V : Variant; const data : Variant; i1, i2, i3, i4 : integer);');
 CL.AddDelphiFunction('Procedure VariantPutElement4( var V : Variant; const data : Variant; i1, i2, i3, i4, i5 : integer);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure VariantPutElement4_P( var V : Variant; const data : Variant; i1, i2, i3, i4, i5 : integer);
Begin VarHlpr.VariantPutElement(V, data, i1, i2, i3, i4, i5); END;

(*----------------------------------------------------------------------------*)
Procedure VariantPutElement3_P( var V : Variant; const data : Variant; i1, i2, i3, i4 : integer);
Begin VarHlpr.VariantPutElement(V, data, i1, i2, i3, i4); END;

(*----------------------------------------------------------------------------*)
Procedure VariantPutElement2_P( var V : Variant; const data : Variant; i1, i2, i3 : integer);
Begin VarHlpr.VariantPutElement(V, data, i1, i2, i3); END;

(*----------------------------------------------------------------------------*)
Procedure VariantPutElement1_P( var V : Variant; const data : Variant; i1, i2 : integer);
Begin VarHlpr.VariantPutElement(V, data, i1, i2); END;

(*----------------------------------------------------------------------------*)
Procedure VariantPutElement_P( var V : Variant; const data : Variant; i1 : integer);
Begin VarHlpr.VariantPutElement(V, data, i1); END;

(*----------------------------------------------------------------------------*)
Function VariantGetElement4_P( const V : Variant; i1, i2, i3, i4, i5 : integer) : Variant;
Begin Result := VarHlpr.VariantGetElement(V, i1, i2, i3, i4, i5); END;

(*----------------------------------------------------------------------------*)
Function VariantGetElement3_P( const V : Variant; i1, i2, i3, i4 : integer) : Variant;
Begin Result := VarHlpr.VariantGetElement(V, i1, i2, i3, i4); END;

(*----------------------------------------------------------------------------*)
Function VariantGetElement2_P( const V : Variant; i1, i2, i3 : integer) : Variant;
Begin Result := VarHlpr.VariantGetElement(V, i1, i2, i3); END;

(*----------------------------------------------------------------------------*)
Function VariantGetElement1_P( const V : Variant; i1, i2 : integer) : Variant;
Begin Result := VarHlpr.VariantGetElement(V, i1, i2); END;

(*----------------------------------------------------------------------------*)
Function VariantGetElement_P( const V : Variant; i1 : integer) : Variant;
Begin Result := VarHlpr.VariantGetElement(V, i1); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VarHlpr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VariantClear, 'VariantClear', cdRegister);
 S.RegisterDelphiFunction(@VariantArrayRedim, 'VariantArrayRedim', cdRegister);
 S.RegisterDelphiFunction(@VariantCast, 'VariantCast', cdRegister);
 S.RegisterDelphiFunction(@VariantCpy, 'VariantCpy', cdRegister);
 S.RegisterDelphiFunction(@VariantAdd, 'VariantAdd', cdRegister);
 S.RegisterDelphiFunction(@VariantSub, 'VariantSub', cdRegister);
 S.RegisterDelphiFunction(@VariantMul, 'VariantMul', cdRegister);
 S.RegisterDelphiFunction(@VariantDiv, 'VariantDiv', cdRegister);
 S.RegisterDelphiFunction(@VariantMod, 'VariantMod', cdRegister);
 S.RegisterDelphiFunction(@VariantAnd, 'VariantAnd', cdRegister);
 S.RegisterDelphiFunction(@VariantOr, 'VariantOr', cdRegister);
 S.RegisterDelphiFunction(@VariantXor, 'VariantXor', cdRegister);
 S.RegisterDelphiFunction(@VariantShl, 'VariantShl', cdRegister);
 S.RegisterDelphiFunction(@VariantShr, 'VariantShr', cdRegister);
 S.RegisterDelphiFunction(@VariantAdd2, 'VariantAdd2', cdRegister);
 S.RegisterDelphiFunction(@VariantSub2, 'VariantSub2', cdRegister);
 S.RegisterDelphiFunction(@VariantMul2, 'VariantMul2', cdRegister);
 S.RegisterDelphiFunction(@VariantDiv2, 'VariantDiv2', cdRegister);
 S.RegisterDelphiFunction(@VariantMod2, 'VariantMod2', cdRegister);
 S.RegisterDelphiFunction(@VariantAnd2, 'VariantAnd2', cdRegister);
 S.RegisterDelphiFunction(@VariantOr2, 'VariantOr2', cdRegister);
 S.RegisterDelphiFunction(@VariantXor2, 'VariantXor2', cdRegister);
 S.RegisterDelphiFunction(@VariantShl2, 'VariantShl2', cdRegister);
 S.RegisterDelphiFunction(@VariantShr2, 'VariantShr2', cdRegister);
 S.RegisterDelphiFunction(@VariantNot, 'VariantNot', cdRegister);
 S.RegisterDelphiFunction(@VariantNeg, 'VariantNeg', cdRegister);
 S.RegisterDelphiFunction(@VariantGetElement, 'VariantGetElement', cdRegister);
 S.RegisterDelphiFunction(@VariantGetElement1_P, 'VariantGetElement1', cdRegister);
 S.RegisterDelphiFunction(@VariantGetElement2_P, 'VariantGetElement2', cdRegister);
 S.RegisterDelphiFunction(@VariantGetElement3_P, 'VariantGetElement3', cdRegister);
 S.RegisterDelphiFunction(@VariantGetElement4_P, 'VariantGetElement4', cdRegister);
 S.RegisterDelphiFunction(@VariantPutElement, 'VariantPutElement', cdRegister);
 S.RegisterDelphiFunction(@VariantPutElement1_P, 'VariantPutElement1', cdRegister);
 S.RegisterDelphiFunction(@VariantPutElement2_P, 'VariantPutElement2', cdRegister);
 S.RegisterDelphiFunction(@VariantPutElement3_P, 'VariantPutElement3', cdRegister);
 S.RegisterDelphiFunction(@VariantPutElement4_P, 'VariantPutElement4', cdRegister);
end;



{ TPSImport_VarHlpr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarHlpr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VarHlpr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarHlpr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_VarHlpr(ri);
  RIRegister_VarHlpr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
