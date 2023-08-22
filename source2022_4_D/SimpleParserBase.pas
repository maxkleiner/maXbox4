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
unit SimpleParserBase;

interface

uses Classes, SimpleRSS;

type
    TSimpleParserBase = class(TObject)
    private
    protected
      FSimpleRSS: TSimpleRSS;
    public
        Procedure Generate; virtual; abstract;
        procedure Parse; virtual; abstract;
        constructor Create(SimpleRSS: TSimpleRSS);
    published
    end; { TSimpleParserBase }

implementation

constructor TSimpleParserBase.Create(SimpleRSS: TSimpleRSS);
begin
  inherited Create;
  FSimpleRSS:=SimpleRSS;
end;

end.
