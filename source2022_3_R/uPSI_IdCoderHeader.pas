unit uPSI_IdCoderHeader;
{
for a python header spider

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
  TPSImport_IdCoderHeader = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdCoderHeader(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdCoderHeader_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdEMailAddress
  ,IdCoderHeader
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdCoderHeader]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdCoderHeader(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTransfer', '( bit7, bit8, iso2022jp )');
  CL.AddTypeS('CSET2', 'set of Char');
 CL.AddDelphiFunction('Function EncodeAddressItem( EmailAddr : TIdEmailAddressItem; const HeaderEncoding : Char; TransferHeader : TTransfer; MimeCharSet : string) : string');
 CL.AddDelphiFunction('Function EncodeHeader( const Header : string; specials : CSET2; const HeaderEncoding : Char; TransferHeader : TTransfer; MimeCharSet : string) : string');
 CL.AddDelphiFunction('Function Encode2022JP( const S : string) : string');
 CL.AddDelphiFunction('Function EncodeAddress( EmailAddr : TIdEMailAddressList; const HeaderEncoding : Char; TransferHeader : TTransfer; MimeCharSet : string) : string');
 CL.AddDelphiFunction('Function DecodeHeader( Header : string) : string');
 CL.AddDelphiFunction('Function Decode2022JP( const S : string) : string');
 CL.AddDelphiFunction('Procedure DecodeAddress( EMailAddr : TIdEmailAddressItem)');
 CL.AddDelphiFunction('Procedure DecodeAddresses( AEMails : String; EMailAddr : TIdEmailAddressList)');
 CL.AddDelphiFunction('Procedure InitializeISO( var TransferHeader : TTransfer; var HeaderEncoding : char; var CharSet : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCoderHeader_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EncodeAddressItem, 'EncodeAddressItem', cdRegister);
 S.RegisterDelphiFunction(@EncodeHeader, 'EncodeHeader', cdRegister);
 S.RegisterDelphiFunction(@Encode2022JP, 'Encode2022JP', cdRegister);
 S.RegisterDelphiFunction(@EncodeAddress, 'EncodeAddress', cdRegister);
 S.RegisterDelphiFunction(@DecodeHeader, 'DecodeHeader', cdRegister);
 S.RegisterDelphiFunction(@Decode2022JP, 'Decode2022JP', cdRegister);
 S.RegisterDelphiFunction(@DecodeAddress, 'DecodeAddress', cdRegister);
 S.RegisterDelphiFunction(@DecodeAddresses, 'DecodeAddresses', cdRegister);
 S.RegisterDelphiFunction(@InitializeISO, 'InitializeISO', cdRegister);
end;

 
 
{ TPSImport_IdCoderHeader }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoderHeader.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdCoderHeader(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCoderHeader.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdCoderHeader_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
