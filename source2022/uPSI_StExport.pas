unit uPSI_StExport;
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
  TPSImport_StExport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStDbSchemaGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TStDBtoCSVExport(CL: TPSPascalCompiler);
procedure SIRegister_StExport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStDbSchemaGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStDBtoCSVExport(CL: TPSRuntimeClassImporter);
procedure RIRegister_StExport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,DB
  ,DbConsts
  ,StBase
  ,StStrms
  ,StTxtDat
  ,StExport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StExport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDbSchemaGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStDbSchemaGenerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStDbSchemaGenerator') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure ExportToStream( AStream : TStream)');
    RegisterMethod('Procedure ExportToFile( AFile : TFileName)');
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('FieldDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('QuoteDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('SchemaName', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDBtoCSVExport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStDBtoCSVExport') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStDBtoCSVExport') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
      RegisterMethod('Procedure DoQuote( var Value : AnsiString)');
    RegisterMethod('Procedure ExportToStream( AStream : TStream)');
    RegisterMethod('Procedure ExportToFile( AFile : TFileName)');
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('FieldDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('IncludeHeader', 'Boolean', iptrw);
    RegisterProperty('LineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('LineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('QuoteAlways', 'Boolean', iptrw);
    RegisterProperty('QuoteDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('QuoteIfSpaces', 'Boolean', iptrw);
    RegisterProperty('DateFmt', 'AnsiString', iptrw);
    RegisterProperty('TimeFmt', 'AnsiString', iptrw);
    RegisterProperty('DateTimeFmt', 'AnsiString', iptrw);
    RegisterProperty('OnQuoteField', 'TStOnQuoteFieldEvent', iptrw);
    RegisterProperty('OnExportProgress', 'TStExportProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StExport(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefaultDateFmt','AnsiString').SetString( 'mm/dd/yyyy');
 CL.AddConstantN('DefaultTimeFmt','AnsiString').SetString( 'hh:mm:ss');
 CL.AddConstantN('DefaultDateTimeFmt','AnsiString').SetString( 'mm/dd/yyyy hh:mm:ss');
  CL.AddTypeS('TStExportProgressEvent', 'Procedure ( Sender : TObject; Index : '
   +'Integer; var Abort : Boolean)');
  SIRegister_TStDBtoCSVExport(CL);
  SIRegister_TStDbSchemaGenerator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorSchemaName_W(Self: TStDbSchemaGenerator; const T: AnsiString);
begin Self.SchemaName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorSchemaName_R(Self: TStDbSchemaGenerator; var T: AnsiString);
begin T := Self.SchemaName; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorQuoteDelimiter_W(Self: TStDbSchemaGenerator; const T: AnsiChar);
begin Self.QuoteDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorQuoteDelimiter_R(Self: TStDbSchemaGenerator; var T: AnsiChar);
begin T := Self.QuoteDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorFieldDelimiter_W(Self: TStDbSchemaGenerator; const T: AnsiChar);
begin Self.FieldDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorFieldDelimiter_R(Self: TStDbSchemaGenerator; var T: AnsiChar);
begin T := Self.FieldDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorDataSet_W(Self: TStDbSchemaGenerator; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDbSchemaGeneratorDataSet_R(Self: TStDbSchemaGenerator; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportOnExportProgress_W(Self: TStDBtoCSVExport; const T: TStExportProgressEvent);
begin Self.OnExportProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportOnExportProgress_R(Self: TStDBtoCSVExport; var T: TStExportProgressEvent);
begin T := Self.OnExportProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportOnQuoteField_W(Self: TStDBtoCSVExport; const T: TStOnQuoteFieldEvent);
begin Self.OnQuoteField := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportOnQuoteField_R(Self: TStDBtoCSVExport; var T: TStOnQuoteFieldEvent);
begin T := Self.OnQuoteField; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDateTimeFmt_W(Self: TStDBtoCSVExport; const T: AnsiString);
begin Self.DateTimeFmt := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDateTimeFmt_R(Self: TStDBtoCSVExport; var T: AnsiString);
begin T := Self.DateTimeFmt; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportTimeFmt_W(Self: TStDBtoCSVExport; const T: AnsiString);
begin Self.TimeFmt := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportTimeFmt_R(Self: TStDBtoCSVExport; var T: AnsiString);
begin T := Self.TimeFmt; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDateFmt_W(Self: TStDBtoCSVExport; const T: AnsiString);
begin Self.DateFmt := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDateFmt_R(Self: TStDBtoCSVExport; var T: AnsiString);
begin T := Self.DateFmt; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteIfSpaces_W(Self: TStDBtoCSVExport; const T: Boolean);
begin Self.QuoteIfSpaces := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteIfSpaces_R(Self: TStDBtoCSVExport; var T: Boolean);
begin T := Self.QuoteIfSpaces; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteDelimiter_W(Self: TStDBtoCSVExport; const T: AnsiChar);
begin Self.QuoteDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteDelimiter_R(Self: TStDBtoCSVExport; var T: AnsiChar);
begin T := Self.QuoteDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteAlways_W(Self: TStDBtoCSVExport; const T: Boolean);
begin Self.QuoteAlways := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportQuoteAlways_R(Self: TStDBtoCSVExport; var T: Boolean);
begin T := Self.QuoteAlways; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportLineTerminator_W(Self: TStDBtoCSVExport; const T: TStLineTerminator);
begin Self.LineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportLineTerminator_R(Self: TStDBtoCSVExport; var T: TStLineTerminator);
begin T := Self.LineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportLineTermChar_W(Self: TStDBtoCSVExport; const T: AnsiChar);
begin Self.LineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportLineTermChar_R(Self: TStDBtoCSVExport; var T: AnsiChar);
begin T := Self.LineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportIncludeHeader_W(Self: TStDBtoCSVExport; const T: Boolean);
begin Self.IncludeHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportIncludeHeader_R(Self: TStDBtoCSVExport; var T: Boolean);
begin T := Self.IncludeHeader; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportFieldDelimiter_W(Self: TStDBtoCSVExport; const T: AnsiChar);
begin Self.FieldDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportFieldDelimiter_R(Self: TStDBtoCSVExport; var T: AnsiChar);
begin T := Self.FieldDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDataSet_W(Self: TStDBtoCSVExport; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDBtoCSVExportDataSet_R(Self: TStDBtoCSVExport; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDbSchemaGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDbSchemaGenerator) do begin
    RegisterConstructor(@TStDbSchemaGenerator.Create, 'Create');
    RegisterMethod(@TStDbSchemaGenerator.Destroy, 'Free');
   RegisterMethod(@TStDbSchemaGenerator.ExportToStream, 'ExportToStream');
    RegisterMethod(@TStDbSchemaGenerator.ExportToFile, 'ExportToFile');
    RegisterPropertyHelper(@TStDbSchemaGeneratorDataSet_R,@TStDbSchemaGeneratorDataSet_W,'DataSet');
    RegisterPropertyHelper(@TStDbSchemaGeneratorFieldDelimiter_R,@TStDbSchemaGeneratorFieldDelimiter_W,'FieldDelimiter');
    RegisterPropertyHelper(@TStDbSchemaGeneratorQuoteDelimiter_R,@TStDbSchemaGeneratorQuoteDelimiter_W,'QuoteDelimiter');
    RegisterPropertyHelper(@TStDbSchemaGeneratorSchemaName_R,@TStDbSchemaGeneratorSchemaName_W,'SchemaName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDBtoCSVExport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDBtoCSVExport) do begin
    RegisterConstructor(@TStDBtoCSVExport.Create, 'Create');
     RegisterMethod(@TStDBtoCSVExport.Destroy, 'Free');
    RegisterVirtualMethod(@TStDBtoCSVExport.DoQuote, 'DoQuote');
    RegisterMethod(@TStDBtoCSVExport.ExportToStream, 'ExportToStream');
    RegisterMethod(@TStDBtoCSVExport.ExportToFile, 'ExportToFile');
    RegisterPropertyHelper(@TStDBtoCSVExportDataSet_R,@TStDBtoCSVExportDataSet_W,'DataSet');
    RegisterPropertyHelper(@TStDBtoCSVExportFieldDelimiter_R,@TStDBtoCSVExportFieldDelimiter_W,'FieldDelimiter');
    RegisterPropertyHelper(@TStDBtoCSVExportIncludeHeader_R,@TStDBtoCSVExportIncludeHeader_W,'IncludeHeader');
    RegisterPropertyHelper(@TStDBtoCSVExportLineTermChar_R,@TStDBtoCSVExportLineTermChar_W,'LineTermChar');
    RegisterPropertyHelper(@TStDBtoCSVExportLineTerminator_R,@TStDBtoCSVExportLineTerminator_W,'LineTerminator');
    RegisterPropertyHelper(@TStDBtoCSVExportQuoteAlways_R,@TStDBtoCSVExportQuoteAlways_W,'QuoteAlways');
    RegisterPropertyHelper(@TStDBtoCSVExportQuoteDelimiter_R,@TStDBtoCSVExportQuoteDelimiter_W,'QuoteDelimiter');
    RegisterPropertyHelper(@TStDBtoCSVExportQuoteIfSpaces_R,@TStDBtoCSVExportQuoteIfSpaces_W,'QuoteIfSpaces');
    RegisterPropertyHelper(@TStDBtoCSVExportDateFmt_R,@TStDBtoCSVExportDateFmt_W,'DateFmt');
    RegisterPropertyHelper(@TStDBtoCSVExportTimeFmt_R,@TStDBtoCSVExportTimeFmt_W,'TimeFmt');
    RegisterPropertyHelper(@TStDBtoCSVExportDateTimeFmt_R,@TStDBtoCSVExportDateTimeFmt_W,'DateTimeFmt');
    RegisterPropertyHelper(@TStDBtoCSVExportOnQuoteField_R,@TStDBtoCSVExportOnQuoteField_W,'OnQuoteField');
    RegisterPropertyHelper(@TStDBtoCSVExportOnExportProgress_R,@TStDBtoCSVExportOnExportProgress_W,'OnExportProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StExport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDBtoCSVExport(CL);
  RIRegister_TStDbSchemaGenerator(CL);
end;

 
 
{ TPSImport_StExport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StExport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StExport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
