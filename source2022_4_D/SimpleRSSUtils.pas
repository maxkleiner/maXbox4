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

This File Originally Created By Robert MacLean <dfantom@gmail.com> 2003
Additional work by:
 - Thomas Zangl <thomas@tzis.net> 2005
--------------------------------------------------------------------------------
}
unit SimpleRSSUtils;

interface

uses
  SysUtils,
  XMLIntf,
  SimpleRSSTypes,
  SimpleRSS;

function StringToLanguage(Language: string): TLanguages;
Function LanguageToString(Language: TLanguages):String;
function DecodeString(Encoding: TEncodingType; Data: string): string;
procedure GetSkipHours(RootNode: IXMLNode; var aSimpleRSS: TSimpleRSS);
procedure GetSkipDays(RootNode: IXMLNode; var aSimpleRSS: TSimpleRSS);

implementation

uses SimpleRSSConst,
  IdCoderMime, Variants;

function StringToLanguage(Language: string): TLanguages;
begin
  // default return value if no one of the languages match
  Result := langX;
  if Language = strLangAF then
    Result := langAF;
  if Language = strLangSQ then
    Result := langSQ;
  if Language = strLangEU then
    Result := langEU;
  if Language = strLangBE then
    Result := langBE;
  if Language = strLangBG then
    Result := langBG;
  if Language = strLangCA then
    Result := langCA;
  if Language = strLangZH_CN then
    Result := langZH_CN;
  if Language = strLangZH_TW then
    Result := langZH_TW;
  if Language = strLangHR then
    Result := langHR;
  if Language = strLangCS then
    Result := langCS;
  if Language = strLangDA then
    Result := langDA;
  if Language = strLangNL then
    Result := langNL;
  if Language = strLangNL_BE then
    Result := langNL_BE;
  if Language = strLangNL_NL then
    Result := langNL_NL;
  if Language = strLangEN then
    Result := langEN;
  if Language = strLangEN_AU then
    Result := langEN_AU;
  if Language = strLangEN_BZ then
    Result := langEN_BZ;
  if Language = strLangEN_CA then
    Result := langEN_CA;
  if Language = strLangEN_IE then
    Result := langEN_IE;
  if Language = strLangEN_JM then
    Result := langEN_JM;
  if Language = strLangEN_NZ then
    Result := langEN_NZ;
  if Language = strLangEN_PH then
    Result := langEN_PH;
  if Language = strLangEN_ZA then
    Result := langEN_ZA;
  if Language = strLangEN_TT then
    Result := langEN_TT;
  if Language = strLangEN_GB then
    Result := langEN_GB;
  if Language = strLangEN_US then
    Result := langEN_US;
  if Language = strLangEN_ZW then
    Result := langEN_ZW;
  if Language = strLangET then
    Result := langET;
  if Language = strLangFO then
    Result := langFO;
  if Language = strLangFI then
    Result := langFI;
  if Language = strLangFR then
    Result := langFR;
  if Language = strLangFR_BE then
    Result := langFR_BE;
  if Language = strLangFR_CA then
    Result := langFR_CA;
  if Language = strLangFR_FR then
    Result := langFR_FR;
  if Language = strLangFR_LU then
    Result := langFR_LU;
  if Language = strLangFR_MC then
    Result := langFR_MC;
  if Language = strLangFR_CH then
    Result := langFR_CH;
  if Language = strLangGL then
    Result := langGL;
  if Language = strLangGD then
    Result := langGD;
  if Language = strLangDE then
    Result := langDE;
  if Language = strLangDE_AT then
    Result := langDE_AT;
  if Language = strLangDE_DE then
    Result := langDE_DE;
  if Language = strLangDE_LI then
    Result := langDE_LI;
  if Language = strLangDE_LU then
    Result := langDE_LU;
  if Language = strLangDE_CH then
    Result := langDE_CH;
  if Language = strLangEL then
    Result := langEL;
  if Language = strLangHAW then
    Result := langHAW;
  if Language = strLangHU then
    Result := langHU;
  if Language = strLangIS then
    Result := langIS;
  if Language = strLangIN then
    Result := langIN;
  if Language = strLangGA then
    Result := langGA;
  if Language = strLangIT then
    Result := langIT;
  if Language = strLangIT_IT then
    Result := langIT_IT;
  if Language = strLangIT_CH then
    Result := langIT_CH;
  if Language = strLangJA then
    Result := langJA;
  if Language = strLangKO then
    Result := langKO;
  if Language = strLangMK then
    Result := langMK;
  if Language = strLangNO then
    Result := langNO;
  if Language = strLangPL then
    Result := langPL;
  if Language = strLangPT then
    Result := langPT;
  if Language = strLangPT_BR then
    Result := langPT_BR;
  if Language = strLangPT_PT then
    Result := langPT_PT;
  if Language = strLangRO then
    Result := langRO;
  if Language = strLangRO_MO then
    Result := langRO_MO;
  if Language = strLangRO_RP then
    Result := langRO_RP;
  if Language = strLangRU then
    Result := langRU;
  if Language = strLangRU_MO then
    Result := langRU_MO;
  if Language = strLangRU_RU then
    Result := langRU_RU;
  if Language = strLangSR then
    Result := langSR;
  if Language = strLangSK then
    Result := langSK;
  if Language = strLangSL then
    Result := langSL;
  if Language = strLangES then
    Result := langES;
  if Language = strLangES_AR then
    Result := langES_AR;
  if Language = strLangES_BO then
    Result := langES_BO;
  if Language = strLangES_CL then
    Result := langES_CL;
  if Language = strLangES_CO then
    Result := langES_CO;
  if Language = strLangES_CR then
    Result := langES_CR;
  if Language = strLangES_DO then
    Result := langES_DO;
  if Language = strLangES_EC then
    Result := langES_EC;
  if Language = strLangES_SV then
    Result := langES_SV;
  if Language = strLangES_GT then
    Result := langES_GT;
  if Language = strLangES_HN then
    Result := langES_HN;
  if Language = strLangES_MX then
    Result := langES_MX;
  if Language = strLangES_NI then
    Result := langES_NI;
  if Language = strLangES_PA then
    Result := langES_PA;
  if Language = strLangES_PY then
    Result := langES_PY;
  if Language = strLangES_PE then
    Result := langES_PE;
  if Language = strLangES_PR then
    Result := langES_PR;
  if Language = strLangES_ES then
    Result := langES_ES;
  if Language = strLangES_UY then
    Result := langES_UY;
  if Language = strLangES_VE then
    Result := langES_VE;
  if Language = strLangSV then
    Result := langSV;
  if Language = strLangSV_FI then
    Result := langSV_FI;
  if Language = strLangSV_SE then
    Result := langSV_SE;
  if Language = strLangTR then
    Result := langTR;
  if Language = strLangUK then
    Result := langUK;
end;

Function LanguageToString(Language: TLanguages):String;
Begin
  Result := '';
  If Language = langAF then
    Result := strLangAF;
  If Language = langSQ then
    Result := strLangSQ;
  If Language = langEU then
    Result := strLangEU;
  If Language = langBE then
    Result := strLangBE;
  If Language = langBG then
    Result := strLangBG;
  If Language = langCA then
    Result := strLangCA;
  If Language = langZH_CN then
    Result := strLangZH_CN;
  If Language = langZH_TW then
    Result := strLangZH_TW;
  If Language = langHR then
    Result := strLangHR;
  If Language = langCS then
    Result := strLangCS;
  If Language = langDA then
    Result := strLangDA;
  If Language = langNL then
    Result := strLangNL;
  If Language = langNL_BE then
    Result := strLangNL_BE;
  If Language = langNL_NL then
    Result := strLangNL_NL;
  If Language = langEN then
    Result := strLangEN;
  If Language = langEN_AU then
    Result := strLangEN_AU;
  If Language = langEN_BZ then
    Result := strLangEN_BZ;
  If Language = langEN_CA then
    Result := strLangEN_CA;
  If Language = langEN_IE then
    Result := strLangEN_IE;
  If Language = langEN_JM then
    Result := strLangEN_JM;
  If Language = langEN_NZ then
    Result := strLangEN_NZ;
  If Language = langEN_PH then
    Result := strLangEN_PH;
  If Language = langEN_ZA then
    Result := strLangEN_ZA;
  If Language = langEN_TT then
    Result := strLangEN_TT;
  If Language = langEN_GB then
    Result := strLangEN_GB;
  If Language = langEN_US then
    Result := strLangEN_US;
  If Language = langEN_ZW then
    Result := strLangEN_ZW;
  If Language = langET then
    Result := strLangET;
  If Language = langFO then
    Result := strLangFO;
  If Language = langFI then
    Result := strLangFI;
  If Language = langFR then
    Result := strLangFR;
  If Language = langFR_BE then
    Result := strLangFR_BE;
  If Language = langFR_CA then
    Result := strLangFR_CA;
  If Language = langFR_FR then
    Result := strLangFR_FR;
  If Language = langFR_LU then
    Result := strLangFR_LU;
  If Language = langFR_MC then
    Result := strLangFR_MC;
  If Language = langFR_CH then
    Result := strLangFR_CH;
  If Language = langGL then
    Result := strLangGL;
  If Language = langGD then
    Result := strLangGD;
  If Language = langDE then
    Result := strLangDE;
  If Language = langDE_AT then
    Result := strLangDE_AT;
  If Language = langDE_DE then
    Result := strLangDE_DE;
  If Language = langDE_LI then
    Result := strLangDE_LI;
  If Language = langDE_LU then
    Result := strLangDE_LU;
  If Language = langDE_CH then
    Result := strLangDE_CH;
  If Language = langEL then
    Result := strLangEL;
  If Language = langHAW then
    Result := strLangHAW;
  If Language = langHU then
    Result := strLangHU;
  If Language = langIS then
    Result := strLangIS;
  If Language = langIN then
    Result := strLangIN;
  If Language = langGA then
    Result := strLangGA;
  If Language = langIT then
    Result := strLangIT;
  If Language = langIT_IT then
    Result := strLangIT_IT;
  If Language = langIT_CH then
    Result := strLangIT_CH;
  If Language = langJA then
    Result := strLangJA;
  If Language = langKO then
    Result := strLangKO;
  If Language = langMK then
    Result := strLangMK;
  If Language = langNO then
    Result := strLangNO;
  If Language = langPL then
    Result := strLangPL;
  If Language = langPT then
    Result := strLangPT;
  If Language = langPT_BR then
    Result := strLangPT_BR;
  If Language = langPT_PT then
    Result := strLangPT_PT;
  If Language = langRO then
    Result := strLangRO;
  If Language = langRO_MO then
    Result := strLangRO_MO;
  If Language = langRO_RP then
    Result := strLangRO_RP;
  If Language = langRU then
    Result := strLangRU;
  If Language = langRU_MO then
    Result := strLangRU_MO;
  If Language = langRU_RU then
    Result := strLangRU_RU;
  If Language = langSR then
    Result := strLangSR;
  If Language = langSK then
    Result := strLangSK;
  If Language = langSL then
    Result := strLangSL;
  If Language = langES then
    Result := strLangES;
  If Language = langES_AR then
    Result := strLangES_AR;
  If Language = langES_BO then
    Result := strLangES_BO;
  If Language = langES_CL then
    Result := strLangES_CL;
  If Language = langES_CO then
    Result := strLangES_CO;
  If Language = langES_CR then
    Result := strLangES_CR;
  If Language = langES_DO then
    Result := strLangES_DO;
  If Language = langES_EC then
    Result := strLangES_EC;
  If Language = langES_SV then
    Result := strLangES_SV;
  If Language = langES_GT then
    Result := strLangES_GT;
  If Language = langES_HN then
    Result := strLangES_HN;
  If Language = langES_MX then
    Result := strLangES_MX;
  If Language = langES_NI then
    Result := strLangES_NI;
  If Language = langES_PA then
    Result := strLangES_PA;
  If Language = langES_PY then
    Result := strLangES_PY;
  If Language = langES_PE then
    Result := strLangES_PE;
  If Language = langES_PR then
    Result := strLangES_PR;
  If Language = langES_ES then
    Result := strLangES_ES;
  If Language = langES_UY then
    Result := strLangES_UY;
  If Language = langES_VE then
    Result := strLangES_VE;
  If Language = langSV then
    Result := strLangSV;
  If Language = langSV_FI then
    Result := strLangSV_FI;
  If Language = langSV_SE then
    Result := strLangSV_SE;
  If Language = langTR then
    Result := strLangTR;
  If Language = langUK then
    Result := strLangUK;
end; // if then

function DecodeString(Encoding: TEncodingType; Data: string): string;
var
  aBase64Decoder: TIdDecoderMIME;
begin
  Result := Data;
  case Encoding of
    etBase64: begin
        aBase64Decoder := TIdDecoderMIME.Create(nil);
        try
          Result := aBase64Decoder.DecodeString(Result);
        finally
          FreeAndNil(aBase64Decoder);
        end;
      end;
  end;
end;

procedure GetSkipHours(RootNode: IXMLNode; var aSimpleRSS: TSimpleRSS);
var
  Counter: Integer;
begin
  for Counter := 0 to RootNode.ChildNodes.Count - 1 do begin
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum1 then
      aSimpleRSS.Channel.Optional.SkipHours.h01 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum2 then
      aSimpleRSS.Channel.Optional.SkipHours.h02 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum3 then
      aSimpleRSS.Channel.Optional.SkipHours.h03 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum4 then
      aSimpleRSS.Channel.Optional.SkipHours.h04 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum5 then
      aSimpleRSS.Channel.Optional.SkipHours.h05 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum6 then
      aSimpleRSS.Channel.Optional.SkipHours.h06 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum7 then
      aSimpleRSS.Channel.Optional.SkipHours.h07 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum8 then
      aSimpleRSS.Channel.Optional.SkipHours.h08 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum9 then
      aSimpleRSS.Channel.Optional.SkipHours.h09 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum10 then
      aSimpleRSS.Channel.Optional.SkipHours.h10 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum11 then
      aSimpleRSS.Channel.Optional.SkipHours.h11 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum12 then
      aSimpleRSS.Channel.Optional.SkipHours.h12 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum13 then
      aSimpleRSS.Channel.Optional.SkipHours.h13 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum14 then
      aSimpleRSS.Channel.Optional.SkipHours.h14 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum15 then
      aSimpleRSS.Channel.Optional.SkipHours.h15 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum16 then
      aSimpleRSS.Channel.Optional.SkipHours.h16 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum17 then
      aSimpleRSS.Channel.Optional.SkipHours.h17 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum18 then
      aSimpleRSS.Channel.Optional.SkipHours.h18 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum19 then
      aSimpleRSS.Channel.Optional.SkipHours.h19 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum20 then
      aSimpleRSS.Channel.Optional.SkipHours.h20 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum21 then
      aSimpleRSS.Channel.Optional.SkipHours.h21 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum22 then
      aSimpleRSS.Channel.Optional.SkipHours.h22 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum23 then
      aSimpleRSS.Channel.Optional.SkipHours.h23 := True;
    if
      RootNode.ChildNodes.Nodes[Counter].NodeValue = strNum0 then
      aSimpleRSS.Channel.Optional.SkipHours.h00 := True;
  end;
end;

procedure GetSkipDays(RootNode: IXMLNode; var aSimpleRSS: TSimpleRSS);
var
  Counter: Integer;
begin
  for Counter := 0 to RootNode.ChildNodes.Count - 1 do begin
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullMonday then
      aSimpleRSS.Channel.Optional.SkipDays.Monday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullTuesday then
      aSimpleRSS.Channel.Optional.SkipDays.Tuesday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue  = strFullWednesday then
      aSimpleRSS.Channel.Optional.SkipDays.Wednesday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullThursday then
      aSimpleRSS.Channel.Optional.SkipDays.Thursday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullFriday then
      aSimpleRSS.Channel.Optional.SkipDays.Friday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullSaturday then
      aSimpleRSS.Channel.Optional.SkipDays.Saturday := True;
    if RootNode.ChildNodes.Nodes[Counter].NodeValue = strFullSunday then
      aSimpleRSS.Channel.Optional.SkipDays.Sunday := True;
  end;
end;

end.

