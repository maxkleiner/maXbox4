unit uPSI_ip_misc;
{
   another ip stack
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
  TPSImport_ip_misc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ip_misc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ip_misc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   winprocs
  ,wintypes
  ,windows
  ,winsock
  ,ip_misc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ip_misc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ip_misc(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('INVALID_IP_ADDRESS','LongWord').SetUInt( $ffffffff);
  CL.AddTypeS('t_encoding', '( uuencode, base64, mime )');
 CL.AddDelphiFunction('Function internet_date( date : TDateTime) : string');
 CL.AddDelphiFunction('Function lookup_hostname( const hostname : string) : longint');
 CL.AddDelphiFunction('Function my_hostname : string');
 CL.AddDelphiFunction('Function my_ip_address : longint');
 CL.AddDelphiFunction('Function ip2string( ip_address : longint) : string');
 CL.AddDelphiFunction('Function resolve_hostname( ip : longint) : string');
 CL.AddDelphiFunction('Function address_from( const s : string; count : integer) : string');
 CL.AddDelphiFunction('Function encode_base64( data : TStream) : TStringList');
 CL.AddDelphiFunction('Function decode_base64( source : TStringList) : TMemoryStream');
 CL.AddDelphiFunction('Function posn( const s, t : string; count : integer) : integer');
 CL.AddDelphiFunction('Function poscn( c : char; const s : string; n : integer) : integer');
 CL.AddDelphiFunction('Function filename_of( const s : string) : string');
 //CL.AddDelphiFunction('Function trim( const s : string) : string');
 //CL.AddDelphiFunction('Procedure setlength( var s : string; l : byte)');
 CL.AddDelphiFunction('Function TimeZoneBias : longint');
 CL.AddDelphiFunction('Function eight2seven_quoteprint( const s : string) : string');
 CL.AddDelphiFunction('Function eight2seven_german( const s : string) : string');
 CL.AddDelphiFunction('Function seven2eight_quoteprint( const s : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ip_misc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@internet_date, 'internet_date', cdRegister);
 S.RegisterDelphiFunction(@lookup_hostname, 'lookup_hostname', cdRegister);
 S.RegisterDelphiFunction(@my_hostname, 'my_hostname', cdRegister);
 S.RegisterDelphiFunction(@my_ip_address, 'my_ip_address', cdRegister);
 S.RegisterDelphiFunction(@ip2string, 'ip2string', cdRegister);
 S.RegisterDelphiFunction(@resolve_hostname, 'resolve_hostname', cdRegister);
 S.RegisterDelphiFunction(@address_from, 'address_from', cdRegister);
 S.RegisterDelphiFunction(@encode_base64, 'encode_base64', cdRegister);
 S.RegisterDelphiFunction(@decode_base64, 'decode_base64', cdRegister);
 S.RegisterDelphiFunction(@posn, 'posn', cdRegister);
 S.RegisterDelphiFunction(@poscn, 'poscn', cdRegister);
 S.RegisterDelphiFunction(@filename_of, 'filename_of', cdRegister);
 //S.RegisterDelphiFunction(@trim, 'trim', cdRegister);
 //S.RegisterDelphiFunction(@setlength, 'setlength', cdRegister);
 S.RegisterDelphiFunction(@TimeZoneBias, 'TimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@eight2seven_quoteprint, 'eight2seven_quoteprint', cdRegister);
 S.RegisterDelphiFunction(@eight2seven_german, 'eight2seven_german', cdRegister);
 S.RegisterDelphiFunction(@seven2eight_quoteprint, 'seven2eight_quoteprint', cdRegister);
end;

 
 
{ TPSImport_ip_misc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ip_misc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ip_misc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ip_misc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ip_misc(ri);
  RIRegister_ip_misc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
