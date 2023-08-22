unit uPSI_JvUrlGrabbers;
{
   two versions of jvtypes!
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
  TPSImport_JvUrlGrabbers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvLocalFileUrlGrabberProperties(CL: TPSPascalCompiler);
procedure SIRegister_TJvLocalFileUrlGrabberThread(CL: TPSPascalCompiler);
procedure SIRegister_TJvLocalFileUrlGrabber(CL: TPSPascalCompiler);
procedure SIRegister_TJvHttpsUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
procedure SIRegister_TJvHttpsUrlGrabber(CL: TPSPascalCompiler);
procedure SIRegister_TJvHttpUrlGrabberThread(CL: TPSPascalCompiler);
procedure SIRegister_TJvHttpUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
procedure SIRegister_TJvHttpUrlGrabber(CL: TPSPascalCompiler);
procedure SIRegister_TJvFtpUrlGrabberThread(CL: TPSPascalCompiler);
procedure SIRegister_TJvFtpUrlGrabber(CL: TPSPascalCompiler);
procedure SIRegister_TJvFtpUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
procedure SIRegister_TJvProxyingUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
procedure SIRegister_TJvProxyingUrlGrabber(CL: TPSPascalCompiler);
procedure SIRegister_JvUrlGrabbers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvLocalFileUrlGrabberProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvLocalFileUrlGrabberThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvLocalFileUrlGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHttpsUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHttpsUrlGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHttpUrlGrabberThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHttpUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHttpUrlGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFtpUrlGrabberThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFtpUrlGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFtpUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvProxyingUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvProxyingUrlGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvUrlGrabbers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //Windows
  //,Contnrs
  JvUrlListGrabber
  ,JvTypes
  ,JvUrlGrabbers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvUrlGrabbers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLocalFileUrlGrabberProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabberDefaultProperties', 'TJvLocalFileUrlGrabberProperties') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabberDefaultProperties'),'TJvLocalFileUrlGrabberProperties') do
  begin
    RegisterProperty('PreserveAttributes', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLocalFileUrlGrabberThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabberThread', 'TJvLocalFileUrlGrabberThread') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabberThread'),'TJvLocalFileUrlGrabberThread') do
  begin
    RegisterProperty('Grabber', 'TJvLocalFileUrlGrabber', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLocalFileUrlGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabber', 'TJvLocalFileUrlGrabber') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabber'),'TJvLocalFileUrlGrabber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent);');
    RegisterMethod('Constructor Create1( AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties);');
    RegisterMethod('Procedure ParseUrl1( const Url : string; var FileName : string);');
    RegisterProperty('PreserveAttributes', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHttpsUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvHttpUrlGrabberDefaultProperties', 'TJvHttpsUrlGrabberDefaultProperties') do
  with CL.AddClassN(CL.FindClass('TJvHttpUrlGrabberDefaultProperties'),'TJvHttpsUrlGrabberDefaultProperties') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHttpsUrlGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvHttpUrlGrabber', 'TJvHttpsUrlGrabber') do
  with CL.AddClassN(CL.FindClass('TJvHttpUrlGrabber'),'TJvHttpsUrlGrabber') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHttpUrlGrabberThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabberThread', 'TJvHttpUrlGrabberThread') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabberThread'),'TJvHttpUrlGrabberThread') do
  begin
    RegisterProperty('Grabber', 'TJvHttpUrlGrabber', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHttpUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvProxyingUrlGrabberDefaultProperties', 'TJvHttpUrlGrabberDefaultProperties') do
  with CL.AddClassN(CL.FindClass('TJvProxyingUrlGrabberDefaultProperties'),'TJvHttpUrlGrabberDefaultProperties') do
  begin
    RegisterMethod('Constructor Create( AOwner : TJvUrlGrabberDefaultPropertiesList)');
    RegisterProperty('Referer', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHttpUrlGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvProxyingUrlGrabber', 'TJvHttpUrlGrabber') do
  with CL.AddClassN(CL.FindClass('TJvProxyingUrlGrabber'),'TJvHttpUrlGrabber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties)');
    RegisterProperty('HTTPStatus', 'string', iptr);
    RegisterProperty('Referer', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFtpUrlGrabberThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabberThread', 'TJvFtpUrlGrabberThread') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabberThread'),'TJvFtpUrlGrabberThread') do
  begin
    RegisterProperty('Grabber', 'TJvFtpUrlGrabber', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFtpUrlGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvProxyingUrlGrabber', 'TJvFtpUrlGrabber') do
  with CL.AddClassN(CL.FindClass('TJvProxyingUrlGrabber'),'TJvFtpUrlGrabber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent);');
    RegisterMethod('Constructor Create1( AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties);');
    RegisterProperty('Passive', 'Boolean', iptrw);
    RegisterProperty('Mode', 'TJvFtpDownloadMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFtpUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvProxyingUrlGrabberDefaultProperties', 'TJvFtpUrlGrabberDefaultProperties') do
  with CL.AddClassN(CL.FindClass('TJvProxyingUrlGrabberDefaultProperties'),'TJvFtpUrlGrabberDefaultProperties') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Constructor Create( AOwner : TJvUrlGrabberDefaultPropertiesList)');
    RegisterProperty('Passive', 'Boolean', iptrw);
    RegisterProperty('Mode', 'TJvFtpDownloadMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvProxyingUrlGrabberDefaultProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabberDefaultProperties', 'TJvProxyingUrlGrabberDefaultProperties') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabberDefaultProperties'),'TJvProxyingUrlGrabberDefaultProperties') do
  begin
    RegisterMethod('Constructor Create( AOwner : TJvUrlGrabberDefaultPropertiesList)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvProxyingUrlGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomUrlGrabber', 'TJvProxyingUrlGrabber') do
  with CL.AddClassN(CL.FindClass('TJvCustomUrlGrabber'),'TJvProxyingUrlGrabber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent);');
    RegisterMethod('Constructor Create1( AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvUrlGrabbers(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvProxyMode', '( pmNoProxy, pmSysConfig, pmManual )');
  SIRegister_TJvProxyingUrlGrabber(CL);
  SIRegister_TJvProxyingUrlGrabberDefaultProperties(CL);
  CL.AddTypeS('TJvFtpDownloadMode', '( hmBinary, hmAscii )');
  SIRegister_TJvFtpUrlGrabberDefaultProperties(CL);
  SIRegister_TJvFtpUrlGrabber(CL);
  SIRegister_TJvFtpUrlGrabberThread(CL);
  SIRegister_TJvHttpUrlGrabber(CL);
  SIRegister_TJvHttpUrlGrabberDefaultProperties(CL);
  SIRegister_TJvHttpUrlGrabberThread(CL);
  SIRegister_TJvHttpsUrlGrabber(CL);
  SIRegister_TJvHttpsUrlGrabberDefaultProperties(CL);
  SIRegister_TJvLocalFileUrlGrabber(CL);
  SIRegister_TJvLocalFileUrlGrabberThread(CL);
  SIRegister_TJvLocalFileUrlGrabberProperties(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvLocalFileUrlGrabberPropertiesPreserveAttributes_W(Self: TJvLocalFileUrlGrabberProperties; const T: Boolean);
begin Self.PreserveAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocalFileUrlGrabberPropertiesPreserveAttributes_R(Self: TJvLocalFileUrlGrabberProperties; var T: Boolean);
begin T := Self.PreserveAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocalFileUrlGrabberThreadGrabber_R(Self: TJvLocalFileUrlGrabberThread; var T: TJvLocalFileUrlGrabber);
begin T := Self.Grabber; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocalFileUrlGrabberPreserveAttributes_W(Self: TJvLocalFileUrlGrabber; const T: Boolean);
begin Self.PreserveAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocalFileUrlGrabberPreserveAttributes_R(Self: TJvLocalFileUrlGrabber; var T: Boolean);
begin T := Self.PreserveAttributes; end;

(*----------------------------------------------------------------------------*)
Procedure TJvLocalFileUrlGrabberParseUrl1_P(Self: TJvLocalFileUrlGrabber;  const Url : string; var FileName : string);
Begin Self.ParseUrl(Url, FileName); END;

(*----------------------------------------------------------------------------*)
Procedure TJvLocalFileUrlGrabberParseUrl_P(Self: TJvLocalFileUrlGrabber;  Url : string; Protocol : string; var Host : string; var FileName : string; var UserName : string; var Password : string; var Port : Cardinal);
Begin Self.ParseUrl(Url, Protocol, Host, FileName, UserName, Password, Port); END;

(*----------------------------------------------------------------------------*)
Function TJvLocalFileUrlGrabberCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties):TObject;
Begin Result := TJvLocalFileUrlGrabber.Create(AOwner, AUrl, DefaultProperties); END;

(*----------------------------------------------------------------------------*)
Function TJvLocalFileUrlGrabberCreate_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TJvLocalFileUrlGrabber.Create(AOwner); END;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberThreadGrabber_R(Self: TJvHttpUrlGrabberThread; var T: TJvHttpUrlGrabber);
begin T := Self.Grabber; end;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberDefaultPropertiesReferer_W(Self: TJvHttpUrlGrabberDefaultProperties; const T: string);
begin Self.Referer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberDefaultPropertiesReferer_R(Self: TJvHttpUrlGrabberDefaultProperties; var T: string);
begin T := Self.Referer; end;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberReferer_W(Self: TJvHttpUrlGrabber; const T: string);
begin Self.Referer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberReferer_R(Self: TJvHttpUrlGrabber; var T: string);
begin T := Self.Referer; end;

(*----------------------------------------------------------------------------*)
procedure TJvHttpUrlGrabberHTTPStatus_R(Self: TJvHttpUrlGrabber; var T: string);
begin T := Self.HTTPStatus; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberThreadGrabber_R(Self: TJvFtpUrlGrabberThread; var T: TJvFtpUrlGrabber);
begin T := Self.Grabber; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberMode_W(Self: TJvFtpUrlGrabber; const T: TJvFtpDownloadMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberMode_R(Self: TJvFtpUrlGrabber; var T: TJvFtpDownloadMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberPassive_W(Self: TJvFtpUrlGrabber; const T: Boolean);
begin Self.Passive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberPassive_R(Self: TJvFtpUrlGrabber; var T: Boolean);
begin T := Self.Passive; end;

(*----------------------------------------------------------------------------*)
Function TJvFtpUrlGrabberCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties):TObject;
Begin Result := TJvFtpUrlGrabber.Create(AOwner, AUrl, DefaultProperties); END;

(*----------------------------------------------------------------------------*)
Function TJvFtpUrlGrabberCreate_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TJvFtpUrlGrabber.Create(AOwner); END;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberDefaultPropertiesMode_W(Self: TJvFtpUrlGrabberDefaultProperties; const T: TJvFtpDownloadMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberDefaultPropertiesMode_R(Self: TJvFtpUrlGrabberDefaultProperties; var T: TJvFtpDownloadMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberDefaultPropertiesPassive_W(Self: TJvFtpUrlGrabberDefaultProperties; const T: Boolean);
begin Self.Passive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpUrlGrabberDefaultPropertiesPassive_R(Self: TJvFtpUrlGrabberDefaultProperties; var T: Boolean);
begin T := Self.Passive; end;

(*----------------------------------------------------------------------------*)
Function TJvProxyingUrlGrabberCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent; AUrl : string; DefaultProperties : TJvCustomUrlGrabberDefaultProperties):TObject;
Begin Result := TJvProxyingUrlGrabber.Create(AOwner, AUrl, DefaultProperties); END;

(*----------------------------------------------------------------------------*)
Function TJvProxyingUrlGrabberCreate_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TJvProxyingUrlGrabber.Create(AOwner); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLocalFileUrlGrabberProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLocalFileUrlGrabberProperties) do
  begin
    RegisterPropertyHelper(@TJvLocalFileUrlGrabberPropertiesPreserveAttributes_R,@TJvLocalFileUrlGrabberPropertiesPreserveAttributes_W,'PreserveAttributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLocalFileUrlGrabberThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLocalFileUrlGrabberThread) do
  begin
    RegisterPropertyHelper(@TJvLocalFileUrlGrabberThreadGrabber_R,nil,'Grabber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLocalFileUrlGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLocalFileUrlGrabber) do begin
    RegisterConstructor(@TJvLocalFileUrlGrabberCreate_P, 'Create');
    RegisterConstructor(@TJvLocalFileUrlGrabberCreate1_P, 'Create1');
    RegisterMethod(@TJvLocalFileUrlGrabberParseUrl1_P, 'ParseUrl1');
    RegisterPropertyHelper(@TJvLocalFileUrlGrabberPreserveAttributes_R,@TJvLocalFileUrlGrabberPreserveAttributes_W,'PreserveAttributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHttpsUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHttpsUrlGrabberDefaultProperties) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHttpsUrlGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHttpsUrlGrabber) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHttpUrlGrabberThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHttpUrlGrabberThread) do
  begin
    RegisterPropertyHelper(@TJvHttpUrlGrabberThreadGrabber_R,nil,'Grabber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHttpUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHttpUrlGrabberDefaultProperties) do
  begin
    RegisterConstructor(@TJvHttpUrlGrabberDefaultProperties.Create, 'Create');
    RegisterPropertyHelper(@TJvHttpUrlGrabberDefaultPropertiesReferer_R,@TJvHttpUrlGrabberDefaultPropertiesReferer_W,'Referer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHttpUrlGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHttpUrlGrabber) do begin
    RegisterConstructor(@TJvHttpUrlGrabber.Create, 'Create');
    RegisterPropertyHelper(@TJvHttpUrlGrabberHTTPStatus_R,nil,'HTTPStatus');
    RegisterPropertyHelper(@TJvHttpUrlGrabberReferer_R,@TJvHttpUrlGrabberReferer_W,'Referer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFtpUrlGrabberThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFtpUrlGrabberThread) do
  begin
    RegisterPropertyHelper(@TJvFtpUrlGrabberThreadGrabber_R,nil,'Grabber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFtpUrlGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFtpUrlGrabber) do begin
    RegisterConstructor(@TJvFtpUrlGrabberCreate_P, 'Create');
    RegisterConstructor(@TJvFtpUrlGrabberCreate1_P, 'Create1');
    RegisterPropertyHelper(@TJvFtpUrlGrabberPassive_R,@TJvFtpUrlGrabberPassive_W,'Passive');
    RegisterPropertyHelper(@TJvFtpUrlGrabberMode_R,@TJvFtpUrlGrabberMode_W,'Mode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFtpUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFtpUrlGrabberDefaultProperties) do begin
    RegisterMethod(@TJvFtpUrlGrabberDefaultProperties.Assign, 'Assign');
    RegisterConstructor(@TJvFtpUrlGrabberDefaultProperties.Create, 'Create');
    RegisterPropertyHelper(@TJvFtpUrlGrabberDefaultPropertiesPassive_R,@TJvFtpUrlGrabberDefaultPropertiesPassive_W,'Passive');
    RegisterPropertyHelper(@TJvFtpUrlGrabberDefaultPropertiesMode_R,@TJvFtpUrlGrabberDefaultPropertiesMode_W,'Mode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvProxyingUrlGrabberDefaultProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvProxyingUrlGrabberDefaultProperties) do
  begin
    RegisterConstructor(@TJvProxyingUrlGrabberDefaultProperties.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvProxyingUrlGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvProxyingUrlGrabber) do
  begin
    RegisterConstructor(@TJvProxyingUrlGrabberCreate_P, 'Create');
    RegisterConstructor(@TJvProxyingUrlGrabberCreate1_P, 'Create1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvUrlGrabbers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvProxyingUrlGrabber(CL);
  RIRegister_TJvProxyingUrlGrabberDefaultProperties(CL);
  RIRegister_TJvFtpUrlGrabberDefaultProperties(CL);
  RIRegister_TJvFtpUrlGrabber(CL);
  RIRegister_TJvFtpUrlGrabberThread(CL);
  RIRegister_TJvHttpUrlGrabber(CL);
  RIRegister_TJvHttpUrlGrabberDefaultProperties(CL);
  RIRegister_TJvHttpUrlGrabberThread(CL);
  RIRegister_TJvHttpsUrlGrabber(CL);
  RIRegister_TJvHttpsUrlGrabberDefaultProperties(CL);
  RIRegister_TJvLocalFileUrlGrabber(CL);
  RIRegister_TJvLocalFileUrlGrabberThread(CL);
  RIRegister_TJvLocalFileUrlGrabberProperties(CL);
end;



{ TPSImport_JvUrlGrabbers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvUrlGrabbers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvUrlGrabbers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvUrlGrabbers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvUrlGrabbers(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
