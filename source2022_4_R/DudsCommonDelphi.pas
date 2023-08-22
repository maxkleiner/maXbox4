//------------------------------------------------------------------------------
//
// The contents of this file are subject to the Mozilla Public License
// Version 2.0 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under
// the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; either version 2.1 of the License, or (at your
// option) any later version. You may obtain a copy of the LGPL at
// http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// Orginally released as freeware then open sourced in July 2017.
//
// The initial developer of the original code is Easy-IP AS
// (Oslo, Norway, www.easy-ip.net), written by Paul Spencer Thornton -
// paul.thornton@easy-ip.net.
//
// (C) 2017 Easy-IP AS. All Rights Reserved.
//http://stella.kojot.co.hu/Delphi/Trukkok/DelphiGrafika/index.html?unittool_pas.htm
//
//------------------------------------------------------------------------------

unit DudsCommonDelphi;

interface

uses
  Classes, SysUtils,

  Windows, Registry, Graphics, Math;

  //Duds.Common.Utils;

type

//    Float = Single;
  TStringDynArray  = array of string;

function DelphiIDERunning: Boolean;
function GetDelphiVersionRegistryKey(Version: Integer): String;
function GetDelphiRootDirectory(Version: Integer): String;
function IsDelphiVersionInstalled(Version: Integer): Boolean;
function GetDelphiEnvironmentVariables(Version: Integer; const EnvironmentVariables: TStrings): Boolean;
function GetDelphiLibraryPaths(Version: Integer; const LibraryPaths: TStrings; EvaluateMacros: Boolean = TRUE; CheckPaths: Boolean = TRUE): Boolean;
function StrConcat(ArrS:array of string;Space:string):string;
function StrDelSpc(s:string):string;
function StrSplit2(S:string;Ch:char):TStringDynArray;
procedure StrReplaceFirst(var S:string;olds,news:string);
  procedure StrReplaceLast(var S:string;OldS,NewS:string);
  //Other
  procedure ConvertV3ToS(X,Y,Z:extended;var r,a,b:extended);
  procedure ConvertSToV3(R,A,B:extended;var X,Y,Z:extended);
  procedure InterpolateColor(Color0,Color1:TColor;Count:integer;var TempColor:array of TColor);
  function TryStrToextended(const S: string; out Value: extended): Boolean;


implementation

function DelphiIDERunning: Boolean;
begin
  Result := FindWindow('TAppBuilder', nil) <> 0;
end;

function StrConcat(ArrS:array of string;Space:string):string;
var
  i:integer;
  S:string;
 begin
  S:=ArrS[0];
  for i:=1 to Length(ArrS)-1 do
      S:=S+Space+ArrS[i];
  Result:=S;
end;

function StrDelSpc(s:string):string;
var i:integer;
begin
 i:=1;
 while(i<=length(s))do
    if(s[i]=' ')then delete(s,i,1)else inc(i);
 result:=uppercase(s);
end;

procedure StrReplaceFirst(var S:string;Olds,News:string);
var k:integer;
begin
  k:=pos(olds,S);
  if (k>0) then begin
      delete(s,k,length(olds));
      insert(news,s,k);
  end;
end;


procedure StrReplaceLast(var S:string;OldS,NewS:string);
var k,l:integer;
begin
  l:=length(S)-length(OldS)+1;
  for k:=l downto 1 do
      if (S[k]=OldS[1]) then
          if copy(S,k,length(OldS))=OldS then break;
  if k>0 then begin
      delete(s,k,length(olds));
      insert(news,s,k);
  end;
end;

{
procedure StrReplaceFirst(var S:string;Olds,News:string);
var k:integer;
begin
  k:=pos(olds,S);
  if (k>0) then begin
      delete(s,k,length(olds));
      insert(news,s,k);
  end;
end;

procedure StrReplaceLast(var S:string;OldS,NewS:string);
var k,l:integer;
begin
  l:=length(S)-length(OldS)+1;
  for k:=l downto 1 do
      if (S[k]=OldS[1]) then
          if copy(S,k,length(OldS))=OldS then break;
  if k>0 then begin
      delete(s,k,length(olds));
      insert(news,s,k);
  end;
end;  }


function StrReplace(s:string;olds,news:string):string;
begin
  Result:=StringReplace(s,olds,news,[rfReplaceAll, rfIgnoreCase]);
end;


function StrSplit2(S:string;Ch:char):TStringDynArray;
var
  i,Count:integer;
  ArrS:TStringDynArray;
begin
  if (S = '') then
      begin Result := nil; exit; end;
  if (S[length(s)]<>Ch) then S:=S+Ch;
  //Count Ch
  Count:=0;
  for i:=1 to length(S)do
      if (s[i]=ch) then inc(Count);
  //Create New Array
  SetLength(ArrS,Count);
  //Fill up Array
  Count:=0;
  i:=Pos(Ch,S);
  while(i>0)do begin
      ArrS[Count]:=copy(S,1,i-1);
      inc(Count);
      //Find Next
      delete(s,1,i);
      i:=pos(Ch,S);
  end;
  Result:=ArrS;
end;

//-----------------------------------OTHER-----------------------------------

 

procedure InterpolateColor(Color0, Color1:TColor; Count:integer;var TempColor: array of TColor);
var
  R0,G0,B0,R1,G1,B1:byte;
  R,G,B:real;
  i:integer;

begin
  R0:=Color0 and $FF;
  G0:=(Color0 and $FF00)shr 8;
  B0:=(Color0 and $FF0000)shr 16;
  R1:=Color1 and $FF;
  G1:=(Color1 and $FF00)shr 8;
  B1:=(Color1 and $FF0000)shr 16;
  R:=(R1-R0)/(Count-1);G:=(G1-G0)/(Count-1);B:=(B1-B0)/(Count-1);
  for i:=0 to Count-1 do
  begin
      R1:=round(R0+i*R);
      G1:=round(G0+i*G);
      B1:=round(B0+i*B);
      TempColor[i]:=R1+(G1 shl 8)+(B1 shl 16);
  end;
end;


procedure ConvertV3ToS(X,Y,Z:extended;var r,a,b:extended);
begin
  if(X=0)and(Y=0)and(Z=0)then exit;
  R:=Sqrt(X*X+Y*Y+Z*Z);
  if(Y=0)then
      begin
          if(X>0)then a:=pi/2 else a:=-PI/2;
      end
  else
      begin
          a:=Arctan(X/Y);
          if(a*X<0)then a:=a+PI;
      end;
  b:=Arccos(Z/r);
end;



procedure ConvertSToV3(R,A,B:extended;var X,Y,Z:extended);
begin
  Y:=r*Sin(b)*Cos(a);
  X:=r*Sin(b)*Sin(a);
  Z:=r*Cos(b);
end;

  function TryStrToextended(const S: string; out Value: extended): Boolean;
  begin
       Result := TextToFloat(PChar(S), Value, fvExtended);
  end;

function GetDelphiVersionRegistryKey(Version: Integer): String;
begin
  Result := '';

  case Version of
    15: Result := '\Software\Embarcadero\BDS\8.0';
    16: Result := '\Software\Embarcadero\BDS\9.0';
    17: Result := '\Software\Embarcadero\BDS\10.0';
  end;
end;

function GetDelphiRootDirectory(Version: Integer): String;
var
  Reg: TRegistry;
  DelphiKey: String;
begin
  Result := '';

  DelphiKey := GetDelphiVersionRegistryKey(Version);

  if DelphiKey <> '' then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;

      // Find the Delphi root directory
      if (Reg.OpenKey(DelphiKey, FALSE)) and
         (Reg.ValueExists('RootDir')) then
        Result := Reg.ReadString('RootDir');

      Reg.CloseKey;
    finally
      FreeAndNil(Reg);
    end;
  end;
end;

function IsDelphiVersionInstalled(Version: Integer): Boolean;
begin
  Result := GetDelphiRootDirectory(Version) <> '';
end;

function GetDelphiEnvironmentVariables(Version: Integer; const EnvironmentVariables: TStrings): Boolean;
var
  Reg: TRegistry;
  DelphiKey: String;
  i: Integer;
begin
  Result := FALSE;

  DelphiKey := GetDelphiVersionRegistryKey(Version);

  if DelphiKey <> '' then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;

      // Open the key that contains all the delphi library paths
      if (Reg.OpenKey(DelphiKey + '\Environment Variables', FALSE)) then
      begin
        Reg.GetValueNames(EnvironmentVariables);

        for i := 0 to pred(EnvironmentVariables.Count) do
          EnvironmentVariables[i] := EnvironmentVariables[i] + '=' + Reg.ReadString(EnvironmentVariables[i]);

        Result := TRUE;
      end;

      Reg.CloseKey;
    finally
      FreeAndNil(Reg);
    end;
  end;
end;

function GetDelphiLibraryPaths(Version: Integer; const LibraryPaths: TStrings; EvaluateMacros, CheckPaths: Boolean): Boolean;
var
  Reg: TRegistry;
  DelphiKey, DelphiPath, KeyName, TempPath, SearchPath: String;
  i, n: Integer;
  EnvironmentVariables, DelphiPaths: TStringList;
begin
  Result := FALSE;

  DelphiKey := GetDelphiVersionRegistryKey(Version);

  if DelphiKey <> '' then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;

      EnvironmentVariables := TStringList.Create;
      DelphiPaths := TStringList.Create;
      try
        if EvaluateMacros then
          GetDelphiEnvironmentVariables(Version, EnvironmentVariables);

        KeyName := 'Search Path';
        DelphiPath := GetDelphiRootDirectory(Version);

        // Open the key that contains all the delphi library paths
        if (Reg.OpenKey(DelphiKey + '\Library\Win32', FALSE)) and
           (Reg.ValueExists(KeyName)) then
        begin
          SearchPath := Reg.ReadString(KeyName);
          SearchPath := concat('"', StringReplace(SearchPath, ';', '","', [rfReplaceAll, rfIgnoreCase]), '"');

          // if we have a delphi root directory, replace all the $(DELPHI) macros
          if DelphiPath <> '' then
            SearchPath := StringReplace(SearchPath, '$(DELPHI)', DelphiPath, [rfReplaceAll, rfIgnoreCase]);

          DelphiPaths.CommaText := SearchPath;

          LibraryPaths.BeginUpdate;
          try
            // Add the paths that exist
            for i := 0 to pred(DelphiPaths.Count) do
              for n := 0 to pred(EnvironmentVariables.Count) do
              begin
                TempPath := DelphiPaths[i];

                if EvaluateMacros then
                  TempPath := StringReplace(TempPath, format('$(%s)',
                                            [EnvironmentVariables.Names[n]]),
                                             EnvironmentVariables.Values[EnvironmentVariables.Names[n]],
                                            [rfReplaceAll, rfIgnoreCase]);

                if (not CheckPaths) or
                   ((CheckPaths) and (DirectoryExists(TempPath))) then
                  LibraryPaths.Add(TempPath);
              end;

            Result := TRUE;
          finally
            LibraryPaths.EndUpdate;
          end;
        end;
      finally
        FreeAndNil(EnvironmentVariables);
        FreeAndNil(DelphiPaths);
      end;

      Reg.CloseKey;
    finally
      FreeAndNil(Reg);
    end;
  end;
end;

end.
