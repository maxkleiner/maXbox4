program RSA;

{*********************************************************************}
{// Name     : Start.exe
{// Zweck    : AutoInf Programm fuer CD
{// Umgebung : Windows XP / Delphi 7
{// Autor    : U. Etter
{// Output   : EXE
{// Update   : 12.04.2006
{//*******************************************************************}

uses
  Forms,
  PrivateKey in 'PrivateKey.pas'; {Main}

{$R *.RES}

begin
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
