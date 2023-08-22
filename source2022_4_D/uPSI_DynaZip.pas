unit uPSI_DynaZip;
{
  just of dynasoft
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
  TPSImport_DynaZip = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDynaZip(CL: TPSPascalCompiler);
procedure SIRegister_TLPStr(CL: TPSPascalCompiler);
procedure SIRegister_DynaZip(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DynaZip_Routines(S: TPSExec);
procedure RIRegister_TDynaZip(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLPStr(CL: TPSRuntimeClassImporter);
procedure RIRegister_DynaZip(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Consts
  ,Dialogs
  ,DynaZip
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DynaZip]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDynaZip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDynaZip') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDynaZip') do begin
    RegisterMethod('Procedure DoOnMajor( szItem : PChar; Percent : longint; var DoCancel : Boolean)');
    RegisterMethod('Procedure DoOnMinor( szItem : PChar; Percent : longint; var DoCancel : Boolean)');
    RegisterMethod('Procedure DoOnMessage( MsgID, mbType : word; p1, p2 : integer; lpsz1, lpsz2 : PChar; var RtnResult : integer)');
    RegisterMethod('Procedure DoOnRename( dzr : PDZRename)');
    RegisterMethod('Procedure NoCanDo( Value : TLPStr)');
    RegisterProperty('OnMajorCallback', 'TStatusCallback', iptrw);
    RegisterProperty('OnMinorCallback', 'TStatusCallback', iptrw);
    RegisterProperty('OnMessageCallback', 'TMessageCallback', iptrw);
    RegisterProperty('OnRenameCallback', 'TRenameCallback', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLPStr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TLPStr') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TLPStr') do begin
    RegisterMethod('Constructor Create( Size : word)');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Function GetBufSize : word');
    RegisterMethod('Function GetPtr : pchar');
    RegisterMethod('Function GetText( var Dest : PChar) : PChar');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SetBufSize( Size : word)');
    RegisterMethod('Procedure SetText( Text : PChar)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DynaZip(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ZIPINFO_DATETIME_SIZE','LongInt').SetInt( 18);
 CL.AddConstantN('ZIPINFO_FNAME_SIZE','LongInt').SetInt( 260);
 CL.AddConstantN('MSGID_DISK','LongInt').SetInt( 0);
 CL.AddConstantN('MSGID_DISKOFDISK','LongInt').SetInt( 1);
 CL.AddConstantN('MSGID_ZOPEN','LongInt').SetInt( 2);
 CL.AddConstantN('MSGID_ZREAD','LongInt').SetInt( 3);
 CL.AddConstantN('MSGID_ZWRITE','LongInt').SetInt( 4);
 CL.AddConstantN('MSGID_NOREMOVE','LongInt').SetInt( 5);
 CL.AddConstantN('MSGID_SAMEVOL','LongInt').SetInt( 6);
 CL.AddConstantN('MSGID_ZFORMAT','LongInt').SetInt( 7);
 CL.AddConstantN('MSGID_OVERWRT','LongInt').SetInt( 8);
 CL.AddConstantN('MSGID_CODEERR','LongInt').SetInt( 9);
 CL.AddConstantN('MSGID_MVBADFIRSTDISK','LongInt').SetInt( 10);
 CL.AddConstantN('MSGID_ERROR','LongInt').SetInt( 11);
 CL.AddConstantN('MSGID_WARN','LongInt').SetInt( 12);
 CL.AddConstantN('MSGID_CHANGE','LongInt').SetInt( 13);
  SIRegister_TLPStr(CL);
  //CL.AddTypeS('PDZRename', '^DZRename // will not work');
  CL.AddTypeS('TStatusCallback', 'Procedure ( szItem : PChar; Percent : longint'
   +'; var DoCancel : Boolean)');
  CL.AddTypeS('TMessageCallback', 'Procedure ( MsgID, mbType : word; p1, p2 : i'
   +'nteger; lpsz1, lpsz2 : PChar; var RtnResult : integer)');
  //CL.AddTypeS('TRenameCallback', 'Procedure ( dzr : PDZRename)');
  SIRegister_TDynaZip(CL);
 {CL.AddDelphiFunction('Function MajorCallBack( szItem : Pchar; percent : LongInt; majorData : Pointer) : bool');
 CL.AddDelphiFunction('Function MinorCallBack( szItem : Pchar; percent : LongInt; minorData : Pointer) : bool');
 CL.AddDelphiFunction('Function MessageCallback( MsgID, mbType : word; p1, p2 : integer; lpsz1, lpsz2 : PChar; MessageData : Pointer) : integer');
 CL.AddDelphiFunction('Function RenameCallback( dzr : PDZRename; RenameData : pointer) : integer');
 CL.AddDelphiFunction('Function MajorCallBack( szItem : Pchar; percent : LongInt; majorData : Pointer) : bool');
 CL.AddDelphiFunction('Function MinorCallBack( szItem : Pchar; percent : LongInt; minorData : Pointer) : bool');
 CL.AddDelphiFunction('Function MessageCallback( MsgID, mbType : word; p1, p2 : integer; lpsz1, lpsz2 : PChar; MessageData : Pointer) : integer');
 CL.AddDelphiFunction('Function RenameCallback( dzr : PDZRename; RenameData : pointer) : integer');}
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDynaZipOnRenameCallback_W(Self: TDynaZip; const T: TRenameCallback);
begin Self.OnRenameCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnRenameCallback_R(Self: TDynaZip; var T: TRenameCallback);
begin T := Self.OnRenameCallback; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMessageCallback_W(Self: TDynaZip; const T: TMessageCallback);
begin Self.OnMessageCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMessageCallback_R(Self: TDynaZip; var T: TMessageCallback);
begin T := Self.OnMessageCallback; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMinorCallback_W(Self: TDynaZip; const T: TStatusCallback);
begin Self.OnMinorCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMinorCallback_R(Self: TDynaZip; var T: TStatusCallback);
begin T := Self.OnMinorCallback; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMajorCallback_W(Self: TDynaZip; const T: TStatusCallback);
begin Self.OnMajorCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynaZipOnMajorCallback_R(Self: TDynaZip; var T: TStatusCallback);
begin T := Self.OnMajorCallback; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DynaZip_Routines(S: TPSExec);
begin
 {S.RegisterDelphiFunction(@MajorCallBack, 'MajorCallBack', CdStdCall);
 S.RegisterDelphiFunction(@MinorCallBack, 'MinorCallBack', CdStdCall);
 S.RegisterDelphiFunction(@MessageCallback, 'MessageCallback', CdStdCall);
 S.RegisterDelphiFunction(@RenameCallback, 'RenameCallback', CdStdCall);
 S.RegisterDelphiFunction(@MajorCallBack, 'MajorCallBack', cdRegister);
 S.RegisterDelphiFunction(@MinorCallBack, 'MinorCallBack', cdRegister);
 S.RegisterDelphiFunction(@MessageCallback, 'MessageCallback', cdRegister);
 S.RegisterDelphiFunction(@RenameCallback, 'RenameCallback', cdRegister);}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDynaZip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDynaZip) do
  begin
    RegisterMethod(@TDynaZip.DoOnMajor, 'DoOnMajor');
    RegisterMethod(@TDynaZip.DoOnMinor, 'DoOnMinor');
    RegisterMethod(@TDynaZip.DoOnMessage, 'DoOnMessage');
    RegisterMethod(@TDynaZip.DoOnRename, 'DoOnRename');
    RegisterMethod(@TDynaZip.NoCanDo, 'NoCanDo');
    RegisterPropertyHelper(@TDynaZipOnMajorCallback_R,@TDynaZipOnMajorCallback_W,'OnMajorCallback');
    RegisterPropertyHelper(@TDynaZipOnMinorCallback_R,@TDynaZipOnMinorCallback_W,'OnMinorCallback');
    RegisterPropertyHelper(@TDynaZipOnMessageCallback_R,@TDynaZipOnMessageCallback_W,'OnMessageCallback');
    RegisterPropertyHelper(@TDynaZipOnRenameCallback_R,@TDynaZipOnRenameCallback_W,'OnRenameCallback');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLPStr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLPStr) do begin
    RegisterConstructor(@TLPStr.Create, 'Create');
        RegisterMethod(@TLPStr.Destroy, 'Free');
     RegisterVirtualMethod(@TLPStr.Clear, 'Clear');
    RegisterMethod(@TLPStr.GetBufSize, 'GetBufSize');
    RegisterMethod(@TLPStr.GetPtr, 'GetPtr');
    RegisterVirtualMethod(@TLPStr.GetText, 'GetText');
    RegisterMethod(@TLPStr.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TLPStr.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TLPStr.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TLPStr.SaveToStream, 'SaveToStream');
    RegisterMethod(@TLPStr.SetBufSize, 'SetBufSize');
    RegisterVirtualMethod(@TLPStr.SetText, 'SetText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DynaZip(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLPStr(CL);
  RIRegister_TDynaZip(CL);
end;

 
 
{ TPSImport_DynaZip }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DynaZip.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DynaZip(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DynaZip.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DynaZip(ri);
  //RIRegister_DynaZip_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
