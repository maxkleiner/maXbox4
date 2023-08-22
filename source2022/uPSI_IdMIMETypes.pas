unit uPSI_IdMIMETypes;
{
  in accordance with idmimetable
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
  TPSImport_IdMIMETypes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdMIMETypes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdMIMETypes_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdMIMETypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMIMETypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMIMETypes(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MIMESplit','String').SetString( '/');
 CL.AddConstantN('MIMEXVal','String').SetString( 'x-');
 CL.AddConstantN('MIMETypeApplication','String').SetString( 'application' + '/');
 CL.AddConstantN('MIMETypeAudio','String').SetString( 'audio' + '/');
 CL.AddConstantN('MIMETypeImage','String').SetString( 'image' + '/');
 CL.AddConstantN('MIMETypeMessage','String').SetString( 'message' + '/');
 CL.AddConstantN('MIMETypeMultipart','String').SetString( 'multipart' + '/');
 CL.AddConstantN('MIMETypeText','String').SetString( 'text' + '/');
 CL.AddConstantN('MIMETypeVideo','String').SetString( 'video' + '/');
 CL.AddConstantN('MaxMIMEType','LongInt').SetInt( 6);
 CL.AddConstantN('MIMESubOctetStream','String').SetString( 'octet-stream');
 CL.AddConstantN('MIMESubMacBinHex40','String').SetString( 'mac-binhex40');
 CL.AddConstantN('MaxMIMESubTypes','LongInt').SetInt( 1);
 CL.AddConstantN('MIMEEncBase64','String').SetString( 'base64');
 CL.AddConstantN('MIMEEncUUEncode','String').SetString( MIMEXVal + 'uu');
 CL.AddConstantN('MIMEEncXXEncode','String').SetString( MIMEXVal + 'xx');
 CL.AddConstantN('MaxMIMEBinToASCIIType','LongInt').SetInt( 2);
 CL.AddConstantN('MIMEEncRSAMD2','String').SetString( MIMEXVal + 'rsa-md2');
 CL.AddConstantN('MIMEEncRSAMD4','String').SetString( MIMEXVal + 'rsa-md4');
 CL.AddConstantN('MIMEEncRSAMD5','String').SetString( MIMEXVal + 'rsa-md5');
 CL.AddConstantN('MIMEEncNISTSHA','String').SetString( MIMEXVal + 'nist-sha');
 CL.AddConstantN('MaxMIMEMessageDigestType','LongInt').SetInt( 3);
 CL.AddConstantN('MIMEEncRLECompress','String').SetString( MIMEXVal + 'rle-compress');
 CL.AddConstantN('MaxMIMECompressType','LongInt').SetInt( 0);
 CL.AddDelphiFunction('Function ReturnMIMEType( var MediaType, EncType : String) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMIMETypes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ReturnMIMEType, 'ReturnMIMEType', cdRegister);
end;

 
 
{ TPSImport_IdMIMETypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMIMETypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMIMETypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMIMETypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdMIMETypes(ri);
  RIRegister_IdMIMETypes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
