{
--------------------------------------------------------------------------------
SimpleRSS Version 0.4 (BlueHippo)

http://simplerss.sourceforge.net
Provides a simple methods for accessing, importing, exporting and working with RSS, RDF, Atom & iTunes Feeds

SimpleRSS Originally Created By Robert MacLean
SimpleRSS (C) Copyright 2003-2005 Robert MacLean. All Rights Reserved World Wide

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.
This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

This File Originally Created By Robert MacLean <dfantom@gmail.com> 2005
--------------------------------------------------------------------------------
}
unit iTunesTypes;

interface

Uses
  Classes, SysUtils;

Type
  TiTunesCategory = class(TPersistent)
  Private
    FSubCategory: String;
    FCategory: String;
    procedure SetCategory(const Value: String);
    procedure SetSubCategory(const Value: String);
  Published
    Property Category:String Read FCategory Write SetCategory;
    Property SubCategory:String Read FSubCategory Write SetSubCategory;
  end; // TiTunesCateogry

Type
  TiTunesOwner = class(TPersistent)
  Private
    FName: String;
    FEmailAddress: String;
    procedure SetEmailAddress(const Value: String);
    procedure SetName(const Value: String);
  Published
    Property Name:String Read FName Write SetName;
    Property EmailAddress:String Read FEmailAddress Write SetEmailAddress;
  end; // TiTunesOwner

type
  TiTunesKeyword = class(TCollectionItem)
  private
    FValue: String;
  published
    property Value:String Read FValue Write FValue;
  end;

type
  TiTunesKeywords = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TiTunesKeyword;
    procedure SetItem(Index: Integer; Value: TiTunesKeyword);
    function GetKeywords: String;
    procedure SetKeyWords(const aValue: String);
  public
    function Add: TiTunesKeyword;
    function Insert(Index: Integer): TiTunesKeyword;
    property Items[Index: Integer]: TiTunesKeyword read GetItem write SetItem; default;
    Property Keywords:String Read GetKeywords Write SetKeyWords;
  end;

Type
  TiTunesChannelExtra = class(TPersistent)
  Private
    FExplict: Boolean;
    FOwner: TiTunesOwner;
    FSubtitle: String;
    FSummary: String;
    FCategory: TiTunesCategory;
    FBlock: Boolean;
    FKeyWords: TiTunesKeywords;
    FAuthor: String;
    FImage: String;
    procedure SetBlock(const Value: Boolean);
    procedure SetCategory(const Value: TiTunesCategory);
    procedure SetExplict(const Value: Boolean);
    procedure SetKeyWords(const Value: TiTunesKeywords);
    procedure SetOwner(const Value: TiTunesOwner);
    procedure SetSubtitle(const Value: String);
    procedure SetSummary(const Value: String);
    procedure SetAuthor(const Value: String);
    procedure SetImage(const Value: String);
  Public
    constructor Create;
    Destructor Destroy;override;
    Function StrExplict:String;
    Function GetKeywordsAsString:String;
    Procedure SetKeywordsFromString(Keywords:String);
  Published
    Property Block:Boolean Read FBlock Write SetBlock;
    Property Category:TiTunesCategory Read FCategory Write SetCategory;
    Property Explict:Boolean Read FExplict Write SetExplict;
    Property KeyWords:TiTunesKeywords Read FKeyWords Write SetKeyWords;
    Property Owner: TiTunesOwner Read FOwner Write SetOwner;
    Property Subtitle:String Read FSubtitle Write SetSubtitle;
    Property Summary:String Read FSummary Write SetSummary;
    Property Author:String Read FAuthor Write SetAuthor;
    Property Image:String Read FImage Write SetImage;
  end; // TiTunesChannelExtra

Type
  TiTunesDuration = class(TPersistent)
  Private
    FSecond: Integer;
    FMinute: Integer;
    FHour: Integer;
    function GetDuration: String;
    procedure SetDuration(const Value: String);
    procedure SetHour(const Value: Integer);
    procedure SetMinute(const Value: Integer);
    procedure SetSecond(const Value: Integer);
  Published
    Property Hour:Integer Read FHour Write SetHour;
    Property Minute:Integer Read FMinute Write SetMinute;
    Property Second:Integer Read FSecond Write SetSecond;
    Property Duration:String Read GetDuration Write SetDuration;
  end; // TiTunesDuration

Type
  TiTunesItemExtra = class(TPersistent)
  Private
    FExplict: Boolean;
    FSubtitle: String;
    FSummary: String;
    FCategory: TiTunesCategory;
    FBlock: Boolean;
    FKeyWords: TiTunesKeywords;
    FAuthor: String;
    FDuration: TiTunesDuration;
    procedure SetBlock(const Value: Boolean);
    procedure SetCategory(const Value: TiTunesCategory);
    procedure SetExplict(const Value: Boolean);
    procedure SetKeyWords(const Value: TiTunesKeywords);
    procedure SetSubtitle(const Value: String);
    procedure SetSummary(const Value: String);
    procedure SetAuthor(const Value: String);
    procedure SetDuration(const Value: TiTunesDuration);
  Public
    constructor Create;
    Destructor Destroy;override;
    Function StrExplict:String;
    Function GetKeywordsAsString:String;
    Procedure SetKeywordsFromString(Keywords:String);
  Published
    Property Author:String Read FAuthor Write SetAuthor;
    Property Duration:TiTunesDuration Read FDuration Write SetDuration;
    Property Block:Boolean Read FBlock Write SetBlock;
    Property Category:TiTunesCategory Read FCategory Write SetCategory;
    Property Explict:Boolean Read FExplict Write SetExplict;
    Property KeyWords:TiTunesKeywords Read FKeyWords Write SetKeyWords;
    Property Subtitle:String Read FSubtitle Write SetSubtitle;
    Property Summary:String Read FSummary Write SetSummary;
  end; // TiTunesItemExtra


implementation

uses SimpleRSSConst;

procedure SetKeywordsFromString(KeywordsStr: String;Keywords:TiTunesKeywords);
Var
  aDummy : String;
  aPosResult : Integer;
begin
  aDummy := Trim(KeywordsStr);
  If Length(aDummy) = 0 then
    Exit;
  aPosResult := Pos(#32,aDummy);
  While aPosResult <> 0 do
    Begin
      With KeyWords.Add do
        Value := Copy(aDummy,1,aPosResult-1);
      Delete(aDummy,1,aPosResult);
      aPosResult := Pos(#32,aDummy);
    end;
  With KeyWords.Add do
    Value := aDummy;
end;

function GetKeywordsAsString(Keywords:TiTunesKeywords): String;
Var
  aCounter : Integer;
begin
  For aCounter := 0 to KeyWords.Count-1 do
    Begin
      If aCounter > 0 then
        Result := Result + #32;
      Result := Result + KeyWords.Items[aCounter].Value;
    end; // for 2 do
end;

Procedure BBC(S:String;Start,Count:Integer);
// Bloody Buggy Compiler
// The SetKeyWords procedure can not use the System.Delete method under .net due to a name conflict
// and you can not specify the system name space :/
// This just acts as wrapper for the system.delete method
Begin
  Delete(S,Start,Count);
end; // BBC

{ TitTunesCategory }

procedure TiTunesCategory.SetSubCategory(const Value: String);
begin
  If Value <> FSubCategory then
    Begin
      FSubCategory := Value;
    end; // if then
end;

procedure TiTunesCategory.SetCategory(const Value: String);
begin
  If Value <> FCategory then
    Begin
      FCategory := Value;
    end; // if then
end;

{ TiTunesOwner }

procedure TiTunesOwner.SetName(const Value: String);
begin
  If Value <> FName then
    Begin
      FName := Value;
    end; // if then
end;

procedure TiTunesOwner.SetEmailAddress(const Value: String);
begin
  If Value <> FEmailAddress then
    Begin
      FEmailAddress := Value;
    end; // if then
end;

{ TiTunesKeywords }

function TiTunesKeywords.GetKeywords: String;
Var
  Counter : Integer;
begin
  Result := '';
  For Counter := 0 to Self.Count-1 do
    Begin
      Result := Result + ' ' + Self.Items[Counter].Value;
    end; // for 2 do
end;
procedure TiTunesKeywords.SetKeyWords(const aValue: String);
Var
  Dummy : String;
  SpacePos : Integer;
begin
  Clear;
  If Length(aValue) = 0 then
    Exit; // no values

  If Pos(' ',aValue) = 0 then
    Begin
      //no spaces must be one word
      With Add do
        Value := aValue;
      Exit;
    end // if then
  else
    Begin
      // must be atleast two keywords
      Dummy := aValue;
      Repeat
        If Dummy[1] = ' ' then
          BBC(Dummy,1,1);
        SpacePos := Pos(' ',Dummy)-1;
        If SpacePos < 1 then
          SpacePos := Length(Dummy);
        With Add do
          Value := Copy(Dummy,1,SpacePos);
        BBC(Dummy,1,SpacePos);
      until Length(Dummy)=0;
    end; // if else
end;

function TiTunesKeywords.Add: TiTunesKeyword;
begin
  Result := TiTunesKeyword(inherited Add);
end;

function TiTunesKeywords.GetItem(Index: Integer): TiTunesKeyword;
begin
  Result := TiTunesKeyword(inherited GetItem(Index));
end;

procedure TiTunesKeywords.SetItem(Index: Integer; Value: TiTunesKeyword);
begin
  inherited SetItem(Index,Value);
end;

function TiTunesKeywords.Insert(Index: Integer): TiTunesKeyword;
begin
  Result := TiTunesKeyword(inherited Insert(Index));
end;

{ TiTunesChannelExtra }

procedure TiTunesChannelExtra.SetExplict(const Value: Boolean);
begin
  If Value <> FExplict then
    Begin
      FExplict := Value;
    end; // if then
end;

procedure TiTunesChannelExtra.SetOwner(const Value: TiTunesOwner);
begin
  FOwner := Value;
end;

procedure TiTunesChannelExtra.SetSubtitle(const Value: String);
begin
  If Value <> FSubtitle then
    Begin
      FSubtitle := Value;
    end; // if then
end;

procedure TiTunesChannelExtra.SetSummary(const Value: String);
begin
  If Value <> FSummary then
    Begin
      If Length(Value) > 4000 then
        FSummary := Copy(Value,1,4000)
      else
        FSummary := Value;
    end; // fi then
end;

procedure TiTunesChannelExtra.SetCategory(const Value: TiTunesCategory);
begin
  FCategory := Value;
end;

procedure TiTunesChannelExtra.SetBlock(const Value: Boolean);
begin
  FBlock := Value;
end;

procedure TiTunesChannelExtra.SetKeyWords(const Value: TiTunesKeywords);
begin
  FKeyWords := Value;
end;

constructor TiTunesChannelExtra.Create;
begin
  inherited;
  FKeyWords := TiTunesKeywords.Create(Self,TiTunesKeyword);
  FCategory := TiTunesCategory.Create;
  FOwner := TiTunesOwner.Create;
  FBlock := False;
  FExplict := False;
end;


destructor TiTunesChannelExtra.Destroy;
begin
  FOwner.Free;
  FCategory.Free;
  FKeyWords.Free;
  inherited;
end;

procedure TiTunesChannelExtra.SetAuthor(const Value: String);
begin
  FAuthor := Value;
end;

procedure TiTunesChannelExtra.SetImage(const Value: String);
begin
  FImage := Value;
end;

function TiTunesChannelExtra.StrExplict: String;
begin
  If FExplict then
    Result := itunesYes
  else
    Result := itunesNo;
end;

procedure TiTunesChannelExtra.SetKeywordsFromString(Keywords: String);
begin
  iTunesTypes.SetKeywordsFromString(Keywords,FKeywords);
end;

function TiTunesChannelExtra.GetKeywordsAsString: String;
begin
  Result := iTunesTypes.GetKeywordsAsString(FKeyWords);
end;

{ TiTunesDuration }

procedure TiTunesDuration.SetSecond(const Value: Integer);
begin
  FSecond := Value;
end;

function TiTunesDuration.GetDuration: String;
begin
  Result := IntToStr(FHour)+':'+IntToStr(FMinute)+':';
  If FSecond < 10 then
    Result := Result + '0'+IntToStr(FSecond)
  else
    Result := Result + IntToStr(FSecond);
end;

procedure TiTunesDuration.SetDuration(const Value: String);
Var
  Dummy : String;
begin
  Dummy := Value;
  FHour := StrToInt(Copy(Dummy,1,Pos(':',Dummy)-1));
  Delete(Dummy,1,Pos(':',Dummy));
  FMinute := StrToInt(Copy(Dummy,1,Pos(':',Dummy)-1));
  Delete(Dummy,1,Pos(':',Dummy));
  FSecond := StrToInt(Copy(Dummy,1,Length(Dummy)));
end;

procedure TiTunesDuration.SetMinute(const Value: Integer);
begin
  FMinute := Value;
end;

procedure TiTunesDuration.SetHour(const Value: Integer);
begin
  FHour := Value;
end;

{ TiTunesItemExtra }

procedure TiTunesItemExtra.SetAuthor(const Value: String);
begin
  FAuthor := Value;
end;

procedure TiTunesItemExtra.SetDuration(const Value: TiTunesDuration);
begin
  FDuration := Value;
end;

constructor TiTunesItemExtra.Create;
begin
  inherited;
  FCategory := TiTunesCategory.Create;
  FDuration := TiTunesDuration.Create;
  FKeyWords := TiTunesKeywords.Create(Self,TiTunesKeyword);
end;

procedure TiTunesItemExtra.SetExplict(const Value: Boolean);
begin
  FExplict := Value;
end;

procedure TiTunesItemExtra.SetSubtitle(const Value: String);
begin
  FSubtitle := Value;
end;

procedure TiTunesItemExtra.SetSummary(const Value: String);
begin
  If Length(Value) > 4000 then
    FSummary := Copy(Value,1,4000)
  else
    FSummary := Value;
end;

procedure TiTunesItemExtra.SetCategory(const Value: TiTunesCategory);
begin
  FCategory := Value;
end;

procedure TiTunesItemExtra.SetBlock(const Value: Boolean);
begin
  FBlock := Value;
end;

destructor TiTunesItemExtra.Destroy;
begin
  FKeyWords.Free;
  FDuration.Free;
  FCategory.Free;
  inherited;
end;

procedure TiTunesItemExtra.SetKeyWords(const Value: TiTunesKeywords);
begin
  FKeyWords := Value;
end;

function TiTunesItemExtra.StrExplict: String;
begin
  If FExplict then
    Result := itunesYes
  else
    Result := itunesNo;
end;

procedure TiTunesItemExtra.SetKeywordsFromString(Keywords: String);
begin
  iTunesTypes.SetKeywordsFromString(KeyWords,FKeyWords);
end;

function TiTunesItemExtra.GetKeywordsAsString: String;
begin
  Result := iTunesTypes.GetKeywordsAsString(FKeyWords);
end;

end.
