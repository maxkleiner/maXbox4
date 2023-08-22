unit uPSI_flcStringBuilder;
{
Tunicode core code uni     string the bild

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
  TPSImport_flcStringBuilder = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStringBuilder(CL: TPSPascalCompiler);
//procedure SIRegister_TUnicodeStringBuilder(CL: TPSPascalCompiler);
procedure SIRegister_TRawByteStringBuilder(CL: TPSPascalCompiler);
procedure SIRegister_TAnsiStringBuilder(CL: TPSPascalCompiler);
procedure SIRegister_flcStringBuilder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcStringBuilder_Routines(S: TPSExec);
procedure RIRegister_TStringBuilder(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TUnicodeStringBuilder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRawByteStringBuilder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnsiStringBuilder(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcStringBuilder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcStringBuilder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcStringBuilder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringBuilder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStringBuilder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStringBuilder') do begin
    RegisterMethod('Constructor Create( const S : String);');
    RegisterMethod('Constructor Create2( const Capacity : Integer);');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('AsString', 'String', iptrw);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( const S : TStringBuilder)');
    RegisterMethod('Procedure Append( const S : String);');
    RegisterMethod('Procedure AppendCRLF');
    RegisterMethod('Procedure AppendLn( const S : String)');
    RegisterMethod('Procedure Append1( const S : String; const Count : Integer);');
    RegisterMethod('Procedure AppendCh( const C : Char);');
    RegisterMethod('Procedure AppendCh1( const C : Char; const Count : Integer);');
    RegisterMethod('Procedure Append2( const S : TStringBuilder);');
    RegisterMethod('Procedure Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUnicodeStringBuilder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TUnicodeStringBuilder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TUnicodeStringBuilder') do
  begin
    RegisterMethod('Constructor Create( const S : UnicodeString);');
    RegisterMethod('Constructor Create2( const Capacity : Integer);');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('AsUnicodeString', 'UnicodeString', iptrw);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( const S : TUnicodeStringBuilder)');
    RegisterMethod('Procedure Append18( const S : UnicodeString);');
    RegisterMethod('Procedure AppendCRLF');
    RegisterMethod('Procedure AppendLn( const S : UnicodeString)');
    RegisterMethod('Procedure Append19( const S : UnicodeString; const Count : Integer);');
    RegisterMethod('Procedure AppendCh20( const C : WideChar);');
    RegisterMethod('Procedure AppendCh21( const C : WideChar; const Count : Integer);');
    RegisterMethod('Procedure Append22( const S : TUnicodeStringBuilder);');
    RegisterMethod('Procedure Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRawByteStringBuilder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRawByteStringBuilder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRawByteStringBuilder') do
  begin
    RegisterMethod('Constructor Create( const S : RawByteString);');
    RegisterMethod('Constructor Create2( const Capacity : Integer);');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('AsRawByteString', 'RawByteString', iptrw);
    RegisterProperty('AsString', 'String', iptr);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( const S : TRawByteStringBuilder)');
    RegisterMethod('Procedure Append10( const S : RawByteString);');
    RegisterMethod('Procedure AppendCRLF');
    RegisterMethod('Procedure AppendLn( const S : RawByteString)');
    RegisterMethod('Procedure Append11( const S : RawByteString; const Count : Integer);');
    RegisterMethod('Procedure AppendCh12( const C : AnsiChar);');
    RegisterMethod('Procedure AppendCh13( const C : AnsiChar; const Count : Integer);');
    RegisterMethod('Procedure Append14( const BufPtr : Pointer; const Size : Integer);');
    RegisterMethod('Procedure Append15( const S : TRawByteStringBuilder);');
    RegisterMethod('Procedure Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnsiStringBuilder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAnsiStringBuilder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAnsiStringBuilder') do
  begin
    RegisterMethod('Constructor Create( const S : AnsiString);');
    RegisterMethod('Constructor Create1( const Capacity : Integer);');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('AsAnsiString', 'AnsiString', iptrw);
    RegisterProperty('AsString', 'String', iptr);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( const S : TAnsiStringBuilder)');
    RegisterMethod('Procedure Append( const S : AnsiString);');
    RegisterMethod('Procedure AppendCRLF');
    RegisterMethod('Procedure AppendLn( const S : AnsiString)');
    RegisterMethod('Procedure Append3( const S : AnsiString; const Count : Integer);');
    RegisterMethod('Procedure AppendCh4( const C : AnsiChar);');
    RegisterMethod('Procedure AppendCh5( const C : AnsiChar; const Count : Integer);');
    RegisterMethod('Procedure Append6( const BufPtr : Pointer; const Size : Integer);');
    RegisterMethod('Procedure Append7( const S : TAnsiStringBuilder);');
    RegisterMethod('Procedure Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcStringBuilder(CL: TPSPascalCompiler);
begin
  SIRegister_TAnsiStringBuilder(CL);
  SIRegister_TRawByteStringBuilder(CL);
  SIRegister_TUnicodeStringBuilder(CL);
  SIRegister_TStringBuilder(CL);
 CL.AddDelphiFunction('Procedure TestStringBuilderClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TStringBuilderAppend29_P(Self: TStringBuilder;  const S : TStringBuilder);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
Procedure TStringBuilderAppendCh28_P(Self: TStringBuilder;  const C : Char; const Count : Integer);
Begin Self.AppendCh(C, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TStringBuilderAppendCh27_P(Self: TStringBuilder;  const C : Char);
Begin Self.AppendCh(C); END;

(*----------------------------------------------------------------------------*)
Procedure TStringBuilderAppend26_P(Self: TStringBuilder;  const S : String; const Count : Integer);
Begin Self.Append(S, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TStringBuilderAppend25_P(Self: TStringBuilder;  const S : String);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
procedure TStringBuilderAsString_W(Self: TStringBuilder; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringBuilderAsString_R(Self: TStringBuilder; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TStringBuilderLength_R(Self: TStringBuilder; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
Function TStringBuilderCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Capacity : Integer):TObject;
Begin Result := TStringBuilder.Create(Capacity); END;

(*----------------------------------------------------------------------------*)
Function TStringBuilderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const S : String):TObject;
Begin Result := TStringBuilder.Create(S); END;

{
(*----------------------------------------------------------------------------*)
Procedure TUnicodeStringBuilderAppend22_P(Self: TUnicodeStringBuilder;  const S : TUnicodeStringBuilder);
Begin Self.Append(S); END;      }

{
(*----------------------------------------------------------------------------*)
Procedure TUnicodeStringBuilderAppendCh21_P(Self: TUnicodeStringBuilder;  const C : WideChar; const Count : Integer);
Begin Self.AppendCh(C, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TUnicodeStringBuilderAppendCh20_P(Self: TUnicodeStringBuilder;  const C : WideChar);
Begin Self.AppendCh(C); END;

(*----------------------------------------------------------------------------*)
Procedure TUnicodeStringBuilderAppend19_P(Self: TUnicodeStringBuilder;  const S : UnicodeString; const Count : Integer);
Begin Self.Append(S, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TUnicodeStringBuilderAppend18_P(Self: TUnicodeStringBuilder;  const S : UnicodeString);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
procedure TUnicodeStringBuilderAsUnicodeString_W(Self: TUnicodeStringBuilder; const T: UnicodeString);
begin Self.AsUnicodeString := T; end;

(*----------------------------------------------------------------------------*)
procedure TUnicodeStringBuilderAsUnicodeString_R(Self: TUnicodeStringBuilder; var T: UnicodeString);
begin T := Self.AsUnicodeString; end;

(*----------------------------------------------------------------------------*)
procedure TUnicodeStringBuilderLength_R(Self: TUnicodeStringBuilder; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
Function TUnicodeStringBuilderCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Capacity : Integer):TObject;
Begin Result := TUnicodeStringBuilder.Create(Capacity); END;

(*----------------------------------------------------------------------------*)
Function TUnicodeStringBuilderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const S : UnicodeString):TObject;
Begin Result := TUnicodeStringBuilder.Create(S); END;      }

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppend15_P(Self: TRawByteStringBuilder;  const S : TRawByteStringBuilder);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppend14_P(Self: TRawByteStringBuilder;  const BufPtr : Pointer; const Size : Integer);
Begin Self.Append(BufPtr, Size); END;

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppendCh13_P(Self: TRawByteStringBuilder;  const C : AnsiChar; const Count : Integer);
Begin Self.AppendCh(C, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppendCh12_P(Self: TRawByteStringBuilder;  const C : AnsiChar);
Begin Self.AppendCh(C); END;

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppend11_P(Self: TRawByteStringBuilder;  const S : RawByteString; const Count : Integer);
Begin Self.Append(S, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TRawByteStringBuilderAppend10_P(Self: TRawByteStringBuilder;  const S : RawByteString);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
procedure TRawByteStringBuilderAsString_R(Self: TRawByteStringBuilder; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TRawByteStringBuilderAsRawByteString_W(Self: TRawByteStringBuilder; const T: RawByteString);
begin Self.AsRawByteString := T; end;

(*----------------------------------------------------------------------------*)
procedure TRawByteStringBuilderAsRawByteString_R(Self: TRawByteStringBuilder; var T: RawByteString);
begin T := Self.AsRawByteString; end;

(*----------------------------------------------------------------------------*)
procedure TRawByteStringBuilderLength_R(Self: TRawByteStringBuilder; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
Function TRawByteStringBuilderCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Capacity : Integer):TObject;
Begin Result := TRawByteStringBuilder.Create(Capacity); END;

(*----------------------------------------------------------------------------*)
Function TRawByteStringBuilderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const S : RawByteString):TObject;
Begin Result := TRawByteStringBuilder.Create(S); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend7_P(Self: TAnsiStringBuilder;  const S : TAnsiStringBuilder);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend6_P(Self: TAnsiStringBuilder;  const BufPtr : Pointer; const Size : Integer);
Begin Self.Append(BufPtr, Size); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppendCh5_P(Self: TAnsiStringBuilder;  const C : AnsiChar; const Count : Integer);
Begin Self.AppendCh(C, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppendCh4_P(Self: TAnsiStringBuilder;  const C : AnsiChar);
Begin Self.AppendCh(C); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend3_P(Self: TAnsiStringBuilder;  const S : AnsiString; const Count : Integer);
Begin Self.Append(S, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend2_P(Self: TAnsiStringBuilder;  const S : AnsiString);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsString_R(Self: TAnsiStringBuilder; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsAnsiString_W(Self: TAnsiStringBuilder; const T: AnsiString);
begin Self.AsAnsiString := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsAnsiString_R(Self: TAnsiStringBuilder; var T: AnsiString);
begin T := Self.AsAnsiString; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderLength_R(Self: TAnsiStringBuilder; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
Function TAnsiStringBuilderCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const Capacity : Integer):TObject;
Begin Result := TAnsiStringBuilder.Create(Capacity); END;

(*----------------------------------------------------------------------------*)
Function TAnsiStringBuilderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const S : AnsiString):TObject;
Begin Result := TAnsiStringBuilder.Create(S); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcStringBuilder_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TestStringBuilder, 'TestStringBuilderClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringBuilder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringBuilder) do begin
    RegisterConstructor(@TStringBuilderCreate_P, 'Create');
    RegisterConstructor(@TStringBuilderCreate2_P, 'Create2');
    RegisterPropertyHelper(@TStringBuilderLength_R,nil,'Length');
    RegisterPropertyHelper(@TStringBuilderAsString_R,@TStringBuilderAsString_W,'AsString');
    RegisterMethod(@TStringBuilder.Clear, 'Clear');
    RegisterMethod(@TStringBuilder.Assign, 'Assign');
    RegisterMethod(@TStringBuilderAppend25_P, 'Append');
    RegisterMethod(@TStringBuilder.AppendCRLF, 'AppendCRLF');
    RegisterMethod(@TStringBuilder.AppendLn, 'AppendLn');
    RegisterMethod(@TStringBuilderAppend26_P, 'Append1');
    RegisterMethod(@TStringBuilderAppendCh27_P, 'AppendCh');
    RegisterMethod(@TStringBuilderAppendCh28_P, 'AppendCh1');
    RegisterMethod(@TStringBuilderAppend29_P, 'Append2');
    RegisterMethod(@TStringBuilder.Pack, 'Pack');
  end;
end;

{

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUnicodeStringBuilder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUnicodeStringBuilder) do
  begin
    RegisterConstructor(@TUnicodeStringBuilderCreate_P, 'Create');
    RegisterConstructor(@TUnicodeStringBuilderCreate2_P, 'Create2');
    RegisterPropertyHelper(@TUnicodeStringBuilderLength_R,nil,'Length');
    RegisterPropertyHelper(@TUnicodeStringBuilderAsUnicodeString_R,@TUnicodeStringBuilderAsUnicodeString_W,'AsUnicodeString');
    RegisterMethod(@TUnicodeStringBuilder.Clear, 'Clear');
    RegisterMethod(@TUnicodeStringBuilder.Assign, 'Assign');
    RegisterMethod(@TUnicodeStringBuilderAppend18_P, 'Append18');
    RegisterMethod(@TUnicodeStringBuilder.AppendCRLF, 'AppendCRLF');
    RegisterMethod(@TUnicodeStringBuilder.AppendLn, 'AppendLn');
    RegisterMethod(@TUnicodeStringBuilderAppend19_P, 'Append19');
    RegisterMethod(@TUnicodeStringBuilderAppendCh20_P, 'AppendCh20');
    RegisterMethod(@TUnicodeStringBuilderAppendCh21_P, 'AppendCh21');
    RegisterMethod(@TUnicodeStringBuilderAppend22_P, 'Append22');
    RegisterMethod(@TUnicodeStringBuilder.Pack, 'Pack');
  end;
end;     }

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRawByteStringBuilder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRawByteStringBuilder) do
  begin
    RegisterConstructor(@TRawByteStringBuilderCreate_P, 'Create');
    RegisterConstructor(@TRawByteStringBuilderCreate2_P, 'Create2');
    RegisterPropertyHelper(@TRawByteStringBuilderLength_R,nil,'Length');
    RegisterPropertyHelper(@TRawByteStringBuilderAsRawByteString_R,@TRawByteStringBuilderAsRawByteString_W,'AsRawByteString');
    RegisterPropertyHelper(@TRawByteStringBuilderAsString_R,nil,'AsString');
    RegisterMethod(@TRawByteStringBuilder.Clear, 'Clear');
    RegisterMethod(@TRawByteStringBuilder.Assign, 'Assign');
    RegisterMethod(@TRawByteStringBuilderAppend10_P, 'Append10');
    RegisterMethod(@TRawByteStringBuilder.AppendCRLF, 'AppendCRLF');
    RegisterMethod(@TRawByteStringBuilder.AppendLn, 'AppendLn');
    RegisterMethod(@TRawByteStringBuilderAppend11_P, 'Append11');
    RegisterMethod(@TRawByteStringBuilderAppendCh12_P, 'AppendCh12');
    RegisterMethod(@TRawByteStringBuilderAppendCh13_P, 'AppendCh13');
    RegisterMethod(@TRawByteStringBuilderAppend14_P, 'Append14');
    RegisterMethod(@TRawByteStringBuilderAppend15_P, 'Append15');
    RegisterMethod(@TRawByteStringBuilder.Pack, 'Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnsiStringBuilder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnsiStringBuilder) do
  begin
    RegisterConstructor(@TAnsiStringBuilderCreate_P, 'Create');
    RegisterConstructor(@TAnsiStringBuilderCreate1_P, 'Create1');
    RegisterPropertyHelper(@TAnsiStringBuilderLength_R,nil,'Length');
    RegisterPropertyHelper(@TAnsiStringBuilderAsAnsiString_R,@TAnsiStringBuilderAsAnsiString_W,'AsAnsiString');
    RegisterPropertyHelper(@TAnsiStringBuilderAsString_R,nil,'AsString');
    RegisterMethod(@TAnsiStringBuilder.Clear, 'Clear');
    RegisterMethod(@TAnsiStringBuilder.Assign, 'Assign');
    RegisterMethod(@TAnsiStringBuilderAppend2_P, 'Append');
    RegisterMethod(@TAnsiStringBuilder.AppendCRLF, 'AppendCRLF');
    RegisterMethod(@TAnsiStringBuilder.AppendLn, 'AppendLn');
    RegisterMethod(@TAnsiStringBuilderAppend3_P, 'Append3');
    RegisterMethod(@TAnsiStringBuilderAppendCh4_P, 'AppendCh4');
    RegisterMethod(@TAnsiStringBuilderAppendCh5_P, 'AppendCh5');
    RegisterMethod(@TAnsiStringBuilderAppend6_P, 'Append6');
    RegisterMethod(@TAnsiStringBuilderAppend7_P, 'Append7');
    RegisterMethod(@TAnsiStringBuilder.Pack, 'Pack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcStringBuilder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAnsiStringBuilder(CL);
  RIRegister_TRawByteStringBuilder(CL);
  //RIRegister_TUnicodeStringBuilder(CL);
  RIRegister_TStringBuilder(CL);
end;

 
 
{ TPSImport_flcStringBuilder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStringBuilder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcStringBuilder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStringBuilder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcStringBuilder(ri);
  RIRegister_flcStringBuilder_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
