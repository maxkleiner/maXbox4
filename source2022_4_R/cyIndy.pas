{   Unit cyImageEn3

    Description:
    Unit with functions to use with Indy components.

    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    $  €€€ Accept any PAYPAL DONATION $$$  €
    $      to: mauricio_box@yahoo.com      €
    €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

    * ***** BEGIN LICENSE BLOCK *****
    *
    * Version: MPL 1.1
    *
    * The contents of this file are subject to the Mozilla Public License Version
    * 1.1 (the "License"); you may not use this file except in compliance with the
    * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
    *
    * Software distributed under the License is distributed on an "AS IS" basis,
    * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
    * the specific language governing rights and limitations under the License.
    *
    * The Initial Developer of the Original Code is Mauricio
    * (https://sourceforge.net/projects/tcycomponents/).
    *
    * Donations: see Donation section on Description.txt
    *
    * Alternatively, the contents of this file may be used under the terms of
    * either the GNU General Public License Version 2 or later (the "GPL"), or the
    * GNU Lesser General Public License Version 2.1 or later (the "LGPL"), in which
    * case the provisions of the GPL or the LGPL are applicable instead of those
    * above. If you wish to allow use of your version of this file only under the
    * terms of either the GPL or the LGPL, and not to allow others to use your
    * version of this file under the terms of the MPL, indicate your decision by
    * deleting the provisions above and replace them with the notice and other
    * provisions required by the LGPL or the GPL. If you do not delete the
    * provisions above, a recipient may use your version of this file under the
    * terms of any one of the MPL, the GPL or the LGPL.
    *
    * ***** END LICENSE BLOCK *****}

unit cyIndy;

interface

uses Classes, SysUtils, idHttp, idComponent, idCoderHeader, IdCoderMIME, IdHashMessageDigest;

type
  // Set ContentType according to mail content
  // RelatedAttach are embedded content (like images) on html page
  TContentTypeMessage = (cmPlainText, cmPlainText_Attach,
                         cmHtml_Attach, cmHtml_RelatedAttach,
                         cmAlterText_Html,
                         cmAlterText_Html_Attach,
                         cmAlterText_Html_RelatedAttach,
                         cmAlterText_Html_Attach_RelatedAttach,
                         cmReadNotification);

const
  MessagePlainText                           = 'text/plain';
  MessagePlainText_Attach                    = 'multipart/mixed';
  MessageAlterText_Html                      = 'multipart/alternative';  // Hide attachments and only html is viewed
  MessageHtml_Attach                         = 'multipart/mixed';
  MessageHtml_RelatedAttach                  = 'multipart/related; type="text/html"'; // No simple text
  MessageAlterText_Html_Attach               = 'multipart/mixed';
  MessageAlterText_Html_RelatedAttach        = 'multipart/related; type="multipart/alternative"';
  MessageAlterText_Html_Attach_RelatedAttach = 'multipart/mixed';
  MessageReadNotification                    = 'multipart/report; report-type="disposition-notification"';

function ForceDecodeHeader(aHeader: String): String;

// Functions to encode/Decode base64:
function Base64_EncodeString(Value: String; const aEncoding: TObject = Nil): string;  // Descodificar com Base64_DecodeToString()
function Base64_DecodeToString(Value: String; const aBytesEncoding: TObject = nil): String; overload; // Descodifica o que foi codificado com Base64_EncodeString()

function Base64_DecodeToBytes(Value: String): TBytes; overload;

function IdHttp_DownloadFile(aSrcUrlFile, aDestFile: String; const OnWorkEvent: TWorkEvent = Nil): Boolean;
function Get_MD5(const aFileName: string): string;
function Get_MD5FromString(const aString: string): string;

implementation

function ForceDecodeHeader(aHeader: String): String;
begin
  { Why?: "Subject" not correctly returned on DecodeHeader function:
    Subject Exemple:
    =?iso-8859-1?Q?Est=E1 na hora de avan=E7ar para o RAD Studio XE Enterprise!?=

    idMessage.pas:
    Subject := DecodeHeader(Headers.Values['Subject']);

     idCoderHeader.pas linha 228:
        LDataEnd := PosIdx('?=', AHeader, LData);
        if (LDataEnd = 0) // RHR or (LDataEnd > VEndPos)
        then begin
          Exit;
        end;

  // Depois de ter falado com Remy Lebeau, pela norma iso, não deveria ter espaços no assunto pelo que é por isso que não descodifica ...
  }
  aHeader := StringReplace(aHeader, ' ', '&nbsp;', [rfReplaceAll]);
  aHeader := idCoderHeader.DecodeHeader(aHeader);
  Result := StringReplace(aHeader, '&nbsp;', ' ', [rfReplaceAll]);
end;

function Base64_EncodeString(Value: String; const aEncoding: TObject = Nil): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    //Result := Encoder.EncodeString(Value, aEncoding);
    Result := Encoder.EncodeString(Value);

  finally
    Encoder.Free;
  end;
end;

function Base64_DecodeToString(Value: String; const aBytesEncoding: TObject = nil): String; overload;
var
  Decoder: TIdDecoderMIME;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    //Result := Decoder.DecodeString(Value, aBytesEncoding);
    Result := Decoder.DecodeString(Value);

  finally
    Decoder.Free;
  end;
end;

function Base64_DecodeToBytes(Value: String): TBytes; overload;
var
  Decoder: TIdDecoderMIME;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    //Result := Decoder.DecodeBytes(Value);
  finally
    Decoder.Free;
  end;
end;

function IdHttp_DownloadFile(aSrcUrlFile, aDestFile: String; const OnWorkEvent: TWorkEvent = Nil): Boolean;
var
  Http: TIdHTTP;
  MS: TMemoryStream;
begin
  Result := false;
  Http := TIdHTTP.Create(nil);
  try
    MS := TMemoryStream.Create;
    try
      if Assigned(OnWorkEvent) then
        Http.OnWork := OnWorkEvent;

      Http.Get(aSrcUrlFile, MS);
      MS.SaveToFile(aDestFile);
      Result := true;
    finally
      MS.Free;
    end;
  finally
    Http.Free;
  end;
end;

function Get_MD5(const aFileName: string): string;
var
  idmd5: TIdHashMessageDigest5;
  fs: TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(aFileName, fmOpenRead OR fmShareDenyWrite) ;
  try
    //Result := idmd5.HashStreamAsHex(fs);
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

function Get_MD5FromString(const aString: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    //Result := idmd5.HashStringAsHex(aString);
  finally
    idmd5.Free;
  end;
end;

end.
