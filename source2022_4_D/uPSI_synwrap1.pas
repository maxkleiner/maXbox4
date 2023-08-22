unit uPSI_synwrap1;
{
   based on synapse      GetUrl1 buffer overflow!
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
  TPSImport_synwrap1 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synwrap1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synwrap1_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StreamWrap1
  ,httpsend
  ,strutils
  ,synwrap1
  //,StreamWrap1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synwrap1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synwrap1(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSynwInfo', 'record Err : byte; UrlHtml : ansistring; ErrRespons'
   +'e : integer; UltimateURL : ansistring; Headers : ansistring; end;');
  CL.AddTypeS('TUrlInfo', 'record Err : byte; UltimateURL : string; end');
 CL.AddDelphiFunction('Function GetHttpFile( const Url, UserAgent, Outfile : string; verbose : boolean) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetHttpFile1( const Url, UserAgent, Outfile : string) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetHttpFile2( const Url, Outfile : string) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetHttpFile3( const Url, outfile : string; verbose : boolean) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetHtm( const Url : string) : string;');
 CL.AddDelphiFunction('Function GetHtml( const Url : string) : string;');
 CL.AddDelphiFunction('Function GetHtm12( const Url, UserAgent : string) : string;');
 CL.AddDelphiFunction('Function GetHtm2( const Url, UserAgent : string) : string;');

 CL.AddDelphiFunction('Function GetHtm1( const Url, UserAgent : string) : string;');
 CL.AddDelphiFunction('Function GetUrl( const Url : string) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetUrl5( const Url : string; verbose : boolean) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetUrlX( const Url : string; verbose : boolean) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetUrl1( const Url, useragent : string) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetUrl2( const Url : string) : TSynwInfo;');
 CL.AddDelphiFunction('Function GetUrl3( const Url : string; const http : THTTPSend; verbose : boolean) : TUrlInfo;');
 CL.AddDelphiFunction('Function GetUrl4( const Url : string; const http : THTTPSend) : TUrlInfo;');
 CL.AddDelphiFunction('Procedure StrToStream( s : String; strm : TMemoryStream)');
 CL.AddDelphiFunction('Function StrLoadStream( strm : TStream) : String');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetUrl4_P( const Url : string; const http : THTTPSend) : TUrlInfo;
Begin Result := synwrap1.GetUrl(Url, http); END;

(*----------------------------------------------------------------------------*)
Function GetUrl3_P( const Url : string; const http : THTTPSend; verbose : boolean) : TUrlInfo;
Begin Result := synwrap1.GetUrl(Url, http, verbose); END;

(*----------------------------------------------------------------------------*)
Function GetUrl2_P( const Url : string) : TSynwInfo;
Begin Result := synwrap1.GetUrl(Url); END;

(*----------------------------------------------------------------------------*)
Function GetUrl1_P( const Url, useragent : string) : TSynwInfo;
Begin Result := synwrap1.GetUrl(Url, useragent); END;

(*----------------------------------------------------------------------------*)
Function GetUrl_P( const Url : string; verbose : boolean) : TSynwInfo;
Begin Result := synwrap1.GetUrl(Url, verbose); END;

Function GetUrl1( const Url : string) : TSynwInfo;
Begin Result := synwrap1.GetUrl(Url); END;

(*----------------------------------------------------------------------------*)
Function GetHtm1_P( const Url, UserAgent : string) : string;
Begin Result := synwrap1.GetHtm(Url, UserAgent); END;

(*----------------------------------------------------------------------------*)
Function GetHtm_P( const Url : string) : string;
Begin Result := synwrap1.GetHtm(Url); END;

(*----------------------------------------------------------------------------*)
Function GetHttpFile3_P( const Url, outfile : string; verbose : boolean) : TSynwInfo;
Begin Result := synwrap1.GetHttpFile(Url, outfile, verbose); END;

(*----------------------------------------------------------------------------*)
Function GetHttpFile2_P( const Url, Outfile : string) : TSynwInfo;
Begin Result := synwrap1.GetHttpFile(Url, Outfile); END;

(*----------------------------------------------------------------------------*)
Function GetHttpFile1_P( const Url, UserAgent, Outfile : string) : TSynwInfo;
Begin Result := synwrap1.GetHttpFile(Url, UserAgent, Outfile); END;

(*----------------------------------------------------------------------------*)
Function GetHttpFile_P( const Url, UserAgent, Outfile : string; verbose : boolean) : TSynwInfo;
Begin Result := synwrap1.GetHttpFile(Url, UserAgent, Outfile, verbose); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synwrap1_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetHttpFile, 'GetHttpFile', cdRegister);
 S.RegisterDelphiFunction(@GetHttpFile1_P, 'GetHttpFile1', cdRegister);
 S.RegisterDelphiFunction(@GetHttpFile2_P, 'GetHttpFile2', cdRegister);
 S.RegisterDelphiFunction(@GetHttpFile3_P, 'GetHttpFile3', cdRegister);
 S.RegisterDelphiFunction(@GetHtm, 'GetHtm', cdRegister);
 S.RegisterDelphiFunction(@GetHtm1_P, 'GetHtm1', cdRegister);
 S.RegisterDelphiFunction(@GetHtm, 'GetHtml', cdRegister);
 S.RegisterDelphiFunction(@GetHtm1_P, 'GetHtml2', cdRegister);
  S.RegisterDelphiFunction(@GetHtm1_P, 'GetHtm2', cdRegister);

 S.RegisterDelphiFunction(@GetUrl1, 'GetUrl', cdRegister);
 S.RegisterDelphiFunction(@GetUrlX, 'GetUrlX', cdRegister);
 S.RegisterDelphiFunction(@GetUrl1_p, 'GetUrl1', cdRegister);
 S.RegisterDelphiFunction(@GetUrl2_P, 'GetUrl2', cdRegister);
 S.RegisterDelphiFunction(@GetUrl3_P, 'GetUrl3', cdRegister);
 S.RegisterDelphiFunction(@GetUrl4_P, 'GetUrl4', cdRegister);
 S.RegisterDelphiFunction(@GetUrl_P, 'GetUrl5', cdRegister);
 S.RegisterDelphiFunction(@StrToStream, 'StrToStream', cdRegister);
 S.RegisterDelphiFunction(@StrLoadStream, 'StrLoadStream', cdRegister);

end;

 
 
{ TPSImport_synwrap1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synwrap1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synwrap1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synwrap1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synwrap1(ri);
  RIRegister_synwrap1_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
