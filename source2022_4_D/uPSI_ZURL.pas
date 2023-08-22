unit uPSI_ZURL;
{
   first ZEOS
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
  TPSImport_ZURL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZURL(CL: TPSPascalCompiler);
procedure SIRegister_TZURLStringList(CL: TPSPascalCompiler);
procedure SIRegister_ZURL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZURL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZURLStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZURL(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZURL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZURL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZURL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TZURL') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TZURL') do begin
    RegisterMethod('Constructor Create;');
     RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create1( const AURL : String);');
    RegisterMethod('Constructor Create2( const AURL : String; Info : TStrings);');
    RegisterMethod('Constructor Create3( const AURL : TZURL);');
    RegisterMethod('Constructor Create4( const AURL, AHostName : string; const APort : Integer; const ADatabase, AUser, APassword : string; Info : TStrings);');
    RegisterProperty('Prefix', 'string', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('HostName', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Database', 'string', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('LibLocation', 'string', iptrw);
    RegisterProperty('Properties', 'TZURLStringList', iptr);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('OnPropertiesChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZURLStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TZURLStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TZURLStringList') do
  begin
    RegisterProperty('URLText', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZURL(CL: TPSPascalCompiler);
begin
  SIRegister_TZURLStringList(CL);
  SIRegister_TZURL(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZURLOnPropertiesChange_W(Self: TZURL; const T: TNotifyEvent);
begin Self.OnPropertiesChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLOnPropertiesChange_R(Self: TZURL; var T: TNotifyEvent);
begin T := Self.OnPropertiesChange; end;

(*----------------------------------------------------------------------------*)
procedure TZURLURL_W(Self: TZURL; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLURL_R(Self: TZURL; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TZURLProperties_R(Self: TZURL; var T: TZURLStringList);
begin T := Self.Properties; end;

(*----------------------------------------------------------------------------*)
procedure TZURLLibLocation_W(Self: TZURL; const T: string);
begin Self.LibLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLLibLocation_R(Self: TZURL; var T: string);
begin T := Self.LibLocation; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPassword_W(Self: TZURL; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPassword_R(Self: TZURL; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TZURLUserName_W(Self: TZURL; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLUserName_R(Self: TZURL; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TZURLDatabase_W(Self: TZURL; const T: string);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLDatabase_R(Self: TZURL; var T: string);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPort_W(Self: TZURL; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPort_R(Self: TZURL; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TZURLHostName_W(Self: TZURL; const T: string);
begin Self.HostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLHostName_R(Self: TZURL; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure TZURLProtocol_W(Self: TZURL; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLProtocol_R(Self: TZURL; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPrefix_W(Self: TZURL; const T: string);
begin Self.Prefix := T; end;

(*----------------------------------------------------------------------------*)
procedure TZURLPrefix_R(Self: TZURL; var T: string);
begin T := Self.Prefix; end;

(*----------------------------------------------------------------------------*)
Function TZURLCreate4_P(Self: TClass; CreateNewInstance: Boolean;  const AURL, AHostName : string; const APort : Integer; const ADatabase, AUser, APassword : string; Info : TStrings):TObject;
Begin Result := TZURL.Create(AURL, AHostName, APort, ADatabase, AUser, APassword, Info); END;

(*----------------------------------------------------------------------------*)
Function TZURLCreate3_P(Self: TClass; CreateNewInstance: Boolean;  const AURL : TZURL):TObject;
Begin Result := TZURL.Create(AURL); END;

(*----------------------------------------------------------------------------*)
Function TZURLCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const AURL : String; Info : TStrings):TObject;
Begin Result := TZURL.Create(AURL, Info); END;

(*----------------------------------------------------------------------------*)
Function TZURLCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const AURL : String):TObject;
Begin Result := TZURL.Create(AURL); END;

(*----------------------------------------------------------------------------*)
Function TZURLCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TZURL.Create; END;

(*----------------------------------------------------------------------------*)
procedure TZURLStringListURLText_R(Self: TZURLStringList; var T: String);
begin T := Self.URLText; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZURL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZURL) do begin
    RegisterConstructor(@TZURLCreate_P, 'Create');
    RegisterMethod(@TZURL.Destroy, 'Free');
    RegisterConstructor(@TZURLCreate1_P, 'Create1');
    RegisterConstructor(@TZURLCreate2_P, 'Create2');
    RegisterConstructor(@TZURLCreate3_P, 'Create3');
    RegisterConstructor(@TZURLCreate4_P, 'Create4');
    RegisterPropertyHelper(@TZURLPrefix_R,@TZURLPrefix_W,'Prefix');
    RegisterPropertyHelper(@TZURLProtocol_R,@TZURLProtocol_W,'Protocol');
    RegisterPropertyHelper(@TZURLHostName_R,@TZURLHostName_W,'HostName');
    RegisterPropertyHelper(@TZURLPort_R,@TZURLPort_W,'Port');
    RegisterPropertyHelper(@TZURLDatabase_R,@TZURLDatabase_W,'Database');
    RegisterPropertyHelper(@TZURLUserName_R,@TZURLUserName_W,'UserName');
    RegisterPropertyHelper(@TZURLPassword_R,@TZURLPassword_W,'Password');
    RegisterPropertyHelper(@TZURLLibLocation_R,@TZURLLibLocation_W,'LibLocation');
    RegisterPropertyHelper(@TZURLProperties_R,nil,'Properties');
    RegisterPropertyHelper(@TZURLURL_R,@TZURLURL_W,'URL');
    RegisterPropertyHelper(@TZURLOnPropertiesChange_R,@TZURLOnPropertiesChange_W,'OnPropertiesChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZURLStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZURLStringList) do
  begin
    RegisterPropertyHelper(@TZURLStringListURLText_R,nil,'URLText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZURL(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZURLStringList(CL);
  RIRegister_TZURL(CL);
end;

 
 
{ TPSImport_ZURL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZURL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZURL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZURL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZURL(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
