unit uPSI_DelticsBitField;
{
bitmonster gauntlet  crypto node3

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
  TPSImport_DelticsBitField = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBitField(CL: TPSPascalCompiler);
procedure SIRegister_DelticsBitField(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBitField(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelticsBitField(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DelticsBitField
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DelticsBitField]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBitField') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBitField') do begin
    RegisterMethod('Constructor Create( const aBitCount : Integer);');
    RegisterMethod('Constructor Create1( const aData : ___Pointer; const aBytes : Integer);');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromStream( const aStream : TStream)');
    RegisterMethod('Procedure SaveToStream( const aStream : TStream)');
    RegisterProperty('AsString', 'String', iptr);
    RegisterProperty('Bit', 'Boolean Integer', iptrw);
    SetDefaultPropery('Bit');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DelticsBitField(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBitBytes', 'array of Byte');
  SIRegister_TBitField(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBitFieldCount_R(Self: TBitField; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TBitFieldBit_W(Self: TBitField; const T: Boolean; const t1: Integer);
begin Self.Bit[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitFieldBit_R(Self: TBitField; var T: Boolean; const t1: Integer);
begin T := Self.Bit[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBitFieldAsString_R(Self: TBitField; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Function TBitFieldCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const aData : Pointer; const aBytes : Integer):TObject;
Begin Result := TBitField.Create(aData, aBytes); END;

(*----------------------------------------------------------------------------*)
Function TBitFieldCreate_P(Self: TClass; CreateNewInstance: Boolean;  const aBitCount : Integer):TObject;
Begin Result := TBitField.Create(aBitCount); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitField) do begin
    RegisterConstructor(@TBitFieldCreate_P, 'Create');
    RegisterConstructor(@TBitFieldCreate1_P, 'Create1');
    RegisterMethod(@TBitField.Clear, 'Clear');
    RegisterMethod(@TBitField.Destroy, 'Free');
    RegisterMethod(@TBitField.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TBitField.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TBitFieldAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TBitFieldBit_R,@TBitFieldBit_W,'Bit');
    RegisterPropertyHelper(@TBitFieldCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsBitField(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBitField(CL);
end;

 
 
{ TPSImport_DelticsBitField }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsBitField.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DelticsBitField(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsBitField.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DelticsBitField(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
