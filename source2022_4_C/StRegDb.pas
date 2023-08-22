(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower SysTools
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{* SysTools: StRegDb.pas 4.03                            *}
{*********************************************************}
{* SysTools: Data-Aware Component Registration Unit      *}
{*********************************************************}

{$I StDefine.inc}

{$R StRegDb.r32}

unit StRegDb;

interface

uses
  Classes;

procedure Register;

implementation

uses
  StBase,
  StDbBarC,
  StDbPNBC,
  StDb2DBC,
  StExport;

procedure Register;
begin
  RegisterComponents('SysTools', [TStDbBarCode, TStDbPNBarCode, TStDbPDF417Barcode, TStDbMaxiCodeBarcode]);
end;

end.
