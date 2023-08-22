unit uPSI_cyIndy;
{
   indy enhancer not all functions
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
  TPSImport_cyIndy = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyIndy(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyIndy_Routines(S: TPSExec);

procedure Register;

implementation


uses
   idHttp
  ,idComponent
  ,idCoderHeader
  ,IdCoderMIME
  ,IdHashMessageDigest
  ,cyIndy
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyIndy]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyIndy(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TContentTypeMessage', '( cmPlainText, cmPlainText_Attach, cmHtml'
   +'_Attach, cmHtml_RelatedAttach, cmAlterText_Html, cmAlterText_Html_Attach, '
   +'cmAlterText_Html_RelatedAttach, cmAlterText_Html_Attach_RelatedAttach, cmReadNotification )');
 CL.AddConstantN('MessagePlainText','String').SetString( 'text/plain');
 CL.AddConstantN('MessagePlainText_Attach','String').SetString( 'multipart/mixed');
 CL.AddConstantN('MessageAlterText_Html','String').SetString( 'multipart/alternative');
 CL.AddConstantN('MessageHtml_Attach','String').SetString( 'multipart/mixed');
 CL.AddConstantN('MessageHtml_RelatedAttach','String').SetString( 'multipart/related; type="text/html"');
 CL.AddConstantN('MessageAlterText_Html_Attach','String').SetString( 'multipart/mixed');
 CL.AddConstantN('MessageAlterText_Html_RelatedAttach','String').SetString( 'multipart/related; type="multipart/alternative"');
 CL.AddConstantN('MessageAlterText_Html_Attach_RelatedAttach','String').SetString( 'multipart/mixed');
 CL.AddConstantN('MessageReadNotification','String').SetString( 'multipart/report; report-type="disposition-notification"');
 CL.AddDelphiFunction('Function ForceDecodeHeader( aHeader : String) : String');
 CL.AddDelphiFunction('Function Base64_EncodeString( Value : String; const aEncoding : TObject) : string');
 CL.AddDelphiFunction('Function Base64_DecodeToString( Value : String; const aBytesEncoding : TObject) : String;');
 CL.AddDelphiFunction('Function Base64_DecodeToBytes( Value : String) : TBytes;');
 CL.AddDelphiFunction('Function IdHttp_DownloadFile( aSrcUrlFile, aDestFile : String; const OnWorkEvent : TWorkEvent) : Boolean');
 CL.AddDelphiFunction('Function Get_MD5( const aFileName : string) : string');
 CL.AddDelphiFunction('Function Get_MD5FromString( const aString : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Base64_DecodeToBytes_P( Value : String) : TBytes;
Begin Result := cyIndy.Base64_DecodeToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function Base64_DecodeToString_P( Value : String; const aBytesEncoding : TObject) : String;
Begin Result := cyIndy.Base64_DecodeToString(Value, aBytesEncoding); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyIndy_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ForceDecodeHeader, 'ForceDecodeHeader', cdRegister);
 S.RegisterDelphiFunction(@Base64_EncodeString, 'Base64_EncodeString', cdRegister);
 S.RegisterDelphiFunction(@Base64_DecodeToString, 'Base64_DecodeToString', cdRegister);
 S.RegisterDelphiFunction(@Base64_DecodeToBytes, 'Base64_DecodeToBytes', cdRegister);
 S.RegisterDelphiFunction(@IdHttp_DownloadFile, 'IdHttp_DownloadFile', cdRegister);
 S.RegisterDelphiFunction(@Get_MD5, 'Get_MD5', cdRegister);
 S.RegisterDelphiFunction(@Get_MD5FromString, 'Get_MD5FromString', cdRegister);
end;

 
 
{ TPSImport_cyIndy }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIndy.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyIndy(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIndy.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyIndy(ri);
  RIRegister_cyIndy_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
