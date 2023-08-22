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
--------------------------------------------------------------------------------
}
unit SimpleParserAtom;

interface

uses Classes, SimpleParserBase;

type
    TSimpleParserAtom = class(TSimpleParserBase)
    private
    protected
    public
      Procedure Generate; override;
      procedure Parse; override;
    published
    end; { TSimpleParserRDF }

implementation

uses  Variants,
      SimpleRSSUtils,
      SimpleRSSConst,
      SimpleRSSTypes,
      IdCoderMIME,
//      Dialogs,
      XMLIntf;


procedure TSimpleParserAtom.Generate;
begin
  FSimpleRSS.ClearXML;
  //todo: generate ATOM
end;

procedure TSimpleParserAtom.Parse;

  procedure ParseChannelHeader(Node: IXMLNode);
  var
    Counter: Integer;
  begin
    // parse feed description & co
    for Counter := 0 to Node.ChildNodes.Count - 1 do begin
      if Node.ChildNodes.Nodes[Counter].NodeName = reTitle then
        FSimpleRSS.Channel.Required.Title := Node.ChildNodes.Nodes[Counter].NodeValue;
      if Node.ChildNodes.Nodes[Counter].NodeName = reLink then
        if not VarIsNull(Node.ChildNodes.Nodes[Counter].Attributes[attHREF]) then
          FSimpleRSS.Channel.Required.Link := Node.ChildNodes.Nodes[Counter].Attributes[attHREF];
      if Node.ChildNodes.Nodes[Counter].NodeName = reTagline then
        FSimpleRSS.Channel.Required.Desc := Node.ChildNodes.Nodes[Counter].NodeValue;
      if Node.ChildNodes.Nodes[Counter].NodeName = reGenerator then
        FSimpleRSS.Channel.Optional.Generator := Node.ChildNodes.Nodes[Counter].NodeValue;
      if Node.ChildNodes.Nodes[Counter].NodeName = reModified then
        FSimpleRSS.Channel.Optional.PubDate.LoadDCDateTime(Node.ChildNodes.Nodes[Counter].NodeValue);
    end;
  end;

var
  Counter, SecondCounter: Integer;
  aFeedRoot: IXMLNode;
  aTempNode: IXMLNode;
begin
  // the header of the feed *should* be inside an head element
  // but I have found atom streams (below version 0.3) which have this
  // information simple below the feed element
  // set the appropriate ROOT element of our feed
  if (FSimpleRSS.XMLFile.DocumentElement.ChildNodes.FindNode(reHead) <> nil) then
    aFeedRoot:=FSimpleRSS.XMLFile.DocumentElement.ChildNodes.FindNode(reHead)
  else
    aFeedRoot:=FSimpleRSS.XMLFile.DocumentElement;

  ParseChannelHeader(aFeedRoot);

  with aFeedRoot do begin
    //check if multiple feeds are possible with atom in a single file?
    for Counter := 0 to ChildNodes.Count - 1 do begin

      //begin entry
      if ChildNodes.Nodes[Counter].NodeName = reEntry then begin
        with FSimpleRSS.Items.Add do begin
          // a valid entry needs at least title and content
          if (ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil)
            and (ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent) = nil) then begin
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) = nil then
              raise ESimpleRSSException.Create(emRequiredFieldMissing + reEntry + strArrow + reTitle);
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent) = nil then
              raise ESimpleRSSException.Create(emRequiredFieldMissing + reEntry + strArrow + reContent);
          end; // if then

          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle) <> nil then
            Title := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reTitle).NodeValue;
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink) <> nil then
            if not VarIsNull(ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).Attributes[attHREF]) then
              Link := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reLink).Attributes[attHREF];

          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent) <> nil then begin
            aTempNode:=ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent);
            if (aTempNode.ChildNodes.Count>0) then begin
              Description := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent).ChildNodes.Nodes[0].NodeValue;
            end else begin
              Description := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reContent).NodeValue;
            end;
            if not VarIsNull(aTempNode.Attributes[attMode]) then begin
              if (aTempNode.Attributes[attMode] = attValueBase64) then
                Description:=DecodeString(etBase64,Description)
            end;
          end;

          // parse author
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor) <> nil then begin
            aTempNode := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reAuthor);
            if aTempNode.ChildNodes.FindNode(reName) <> nil then
              Author.Name := aTempNode.ChildNodes.FindNode(reName).NodeValue;
            if aTempNode.ChildNodes.FindNode(reEMail) <> nil then
              Author.EMail := aTempNode.ChildNodes.FindNode(reEMail).NodeValue;
            if aTempNode.ChildNodes.FindNode(reURL) <> nil then
              Author.URL := aTempNode.ChildNodes.FindNode(reURL).NodeValue;
          end;

          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments) <> nil then
            Comments := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reComments).NodeValue;
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reModified) <> nil then
            PubDate.LoadDCDateTime(ChildNodes.Nodes[Counter].ChildNodes.FindNode(reModified).NodeValue);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure) <> nil then begin
            if
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reURL) = nil then
              raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reURL);
            if
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reLength) = nil then
              raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reLength);
            if
              ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.FindNode(reType) = nil then
              raise ESimpleRSSException.Create(emRequiredFieldMissing + reEnclosure + strArrow + reType);
            Enclosure.URL := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reURL].NodeValue;
            Enclosure.Length := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reLength].NodeValue;
            Enclosure.EnclosureType := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reEnclosure).AttributeNodes.Nodes[reType].NodeValue;
            Enclosure.Include := True;
          end; // if then
          // atom ID is stored in the GUID
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reID) <> nil then begin
            GUID.Include := True;
            GUID.GUID := ChildNodes.Nodes[Counter].ChildNodes.FindNode(reID).NodeValue;
          end; // if then
          
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(rePubDate) <> nil then
            PubDate.LoadDateTime(ChildNodes.Nodes[Counter].ChildNodes.Nodes[rePubDate].NodeValue);
          if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource) <> nil then begin
            if ChildNodes.Nodes[Counter].ChildNodes.FindNode(reSource).AttributeNodes.FindNode(reURL) = nil then
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
      if ChildNodes.Nodes[Counter].NodeName = reLanguage then begin
        FSimpleRSS.Channel.Optional.Language := StringToLanguage(ChildNodes.Nodes[Counter].NodeValue);
        if FSimpleRSS.Channel.Optional.Language = langX then
          FSimpleRSS.Channel.Optional.Xlang := ChildNodes.Nodes[Counter].NodeValue
        else
          FSimpleRSS.Channel.Optional.Xlang := '';
      end; // if then

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
