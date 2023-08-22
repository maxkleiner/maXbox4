{
Mystix
Copyright (C) 2005  Piotr Jura

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

You can contact with me by e-mail: pjura@o2.pl
}
unit uMRU;

interface

uses
	Classes, SysUtils, IniFiles;

type
	TMRUList = class
  private
  	fMRUList: TStringList;
    fLimit: Integer;
    fMyIniFile: TIniFile;
    fIniSection: String;
    function GetItem(Index: Integer): String;
    procedure Read;
    procedure Write;
    function GetCount: Integer;
  public
  	constructor Create(aMyIniFile: TIniFile; aLimit: Integer;
    	aIniSection: String);
    destructor Destroy; override;

    procedure Add(Item: String);
    procedure Clear;

    property AllItems: TStringList read fMRUList;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: String read GetItem; default;
  end;

implementation

{ TMRUList }

procedure TMRUList.Add(Item: String);
begin
	if fMRUList.IndexOf(Item) <> -1 then
  	fMRUList.Delete(fMRUList.IndexOf(Item));

  fMRUList.Insert(0, Item);

  if fMRUList.Count > fLimit then
  	fMRUList.Delete(fLimit);
end;

procedure TMRUList.Clear;
begin
  fMRUList.Clear;
end;

constructor TMRUList.Create(aMyIniFile: TIniFile; aLimit: Integer;
  aIniSection: String);
begin
	fMyIniFile := aMyIniFile;
  fLimit := aLimit;
  fIniSection := aIniSection;
  fMRUList := TStringList.Create;
  Read;
end;

destructor TMRUList.Destroy;
begin
	Write;
  fMRUList.Free;
  inherited;
end;

function TMRUList.GetCount: Integer;
begin
	Result := fMRUList.Count;
end;

function TMRUList.GetItem(Index: Integer): String;
begin
	Result := fMRUList[Index];
end;

procedure TMRUList.Read;
var
	i: Integer;
begin
	i := 1;

	while (fMyIniFile.ValueExists(fIniSection, 'MRUItem' + IntToStr(i)))
  and (i <= fLimit) do
	begin
		fMRUList.Add( fMyIniFile.ReadString(fIniSection, 'MRUItem' + IntToStr(i), '') );
		Inc(i);
	end;
end;

procedure TMRUList.Write;
var
	i: Integer;
begin
	for i := 1 to fMRUList.Count do
		fMyIniFile.WriteString(fIniSection, 'MRUItem' + IntToStr(i), fMRUList[i - 1]);
end;

end.
