unit uPSI_cX509Certificate;
{
with fundamentals to cryptobox5 and securecenter5

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
  TPSImport_cX509Certificate = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cX509Certificate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cX509Certificate_Routines(S: TPSExec);
procedure RIRegister_cX509Certificate(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cASN1
  ,cX509Certificate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cX509Certificate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cX509Certificate(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EX509');
  CL.AddTypeS('TX509AttributeType', 'TASN1ObjectIdentifier');
  CL.AddTypeS('TX509AttributeValue', 'AnsiString');
  CL.AddTypeS('TX509AttributeTypeAndValue', 'record AType : TX509AttributeType;'
   +' Value : TX509AttributeValue; _Decoded : Boolean; end');
  //CL.AddTypeS('PX509AttributeTypeAndValue', '^TX509AttributeTypeAndValue // wil not work');
 CL.AddDelphiFunction('Procedure InitX509AttributeTypeAndValue( var A : TX509AttributeTypeAndValue; const AType : TX509AttributeType; const Value : TX509AttributeValue)');
 CL.AddDelphiFunction('Procedure InitX509AtName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtSurname( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtGivenName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtInitials( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtGenerationQuailifier( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtCommonName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtLocailityName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtStateOrProvince( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtOriganizationName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtOriganizationUnitName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtTitle( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtDnQualifier( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtCountryName( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AtEmailAddress( var A : TX509AttributeTypeAndValue; const B : AnsiString)');
 CL.AddDelphiFunction('Function EncodeX509AttributeTypeAndValue( const A : TX509AttributeTypeAndValue) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509AttributeTypeAndValue( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509AttributeTypeAndValue) : Integer');
  CL.AddTypeS('TX509RelativeDistinguishedName', 'array of TX509AttributeTypeAndValue');
 // CL.AddTypeS('PX509RelativeDistinguishedName', '^TX509RelativeDistinguishedName // will not work');
 CL.AddDelphiFunction('Procedure AppendX509RelativeDistinguishedName( var A : TX509RelativeDistinguishedName; const V : TX509AttributeTypeAndValue)');
 CL.AddDelphiFunction('Function EncodeX509RelativeDistinguishedName( const A : TX509RelativeDistinguishedName) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509RelativeDistinguishedName( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509RelativeDistinguishedName) : Integer');
  CL.AddTypeS('TX509RDNSequence', 'array of TX509RelativeDistinguishedName');
  //CL.AddTypeS('PX509RDNSequence', '^TX509RDNSequence // will not work');
  CL.AddTypeS('TX509Name', 'TX509RDNSequence');
 CL.AddDelphiFunction('Procedure AppendX509RDNSequence( var A : TX509RDNSequence; const B : TX509RelativeDistinguishedName)');
 CL.AddDelphiFunction('Function EncodeX509RDNSequence( const A : TX509RDNSequence) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509RDNSequence( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509RDNSequence) : Integer');
 CL.AddDelphiFunction('Function EncodeX509Name( const A : TX509Name) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Name( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Name) : Integer');
 CL.AddConstantN('CurrentX509Version','string').SetString(' X509v3');

 (*type
  TX509Version = (
      X509v1 = 0,
      X509v2 = 1,
      X509v3 = 2,
      X509vUndefined = $FF // implementation defined value   );
  *)
  CL.AddTypeS('TX509Version', '(X509v1, X509v2,X509v3, X509vUndefined)');


 { type
  TX509GeneralNameType = (
    gnOtherName                 = 0,
    gnRFC822Name                = 1,
    gnDNSName                   = 2,
    gnX400Address               = 3,
    gnDirectoryName             = 4,
    gnEDIPartyName              = 5,
    gnUniformResourceIdentifier = 6,
    gnIPAddress                 = 7,
    gnRegisteredID              = 8);  }

  CL.AddTypeS('TX509GeneralNameType', '(gnOtherName, gnRFC822Name,gnDNSName, gnX400Address,gnDirectoryName,gnEDIPartyName,gnUniformResourceIdentifier,gnIPAddress,gnRegisteredID)');


 CL.AddDelphiFunction('Procedure InitX509Version( var A : TX509Version)');
 CL.AddDelphiFunction('Function EncodeX509Version( const A : TX509Version) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Version( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Version) : Integer');
  CL.AddTypeS('TX509Time', 'TDateTime');
 CL.AddDelphiFunction('Function EncodeX509Time( const A : TX509Time) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Time( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Time) : Integer');
  CL.AddTypeS('TX509Validity', 'record NotBefore : TX509Time; NotAfter : TX509Time; _Decoded : Boolean; end');
 // CL.AddTypeS('PX509Validity', '^TX509Validity // will not work');
 CL.AddDelphiFunction('Function EncodeX509Validity( const A : TX509Validity) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Validity( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Validity) : Integer');
  CL.AddTypeS('TX509DHValidationParms', 'record Seed : AnsiString; PgenCounter : Integer; end');
  //CL.AddTypeS('PX509DHValidationParms', '^TX509DHValidationParms // will not work');
  CL.AddTypeS('TX509DHDomainParameters', 'record P : AnsiString; G : AnsiString'
   +'; Q : AnsiString; J : AnsiString; ValidationParms : TX509DHValidationParms; end');
 // CL.AddTypeS('PX509DHDomainParameters', '^TX509DHDomainParameters // will not work');
 CL.AddDelphiFunction('Function EncodeX509DHValidationParms( const A : TX509DHValidationParms) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509DHValidationParms( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509DHValidationParms) : Integer');
 CL.AddDelphiFunction('Function EncodeX509DHDomainParameters( const A : TX509DHDomainParameters) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509DHDomainParameters( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509DHDomainParameters) : Integer');
  CL.AddTypeS('TX509DSSParms', 'record P : AnsiString; Q : AnsiString; G : AnsiString; end');
  //CL.AddTypeS('PX509DSSParms', '^TX509DSSParms // will not work');
 CL.AddDelphiFunction('Function EncodeX509DSSParms( const A : TX509DSSParms) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509DSSParms( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509DSSParms) : Integer');
  CL.AddTypeS('TX509DSSSigValue', 'record R : AnsiString; S : AnsiString; end');
  //CL.AddTypeS('PX509DSSSigValue', '^TX509DSSSigValue // will not work');
 CL.AddDelphiFunction('Function EncodeX509DSSSigValue( const A : TX509DSSSigValue) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509DSSSigValue( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509DSSSigValue) : Integer');
  CL.AddTypeS('TX509AlgorithmIdentifier', 'record Algorithm : TASN1ObjectIdenti'
   +'fier; Parameters : AnsiString; _Decoded : Boolean; end');
//  CL.AddTypeS('PX509AlgorithmIdentifier', '^TX509AlgorithmIdentifier // will not work');
 CL.AddDelphiFunction('Procedure InitX509AlgorithmIdentifier( var A : TX509AlgorithmIdentifier; const Algorithm : array of Integer; const Parameters : AnsiString)');
 CL.AddDelphiFunction('Procedure InitX509AlgorithmIdentifierDSA_SHA1( var A : TX509AlgorithmIdentifier; const Parameters : AnsiString)');
 CL.AddDelphiFunction('Function EncodeX509AlgorithmIdentifier( const A : TX509AlgorithmIdentifier) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509AlgorithmIdentifier( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509AlgorithmIdentifier) : Integer');
  CL.AddTypeS('TX509RSAPublicKey', 'record Modulus : AnsiString; PublicExponent: AnsiString; end');
  //CL.AddTypeS('PX509RSAPublicKey', '^TX509RSAPublicKey // will not work');
 CL.AddDelphiFunction('Function EncodeX509RSAPublicKey( const A : TX509RSAPublicKey) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509RSAPublicKey( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509RSAPublicKey) : Integer');
 CL.AddDelphiFunction('Function ParseX509RSAPublicKey( const Buf : string; const Size : Integer; var A : TX509RSAPublicKey) : Integer');
  CL.AddTypeS('TX509DHPublicKey', 'AnsiString');
 CL.AddDelphiFunction('Function EncodeX509DHPublicKey( const A : TX509DHPublicKey) : AnsiString');
  CL.AddTypeS('TX509DSAPublicKey', 'AnsiString');
 CL.AddDelphiFunction('Function EncodeX509DSAPublicKey( const A : TX509DSAPublicKey) : AnsiString');
  CL.AddTypeS('TX509SubjectPublicKeyInfo', 'record Algorithm : TX509AlgorithmId'
   +'entifier; SubjectPublicKey : AnsiString; _Decoded : Boolean; end');
  //CL.AddTypeS('PX509SubjectPublicKeyInfo', '^TX509SubjectPublicKeyInfo // will not work');
 CL.AddDelphiFunction('Procedure InitX509SubjectPublicKeyInfoDSA( var A : TX509SubjectPublicKeyInfo; const B : TX509DSSParms; const PublicKey : AnsiString)');
 CL.AddDelphiFunction('Function EncodeX509SubjectPublicKeyInfo( const A : TX509SubjectPublicKeyInfo) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509SubjectPublicKeyInfo( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509SubjectPublicKeyInfo) : Integer');
 CL.AddDelphiFunction('Function ParseX509SubjectPublicKeyInfo( const Buf : string; const Size : Integer; var A : TX509SubjectPublicKeyInfo) : Integer');
 CL.AddDelphiFunction('Function EncodeX509GeneralName( const A : TX509GeneralNameType; const EncodedName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509GeneralName( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509GeneralNameType; var B : AnsiString) : Integer');
  CL.AddTypeS('TX509GeneralNames', 'array of record NameType : TX509GeneralNameType; Name : AnsiString; end');
  //CL.AddTypeS('PX509GeneralNames', '^TX509GeneralNames // will not work');
 CL.AddDelphiFunction('Function EncodeX509GeneralNames( const A : TX509GeneralNames) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509GeneralNames( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509GeneralNames) : Integer');
  CL.AddTypeS('TX509BasicConstraints', 'record CA : Boolean; PathLenConstraint : AnsiString; _DecodedCA : Boolean; end');
  //CL.AddTypeS('PX509BasicConstraints', '^TX509BasicConstraints // will not work');
 CL.AddDelphiFunction('Function EncodeX509BasicConstraints( const A : TX509BasicConstraints) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509BasicConstraints( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509BasicConstraints) : Integer');
  CL.AddTypeS('TX509AuthorityKeyIdentifier', 'record KeyIdentifier : AnsiString'
   +'; AuthorityCertIssuer : TX509GeneralNames; AuthorityCertSerialNumber : Int64; end');
  //CL.AddTypeS('PX509AuthorityKeyIdentifier', '^TX509AuthorityKeyIdentifier // will not work');
 CL.AddDelphiFunction('Function EncodeX509AuthorityKeyIdentifier( const A : TX509AuthorityKeyIdentifier) : AnsiString');
  CL.AddTypeS('TX509SubjectKeyIdentifier', 'AnsiString');
  CL.AddTypeS('TX509KeyUsage', 'AnsiString');
  CL.AddTypeS('TX509Extension', 'record ExtnID : TASN1ObjectIdentifier; Critica'
   +'l : Boolean; ExtnValue : AnsiString; _DecodedCritical : Boolean; _Decoded : Boolean; end');
  //CL.AddTypeS('PX509Extension', '^TX509Extension // will not work');
 CL.AddDelphiFunction('Procedure InitX509ExtAuthorityKeyIdentifier( var A : TX509Extension; const B : TX509AuthorityKeyIdentifier)');
 CL.AddDelphiFunction('Procedure InitX509ExtSubjectKeyIdentifier( var A : TX509Extension; const B : TX509SubjectKeyIdentifier)');
 CL.AddDelphiFunction('Procedure InitX509ExtBasicConstraints( var A : TX509Extension; const B : TX509BasicConstraints)');
 CL.AddDelphiFunction('Function EncodeX509Extension( const A : TX509Extension) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Extension( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Extension) : Integer');
  CL.AddTypeS('TX509Extensions', 'array of TX509Extension');
  //CL.AddTypeS('PX509Extensions', '^TX509Extensions // will not work');
 CL.AddDelphiFunction('Procedure AppendX509Extensions( var A : TX509Extensions; const B : TX509Extension)');
 CL.AddDelphiFunction('Function EncodeX509Extensions( const A : TX509Extensions) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Extensions( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Extensions) : Integer');
 CL.AddDelphiFunction('Function NormaliseX509IntKeyBuf( var KeyBuf : AnsiString) : Integer');
  CL.AddTypeS('TX509TBSCertificate', 'record Version : TX509Version; SerialNumb'
   +'er : AnsiString; Signature : TX509AlgorithmIdentifier; Issuer : TX509Name;'
   +' Validity : TX509Validity; Subject : TX509Name; SubjectPublicKeyInfo : TX5'
   +'09SubjectPublicKeyInfo; IssuerUniqueID : AnsiString; SubjectUniqueID : Ans'
   +'iString; Extensions : TX509Extensions; _DecodedVersion : Boolean; _Decoded: Boolean; end');
 // CL.AddTypeS('PX509TBSCertificate', '^TX509TBSCertificate // will not work');
 CL.AddDelphiFunction('Function EncodeX509TBSCertificate( const A : TX509TBSCertificate) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509TBSCertificate( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509TBSCertificate) : Integer');
  CL.AddTypeS('TX509Certificate', 'record TBSCertificate : TX509TBSCertificate;'
   +' SignatureAlgorithm : TX509AlgorithmIdentifier; SignatureValue : AnsiString; _Decoded : Boolean; end');
 // CL.AddTypeS('PX509Certificate', '^TX509Certificate // will not work');
  CL.AddTypeS('TX509CertificateArray', 'array of TX509Certificate');
 CL.AddDelphiFunction('Procedure InitX509Certificate( var A : TX509Certificate)');
 CL.AddDelphiFunction('Function EncodeX509Certificate( const A : TX509Certificate) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509Certificate( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509Certificate) : Integer');
 CL.AddDelphiFunction('Function ParseX509Certificate( const Buf : string; const Size : Integer; var A : TX509Certificate) : Integer');
 CL.AddDelphiFunction('Procedure ParseX509CertificateStr( const BufStr : AnsiString; var A : TX509Certificate)');
 CL.AddDelphiFunction('Procedure ParseX509CertificatePEM( const BufStr : AnsiString; var A : TX509Certificate)');
  CL.AddTypeS('TX509RSAPrivateKey', 'record Version : Integer; Modulus : AnsiSt'
   +'ring; PublicExponent : AnsiString; PrivateExponent : AnsiString; Prime1 : '
   +'AnsiString; Prime2 : AnsiString; Exponent1 : AnsiString; Exponent2 : AnsiString; CRTCoefficient : AnsiString; _Decoded : Boolean; end');
 // CL.AddTypeS('PX509RSAPrivateKey', '^TX509RSAPrivateKey // will not work');
 CL.AddDelphiFunction('Function EncodeX509RSAPrivateKey( const A : TX509RSAPrivateKey) : AnsiString');
 CL.AddDelphiFunction('Function DecodeX509RSAPrivateKey( const TypeID : Byte; const Buf : string; const Size : Integer; var A : TX509RSAPrivateKey) : Integer');
 CL.AddDelphiFunction('Function ParseX509RSAPrivateKey( const Buf : string; const Size : Integer; var A : TX509RSAPrivateKey) : Integer');
 CL.AddDelphiFunction('Procedure ParseX509RSAPrivateKeyStr( const BufStr : AnsiString; var A : TX509RSAPrivateKey)');
 CL.AddDelphiFunction('Procedure ParseX509RSAPrivateKeyPEM( const BufStr : AnsiString; var A : TX509RSAPrivateKey)');
 CL.AddDelphiFunction('Procedure SelfTestX509');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cX509Certificate_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitX509AttributeTypeAndValue, 'InitX509AttributeTypeAndValue', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtName, 'InitX509AtName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtSurname, 'InitX509AtSurname', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtGivenName, 'InitX509AtGivenName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtInitials, 'InitX509AtInitials', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtGenerationQuailifier, 'InitX509AtGenerationQuailifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtCommonName, 'InitX509AtCommonName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtLocailityName, 'InitX509AtLocailityName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtStateOrProvince, 'InitX509AtStateOrProvince', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtOriganizationName, 'InitX509AtOriganizationName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtOriganizationUnitName, 'InitX509AtOriganizationUnitName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtTitle, 'InitX509AtTitle', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtDnQualifier, 'InitX509AtDnQualifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtCountryName, 'InitX509AtCountryName', cdRegister);
 S.RegisterDelphiFunction(@InitX509AtEmailAddress, 'InitX509AtEmailAddress', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509AttributeTypeAndValue, 'EncodeX509AttributeTypeAndValue', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509AttributeTypeAndValue, 'DecodeX509AttributeTypeAndValue', cdRegister);
 S.RegisterDelphiFunction(@AppendX509RelativeDistinguishedName, 'AppendX509RelativeDistinguishedName', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509RelativeDistinguishedName, 'EncodeX509RelativeDistinguishedName', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509RelativeDistinguishedName, 'DecodeX509RelativeDistinguishedName', cdRegister);
 S.RegisterDelphiFunction(@AppendX509RDNSequence, 'AppendX509RDNSequence', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509RDNSequence, 'EncodeX509RDNSequence', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509RDNSequence, 'DecodeX509RDNSequence', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Name, 'EncodeX509Name', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Name, 'DecodeX509Name', cdRegister);
 S.RegisterDelphiFunction(@InitX509Version, 'InitX509Version', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Version, 'EncodeX509Version', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Version, 'DecodeX509Version', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Time, 'EncodeX509Time', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Time, 'DecodeX509Time', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Validity, 'EncodeX509Validity', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Validity, 'DecodeX509Validity', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DHValidationParms, 'EncodeX509DHValidationParms', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509DHValidationParms, 'DecodeX509DHValidationParms', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DHDomainParameters, 'EncodeX509DHDomainParameters', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509DHDomainParameters, 'DecodeX509DHDomainParameters', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DSSParms, 'EncodeX509DSSParms', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509DSSParms, 'DecodeX509DSSParms', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DSSSigValue, 'EncodeX509DSSSigValue', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509DSSSigValue, 'DecodeX509DSSSigValue', cdRegister);
 S.RegisterDelphiFunction(@InitX509AlgorithmIdentifier, 'InitX509AlgorithmIdentifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509AlgorithmIdentifierDSA_SHA1, 'InitX509AlgorithmIdentifierDSA_SHA1', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509AlgorithmIdentifier, 'EncodeX509AlgorithmIdentifier', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509AlgorithmIdentifier, 'DecodeX509AlgorithmIdentifier', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509RSAPublicKey, 'EncodeX509RSAPublicKey', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509RSAPublicKey, 'DecodeX509RSAPublicKey', cdRegister);
 S.RegisterDelphiFunction(@ParseX509RSAPublicKey, 'ParseX509RSAPublicKey', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DHPublicKey, 'EncodeX509DHPublicKey', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509DSAPublicKey, 'EncodeX509DSAPublicKey', cdRegister);
 S.RegisterDelphiFunction(@InitX509SubjectPublicKeyInfoDSA, 'InitX509SubjectPublicKeyInfoDSA', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509SubjectPublicKeyInfo, 'EncodeX509SubjectPublicKeyInfo', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509SubjectPublicKeyInfo, 'DecodeX509SubjectPublicKeyInfo', cdRegister);
 S.RegisterDelphiFunction(@ParseX509SubjectPublicKeyInfo, 'ParseX509SubjectPublicKeyInfo', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509GeneralName, 'EncodeX509GeneralName', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509GeneralName, 'DecodeX509GeneralName', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509GeneralNames, 'EncodeX509GeneralNames', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509GeneralNames, 'DecodeX509GeneralNames', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509BasicConstraints, 'EncodeX509BasicConstraints', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509BasicConstraints, 'DecodeX509BasicConstraints', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509AuthorityKeyIdentifier, 'EncodeX509AuthorityKeyIdentifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509ExtAuthorityKeyIdentifier, 'InitX509ExtAuthorityKeyIdentifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509ExtSubjectKeyIdentifier, 'InitX509ExtSubjectKeyIdentifier', cdRegister);
 S.RegisterDelphiFunction(@InitX509ExtBasicConstraints, 'InitX509ExtBasicConstraints', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Extension, 'EncodeX509Extension', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Extension, 'DecodeX509Extension', cdRegister);
 S.RegisterDelphiFunction(@AppendX509Extensions, 'AppendX509Extensions', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Extensions, 'EncodeX509Extensions', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Extensions, 'DecodeX509Extensions', cdRegister);
 S.RegisterDelphiFunction(@NormaliseX509IntKeyBuf, 'NormaliseX509IntKeyBuf', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509TBSCertificate, 'EncodeX509TBSCertificate', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509TBSCertificate, 'DecodeX509TBSCertificate', cdRegister);
 S.RegisterDelphiFunction(@InitX509Certificate, 'InitX509Certificate', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509Certificate, 'EncodeX509Certificate', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509Certificate, 'DecodeX509Certificate', cdRegister);
 S.RegisterDelphiFunction(@ParseX509Certificate, 'ParseX509Certificate', cdRegister);
 S.RegisterDelphiFunction(@ParseX509CertificateStr, 'ParseX509CertificateStr', cdRegister);
 S.RegisterDelphiFunction(@ParseX509CertificatePEM, 'ParseX509CertificatePEM', cdRegister);
 S.RegisterDelphiFunction(@EncodeX509RSAPrivateKey, 'EncodeX509RSAPrivateKey', cdRegister);
 S.RegisterDelphiFunction(@DecodeX509RSAPrivateKey, 'DecodeX509RSAPrivateKey', cdRegister);
 S.RegisterDelphiFunction(@ParseX509RSAPrivateKey, 'ParseX509RSAPrivateKey', cdRegister);
 S.RegisterDelphiFunction(@ParseX509RSAPrivateKeyStr, 'ParseX509RSAPrivateKeyStr', cdRegister);
 S.RegisterDelphiFunction(@ParseX509RSAPrivateKeyPEM, 'ParseX509RSAPrivateKeyPEM', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestX509', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cX509Certificate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EX509) do
end;

 
 
{ TPSImport_cX509Certificate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cX509Certificate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cX509Certificate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cX509Certificate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cX509Certificate(ri);
  RIRegister_cX509Certificate_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
