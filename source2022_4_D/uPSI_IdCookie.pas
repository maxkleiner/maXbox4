unit uPSI_IdCookie;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_IdCookie = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdServerCookies(CL: TPSPascalCompiler);
procedure SIRegister_TIdCookies(CL: TPSPascalCompiler);
procedure SIRegister_TIdServerCookie(CL: TPSPascalCompiler);
procedure SIRegister_TIdCookieRFC2965(CL: TPSPascalCompiler);
procedure SIRegister_TIdCookieRFC2109(CL: TPSPascalCompiler);
procedure SIRegister_TIdNetscapeCookie(CL: TPSPascalCompiler);
procedure SIRegister_TIdCookieList(CL: TPSPascalCompiler);
procedure SIRegister_IdCookie(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdServerCookies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCookies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdServerCookie(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCookieRFC2965(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCookieRFC2109(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdNetscapeCookie(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCookieList(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdCookie(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SyncObjs
  ,IdGlobal
  ,IdException
  ,IdCookie
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdCookie]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerCookies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCookies', 'TIdServerCookies') do
  with CL.AddClassN(CL.FindClass('TIdCookies'),'TIdServerCookies') do
  begin
    RegisterMethod('Function Add : TIdServerCookie');
    RegisterProperty('Cookie', 'TIdCookieRFC2109 string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCookies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdCookies') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdCookies') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TIdCookieRFC2109');
    RegisterMethod('Function Add2 : TIdCookieRFC2965');
    RegisterMethod('Procedure AddCookie( ACookie : TIdCookieRFC2109)');
    RegisterMethod('Procedure AddSrcCookie( const sCookie : string)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function GetCookieIndex( FirstIndex : integer; const AName : string) : Integer;');
    RegisterMethod('Function GetCookieIndex1( FirstIndex : integer; const AName, ADomain : string) : Integer;');
    RegisterMethod('Function LockCookieListByDomain( AAccessType : TIdCookieAccess) : TIdCookieList');
    RegisterMethod('Procedure UnlockCookieListByDomain( AAccessType : TIdCookieAccess)');
    RegisterProperty('Cookie', 'TIdCookieRFC2109 string string', iptr);
    RegisterProperty('Items', 'TIdCookieRFC2109 Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerCookie(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCookieRFC2109', 'TIdServerCookie') do
  with CL.AddClassN(CL.FindClass('TIdCookieRFC2109'),'TIdServerCookie') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Procedure AddAttribute( const Attribute, Value : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCookieRFC2965(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCookieRFC2109', 'TIdCookieRFC2965') do
  with CL.AddClassN(CL.FindClass('TIdCookieRFC2109'),'TIdCookieRFC2965') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterProperty('CommentURL', 'String', iptrw);
    RegisterProperty('Discard', 'Boolean', iptrw);
    RegisterProperty('PortList', 'Integer Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCookieRFC2109(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdNetscapeCookie', 'TIdCookieRFC2109') do
  with CL.AddClassN(CL.FindClass('TIdNetscapeCookie'),'TIdCookieRFC2109') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterProperty('Comment', 'String', iptrw);
    RegisterProperty('MaxAge', 'Int64', iptrw);
    RegisterProperty('Version', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdNetscapeCookie(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdNetscapeCookie') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdNetscapeCookie') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function IsValidCookie( AServerHost : String) : Boolean');
    RegisterProperty('CookieText', 'String', iptrw);
    RegisterProperty('ServerCookie', 'String', iptr);
    RegisterProperty('ClientCookie', 'String', iptr);
    RegisterProperty('Domain', 'String', iptrw);
    RegisterProperty('Expires', 'String', iptrw);
    RegisterProperty('CookieName', 'String', iptrw);
    RegisterProperty('Path', 'String', iptrw);
    RegisterProperty('Secure', 'Boolean', iptrw);
    RegisterProperty('Value', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCookieList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TIdCookieList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TIdCookieList') do
  begin
    RegisterProperty('Cookies', 'TIdNetscapeCookie Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdCookie(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('GFMaxAge','LongInt').SetInt( - 1);
  CL.AddTypeS('TIdCookieVersion', '( cvNetscape, cvRFC2109, cvRFC2965 )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdNetscapeCookie');
  SIRegister_TIdCookieList(CL);
  SIRegister_TIdNetscapeCookie(CL);
  SIRegister_TIdCookieRFC2109(CL);
  SIRegister_TIdCookieRFC2965(CL);
  SIRegister_TIdServerCookie(CL);
  CL.AddTypeS('TIdCookieAccess', '( caRead, caReadWrite )');
  SIRegister_TIdCookies(CL);
  SIRegister_TIdServerCookies(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdServerCookiesCookie_R(Self: TIdServerCookies; var T: TIdCookieRFC2109; const t1: string);
begin T := Self.Cookie[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookiesItems_W(Self: TIdCookies; const T: TIdCookieRFC2109; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookiesItems_R(Self: TIdCookies; var T: TIdCookieRFC2109; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookiesCookie_R(Self: TIdCookies; var T: TIdCookieRFC2109; const t1: string; const t2: string);
begin T := Self.Cookie[t1, t2]; end;

(*----------------------------------------------------------------------------*)
Function TIdCookiesGetCookieIndex1_P(Self: TIdCookies;  FirstIndex : integer; const AName, ADomain : string) : Integer;
Begin Result := Self.GetCookieIndex(FirstIndex, AName, ADomain); END;

(*----------------------------------------------------------------------------*)
Function TIdCookiesGetCookieIndex_P(Self: TIdCookies;  FirstIndex : integer; const AName : string) : Integer;
Begin Result := Self.GetCookieIndex(FirstIndex, AName); END;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965PortList_W(Self: TIdCookieRFC2965; const T: Integer; const t1: Integer);
begin Self.PortList[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965PortList_R(Self: TIdCookieRFC2965; var T: Integer; const t1: Integer);
begin T := Self.PortList[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965Discard_W(Self: TIdCookieRFC2965; const T: Boolean);
begin Self.Discard := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965Discard_R(Self: TIdCookieRFC2965; var T: Boolean);
begin T := Self.Discard; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965CommentURL_W(Self: TIdCookieRFC2965; const T: String);
begin Self.CommentURL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2965CommentURL_R(Self: TIdCookieRFC2965; var T: String);
begin T := Self.CommentURL; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109Version_W(Self: TIdCookieRFC2109; const T: String);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109Version_R(Self: TIdCookieRFC2109; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109MaxAge_W(Self: TIdCookieRFC2109; const T: Int64);
begin Self.MaxAge := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109MaxAge_R(Self: TIdCookieRFC2109; var T: Int64);
begin T := Self.MaxAge; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109Comment_W(Self: TIdCookieRFC2109; const T: String);
begin Self.Comment := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieRFC2109Comment_R(Self: TIdCookieRFC2109; var T: String);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieValue_W(Self: TIdNetscapeCookie; const T: String);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieValue_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieSecure_W(Self: TIdNetscapeCookie; const T: Boolean);
begin Self.Secure := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieSecure_R(Self: TIdNetscapeCookie; var T: Boolean);
begin T := Self.Secure; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookiePath_W(Self: TIdNetscapeCookie; const T: String);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookiePath_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieCookieName_W(Self: TIdNetscapeCookie; const T: String);
begin Self.CookieName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieCookieName_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.CookieName; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieExpires_W(Self: TIdNetscapeCookie; const T: String);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieExpires_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieDomain_W(Self: TIdNetscapeCookie; const T: String);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieDomain_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieClientCookie_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.ClientCookie; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieServerCookie_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.ServerCookie; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieCookieText_W(Self: TIdNetscapeCookie; const T: String);
begin Self.CookieText := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNetscapeCookieCookieText_R(Self: TIdNetscapeCookie; var T: String);
begin T := Self.CookieText; end;

(*----------------------------------------------------------------------------*)
procedure TIdCookieListCookies_R(Self: TIdCookieList; var T: TIdNetscapeCookie; const t1: Integer);
begin T := Self.Cookies[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerCookies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerCookies) do
  begin
    RegisterMethod(@TIdServerCookies.Add, 'Add');
    RegisterPropertyHelper(@TIdServerCookiesCookie_R,nil,'Cookie');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCookies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCookies) do
  begin
    RegisterConstructor(@TIdCookies.Create, 'Create');
    RegisterMethod(@TIdCookies.Add, 'Add');
    RegisterMethod(@TIdCookies.Add2, 'Add2');
    RegisterMethod(@TIdCookies.AddCookie, 'AddCookie');
    RegisterMethod(@TIdCookies.AddSrcCookie, 'AddSrcCookie');
    RegisterMethod(@TIdCookies.Delete, 'Delete');
    RegisterMethod(@TIdCookiesGetCookieIndex_P, 'GetCookieIndex');
    RegisterMethod(@TIdCookiesGetCookieIndex1_P, 'GetCookieIndex1');
    RegisterMethod(@TIdCookies.LockCookieListByDomain, 'LockCookieListByDomain');
    RegisterMethod(@TIdCookies.UnlockCookieListByDomain, 'UnlockCookieListByDomain');
    RegisterPropertyHelper(@TIdCookiesCookie_R,nil,'Cookie');
    RegisterPropertyHelper(@TIdCookiesItems_R,@TIdCookiesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerCookie(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerCookie) do
  begin
    RegisterConstructor(@TIdServerCookie.Create, 'Create');
    RegisterMethod(@TIdServerCookie.AddAttribute, 'AddAttribute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCookieRFC2965(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCookieRFC2965) do
  begin
    RegisterConstructor(@TIdCookieRFC2965.Create, 'Create');
    RegisterPropertyHelper(@TIdCookieRFC2965CommentURL_R,@TIdCookieRFC2965CommentURL_W,'CommentURL');
    RegisterPropertyHelper(@TIdCookieRFC2965Discard_R,@TIdCookieRFC2965Discard_W,'Discard');
    RegisterPropertyHelper(@TIdCookieRFC2965PortList_R,@TIdCookieRFC2965PortList_W,'PortList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCookieRFC2109(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCookieRFC2109) do
  begin
    RegisterConstructor(@TIdCookieRFC2109.Create, 'Create');
    RegisterPropertyHelper(@TIdCookieRFC2109Comment_R,@TIdCookieRFC2109Comment_W,'Comment');
    RegisterPropertyHelper(@TIdCookieRFC2109MaxAge_R,@TIdCookieRFC2109MaxAge_W,'MaxAge');
    RegisterPropertyHelper(@TIdCookieRFC2109Version_R,@TIdCookieRFC2109Version_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdNetscapeCookie(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdNetscapeCookie) do
  begin
    RegisterConstructor(@TIdNetscapeCookie.Create, 'Create');
    RegisterMethod(@TIdNetscapeCookie.Assign, 'Assign');
    RegisterVirtualMethod(@TIdNetscapeCookie.IsValidCookie, 'IsValidCookie');
    RegisterPropertyHelper(@TIdNetscapeCookieCookieText_R,@TIdNetscapeCookieCookieText_W,'CookieText');
    RegisterPropertyHelper(@TIdNetscapeCookieServerCookie_R,nil,'ServerCookie');
    RegisterPropertyHelper(@TIdNetscapeCookieClientCookie_R,nil,'ClientCookie');
    RegisterPropertyHelper(@TIdNetscapeCookieDomain_R,@TIdNetscapeCookieDomain_W,'Domain');
    RegisterPropertyHelper(@TIdNetscapeCookieExpires_R,@TIdNetscapeCookieExpires_W,'Expires');
    RegisterPropertyHelper(@TIdNetscapeCookieCookieName_R,@TIdNetscapeCookieCookieName_W,'CookieName');
    RegisterPropertyHelper(@TIdNetscapeCookiePath_R,@TIdNetscapeCookiePath_W,'Path');
    RegisterPropertyHelper(@TIdNetscapeCookieSecure_R,@TIdNetscapeCookieSecure_W,'Secure');
    RegisterPropertyHelper(@TIdNetscapeCookieValue_R,@TIdNetscapeCookieValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCookieList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCookieList) do
  begin
    RegisterPropertyHelper(@TIdCookieListCookies_R,nil,'Cookies');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCookie(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdNetscapeCookie) do
  RIRegister_TIdCookieList(CL);
  RIRegister_TIdNetscapeCookie(CL);
  RIRegister_TIdCookieRFC2109(CL);
  RIRegister_TIdCookieRFC2965(CL);
  RIRegister_TIdServerCookie(CL);
  RIRegister_TIdCookies(CL);
  RIRegister_TIdServerCookies(CL);
end;

 
 
{ TPSImport_IdCookie }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCookie.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdCookie(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCookie.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdCookie(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.