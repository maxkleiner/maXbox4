unit uPSI_ovcstr;
{
   orpheus strings
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
  TPSImport_ovcstr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ovcstr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovcstr_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ovcstr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcstr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcstr(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcCharSet', 'set of Char');
  CL.AddTypeS('ovBTable', 'array[0..255] of Byte');
  //  BTable = array[0..{$IFDEF UNICODE}{$IFDEF HUGE_UNICODE_BMTABLE}$FFFF{$ELSE}$FF{$ENDIF}{$ELSE}$FF{$ENDIF}] of Byte;

 CL.AddDelphiFunction('Function BinaryBPChar( Dest : PChar; B : Byte) : PChar');
 CL.AddDelphiFunction('Function BinaryLPChar( Dest : PChar; L : LongInt) : PChar');
 CL.AddDelphiFunction('Function BinaryWPChar( Dest : PChar; W : Word) : PChar');
 CL.AddDelphiFunction('Procedure BMMakeTable( MatchString : PChar; var BT : ovBTable)');
 CL.AddDelphiFunction('Function BMSearch( var Buffer, BufLength : Cardinal; var BT : ovBTable; MatchString : PChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function BMSearchUC( var Buffer, BufLength : Cardinal; var BT : ovBTable; MatchString : PChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CharStrPChar( Dest : PChar; C : Char; Len : Cardinal) : PChar');
 CL.AddDelphiFunction('Function DetabPChar( Dest : PChar; Src : PChar; TabSize : Byte) : PChar');
 CL.AddDelphiFunction('Function HexBPChar( Dest : PChar; B : Byte) : PChar');
 CL.AddDelphiFunction('Function HexLPChar( Dest : PChar; L : LongInt) : PChar');
 CL.AddDelphiFunction('Function HexPtrPChar( Dest : PChar; P : TObject) : PChar');
 CL.AddDelphiFunction('Function HexWPChar( Dest : PChar; W : Word) : PChar');
 CL.AddDelphiFunction('Function LoCaseChar( C : Char) : Char');
 CL.AddDelphiFunction('Function OctalLPChar( Dest : PChar; L : LongInt) : PChar');
 CL.AddDelphiFunction('Function StrChDeletePrim( P : PChar; Pos : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrChInsertPrim( Dest : PChar; C : Char; Pos : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrChPos( P : PChar; C : Char; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Procedure StrInsertChars( Dest : PChar; Ch : Char; Pos, Count : Word)');
 CL.AddDelphiFunction('Function StrStCopy( Dest, S : PChar; Pos, Count : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrStDeletePrim( P : PChar; Pos, Count : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrStInsert( Dest, S1, S2 : PChar; Pos : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrStInsertPrim( Dest, S : PChar; Pos : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrStPos( P, S : PChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrToLongPChar( S : PChar; var I : LongInt) : Boolean');
 CL.AddDelphiFunction('Procedure TrimAllSpacesPChar( P : PChar)');
 CL.AddDelphiFunction('Function TrimEmbeddedZeros( const S : string) : string');
 CL.AddDelphiFunction('Procedure TrimEmbeddedZerosPChar( P : PChar)');
 CL.AddDelphiFunction('Function TrimTrailPrimPChar( S : PChar) : PChar');
 CL.AddDelphiFunction('Function TrimTrailPChar( Dest, S : PChar) : PChar');
 CL.AddDelphiFunction('Function TrimTrailingZeros( const S : string) : string');
 CL.AddDelphiFunction('Procedure TrimTrailingZerosPChar( P : PChar)');
 CL.AddDelphiFunction('Function UpCaseChar( C : Char) : Char');
 CL.AddDelphiFunction('Function ovcCharInSet( C : Char; const CharSet : TOvcCharSet) : Boolean');
 CL.AddDelphiFunction('Function ovc32StringIsCurrentCodePage( const S : WideString) : Boolean;');
 //CL.AddDelphiFunction('Function ovc32StringIsCurrentCodePage1( const S : PWideChar; CP : Cardinal) : Boolean;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ovc32StringIsCurrentCodePage1_P( const S : PWideChar; CP : Cardinal) : Boolean;
Begin Result := ovcstr.ovc32StringIsCurrentCodePage(S, CP); END;

(*----------------------------------------------------------------------------*)
{Function ovc32StringIsCurrentCodePage_P( const S : UnicodeStringWideString) : Boolean;
Begin Result := ovcstr.ovc32StringIsCurrentCodePage(S, WideString); END;}

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcstr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BinaryBPChar, 'BinaryBPChar', cdRegister);
 S.RegisterDelphiFunction(@BinaryLPChar, 'BinaryLPChar', cdRegister);
 S.RegisterDelphiFunction(@BinaryWPChar, 'BinaryWPChar', cdRegister);
 S.RegisterDelphiFunction(@BMMakeTable, 'BMMakeTable', cdRegister);
 S.RegisterDelphiFunction(@BMSearch, 'BMSearch', cdRegister);
 S.RegisterDelphiFunction(@BMSearchUC, 'BMSearchUC', cdRegister);
 S.RegisterDelphiFunction(@CharStrPChar, 'CharStrPChar', cdRegister);
 S.RegisterDelphiFunction(@DetabPChar, 'DetabPChar', cdRegister);
 S.RegisterDelphiFunction(@HexBPChar, 'HexBPChar', cdRegister);
 S.RegisterDelphiFunction(@HexLPChar, 'HexLPChar', cdRegister);
 S.RegisterDelphiFunction(@HexPtrPChar, 'HexPtrPChar', cdRegister);
 S.RegisterDelphiFunction(@HexWPChar, 'HexWPChar', cdRegister);
 S.RegisterDelphiFunction(@LoCaseChar, 'LoCaseChar', cdRegister);
 S.RegisterDelphiFunction(@OctalLPChar, 'OctalLPChar', cdRegister);
 S.RegisterDelphiFunction(@StrChDeletePrim, 'StrChDeletePrim', cdRegister);
 S.RegisterDelphiFunction(@StrChInsertPrim, 'StrChInsertPrim', cdRegister);
 S.RegisterDelphiFunction(@StrChPos, 'StrChPos', cdRegister);
 S.RegisterDelphiFunction(@StrInsertChars, 'StrInsertChars', cdRegister);
 S.RegisterDelphiFunction(@StrStCopy, 'StrStCopy', cdRegister);
 S.RegisterDelphiFunction(@StrStDeletePrim, 'StrStDeletePrim', cdRegister);
 S.RegisterDelphiFunction(@StrStInsert, 'StrStInsert', cdRegister);
 S.RegisterDelphiFunction(@StrStInsertPrim, 'StrStInsertPrim', cdRegister);
 S.RegisterDelphiFunction(@StrStPos, 'StrStPos', cdRegister);
 S.RegisterDelphiFunction(@StrToLongPChar, 'StrToLongPChar', cdRegister);
 S.RegisterDelphiFunction(@TrimAllSpacesPChar, 'TrimAllSpacesPChar', cdRegister);
 S.RegisterDelphiFunction(@TrimEmbeddedZeros, 'TrimEmbeddedZeros', cdRegister);
 S.RegisterDelphiFunction(@TrimEmbeddedZerosPChar, 'TrimEmbeddedZerosPChar', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailPrimPChar, 'TrimTrailPrimPChar', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailPChar, 'TrimTrailPChar', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailingZeros, 'TrimTrailingZeros', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailingZerosPChar, 'TrimTrailingZerosPChar', cdRegister);
 S.RegisterDelphiFunction(@UpCaseChar, 'UpCaseChar', cdRegister);
 S.RegisterDelphiFunction(@ovcCharInSet, 'ovcCharInSet', cdRegister);
 S.RegisterDelphiFunction(@ovc32StringIsCurrentCodePage, 'ovc32StringIsCurrentCodePage', cdRegister);
 //S.RegisterDelphiFunction(@ovc32StringIsCurrentCodePage1, 'ovc32StringIsCurrentCodePage1', cdRegister);
end;

 
 
{ TPSImport_ovcstr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcstr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ovcstr(ri);
  RIRegister_ovcstr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
