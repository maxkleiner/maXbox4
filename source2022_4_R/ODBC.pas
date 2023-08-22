{ Usage: just give the values at object inspector and finally
  set Apply property to "True"
  to use "CreateDbForAccess" procedure you should first create a Data
  source for the created database and you set "DatabaseFileName" property
  for which database to be created.
  "CompactDbForAccess" procedure is also works in the same way.
  for your questions and bug repots please mail me at
   abdurrahmansahin@yahoo.com

   thank you

   http://delphi.about.com and nsonic.de/delphi sites !
     }

unit ODBC;

interface

uses
 Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs;
type      FApplyEx=(False,True);
  FODBCActionEx=(ODBC_ADD_DSN,ODBC_CONFIG_DSN,ODBC_REMOVE_DSN,
    ODBC_ADD_SYS_DSN,ODBC_CONFIG_SYS_DSN,ODBC_REMOVE_SYS_DSN);

    FSrcTypeEx=(Access,dBase,Paradox,Excel,FoxPro);
  TODBC = class(TComponent)
  private
     FSrcType:FSrcTypeEx;
     FApply:FApplyEx;
     Fpath:string;
     FDescription:string;
     FDsnName:string;
      FDriver:string;
     FAttributes:string;
      FErrorResult:String;
     FODBC:Word;
     FODBCAction:FODBCActionEx;
    procedure SetFsrcType(FSrcTypeX:FSrcTypeEx);

    Procedure SetFPath(FPathX:string);

    procedure SetFDescription(FDescriptionX:string);

    procedure setFDsnName(FDsnNameX:string);

    procedure SetFApply(FApplyX:FApplyEx);

    procedure SetFODBCAction(FODBCActionX:FODBCActionEx);
    procedure SetFApplyAction(Key:integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure CompactDbForAccess;
    procedure CreateDbForAccess;
    constructor Create(AOwner:TComponent);override;
    Destructor Destroy; override;
    property ODBCError:String read FErrorResult;

  published
    { Published declarations }
  property ODBCSourceType:FSrcTypeEx read FSrcType write setFsrcType;
  property DatabaseFileName:string read  FPath write SetFPath;
  property Description:string  read FDescription write SetFDescription;
  property DSNName:string read FDsnName write SetFDsnName;
  property Apply:FApplyEx read FApply write SetFApply; //default False;

  Property ODBCAction:FODBCActionEx read FODBCAction write setFODBCAction;
  end;

 TMYSQL= function( hwndParent: HWND;
                       fRequest: WORD;
                      lpszDriver: LPCSTR;
                 lpszAttributes: LPCSTR ) :bool; stdcall;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Data Access', [TODBC]);
end;

constructor TODBC.Create(AOwner:TComponent);
begin
//FApply:=False;
inherited Create(AOwner);
end;
destructor TODBC.Destroy;
begin
inherited destroy;
end;

procedure TODBC.SetFApplyAction(Key:integer);
var
Psql:TMYSQL;
hLib:LongWord;
  FResult:bool;
begin
 Case key of
    1:begin
     FAttributes:='DSN='+FDsnName+#0+'DESCRIPTION='+FDescription+#0+'DBQ='+FPath+#0+#0;
      end;
     2: begin
    FAttributes:='DSN='+FDsnName+#0+'DESCRIPTION='+FDescription+#0+'DBQ='+FPath+#0+
   'CREATE_DB="'+FPath+'"'+#0+#0;
   end;
   3:
   begin
    FAttributes:='DSN='+FDsnName+#0+'DESCRIPTION='+FDescription+#0+'DBQ='+FPath+#0+
   'COMPACT_DB="'+FPath+'"'+#0+#0;
   end;
   end;
  //  Fdriver:='Microsoft Access Driver (*.mdb)';
   Hlib:=LoadLibrary('ODBCCP32.dll');
   if Hlib<> 0 then
       begin
       @PSQL:=GetProcAddress(HLib,'SQLConfigDataSource');
       if(@PSQL)<>nil then
       begin
         fresult:=(PSQL(0,FODBC,@Fdriver[1],@Fattributes[1]));
  //   if fresult=false then
    //      FErrorResult:=inttostr(Fodbc);

          end;
       FApply:=True;
       end;

end;

procedure TODBC.CompactDbForAccess;
begin
 SetFApplyAction(3);

 end;

procedure TODBC.CreateDbForAccess;
begin
SetFApplyAction(2);
 end;

procedure TODBC.SetFODBCAction(FODBCActionX:FODBCActionEx);
begin

   FODBC:=Ord(FODBCActionX)+1;
   FODBCAction:=FODBCActionX;


end;





procedure TODBC.SetFApply(FApplyX:FApplyEx);
begin
if (FApplyX=True) then
   begin
   SetFApplyAction(1);
        end
     else FApply:=False;
  end;


procedure TODBC.SetFsrcType(FSrcTypeX:FSrcTypeEx);
begin

 Case (Ord(FSrcTypeX)+1) of
      1:begin
      Fdriver:='Microsoft Access Driver (*.mdb)';
      FSrcType:=FSrcTypeX;
      end;

      2:begin
        FDriver:='Microsoft dBase Driver (*.dbf)';
      FSrcType:=FSrcTypeX;
      end;
      3:begin
      FDriver:='Microsoft Paradox Driver (*.db)';
      FSrcType:=FSrcTypeX;
      end;

      4:begin
      FDriver:='Microsoft Excel Driver (*.xls)';
      FSrcType:=FSrcTypeX;
      end;
      5:begin
      FDriver:='Microsoft FoxPro Driver';
      FSrcType:=FSrcTypeX;
      end;

      else

      end;



end;

procedure TODBC.SetFPath(FpathX:string);
begin
FAttributes:=FAttributes+' '+'DBQ='+FpathX+#0;
FPath:=FpathX;

  end;

procedure TODBC.setFDsnName(FDsnNameX:String);
begin
Fattributes:=FAttributes+' '+'DSN='+FDsnNameX+#0;
FDsnName:=FDsnNameX;
end;




procedure TODBC.SetFDescription(FDescriptionX:string);
begin

Fattributes:=FAttributes+' '+'Description='+FDescriptionX+#0;
FDescription:=FDescriptionX;

end;

end.








