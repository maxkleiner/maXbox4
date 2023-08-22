unit uPSI_urandom;
{
   with UVAG
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
  TPSImport_urandom = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_urandom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_urandom_Routines(S: TPSExec);
{ compile-time registration functions }

procedure SIRegister_uranuvag(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uranuvag_Routines(S: TPSExec);

{ compile-time registration functions }
procedure SIRegister_uqsort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uqsort_Routines(S: TPSExec);

{ compile-time registration functions }
procedure SIRegister_ugenalg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ugenalg_Routines(S: TPSExec);

{ compile-time registration functions }
procedure SIRegister_uinterv(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uinterv_Routines(S: TPSExec);






procedure Register;

implementation


uses
   utypes
  //,uranmwc
  //,uranmt
  ,uranuvag
  ,urandom
  ,ugenalg
  ,uinterv
  ;


procedure QSort(X : TVector; Lb, Ub : Integer);
{ Quick sort in ascending order - Adapted from Borland's BP7 demo }

    procedure Sort(L, R : Integer);
    var
      I, J : Integer;
      U, V : Float;
    begin
      I := L;
      J := R;
      U := X[(L + R) div 2];
      repeat
        while X[I] < U do I := I + 1;
        while U < X[J] do J := J - 1;
        if I <= J then
          begin
            V := X[I]; X[I] := X[J]; X[J] := V;
            I := I + 1; J := J - 1;
          end;
      until I > J;
      if L < J then Sort(L, J);
      if I < R then Sort(I, R);
    end;

begin
  Sort(Lb, Ub);
end;

procedure DQSort(X : TVector; Lb, Ub : Integer);
{ Quick sort in descending order - Adapted from Borland's BP7 demo }

    procedure Sort(L, R : Integer);
    var
      I, J : Integer;
      U, V : Float;
    begin
      I := L;
      J := R;
      U := X[(L + R) div 2];
      repeat
        while X[I] > U do I := I + 1;
        while U > X[J] do J := J - 1;
        if I <= J then
          begin
            V := X[I]; X[I] := X[J]; X[J] := V;
            I := I + 1; J := J - 1;
          end;
      until I > J;
      if L < J then Sort(L, J);
      if I < R then Sort(I, R);
    end;

begin
  Sort(Lb, Ub);
end;  
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_urandom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_urandom(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SetRNG( RNG : RNG_Type)');
 CL.AddDelphiFunction('Procedure InitGen( Seed : RNG_IntType)');
 CL.AddDelphiFunction('Procedure SRand( Seed : RNG_IntType)');
 CL.AddDelphiFunction('Function IRanGen : RNG_IntType');
 CL.AddDelphiFunction('Function IRanGen31 : RNG_IntType');
 CL.AddDelphiFunction('Function RanGen1 : Float');
 CL.AddDelphiFunction('Function RanGen2 : Float');
 CL.AddDelphiFunction('Function RanGen3 : Float');
 CL.AddDelphiFunction('Function RanGen53 : Float');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_urandom_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetRNG, 'SetRNG', cdRegister);
 S.RegisterDelphiFunction(@InitGen, 'InitGen', cdRegister);
 S.RegisterDelphiFunction(@InitGen, 'SRand', cdRegister);
 S.RegisterDelphiFunction(@IRanGen, 'IRanGen', cdRegister);
 S.RegisterDelphiFunction(@IRanGen31, 'IRanGen31', cdRegister);
 S.RegisterDelphiFunction(@RanGen1, 'RanGen1', cdRegister);
 S.RegisterDelphiFunction(@RanGen2, 'RanGen2', cdRegister);
 S.RegisterDelphiFunction(@RanGen3, 'RanGen3', cdRegister);
 S.RegisterDelphiFunction(@RanGen53, 'RanGen53', cdRegister);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uranuvag(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure InitUVAGbyString( KeyPhrase : string)');
 CL.AddDelphiFunction('Procedure InitUVAG( Seed : RNG_IntType)');
 CL.AddDelphiFunction('Function IRanUVAG : RNG_IntType');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uranuvag_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitUVAGbyString, 'InitUVAGbyString', cdRegister);
 S.RegisterDelphiFunction(@InitUVAG, 'InitUVAG', cdRegister);
 S.RegisterDelphiFunction(@IRanUVAG, 'IRanUVAG', cdRegister);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ugenalg(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure InitGAParams( NP, NG : Integer; SR, MR, HR : Float)');
 CL.AddDelphiFunction('Procedure GA_CreateLogFile( LogFileName : String)');
 CL.AddDelphiFunction('Procedure GenAlg( Func : TFuncNVar; X, Xmin, Xmax : TVector; Lb, Ub : Integer; var F_min : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ugenalg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitGAParams, 'InitGAParams', cdRegister);
 S.RegisterDelphiFunction(@GA_CreateLogFile, 'GA_CreateLogFile', cdRegister);
 S.RegisterDelphiFunction(@GenAlg, 'GenAlg', cdRegister);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uqsort(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure QSort( X : TVector; Lb, Ub : Integer)');
 CL.AddDelphiFunction('Procedure DQSort( X : TVector; Lb, Ub : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uqsort_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@QSort, 'QSort', cdRegister);
 S.RegisterDelphiFunction(@DQSort, 'DQSort', cdRegister);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uinterv(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure Interval( X1, X2 : Float; MinDiv, MaxDiv : Integer; var Min, Max, Step : Float)');
 CL.AddDelphiFunction('Procedure AutoScale( X : TVector; Lb, Ub : Integer; Scale : TScale; var XMin, XMax, XStep : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uinterv_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Interval, 'Interval', cdRegister);
 S.RegisterDelphiFunction(@AutoScale, 'AutoScale', cdRegister);
end;




 
{ TPSImport_urandom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_urandom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_urandom(CompExec.Comp);
  SIRegister_uranuvag(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_urandom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_urandom(ri);
  RIRegister_urandom_Routines(CompExec.Exec); // comment it if no routines
  RIRegister_uranuvag_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
 
 
end.
