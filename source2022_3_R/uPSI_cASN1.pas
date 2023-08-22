unit uPSI_cASN1;
{
  with fundamentals to cryptobox5  with buf as string

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
  TPSImport_cASN1 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cASN1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cASN1_Routines(S: TPSExec);
procedure RIRegister_cASN1(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cASN1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cASN1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cASN1(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EASN1');
 CL.AddConstantN('ASN1_ID_END_OF_CONTENT','LongWord').SetUInt( $00);
 CL.AddConstantN('ASN1_ID_BOOLEAN','LongWord').SetUInt( $01);
 CL.AddConstantN('ASN1_ID_INTEGER','LongWord').SetUInt( $02);
 CL.AddConstantN('ASN1_ID_BIT_STRING','LongWord').SetUInt( $03);
 CL.AddConstantN('ASN1_ID_OCTET_STRING','LongWord').SetUInt( $04);
 CL.AddConstantN('ASN1_ID_NULL','LongWord').SetUInt( $05);
 CL.AddConstantN('ASN1_ID_OBJECT_IDENTIFIER','LongWord').SetUInt( $06);
 CL.AddConstantN('ASN1_ID_OBJECT_DESCRIPTOR','LongWord').SetUInt( $07);
 CL.AddConstantN('ASN1_ID_EXTERNAL','LongWord').SetUInt( $08);
 CL.AddConstantN('ASN1_ID_REAL','LongWord').SetUInt( $09);
 CL.AddConstantN('ASN1_ID_ENUMERATED','LongWord').SetUInt( $0A);
 CL.AddConstantN('ASN1_ID_EMBEDDED_PDV','LongWord').SetUInt( $0B);
 CL.AddConstantN('ASN1_ID_UTF8STRING','LongWord').SetUInt( $0C);
 CL.AddConstantN('ASN1_ID_RELATIVE_OID','LongWord').SetUInt( $0D);
 CL.AddConstantN('ASN1_ID_NUMERICSTRING','LongWord').SetUInt( $12);
 CL.AddConstantN('ASN1_ID_PRINTABLESTRING','LongWord').SetUInt( $13);
 CL.AddConstantN('ASN1_ID_T61STRING','LongWord').SetUInt( $14);
 CL.AddConstantN('ASN1_ID_VIDEOTEXSTRING','LongWord').SetUInt( $15);
 CL.AddConstantN('ASN1_ID_IA5STRING','LongWord').SetUInt( $16);
 CL.AddConstantN('ASN1_ID_UTCTIME','LongWord').SetUInt( $17);
 CL.AddConstantN('ASN1_ID_GENERALIZEDTIME','LongWord').SetUInt( $18);
 CL.AddConstantN('ASN1_ID_GRAPHICSTRING','LongWord').SetUInt( $19);
 CL.AddConstantN('ASN1_ID_VISIBLESTRING','LongWord').SetUInt( $1A);
 CL.AddConstantN('ASN1_ID_GENERALSTRING','LongWord').SetUInt( $1B);
 CL.AddConstantN('ASN1_ID_UNIVERSALSTRING','LongWord').SetUInt( $1C);
 CL.AddConstantN('ASN1_ID_CHARACTERSTRING','LongWord').SetUInt( $1D);
 CL.AddConstantN('ASN1_ID_BMPSTRING','LongWord').SetUInt( $1E);
 CL.AddConstantN('ASN1_ID_SEQUENCE','LongWord').SetUInt( $30);
 CL.AddConstantN('ASN1_ID_SET','LongWord').SetUInt( $31);
 CL.AddConstantN('ASN1_ID_CONSTRUCTED','LongWord').SetUInt( $20);
 CL.AddConstantN('ASN1_ID_APPLICATION','LongWord').SetUInt( $40);
 CL.AddConstantN('ASN1_ID_CONTEXT_SPECIFIC','LongWord').SetUInt( $80);
 CL.AddConstantN('ASN1_ID_PRIVATE','LongWord').SetUInt( $C0);
  CL.AddTypeS('TASN1ObjectIdentifier', 'array of Integer');
  CL.AddTypeS('TASN1ParseProc', 'procedure (const TypeID: Byte; const DataBuf: string; const DataSize: Integer; const ObjectIdx: Integer; const CallerData: Integer);');

  {TASN1ParseProc =
      procedure (const TypeID: Byte; const DataBuf; const DataSize: Integer;
                 const ObjectIdx: Integer; const CallerData: Integer); }
                 
 CL.AddDelphiFunction('Procedure ASN1OIDInit( var A : TASN1ObjectIdentifier; const B : array of Integer)');
 CL.AddDelphiFunction('Function ASN1OIDToStr( const A : TASN1ObjectIdentifier) : AnsiString');
 CL.AddDelphiFunction('Function ASN1OIDEqual( const A : TASN1ObjectIdentifier; const B : array of Integer) : Boolean');
 CL.AddDelphiFunction('Function ASN1EncodeLength( const Len : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeObj( const TypeID : Byte; const Data : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ANS1EncodeEndOfContent : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeNull : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeBoolean( const A : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeDataInteger8( const A : ShortInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeDataInteger16( const A : SmallInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeDataInteger24( const A : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeDataInteger32( const A : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeDataInteger64( const A : Int64) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInteger8( const A : ShortInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInteger16( const A : SmallInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInteger24( const A : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInteger32( const A : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInteger64( const A : Int64) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeIntegerBuf( const A : string; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeIntegerBufStr( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeEnumerated( const A : Int64) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeBitString( const A : AnsiString; const UnusedBits : Byte) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeOctetString( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeInt32AsOctetString( const A : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeUTF8String( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeIA5String( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeVisibleString( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeNumericString( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodePrintableString( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeTeletexString( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeUniversalString( const A : WideString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeBMPString( const A : WideString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeUTCTime( const A : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeGeneralizedTime( const A : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeOID( const OID : array of Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeSequence( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeSet( const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1EncodeContextSpecific( const I : Integer; const A : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASN1DecodeLength( const Buf : string; const Size : Integer; var Len : Integer) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeObjHeader( const Buf : string; const Size : Integer; var TypeID : Byte; var Len : Integer; var Data : string) : Integer');
 CL.AddDelphiFunction('Function ASN1TypeIsConstructedType( const TypeID : Byte) : Boolean');
 CL.AddDelphiFunction('Function ASN1TypeIsContextSpecific( const TypeID : Byte; var Idx : Integer) : Boolean');
 CL.AddDelphiFunction('Function ASN1DecodeDataBoolean( const Buf : string; const Size : Integer; var A : Boolean) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataInteger32( const Buf : string; const Size : Integer; var A : LongInt) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataInteger64( const Buf : string; const Size : Integer; var A : Int64) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataIntegerBuf( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataBitString( const Buf : string; const Size : Integer; var A : AnsiString; var UnusedBits : Byte) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataRawAnsiString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataOctetString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataIA5String( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataVisibleString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataNumericString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataPrintableString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataTeletexString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataUTF8String( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataUniversalString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataBMPString( const Buf : string; const Size : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataOID( const Buf : string; const Size : Integer; var A : TASN1ObjectIdentifier) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataUTCTime( const Buf : string; const Size : Integer; var A : TDateTime) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeDataGeneralizedTime( const Buf : string; const Size : Integer; var A : TDateTime) : Integer');
 CL.AddDelphiFunction('Function ASN1Parse( const Buf : string; const Size : Integer; const ParseProc : TASN1ParseProc; const CallerData : Integer) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeBoolean( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : Boolean) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeInteger32( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : LongInt) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeInteger64( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : Int64) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeIntegerBuf( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeBitString( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : AnsiString; var UnusedBits : Byte) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeString( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeOID( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : TASN1ObjectIdentifier) : Integer');
 CL.AddDelphiFunction('Function ASN1DecodeTime( const TypeID : Byte; const DataBuf : string; const DataSize : Integer; var A : TDateTime) : Integer');
 CL.AddDelphiFunction('Procedure SelfTestASN1');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cASN1_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ASN1OIDInit, 'ASN1OIDInit', cdRegister);
 S.RegisterDelphiFunction(@ASN1OIDToStr, 'ASN1OIDToStr', cdRegister);
 S.RegisterDelphiFunction(@ASN1OIDEqual, 'ASN1OIDEqual', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeLength, 'ASN1EncodeLength', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeObj, 'ASN1EncodeObj', cdRegister);
 S.RegisterDelphiFunction(@ANS1EncodeEndOfContent, 'ANS1EncodeEndOfContent', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeNull, 'ASN1EncodeNull', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeBoolean, 'ASN1EncodeBoolean', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeDataInteger8, 'ASN1EncodeDataInteger8', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeDataInteger16, 'ASN1EncodeDataInteger16', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeDataInteger24, 'ASN1EncodeDataInteger24', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeDataInteger32, 'ASN1EncodeDataInteger32', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeDataInteger64, 'ASN1EncodeDataInteger64', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInteger8, 'ASN1EncodeInteger8', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInteger16, 'ASN1EncodeInteger16', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInteger24, 'ASN1EncodeInteger24', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInteger32, 'ASN1EncodeInteger32', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInteger64, 'ASN1EncodeInteger64', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeIntegerBuf, 'ASN1EncodeIntegerBuf', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeIntegerBufStr, 'ASN1EncodeIntegerBufStr', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeEnumerated, 'ASN1EncodeEnumerated', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeBitString, 'ASN1EncodeBitString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeOctetString, 'ASN1EncodeOctetString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeInt32AsOctetString, 'ASN1EncodeInt32AsOctetString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeUTF8String, 'ASN1EncodeUTF8String', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeIA5String, 'ASN1EncodeIA5String', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeVisibleString, 'ASN1EncodeVisibleString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeNumericString, 'ASN1EncodeNumericString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodePrintableString, 'ASN1EncodePrintableString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeTeletexString, 'ASN1EncodeTeletexString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeUniversalString, 'ASN1EncodeUniversalString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeBMPString, 'ASN1EncodeBMPString', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeUTCTime, 'ASN1EncodeUTCTime', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeGeneralizedTime, 'ASN1EncodeGeneralizedTime', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeOID, 'ASN1EncodeOID', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeSequence, 'ASN1EncodeSequence', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeSet, 'ASN1EncodeSet', cdRegister);
 S.RegisterDelphiFunction(@ASN1EncodeContextSpecific, 'ASN1EncodeContextSpecific', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeLength, 'ASN1DecodeLength', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeObjHeader, 'ASN1DecodeObjHeader', cdRegister);
 S.RegisterDelphiFunction(@ASN1TypeIsConstructedType, 'ASN1TypeIsConstructedType', cdRegister);
 S.RegisterDelphiFunction(@ASN1TypeIsContextSpecific, 'ASN1TypeIsContextSpecific', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataBoolean, 'ASN1DecodeDataBoolean', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataInteger32, 'ASN1DecodeDataInteger32', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataInteger64, 'ASN1DecodeDataInteger64', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataIntegerBuf, 'ASN1DecodeDataIntegerBuf', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataBitString, 'ASN1DecodeDataBitString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataRawAnsiString, 'ASN1DecodeDataRawAnsiString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataOctetString, 'ASN1DecodeDataOctetString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataIA5String, 'ASN1DecodeDataIA5String', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataVisibleString, 'ASN1DecodeDataVisibleString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataNumericString, 'ASN1DecodeDataNumericString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataPrintableString, 'ASN1DecodeDataPrintableString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataTeletexString, 'ASN1DecodeDataTeletexString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataUTF8String, 'ASN1DecodeDataUTF8String', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataUniversalString, 'ASN1DecodeDataUniversalString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataBMPString, 'ASN1DecodeDataBMPString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataOID, 'ASN1DecodeDataOID', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataUTCTime, 'ASN1DecodeDataUTCTime', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeDataGeneralizedTime, 'ASN1DecodeDataGeneralizedTime', cdRegister);
 S.RegisterDelphiFunction(@ASN1Parse, 'ASN1Parse', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeBoolean, 'ASN1DecodeBoolean', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeInteger32, 'ASN1DecodeInteger32', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeInteger64, 'ASN1DecodeInteger64', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeIntegerBuf, 'ASN1DecodeIntegerBuf', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeBitString, 'ASN1DecodeBitString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeString, 'ASN1DecodeString', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeOID, 'ASN1DecodeOID', cdRegister);
 S.RegisterDelphiFunction(@ASN1DecodeTime, 'ASN1DecodeTime', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestASN1', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cASN1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EASN1) do
end;

 
 
{ TPSImport_cASN1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cASN1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cASN1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cASN1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cASN1(ri);
  RIRegister_cASN1_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
