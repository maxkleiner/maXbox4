(******************************************************************************)
(*                                                                            *)
(*   Netzwerk-Tools                                                           *)
(*                                                                            *)
(*   (c) 1999 Rainer Reusch & Toolbox                                         *)
(*                                                                            *)
(*   Borland Delphi 3,4                                                       *)
(*                                                                            *)
(******************************************************************************)

unit NetTools;

interface

uses
  Windows, SysUtils;

type
  TDrivesProperty = array['A'..'Z'] of boolean;
  TPasswordUsage  = (pu_None, pu_Default, pu_Defined);  // Paßwort bei Laufwerk-Mapping

function TrimNetResource(UNC : string) : string;
// Entfernt alle Unterverzeichnisse einer UNC-Pfadangabe, das heißt, es
// bleibt nur der Rechnername und Netzwerkressource übrig.

procedure GetFreeDrives(var FreeDrives : TDrivesProperty);
// Ermitteln, welche Laufwerksbuchstaben noch frei sind (ab C:)
// Das boolsche Array 'A'..'Z' wird entsprechend besetzt
// true: Laufwerksbuchstabe ist noch frei

procedure GetMappedDrives(var MappedDrives : TDrivesProperty);
// Ermitteln, welche Laufwerksbuchstaben einer Netzwerkressource zugeordnet sind
// Das boolsche Array 'A'..'Z' wird entsprechend besetzt
// true: Laufwerksbuchstabe ist Netzlaufwerk

function MapDrive(UNCPath : string; Drive : char;
                  PasswordUsage : TPasswordUsage; Password : string;
                  UserUsage     : TPasswordUsage; User : string;
                  Comment : string) : boolean;
// Netzlaufwerk mappen
// UNCPath: Netzwerkpfad bestehend aus \\Rechner\Netzressource
// Drive  : lokaler Laufwerksbuchstabe, der dem Netzwerkpfad zugeordnet werden soll
// PasswordUsage: kein, aktuelles oder in Password angegebenes Paßwort verwenden
// Password: zu verwendendes Paßwort, wenn PasswordUsage=pu_Defined
// Comment: Kommentar
// Funktionsergebnis: true, wenn Aktion erfogreich

function UnmapDrive(Drive : char; Force : boolean) : boolean;
// Mapping eines Netzlaufwerks aufheben
// Drive: Buchstabe des gemappten Laufwerks
// Force: true = Aufhebung erzwingen
// Funktionsergebnis: true, wenn Aktion erfolgreich

implementation

const
  DriveName : array[0..3] of char = 'A:'+#0+#0;

function TrimNetResource(UNC : string) : string;
var
  i, n : integer;
begin
  Result:=UNC;
  if Length(UNC)>0 then
  begin
    i:=0;
    n:=0;
    repeat
      inc(i);
      inc(n,ord(UNC[i]='\'));
    until (i=Length(UNC)) or (n=4);
    if n=4 then Result:=Copy(UNC,1,i-1)
  end;
end;

procedure GetFreeDrives(var FreeDrives : TDrivesProperty);
var
  d : char;
begin
  for d:='C' to 'Z' do
  begin
    DriveName[0]:=d;
    FreeDrives[d]:=GetDriveType(@DriveName)<2;
  end;
end;

procedure GetMappedDrives(var MappedDrives : TDrivesProperty);
var
  d : char;
begin
  for d:='A' to 'Z' do
  begin
    DriveName[0]:=d;
    MappedDrives[d]:=GetDriveType(@DriveName)=DRIVE_REMOTE;
  end;
end;

function MapDrive(UNCPath : string; Drive : char;
                  PasswordUsage : TPasswordUsage; Password : string;
                  UserUsage     : TPasswordUsage; User : string;
                  Comment : string) : boolean;
var
  NetResource : TNetResource;
  pwd      : array[0..255] of char;
  username : array[0..255] of char;
  p    : PChar;
  u    : PChar;
begin
  DriveName[0]:=Drive;
  with NetResource do
  begin
    dwScope:=RESOURCE_GLOBALNET;
    dwType:=RESOURCETYPE_DISK;
    dwDisplayType:=RESOURCEDISPLAYTYPE_GENERIC;
    dwUsage:=RESOURCEUSAGE_CONNECTABLE;
    lpLocalName:=@DriveName;
    lpRemoteName:=PChar(UNCPath);
    lpComment:=PChar(Comment);
    lpProvider:=nil;
  end;
  p:=@pwd;
  case PasswordUsage of
    pu_None    : pwd[0]:=#0;
    pu_Default : p:=nil;
    pu_Defined : StrPCopy(@pwd,Password);
  end { case };
  u:=@username;
  case UserUsage of
    pu_None    : username[0]:=#0;
    pu_Default : u:=nil;
    pu_Defined : StrPCopy(@username,User);
  end { case };
  Result:=WNetAddConnection2(NetResource,p,u,CONNECT_UPDATE_PROFILE)=NO_ERROR;
end;

function UnmapDrive(Drive : char; Force : boolean) : boolean;
begin
  DriveName[0]:=Drive;
  Result:=WNetCancelConnection2(@DriveName,CONNECT_UPDATE_PROFILE,Force)=NO_ERROR;
end;

end.
