unit AssocExec;

interface

uses
  Windows, Messages, SysUtils, Classes, {Graphics, Controls, Forms, Dialogs,} registry;

type
  TAssocExec = class(TComponent)
  private
    FFileName:String;
    FWait:Boolean;
  protected
    function GetFileName:String;
    procedure SetFileName(a:String);
//    function GetWait:Boolean;
//    procedure SetWait(a:Boolean);
  public
    function Execute:Boolean;
  published
    property FileName:String read GetFileName write SetFileName;
//    property Wait:Boolean read GetWait write SetWait default false;
  end;

procedure Register;

implementation

function TAssocExec.GetFileName:String;
begin
  result:=FFileName;
end;
{
function TAssocExec.GetWait:Boolean;
begin
  result:=FWait;
end;
}
{
procedure TAssocExec.SetWait(a:Boolean);
begin
  FWait:=a;
end;
}
procedure TAssocExec.SetFileName(a:String);
begin
  FFileName:=a;
end;

function TAssocExec.Execute:Boolean;
var
  reg:TRegistry;
  temp:String;
  x:Integer;
begin
  result:=false;
  if (not FileExists(FFileName)) then Exit;
  if (Length(FFileName)<5) then Exit;

  reg := TRegistry.Create();
  reg.RootKey:=HKEY_CLASSES_ROOT;

  temp := Copy(FFileName, Length(FFileName)-3, 4);
  if (not reg.OpenKey(temp, false)) then begin reg.Free; Exit; end;

  temp:=reg.ReadString('');
  reg.CloseKey();

  if (not reg.OpenKey(temp+'\shell\open\command', false)) then begin reg.Free; Exit; end;
  temp := reg.ReadString('');
  reg.CloseKey();
  reg.Free;

  x := Pos('%', temp);
  if x = 0 then Exit;

  Delete(temp, x, 2);
  Insert(FFileName, temp, x);

  x := WinExec(PChar(temp), SW_SHOWNORMAL);
  if x>31 then result:=true;
end;

procedure Register;
begin
  RegisterComponents('About.com', [TAssocExec]);
end;

end.
