unit uPSI_Paradox;
{
Tdirect paradox lastlink parabox

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
  TPSImport_Paradox = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TParadox(CL: TPSPascalCompiler);
procedure SIRegister_Paradox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Paradox_Routines(S: TPSExec);
procedure RIRegister_TParadox(CL: TPSRuntimeClassImporter);
procedure RIRegister_Paradox(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Math
  ,Dialogs
  ,Paradox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Paradox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TParadox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TParadox') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TParadox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterMethod('Function Open : Boolean');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function Next : Boolean');
    RegisterMethod('Procedure First');
    RegisterMethod('Function Field( FldNo : Integer) : String;');
    RegisterMethod('Function Field1( FldName : String) : String;');
    RegisterMethod('Function FieldAsInteger( FldNo : Integer) : Int64;');
    RegisterMethod('Function FieldAsInteger3( FldName : String) : Int64;');
    RegisterMethod('Function FieldType( FldNo : Integer) : Integer;');
    RegisterMethod('Function FieldType5( FldName : String) : Integer;');
    RegisterMethod('Function FieldIndex( FldName : String) : Integer');
    RegisterMethod('Function FieldName( FldNo : Integer) : String');
    RegisterMethod('Function FindKey( Val : array of String) : Boolean');
    RegisterMethod('Procedure GetBlob( FldNo, BfrSiz : Integer; var BlobBfr);');
    RegisterMethod('Procedure GetBlob7( FldName : String; BfrSiz : Integer; var BlobBfr);');
    RegisterMethod('Function Locate( FldNo : array of Integer; Val : array of String) : Boolean');
    RegisterMethod('Function Version : String');
    RegisterMethod('Function WriteField( FldNo : Integer; Fld : String) : Boolean;');
    RegisterMethod('Function WriteField9( FldName : String; Fld : String) : Boolean;');
    RegisterProperty('BlobInfo', 'aPdoxBlob', iptr);
    RegisterProperty('BlockSize', 'Integer', iptr);
    RegisterProperty('EOF', 'Boolean', iptr);
    RegisterProperty('FieldCount', 'Word', iptr);
    RegisterProperty('KeyFields', 'Word', iptr);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('RecordCount', 'LongWord', iptr);
    RegisterProperty('RecordSize', 'Word', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('TableName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Paradox(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('aBlobHdr', 'record RcdType : Byte; BlkSize : Integer; end');
  //CL.AddTypeS('pPdoxBlk', '^aPdoxBlk // will not work');
  CL.AddTypeS('aPdoxBlk', 'record Next : Word; Prev : Word; Last : Word; end');
  CL.AddTypeS('aPdoxBlob', 'record FileLoc : Integer; Length : Integer; ModCnt : Word; Index : Byte; end');
  CL.AddTypeS('aBlobIdx', 'record Offset : Byte; Len16 : Byte; ModCnt : Word; Len : Byte; end');
  CL.AddTypeS('aPdoxFld', 'record Name : String; Typ : Integer; Start : Integer; Len : Integer; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EParadoxError');
  SIRegister_TParadox(CL);
 CL.AddDelphiFunction('Function CompareBytes( const V1, V2, Len : Integer) : Integer');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TParadoxTableName_W(Self: TParadox; const T: string);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxTableName_R(Self: TParadox; var T: string);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxActive_W(Self: TParadox; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxActive_R(Self: TParadox; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxRecordSize_R(Self: TParadox; var T: Word);
begin T := Self.RecordSize; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxRecordCount_R(Self: TParadox; var T: LongWord);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxReadOnly_W(Self: TParadox; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxReadOnly_R(Self: TParadox; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxKeyFields_R(Self: TParadox; var T: Word);
begin T := Self.KeyFields; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxFieldCount_R(Self: TParadox; var T: Word);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxEOF_R(Self: TParadox; var T: Boolean);
begin T := Self.EOF; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxBlockSize_R(Self: TParadox; var T: Integer);
begin T := Self.BlockSize; end;

(*----------------------------------------------------------------------------*)
procedure TParadoxBlobInfo_R(Self: TParadox; var T: aPdoxBlob);
begin T := Self.BlobInfo; end;

(*----------------------------------------------------------------------------*)
Function TParadoxWriteField9_P(Self: TParadox;  FldName : String; Fld : String) : Boolean;
Begin Result := Self.WriteField(FldName, Fld); END;

(*----------------------------------------------------------------------------*)
Function TParadoxWriteField_P(Self: TParadox;  FldNo : Integer; Fld : String) : Boolean;
Begin Result := Self.WriteField(FldNo, Fld); END;

(*----------------------------------------------------------------------------*)
Procedure TParadoxGetBlob7_P(Self: TParadox;  FldName : String; BfrSiz : Integer; var BlobBfr);
Begin Self.GetBlob(FldName, BfrSiz, BlobBfr); END;

(*----------------------------------------------------------------------------*)
Procedure TParadoxGetBlob_P(Self: TParadox;  FldNo, BfrSiz : Integer; var BlobBfr);
Begin Self.GetBlob(FldNo, BfrSiz, BlobBfr); END;

(*----------------------------------------------------------------------------*)
Function TParadoxFieldType5_P(Self: TParadox;  FldName : String) : Integer;
Begin Result := Self.FieldType(FldName); END;

(*----------------------------------------------------------------------------*)
Function TParadoxFieldType_P(Self: TParadox;  FldNo : Integer) : Integer;
Begin Result := Self.FieldType(FldNo); END;

(*----------------------------------------------------------------------------*)
Function TParadoxFieldAsInteger3_P(Self: TParadox;  FldName : String) : Int64;
Begin Result := Self.FieldAsInteger(FldName); END;

(*----------------------------------------------------------------------------*)
Function TParadoxFieldAsInteger_P(Self: TParadox;  FldNo : Integer) : Int64;
Begin Result := Self.FieldAsInteger(FldNo); END;

(*----------------------------------------------------------------------------*)
Function TParadoxField1_P(Self: TParadox;  FldName : String) : String;
Begin Result := Self.Field(FldName); END;

(*----------------------------------------------------------------------------*)
Function TParadoxField_P(Self: TParadox;  FldNo : Integer) : String;
Begin Result := Self.Field(FldNo); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Paradox_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareBytes, 'CompareBytes', cdRegister);
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParadox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParadox) do begin
    RegisterConstructor(@TParadox.Create, 'Create');
     RegisterMethod(@TParadox.Destroy, 'Free');
    RegisterMethod(@TParadox.Open, 'Open');
    RegisterMethod(@TParadox.Close, 'Close');
    RegisterMethod(@TParadox.Next, 'Next');
    RegisterMethod(@TParadox.First, 'First');
    RegisterMethod(@TParadoxField_P, 'Field');
    RegisterMethod(@TParadoxField1_P, 'Field1');
    RegisterMethod(@TParadoxFieldAsInteger_P, 'FieldAsInteger');
    RegisterMethod(@TParadoxFieldAsInteger3_P, 'FieldAsInteger3');
    RegisterMethod(@TParadoxFieldType_P, 'FieldType');
    RegisterMethod(@TParadoxFieldType5_P, 'FieldType5');
    RegisterMethod(@TParadox.FieldIndex, 'FieldIndex');
    RegisterMethod(@TParadox.FieldName, 'FieldName');
    RegisterMethod(@TParadox.FindKey, 'FindKey');
    RegisterMethod(@TParadoxGetBlob_P, 'GetBlob');
    RegisterMethod(@TParadoxGetBlob7_P, 'GetBlob7');
    RegisterMethod(@TParadox.Locate, 'Locate');
    RegisterMethod(@TParadox.Version, 'Version');
    RegisterMethod(@TParadoxWriteField_P, 'WriteField');
    RegisterMethod(@TParadoxWriteField9_P, 'WriteField9');
    RegisterPropertyHelper(@TParadoxBlobInfo_R,nil,'BlobInfo');
    RegisterPropertyHelper(@TParadoxBlockSize_R,nil,'BlockSize');
    RegisterPropertyHelper(@TParadoxEOF_R,nil,'EOF');
    RegisterPropertyHelper(@TParadoxFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@TParadoxKeyFields_R,nil,'KeyFields');
    RegisterPropertyHelper(@TParadoxReadOnly_R,@TParadoxReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TParadoxRecordCount_R,nil,'RecordCount');
    RegisterPropertyHelper(@TParadoxRecordSize_R,nil,'RecordSize');
    RegisterPropertyHelper(@TParadoxActive_R,@TParadoxActive_W,'Active');
    RegisterPropertyHelper(@TParadoxTableName_R,@TParadoxTableName_W,'TableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Paradox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EParadoxError) do
  RIRegister_TParadox(CL);
end;

 
 
{ TPSImport_Paradox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Paradox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Paradox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Paradox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Paradox(ri);
  RIRegister_Paradox_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
