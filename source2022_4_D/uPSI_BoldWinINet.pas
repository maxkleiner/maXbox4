unit uPSI_BoldWinINet;
{
   like httpget  but with TObject instead pointer 
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
  TPSImport_BoldWinINet = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_BoldWinINet(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldWinINet_Routines(S: TPSExec);

procedure Register;

implementation


uses
   BoldDefs
  ,Windows
  ,WinInet
  ,BoldWinINet
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldWinINet]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldWinINet(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('PCharArr', 'array of PChar');
  CL.AddTypeS('HINTERNET', 'TObject');
  CL.AddTypeS('INTERNET_PORT', 'Word');

 // type HINTERNET = Pointer;
  // INTERNET_PORT = Word;

 CL.AddDelphiFunction('Function BoldInternetOpen( Agent : String; AccessType : integer; Proxy : string; ProxyByPass : String; Flags : integer) : TObject');
 CL.AddDelphiFunction('Function BoldInternetOpenUrl( iNet : TObject; URL : string; Headers : String; Flags, Context : cardinal) : TObject');
 CL.AddDelphiFunction('Function BoldInternetReadFile( hFile : TObject; Buffer : TObject; NumberOfBytesToRead : Cardinal; var NumberOfBytesRead : Cardinal) : LongBool');
 CL.AddDelphiFunction('Function BoldInternetCloseHandle( HINet : TObject) : LongBool');
 CL.AddDelphiFunction('Function BoldHttpQueryInfo( hRequest : TObject; InfoLevel : Cardinal; Buffer : TObject; BufferLength : Cardinal; Reserved : Cardinal) : LongBool');
 CL.AddDelphiFunction('Function BoldInternetQueryDataAvailable( hFile : TObject; var NumberOfBytesAvailable : Cardinal; flags : Cardinal; Context : Cardinal) : LongBool');
 CL.AddDelphiFunction('Function BoldHttpOpenRequest( hConnect : TObject; Verb, ObjectName, Version, Referrer : String; AcceptTypes : PCharArr; Flags, Context : Cardinal) : TObject');
 CL.AddDelphiFunction('Function BoldHttpSendRequest( hRequest : TObject; Headers : string; Optional : TObject; OptionalLength : Cardinal) : LongBool');
 CL.AddDelphiFunction('Function BoldInternetErrorDlg( hWnd : HWND; hRequest : HINTERNET; dwError, dwFlags : DWORD; var lppvData : TObject) : DWORD');
 CL.AddDelphiFunction('Function BoldInternetAttemptConnect( dwReserved : DWORD) : DWORD');
 CL.AddDelphiFunction('Function BoldInternetConnect( hInet : HINTERNET; ServerName : string; nServerPort : INTERNET_PORT; Username : string; Password : string; dwService : DWORD; dwFlags : DWORD; dwContext : DWORD) : HINTERNET');
 //CL.AddDelphiFunction('Function BoldInternetCrackUrl( Url : PChar; UrlLength, dwFlags : DWORD; var lpUrlComponents : TURLComponents) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldWinINet_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BoldInternetOpen, 'BoldInternetOpen', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetOpenUrl, 'BoldInternetOpenUrl', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetReadFile, 'BoldInternetReadFile', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetCloseHandle, 'BoldInternetCloseHandle', cdRegister);
 S.RegisterDelphiFunction(@BoldHttpQueryInfo, 'BoldHttpQueryInfo', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetQueryDataAvailable, 'BoldInternetQueryDataAvailable', cdRegister);
 S.RegisterDelphiFunction(@BoldHttpOpenRequest, 'BoldHttpOpenRequest', cdRegister);
 S.RegisterDelphiFunction(@BoldHttpSendRequest, 'BoldHttpSendRequest', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetErrorDlg, 'BoldInternetErrorDlg', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetAttemptConnect, 'BoldInternetAttemptConnect', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetConnect, 'BoldInternetConnect', cdRegister);
 S.RegisterDelphiFunction(@BoldInternetCrackUrl, 'BoldInternetCrackUrl', cdRegister);
end;



{ TPSImport_BoldWinINet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldWinINet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldWinINet(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldWinINet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_BoldWinINet(ri);
  RIRegister_BoldWinINet_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
