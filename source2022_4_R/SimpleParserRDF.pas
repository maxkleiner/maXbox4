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

This File Originally Created By Thomas Zangl <thomas@tzis.net> 2005
Additional work by:
 - Robert MacLean <dfantom@gmail.com> 2005

Spec
http://www.w3.org/TR/1999/REC-rdf-syntax-19990222/
http://web.resource.org/rss/1.0/spec
--------------------------------------------------------------------------------
}
unit SimpleParserRDF;

interface

uses Classes, SimpleParserBase, Variants;

type
    TSimpleParserRDF = class(TSimpleParserBase)
    private
    protected
    public
      Procedure Generate; override;
      procedure Parse; override;
    published
    end; { TSimpleParserRDF }

implementation

uses  SimpleRSSTypes,
      SimpleRSSConst, SimpleRSSUtils, XMLIntf, XMLDoc, SysUtils, SimpleRSS;

procedure TSimpleParserRDF.Generate;
var
  Counter : Integer;
  XNode, Item, Channel, TOC, Image, TextInput: IXMLNode;
begin
  //todo: generate RDF - fix the attack of the xmlns issue
  FSimpleRSS.ClearXML;
  // ROOT
  XNode := FSimpleRSS.XMLFile.CreateNode(strXMLHeader, ntProcessingInstr, strXMLVersion);
  FSimpleRSS.XMLFile.ChildNodes.Add(XNode);
  XNode := FSimpleRSS.XMLFile.CreateElement(rdfeRDF,rdfeRDFNSUrl);
  XNode.DeclareNamespace('',rdfeXMLNSUrl);
  FSimpleRSS.XMLFile.ChildNodes.Add(XNode);
  XNode := FSimpleRSS.XMLFile.CreateNode(Format(strAdvert,[FormatDateTime(strDateFormat,Now)]), ntComment);
  FSimpleRSS.XMLFile.ChildNodes.Nodes[rdfeRDF].ChildNodes.Add(XNode);
  // END ROOT

  // CHANNEL
  Channel := FSimpleRSS.XMLFile.CreateNode(reChannel);
  Channel.Attributes[rdfeAbout] := FSimpleRSS.Channel.AboutURL;
  // REQUIRED
  Channel.ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Channel.Required.Title;
  Channel.ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Channel.Required.Link;
  Channel.ChildNodes.Nodes[reDescription].NodeValue := FSimpleRSS.Channel.Required.Desc;
  // END REQUIRED
  // OPTIONAL

  if FSimpleRSS.Channel.Optional.Image.Include then
    begin
      XNode := FSimpleRSS.XMLFile.CreateNode(reImage);
      XNode.Attributes[rdfeResource] := FSimpleRSS.Channel.Optional.Image.Required.URL;
      Channel.ChildNodes.Add(XNode);

      Image := Channel.AddChild(reImage);
//      Image := FSimpleRSS.XMLFile.CreateNode(reImage);
      // IMAGE REQUIRED
      Image.Attributes[rdfeAbout] := FSimpleRSS.Channel.Optional.Image.Required.URL;
      Image.ChildNodes.Nodes[reURL].NodeValue := FSimpleRSS.Channel.Optional.Image.Required.URL;
      Image.ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Channel.Optional.Image.Required.Title;
      Image.ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Channel.Optional.Image.Required.Link;
      // END IMAGE REQUIRED
    end; // if then IMAGE

  // TOC
  TOC := FSimpleRSS.XMLFile.CreateNode(rdfeItems);
  XNode := FSimpleRSS.XMLFile.CreateNode(rdfeSeq);
  For Counter := 0 to FSimpleRSS.Items.Count-1 do
    begin
      If FSimpleRSS.Items.Items[Counter].TitleChanged or FSimpleRSS.Items.Items[Counter].DescriptionChanged then
        Begin
          Item := FSimpleRSS.XMLFile.CreateNode(rdfeLi);
          Item.Attributes[rdfeResource] := FSimpleRSS.Items.Items[Counter].Link;
          XNode.ChildNodes.Add(Item);
        end; // if then
    end; // for 2 do
  TOC.ChildNodes.Add(XNode);
  Channel.ChildNodes.Add(TOC);
  // END TOC

  //TEXTINPUT
  If FSimpleRSS.Channel.Optional.TextInput.Include then
    begin
      XNode := FSimpleRSS.XMLFile.CreateNode(reTextInput);
      XNode.Attributes[rdfeResource] := FSimpleRSS.Channel.Optional.TextInput.Link;
      Channel.ChildNodes.Add(XNode);

      TextInput := FSimpleRSS.XMLFile.CreateNode(reTextInput);
      TextInput.Attributes[rdfeAbout] := FSimpleRSS.Channel.Optional.TextInput.Link;
      TextInput.ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Channel.Optional.TextInput.Title;
      TextInput.ChildNodes.Nodes[reDescription].NodeValue := FSimpleRSS.Channel.Optional.TextInput.Description;
      TextInput.ChildNodes.Nodes[reName].NodeValue := FSimpleRSS.Channel.Optional.TextInput.TextInputName;
      TextInput.ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Channel.Optional.TextInput.Link;
    end; // if then
  // END TEXTINPUT
  // END OPTIONAL
  FSimpleRSS.XMLFile.ChildNodes[rdfeRDF].ChildNodes.Add(Channel);

  If Image <> nil then
    FSimpleRSS.XMLFile.ChildNodes[rdfeRDF].ChildNodes.Add(Image);
  // END CHANNEL
  // ITEMS
  For Counter := 0 to FSimpleRSS.Items.Count-1 do
    begin
      If FSimpleRSS.Items.Items[Counter].TitleChanged or FSimpleRSS.Items.Items[Counter].DescriptionChanged then
        Begin
          Item := FSimpleRSS.XMLFile.CreateNode(reItem);
          Item.Attributes[rdfeAbout] := FSimpleRSS.Items.Items[Counter].Link;
          Item.ChildNodes.Nodes[reTitle].NodeValue := FSimpleRSS.Items.Items[Counter].Title;
          Item.ChildNodes.Nodes[reLink].NodeValue := FSimpleRSS.Items.Items[Counter].Link;
          Item.ChildNodes.Nodes[reDescription].NodeValue := FSimpleRSS.Items.Items[Counter].Description;
          FSimpleRSS.XMLFile.ChildNodes[rdfeRDF].ChildNodes.Add(Item);
        end; // if then
    end; // for 2 do
  // END ITEMS

  If TextInput <> nil then
    FSimpleRSS.XMLFile.ChildNodes[rdfeRDF].ChildNodes.Add(TextInput);
end;

procedure TSimpleParserRDF.Parse;
var
  Counter, SecondCounter: Integer;
begin
  with FSimpleRSS.XMLFile.DocumentElement do begin
      for Counter := 0 to ChildNodes.Count - 1 do begin
        // begin channel
        if ChildNodes.Nodes[Counter].NodeName = reChannel then begin
          for SecondCounter := 0 to ChildNodes.Nodes[Counter].ChildNodes.Count - 1 do begin
            if ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeName = reTitle then
              FSimpleRSS.Channel.Required.Title := ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeName = reLink then
              FSimpleRSS.Channel.Required.Link := ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeName = reDescription then
              FSimpleRSS.Channel.Required.Desc := ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].NodeValue;
          end; // for
        end; // end channel

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
              and (ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) =
              nil) then begin
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil then
                raise ESimpleRSSException.Create(emRequiredFieldMissing + reItem
                  + strArrow + reTitle);
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) =
                nil then
                raise ESimpleRSSException.Create(emRequiredFieldMissing + reItem
                  + strArrow + reDescription);
            end; // if then
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) <> nil then
              Title :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink) <> nil then
              Link :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription) <>
              nil then
              Description :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reDescription).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor) <> nil then
              Author.Name :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments) <> nil then
              Comments :=
                ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments).NodeValue;
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(rdfeDate) <> nil then
              PubDate.LoadDCDateTime(ChildNodes.Nodes[Counter].ChildNodes.FindNode(rdfeDate).NodeValue);
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure) <> nil then begin
              if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reURL) = nil then
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
                GUID.IsPermaLink := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reGUID).AttributeNodes.Nodes[reIsPermaLink].NodeValue = strTrue;
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
                  if
                    ChildNodes.Nodes[Counter].ChildNodes.Nodes[SecondCounter].AttributeNodes.FindNode(reDomain) <> nil then
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
          FSimpleRSS.Channel.Optional.ManagingEditor := ChildNodes.Nodes[Counter].NodeValue;
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
          FSimpleRSS.Channel.Optional.Cloud.Include := ChildNodes.Nodes[Counter].AttributeNodes.Count > 0;
          if FSimpleRSS.Channel.Optional.Cloud.Include then begin
            FSimpleRSS.Channel.Optional.Cloud.Domain := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reDomain].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Port := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[rePort].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Path := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[rePath].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.RegisterProcedure := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reRegisterProcedure].NodeValue;
            FSimpleRSS.Channel.Optional.Cloud.Protocol := ChildNodes.Nodes[Counter].AttributeNodes.Nodes[reProtocol].NodeValue;
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
  end; // with do
end;

end.
