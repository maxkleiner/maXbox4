unit uPSI_GR32_LowLevel;
{
   bit processor
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
  TPSImport_GR32_LowLevel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GR32_LowLevel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_LowLevel_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Graphics
  ,GR32
  ,GR32_Math
  ,GR32_System
  ,GR32_Bindings
  ,GR32_LowLevel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_LowLevel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_LowLevel(CL: TPSPascalCompiler);
begin

//TWrapProc = function(Value, Max: Integer): Integer;
//TWrapProcEx = function(Value, Min, Max: Integer): Integer;
//TWrapMode = (wmClamp, wmRepeat, wmMirror);

  CL.AddTypeS('TWrapProc', 'function(Value, Max: Integer): Integer;');
  CL.AddTypeS('TWrapProcEx', 'function(Value, Min, Max: Integer): Integer;');
  CL.AddTypeS('TWrapMode', '(wmClamp, wmRepeat, wmMirror)');

 CL.AddDelphiFunction('Function Clamp( const Value : Integer) : Integer;');
 CL.AddDelphiFunction('Procedure GRFillWord( var X, Count : Cardinal; Value : Longword)');
 CL.AddDelphiFunction('Function StackAlloc( Size : Integer) : ___Pointer');
 CL.AddDelphiFunction('Procedure StackFree( P : ___Pointer)');
 CL.AddDelphiFunction('Procedure Swap( var A, B : ___Pointer);');
 CL.AddDelphiFunction('Procedure Swap1( var A, B : Integer);');
 CL.AddDelphiFunction('Procedure Swap2( var A, B : TFixed);');
 CL.AddDelphiFunction('Procedure Swap3( var A, B : TColor32);');
 CL.AddDelphiFunction('Procedure TestSwap( var A, B : Integer);');
 CL.AddDelphiFunction('Procedure TestSwap1( var A, B : TFixed);');
 CL.AddDelphiFunction('Function TestClip( var A, B : Integer; const Size : Integer) : Boolean;');
 CL.AddDelphiFunction('Function TestClip1( var A, B : Integer; const Start, Stop : Integer) : Boolean;');
 CL.AddDelphiFunction('Function GRConstrain( const Value, Lo, Hi : Integer) : Integer;');
 CL.AddDelphiFunction('Function Constrain1( const Value, Lo, Hi : Single) : Single;');
 CL.AddDelphiFunction('Function SwapConstrain( const Value : Integer; Constrain1, Constrain2 : Integer) : Integer');
 CL.AddDelphiFunction('Function GRMin( const A, B, C : Integer) : Integer;');
 CL.AddDelphiFunction('Function GRMax( const A, B, C : Integer) : Integer;');
 CL.AddDelphiFunction('Function Clamp( Value, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Clamp1( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Wrap( Value, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Wrap1( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Wrap3( Value, Max : Single) : Single;;');
 CL.AddDelphiFunction('Function WrapPow2( Value, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function WrapPow21( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Mirror( Value, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function Mirror1( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function MirrorPow2( Value, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function MirrorPow21( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function GetOptimalWrap( Max : Integer) : TWrapProc;');
 CL.AddDelphiFunction('Function GetOptimalWrap1( Min, Max : Integer) : TWrapProcEx;');
 CL.AddDelphiFunction('Function GetOptimalMirror( Max : Integer) : TWrapProc;');
 CL.AddDelphiFunction('Function GetOptimalMirror1( Min, Max : Integer) : TWrapProcEx;');
 CL.AddDelphiFunction('Function GetWrapProc( WrapMode : TWrapMode) : TWrapProc;');
 CL.AddDelphiFunction('Function GetWrapProc1( WrapMode : TWrapMode; Max : Integer) : TWrapProc;');
 CL.AddDelphiFunction('Function GetWrapProcEx( WrapMode : TWrapMode) : TWrapProcEx;');
 CL.AddDelphiFunction('Function GetWrapProcEx1( WrapMode : TWrapMode; Min, Max : Integer) : TWrapProcEx;');
 CL.AddDelphiFunction('Function Div255( Value : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function SAR_4( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_8( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_9( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_11( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_12( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_13( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_14( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_15( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function SAR_16( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function ColorSwap( WinColor : TColor) : TColor32');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetWrapProcEx1_P( WrapMode : TWrapMode; Min, Max : Integer) : TWrapProcEx;
Begin Result := GR32_LowLevel.GetWrapProcEx(WrapMode, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function GetWrapProcEx_P( WrapMode : TWrapMode) : TWrapProcEx;
Begin Result := GR32_LowLevel.GetWrapProcEx(WrapMode); END;

(*----------------------------------------------------------------------------*)
Function GetWrapProc1_P( WrapMode : TWrapMode; Max : Integer) : TWrapProc;
Begin Result := GR32_LowLevel.GetWrapProc(WrapMode, Max); END;

(*----------------------------------------------------------------------------*)
Function GetWrapProc_P( WrapMode : TWrapMode) : TWrapProc;
Begin Result := GR32_LowLevel.GetWrapProc(WrapMode); END;

(*----------------------------------------------------------------------------*)
Function GetOptimalMirror1_P( Min, Max : Integer) : TWrapProcEx;
Begin Result := GR32_LowLevel.GetOptimalMirror(Min, Max); END;

(*----------------------------------------------------------------------------*)
Function GetOptimalMirror_P( Max : Integer) : TWrapProc;
Begin Result := GR32_LowLevel.GetOptimalMirror(Max); END;

(*----------------------------------------------------------------------------*)
Function GetOptimalWrap1_P( Min, Max : Integer) : TWrapProcEx;
Begin Result := GR32_LowLevel.GetOptimalWrap(Min, Max); END;

(*----------------------------------------------------------------------------*)
Function GetOptimalWrap_P( Max : Integer) : TWrapProc;
Begin Result := GR32_LowLevel.GetOptimalWrap(Max); END;

(*----------------------------------------------------------------------------*)
Function MirrorPow21_P( Value, Min, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.MirrorPow2(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MirrorPow2_P( Value, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.MirrorPow2(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Mirror1_P( Value, Min, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Mirror(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function Mirror_P( Value, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Mirror(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function WrapPow21_P( Value, Min, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.WrapPow2(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function WrapPow2_P( Value, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.WrapPow2(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Wrap3_P( Value, Max : Single) : Single;
Begin Result := GR32_LowLevel.Wrap(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Wrap2_P( Value, Max : Single) : Single;
Begin Result := GR32_LowLevel.Wrap(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Wrap1_P( Value, Min, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Wrap(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function Wrap_P( Value, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Wrap(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Clamp1_P( Value, Min, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Clamp(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function Clamp_P( Value, Max : Integer) : Integer;
Begin Result := GR32_LowLevel.Clamp(Value, Max); END;

(*----------------------------------------------------------------------------*)
Function Max_P( const A, B, C : Integer) : Integer;
Begin Result := GR32_LowLevel.Max(A, B, C); END;

(*----------------------------------------------------------------------------*)
Function Min_P( const A, B, C : Integer) : Integer;
Begin Result := GR32_LowLevel.Min(A, B, C); END;

(*----------------------------------------------------------------------------*)
Function Constrain1_P( const Value, Lo, Hi : Single) : Single;
Begin Result := GR32_LowLevel.Constrain(Value, Lo, Hi); END;

(*----------------------------------------------------------------------------*)
Function Constrain_P( const Value, Lo, Hi : Integer) : Integer;
Begin Result := GR32_LowLevel.Constrain(Value, Lo, Hi); END;

(*----------------------------------------------------------------------------*)
Function TestClip1_P( var A, B : Integer; const Start, Stop : Integer) : Boolean;
Begin Result := GR32_LowLevel.TestClip(A, B, Start, Stop); END;

(*----------------------------------------------------------------------------*)
Function TestClip_P( var A, B : Integer; const Size : Integer) : Boolean;
Begin Result := GR32_LowLevel.TestClip(A, B, Size); END;

(*----------------------------------------------------------------------------*)
Procedure TestSwap1_P( var A, B : TFixed);
Begin GR32_LowLevel.TestSwap(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure TestSwap_P( var A, B : Integer);
Begin GR32_LowLevel.TestSwap(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure Swap3_P( var A, B : TColor32);
Begin GR32_LowLevel.Swap(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure Swap2_P( var A, B : TFixed);
Begin GR32_LowLevel.Swap(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure Swap1_P( var A, B : Integer);
Begin GR32_LowLevel.Swap(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure Swap_P( var A, B : Pointer);
Begin GR32_LowLevel.Swap(A, B); END;

(*----------------------------------------------------------------------------*)
Function Clamp( const Value : Integer) : Integer;
Begin Result := GR32_LowLevel.Clamp(Value); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_LowLevel_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Clamp, 'Clamp', cdRegister);
 S.RegisterDelphiFunction(@FillWord, 'GRFillWord', cdRegister);
 S.RegisterDelphiFunction(@StackAlloc, 'StackAlloc', cdRegister);
 S.RegisterDelphiFunction(@StackFree, 'StackFree', cdRegister);
 S.RegisterDelphiFunction(@Swap, 'Swap', cdRegister);
 S.RegisterDelphiFunction(@Swap, 'Swap1', cdRegister);
 S.RegisterDelphiFunction(@Swap, 'Swap2', cdRegister);
 S.RegisterDelphiFunction(@Swap, 'Swap3', cdRegister);
 S.RegisterDelphiFunction(@TestSwap, 'TestSwap', cdRegister);
 S.RegisterDelphiFunction(@TestSwap, 'TestSwap1', cdRegister);
 S.RegisterDelphiFunction(@TestClip, 'TestClip', cdRegister);
 S.RegisterDelphiFunction(@TestClip, 'TestClip1', cdRegister);
 S.RegisterDelphiFunction(@Constrain, 'GRConstrain', cdRegister);
 S.RegisterDelphiFunction(@Constrain, 'Constrain1', cdRegister);
 S.RegisterDelphiFunction(@SwapConstrain, 'SwapConstrain', cdRegister);
 S.RegisterDelphiFunction(@Min, 'GRMin', cdRegister);
 S.RegisterDelphiFunction(@Max, 'GRMax', cdRegister);
 S.RegisterDelphiFunction(@Clamp, 'Clamp', cdRegister);
 S.RegisterDelphiFunction(@Clamp, 'Clamp1', cdRegister);
 S.RegisterDelphiFunction(@Wrap, 'Wrap', cdRegister);
 S.RegisterDelphiFunction(@Wrap, 'Wrap1', cdRegister);
 S.RegisterDelphiFunction(@Wrap, 'Wrap3', cdRegister);
 S.RegisterDelphiFunction(@WrapPow2, 'WrapPow2', cdRegister);
 S.RegisterDelphiFunction(@WrapPow2, 'WrapPow21', cdRegister);
 S.RegisterDelphiFunction(@Mirror, 'Mirror', cdRegister);
 S.RegisterDelphiFunction(@Mirror, 'Mirror1', cdRegister);
 S.RegisterDelphiFunction(@MirrorPow2, 'MirrorPow2', cdRegister);
 S.RegisterDelphiFunction(@MirrorPow2, 'MirrorPow21', cdRegister);
 S.RegisterDelphiFunction(@GetOptimalWrap, 'GetOptimalWrap', cdRegister);
 S.RegisterDelphiFunction(@GetOptimalWrap, 'GetOptimalWrap1', cdRegister);
 S.RegisterDelphiFunction(@GetOptimalMirror, 'GetOptimalMirror', cdRegister);
 S.RegisterDelphiFunction(@GetOptimalMirror, 'GetOptimalMirror1', cdRegister);
 S.RegisterDelphiFunction(@GetWrapProc, 'GetWrapProc', cdRegister);
 S.RegisterDelphiFunction(@GetWrapProc, 'GetWrapProc1', cdRegister);
 S.RegisterDelphiFunction(@GetWrapProcEx, 'GetWrapProcEx', cdRegister);
 S.RegisterDelphiFunction(@GetWrapProcEx, 'GetWrapProcEx1', cdRegister);
 S.RegisterDelphiFunction(@Div255, 'Div255', cdRegister);
 S.RegisterDelphiFunction(@SAR_4, 'SAR_4', cdRegister);
 S.RegisterDelphiFunction(@SAR_8, 'SAR_8', cdRegister);
 S.RegisterDelphiFunction(@SAR_9, 'SAR_9', cdRegister);
 S.RegisterDelphiFunction(@SAR_11, 'SAR_11', cdRegister);
 S.RegisterDelphiFunction(@SAR_12, 'SAR_12', cdRegister);
 S.RegisterDelphiFunction(@SAR_13, 'SAR_13', cdRegister);
 S.RegisterDelphiFunction(@SAR_14, 'SAR_14', cdRegister);
 S.RegisterDelphiFunction(@SAR_15, 'SAR_15', cdRegister);
 S.RegisterDelphiFunction(@SAR_16, 'SAR_16', cdRegister);
 S.RegisterDelphiFunction(@ColorSwap, 'ColorSwap', cdRegister);
end;

 
 
{ TPSImport_GR32_LowLevel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_LowLevel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_LowLevel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_LowLevel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GR32_LowLevel(ri);
  RIRegister_GR32_LowLevel_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
