program RSA2_maXbox4_Crypto64;

{*********************************************************************}
{// Name     : RSAStart.exe   Cryptobox Sample
{// Zweck    : AutoInf Programm fuer CD   Teaching RSA
{// Umgebung : Windows XP / Delphi 7  /Delphi Community Edition 10.3
{// Autor    : Max Kleiner
{// Output   : EXE or TXT
{// Update   : 12.04.2006 - 12.05.2020 - 16.05.2020  - englisch 22/12/2022
{//*******************************************************************}

{$R *.dres}

uses
  Forms, Windows,
  PrivateKey in 'PrivateKey.pas';

{Main}

{$R *.RES}

begin
  Application.CreateForm(TMain, Main);
  //MinIcon:=TIcon.Create;
  //Application.Icon:=LoadIcon(hInstance,'Icon_1');;
  Application.Run;
end.
