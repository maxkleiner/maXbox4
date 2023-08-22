unit uPSI_ldapsend;
{
   first openldap of synapse
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
  TPSImport_ldapsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLDAPSend(CL: TPSPascalCompiler);
procedure SIRegister_TLDAPResultList(CL: TPSPascalCompiler);
procedure SIRegister_TLDAPResult(CL: TPSPascalCompiler);
procedure SIRegister_TLDAPAttributeList(CL: TPSPascalCompiler);
procedure SIRegister_TLDAPAttribute(CL: TPSPascalCompiler);
procedure SIRegister_ldapsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ldapsend_Routines(S: TPSExec);
procedure RIRegister_TLDAPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLDAPResultList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLDAPResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLDAPAttributeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLDAPAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_ldapsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,asn1util
  ,synacode
  ,ldapsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ldapsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLDAPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TLDAPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TLDAPSend') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Bind : Boolean');
    RegisterMethod('Function BindSasl : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Function Modify( obj : AnsiString; Op : TLDAPModifyOp; const Value : TLDAPAttribute) : Boolean');
    RegisterMethod('Function Add( obj : AnsiString; const Value : TLDAPAttributeList) : Boolean');
    RegisterMethod('Function Delete( obj : AnsiString) : Boolean');
    RegisterMethod('Function ModifyDN( obj, newRDN, newSuperior : AnsiString; DeleteoldRDN : Boolean) : Boolean');
    RegisterMethod('Function Compare( obj, AttributeValue : AnsiString) : Boolean');
    RegisterMethod('Function Search( obj : AnsiString; TypesOnly : Boolean; Filter : AnsiString; const Attributes : TStrings) : Boolean');
    RegisterMethod('Function Extended( const Name, Value : AnsiString) : Boolean');
    RegisterMethod('Function StartTLS : Boolean');
    RegisterProperty('Version', 'integer', iptrw);
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'AnsiString', iptr);
    RegisterProperty('FullResult', 'AnsiString', iptr);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('Seq', 'integer', iptr);
    RegisterProperty('SearchScope', 'TLDAPSearchScope', iptrw);
    RegisterProperty('SearchAliases', 'TLDAPSearchAliases', iptrw);
    RegisterProperty('SearchSizeLimit', 'integer', iptrw);
    RegisterProperty('SearchTimeLimit', 'integer', iptrw);
    RegisterProperty('SearchResult', 'TLDAPResultList', iptr);
    RegisterProperty('Referals', 'TStringList', iptr);
    RegisterProperty('ExtName', 'AnsiString', iptr);
    RegisterProperty('ExtValue', 'AnsiString', iptr);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLDAPResultList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLDAPResultList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLDAPResultList') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : integer');
    RegisterMethod('Function Add : TLDAPResult');
    RegisterProperty('Items', 'TLDAPResult Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLDAPResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLDAPResult') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLDAPResult') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterProperty('ObjectName', 'AnsiString', iptrw);
    RegisterProperty('Attributes', 'TLDAPAttributeList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLDAPAttributeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLDAPAttributeList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLDAPAttributeList') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : integer');
    RegisterMethod('Function Add : TLDAPAttribute');
    RegisterMethod('Procedure Del( Index : integer)');
    RegisterMethod('Function Find( AttributeName : AnsiString) : TLDAPAttribute');
    RegisterMethod('Function Get( AttributeName : AnsiString) : string');
    RegisterProperty('Items', 'TLDAPAttribute Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLDAPAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TLDAPAttribute') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TLDAPAttribute') do begin
    RegisterProperty('AttributeName', 'AnsiString', iptrw);
    RegisterProperty('IsBinary', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ldapsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cLDAPProtocol','String').SetString( '389');
 CL.AddConstantN('LDAP_ASN1_BIND_REQUEST','LongWord').SetUInt( $60);
 CL.AddConstantN('LDAP_ASN1_BIND_RESPONSE','LongWord').SetUInt( $61);
 CL.AddConstantN('LDAP_ASN1_UNBIND_REQUEST','LongWord').SetUInt( $42);
 CL.AddConstantN('LDAP_ASN1_SEARCH_REQUEST','LongWord').SetUInt( $63);
 CL.AddConstantN('LDAP_ASN1_SEARCH_ENTRY','LongWord').SetUInt( $64);
 CL.AddConstantN('LDAP_ASN1_SEARCH_DONE','LongWord').SetUInt( $65);
 CL.AddConstantN('LDAP_ASN1_SEARCH_REFERENCE','LongWord').SetUInt( $73);
 CL.AddConstantN('LDAP_ASN1_MODIFY_REQUEST','LongWord').SetUInt( $66);
 CL.AddConstantN('LDAP_ASN1_MODIFY_RESPONSE','LongWord').SetUInt( $67);
 CL.AddConstantN('LDAP_ASN1_ADD_REQUEST','LongWord').SetUInt( $68);
 CL.AddConstantN('LDAP_ASN1_ADD_RESPONSE','LongWord').SetUInt( $69);
 CL.AddConstantN('LDAP_ASN1_DEL_REQUEST','LongWord').SetUInt( $4A);
 CL.AddConstantN('LDAP_ASN1_DEL_RESPONSE','LongWord').SetUInt( $6B);
 CL.AddConstantN('LDAP_ASN1_MODIFYDN_REQUEST','LongWord').SetUInt( $6C);
 CL.AddConstantN('LDAP_ASN1_MODIFYDN_RESPONSE','LongWord').SetUInt( $6D);
 CL.AddConstantN('LDAP_ASN1_COMPARE_REQUEST','LongWord').SetUInt( $6E);
 CL.AddConstantN('LDAP_ASN1_COMPARE_RESPONSE','LongWord').SetUInt( $6F);
 CL.AddConstantN('LDAP_ASN1_ABANDON_REQUEST','LongWord').SetUInt( $70);
 CL.AddConstantN('LDAP_ASN1_EXT_REQUEST','LongWord').SetUInt( $77);
 CL.AddConstantN('LDAP_ASN1_EXT_RESPONSE','LongWord').SetUInt( $78);
  SIRegister_TLDAPAttribute(CL);
  SIRegister_TLDAPAttributeList(CL);
  SIRegister_TLDAPResult(CL);
  SIRegister_TLDAPResultList(CL);
  CL.AddTypeS('TLDAPModifyOp', '( MO_Add, MO_Delete, MO_Replace )');
  CL.AddTypeS('TLDAPSearchScope', '( SS_BaseObject, SS_SingleLevel, SS_WholeSubtree )');
  CL.AddTypeS('TLDAPSearchAliases', '( SA_NeverDeref, SA_InSearching, SA_FindingBaseObj, SA_Always )');
  SIRegister_TLDAPSend(CL);
 CL.AddDelphiFunction('Function LDAPResultDump( const Value : TLDAPResultList) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLDAPSendSock_R(Self: TLDAPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendExtValue_R(Self: TLDAPSend; var T: AnsiString);
begin T := Self.ExtValue; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendExtName_R(Self: TLDAPSend; var T: AnsiString);
begin T := Self.ExtName; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendReferals_R(Self: TLDAPSend; var T: TStringList);
begin T := Self.Referals; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchResult_R(Self: TLDAPSend; var T: TLDAPResultList);
begin T := Self.SearchResult; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchTimeLimit_W(Self: TLDAPSend; const T: integer);
begin Self.SearchTimeLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchTimeLimit_R(Self: TLDAPSend; var T: integer);
begin T := Self.SearchTimeLimit; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchSizeLimit_W(Self: TLDAPSend; const T: integer);
begin Self.SearchSizeLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchSizeLimit_R(Self: TLDAPSend; var T: integer);
begin T := Self.SearchSizeLimit; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchAliases_W(Self: TLDAPSend; const T: TLDAPSearchAliases);
begin Self.SearchAliases := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchAliases_R(Self: TLDAPSend; var T: TLDAPSearchAliases);
begin T := Self.SearchAliases; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchScope_W(Self: TLDAPSend; const T: TLDAPSearchScope);
begin Self.SearchScope := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSearchScope_R(Self: TLDAPSend; var T: TLDAPSearchScope);
begin T := Self.SearchScope; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendSeq_R(Self: TLDAPSend; var T: integer);
begin T := Self.Seq; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendFullSSL_W(Self: TLDAPSend; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendFullSSL_R(Self: TLDAPSend; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendAutoTLS_W(Self: TLDAPSend; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendAutoTLS_R(Self: TLDAPSend; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendFullResult_R(Self: TLDAPSend; var T: AnsiString);
begin T := Self.FullResult; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendResultString_R(Self: TLDAPSend; var T: AnsiString);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendResultCode_R(Self: TLDAPSend; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendVersion_W(Self: TLDAPSend; const T: integer);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPSendVersion_R(Self: TLDAPSend; var T: integer);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPResultListItems_R(Self: TLDAPResultList; var T: TLDAPResult; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPResultAttributes_R(Self: TLDAPResult; var T: TLDAPAttributeList);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPResultObjectName_W(Self: TLDAPResult; const T: AnsiString);
begin Self.ObjectName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPResultObjectName_R(Self: TLDAPResult; var T: AnsiString);
begin T := Self.ObjectName; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPAttributeListItems_R(Self: TLDAPAttributeList; var T: TLDAPAttribute; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPAttributeIsBinary_R(Self: TLDAPAttribute; var T: Boolean);
begin T := Self.IsBinary; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPAttributeAttributeName_W(Self: TLDAPAttribute; const T: AnsiString);
begin Self.AttributeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLDAPAttributeAttributeName_R(Self: TLDAPAttribute; var T: AnsiString);
begin T := Self.AttributeName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ldapsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LDAPResultDump, 'LDAPResultDump', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLDAPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLDAPSend) do begin
    RegisterConstructor(@TLDAPSend.Create, 'Create');
      RegisterMethod(@TLDAPSend.Destroy, 'Free');
     RegisterMethod(@TLDAPSend.Login, 'Login');
    RegisterMethod(@TLDAPSend.Bind, 'Bind');
    RegisterMethod(@TLDAPSend.BindSasl, 'BindSasl');
    RegisterMethod(@TLDAPSend.Logout, 'Logout');
    RegisterMethod(@TLDAPSend.Modify, 'Modify');
    RegisterMethod(@TLDAPSend.Add, 'Add');
    RegisterMethod(@TLDAPSend.Delete, 'Delete');
    RegisterMethod(@TLDAPSend.ModifyDN, 'ModifyDN');
    RegisterMethod(@TLDAPSend.Compare, 'Compare');
    RegisterMethod(@TLDAPSend.Search, 'Search');
    RegisterMethod(@TLDAPSend.Extended, 'Extended');
    RegisterMethod(@TLDAPSend.StartTLS, 'StartTLS');
    RegisterPropertyHelper(@TLDAPSendVersion_R,@TLDAPSendVersion_W,'Version');
    RegisterPropertyHelper(@TLDAPSendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@TLDAPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TLDAPSendFullResult_R,nil,'FullResult');
    RegisterPropertyHelper(@TLDAPSendAutoTLS_R,@TLDAPSendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TLDAPSendFullSSL_R,@TLDAPSendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TLDAPSendSeq_R,nil,'Seq');
    RegisterPropertyHelper(@TLDAPSendSearchScope_R,@TLDAPSendSearchScope_W,'SearchScope');
    RegisterPropertyHelper(@TLDAPSendSearchAliases_R,@TLDAPSendSearchAliases_W,'SearchAliases');
    RegisterPropertyHelper(@TLDAPSendSearchSizeLimit_R,@TLDAPSendSearchSizeLimit_W,'SearchSizeLimit');
    RegisterPropertyHelper(@TLDAPSendSearchTimeLimit_R,@TLDAPSendSearchTimeLimit_W,'SearchTimeLimit');
    RegisterPropertyHelper(@TLDAPSendSearchResult_R,nil,'SearchResult');
    RegisterPropertyHelper(@TLDAPSendReferals_R,nil,'Referals');
    RegisterPropertyHelper(@TLDAPSendExtName_R,nil,'ExtName');
    RegisterPropertyHelper(@TLDAPSendExtValue_R,nil,'ExtValue');
    RegisterPropertyHelper(@TLDAPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLDAPResultList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLDAPResultList) do begin
    RegisterConstructor(@TLDAPResultList.Create, 'Create');
       RegisterMethod(@TLDAPResultlist.Destroy, 'Free');
       RegisterMethod(@TLDAPResultList.Clear, 'Clear');
    RegisterMethod(@TLDAPResultList.Count, 'Count');
    RegisterMethod(@TLDAPResultList.Add, 'Add');
    RegisterPropertyHelper(@TLDAPResultListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLDAPResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLDAPResult) do begin
    RegisterConstructor(@TLDAPResult.Create, 'Create');
       RegisterMethod(@TLDAPResult.Destroy, 'Free');
       RegisterPropertyHelper(@TLDAPResultObjectName_R,@TLDAPResultObjectName_W,'ObjectName');
    RegisterPropertyHelper(@TLDAPResultAttributes_R,nil,'Attributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLDAPAttributeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLDAPAttributeList) do begin
    RegisterConstructor(@TLDAPAttributeList.Create, 'Create');
       RegisterMethod(@TLDAPAttributeList.Destroy, 'Free');
       RegisterMethod(@TLDAPAttributeList.Clear, 'Clear');
    RegisterMethod(@TLDAPAttributeList.Count, 'Count');
    RegisterMethod(@TLDAPAttributeList.Add, 'Add');
    RegisterMethod(@TLDAPAttributeList.Del, 'Del');
    RegisterMethod(@TLDAPAttributeList.Find, 'Find');
    RegisterMethod(@TLDAPAttributeList.Get, 'Get');
    RegisterPropertyHelper(@TLDAPAttributeListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLDAPAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLDAPAttribute) do begin
    RegisterPropertyHelper(@TLDAPAttributeAttributeName_R,@TLDAPAttributeAttributeName_W,'AttributeName');
    RegisterPropertyHelper(@TLDAPAttributeIsBinary_R,nil,'IsBinary');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ldapsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLDAPAttribute(CL);
  RIRegister_TLDAPAttributeList(CL);
  RIRegister_TLDAPResult(CL);
  RIRegister_TLDAPResultList(CL);
  RIRegister_TLDAPSend(CL);
end;

 
 
{ TPSImport_ldapsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ldapsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ldapsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ldapsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ldapsend(ri);
  RIRegister_ldapsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
