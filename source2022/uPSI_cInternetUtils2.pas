unit uPSI_cInternetUtils2;
{
Tfundamentals mental    TDateFieldClass , SIRegister_TDateFieldClass , SIRegister_THeaderCls

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
  TPSImport_cInternetUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TEMailField(CL: TPSPascalCompiler);
procedure SIRegister_TDateFieldClass(CL: TPSPascalCompiler);
procedure SIRegister_TInvalidField(CL: TPSPascalCompiler);
procedure SIRegister_THeaderField(CL: TPSPascalCompiler);
procedure SIRegister_THeaderCls(CL: TPSPascalCompiler);
procedure SIRegister_AHeaderField(CL: TPSPascalCompiler);
procedure SIRegister_cInternetUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TEMailField(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDateFieldClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInvalidField(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderField(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderCls(CL: TPSRuntimeClassImporter);
procedure RIRegister_AHeaderField(CL: TPSRuntimeClassImporter);
procedure RIRegister_cInternetUtils_Routines(S: TPSExec);
procedure RIRegister_cInternetUtils(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   cfundamentUtils
 //,cStrings
 // ,cReaders
  //,cStreams
  ,cInternetUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cInternetUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TEMailField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THeaderField', 'TEMailField') do
  with CL.AddClassN(CL.FindClass('THeaderField'),'TEMailField') do
  begin
    RegisterProperty('Address', 'String', iptr);
    RegisterProperty('Name', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDateFieldClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHeaderField', 'TDateField') do
  with CL.AddClassN(CL.FindClass('AHeaderField'),'TDateFieldClass') do
  begin
    RegisterMethod('Constructor CreateNow');
    RegisterMethod('Constructor Create( const LocalTime : TDateTime);');
    RegisterProperty('GMTDateTime', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInvalidField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHeaderField', 'TInvalidField') do
  with CL.AddClassN(CL.FindClass('AHeaderField'),'TInvalidField') do
  begin
    RegisterMethod('Constructor Create( const RawLine : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHeaderField', 'THeaderField') do
  with CL.AddClassN(CL.FindClass('AHeaderField'),'THeaderField') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderCls(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THeader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THeaderCls') do begin
    RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor Create( const Header : String);');
    RegisterMethod('Constructor Create5( const HeaderReader: AReaderEx; const Tolerant: Boolean; const MaxHeaderSize : Integer);');
    RegisterMethod('Function Duplicate : THeader');
    RegisterMethod('Procedure ReadFromStream( const HeaderReader: AReaderEx; const Tolerant : Boolean; const MaxHeaderSize : Integer)');
    RegisterMethod('Procedure Prepare');
    RegisterProperty('AsString', 'String', iptrw);
    RegisterProperty('FieldCount', 'Integer', iptr);
    RegisterProperty('FieldByIndex', 'AHeaderField Integer', iptrw);
    RegisterMethod('Function GetFieldIndex( const Name : String) : Integer');
    RegisterMethod('Function HasField( const Name : String) : Boolean');
    RegisterProperty('Field', 'AHeaderField String', iptrw);
    SetDefaultPropery('Field');
    RegisterProperty('FieldBody', 'String String', iptrw);
    RegisterMethod('Function GetFieldNames : TStringArray');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure DeleteFieldByIndex( const Idx : Integer)');
    RegisterMethod('Function DeleteField( const Name : String) : Boolean');
    RegisterMethod('Procedure AddField6( const Field : AHeaderField);');
    RegisterMethod('Procedure AddField7( const Name, Body : String);');
    RegisterMethod('Procedure AddField8( const FieldLine : String);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AHeaderField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'AHeaderField') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'AHeaderField') do
  begin
    RegisterMethod('Constructor Create2( const Body : String);');
    RegisterMethod('Constructor Create3( const Name, Body : String);');
    RegisterMethod('Function Duplicate : AHeaderField');
    RegisterMethod('Procedure Prepare');
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Body', 'String', iptrw);
    RegisterProperty('BodyAsInteger', 'Int64', iptrw);
    RegisterProperty('BodyAsFloat', 'Extended', iptrw);
    RegisterProperty('AsString', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cInternetUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ctHTML','String').SetString( 'text/html');
 CL.AddConstantN('ctText','String').SetString( 'text/plain');
 CL.AddConstantN('ctXML','String').SetString( 'text/xml');
 CL.AddConstantN('ctJPG','String').SetString( 'image/jpeg');
 CL.AddConstantN('ctGIF','String').SetString( 'image/gif');
 CL.AddConstantN('ctBMP','String').SetString( 'image/bmp');
 CL.AddConstantN('ctPNG','String').SetString( 'image/png');
 CL.AddConstantN('ctTIFF','String').SetString( 'image/tiff');
 CL.AddConstantN('ctMPG','String').SetString( 'video/mpeg');
 CL.AddConstantN('ctAVI','String').SetString( 'video/avi');
 CL.AddConstantN('ctQT','String').SetString( 'video/quicktime');
 CL.AddConstantN('ctBinary','String').SetString( 'application/binary');
 CL.AddConstantN('ctPDF','String').SetString( 'application/pdf');
 CL.AddConstantN('ctPostscript','String').SetString( 'application/postscript');
 CL.AddConstantN('ctBasicAudio','String').SetString( 'audio/basic');
 CL.AddConstantN('ctMP3','String').SetString( 'audio/mpeg');
 CL.AddConstantN('ctRA','String').SetString( 'audio/x-realaudio');
 CL.AddConstantN('ctURLEncoded','String').SetString( 'application/x-www-form-urlencoded');
 CL.AddConstantN('ctZIP','String').SetString( 'application/zip');
 CL.AddConstantN('ctJavaScript','String').SetString( 'application/javascript');
 CL.AddConstantN('ctPascal','String').SetString( 'text/x-source-pascal');
 CL.AddConstantN('ctCPP','String').SetString( 'text/x-source-cpp');
 CL.AddConstantN('ctINI','String').SetString( 'text/x-windows-ini');
 CL.AddConstantN('ctBAT','String').SetString( 'text/x-windows-bat');
 CL.AddDelphiFunction('Function flcMIMEContentTypeFromExtention( const Extention : String) : String');
 CL.AddConstantN('protoHTTP','String').SetString( 'http');
 CL.AddConstantN('protoNNTP','String').SetString( 'news');
 CL.AddConstantN('protoFTP','String').SetString( 'ftp');
 CL.AddConstantN('protoGopher','String').SetString( 'gopher');
 CL.AddConstantN('protoEMail','String').SetString( 'mailto');
 CL.AddConstantN('protoHTTPS','String').SetString( 'https');
 CL.AddConstantN('protoIRC','String').SetString( 'irc');
 CL.AddConstantN('protoFile','String').SetString( 'file');
 CL.AddConstantN('protoTelnet','String').SetString( 'telnet');
 CL.AddDelphiFunction('Procedure flcDecodeURL( const URL : String; var Protocol, Host, Path : String)');
 CL.AddDelphiFunction('Function flcEncodeURL( const Protocol, Host, Path : String) : String');
 CL.AddDelphiFunction('Procedure flcDecodeHost( const Address: String; var Host, Port: String; const DefaultPort: String)');
 CL.AddDelphiFunction('Function flcEncodeDotLineTerminated( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function flcEncodeEmptyLineTerminated( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function flcDecodeDotLineTerminated( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function flcDecodeEmptyLineTerminated( const S : AnsiString) : AnsiString');
 //CL.AddDelphiFunction('Procedure StreamDotLineTerminated0( const Source, Destination : AStream; const ProgressCallback : TCopyProgressProcedure);');
 //CL.AddDelphiFunction('Procedure StreamDotLineTerminated1( const Source : String; const Destination : AStream; const ProgressCallback : TCopyProgressProcedure);');
 CL.AddDelphiFunction('Function flchtmlCharRef( const CharVal : LongWord; const UseHex : Boolean) : String');
 CL.AddDelphiFunction('Function flchtmlSafeAsciiText( const S : String) : String');
 CL.AddDelphiFunction('Procedure flchtmlSafeWideText( var S : WideString)');
 CL.AddDelphiFunction('Function flchtmlSafeQuotedText( const S : String) : String');
 CL.AddDelphiFunction('Function flcEncodeHeaderField( const Name, Body : String) : String');
 CL.AddDelphiFunction('Function flcDecodeHeaderField( const S : String; var Name, Body : String) : Boolean');
 CL.AddDelphiFunction('Procedure flcDecodeEMailAddress( const S : String; var User, Domain : String)');
 CL.AddDelphiFunction('Procedure flcDecodeEMailField( const S : String; var EMailAddress, Name : String)');
 CL.AddDelphiFunction('Function flcDateFieldBody : String');
 CL.AddDelphiFunction('Function flcDateField : String');
 CL.AddDelphiFunction('Function flcMessageIDFieldBody( const ID : String; const Host : String) : String');
  SIRegister_AHeaderField(CL);
  //CL.AddTypeS('AHeaderFieldClass', 'class of AHeaderField');
  CL.AddTypeS('AHeaderFieldArray', 'array of AHeaderField');
  SIRegister_THeaderCls(CL);
  //CL.AddTypeS('THeaderClass', 'class of THeader');
  CL.AddTypeS('THeaderArray', 'array of THeaderCls');
  SIRegister_THeaderField(CL);
  SIRegister_TInvalidField(CL);
  SIRegister_TDateFieldClass(CL);
  SIRegister_TEMailField(CL);
 CL.AddDelphiFunction('Procedure SelfTestInternetUtils');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TEMailFieldName_R(Self: TEMailField; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TEMailFieldAddress_R(Self: TEMailField; var T: String);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TDateFieldGMTDateTime_W(Self: TDateFieldClass; const T: TDateTime);
begin Self.GMTDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateFieldGMTDateTime_R(Self: TDateFieldClass; var T: TDateTime);
begin T := Self.GMTDateTime; end;

(*----------------------------------------------------------------------------*)
Function TDateFieldCreate9_P(Self: TClass; CreateNewInstance: Boolean;  const LocalTime : TDateTime):TObject;
Begin Result := TDateFieldClass.Create(LocalTime); END;

(*----------------------------------------------------------------------------*)
Procedure THeaderAddField8_P(Self: THeaderCls;  const FieldLine : String);
Begin Self.AddField(FieldLine); END;

(*----------------------------------------------------------------------------*)
Procedure THeaderAddField7_P(Self: THeaderCls;  const Name, Body : String);
Begin Self.AddField(Name, Body); END;

(*----------------------------------------------------------------------------*)
Procedure THeaderAddField6_P(Self: THeaderCls;  const Field : AHeaderField);
Begin Self.AddField(Field); END;

(*----------------------------------------------------------------------------*)
procedure THeaderFieldBody_W(Self: THeaderCls; const T: String; const t1: String);
begin Self.FieldBody[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFieldBody_R(Self: THeaderCls; var T: String; const t1: String);
begin T := Self.FieldBody[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THeaderField_W(Self: THeaderCls; const T: AHeaderField; const t1: String);
begin Self.Field[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderField_R(Self: THeaderCls; var T: AHeaderField; const t1: String);
begin T := Self.Field[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFieldByIndex_W(Self: THeaderCls; const T: AHeaderField; const t1: Integer);
begin Self.FieldByIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFieldByIndex_R(Self: THeaderCls; var T: AHeaderField; const t1: Integer);
begin T := Self.FieldByIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFieldCount_R(Self: THeaderCls; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure THeaderAsString_W(Self: THeaderCls; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderAsString_R(Self: THeaderCls; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
//Function THeaderCreate5_P(Self: TClass; CreateNewInstance: Boolean;  const HeaderReader : AReaderEx; const Tolerant : Boolean; const MaxHeaderSize : Integer):TObject;
//Begin Result := THeaderCls.Create(HeaderReader, Tolerant, MaxHeaderSize); END;

(*----------------------------------------------------------------------------*)
Function THeaderCreate4_P(Self: TClass; CreateNewInstance: Boolean;  const Header : String):TObject;
Begin Result := THeaderCls.Create(Header); END;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldAsString_W(Self: AHeaderField; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldAsString_R(Self: AHeaderField; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBodyAsFloat_W(Self: AHeaderField; const T: Extended);
begin Self.BodyAsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBodyAsFloat_R(Self: AHeaderField; var T: Extended);
begin T := Self.BodyAsFloat; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBodyAsInteger_W(Self: AHeaderField; const T: Int64);
begin Self.BodyAsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBodyAsInteger_R(Self: AHeaderField; var T: Int64);
begin T := Self.BodyAsInteger; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBody_W(Self: AHeaderField; const T: String);
begin Self.Body := T; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldBody_R(Self: AHeaderField; var T: String);
begin T := Self.Body; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldName_W(Self: AHeaderField; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure AHeaderFieldName_R(Self: AHeaderField; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
Function AHeaderFieldCreate3_P(Self: TClass; CreateNewInstance: Boolean;  const Name, Body : String):TObject;
Begin Result := AHeaderField.Create(Name, Body); END;

(*----------------------------------------------------------------------------*)
Function AHeaderFieldCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Body : String):TObject;
Begin Result := AHeaderField.Create(Body); END;

(*----------------------------------------------------------------------------*)
//rocedure StreamDotLineTerminated1_P( const Source : String; const Destination : AStream; const ProgressCallback : TCopyProgressProcedure);
//Begin cInternetUtils.StreamDotLineTerminated(Source, Destination, ProgressCallback); END;

(*----------------------------------------------------------------------------*)
//Procedure StreamDotLineTerminated0_P( const Source, Destination : AStream; const ProgressCallback : TCopyProgressProcedure);
//Begin cInternetUtils.StreamDotLineTerminated(Source, Destination, ProgressCallback); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEMailField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEMailField) do
  begin
    RegisterPropertyHelper(@TEMailFieldAddress_R,nil,'Address');
    RegisterPropertyHelper(@TEMailFieldName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDateFieldClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDateFieldClass) do
  begin
    RegisterConstructor(@TDateFieldClass.CreateNow, 'CreateNow');
    RegisterConstructor(@TDateFieldCreate9_P, 'Create');
    RegisterPropertyHelper(@TDateFieldGMTDateTime_R,@TDateFieldGMTDateTime_W,'GMTDateTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInvalidField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInvalidField) do
  begin
    RegisterConstructor(@TInvalidField.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderField) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderCls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderCls) do
  begin
    RegisterConstructor(@THeaderCreate4_P, 'Create');
       RegisterMethod(@THeaderCls.Destroy, 'Free');

    //RegisterConstructor(@THeaderCreate5_P, 'Create5');
    RegisterVirtualMethod(@THeaderCls.Duplicate, 'Duplicate');
    //RegisterVirtualMethod(@THeaderCls.ReadFromStream, 'ReadFromStream');
    RegisterVirtualMethod(@THeaderCls.Prepare, 'Prepare');
    RegisterPropertyHelper(@THeaderAsString_R,@THeaderAsString_W,'AsString');
    RegisterPropertyHelper(@THeaderFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@THeaderFieldByIndex_R,@THeaderFieldByIndex_W,'FieldByIndex');
    RegisterMethod(@THeaderCls.GetFieldIndex, 'GetFieldIndex');
    RegisterMethod(@THeaderCls.HasField, 'HasField');
    RegisterPropertyHelper(@THeaderField_R,@THeaderField_W,'Field');
    RegisterPropertyHelper(@THeaderFieldBody_R,@THeaderFieldBody_W,'FieldBody');
    RegisterVirtualMethod(@THeaderCls.GetFieldNames, 'GetFieldNames');
    RegisterVirtualMethod(@THeaderCls.Clear, 'Clear');
    RegisterMethod(@THeaderCls.DeleteFieldByIndex, 'DeleteFieldByIndex');
    RegisterMethod(@THeaderCls.DeleteField, 'DeleteField');
    RegisterMethod(@THeaderAddField6_P, 'AddField6');
    RegisterVirtualMethod(@THeaderAddField7_P, 'AddField7');
    RegisterVirtualMethod(@THeaderAddField8_P, 'AddField8');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AHeaderField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AHeaderField) do
  begin
    RegisterConstructor(@AHeaderFieldCreate2_P, 'Create2');
    RegisterConstructor(@AHeaderFieldCreate3_P, 'Create3');
    RegisterVirtualMethod(@AHeaderField.Duplicate, 'Duplicate');
    RegisterVirtualMethod(@AHeaderField.Prepare, 'Prepare');
    RegisterPropertyHelper(@AHeaderFieldName_R,@AHeaderFieldName_W,'Name');
    RegisterPropertyHelper(@AHeaderFieldBody_R,@AHeaderFieldBody_W,'Body');
    RegisterPropertyHelper(@AHeaderFieldBodyAsInteger_R,@AHeaderFieldBodyAsInteger_W,'BodyAsInteger');
    RegisterPropertyHelper(@AHeaderFieldBodyAsFloat_R,@AHeaderFieldBodyAsFloat_W,'BodyAsFloat');
    RegisterPropertyHelper(@AHeaderFieldAsString_R,@AHeaderFieldAsString_W,'AsString');
  end;

end;

procedure RIRegister_cInternetUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_AHeaderField(CL);
  RIRegister_THeaderCls(CL);
  RIRegister_THeaderField(CL);
  RIRegister_TInvalidField(CL);
  RIRegister_TDateFieldClass(CL);
  RIRegister_TEMailField(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cInternetUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MIMEContentTypeFromExtention, 'flcMIMEContentTypeFromExtention', cdRegister);
 S.RegisterDelphiFunction(@DecodeURL, 'flcDecodeURL', cdRegister);
 S.RegisterDelphiFunction(@EncodeURL, 'flcEncodeURL', cdRegister);
 S.RegisterDelphiFunction(@DecodeHost, 'flcDecodeHost', cdRegister);
 S.RegisterDelphiFunction(@EncodeDotLineTerminated, 'flcEncodeDotLineTerminated', cdRegister);
 S.RegisterDelphiFunction(@EncodeEmptyLineTerminated, 'flcEncodeEmptyLineTerminated', cdRegister);
 S.RegisterDelphiFunction(@DecodeDotLineTerminated, 'flcDecodeDotLineTerminated', cdRegister);
 S.RegisterDelphiFunction(@DecodeEmptyLineTerminated, 'DecodeEmptyLineTerminated', cdRegister);
 //S.RegisterDelphiFunction(@StreamDotLineTerminated0, 'StreamDotLineTerminated0', cdRegister);
 //S.RegisterDelphiFunction(@StreamDotLineTerminated1, 'StreamDotLineTerminated1', cdRegister);
 S.RegisterDelphiFunction(@htmlCharRef, 'flchtmlCharRef', cdRegister);
 S.RegisterDelphiFunction(@htmlSafeAsciiText, 'flchtmlSafeAsciiText', cdRegister);
 S.RegisterDelphiFunction(@htmlSafeWideText, 'flchtmlSafeWideText', cdRegister);
 S.RegisterDelphiFunction(@htmlSafeQuotedText, 'flchtmlSafeQuotedText', cdRegister);
 S.RegisterDelphiFunction(@EncodeHeaderField, 'flcEncodeHeaderField', cdRegister);
 S.RegisterDelphiFunction(@DecodeHeaderField, 'flcDecodeHeaderField', cdRegister);
 S.RegisterDelphiFunction(@DecodeEMailAddress, 'flcDecodeEMailAddress', cdRegister);
 S.RegisterDelphiFunction(@DecodeEMailField, 'flcDecodeEMailField', cdRegister);
 S.RegisterDelphiFunction(@DateFieldBody, 'flcDateFieldBody', cdRegister);
 S.RegisterDelphiFunction(@DateField, 'flcDateField', cdRegister);
 S.RegisterDelphiFunction(@MessageIDFieldBody, 'flcMessageIDFieldBody', cdRegister);
 { RIRegister_AHeaderField(CL);
  RIRegister_THeader(CL);
  RIRegister_THeaderField(CL);
  RIRegister_TInvalidField(CL);
  RIRegister_TDateField(CL);
  RIRegister_TEMailField(CL);   }
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestInternetUtils', cdRegister);
end;

 
 
{ TPSImport_cInternetUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cInternetUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cInternetUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cInternetUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cInternetUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
