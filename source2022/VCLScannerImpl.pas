{ Invokable implementation File for TVCLScanner which implements IVCLScanner }
{ ****************************************************************
  sourcefile:  	vclscannerimpl.pas
  typ:      		implementation-Unit
  author :  		borland, max kleiner, LoCs 151
  description:  handles and supports interface of database writing
  classes:	  	see ModelMaker ps#12
  specials: 	  cooperates with ivclscanner and interbase
                change of the dbexp dll depends on os
  revisions:     	20.07.04 build menu structure
			            19.08.06 enlarge register functions and test xmemo
                  20.08.06 orchestrator and ticketing
                  26.08.06 put config data in the file pathinfo.txt
                  30.08.06 format logdate, new db schema
 **************************************************************** }


unit VCLScannerImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, VCLScannerIntf;

type
  { TVCLScanner }
  TVCLScanner = class(TInvokableClass, IVCLScanner)
  public
    function PostData(const UserData : WideString; const CheckSum : integer): Boolean; stdcall;
    procedure PostUser(const Email, FirstName, LastName : WideString); stdcall;
    function GetTicketNr: longint; stdcall;
  end;

  TVCLOrchestrator = class(TInvokableClass, IVCLOrchestrator)
     function SetSequence(S,Localizar,Substituir: shortstring): shortstring;
                                                                stdcall;
     procedure lineToNumber(xmemo: String; met: boolean); stdcall;
  end;

implementation

uses
  Classes, SysUtils, CRC32, SqlExpr, vwebmod;

const
  //StrDatabase2Dfr = 'Database=APSN21:D:\kleiner2005\ekon9_10\soa_vcl\umlbank2.gdb';
  StrINSERTSQLStat = 'insert into KINGS values("%d","%s","%s","%s","%s")';


function TVCLScanner.GetTicketNr: longint;
begin
  randomize;
  result:= random(30000000)+1;
end;

function TVCLScanner.PostData(const UserData: WideString; const CheckSum: integer): Boolean;
var
  SL: TStringList;
  FileName: String;
begin
  with TWebModule1.Create(NIL) do begin
    getFile_DatabasePath;
    FileName:= filePath+FormatDateTime('yyyymmdd-hhnnsszzz',Now)+'.txt';
    Free
  end;
  SL:= TStringList.Create;
  SL.Text:= UserData;
  SL.SaveToFile(FileName);
  SL.Free;
  Result:= True;
end;

procedure TVCLScanner.PostUser(const Email, FirstName, LastName: WideString);
var
  SQLConnection1: TSQLConnection;
  DataSet: TSQLDataSet;
  logdate: string[16];
begin
  SQLConnection1:= TSQLConnection.Create(NIL);
    with TWebModule1.Create(NIL) do begin
      letSQLConnection(SQLConnection1);
      Free
    end;
  DataSet:= TSQLDataSet.Create(NIL);
  logdate:= dateTimeToStr(now);
  with DataSet do begin
    SQLConnection:= SQLConnection1;
    CommandText:= Format(StrINSERTSQLStat,
                               [10,Email,FirstName,LastName,logdate]);
   // commandText:=
   //'insert into KINGS values(10, "email","firstname","lastname", logdate)';
   //'insert into KINGS values(10, "email","firstname", "lastname",logdate)';
    try
      ExecSQL;
      //silent cause of CGI Webscript or reraise after a message
    except
      raise
    end;
  end;
  SQLConnection1.Close;
  DataSet.Free;
  SQLConnection1.Free;
end;

{ TVCLOrchestrator }

procedure TVCLOrchestrator.lineToNumber(xmemo: string; met: boolean);
var i: integer;
  mypos: integer;
  mystr: string[250];
begin
  if met then
  for i:= 1 to length(xmemo)  - 1 do begin
     //xmemo[i]:= inttostr(i)+' '+xmemo[i];
  end
  //check if linenumber was on before
  else if pos(inttostr(1), xmemo[1]) <> 0 then begin
    for i:= 1 to length(xmemo) - 1 do begin
      mypos:= pos(inttostr(i), xmemo[i]);
      if pos(inttostr(i), xmemo[i]) <> 0 then begin
        mystr:= xmemo[i];
        delete(mystr, mypos, (length(inttostr(i))+1));
        //xmemo[i]:= mystr;
      end;
    end;
  end;
end;

function TVCLOrchestrator.SetSequence(S, Localizar,
                                  Substituir: shortstring): shortstring;
  var
   Retorno: String;
   Posicao: Integer;
begin
   Retorno:= S;
   //Obtendo a posição inicial da substring Localizar na string Localizar.
   Posicao:= Pos (Localizar, Retorno);
   // Verificando se a substring Localizar existe.
   if Posicao <> 0 then begin
      // Excluindo a Localizar.
      Delete(Retorno, Posicao, Length (Localizar));
      // Inserindo a string do parâmetro Substituir
      Insert(Substituir, Retorno , Posicao);
   end;
 Result:= Retorno;
end;

initialization
  { Invokable classes must be registered }
  InvRegistry.RegisterInvokableClass(TVCLScanner);
  InvRegistry.RegisterInvokableClass(TVCLOrchestrator);
end.

