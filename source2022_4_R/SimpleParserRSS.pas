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

Specification:
http://feedvalidator.org/docs/rss2.html
http://web.resource.org/rss/1.0/modules/content/
--------------------------------------------------------------------------------
}

unit SimpleParserRSS;

interface

uses Classes, SimpleParserBase, Variants;

type
    TSimpleParserRSS = class(TSimpleParserBase)
    private
    protected
    public
        procedure Parse; override;
        Procedure Generate; override;
    published
    end; { TSimpleParserRSS }


implementation

uses
  XMLIntf, SimpleRSSTypes, SimpleRSSConst, SimpleRSSUtils, SysUtils;

procedure TSimpleParserRSS.Generate;
var
  Counter, SubCounter: Integer;
  XNode, Item, Channel: IXMLNode;
begin
  FSimpleRSS.ClearXML;
  // ROOT
  with FSimpleRSS.XMLFile do begin
    XNode := FSimpleRSS.XMLFile.CreateNode(strXMLHeader, ntProcessingInstr, strXMLVersion);
    FSimpleRSS.XMLFile.ChildNodes.Add(XNode);
    AddChild(reRSS);
    ChildNodes.Nodes[reRSS].Attributes[reVersion] := FSimpleRSS.Version;
    XNode := FSimpleRSS.XMLFile.CreateNode(Format(strAdvert,[FormatDateTime(strDateFormat,Now)]), ntComment);
    ChildNodes.Nodes[reRSS].ChildNodes.Add(XNode);
    XNode := CreateNode(strRSSLicenceAdvert, ntComment);
    ChildNodes.Nodes[reRSS].ChildNodes.Add(XNode);
    XNode := CreateNode(strRSSLicenceURL, ntComment);
    ChildNodes.Nodes[reRSS].ChildNodes.Add(XNode);
  end; // with do
  // END ROOT
  // CHANNEL
  Channel := FSimpleRSS.XMLFile.CreateNode(reChannel);
  // REQUIRED
  Channel.ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Channel.Required.Title;
  Channel.ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Channel.Required.Link;
  Channel.ChildNodes.Nodes[reDescription].NodeValue := FSimpleRSS.Channel.Required.Desc;
  // END REQUIRED
  // OPTIONAL
  // LANGUAGE
  // even though it is optional simplerss always inserts it
  if FSimpleRSS.Channel.Optional.Language = langX then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := FSimpleRSS.Channel.Optional.XLang;
  if FSimpleRSS.Channel.Optional.Language = langAF then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangAF;
  if FSimpleRSS.Channel.Optional.Language = langSQ then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSQ;
  if FSimpleRSS.Channel.Optional.Language = langSQ then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEU;
  if FSimpleRSS.Channel.Optional.Language = langBE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangBE;
  if FSimpleRSS.Channel.Optional.Language = langBG then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangBG;
  if FSimpleRSS.Channel.Optional.Language = langCA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangCA;
  if FSimpleRSS.Channel.Optional.Language = langZH_CN then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangZH_CN;
  if FSimpleRSS.Channel.Optional.Language = langZH_CN then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangZH_TW;
  if FSimpleRSS.Channel.Optional.Language = langHR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangHR;
  if FSimpleRSS.Channel.Optional.Language = langCS then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangCS;
  if FSimpleRSS.Channel.Optional.Language = langDA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDA;
  if FSimpleRSS.Channel.Optional.Language = langNL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangNL;
  if FSimpleRSS.Channel.Optional.Language = langNL_BE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangNL_BE;
  if FSimpleRSS.Channel.Optional.Language = langNL_NL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangNL_NL;
  if FSimpleRSS.Channel.Optional.Language = langEN then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN;
  if FSimpleRSS.Channel.Optional.Language = langEN_AU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_AU;
  if FSimpleRSS.Channel.Optional.Language = langEN_BZ then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_BZ;
  if FSimpleRSS.Channel.Optional.Language = langEN_CA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_CA;
  if FSimpleRSS.Channel.Optional.Language = langEN_IE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_IE;
  if FSimpleRSS.Channel.Optional.Language = langEN_JM then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_JM;
  if FSimpleRSS.Channel.Optional.Language = langEN_NZ then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_NZ;
  if FSimpleRSS.Channel.Optional.Language = langEN_PH then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_PH;
  if FSimpleRSS.Channel.Optional.Language = langEN_ZA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_ZA;
  if FSimpleRSS.Channel.Optional.Language = langEN_TT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_TT;
  if FSimpleRSS.Channel.Optional.Language = langEN_GB then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_GB;
  if FSimpleRSS.Channel.Optional.Language = langEN_US then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_US;
  if FSimpleRSS.Channel.Optional.Language = langEN_ZW then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEN_ZW;
  if FSimpleRSS.Channel.Optional.Language = langET then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangET;
  if FSimpleRSS.Channel.Optional.Language = langFO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFO;
  if FSimpleRSS.Channel.Optional.Language = langFI then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFI;
  if FSimpleRSS.Channel.Optional.Language = langFR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR;
  if FSimpleRSS.Channel.Optional.Language = langFR_BE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_BE;
  if FSimpleRSS.Channel.Optional.Language = langFR_CA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_CA;
  if FSimpleRSS.Channel.Optional.Language = langFR_FR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_FR;
  if FSimpleRSS.Channel.Optional.Language = langFR_LU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_LU;
  if FSimpleRSS.Channel.Optional.Language = langFR_MC then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_MC;
  if FSimpleRSS.Channel.Optional.Language = langFR_CH then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangFR_CH;
  if FSimpleRSS.Channel.Optional.Language = langGL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangGL;
  if FSimpleRSS.Channel.Optional.Language = langGD then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangGD;
  if FSimpleRSS.Channel.Optional.Language = langDE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE;
  if FSimpleRSS.Channel.Optional.Language = langDE_AT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE_AT;
  if FSimpleRSS.Channel.Optional.Language = langDE_DE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE_DE;
  if FSimpleRSS.Channel.Optional.Language = langDE_LI then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE_LI;
  if FSimpleRSS.Channel.Optional.Language = langDE_LU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE_LU;
  if FSimpleRSS.Channel.Optional.Language = langDE_CH then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangDE_CH;
  if FSimpleRSS.Channel.Optional.Language = langEL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangEL;
  if FSimpleRSS.Channel.Optional.Language = langHAW then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangHAW;
  if FSimpleRSS.Channel.Optional.Language = langHU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangHU;
  if FSimpleRSS.Channel.Optional.Language = langIS then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangIS;
  if FSimpleRSS.Channel.Optional.Language = langIN then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangIN;
  if FSimpleRSS.Channel.Optional.Language = langGA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangGA;
  if FSimpleRSS.Channel.Optional.Language = langIT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangIT;
  if FSimpleRSS.Channel.Optional.Language = langIT_IT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangIT_IT;
  if FSimpleRSS.Channel.Optional.Language = langIT_CH then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangIT_CH;
  if FSimpleRSS.Channel.Optional.Language = langJA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangJA;
  if FSimpleRSS.Channel.Optional.Language = langKO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangKO;
  if FSimpleRSS.Channel.Optional.Language = langMK then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangMK;
  if FSimpleRSS.Channel.Optional.Language = langNO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangNO;
  if FSimpleRSS.Channel.Optional.Language = langPL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangPL;
  if FSimpleRSS.Channel.Optional.Language = langPT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangPT;
  if FSimpleRSS.Channel.Optional.Language = langPT_BR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangPT_BR;
  if FSimpleRSS.Channel.Optional.Language = langPT_PT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangPT_PT;
  if FSimpleRSS.Channel.Optional.Language = langRO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRO;
  if FSimpleRSS.Channel.Optional.Language = langRO_MO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRO_MO;
  if FSimpleRSS.Channel.Optional.Language = langRO_RP then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRO_RP;
  if FSimpleRSS.Channel.Optional.Language = langRU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRU;
  if FSimpleRSS.Channel.Optional.Language = langRU_MO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRU_MO;
  if FSimpleRSS.Channel.Optional.Language = langRU_RU then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangRU_RU;
  if FSimpleRSS.Channel.Optional.Language = langSR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSR;
  if FSimpleRSS.Channel.Optional.Language = langSK then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSK;
  if FSimpleRSS.Channel.Optional.Language = langSL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSL;
  if FSimpleRSS.Channel.Optional.Language = langES then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES;
  if FSimpleRSS.Channel.Optional.Language = langES_AR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_AR;
  if FSimpleRSS.Channel.Optional.Language = langES_BO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_BO;
  if FSimpleRSS.Channel.Optional.Language = langES_CL then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_CL;
  if FSimpleRSS.Channel.Optional.Language = langES_CO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_CO;
  if FSimpleRSS.Channel.Optional.Language = langES_CR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_CR;
  if FSimpleRSS.Channel.Optional.Language = langES_DO then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_DO;
  if FSimpleRSS.Channel.Optional.Language = langES_EC then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_EC;
  if FSimpleRSS.Channel.Optional.Language = langES_SV then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_SV;
  if FSimpleRSS.Channel.Optional.Language = langES_GT then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_GT;
  if FSimpleRSS.Channel.Optional.Language = langES_HN then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_HN;
  if FSimpleRSS.Channel.Optional.Language = langES_MX then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_MX;
  if FSimpleRSS.Channel.Optional.Language = langES_NI then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_NI;
  if FSimpleRSS.Channel.Optional.Language = langES_PA then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_PA;
  if FSimpleRSS.Channel.Optional.Language = langES_PY then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_PY;
  if FSimpleRSS.Channel.Optional.Language = langES_PE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_PE;
  if FSimpleRSS.Channel.Optional.Language = langES_PR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_PR;
  if FSimpleRSS.Channel.Optional.Language = langES_ES then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_ES;
  if FSimpleRSS.Channel.Optional.Language = langES_UY then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_UY;
  if FSimpleRSS.Channel.Optional.Language = langES_VE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangES_VE;
  if FSimpleRSS.Channel.Optional.Language = langSV then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSV;
  if FSimpleRSS.Channel.Optional.Language = langSV_FI then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSV_FI;
  if FSimpleRSS.Channel.Optional.Language = langSV_SE then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangSV_SE;
  if FSimpleRSS.Channel.Optional.Language = langTR then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangTR;
  if FSimpleRSS.Channel.Optional.Language = langUK then
    Channel.ChildNodes.Nodes[reLanguage].NodeValue := strLangUK;
  // LANGUAGE

  if FSimpleRSS.Channel.Optional.CopyrightChanged then
    Channel.ChildNodes.Nodes[reCopyright].NodeValue :=
      FSimpleRSS.Channel.Optional.Copyright;
  if FSimpleRSS.Channel.Optional.ManagingEditorChanged then
    Channel.ChildNodes.Nodes[reManagingEditor].NodeValue :=
      FSimpleRSS.Channel.Optional.ManagingEditor;
  if FSimpleRSS.Channel.Optional.WebMasterChanged then
    Channel.ChildNodes.Nodes[reWebMaster].NodeValue :=
      FSimpleRSS.Channel.Optional.WebMaster;
  if FSimpleRSS.Channel.Optional.PubDate.Changed then
    Channel.ChildNodes.Nodes[rePubDate].NodeValue :=
      FSimpleRSS.Channel.Optional.PubDate.GetDateTime;
  if FSimpleRSS.Channel.Optional.LastBuildDate.Changed then
    Channel.ChildNodes.Nodes[reLastBuildDate].NodeValue :=
      FSimpleRSS.Channel.Optional.LastBuildDate.GetDateTime;
  if FSimpleRSS.Channel.Optional.Categories.Count > 0 then begin
    for Counter := 0 to FSimpleRSS.Channel.Optional.Categories.Count - 1 do begin
      XNode := FSimpleRSS.XMLFile.CreateNode(reCategory);
      XNode.NodeValue := FSimpleRSS.Channel.Optional.Categories.Items[Counter].Category;
      if FSimpleRSS.Channel.Optional.Categories.Items[Counter].DomainChanged then
        XNode.AttributeNodes.Nodes[reDomain].NodeValue :=
          FSimpleRSS.Channel.Optional.Categories.Items[Counter].Domain;
      Channel.ChildNodes.Add(XNode);
    end; // for 2 do
  end; // if then // category
  // even though docs is optional, simplerss always adds it
  Channel.ChildNodes.Nodes[reDocs].NodeValue := FSimpleRSS.Channel.Optional.Docs;
  if FSimpleRSS.Channel.Optional.Cloud.Include then begin
    with Channel.ChildNodes.Nodes[reCloud] do begin
      AttributeNodes.Nodes[reDomain].NodeValue :=
        FSimpleRSS.Channel.Optional.Cloud.Domain;
      AttributeNodes.Nodes[rePort].NodeValue := FSimpleRSS.Channel.Optional.Cloud.Port;
      AttributeNodes.Nodes[rePath].NodeValue := FSimpleRSS.Channel.Optional.Cloud.Path;
      AttributeNodes.Nodes[reRegisterProcedure].NodeValue :=
        FSimpleRSS.Channel.Optional.Cloud.RegisterProcedure;
      AttributeNodes.Nodes[reProtocol].NodeValue :=
        FSimpleRSS.Channel.Optional.Cloud.Protocol;
    end; // with do
  end; // if then CLOUD
  if FSimpleRSS.Channel.Optional.TTLChanged then
    Channel.ChildNodes.Nodes[reTTL].NodeValue := FSimpleRSS.Channel.Optional.TTL;
  if FSimpleRSS.Channel.Optional.Image.Include then begin
    XNode := FSimpleRSS.XMLFile.CreateNode(reImage);
    // IMAGE REQUIRED
    XNode.ChildNodes.Nodes[reURL].NodeValue :=
      FSimpleRSS.Channel.Optional.Image.Required.URL;
    XNode.ChildNodes.Nodes[reTitle].NodeValue :=
      FSimpleRSS.Channel.Optional.Image.Required.Title;
    XNode.ChildNodes.Nodes[reLink].NodeValue :=
      FSimpleRSS.Channel.Optional.Image.Required.Link;
    // END IMAGE REQUIRED
    // IMAGE OPTIONAL
    if FSimpleRSS.Channel.Optional.Image.Optional.DescriptionChanged then
      XNode.ChildNodes.Nodes[reDescription].NodeValue :=
        FSimpleRSS.Channel.Optional.Image.Optional.Description;
    if FSimpleRSS.Channel.Optional.Image.Optional.HeightChanged then
      XNode.ChildNodes.Nodes[reHeight].NodeValue :=
        FSimpleRSS.Channel.Optional.Image.Optional.Height;
    if FSimpleRSS.Channel.Optional.Image.Optional.WidthChanged then
      XNode.ChildNodes.Nodes[reWidth].NodeValue :=
        FSimpleRSS.Channel.Optional.Image.Optional.Width;
    // END IMAGE OPTIONAL
    Channel.ChildNodes.Add(XNode);
  end; // if then IMAGE
  if (FSimpleRSS.Channel.Optional.SkipHours.h01) or
    (FSimpleRSS.Channel.Optional.SkipHours.h02) or
    (FSimpleRSS.Channel.Optional.SkipHours.h03) or
    (FSimpleRSS.Channel.Optional.SkipHours.h04) or
    (FSimpleRSS.Channel.Optional.SkipHours.h05) or
    (FSimpleRSS.Channel.Optional.SkipHours.h06) or
    (FSimpleRSS.Channel.Optional.SkipHours.h07) or
    (FSimpleRSS.Channel.Optional.SkipHours.h08) or
    (FSimpleRSS.Channel.Optional.SkipHours.h09) or
    (FSimpleRSS.Channel.Optional.SkipHours.h10) or
    (FSimpleRSS.Channel.Optional.SkipHours.h11) or
    (FSimpleRSS.Channel.Optional.SkipHours.h12) or
    (FSimpleRSS.Channel.Optional.SkipHours.h13) or
    (FSimpleRSS.Channel.Optional.SkipHours.h14) or
    (FSimpleRSS.Channel.Optional.SkipHours.h15) or
    (FSimpleRSS.Channel.Optional.SkipHours.h16) or
    (FSimpleRSS.Channel.Optional.SkipHours.h17) or
    (FSimpleRSS.Channel.Optional.SkipHours.h18) or
    (FSimpleRSS.Channel.Optional.SkipHours.h19) or
    (FSimpleRSS.Channel.Optional.SkipHours.h20) or
    (FSimpleRSS.Channel.Optional.SkipHours.h21) or
    (FSimpleRSS.Channel.Optional.SkipHours.h22) or
    (FSimpleRSS.Channel.Optional.SkipHours.h23) or
    (FSimpleRSS.Channel.Optional.SkipHours.h00) then begin
    with Channel.ChildNodes.Nodes[reSkipHours] do begin
      if FSimpleRSS.Channel.Optional.SkipHours.h01 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 1;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h02 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 2;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h03 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 3;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h04 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 4;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h05 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 5;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h06 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 6;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h07 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 7;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h08 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 8;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h09 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 9;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h10 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 10;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h11 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 11;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h12 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 12;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h13 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 13;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h14 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 14;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h15 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 15;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h16 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 16;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h17 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 17;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h18 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 18;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h19 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 19;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h20 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 20;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h21 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 21;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h22 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 22;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h23 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 23;
        ChildNodes.Add(XNode);
      end;
      if FSimpleRSS.Channel.Optional.SkipHours.h00 then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reHour);
        XNode.NodeValue := 0;
        ChildNodes.Add(XNode);
      end;
    end; // with do
  end; // if then
  if (FSimpleRSS.Channel.Optional.SkipDays.Monday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Tuesday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Wednesday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Thursday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Friday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Saturday) or
    (FSimpleRSS.Channel.Optional.SkipDays.Sunday) then begin
    with Channel.ChildNodes.Nodes[reSkipDays] do begin
      if FSimpleRSS.Channel.Optional.SkipDays.Monday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullMonday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Tuesday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullTuesday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Wednesday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullWednesday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Thursday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullThursday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Friday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullFriday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Saturday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullSaturday;
        ChildNodes.Add(XNode);
      end; // if them
      if FSimpleRSS.Channel.Optional.SkipDays.Sunday then begin
        XNode := FSimpleRSS.XMLFile.CreateNode(reDay);
        XNode.NodeValue := strFullSunday;
        ChildNodes.Add(XNode);
      end; // if them
    end; // with
  end; // if then
  if FSimpleRSS.Channel.Optional.TextInput.Include then begin
    with Channel.ChildNodes.Nodes[reTextInput] do begin
      ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Channel.Optional.TextInput.Title;
      ChildNodes.Nodes[reDescription].NodeValue :=
        FSimpleRSS.Channel.Optional.TextInput.Description;
      ChildNodes.Nodes[reName].NodeValue :=
        FSimpleRSS.Channel.Optional.TextInput.TextInputName;
      ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Channel.Optional.TextInput.Link;
    end; // with do
  end; // if then
  if FSimpleRSS.Channel.Optional.GeneratorChanged then
    Channel.ChildNodes.Nodes[reGenerator].NodeValue :=
      FSimpleRSS.Channel.Optional.Generator;
  if FSimpleRSS.Channel.Optional.RatingChanged then
    Channel.ChildNodes.Nodes[reRating].NodeValue := FSimpleRSS.Channel.Optional.Rating;
  FSimpleRSS.XMLFile.ChildNodes.Nodes[reRSS].ChildNodes.Add(Channel);
  // END OPTIONAL
  // END CHANNEL
  // ITEMS
  for Counter := 0 to FSimpleRSS.Items.Count - 1 do
    begin
      if FSimpleRSS.Items.Items[Counter].TitleChanged or FSimpleRSS.Items.Items[Counter].DescriptionChanged then
        begin
          Item := FSimpleRSS.XMLFile.CreateNode(reItem);
      with Item do begin
        if FSimpleRSS.Items.Items[Counter].TitleChanged then
          ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Items.Items[Counter].Title;
        if FSimpleRSS.Items.Items[Counter].LinkChanged then
          ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Items.Items[Counter].Link;
        if FSimpleRSS.Items.Items[Counter].DescriptionChanged then
          ChildNodes.Nodes[reDescription].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Description;
        if FSimpleRSS.Items.Items[Counter].AuthorChanged then
          ChildNodes.Nodes[reAuthor].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Author.Name;
        if FSimpleRSS.Items.Items[Counter].Categories.Count > 0 then begin
          for SubCounter := 0 to FSimpleRSS.Items.Items[Counter].Categories.Count - 1 do begin
            XNode := FSimpleRSS.XMLFile.CreateNode(reCategory);
            XNode.NodeValue :=
              FSimpleRSS.Items.Items[Counter].Categories.Items[SubCounter].Title;
            if FSimpleRSS.Items.Items[Counter].Categories.Items[SubCounter].DomainChanged then
              XNode.AttributeNodes.Nodes[reDomain].NodeValue :=
                FSimpleRSS.Items.Items[Counter].Categories.Items[SubCounter].Domain;
            ChildNodes.Add(XNode);
          end; // forn 2 do
        end; // if categories
        if FSimpleRSS.Items.Items[Counter].CommentsChanged then
          ChildNodes.Nodes[reComments].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Comments;
        if FSimpleRSS.Items.Items[Counter].Enclosure.Include then begin
          XNode := FSimpleRSS.XMLFile.CreateNode(reEnclosure);
          XNode.AttributeNodes.Nodes[reURL].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Enclosure.URL;
          XNode.AttributeNodes.Nodes[reLength].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Enclosure.Length;
          XNode.AttributeNodes.Nodes[reType].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Enclosure.EnclosureType;
          ChildNodes.Add(XNode);
        end; // if enclosure
        if FSimpleRSS.Items.Items[Counter].GUID.Include then begin
          XNode := FSimpleRSS.XMLFile.CreateNode(reGUID);
          XNode.NodeValue := FSimpleRSS.Items.Items[Counter].GUID.GUID;
          if FSimpleRSS.Items.Items[Counter].GUID.IsPermaLink then
            XNode.AttributeNodes.Nodes[reIsPermaLink].NodeValue := strTrue
          else
            XNode.AttributeNodes.Nodes[reIsPermaLink].NodeValue := strFalse;
          ChildNodes.Add(XNode);
        end; // if guid
        if FSimpleRSS.Items.Items[Counter].PubDate.Changed then
          ChildNodes.Nodes[rePubDate].NodeValue :=
            FSimpleRSS.Items.Items[Counter].PubDate.GetDateTime;
        if FSimpleRSS.Items.Items[Counter].Source.Include then begin
          XNode := FSimpleRSS.XMLFile.CreateNode(reSource);
          XNode.NodeValue := FSimpleRSS.Items.Items[Counter].Source.Title;
          XNode.AttributeNodes.Nodes[reURL].NodeValue :=
            FSimpleRSS.Items.Items[Counter].Source.URL;
          ChildNodes.Add(XNode);
        end; // if source
      end; // with do
      Channel.ChildNodes.Add(Item);
    end; // if then
  end; // for 2 do
  // END ITEMS
end;

procedure TSimpleParserRSS.Parse;
var
  Counter, SecondCounter: Integer;
  aTempNode: IXMLNode;
begin
  with FSimpleRSS.XMLFile.DocumentElement.ChildNodes.Nodes[reChannel] do begin
    if ChildNodes.FindNode(reTitle) = nil then begin
      raise ESimpleRSSException.Create(emRequiredFieldMissing + reTitle);
    end; // if then
    if ChildNodes.FindNode(reLink) = nil then begin
      raise ESimpleRSSException.Create(emRequiredFieldMissing + reLink);
    end; // if then
    if ChildNodes.FindNode(reDescription) = nil then begin
      raise ESimpleRSSException.Create(emRequiredFieldMissing + reDescription);
    end; // if then
    if (ChildNodes.FindNode(reItem) <> nil) or (ChildNodes.FindNode(reCategory) <> nil) then begin
      for Counter := 0 to ChildNodes.Count - 1 do begin
        // begin categorie
        if ChildNodes.Nodes[Counter].NodeName = reCategory then begin
          with FSimpleRSS.Channel.Optional.Categories.Add do begin
            Category := ChildNodes.Nodes[Counter].NodeValue;
            if ChildNodes.Nodes[Counter].AttributeNodes.FindNode(reDomain) <> nil then begin
              Domain := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reDomain].NodeValue;
            end; // if then
          end; // with do
        end; // if then
        // end categorie
        //begin item
        if ChildNodes.Nodes[Counter].NodeName = reItem then begin
          with FSimpleRSS.Items.Add do begin
            if (ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil)
              and (ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) = nil) then begin
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil then
                raise ESimpleRSSException.Create(emRequiredFieldMissing + reItem + strArrow + reTitle);
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) = nil then
                raise ESimpleRSSException.Create(emRequiredFieldMissing + reItem + strArrow + reDescription);
            end; // if then
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) <> nil then
              Title := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink) <> nil then
              Link := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).NodeValue;
              
            // I have seen RSS2 with a content tag. can contain HTML
            // the content can be wrapped inside a <![CDATA statement. then its inside a childnode
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent) <> nil then begin
              aTempNode:=ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent);
              if (aTempNode.ChildNodes.Count>0) then begin
                Description := aTempNode.ChildNodes.Nodes[0].NodeValue;
              end else begin
                Description := aTempNode.NodeValue;
              end;
            end;
            // the content can also be encoded (content:encoded)
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContentEncoded) <> nil then begin
              aTempNode:=ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContentEncoded);
              if (aTempNode.ChildNodes.Count>0) then begin
                Description := aTempNode.ChildNodes.Nodes[0].NodeValue;
              end else begin
                Description := aTempNode.NodeValue;
              end;
            end;
            // the description can be wrapped inside a <![CDATA statement. then its inside a childnode
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) <> nil then begin
              aTempNode:=ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription);
              if (aTempNode.ChildNodes.Count>0) then begin
                Description := aTempNode.ChildNodes.Nodes[0].NodeValue;
              end else begin
                Description := aTempNode.NodeValue;
              end;
            end;

            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor) <> nil then
              Author.Name := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments) <> nil then
              Comments := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(rdfeDate) <> nil then
              PubDate.LoadDCDateTime(ChildNodes.Nodes[Counter].ChildNodes.FindNode(rdfeDate).NodeValue);
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure) <> nil then
              begin
                If ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reURL) = nil then
                  raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reURL);
                if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reLength) = nil then
                  raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reLength);
                if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reType) = nil then
                  raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reType);
                Enclosure.URL := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reURL].NodeValue;
                Enclosure.Length := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reLength].NodeValue;
                Enclosure.EnclosureType := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reType].NodeValue;
                Enclosure.Include := True;
            end; // if then
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reGUID) <> nil then begin
              GUID.Include := True;
              GUID.GUID := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reGUID).NodeValue;
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reGUID).AttributeNodes.FindNode(reIsPermaLink) <> nil then
                GUID.IsPermaLink := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reGUID).AttributeNodes.Nodes[reIsPermaLink].NodeValue = strTrue
              else
                GUID.IsPermaLink := True;
            end; // if then
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(rePubDate) <> nil then
              PubDate.LoadDateTime(ChildNodes.Nodes[Counter].ChildNodes.Nodes[rePubDate].NodeValue);
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource) <> nil then begin
              if
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource).AttributeNodes.FindNode(reURL) = nil then
                raise ESimpleRSSException.Create(emRequiredFieldMissing + reSource + strArrow + reURL);
              Source.Include := True;
              Source.Title := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource).NodeValue;
              Source.URL := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource).AttributeNodes.Nodes[reURL].NodeValue;
            end; // if then
            for SecondCounter := 0 to ChildNodes.Nodes[Counter].ChildNodes.Count - 1 do begin
              if
                ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].LocalName = reCategory then begin
                with Categories.Add do begin
                  Title := ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeValue;
                  if ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].AttributeNodes.FindNode(reDomain) <> nil then
                    Domain := ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].AttributeNodes.Nodes[reDomain].NodeValue;
                end; // with do
              end; // if then
            end; // for 2 do
          end; // with do
        end; // if then
        // END ITEM
        if ChildNodes.Nodes[Counter].NodeName = reTitle then
          FSimpleRSS.Channel.Required.Title := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reLink then
          FSimpleRSS.Channel.Required.Link := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reDescription then
          FSimpleRSS.Channel.Required.Desc := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reLanguage then begin
          FSimpleRSS.Channel.Optional.Language := StringToLanguage(ChildNodes.Nodes[Counter].NodeValue);
          if FSimpleRSS.Channel.Optional.Language = langX then
            FSimpleRSS.Channel.Optional.Xlang := ChildNodes.Nodes[Counter].NodeValue
          else
            FSimpleRSS.Channel.Optional.Xlang := '';
        end; // if then
        if ChildNodes.Nodes[Counter].NodeName = reCopyright then
          FSimpleRSS.Channel.Optional.Copyright := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reManagingEditor then
          FSimpleRSS.Channel.Optional.ManagingEditor :=
            ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reWebMaster then
          FSimpleRSS.Channel.Optional.WebMaster := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = rePubDate then
          FSimpleRSS.Channel.Optional.PubDate.LoadDateTime(ChildNodes.Nodes[Counter].NodeValue);
        if ChildNodes.Nodes[Counter].NodeName = reLastBuildDate then
          FSimpleRSS.Channel.Optional.LastBuildDate.LoadDateTime(ChildNodes.Nodes[Counter].NodeValue);
        if ChildNodes.Nodes[Counter].NodeName = reGenerator then
          FSimpleRSS.Channel.Optional.Generator := ChildNodes.Nodes[Counter].NodeValue;
        if ChildNodes.Nodes[Counter].NodeName = reDocs then
          FSimpleRSS.Channel.Optional.Docs := ChildNodes.Nodes[Counter].NodeValue;
        // BEGIN CLOUD
        if ChildNodes.Nodes[Counter].NodeName = reCloud then begin
          FSimpleRSS.Channel.Optional.Cloud.Include :=
            ChildNodes.Nodes[Counter].AttributeNodes.Count > 0;
          if FSimpleRSS.Channel.Optional.Cloud.Include then begin
            FSimpleRSS.Channel.Optional.Cloud.Domain :=
              ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reDomain].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Port :=
              ChildNodes.Nodes[Counter].AttributeNodes.Nodes[rePort].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Path :=
              ChildNodes.Nodes[Counter].AttributeNodes.Nodes[rePath].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.RegisterProcedure :=
              ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reRegisterProcedure].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Protocol :=
              ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reProtocol].NodeValue;
          end; // if then
        end; // if then
        //END CLOUD
        if ChildNodes.Nodes[Counter].NodeName = reTTL then
          FSimpleRSS.Channel.Optional.TTL := ChildNodes.Nodes[Counter].NodeValue;
        //BEGIN IMAGE
        if ChildNodes.Nodes[Counter].NodeName = reImage then begin
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reURL) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reImage +
              strArrow + reURL);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reImage +
              strArrow + reTitle);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reImage +
              strArrow + reLink);
          FSimpleRSS.Channel.Optional.Image.Include :=
            ChildNodes.Nodes[Counter].ChildNodes.Count > 0;
          if FSimpleRSS.Channel.Optional.Image.Include then begin
            FSimpleRSS.Channel.Optional.Image.Required.URL :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reURL).NodeValue;
            FSimpleRSS.Channel.Optional.Image.Required.Title :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle).NodeValue;
            FSimpleRSS.Channel.Optional.Image.Required.Link :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) <>
              nil then
              FSimpleRSS.Channel.Optional.Image.Optional.Description :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reWidth) <> nil then
              FSimpleRSS.Channel.Optional.Image.Optional.Width :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reWidth).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reHeight) <> nil then
              FSimpleRSS.Channel.Optional.Image.Optional.Height :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reHeight).NodeValue;
          end; // if then
        end; // if then
        //END IMAGE
        //BEGIN RATING
        if ChildNodes.Nodes[Counter].NodeName = reRating then
          FSimpleRSS.Channel.Optional.Rating := ChildNodes.Nodes[Counter].NodeValue;
        //END RATING
        //BEGIN TEXTINPUT
        if ChildNodes.Nodes[Counter].NodeName = reTextInput then begin
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reTextInput
              + strArrow + reTitle);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reTextInput
              + strArrow + reDescription);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reName) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reTextInput
              + strArrow + reName);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink) = nil then
            raise ESimpleRSSException.Create(emRequiredFieldMissing + reTextInput
              + strArrow + reLink);
          FSimpleRSS.Channel.Optional.TextInput.Include :=
            ChildNodes.Nodes[Counter].ChildNodes.Count > 0;
          if FSimpleRSS.Channel.Optional.TextInput.Include then begin
            FSimpleRSS.Channel.Optional.TextInput.Title :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle).NodeValue;
            FSimpleRSS.Channel.Optional.TextInput.Description :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription).NodeValue;
            FSimpleRSS.Channel.Optional.TextInput.Link :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).NodeValue;
            FSimpleRSS.Channel.Optional.TextInput.TextInputName :=
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reName).NodeValue;
          end; // if then
        end; // if then
        //END TEXTINPUT
      //BEGIN SKIPHOURS
      if ChildNodes.Nodes[Counter].NodeName = reSkipHours then begin
        GetSkipHours(ChildNodes.Nodes[Counter],FSimpleRSS);
      end; // if then
      //END SKIPHOURS
      //BEGIN SKIPDAYS
      if ChildNodes.Nodes[Counter].NodeName = reSkipDays then begin
        GetSkipDays(ChildNodes.Nodes[Counter],FSimpleRss);
      end; // if then
      //END SKIPDAYS
      end; // for to do
    end; // if then
  end; // with do
end;


end.
