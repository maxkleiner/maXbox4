unit uPSI_xmlutil;
{
for webservice by max
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
  TPSImport_xmlutil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xmlutil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xmlutil_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // xmldom
  xmlutil_max
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xmlutil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xmlutil(CL: TPSPascalCompiler);
begin
  //IDOMNode = interface;
  //CL.AddTypeS('IDOMNode','interface');
{ CL.AddDelphiFunction('Function SelectNode( Node : IDOMNode; Path : string) : IDOMNode');
 CL.AddDelphiFunction('Function SelectCreateNode( Node : IDOMNode; Path : string; var attrs : string) : IDOMNode');
 CL.AddDelphiFunction('Function SelectCreateSibling( Node : IDOMNode; CloneNode : IDOMNode) : IDOMNode');
 CL.AddDelphiFunction('Function NextCreateElement( El : IDOMNode; tag : string; var attr : string) : IDOMNode');
 CL.AddDelphiFunction('Function FindNode( CurrEl : IDOMNode; currtag : Integer; tags : TStrings) : IDOMNode');
 CL.AddDelphiFunction('Procedure PutValue( Node : IDOMNode; Path : string; value : string)');}
 CL.AddDelphiFunction('Function MapValues( Mapping : string; Value : string) : string');
 CL.AddDelphiFunction('Function MakeValueMap( Enumeration : string; ToCds : Boolean) : string');
 CL.AddDelphiFunction('Function MapDateTime( const DateFormatType : string; DateFormat : string; Value : string; ToCds : Boolean) : string');
 CL.AddDelphiFunction('Function XmlDateTimeToStr( const XmlDateTime : string; const Format : string) : string');
 CL.AddDelphiFunction('Function XmlTimeToStr( const XmlTime : string; const Format : string) : string');
 CL.AddDelphiFunction('Function StrToXmlDate( const DateStr : string; const Format : string) : string');
 CL.AddDelphiFunction('Function StrToXmlDateTime( const DateStr : string; const Format : string) : string');
 CL.AddDelphiFunction('Function StrToXmlTime( const TimeStr : string; const Format : string) : string');
 CL.AddDelphiFunction('Function getIndex_Attrs( tag : string; var idx : Integer; var Attrs : string) : string');
 {CL.AddDelphiFunction('Procedure SetEncoding( Doc : IDOMDocument; Encoding : string; OverWrite : Boolean)');
 CL.AddDelphiFunction('Function GetEncoding( Doc : IDOMDocument) : string');
 CL.AddDelphiFunction('Procedure SetStandalone( Doc : IDOMDocument; value : string)');
 CL.AddDelphiFunction('Function LoadDocFromFile( const XMLFile : string) : IDOMDocument');
 CL.AddDelphiFunction('Function LoadDocFromString( const XMLStr : string) : IDOMDocument');
 CL.AddDelphiFunction('Function CloneDoc( Doc : IDOMDocument) : IDOMDocument');
 CL.AddDelphiFunction('Function GetAttribute( Node : IDOMNode; const name : string) : string'); }
 CL.AddDelphiFunction('Function Split0( Str : string; const substr : string) : TStringList');
 CL.AddDelphiFunction('Function Head( s : string; const subs : string; var tail : string) : string');
 //CL.AddDelphiFunction('Function CloneNodeToDoc( const SourceNode : IDOMNode; const TargetDoc : IDOMDocument; Deep : Boolean) : IDOMNode');}
  CL.AddClassN(CL.FindClass('TOBJECT'),'DomException');
 CL.AddConstantN('mx_Root','String').SetString( 'XmlTransformation');
 CL.AddConstantN('mx_Transform','String').SetString( 'Transform');
 CL.AddConstantN('mx_Skeleton','String').SetString( 'Skeleton');
 CL.AddConstantN('mx_TranslateEach','String').SetString( 'SelectEach');
 CL.AddConstantN('mx_Translate','String').SetString( 'Select');
 CL.AddConstantN('mx_XmlSchema','String').SetString( 'XmlSchema');
 CL.AddConstantN('mx_CdsSkeleton','String').SetString( 'CdsSkeleton');
 CL.AddConstantN('mx_XmlSkeleton','String').SetString( 'XmlSkeleton');
 CL.AddConstantN('mx_XSLTransform','String').SetString( 'XslTransform');
 CL.AddConstantN('mx_Version','String').SetString( 'Version');
 CL.AddConstantN('mx_CurrVersion','String').SetString( '1.0');
 CL.AddConstantN('mx_RootName','String').SetString( 'RootName');
 CL.AddConstantN('mx_DataEncoding','String').SetString( 'DataEncoding');
 CL.AddConstantN('mx_Direction','String').SetString( 'Direction');
 CL.AddConstantN('mx_ToXml','String').SetString( 'ToXml');
 CL.AddConstantN('mx_ToCds','String').SetString( 'ToCds');
 CL.AddConstantN('mx_ID','String').SetString( 'id');
 CL.AddConstantN('mx_DEFAULT','String').SetString( 'Default');
 CL.AddConstantN('mx_VALUE','String').SetString( 'value');
 CL.AddConstantN('mx_OPTIONS','String').SetString( 'Options');
 CL.AddConstantN('mx_MAPVALUES','String').SetString( 'Map_Values');
 CL.AddConstantN('mx_BOOLFORMAT','String').SetString( 'Format_Bool');
 CL.AddConstantN('mx_OPTIONAL','String').SetString( 'Optional');
 CL.AddConstantN('mx_DEST','String').SetString( 'dest');
 CL.AddConstantN('mx_FROM','String').SetString( 'from');
 CL.AddConstantN('mx_DATETIMEFORMAT','String').SetString( 'Format_DateTime');
 CL.AddConstantN('mx_DATEFORMAT','String').SetString( 'Format_Date');
 CL.AddConstantN('mx_TIMEFORMAT','String').SetString( 'Format_Time');
 CL.AddConstantN('mx_Datapacket','String').SetString( 'DATAPACKET');
 CL.AddConstantN('mx_ROWDATA','String').SetString( 'ROWDATA');
 CL.AddConstantN('mx_ROW','String').SetString( 'ROW');
 CL.AddConstantN('mx_RowState','String').SetString( 'RowState');
 CL.AddConstantN('val_DateTimeDefault','String').SetString( 'Default Format');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xmlutil_Routines(S: TPSExec);
begin
 {S.RegisterDelphiFunction(@SelectNode, 'SelectNode', cdRegister);
 S.RegisterDelphiFunction(@SelectCreateNode, 'SelectCreateNode', cdRegister);
 S.RegisterDelphiFunction(@SelectCreateSibling, 'SelectCreateSibling', cdRegister);
 S.RegisterDelphiFunction(@NextCreateElement, 'NextCreateElement', cdRegister);
 S.RegisterDelphiFunction(@FindNode, 'FindNode', cdRegister);
 S.RegisterDelphiFunction(@PutValue, 'PutValue', cdRegister);}
 S.RegisterDelphiFunction(@MapValues, 'MapValues', cdRegister);
 S.RegisterDelphiFunction(@MakeValueMap, 'MakeValueMap', cdRegister);
 S.RegisterDelphiFunction(@MapDateTime, 'MapDateTime', cdRegister);
 S.RegisterDelphiFunction(@XmlDateTimeToStr, 'XmlDateTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@XmlTimeToStr, 'XmlTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToXmlDate, 'StrToXmlDate', cdRegister);
 S.RegisterDelphiFunction(@StrToXmlDateTime, 'StrToXmlDateTime', cdRegister);
 S.RegisterDelphiFunction(@StrToXmlTime, 'StrToXmlTime', cdRegister);
 S.RegisterDelphiFunction(@getIndex_Attrs, 'getIndex_Attrs', cdRegister);
 {S.RegisterDelphiFunction(@SetEncoding, 'SetEncoding', cdRegister);
 S.RegisterDelphiFunction(@GetEncoding, 'GetEncoding', cdRegister);
 S.RegisterDelphiFunction(@SetStandalone, 'SetStandalone', cdRegister);
 S.RegisterDelphiFunction(@LoadDocFromFile, 'LoadDocFromFile', cdRegister);
 S.RegisterDelphiFunction(@LoadDocFromString, 'LoadDocFromString', cdRegister);
 S.RegisterDelphiFunction(@CloneDoc, 'CloneDoc', cdRegister); }
 //S.RegisterDelphiFunction(@GetAttribute, 'GetAttribute', cdRegister);
 S.RegisterDelphiFunction(@Split0, 'Split0', cdRegister);
 S.RegisterDelphiFunction(@Head, 'Head', cdRegister);
 //S.RegisterDelphiFunction(@CloneNodeToDoc, 'CloneNodeToDoc', cdRegister);
  //with CL.Add(DomException) do
end;

 
 
{ TPSImport_xmlutil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xmlutil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xmlutil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xmlutil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xmlutil(ri);
  RIRegister_xmlutil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
