unit uPSI_ALFcnCGI;
{
   CGI and GSM
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
  TPSImport_ALFcnCGI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnCGI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnCGI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ALIsapiHTTP
  ,AlHttpCommon
  ,AlStringList
  ,ALFcnCGI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnCGI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnCGI(CL: TPSPascalCompiler);
begin

//from unit uPSI_ALIsapiHTTP;  !
 //CL.AddTypeS('TALWebRequest', 'TObject');
 //TALWebRequest = class(TObject)

 CL.AddDelphiFunction('Procedure AlCGIInitDefaultServerVariablesFromWebRequest( WebRequest : TALWebRequest; ServerVariables : TALStrings);');
 CL.AddDelphiFunction('Procedure AlCGIInitDefaultServerVariablesFromWebRequest1( WebRequest : TALWebRequest; ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);');
 CL.AddDelphiFunction('Procedure ALCGIInitDefaultServerVariables( ServerVariables : TALStrings);');
 CL.AddDelphiFunction('Procedure AlCGIInitDefaultServerVariables1( ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);');
 CL.AddDelphiFunction('Procedure AlCGIInitServerVariablesFromWebRequest( WebRequest : TALWebRequest; ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);');
 CL.AddDelphiFunction('Procedure AlCGIExec( InterpreterFilename : AnsiString; ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);');
 //CL.AddDelphiFunction('Procedure AlCGIExec1(ScriptName,ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename:AnsiString; WebRequest : TALIsapiRequest; overloadedCookies: AnsiString; overloadedQueryString : AnsiString; overloadedReferer: AnsiString;'
 //+ 'overloadedRequestContentStream: Tstream; var ResponseContentString: AnsiString; ResponseHeader: TALHTTPResponseHeader);');
 //CL.AddDelphiFunction('Procedure AlCGIExec2( ScriptName, ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename : AnsiString; WebRequest : TALIsapiRequest; var ResponseContentString : AnsiString; ResponseHeader : TALHTTPResponseHeader);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure AlCGIExec2_P( ScriptName, ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename : AnsiString; WebRequest : TALIsapiRequest; var ResponseContentString : AnsiString; ResponseHeader : TALHTTPResponseHeader);
Begin ALFcnCGI.AlCGIExec(ScriptName, ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename, WebRequest, ResponseContentString, ResponseHeader); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIExec1_P( ScriptName, ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename : AnsiString; WebRequest : TALIsapiRequest; overloadedCookies : AnsiString; overloadedQueryString : AnsiString; overloadedReferer : AnsiString; overloadedRequestContentStream : Tstream; var ResponseContentString : AnsiString; ResponseHeader : TALHTTPResponseHeader);
Begin ALFcnCGI.AlCGIExec(ScriptName, ScriptFileName, Url, X_REWRITE_URL, InterpreterFilename, WebRequest, overloadedCookies, overloadedQueryString, overloadedReferer, overloadedRequestContentStream, ResponseContentString, ResponseHeader); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIExec_P( InterpreterFilename : AnsiString; ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);
Begin ALFcnCGI.AlCGIExec(InterpreterFilename, ServerVariables, RequestContentStream, ResponseContentStream, ResponseHeader); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIInitServerVariablesFromWebRequest_P( WebRequest : TALWebRequest; ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);
Begin ALFcnCGI.AlCGIInitServerVariablesFromWebRequest(WebRequest, ServerVariables, ScriptName, ScriptFileName, Url); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIInitDefaultServerVariables1_P( ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);
Begin ALFcnCGI.AlCGIInitDefaultServerVariables(ServerVariables, ScriptName, ScriptFileName, Url); END;

(*----------------------------------------------------------------------------*)
Procedure ALCGIInitDefaultServerVariables_P( ServerVariables : TALStrings);
Begin ALFcnCGI.ALCGIInitDefaultServerVariables(ServerVariables); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIInitDefaultServerVariablesFromWebRequest1_P( WebRequest : TALWebRequest; ServerVariables : TALStrings; ScriptName, ScriptFileName : AnsiString; Url : AnsiString);
Begin ALFcnCGI.AlCGIInitDefaultServerVariablesFromWebRequest(WebRequest, ServerVariables, ScriptName, ScriptFileName, Url); END;

(*----------------------------------------------------------------------------*)
Procedure AlCGIInitDefaultServerVariablesFromWebRequest_P( WebRequest : TALWebRequest; ServerVariables : TALStrings);
Begin ALFcnCGI.AlCGIInitDefaultServerVariablesFromWebRequest(WebRequest, ServerVariables); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnCGI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlCGIInitDefaultServerVariablesFromWebRequest, 'AlCGIInitDefaultServerVariablesFromWebRequest', cdRegister);
 S.RegisterDelphiFunction(@AlCGIInitDefaultServerVariablesFromWebRequest1_P, 'AlCGIInitDefaultServerVariablesFromWebRequest1', cdRegister);
 S.RegisterDelphiFunction(@ALCGIInitDefaultServerVariables, 'ALCGIInitDefaultServerVariables', cdRegister);
 S.RegisterDelphiFunction(@AlCGIInitDefaultServerVariables1_P, 'AlCGIInitDefaultServerVariables1', cdRegister);
 S.RegisterDelphiFunction(@AlCGIInitServerVariablesFromWebRequest, 'AlCGIInitServerVariablesFromWebRequest', cdRegister);
 S.RegisterDelphiFunction(@AlCGIExec, 'AlCGIExec', cdRegister);
 S.RegisterDelphiFunction(@AlCGIExec1_P, 'AlCGIExec1', cdRegister);
 S.RegisterDelphiFunction(@AlCGIExec2_P, 'AlCGIExec2', cdRegister);
end;

 
 
{ TPSImport_ALFcnCGI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnCGI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnCGI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnCGI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnCGI(ri);
  RIRegister_ALFcnCGI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
