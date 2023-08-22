unit uPSI_ALOpenOffice;
{
second step to open office

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
  TPSImport_ALOpenOffice = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALOpenOffice(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALOpenOffice_Routines(S: TPSExec);
procedure RIRegister_ALOpenOffice(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALOpenOffice
  ;

function EnDeCrypt(const Value : String) : String;
var
  CharIndex : integer;
begin
  Result := Value;
  for CharIndex := 1 to Length(Value) do
    Result[CharIndex] := chr(not(ord(Value[CharIndex])));
end;


 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALOpenOffice]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALOpenOffice(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALOpenOfficeException');
  CL.AddClassN(CL.FindClass('Exception'),'EALOpenOfficeException2');
 CL.AddDelphiFunction('Procedure ConnectOpenOffice');
 CL.AddDelphiFunction('Procedure DisconnectOpenOffice( aTerminateOpenOffice : boolean)');
 CL.AddDelphiFunction('Function IsOpenOfficeConnected : boolean');
 CL.AddDelphiFunction('Function CreateUnoService( const aServiceName : AnsiString) : Variant');
 CL.AddDelphiFunction('Function CreateUnoStruct( const aStructureName : AnsiString; const aMaxIndex : integer) : Variant');
 CL.AddDelphiFunction('Function HasUnoInterfaces( aObject : Variant; aInterfaceList : array of AnsiString) : boolean');
 CL.AddDelphiFunction('Function CreateOOProperties( aPropertyList : array of Variant) : Variant');
 CL.AddDelphiFunction('Function MakeOOPropertyValue( aPropertyName : AnsiString; aPropertyValue : Variant) : Variant');
 CL.AddDelphiFunction('Function CreateOOCalcDocument : Variant');
 CL.AddDelphiFunction('Function CreateOOWordDocument : Variant');
 CL.AddDelphiFunction('Function CreateOOImpressDocument : Variant');
 CL.AddDelphiFunction('Function CreateOODrawDocument : Variant');

 CL.AddDelphiFunction('Procedure SaveOODocument( aDocument : Variant; aFileName : AnsiString; aFileType : AnsiString)');
 CL.AddDelphiFunction('Procedure CreateOOSheet( aDocument : Variant; const aSheetName : AnsiString)');
 CL.AddDelphiFunction('Procedure SetColumnWidth( aSheet : Variant; const aColumnIndex : integer; const aWidthInCentimetres : integer);');
 CL.AddDelphiFunction('Procedure SetColumnWidth1( aSheet : Variant; aColumn : Variant; const aWidthInCentimetres : integer);');
 CL.AddDelphiFunction('Procedure SetCellBold( aCell : Variant)');
 CL.AddDelphiFunction('Procedure SetCellBorder( aCellRange : Variant; const aBorderColor : Longword)');
 CL.AddDelphiFunction('Function IsVariantNullOrEmpty( aVariant : Variant) : boolean');
 CL.AddDelphiFunction('Function VarDummyArray : Variant');
 CL.AddDelphiFunction('Function ConvertToURL( aWinAddress : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ConvertFromURL( aUrlAddress : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function OORGB( aRedByte, aGreenByte, aBlueByte : byte) : Longword');
 CL.AddDelphiFunction('function ALCopyStr2(const aSourceString: AnsiString; aStart, aLength: Integer): AnsiString;');
 CL.AddDelphiFunction('function EnDeCrypt(const Value : String) : String;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SetColumnWidth1_P( aSheet : Variant; aColumn : Variant; const aWidthInCentimetres : integer);
Begin ALOpenOffice.SetColumnWidth(aSheet, aColumn, aWidthInCentimetres); END;

(*----------------------------------------------------------------------------*)
Procedure SetColumnWidth0_P( aSheet : Variant; const aColumnIndex : integer; const aWidthInCentimetres : integer);
Begin ALOpenOffice.SetColumnWidth(aSheet, aColumnIndex, aWidthInCentimetres); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALOpenOffice_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ConnectOpenOffice, 'ConnectOpenOffice', cdRegister);
 S.RegisterDelphiFunction(@DisconnectOpenOffice, 'DisconnectOpenOffice', cdRegister);
 S.RegisterDelphiFunction(@IsOpenOfficeConnected, 'IsOpenOfficeConnected', cdRegister);
 S.RegisterDelphiFunction(@CreateUnoService, 'CreateUnoService', cdRegister);
 S.RegisterDelphiFunction(@CreateUnoStruct, 'CreateUnoStruct', cdRegister);
 S.RegisterDelphiFunction(@HasUnoInterfaces, 'HasUnoInterfaces', cdRegister);
 S.RegisterDelphiFunction(@CreateProperties, 'CreateOOProperties', cdRegister);
 S.RegisterDelphiFunction(@MakePropertyValue, 'MakeOOPropertyValue', cdRegister);
 S.RegisterDelphiFunction(@CreateCalcDocument, 'CreateOOCalcDocument', cdRegister);
 S.RegisterDelphiFunction(@CreateWordDocument, 'CreateOOWordDocument', cdRegister);
 S.RegisterDelphiFunction(@CreateImpressDocument, 'CreateOOImpressDocument', cdRegister);
 S.RegisterDelphiFunction(@CreateDrawDocument, 'CreateOODrawDocument', cdRegister);

 S.RegisterDelphiFunction(@SaveDocument, 'SaveOODocument', cdRegister);
 S.RegisterDelphiFunction(@CreateSheet, 'CreateOOSheet', cdRegister);
 S.RegisterDelphiFunction(@SetColumnWidth0_P, 'SetColumnWidth', cdRegister);
 S.RegisterDelphiFunction(@SetColumnWidth1_P, 'SetColumnWidth1', cdRegister);
 S.RegisterDelphiFunction(@SetCellBold, 'SetCellBold', cdRegister);
 S.RegisterDelphiFunction(@SetCellBorder, 'SetCellBorder', cdRegister);
 S.RegisterDelphiFunction(@IsVariantNullOrEmpty, 'IsVariantNullOrEmpty', cdRegister);
 S.RegisterDelphiFunction(@DummyArray, 'VarDummyArray', cdRegister);
 S.RegisterDelphiFunction(@ConvertToURL, 'ConvertToURL', cdRegister);
 S.RegisterDelphiFunction(@ConvertFromURL, 'ConvertFromURL', cdRegister);
 S.RegisterDelphiFunction(@RGB, 'OORGB', cdRegister);
 S.RegisterDelphiFunction(@ALCopyStr2, 'ALCopyStr2', cdRegister);
 S.RegisterDelphiFunction(@EnDeCrypt, 'EnDeCrypt', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALOpenOffice(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALOpenOfficeException) do
end;

 
 
{ TPSImport_ALOpenOffice }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALOpenOffice.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALOpenOffice(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALOpenOffice.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALOpenOffice(ri);
  RIRegister_ALOpenOffice_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
