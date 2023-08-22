unit uPSI_StDict;
{
  SysTools4
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
  TPSImport_StDict = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStDictionary(CL: TPSPascalCompiler);
procedure SIRegister_TStDictNode(CL: TPSPascalCompiler);
procedure SIRegister_StDict(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StDict_Routines(S: TPSExec);
procedure RIRegister_TStDictionary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStDictNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_StDict(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StDict
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDict]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDictionary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStDictionary') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStDictionary') do begin
    RegisterMethod('Constructor Create( AHashSize : Integer)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
      RegisterMethod('procedure LoadFromStream(S : TStream);');
   RegisterMethod('procedure StoreToStream(S : TStream);');
    RegisterMethod('Function DoEqual( const String1, String2 : string) : Integer');
    RegisterMethod('Function Exists( const Name : string; var Data : Pointer) : Boolean');
    RegisterMethod('Procedure Add( const Name : string; Data : Pointer)');
    RegisterMethod('Procedure Delete( const Name : string)');
    RegisterMethod('Procedure GetItems( S : TStrings)');
    RegisterMethod('Procedure SetItems( S : TStrings)');
    RegisterMethod('Procedure Update( const Name : string; Data : Pointer)');
    RegisterMethod('Function Find( Data : Pointer; var Name : string) : Boolean');
    RegisterMethod('Procedure Join( D : TStDictionary; IgnoreDups : Boolean)');
    RegisterMethod('Function Iterate( Action : TIterateFunc; OtherData : Pointer) : TStDictNode');
    RegisterMethod('Function BinCount( H : Integer) : LongInt');
    RegisterProperty('Equal', 'TStringCompareFunc', iptrw);
    RegisterProperty('Hash', 'TDictHashFunc', iptrw);
    RegisterProperty('HashSize', 'Integer', iptrw);
    RegisterProperty('OnEqual', 'TStStringCompareEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDictNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNode', 'TStDictNode') do
  with CL.AddClassN(CL.FindClass('TStNode'),'TStDictNode') do begin
     RegisterMethod('Procedure Free');
      RegisterMethod('Constructor CreateStr( const Name : string; AData : string)');
    RegisterProperty('Name', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StDict(CL: TPSPascalCompiler);
begin
  SIRegister_TStDictNode(CL);
  SIRegister_TStDictionary(CL);
 CL.AddDelphiFunction('Function AnsiHashText( const S : string; Size : Integer) : Integer');
 CL.AddDelphiFunction('Function AnsiHashStr( const S : string; Size : Integer) : Integer');
 CL.AddDelphiFunction('Function AnsiELFHashText( const S : string; Size : Integer) : Integer');
 CL.AddDelphiFunction('Function AnsiELFHashStr( const S : string; Size : Integer) : Integer');
  CL.AddDelphiFunction('Function HashText( const S : string; Size : Integer) : Integer');
 CL.AddDelphiFunction('Function ELFHashText( const S : string; Size : Integer) : Integer');
 CL.AddDelphiFunction('Function ELFHashStr( const S : string; Size : Integer) : Integer');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStDictionaryOnEqual_W(Self: TStDictionary; const T: TStStringCompareEvent);
begin Self.OnEqual := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryOnEqual_R(Self: TStDictionary; var T: TStStringCompareEvent);
begin T := Self.OnEqual; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryHashSize_W(Self: TStDictionary; const T: Integer);
begin Self.HashSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryHashSize_R(Self: TStDictionary; var T: Integer);
begin T := Self.HashSize; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryHash_W(Self: TStDictionary; const T: TDictHashFunc);
begin Self.Hash := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryHash_R(Self: TStDictionary; var T: TDictHashFunc);
begin T := Self.Hash; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryEqual_W(Self: TStDictionary; const T: TStringCompareFunc);
begin Self.Equal := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDictionaryEqual_R(Self: TStDictionary; var T: TStringCompareFunc);
begin T := Self.Equal; end;

(*----------------------------------------------------------------------------*)
procedure TStDictNodeName_R(Self: TStDictNode; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StDict_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnsiHashText, 'AnsiHashText', cdRegister);
 S.RegisterDelphiFunction(@AnsiHashStr, 'AnsiHashStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiELFHashText, 'AnsiELFHashText', cdRegister);
 S.RegisterDelphiFunction(@AnsiELFHashStr, 'AnsiELFHashStr', cdRegister);
  S.RegisterDelphiFunction(@AnsiElfHashText, 'HashText', cdRegister);
 S.RegisterDelphiFunction(@AnsiELFHashText, 'ELFHashText', cdRegister);
 S.RegisterDelphiFunction(@AnsiELFHashStr, 'ELFHashStr', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDictionary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDictionary) do begin
    RegisterConstructor(@TStDictionary.Create, 'Create');
    RegisterMethod(@TStDictionary.Destroy, 'Free');
    RegisterMethod(@TStDictionary.Clear, 'Clear');
    RegisterMethod(@TStDictionary.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStDictionary.StoreToStream, 'StoreToStream');
    RegisterMethod(@TStDictionary.DoEqual, 'DoEqual');
    RegisterMethod(@TStDictionary.Exists, 'Exists');
    RegisterMethod(@TStDictionary.Add, 'Add');
    RegisterMethod(@TStDictionary.Delete, 'Delete');
    RegisterMethod(@TStDictionary.GetItems, 'GetItems');
    RegisterMethod(@TStDictionary.SetItems, 'SetItems');
    RegisterMethod(@TStDictionary.Update, 'Update');
    RegisterMethod(@TStDictionary.Find, 'Find');
    RegisterMethod(@TStDictionary.Join, 'Join');
    RegisterMethod(@TStDictionary.Iterate, 'Iterate');
    RegisterMethod(@TStDictionary.BinCount, 'BinCount');
    RegisterPropertyHelper(@TStDictionaryEqual_R,@TStDictionaryEqual_W,'Equal');
    RegisterPropertyHelper(@TStDictionaryHash_R,@TStDictionaryHash_W,'Hash');
    RegisterPropertyHelper(@TStDictionaryHashSize_R,@TStDictionaryHashSize_W,'HashSize');
    RegisterPropertyHelper(@TStDictionaryOnEqual_R,@TStDictionaryOnEqual_W,'OnEqual');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDictNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDictNode) do
  begin
    RegisterConstructor(@TStDictNode.CreateStr, 'CreateStr');
    RegisterPropertyHelper(@TStDictNodeName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StDict(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDictNode(CL);
  RIRegister_TStDictionary(CL);
end;

 
 
{ TPSImport_StDict }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDict.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDict(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDict.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StDict(ri);
  RIRegister_StDict_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
