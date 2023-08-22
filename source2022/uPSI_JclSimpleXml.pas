unit uPSI_JclSimpleXml;
{
   it was a change to   Florent Ouchet (move from the JVCL to the JCL).
   checked virtualconstructor     - add header loadfromn
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
  TPSImport_JclSimpleXml = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXMLVariant(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXML(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemMSOApplication(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemSheet(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemDocType(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemHeader(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemText(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemCData(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemClassic(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemComment(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElem(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElems(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLNamedElems(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLElemsProlog(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLProps(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleXMLProp(CL: TPSPascalCompiler);
procedure SIRegister_JclSimpleXml(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclSimpleXml_Routines(S: TPSExec);
procedure RIRegister_TXMLVariant(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXML(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemMSOApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemSheet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemDocType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemCData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemClassic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemComment(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLNamedElems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLElemsProlog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLProps(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleXMLProp(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclSimpleXml(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  JclUnitVersioning
  Windows
  ,Variants
  ,IniFiles
  ,JclBase
  //,JclStreams
  ,JclSimpleXml
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSimpleXml]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLVariant(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInvokeableVariantType', 'TXMLVariant') do
  with CL.AddClassN(CL.FindClass('TInvokeableVariantType'),'TXMLVariant') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXML') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXML') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromString( const Value : string)');
    //RegisterMethod('Procedure LoadFromFile( const FileName : TFileName; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Procedure LoadFromFile( const FileName : TFileName)');
    //RegisterMethod('Procedure LoadFromStream( Stream : TStream; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream;)');
    //RegisterMethod('Procedure LoadFromStringStream( StringStream : TJclStringStream)');
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : string; Encoding : TJclStringEncoding; CodePage : Word)');
   // RegisterMethod('Procedure SaveToFile( const FileName : TFileName; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Procedure SaveToFile(const FileName : TFileName;)');
    //RegisterMethod('Procedure SaveToStream( Stream : TStream; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    //RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream)');
    RegisterMethod('Function SaveToString : string');

  //    procedure LoadFromString(const Value: string);
    {procedure LoadFromFile(const FileName: TFileName);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromResourceName(Instance: THandle; const ResName: string);
    procedure SaveToFile(FileName: TFileName);
    procedure SaveToStream(Stream: TStream);
    function SaveToString: string;}

    RegisterProperty('Prolog', 'TJclSimpleXMLElemsProlog', iptrw);
    RegisterProperty('Root', 'TJclSimpleXMLElemClassic', iptrw);
    RegisterProperty('XMLData', 'string', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('IndentString', 'string', iptrw);
    RegisterProperty('Options', 'TJclSimpleXMLOptions', iptrw);
    RegisterProperty('OnSaveProgress', 'TJclOnSimpleProgress', iptrw);
    RegisterProperty('OnLoadProgress', 'TJclOnSimpleProgress', iptrw);
    RegisterProperty('OnTagParsed', 'TJclOnSimpleXMLParsed', iptrw);
    RegisterProperty('OnValueParsed', 'TJclOnValueParsed', iptrw);
    RegisterProperty('OnEncodeValue', 'TJclSimpleXMLEncodeEvent', iptrw);
    RegisterProperty('OnDecodeValue', 'TJclSimpleXMLEncodeEvent', iptrw);
    RegisterProperty('OnEncodeStream', 'TJclSimpleXMLEncodeStreamEvent', iptrw);
    RegisterProperty('OnDecodeStream', 'TJclSimpleXMLEncodeStreamEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemMSOApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemMSOApplication') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemMSOApplication') do begin
     RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemSheet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemSheet') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemSheet') do begin
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemDocType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemDocType') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemDocType') do begin
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemHeader') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemHeader') do begin
    RegisterProperty('Version', 'string', iptrw);
    RegisterProperty('StandAlone', 'Boolean', iptrw);
    RegisterProperty('Encoding', 'string', iptrw);
   RegisterMethod('Constructor Create(const AOwner: TJclSimpleXMLElem)');
      RegisterMethod('Procedure Assign(Value: TJclSimpleXMLElem)');
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemText') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemText') do begin
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemCData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemCData') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemCData') do begin
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemClassic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemClassic') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemClassic') do begin
     RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemComment(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXMLElem', 'TJclSimpleXMLElemComment') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXMLElem'),'TJclSimpleXMLElemComment') do begin
    RegisterMethod('procedure LoadFromStream(const Stream: TStream; AParent: TJclSimpleXML');
    RegisterMethod('procedure SaveToStream(const Stream: TStream; const Level: string; AParent: TJclSimpleXML);');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLElem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLElem') do begin
    RegisterMethod('Constructor Create( const AOwner : TJclSimpleXMLElem)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Value : TJclSimpleXMLElem)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure LoadFromStringStream( StringStream : TJclStringStream; AParent : TJclSimpleXML)');
    RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream; const Level : string; AParent : TJclSimpleXML)');
    RegisterMethod('Procedure LoadFromString( const Value : string)');
    RegisterMethod('Function SaveToString : string');
    RegisterMethod('Procedure GetBinaryValue( Stream : TStream)');
    RegisterProperty('Data', 'TObject', iptrw);
    RegisterMethod('Function GetChildIndex( const AChild : TJclSimpleXMLElem) : Integer');
    RegisterMethod('Function GetNamedIndex( const AChild : TJclSimpleXMLElem) : Integer');
    RegisterProperty('SimpleXML', 'TJclSimpleXML', iptr);
    RegisterProperty('Container', 'TJclSimpleXMLElems', iptrw);
    RegisterMethod('Function FullName : string');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Parent', 'TJclSimpleXMLElem', iptrw);
    RegisterProperty('NameSpace', 'string', iptrw);
    RegisterProperty('ChildsCount', 'Integer', iptr);
    RegisterProperty('Items', 'TJclSimpleXMLElems', iptr);
    RegisterProperty('Properties', 'TJclSimpleXMLProps', iptr);
    RegisterProperty('IntValue', 'Int64', iptrw);
    RegisterProperty('BoolValue', 'Boolean', iptrw);
    RegisterProperty('FloatValue', 'Extended', iptrw);
    RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('AnsiValue', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLElems') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLElems') do begin
    RegisterMethod('Constructor Create( const AOwner : TJclSimpleXMLElem)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Notify( Value : TJclSimpleXMLElem; Operation : TOperation)');
    RegisterMethod('Function Add( const Name : string) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function Add1( const Name, Value : string) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function Add2( const Name : string; const Value : Int64) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function Add3( const Name : string; const Value : Boolean) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function Add4( const Name : string; Value : TStream) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function Add5( Value : TJclSimpleXMLElem) : TJclSimpleXMLElem;');
    RegisterMethod('Function AddFirst( Value : TJclSimpleXMLElem) : TJclSimpleXMLElem;');
    RegisterMethod('Function AddFirst1( const Name : string) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Function AddComment( const Name : string; const Value : string) : TJclSimpleXMLElemComment');
    RegisterMethod('Function AddCData( const Name : string; const Value : string) : TJclSimpleXMLElemCData');
    RegisterMethod('Function AddText( const Name : string; const Value : string) : TJclSimpleXMLElemText');
    RegisterMethod('Function Insert( Value : TJclSimpleXMLElem; Index : Integer) : TJclSimpleXMLElem;');
    RegisterMethod('Function Insert1( const Name : string; Index : Integer) : TJclSimpleXMLElemClassic;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( const Index : Integer);');
    RegisterMethod('Procedure Delete1( const Name : string);');
    RegisterMethod('Function Remove( Value : TJclSimpleXMLElem) : Integer');
    RegisterMethod('Procedure Move( const CurIndex, NewIndex : Integer)');
    RegisterMethod('Function IndexOf( const Value : TJclSimpleXMLElem) : Integer;');
    RegisterMethod('Function IndexOf1( const Name : string) : Integer;');
    RegisterMethod('Function Value( const Name : string; const Default : string) : string');
    RegisterMethod('Function IntValue( const Name : string; const Default : Int64) : Int64');
    RegisterMethod('Function FloatValue( const Name : string; const Default : Extended) : Extended');
    RegisterMethod('Function BoolValue( const Name : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure BinaryValue( const Name : string; Stream : TStream)');
    RegisterMethod('Procedure LoadFromStringStream( StringStream : TJclStringStream; AParent : TJclSimpleXML)');
    RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream; const Level : string; AParent : TJclSimpleXML)');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure CustomSort( AFunction : TJclSimpleXMLElemCompare)');
    RegisterProperty('Parent', 'TJclSimpleXMLElem', iptrw);
    RegisterProperty('Item', 'TJclSimpleXMLElem Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('ItemNamed', 'TJclSimpleXMLElem string', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('NamedElems', 'TJclSimpleXMLNamedElems string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLNamedElems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLNamedElems') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLNamedElems') do begin
    RegisterMethod('Constructor Create( const AOwner : TJClSimpleXMLElems; const AName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add : TJclSimpleXmlElemClassic;');
    RegisterMethod('Function Add1( const Value : string) : TJclSimpleXmlElemClassic;');
    RegisterMethod('Function Add2( const Value : Int64) : TJclSimpleXmlElemClassic;');
    RegisterMethod('Function Add3( const Value : Boolean) : TJclSimpleXmlElemClassic;');
    RegisterMethod('Function Add4( Value : TStream) : TJclSimpleXmlElemClassic;');
    RegisterMethod('Function AddFirst : TJclSimpleXmlElemClassic');
    RegisterMethod('Function AddComment( const Value : string) : TJclSimpleXMLElemComment');
    RegisterMethod('Function AddCData( const Value : string) : TJclSimpleXMLElemCData');
    RegisterMethod('Function AddText( const Value : string) : TJclSimpleXMLElemText');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( const Index : Integer)');
    RegisterMethod('Procedure Move( const CurIndex, NewIndex : Integer)');
    RegisterMethod('Function IndexOf( const Value : TJclSimpleXMLElem) : Integer;');
    RegisterMethod('Function IndexOf1( const Value : string) : Integer;');
    RegisterProperty('Elems', 'TJclSimpleXMLElems', iptr);
    RegisterProperty('Item', 'TJclSimpleXMLElem Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Name', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLElemsProlog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLElemsProlog') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLElemsProlog') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function AddComment( const AValue : string) : TJclSimpleXMLElemComment');
    RegisterMethod('Function AddDocType( const AValue : string) : TJclSimpleXMLElemDocType');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function AddStyleSheet( const AType, AHRef : string) : TJclSimpleXMLElemSheet');
    RegisterMethod('Function AddMSOApplication( const AProgId : string) : TJclSimpleXMLElemMSOApplication');
    RegisterMethod('Procedure LoadFromStringStream( StringStream : TJclStringStream; AParent : TJclSimpleXML)');
    RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream; AParent : TJclSimpleXML)');
    RegisterProperty('Item', 'TJclSimpleXMLElem Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Encoding', 'string', iptrw);
    RegisterProperty('StandAlone', 'Boolean', iptrw);
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLProps(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLProps') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLProps') do begin
    RegisterMethod('Constructor Create( Parent : TJclSimpleXMLElem)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( const Name, Value : string) : TJclSimpleXMLProp;');
    RegisterMethod('Function Add1( const Name : string; const Value : AnsiString) : TJclSimpleXMLProp;');
    RegisterMethod('Function Add( const Name : string; const Value : Int64) : TJclSimpleXMLProp;');
    RegisterMethod('Function Add2( const Name : string; const Value : Boolean) : TJclSimpleXMLProp;');
    RegisterMethod('Function Insert( const Index : Integer; const Name, Value : string) : TJclSimpleXMLProp;');
    RegisterMethod('Function Insert1( const Index : Integer; const Name : string; const Value : Int64) : TJclSimpleXMLProp;');
    RegisterMethod('Function Insert2( const Index : Integer; const Name : string; const Value : Boolean) : TJclSimpleXMLProp;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( const Index : Integer);');
    RegisterMethod('Procedure Delete1( const Name : string);');
    RegisterMethod('Function Value( const Name : string; const Default : string) : string');
    RegisterMethod('Function IntValue( const Name : string; const Default : Int64) : Int64');
    RegisterMethod('Function BoolValue( const Name : string; Default : Boolean) : Boolean');
    RegisterMethod('Function FloatValue( const Name : string; const Default : Extended) : Extended');
    RegisterMethod('Procedure LoadFromStringStream( StringStream : TJclStringStream)');
    RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream)');
    RegisterProperty('Item', 'TJclSimpleXMLProp Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('ItemNamed', 'TJclSimpleXMLProp string', iptr);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleXMLProp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleXMLProp') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleXMLProp') do begin
    RegisterMethod('Function GetSimpleXML : TJclSimpleXML');
    RegisterMethod('Procedure SaveToStringStream( StringStream : TJclStringStream)');
    RegisterMethod('Function FullName : string');
    RegisterProperty('Parent', 'TJclSimpleXMLProps', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('AnsiValue', 'AnsiString', iptrw);
    RegisterProperty('IntValue', 'Int64', iptrw);
    RegisterProperty('BoolValue', 'Boolean', iptrw);
    RegisterProperty('FloatValue', 'Extended', iptrw);
    RegisterProperty('NameSpace', 'string', iptrw);
    RegisterProperty('Data', 'Pointer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSimpleXml(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXML');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclSimpleXMLError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElems');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLProps');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemComment');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemClassic');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemCData');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemDocType');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemText');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemHeader');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemSheet');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSimpleXMLElemMSOApplication');
  CL.AddTypeS('TJclOnSimpleXMLParsed', 'Procedure ( Sender : TObject; const Name: string)');
  CL.AddTypeS('TJclOnValueParsed', 'Procedure ( Sender : TObject; const Name, Value: string)');
  CL.AddTypeS('TJclOnSimpleProgress', 'Procedure ( Sender : TObject; const Position, Total : Integer)');
  CL.AddTypeS('TJclHashKind', '( hkList, hkDirect )');
   CL.AddTypeS('TJclStringEncoding','(seAnsi,seUTF8,seUTF16,seAuto)');

 // CL.AddTypeS('PJclHashElem', '^TJclHashElem // will not work');
 // CL.AddTypeS('TJclHashElem', 'record Next : PJclHashElem; Obj : TObject; end');
 // CL.AddTypeS('PJclHashRecord', '^TJclHashRecord // will not work');
 // CL.AddTypeS('PJclHashList', '^TJclHashList // will not work');
  CL.AddTypeS('TJclHashRecord', 'record Count : Byte; end');
  SIRegister_TJclSimpleXMLProp(CL);
  SIRegister_TJclSimpleXMLProps(CL);
  SIRegister_TJclSimpleXMLElemsProlog(CL);
  SIRegister_TJclSimpleXMLNamedElems(CL);
  CL.AddTypeS('TJclSimpleXMLElemCompare', 'Function (Elems: TJclSimpleXMLElems; Index1, Index2 : Integer) : Integer');
  SIRegister_TJclSimpleXMLElems(CL);
  SIRegister_TJclSimpleXMLElem(CL);
  //CL.AddTypeS('TJclSimpleXMLElemClass', 'class of TJclSimpleXMLElem');
  SIRegister_TJclSimpleXMLElemComment(CL);
  SIRegister_TJclSimpleXMLElemClassic(CL);
  SIRegister_TJclSimpleXMLElemCData(CL);
  SIRegister_TJclSimpleXMLElemText(CL);
  SIRegister_TJclSimpleXMLElemHeader(CL);
  SIRegister_TJclSimpleXMLElemDocType(CL);
  SIRegister_TJclSimpleXMLElemSheet(CL);
  SIRegister_TJclSimpleXMLElemMSOApplication(CL);
  CL.AddTypeS('TJclSimpleXMLOptions', '( sxoAutoCreate, sxoAutoIndent, s'
   +'xoAutoEncodeValue, sxoAutoEncodeEntity, sxoDoNotSaveProlog, sxoTrimPrecedingTextWhitespace )');
  CL.AddTypeS('TJclSimpleXMLEncodeEvent', 'Procedure ( Sender : TObject; var Value: string)');
  CL.AddTypeS('TJclSimpleXMLEncodeStreamEvent', 'Procedure ( Sender : TObject; InStream, OutStream : TStream)');
  SIRegister_TJclSimpleXML(CL);
  SIRegister_TJclSimpleXMLElemHeader(CL);
  SIRegister_TXMLVariant(CL);
 CL.AddDelphiFunction('Procedure XMLCreateInto( var ADest : Variant; const AXML : TJclSimpleXMLElem)');
 CL.AddDelphiFunction('Function XMLCreate( const AXML : TJclSimpleXMLElem) : Variant;');
 CL.AddDelphiFunction('Function XMLCreate1 : Variant;');
 CL.AddDelphiFunction('Function VarXML : TVarType');
 CL.AddDelphiFunction('Function SimpleXMLEncode( const S : string) : string');
 CL.AddDelphiFunction('Procedure SimpleXMLDecode( var S : string; TrimBlanks : Boolean)');
 CL.AddDelphiFunction('Function XMLEncode( const S : string) : string');
 CL.AddDelphiFunction('Function XMLDecode( const S : string) : string');
 CL.AddDelphiFunction('Function EntityEncode( const S : string) : string');
 CL.AddDelphiFunction('Function EntityDecode( const S : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function XMLCreate1_P : Variant;
Begin //Result := JclSimpleXml.XMLCreate;
 END;

(*----------------------------------------------------------------------------*)
Function XMLCreate_P( const AXML : TJclSimpleXMLElem) : Variant;
Begin //Result := JclSimpleXml.XMLCreate(AXML);
 END;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnDecodeStream_W(Self: TJclSimpleXML; const T: TJclSimpleXMLEncodeStreamEvent);
begin Self.OnDecodeStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnDecodeStream_R(Self: TJclSimpleXML; var T: TJclSimpleXMLEncodeStreamEvent);
begin T := Self.OnDecodeStream; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnEncodeStream_W(Self: TJclSimpleXML; const T: TJclSimpleXMLEncodeStreamEvent);
begin Self.OnEncodeStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnEncodeStream_R(Self: TJclSimpleXML; var T: TJclSimpleXMLEncodeStreamEvent);
begin T := Self.OnEncodeStream; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnDecodeValue_W(Self: TJclSimpleXML; const T: TJclSimpleXMLEncodeEvent);
begin Self.OnDecodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnDecodeValue_R(Self: TJclSimpleXML; var T: TJclSimpleXMLEncodeEvent);
begin T := Self.OnDecodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnEncodeValue_W(Self: TJclSimpleXML; const T: TJclSimpleXMLEncodeEvent);
begin Self.OnEncodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnEncodeValue_R(Self: TJclSimpleXML; var T: TJclSimpleXMLEncodeEvent);
begin T := Self.OnEncodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnValueParsed_W(Self: TJclSimpleXML; const T: TJclOnValueParsed);
begin Self.OnValueParsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnValueParsed_R(Self: TJclSimpleXML; var T: TJclOnValueParsed);
begin T := Self.OnValueParsed; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnTagParsed_W(Self: TJclSimpleXML; const T: TJclOnSimpleXMLParsed);
begin Self.OnTagParsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnTagParsed_R(Self: TJclSimpleXML; var T: TJclOnSimpleXMLParsed);
begin T := Self.OnTagParsed; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnLoadProgress_W(Self: TJclSimpleXML; const T: TJclOnSimpleProgress);
begin Self.OnLoadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnLoadProgress_R(Self: TJclSimpleXML; var T: TJclOnSimpleProgress);
begin T := Self.OnLoadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnSaveProgress_W(Self: TJclSimpleXML; const T: TJclOnSimpleProgress);
begin Self.OnSaveProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOnSaveProgress_R(Self: TJclSimpleXML; var T: TJclOnSimpleProgress);
begin T := Self.OnSaveProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOptions_W(Self: TJclSimpleXML; const T: TJclSimpleXMLOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLOptions_R(Self: TJclSimpleXML; var T: TJclSimpleXMLOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLIndentString_W(Self: TJclSimpleXML; const T: string);
begin Self.IndentString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLIndentString_R(Self: TJclSimpleXML; var T: string);
begin T := Self.IndentString; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLFileName_W(Self: TJclSimpleXML; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLFileName_R(Self: TJclSimpleXML; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLXMLData_W(Self: TJclSimpleXML; const T: string);
begin Self.XMLData := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLXMLData_R(Self: TJclSimpleXML; var T: string);
begin T := Self.XMLData; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLRoot_W(Self: TJclSimpleXML; const T: TJclSimpleXMLElemClassic);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLRoot_R(Self: TJclSimpleXML; var T: TJclSimpleXMLElemClassic);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLProlog_W(Self: TJclSimpleXML; const T: TJclSimpleXMLElemsProlog);
begin Self.Prolog := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLProlog_R(Self: TJclSimpleXML; var T: TJclSimpleXMLElemsProlog);
begin T := Self.Prolog; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderEncoding_W(Self: TJclSimpleXMLElemHeader; const T: string);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderEncoding_R(Self: TJclSimpleXMLElemHeader; var T: string);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderStandAlone_W(Self: TJclSimpleXMLElemHeader; const T: Boolean);
begin Self.StandAlone := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderStandAlone_R(Self: TJclSimpleXMLElemHeader; var T: Boolean);
begin T := Self.StandAlone; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderVersion_W(Self: TJclSimpleXMLElemHeader; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemHeaderVersion_R(Self: TJclSimpleXMLElemHeader; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemAnsiValue_W(Self: TJclSimpleXMLElem; const T: AnsiString);
begin //Self.AnsiValue := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemAnsiValue_R(Self: TJclSimpleXMLElem; var T: AnsiString);
begin //T := //Self.AnsiValue;
 end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemValue_W(Self: TJclSimpleXMLElem; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemValue_R(Self: TJclSimpleXMLElem; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemFloatValue_W(Self: TJclSimpleXMLElem; const T: Extended);
begin Self.FloatValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemFloatValue_R(Self: TJclSimpleXMLElem; var T: Extended);
begin T := Self.FloatValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemBoolValue_W(Self: TJclSimpleXMLElem; const T: Boolean);
begin Self.BoolValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemBoolValue_R(Self: TJclSimpleXMLElem; var T: Boolean);
begin T := Self.BoolValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemIntValue_W(Self: TJclSimpleXMLElem; const T: Int64);
begin Self.IntValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemIntValue_R(Self: TJclSimpleXMLElem; var T: Int64);
begin T := Self.IntValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemProperties_R(Self: TJclSimpleXMLElem; var T: TJclSimpleXMLProps);
begin T := Self.Properties; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemItems_R(Self: TJclSimpleXMLElem; var T: TJclSimpleXMLElems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemChildsCount_R(Self: TJclSimpleXMLElem; var T: Integer);
begin T := Self.ChildsCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemNameSpace_W(Self: TJclSimpleXMLElem; const T: string);
begin Self.NameSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemNameSpace_R(Self: TJclSimpleXMLElem; var T: string);
begin T := Self.NameSpace; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemParent_W(Self: TJclSimpleXMLElem; const T: TJclSimpleXMLElem);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemParent_R(Self: TJclSimpleXMLElem; var T: TJclSimpleXMLElem);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemName_W(Self: TJclSimpleXMLElem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemName_R(Self: TJclSimpleXMLElem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemContainer_W(Self: TJclSimpleXMLElem; const T: TJclSimpleXMLElems);
begin Self.Container := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemContainer_R(Self: TJclSimpleXMLElem; var T: TJclSimpleXMLElems);
begin T := Self.Container; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemSimpleXML_R(Self: TJclSimpleXMLElem; var T: TJclSimpleXML);
begin T := Self.SimpleXML; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemData_W(Self: TJclSimpleXMLElem; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemData_R(Self: TJclSimpleXMLElem; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
//procedure TJclSimpleXMLElemsNamedElems_R(Self: TJclSimpleXMLElems; var T: TJclSimpleXMLNamedElems; const t1: string);
//begin T := Self.NamedElems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsCount_R(Self: TJclSimpleXMLElems; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsItemNamed_R(Self: TJclSimpleXMLElems; var T: TJclSimpleXMLElem; const t1: string);
begin T := Self.ItemNamed[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsItem_R(Self: TJclSimpleXMLElems; var T: TJclSimpleXMLElem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsParent_W(Self: TJclSimpleXMLElems; const T: TJclSimpleXMLElem);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsParent_R(Self: TJclSimpleXMLElems; var T: TJclSimpleXMLElem);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsIndexOf1_P(Self: TJclSimpleXMLElems;  const Name : string) : Integer;
Begin Result := Self.IndexOf(Name); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsIndexOf_P(Self: TJclSimpleXMLElems;  const Value : TJclSimpleXMLElem) : Integer;
Begin Result := Self.IndexOf(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleXMLElemsDelete1_P(Self: TJclSimpleXMLElems;  const Name : string);
Begin Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleXMLElemsDelete_P(Self: TJclSimpleXMLElems;  const Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsInsert1_P(Self: TJclSimpleXMLElems;  const Name : string; Index : Integer) : TJclSimpleXMLElemClassic;
Begin Result := Self.Insert(Name, Index); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsInsert_P(Self: TJclSimpleXMLElems;  Value : TJclSimpleXMLElem; Index : Integer) : TJclSimpleXMLElem;
Begin Result := Self.Insert(Value, Index); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAddFirst1_P(Self: TJclSimpleXMLElems;  const Name : string) : TJclSimpleXMLElemClassic;
Begin Result := Self.AddFirst(Name); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAddFirst_P(Self: TJclSimpleXMLElems;  Value : TJclSimpleXMLElem) : TJclSimpleXMLElem;
Begin Result := Self.AddFirst(Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd5_P(Self: TJclSimpleXMLElems;  Value : TJclSimpleXMLElem) : TJclSimpleXMLElem;
Begin Result := Self.Add(Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd4_P(Self: TJclSimpleXMLElems;  const Name : string; Value : TStream) : TJclSimpleXMLElemClassic;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd3_P(Self: TJclSimpleXMLElems;  const Name : string; const Value : Boolean) : TJclSimpleXMLElemClassic;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd2_P(Self: TJclSimpleXMLElems;  const Name : string; const Value : Int64) : TJclSimpleXMLElemClassic;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd1_P(Self: TJclSimpleXMLElems;  const Name, Value : string) : TJclSimpleXMLElemClassic;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLElemsAdd_P(Self: TJclSimpleXMLElems;  const Name : string) : TJclSimpleXMLElemClassic;
Begin Result := Self.Add(Name); END;


(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologVersion_W(Self: TJclSimpleXMLElemsProlog; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologVersion_R(Self: TJclSimpleXMLElemsProlog; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologStandAlone_W(Self: TJclSimpleXMLElemsProlog; const T: Boolean);
begin Self.StandAlone := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologStandAlone_R(Self: TJclSimpleXMLElemsProlog; var T: Boolean);
begin T := Self.StandAlone; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologEncoding_W(Self: TJclSimpleXMLElemsProlog; const T: string);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologEncoding_R(Self: TJclSimpleXMLElemsProlog; var T: string);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologCount_R(Self: TJclSimpleXMLElemsProlog; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLElemsPrologItem_R(Self: TJclSimpleXMLElemsProlog; var T: TJclSimpleXMLElem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropsCount_R(Self: TJclSimpleXMLProps; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropsItemNamed_R(Self: TJclSimpleXMLProps; var T: TJclSimpleXMLProp; const t1: string);
begin T := Self.ItemNamed[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropsItem_R(Self: TJclSimpleXMLProps; var T: TJclSimpleXMLProp; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleXMLPropsDelete1_P(Self: TJclSimpleXMLProps;  const Name : string);
Begin Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleXMLPropsDelete_P(Self: TJclSimpleXMLProps;  const Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsInsert2_P(Self: TJclSimpleXMLProps;  const Index : Integer; const Name : string; const Value : Boolean) : TJclSimpleXMLProp;
Begin Result := Self.Insert(Index, Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsInsert1_P(Self: TJclSimpleXMLProps;  const Index : Integer; const Name : string; const Value : Int64) : TJclSimpleXMLProp;
Begin Result := Self.Insert(Index, Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsInsert_P(Self: TJclSimpleXMLProps;  const Index : Integer; const Name, Value : string) : TJclSimpleXMLProp;
Begin Result := Self.Insert(Index, Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsAdd2_P(Self: TJclSimpleXMLProps;  const Name : string; const Value : Boolean) : TJclSimpleXMLProp;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsAdd_P(Self: TJclSimpleXMLProps;  const Name : string; const Value : Int64) : TJclSimpleXMLProp;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclSimpleXMLPropsAdd1_P(Self: TJclSimpleXMLProps;  const Name : string; const Value : AnsiString) : TJclSimpleXMLProp;
Begin Result := Self.Add(Name, Value); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropData_W(Self: TJclSimpleXMLProp; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropData_R(Self: TJclSimpleXMLProp; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropNameSpace_W(Self: TJclSimpleXMLProp; const T: string);
begin Self.NameSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropNameSpace_R(Self: TJclSimpleXMLProp; var T: string);
begin T := Self.NameSpace; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropFloatValue_W(Self: TJclSimpleXMLProp; const T: Extended);
begin Self.FloatValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropFloatValue_R(Self: TJclSimpleXMLProp; var T: Extended);
begin T := Self.FloatValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropBoolValue_W(Self: TJclSimpleXMLProp; const T: Boolean);
begin Self.BoolValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropBoolValue_R(Self: TJclSimpleXMLProp; var T: Boolean);
begin T := Self.BoolValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropIntValue_W(Self: TJclSimpleXMLProp; const T: Int64);
begin Self.IntValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropIntValue_R(Self: TJclSimpleXMLProp; var T: Int64);
begin T := Self.IntValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropAnsiValue_W(Self: TJclSimpleXMLProp; const T: AnsiString);
begin //Self.AnsiValue := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropAnsiValue_R(Self: TJclSimpleXMLProp; var T: AnsiString);
begin //T := Self.AnsiValue;
end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropValue_W(Self: TJclSimpleXMLProp; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropValue_R(Self: TJclSimpleXMLProp; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropName_W(Self: TJclSimpleXMLProp; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropName_R(Self: TJclSimpleXMLProp; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropParent_W(Self: TJclSimpleXMLProp; const T: TJclSimpleXMLProps);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleXMLPropParent_R(Self: TJclSimpleXMLProp; var T: TJclSimpleXMLProps);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSimpleXml_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@XMLCreateInto, 'XMLCreateInto', cdRegister);
 //S.RegisterDelphiFunction(@XMLCreate, 'XMLCreate', cdRegister);
 //S.RegisterDelphiFunction(@XMLCreate1, 'XMLCreate1', cdRegister);
 //S.RegisterDelphiFunction(@VarXML, 'VarXML', cdRegister);
 S.RegisterDelphiFunction(@SimpleXMLEncode, 'SimpleXMLEncode', cdRegister);
 S.RegisterDelphiFunction(@SimpleXMLDecode, 'SimpleXMLDecode', cdRegister);
 S.RegisterDelphiFunction(@XMLEncode, 'XMLEncode', cdRegister);
 S.RegisterDelphiFunction(@XMLDecode, 'XMLDecode', cdRegister);
 S.RegisterDelphiFunction(@EntityEncode, 'EntityEncode', cdRegister);
 S.RegisterDelphiFunction(@EntityDecode, 'EntityDecode', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLVariant(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(TXMLVariant) do
  //begin
  //end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXML) do begin
    RegisterConstructor(@TJclSimpleXML.Create, 'Create');
    RegisterMethod(@TJclSimpleXML.Destroy, 'Free');
    RegisterMethod(@TJclSimpleXML.LoadFromString, 'LoadFromString');
    RegisterMethod(@TJclSimpleXML.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJclSimpleXML.LoadFromStream, 'LoadFromStream');
    //RegisterMethod(@TJclSimpleXML.LoadFromStringStream, 'LoadFromStringStream');
    RegisterMethod(@TJclSimpleXML.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TJclSimpleXML.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJclSimpleXML.SaveToStream, 'SaveToStream');
    //RegisterMethod(@TJclSimpleXML.SaveToStringStream, 'SaveToStringStream');
    RegisterMethod(@TJclSimpleXML.SaveToString, 'SaveToString');
    RegisterPropertyHelper(@TJclSimpleXMLProlog_R,@TJclSimpleXMLProlog_W,'Prolog');
    RegisterPropertyHelper(@TJclSimpleXMLRoot_R,@TJclSimpleXMLRoot_W,'Root');
    RegisterPropertyHelper(@TJclSimpleXMLXMLData_R,@TJclSimpleXMLXMLData_W,'XMLData');
    RegisterPropertyHelper(@TJclSimpleXMLFileName_R,@TJclSimpleXMLFileName_W,'FileName');
    RegisterPropertyHelper(@TJclSimpleXMLIndentString_R,@TJclSimpleXMLIndentString_W,'IndentString');
    RegisterPropertyHelper(@TJclSimpleXMLOptions_R,@TJclSimpleXMLOptions_W,'Options');
    RegisterPropertyHelper(@TJclSimpleXMLOnSaveProgress_R,@TJclSimpleXMLOnSaveProgress_W,'OnSaveProgress');
    RegisterPropertyHelper(@TJclSimpleXMLOnLoadProgress_R,@TJclSimpleXMLOnLoadProgress_W,'OnLoadProgress');
    RegisterPropertyHelper(@TJclSimpleXMLOnTagParsed_R,@TJclSimpleXMLOnTagParsed_W,'OnTagParsed');
    RegisterPropertyHelper(@TJclSimpleXMLOnValueParsed_R,@TJclSimpleXMLOnValueParsed_W,'OnValueParsed');
    RegisterPropertyHelper(@TJclSimpleXMLOnEncodeValue_R,@TJclSimpleXMLOnEncodeValue_W,'OnEncodeValue');
    RegisterPropertyHelper(@TJclSimpleXMLOnDecodeValue_R,@TJclSimpleXMLOnDecodeValue_W,'OnDecodeValue');
    RegisterPropertyHelper(@TJclSimpleXMLOnEncodeStream_R,@TJclSimpleXMLOnEncodeStream_W,'OnEncodeStream');
    RegisterPropertyHelper(@TJclSimpleXMLOnDecodeStream_R,@TJclSimpleXMLOnDecodeStream_W,'OnDecodeStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemMSOApplication(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(TJclSimpleXMLElemMSOApplication) do
  //begin
  //end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemSheet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemSheet) do begin
   RegisterMethod(@TJclSimpleXMLElemSheet.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemSheet.SaveToStream, 'SaveToStream');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemDocType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemDocType) do begin
   RegisterMethod(@TJclSimpleXMLElemDocType.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemDocType.SaveToStream, 'SaveToStream');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemHeader) do begin
    RegisterPropertyHelper(@TJclSimpleXMLElemHeaderVersion_R,@TJclSimpleXMLElemHeaderVersion_W,'Version');
    RegisterPropertyHelper(@TJclSimpleXMLElemHeaderStandAlone_R,@TJclSimpleXMLElemHeaderStandAlone_W,'StandAlone');
    RegisterPropertyHelper(@TJclSimpleXMLElemHeaderEncoding_R,@TJclSimpleXMLElemHeaderEncoding_W,'Encoding');
    RegisterMethod(@TJclSimpleXMLElemHeader.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemHeader.SaveToStream, 'SaveToStream');
    RegisterConstructor(@TJclSimpleXMLElemHeader.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLElemHeader.Assign, 'Assign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemText) do begin
     RegisterMethod(@TJclSimpleXMLElemClassic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemClassic.SaveToStream, 'SaveToStream');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemCData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemCData) do begin
    RegisterMethod(@TJclSimpleXMLElemCData.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemCData.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemClassic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemClassic) do begin
   RegisterMethod(@TJclSimpleXMLElemClassic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemClassic.SaveToStream, 'SaveToStream');
 end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemComment(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemComment) do begin
    RegisterMethod(@TJclSimpleXMLElemClassic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclSimpleXMLElemClassic.SaveToStream, 'SaveToStream');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElem) do begin
    RegisterConstructor(@TJclSimpleXMLElem.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLElem.Destroy, 'Free');
    RegisterVirtualMethod(@TJclSimpleXMLElem.Assign, 'Assign');
    RegisterVirtualMethod(@TJclSimpleXMLElem.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TJclSimpleXMLElem, @!.LoadFromStringStream, 'LoadFromStringStream');
    //RegisterVirtualAbstractMethod(@TJclSimpleXMLElem, @!.SaveToStringStream, 'SaveToStringStream');
    RegisterMethod(@TJclSimpleXMLElem.LoadFromString, 'LoadFromString');
    RegisterMethod(@TJclSimpleXMLElem.SaveToString, 'SaveToString');
    RegisterMethod(@TJclSimpleXMLElem.GetBinaryValue, 'GetBinaryValue');
    RegisterPropertyHelper(@TJclSimpleXMLElemData_R,@TJclSimpleXMLElemData_W,'Data');
    RegisterMethod(@TJclSimpleXMLElem.GetChildIndex, 'GetChildIndex');
    //RegisterMethod(@TJclSimpleXMLElem.GetNamedIndex, 'GetNamedIndex');
    RegisterPropertyHelper(@TJclSimpleXMLElemSimpleXML_R,nil,'SimpleXML');
    RegisterPropertyHelper(@TJclSimpleXMLElemContainer_R,@TJclSimpleXMLElemContainer_W,'Container');
    RegisterVirtualMethod(@TJclSimpleXMLElem.FullName, 'FullName');
    RegisterPropertyHelper(@TJclSimpleXMLElemName_R,@TJclSimpleXMLElemName_W,'Name');
    RegisterPropertyHelper(@TJclSimpleXMLElemParent_R,@TJclSimpleXMLElemParent_W,'Parent');
    RegisterPropertyHelper(@TJclSimpleXMLElemNameSpace_R,@TJclSimpleXMLElemNameSpace_W,'NameSpace');
    RegisterPropertyHelper(@TJclSimpleXMLElemChildsCount_R,nil,'ChildsCount');
    RegisterPropertyHelper(@TJclSimpleXMLElemItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclSimpleXMLElemProperties_R,nil,'Properties');
    RegisterPropertyHelper(@TJclSimpleXMLElemIntValue_R,@TJclSimpleXMLElemIntValue_W,'IntValue');
    RegisterPropertyHelper(@TJclSimpleXMLElemBoolValue_R,@TJclSimpleXMLElemBoolValue_W,'BoolValue');
    RegisterPropertyHelper(@TJclSimpleXMLElemFloatValue_R,@TJclSimpleXMLElemFloatValue_W,'FloatValue');
    RegisterPropertyHelper(@TJclSimpleXMLElemValue_R,@TJclSimpleXMLElemValue_W,'Value');
    RegisterPropertyHelper(@TJclSimpleXMLElemAnsiValue_R,@TJclSimpleXMLElemAnsiValue_W,'AnsiValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElems) do begin
    RegisterConstructor(@TJclSimpleXMLElems.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLElems.Destroy, 'Free');
    RegisterMethod(@TJclSimpleXMLElems.Notify, 'Notify');
    RegisterMethod(@TJclSimpleXMLElemsAdd_P, 'Add');
    RegisterMethod(@TJclSimpleXMLElemsAdd1_P, 'Add1');
    RegisterMethod(@TJclSimpleXMLElemsAdd2_P, 'Add2');
    RegisterMethod(@TJclSimpleXMLElemsAdd3_P, 'Add3');
    RegisterMethod(@TJclSimpleXMLElemsAdd4_P, 'Add4');
    RegisterMethod(@TJclSimpleXMLElemsAdd5_P, 'Add5');
    RegisterMethod(@TJclSimpleXMLElemsAddFirst_P, 'AddFirst');
    RegisterMethod(@TJclSimpleXMLElemsAddFirst1_P, 'AddFirst1');
    RegisterMethod(@TJclSimpleXMLElems.AddComment, 'AddComment');
    RegisterMethod(@TJclSimpleXMLElems.AddCData, 'AddCData');
    RegisterMethod(@TJclSimpleXMLElems.AddText, 'AddText');
    RegisterMethod(@TJclSimpleXMLElemsInsert_P, 'Insert');
    RegisterMethod(@TJclSimpleXMLElemsInsert1_P, 'Insert1');
    RegisterVirtualMethod(@TJclSimpleXMLElems.Clear, 'Clear');
    RegisterMethod(@TJclSimpleXMLElemsDelete_P, 'Delete');
    RegisterMethod(@TJclSimpleXMLElemsDelete1_P, 'Delete1');
    //RegisterMethod(@TJclSimpleXMLElems.Remove, 'Remove');
    RegisterMethod(@TJclSimpleXMLElems.Move, 'Move');
    RegisterMethod(@TJclSimpleXMLElemsIndexOf_P, 'IndexOf');
    RegisterMethod(@TJclSimpleXMLElemsIndexOf1_P, 'IndexOf1');
    RegisterMethod(@TJclSimpleXMLElems.Value, 'Value');
    RegisterMethod(@TJclSimpleXMLElems.IntValue, 'IntValue');
    //RegisterMethod(@TJclSimpleXMLElems.FloatValue, 'FloatValue');
    RegisterMethod(@TJclSimpleXMLElems.BoolValue, 'BoolValue');
    RegisterMethod(@TJclSimpleXMLElems.BinaryValue, 'BinaryValue');
    //RegisterMethod(@TJclSimpleXMLElems.LoadFromStringStream, 'LoadFromStringStream');
    //RegisterMethod(@TJclSimpleXMLElems.SaveToStringStream, 'SaveToStringStream');
    RegisterMethod(@TJclSimpleXMLElems.Sort, 'Sort');
    RegisterMethod(@TJclSimpleXMLElems.CustomSort, 'CustomSort');
    RegisterPropertyHelper(@TJclSimpleXMLElemsParent_R,@TJclSimpleXMLElemsParent_W,'Parent');
    RegisterPropertyHelper(@TJclSimpleXMLElemsItem_R,nil,'Item');
    RegisterPropertyHelper(@TJclSimpleXMLElemsItemNamed_R,nil,'ItemNamed');
    RegisterPropertyHelper(@TJclSimpleXMLElemsCount_R,nil,'Count');
    //RegisterPropertyHelper(@TJclSimpleXMLElemsNamedElems_R,nil,'NamedElems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLNamedElems(CL: TPSRuntimeClassImporter);
begin
  (*with CL.Add(TJclSimpleXMLNamedElems) do
  begin
    RegisterConstructor(@TJclSimpleXMLNamedElems.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLNamedElemsAdd_P, 'Add');
    RegisterMethod(@TJclSimpleXMLNamedElemsAdd1_P, 'Add1');
    RegisterMethod(@TJclSimpleXMLNamedElemsAdd2_P, 'Add2');
    RegisterMethod(@TJclSimpleXMLNamedElemsAdd3_P, 'Add3');
    RegisterMethod(@TJclSimpleXMLNamedElemsAdd4_P, 'Add4');
    RegisterMethod(@TJclSimpleXMLNamedElems.AddFirst, 'AddFirst');
    RegisterMethod(@TJclSimpleXMLNamedElems.AddComment, 'AddComment');
    RegisterMethod(@TJclSimpleXMLNamedElems.AddCData, 'AddCData');
    RegisterMethod(@TJclSimpleXMLNamedElems.AddText, 'AddText');
    RegisterVirtualMethod(@TJclSimpleXMLNamedElems.Clear, 'Clear');
    RegisterMethod(@TJclSimpleXMLNamedElems.Delete, 'Delete');
    RegisterMethod(@TJclSimpleXMLNamedElems.Move, 'Move');
    RegisterMethod(@TJclSimpleXMLNamedElemsIndexOf_P, 'IndexOf');
    RegisterMethod(@TJclSimpleXMLNamedElemsIndexOf1_P, 'IndexOf1');
    RegisterPropertyHelper(@TJclSimpleXMLNamedElemsElems_R,nil,'Elems');
    RegisterPropertyHelper(@TJclSimpleXMLNamedElemsItem_R,nil,'Item');
    RegisterPropertyHelper(@TJclSimpleXMLNamedElemsCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclSimpleXMLNamedElemsName_R,nil,'Name');
  end; *)
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLElemsProlog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLElemsProlog) do
  begin
    RegisterConstructor(@TJclSimpleXMLElemsProlog.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLElemsProlog.Destroy, 'Free');
    RegisterMethod(@TJclSimpleXMLElemsProlog.AddComment, 'AddComment');
    RegisterMethod(@TJclSimpleXMLElemsProlog.AddDocType, 'AddDocType');
    RegisterMethod(@TJclSimpleXMLElemsProlog.Clear, 'Clear');
    RegisterMethod(@TJclSimpleXMLElemsProlog.AddStyleSheet, 'AddStyleSheet');
    //RegisterMethod(@TJclSimpleXMLElemsProlog.AddMSOApplication, 'AddMSOApplication');
    //RegisterMethod(@TJclSimpleXMLElemsProlog.LoadFromStringStream, 'LoadFromStringStream');
    //RegisterMethod(@TJclSimpleXMLElemsProlog.SaveToStringStream, 'SaveToStringStream');
    RegisterPropertyHelper(@TJclSimpleXMLElemsPrologItem_R,nil,'Item');
    RegisterPropertyHelper(@TJclSimpleXMLElemsPrologCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclSimpleXMLElemsPrologEncoding_R,@TJclSimpleXMLElemsPrologEncoding_W,'Encoding');
    RegisterPropertyHelper(@TJclSimpleXMLElemsPrologStandAlone_R,@TJclSimpleXMLElemsPrologStandAlone_W,'StandAlone');
    RegisterPropertyHelper(@TJclSimpleXMLElemsPrologVersion_R,@TJclSimpleXMLElemsPrologVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLProps(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLProps) do begin
    RegisterConstructor(@TJclSimpleXMLProps.Create, 'Create');
    RegisterMethod(@TJclSimpleXMLProps.Destroy, 'Free');
    RegisterMethod(@TJclSimpleXMLPropsAdd_P, 'Add');
    RegisterMethod(@TJclSimpleXMLPropsAdd1_P, 'Add1');
    RegisterMethod(@TJclSimpleXMLPropsAdd_P, 'Add');
    RegisterMethod(@TJclSimpleXMLPropsAdd2_P, 'Add2');
    RegisterMethod(@TJclSimpleXMLPropsInsert_P, 'Insert');
    RegisterMethod(@TJclSimpleXMLPropsInsert1_P, 'Insert1');
    RegisterMethod(@TJclSimpleXMLPropsInsert2_P, 'Insert2');
    RegisterVirtualMethod(@TJclSimpleXMLProps.Clear, 'Clear');
    RegisterMethod(@TJclSimpleXMLPropsDelete_P, 'Delete');
    RegisterMethod(@TJclSimpleXMLPropsDelete1_P, 'Delete1');
    RegisterMethod(@TJclSimpleXMLProps.Value, 'Value');
    RegisterMethod(@TJclSimpleXMLProps.IntValue, 'IntValue');
    RegisterMethod(@TJclSimpleXMLProps.BoolValue, 'BoolValue');
    //RegisterMethod(@TJclSimpleXMLProps.FloatValue, 'FloatValue');
    //RegisterMethod(@TJclSimpleXMLProps.LoadFromStringStream, 'LoadFromStringStream');
    //RegisterMethod(@TJclSimpleXMLProps.SaveToStringStream, 'SaveToStringStream');
    RegisterPropertyHelper(@TJclSimpleXMLPropsItem_R,nil,'Item');
    RegisterPropertyHelper(@TJclSimpleXMLPropsItemNamed_R,nil,'ItemNamed');
    RegisterPropertyHelper(@TJclSimpleXMLPropsCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleXMLProp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXMLProp) do begin
    RegisterMethod(@TJclSimpleXMLProp.GetSimpleXML, 'GetSimpleXML');
    //RegisterMethod(@TJclSimpleXMLProp.SaveToStringStream, 'SaveToStringStream');
    RegisterMethod(@TJclSimpleXMLProp.FullName, 'FullName');
    RegisterPropertyHelper(@TJclSimpleXMLPropParent_R,@TJclSimpleXMLPropParent_W,'Parent');
    RegisterPropertyHelper(@TJclSimpleXMLPropName_R,@TJclSimpleXMLPropName_W,'Name');
    RegisterPropertyHelper(@TJclSimpleXMLPropValue_R,@TJclSimpleXMLPropValue_W,'Value');
    RegisterPropertyHelper(@TJclSimpleXMLPropAnsiValue_R,@TJclSimpleXMLPropAnsiValue_W,'AnsiValue');
    RegisterPropertyHelper(@TJclSimpleXMLPropIntValue_R,@TJclSimpleXMLPropIntValue_W,'IntValue');
    RegisterPropertyHelper(@TJclSimpleXMLPropBoolValue_R,@TJclSimpleXMLPropBoolValue_W,'BoolValue');
    RegisterPropertyHelper(@TJclSimpleXMLPropFloatValue_R,@TJclSimpleXMLPropFloatValue_W,'FloatValue');
    RegisterPropertyHelper(@TJclSimpleXMLPropNameSpace_R,@TJclSimpleXMLPropNameSpace_W,'NameSpace');
    RegisterPropertyHelper(@TJclSimpleXMLPropData_R,@TJclSimpleXMLPropData_W,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSimpleXml(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleXML) do
  with CL.Add(EJclSimpleXMLError) do
  with CL.Add(TJclSimpleXMLElem) do
  with CL.Add(TJclSimpleXMLElems) do
  with CL.Add(TJclSimpleXMLProps) do
  with CL.Add(TJclSimpleXMLElemComment) do
  with CL.Add(TJclSimpleXMLElemClassic) do
  with CL.Add(TJclSimpleXMLElemCData) do
  with CL.Add(TJclSimpleXMLElemDocType) do
  with CL.Add(TJclSimpleXMLElemText) do
  with CL.Add(TJclSimpleXMLElemHeader) do
  with CL.Add(TJclSimpleXMLElemSheet) do
  //with CL.Add(TJclSimpleXMLElemMSOApplication) do
  RIRegister_TJclSimpleXMLProp(CL);
  RIRegister_TJclSimpleXMLProps(CL);
  RIRegister_TJclSimpleXMLElemsProlog(CL);
  RIRegister_TJclSimpleXMLNamedElems(CL);
  RIRegister_TJclSimpleXMLElems(CL);
  RIRegister_TJclSimpleXMLElem(CL);
  RIRegister_TJclSimpleXMLElemComment(CL);
  RIRegister_TJclSimpleXMLElemClassic(CL);
  RIRegister_TJclSimpleXMLElemCData(CL);
  RIRegister_TJclSimpleXMLElemText(CL);
  RIRegister_TJclSimpleXMLElemHeader(CL);
  RIRegister_TJclSimpleXMLElemDocType(CL);
  RIRegister_TJclSimpleXMLElemSheet(CL);
  RIRegister_TJclSimpleXMLElemMSOApplication(CL);
  RIRegister_TJclSimpleXML(CL);
  RIRegister_TXMLVariant(CL);
end;

 
 
{ TPSImport_JclSimpleXml }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSimpleXml.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSimpleXml(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSimpleXml.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclSimpleXml(ri);
  RIRegister_JclSimpleXml_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
