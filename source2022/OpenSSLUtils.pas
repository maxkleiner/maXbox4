(******************************************************************************
 Utility module for OpenSSL for Delphi, version 0.5, 2010-10-23

 For OpenSSL version 0.9.6b, DLL compiled by GnuWin32.

 Author: Marco Ferrante
 Copyright (C) 2002-2006, CSITA - Universit� di Genova. (http://www.csita.unige.it/)
 Copyright (C) 2007-2008, DISI - Universit� di Genova. (http://www.disi.unige.it/)

 Please, if you use this module in some product, we will appreciate if
 you write a credit like:

   "With a contribute of Univerity of Genoa (Italy) http://www.unige.it/"

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Library General Public
 License as published by the Free Software Foundation; either
 version 2 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Library General Public License for more details.

 You should have received a copy of the GNU Library General Public
 License along with this library; if not, write to the Free
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 Adaptado por Pablo Romero (c) 2010 Cordoba, Argentina
******************************************************************************)
unit OpenSSLUtils;

interface
uses libeay32, SysUtils;

type
EOpenSSL = class(Exception)
  OpenSSLError: integer;
  OpenSSLErrorMessage: string;
  constructor Create(Msg: string);
end;

TEncoding = (auto, PEM, DER, SMIME, NETSCAPE, PKCS12);

TKeyPairGenerator = class
  private
    fKeyLength: word;
    fPassword: string;
    fPrivateKeyFile, fPublicKeyFile: TFileName;
    fSeedFile: TFileName;
  protected
    procedure fSetKeyLength(l: word);
  public
    constructor Create;
    procedure KeyFileNames(KeyPairNames: string); overload;
    procedure KeyFileNames(PrivateKeyName, PublicKeyName: TFileName); overload;
    procedure GenerateRSA;
    property KeyLength: word read fKeyLength write fSetKeyLength default 1024;
    property Password: string write fPassword;
    property SeedFile: TFileName read fSeedFile write fSeedFile;
end;

TX509Certificate = class
  private
    fCertificate: pX509;
    function getDN(pDn: pX509_NAME): String;
    function getTime(asn1_time: pASN1_TIME): TDateTime;
  protected
    constructor Create(pCert: pX509); overload;
    function getIssuer: String;
    function getSubject: String;
    function getNotBefore: TDateTime;
    function getNotAfter: TDateTime;
    function VerifyCalback(ok: integer; ctx: pX509_STORE_CTX): integer;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property Issuer: String read getIssuer;
    property Subject: String read getSubject;
    property NotBefore: TDateTime read getNotBefore;
    property NotAfter: TDateTime read getNotAfter;
    function IsTrusted(CACertificate: array of TX509Certificate): boolean; overload;
    function IsTrusted(CACertificate: TX509Certificate): boolean; overload;
    function IsExpired: boolean;
    function Text: String;
    procedure LoadFromFile(FileName: string); overload;
    procedure LoadFromFile(FileName: string; Encoding: TEncoding); overload;
  end;
TX509CertificateArray = array of TX509Certificate;

TPKCS7 = class
  private
    fEncoding: TEncoding;
    fPkcs7: pPKCS7;
    fCerts: pSTACK_OFX509;
    fDetachedData: pBIO;
  protected
    function countCerts: integer;
    function getCert(i: integer): TX509Certificate;
  public
    constructor Create;
    destructor Destroy; override;
    property Encoding: TEncoding read fEncoding write fEncoding default auto;
    property CountCertificate: integer read countCerts;
    property Certificate[Index: Integer]: TX509Certificate read getCert;
    procedure Open(FileName: string);
    procedure Save(Filename: String); overload;
    procedure Save(Filename: String; Encoding: TEncoding); overload;
    procedure SaveContent(Filename: String);
    function VerifyData: boolean; overload;
    function VerifyData(Content: pointer): boolean; overload;
  end;

TMessageSigner = class
  private
    fCertificate, fOtherCertificates: pX509;
    fKey: pEVP_PKEY;
    fMessage: ansistring;
    fPrivateKeyFile, fCertificateFile, fOtherCertificateFile: TFileName;
    fPassword: ansistring;
    fSignedMessage: ansistring;
  public
    constructor Create;
    procedure MIMESign;
    procedure LoadPrivateKey(KeyFilename: TFileName); overload;
    procedure LoadPrivateKey(KeyFilename: TFileName; KeyPassword: ansistring); overload;
    procedure LoadCertificate(CertificateFilename: TFileName);
    property Password: ansistring write fPassword;
    property PrivateKeyFile: TFileName read fPrivateKeyFile write fPrivateKeyFile;
    property CertificateFile: TFileName read fCertificateFile write fCertificateFile;
    property PlainMessage: ansistring read fMessage write fMessage;
    property SignedMessage: ansistring read fSignedMessage;
end;

// Initialize library
procedure AppStartup;

// Return last error message
function GetErrorMessage: string;

implementation

uses DateUtils;

constructor EOpenSSL.Create(Msg: string);
begin
inherited Create(Msg);
OpenSSLError := ERR_get_error;
OpenSSLErrorMessage := GetErrorMessage;
end;

(************************************
  Private functions
************************************)
// Convert encoding from Pascal type to OpenSSL int constants
function cvOpenSSLEncoding(Encoding: TEncoding): integer;
begin
result := FORMAT_UNDEF;
case Encoding of
  DER: result := FORMAT_ASN1;
  PEM: result := FORMAT_PEM;
  NETSCAPE: result := FORMAT_NETSCAPE;
  PKCS12: result := FORMAT_PKCS12;
  (*
  FORMAT_TEXT = 2;
  FORMAT_PEM = 3;
  FORMAT_NETSCAPE = 4;
  FORMAT_PKCS12 = 5;
  FORMAT_SMIME = 6;*)
  end;
end;

procedure AppStartup;
begin
//_fmode := _O_BINARY;
//do_pipe_sig;
//CRYPTO_malloc_init();
OpenSSL_add_all_algorithms;
OpenSSL_add_all_ciphers;
OpenSSL_add_all_digests;
ERR_load_crypto_strings;
end;

function GetErrorMessage: string;
var
  ErrMsg: array [0..160] of char;
begin
ERR_error_string(ERR_get_error, @ErrMsg);
result := StrPas( pansichar(@ErrMsg) );
end;

(*
  KeyPair Generator
*)
constructor TKeyPairGenerator.Create;
var
  TmpDir: string;
  TmpFile: TSearchRec;
begin
fKeyLength := 1024;
fPassword := '';
TmpDir := GetEnvironmentVariable('TEMP');
if FindFirst(TmpDir + '\*', faReadOnly and faHidden and faSysFile and faArchive,
      TmpFile) = 0 then
  fSeedFile := TmpFile.Name;
FindClose(TmpFile);
end;

// TODO: checking key length and throw exception
procedure TKeyPairGenerator.fSetKeyLength(l: word);
begin
fKeyLength := l;
end;

// File name without extension
procedure TKeyPairGenerator.KeyFileNames(KeyPairNames: string);
begin
KeyFileNames(KeyPairNames + '.key', KeyPairNames + '.pub');
end;

procedure TKeyPairGenerator.KeyFileNames(PrivateKeyName, PublicKeyName: TFileName);
begin
fPrivateKeyFile := PrivateKeyName;
fPublicKeyFile := PublicKeyName;
end;

procedure TKeyPairGenerator.GenerateRSA;
var
  rsa: pRSA;
  PrivateKeyOut, PublicKeyOut, ErrMsg: pBIO;
  buff: array [0..1023] of char;
  enc: pEVP_CIPHER;
begin
if (fPrivateKeyFile = '') or (fPublicKeyFile = '') then
  raise EOpenSSL.Create('Key filenames must be specified.');
if (fPassword = '') then
  raise EOpenSSL.Create('A password must be specified.');

ERR_load_crypto_strings;
OpenSSL_add_all_ciphers;

enc := EVP_des_ede3_cbc; ///??????

// Load a pseudo random file
RAND_load_file(PChar(fSeedFile), -1);

rsa := RSA_generate_key(fKeyLength, RSA_F4, nil, ErrMsg);
if rsa=nil then
  begin
  BIO_reset(ErrMsg);
  BIO_read(ErrMsg, @buff, 1024);
  raise EOpenSSL.Create(PChar(@buff));
  end;

PrivateKeyOut := BIO_new(BIO_s_file());
BIO_write_filename(PrivateKeyOut, PChar(fPrivateKeyFile));
PublicKeyOut := BIO_new(BIO_s_file());
BIO_write_filename(PublicKeyOut, PChar(fPublicKeyFile));

PEM_write_bio_RSAPrivateKey(PrivateKeyOut, rsa, enc, nil, 0, nil, PChar(fPassword));
PEM_write_bio_RSAPublicKey(PublicKeyOut, rsa);

if rsa <> nil then RSA_free(rsa);
if PrivateKeyOut <> nil then BIO_free_all(PrivateKeyOut);
if PublicKeyOut <> nil then BIO_free_all(PublicKeyOut);
end;

(*
  X509 Certificate
*)
constructor TX509Certificate.Create;
begin
fCertificate := nil;
end;

constructor TX509Certificate.Create(pCert: pX509);
begin
fCertificate := pCert;
end;

destructor TX509Certificate.Destroy;
begin
if fCertificate<>nil then
  X509_free(fCertificate);
end;

function TX509Certificate.getDN(pDn: pX509_NAME): String;
var
  buffer: array [0..1023] of char;
begin
X509_NAME_oneline(pDn, @buffer, SizeOf(buffer));
result := StrPas( pansichar( @buffer) );
end;

// Extract a ASN1 time
function TX509Certificate.getTime(asn1_time: pASN1_TIME): TDateTime;
var
  buffer: array [0..31] of char;
  tz, Y, M, D, h, n, s: integer;
//  tmpbio: pBIO;

  function Char2Int(d, u: char): integer;
  begin
  if (d < '0') or (d > '9') or (u < '0') or (u > '9') then
    raise EOpenSSL.Create('Invalid ASN1 date format (invalid char).');
  result := (Ord(d) - Ord('0'))*10 + Ord(u) - Ord('0');
  end;

begin
{
i2d_ASN1_TIME(asn1_time, @buffer2);
if buffer='' then
  result := time
else
  result := 0;
}
if (asn1_time.asn1_type <> V_ASN1_UTCTIME)
    and (asn1_time.asn1_type <> V_ASN1_GENERALIZEDTIME) then
  raise EOpenSSL.Create('Invalid ASN1 date format.');
tz := 0;
s := 0;
StrLCopy( pansichar( @buffer ), asn1_time.data, asn1_time.length);
if asn1_time.asn1_type = V_ASN1_UTCTIME then
  begin
  if asn1_time.length < 10 then
    raise EOpenSSL.Create('Invalid ASN1 UTC date format (too short).');
	Y := Char2Int(buffer[0], buffer[1]);
    if Y < 50 then
      Y := Y + 100;
    Y := Y + 1900;
    M := Char2Int(buffer[2], buffer[3]);
    D := Char2Int(buffer[4], buffer[5]);
    h := Char2Int(buffer[6], buffer[7]);
    n := Char2Int(buffer[8], buffer[9]);
    if (buffer[10] >= '0') and (buffer[10] <= '9')
        and (buffer[11] >= '0') and (buffer[11] <= '9') then
      s := Char2Int(buffer[10], buffer[11]);
    if buffer[asn1_time.length-1] = 'Z' then
      tz := 1;
  end
else if asn1_time.asn1_type = V_ASN1_GENERALIZEDTIME then
  begin
  if asn1_time.length < 12 then
    raise EOpenSSL.Create('Invalid ASN1 generic date format (too short).');
    Y := Char2Int(buffer[0], buffer[1])*100 + Char2Int(buffer[2], buffer[3]);;
	M := Char2Int(buffer[4], buffer[5]);
    D := Char2Int(buffer[6], buffer[7]);
    h := Char2Int(buffer[8], buffer[9]);
    n := Char2Int(buffer[10], buffer[11]);
    if (buffer[12] >= '0') and (buffer[12] <= '9')
        and (buffer[13] >= '0') and (buffer[13] <= '9') then
      s := Char2Int(buffer[12], buffer[13]);
    if buffer[asn1_time.length-1] = 'Z' then
      tz := 1;
  end;
if tz > 0 then
  result := IncHour(EncodeDateTime(Y, M, D, h, n, s, 0), tz)
else
  result := EncodeDateTime(Y, M, D, h, n, s, 0);
{tmpbio := BIO_new(BIO_s_mem());
ASN1_TIME_print(tmpbio, asn1_time);
BIO_read(tmpbio, @buffer, SizeOf(buffer));
BIO_free_all(tmpbio);
if buffer = '' then
  result := time
else
  result := time}
end;

function TX509Certificate.getIssuer: String;
begin
result := getDN(X509_get_issuer_name(fCertificate));
end;

function TX509Certificate.getSubject: String;
begin
result := getDN(X509_get_subject_name(fCertificate));
end;

function TX509Certificate.getNotBefore: TDateTime;
begin
result := getTime(X509_get_notBefore(fCertificate));
end;

function TX509Certificate.getNotAfter: TDateTime;
begin
result := getTime(X509_get_notAfter(fCertificate));
end;

// Output certificate as string
function TX509Certificate.Text: String;
var
  certOut: pBIO;
  buff: PChar;
  buffsize: integer;
begin
result := '';
certOut := BIO_new(BIO_s_mem);
X509_print(certOut, fCertificate);
buffsize := BIO_pending(certOut);
GetMem(buff, buffsize+1);
BIO_read(certOut, buff, buffsize);
result := StrPas(buff);
FreeMem(buff);
BIO_free(certOut);
end;

procedure TX509Certificate.LoadFromFile(FileName: string);
begin
LoadFromFile(Filename, auto);
end;

procedure TX509Certificate.LoadFromFile(FileName: string; Encoding: TEncoding);
var
  certfile: pBIO;
  p12: pPKCS12;
  a: pEVP_PKEY;
  c: pX509;
  ca: pSTACK_OFX509;
begin
if not(Encoding in [auto, DER, PEM, NETSCAPE, PKCS12]) then
  raise EOpenSSL.Create('Bad certificate encoding.');
certfile := BIO_new(BIO_s_file());
if certfile = nil then
  raise EOpenSSL.Create('Error creating BIO.');
BIO_read_filename(certfile, PChar(FileName));
if (Encoding = auto) or (encoding = DER) then
  begin
  fCertificate := d2i_X509_bio(certfile, nil);
  if (Encoding = auto) and (fCertificate = nil) then
    BIO_reset(certfile);
  end;
if ((Encoding = auto) and (fCertificate = nil)) or (encoding = NETSCAPE) then
  begin
  // See apps.c
  end;
if ((Encoding = auto) and (fCertificate = nil)) or (encoding = PEM) then
  begin
  fCertificate := PEM_read_bio_X509_AUX(certfile, c, nil, nil);
  if (Encoding = auto) and (fCertificate = nil) then
    BIO_reset(certfile);
  end;
if ((Encoding = auto) and (fCertificate = nil)) or (encoding = PKCS12) then
  begin
  p12 := d2i_PKCS12_bio(certfile, nil);
  PKCS12_parse(p12, nil, a, c, ca);
  fCertificate := c;
  PKCS12_free(p12);
  p12 := nil;
  end;
BIO_free(certfile);
if fCertificate = nil then
  raise EOpenSSL.Create('Unable to read certificate from file ' + FileName + '.');
end;

function TX509Certificate.VerifyCalback(ok: integer; ctx: pX509_STORE_CTX): integer;
var
  buffer: array [0..255] of char;
begin
if ok=0 then
  begin
		{
		X509_NAME_oneline(
				X509_get_subject_name(ctx->current_cert),buf,256);
		printf("%s\n",buf);
		printf("error %d at %d depth lookup:%s\n",ctx->error,
			ctx->error_depth,
			X509_verify_cert_error_string(ctx->error));
		if (ctx->error == X509_V_ERR_CERT_HAS_EXPIRED) ok=1;
		/* since we are just checking the certificates, it is
		 * ok if they are self signed. But we should still warn
		 * the user.
 		 */
		if (ctx->error == X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT) ok=1;
		/* Continue after extension errors too */
		if (ctx->error == X509_V_ERR_INVALID_CA) ok=1;
		if (ctx->error == X509_V_ERR_PATH_LENGTH_EXCEEDED) ok=1;
		if (ctx->error == X509_V_ERR_INVALID_PURPOSE) ok=1;
		if (ctx->error == X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT) ok=1;
		}
	//if (!v_verbose)
	//	ERR_clear_error();
	//return(ok);
  ok := 1;
  end;
result := ok;
end;

function TX509Certificate.IsTrusted(CACertificate: array of TX509Certificate): boolean;
var
  cert_ctx: pX509_STORE;
  // lookup: pX509_LOOKUP;
  csc: pX509_STORE_CTX;
  uchain: pSTACK_OFX509;  // Untrusted certs
  i, verify: integer;
begin
cert_ctx := X509_STORE_new();
if cert_ctx=nil then
  raise EOpenSSL.Create('Error creating X509_STORE.');
cert_ctx.verify_cb := nil;  // hum...........
// Load CA certificates
for i := 0 to High(CACertificate) do
  begin
  if X509_STORE_add_cert(cert_ctx, CACertificate[i].fCertificate) = 0 then
    raise EOpenSSL.Create('Unable to store X.509 cetrtificate.');
  end;
// Load untrustesd certificate
uchain := sk_new_null;
sk_push(uchain, fCertificate);
// Prepare certificate
csc := X509_STORE_CTX_new;
if csc = nil then
  raise EOpenSSL.Create('Error creating X509_STORE_CTX.');
X509_STORE_CTX_init(csc, cert_ctx, fCertificate, uchain);
verify := X509_verify_cert(csc);
X509_STORE_CTX_free(csc);
sk_free(uchain);
X509_STORE_free(cert_ctx);
result := verify = 1;
end;

function TX509Certificate.IsTrusted(CACertificate: TX509Certificate): boolean;
begin
result := false;
end;

function TX509Certificate.IsExpired: boolean;
var
  now: TDateTime;
begin
now := Time;
result := (NotBefore <= now) and (NotAfter >= now);
end;

(*
  PKCS7 reader
*)
constructor TPKCS7.Create;
begin
fEncoding := auto;
fPkcs7 := nil;
fCerts := nil;
fDetachedData := nil;
end;

destructor TPKCS7.Destroy;
begin
if fDetachedData <> nil then
  BIO_free(fDetachedData);
if fPkcs7 <> nil then
  PKCS7_free(fPkcs7);
end;

function TPKCS7.countCerts: integer;
begin
result := sk_num(fCerts);
end;

function TPKCS7.getCert(i: integer): TX509Certificate;
begin
result := TX509Certificate.Create(sk_value(fCerts, i));
end;

// Open a PKCS7 file
procedure TPKCS7.Open(Filename: string);
var
  p7file: pBIO;
  objectType: integer;
begin
p7file := BIO_new(BIO_s_file());
if p7file = nil then
  raise EOpenSSL.Create('Unable to create a file handle.');
BIO_read_filename(p7file, PChar(Filename));
if (fEncoding = auto) or (fEncoding = DER) then
  begin
  fPkcs7 := d2i_PKCS7_bio(p7file, nil);
  if (fPkcs7 = nil) and (fEncoding = auto) then
    BIO_reset(p7file);
  end;
if ((fPkcs7 = nil) and (fEncoding = auto)) or (fEncoding = PEM) then
  begin
  fPkcs7 := PEM_read_bio_PKCS7(p7file, nil, nil, nil);
  if (fPkcs7 = nil) and (fEncoding = auto) then
    BIO_reset(p7file);
  end;
if ((fPkcs7 = nil) and (fEncoding = auto)) or (fEncoding = SMIME) then
  begin
  fPkcs7 := SMIME_read_PKCS7(p7file, fDetachedData);  // &indata ????
  end;
if fPkcs7 = nil then
  raise EOpenSSL.Create('Unable to read PKCS7 file');
if p7file <> nil then
  BIO_free(p7file);
objectType := OBJ_obj2nid(fPkcs7.asn1_type);
case objectType of
  NID_pkcs7_signed: fCerts := fPkcs7.sign.cert;
  NID_pkcs7_signedAndEnveloped: fCerts := fPkcs7.signed_and_enveloped.cert;
  end;
end;

procedure TPKCS7.Save(Filename: String);
begin
Save(Filename, DER);
end;

procedure TPKCS7.Save(Filename: String; Encoding: TEncoding);
var
  pkcs7file: pBIO;
  result: integer;
begin
if not(Encoding in [DER, PEM]) then
  raise EOpenSSL.Create('Invalid output format.');
pkcs7file := BIO_new(BIO_s_file());
if BIO_write_filename(pkcs7file, PChar(Filename)) <= 0 then
  raise EOpenSSL.Create('Error creating output file.');
if Encoding = DER then
  result := i2d_PKCS7_bio(pkcs7file, fPkcs7);
if Encoding = PEM then
  result := PEM_write_bio_PKCS7(pkcs7file, fPkcs7);
if pkcs7file <> nil then
  BIO_free(pkcs7file);
if result = 0 then
  raise EOpenSSL.Create('Error writing output file.');
end;

procedure TPKCS7.SaveContent(Filename: String);
var
  p7bio, contentfile: pBIO;
  sinfos: pSTACK_OFPKCS7_SIGNER_INFO;
  i: integer;
  buffer: array [0..4096] of char;
begin
if fPkcs7 = nil then
  raise EOpenSSL.Create('No PKCS7 content.');
if OBJ_obj2nid(fPkcs7.asn1_type) <> NID_pkcs7_signed then
  raise EOpenSSL.Create('Wrong PKCS7 format.');
if (PKCS7_get_detached(fPkcs7) <> nil)
    and (fDetachedData = nil) then
  raise EOpenSSL.Create('PKCS7 has no content.');
sinfos := PKCS7_get_signer_info(fPkcs7);
if (sinfos = nil) or (sk_num(sinfos) = 0) then
  raise EOpenSSL.Create('No signature data.');

contentfile := BIO_new(BIO_s_file());
if BIO_write_filename(contentfile, PChar(Filename)) <= 0 then
  raise EOpenSSL.Create('Error creating output file.');
p7bio := PKCS7_dataInit(fPkcs7, fDetachedData);
repeat
  i := BIO_read(p7bio, @buffer, SizeOf(buffer));
  if i > 0 then
    BIO_write(contentfile, @buffer, i);
until i <= 0;

if fDetachedData <> nil then
  BIO_pop(p7bio);
BIO_free_all(p7bio);
BIO_free(contentfile);
end;

// Return true for data integrity check for nodetachted PKCS7
function TPKCS7.VerifyData: boolean;
begin
result := VerifyData(nil);
end;

// Return true for data integrity check for detachted PKCS7
function TPKCS7.VerifyData(Content: pointer): boolean;
var
  p7bio, tmpout: pBIO;
  sinfos: pSTACK_OFPKCS7_SIGNER_INFO;
  si: pPKCS7_SIGNER_INFO;
  signers: pSTACK_OFX509;
  signer: pX509;
  i: integer;
  buffer: array [0..4096] of char;
begin
result := true;
if fPkcs7 = nil then
  raise EOpenSSL.Create('No PKCS7 content.');
if OBJ_obj2nid(fPkcs7.asn1_type) <> NID_pkcs7_signed then
  raise EOpenSSL.Create('Wrong PKCS7 format.');
if (PKCS7_get_detached(fPkcs7) <> nil) and (fDetachedData = nil) then
  raise EOpenSSL.Create('PKCS7 has no content.');
sinfos := PKCS7_get_signer_info(fPkcs7);
if (sinfos = nil) or (sk_num(sinfos) = 0) then
  raise EOpenSSL.Create('No signature data.');
signers := PKCS7_get0_signers(fPkcs7, nil, 0);  //certs, flags);
p7bio := PKCS7_dataInit(fPkcs7, fDetachedData);

tmpout := BIO_new(BIO_s_mem());
repeat
  i := BIO_read(p7bio, @buffer, SizeOf(buffer));
  if i > 0 then
    BIO_write(tmpout, @buffer, i);
until i <= 0;

for i := 0 to sk_num(sinfos)-1 do
  begin
  si := sk_value(sinfos, i);
  signer := sk_value(signers, i);
  if PKCS7_signatureVerify(p7bio, fPkcs7, si, signer) <= 0 then
    begin
    result := false;
    break;
    end;
  end;
if fDetachedData <> nil then
  BIO_pop(p7bio);
BIO_free_all(p7bio);
sk_free(signers);
if (fDetachedData <> nil) then
  BIO_reset(fDetachedData);
end;

(*
  Message signer
*)
constructor TMessageSigner.Create;
begin
fKey := nil;
fCertificate := nil;
fOtherCertificates := nil;
ERR_load_crypto_strings;
OpenSSL_add_all_digests;
OpenSSL_add_all_ciphers;
end;

// Load private key from a file
procedure TMessageSigner.LoadPrivateKey(KeyFilename: TFileName);
begin
LoadPrivateKey(KeyFilename, fPassword);
end;

// Load private key from a file with password
procedure TMessageSigner.LoadPrivateKey(KeyFilename: TFileName; KeyPassword: ansistring);
var
  keyfile: pBIO;
  pw: PAnsiChar;
  a: pEVP_PKEY;  // Because PEM_read_bio_PrivateKey uses parameters by-reference
begin
a := nil;  // Otherwise an Access Violation error will raise (thanks to M. Podostroiec)
keyfile := BIO_new(BIO_s_file());
//BIO_ctrl(keyfile, BIO_C_SET_FILENAME, BIO_CLOSE or BIO_FP_READ, PChar(KeyFilename));
BIO_read_filename(keyfile, PChar( ansistring(KeyFilename) ) );
if KeyPassword = '' then
  pw := nil
else
  pw := PAnsiChar(KeyPassword);
fKey := PEM_read_bio_PrivateKey(keyfile, a, nil, pw);
if fKey = nil then
  raise EOpenSSL.Create('Unable to read private key. ' + GetErrorMessage);
end;

// load signer certificate
procedure TMessageSigner.LoadCertificate(CertificateFilename: TFileName);
var
  certfile: pBIO;
  c: pX509;  // Because PEM_read_bio_X509_AUX uses parameters by-reference
begin
c := nil;  // Otherwise an Access Violation error will raise (thanks to M. Podostroiec)
certfile := BIO_new(BIO_s_file());
BIO_ctrl(certfile, BIO_C_SET_FILENAME, BIO_CLOSE or BIO_FP_READ, PChar( ansistring( CertificateFilename)) );
fCertificate := PEM_read_bio_X509_AUX(certfile, c, nil, nil);
if fCertificate = nil then
  raise EOpenSSL.Create('Unable to read certificate. ' + GetErrorMessage);
end;

procedure TMessageSigner.MIMESign;
var
  p7: pPKCS7;
  msgin, msgout: pBIO;
  buff: PAnsiChar;
  buffsize: integer;
begin

// Load private key if filename is defined
if fKey = nil then
  begin
  if fPrivateKeyFile <> '' then
    LoadPrivateKey(fPrivateKeyFile, fPassword)
  else
    raise EOpenSSL.Create('Private key is required.');
  end;

// Load signer certificate
if fCertificate = nil then
  begin
  if fPrivateKeyFile <> '' then
    LoadCertificate(fCertificateFile)
  else
    raise EOpenSSL.Create('Signer certificate is required.');
  end;

msgin := BIO_new_mem_buf( PChar( ansistring(fMessage) ), -1) ;
msgout := BIO_new(BIO_s_mem);
p7 := PKCS7_sign(fCertificate, fKey, fOtherCertificates, msgin, PKCS7_BINARY); //;PKCS7_DETACHED);
BIO_reset(msgin);
SMIME_write_PKCS7(msgout, p7, msgin, PKCS7_TEXT ); //or PKCS7_DETACHED);
// Count used byte
buffsize := BIO_pending(msgout);
GetMem(buff, buffsize+1);
BIO_read(msgout, buff, buffsize);
fSignedMessage := ansistring( StrPas(buff) );
FreeMem(buff);
end;


end.
