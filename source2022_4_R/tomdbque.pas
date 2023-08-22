{*******************************************************}
{                                                       }
{         Tom's Delphi Extensions                       }
{         For 32-bit applications only                  }
{                                                       }
{         Copyright (c) 1996, 1998 huehn-software       }
{                                                       }
{         EMail tom@huehn-software.de                   }
{         Home  http://www.huehn-software.de            }
{*******************************************************}
{         Creates a background Query using Threads.     }
{         Using multiple Query synronus in Background , }
{         you have to create Database-Components for    }
{         every TQuery-Component.                       }
{                                                       }
{         This component is based on the Borland        }
{         Tecnical Information Article :                }
{         3005:  Performing database queries            }
{                in a background thread                 }
{                                                       }
{                                                       }
{         Released at Public-Domain.                    }
{         The Author is not responsiple for any errors  }
{         or lost Data.                                 }
{                                                       }
{                                                       }
{*******************************************************}

unit TomDBQue;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables;

type
  TTomQueryThread = class(TThread)
  private
    FQuery: TQuery;
    FQueryException: Exception;
    FQueryThreadReady:TNotifyevent;
    FQueryThreadError:TNotifyevent;
    procedure CallReady;
    procedure ShowQryError;
  protected
    procedure Execute; override;
  public
    constructor Create(Query: TQuery); virtual;
     property OnQueryThreadReady:Tnotifyevent read FQueryThreadReady write FQueryThreadReady;
     property OnQueryThreadError:Tnotifyevent read FQueryThreadError write FQueryThreadError;
  end;


 TTomBackgroundQuery=Class(TComponent)
  private
    FQuery: TQuery;
    FQueryReady:TNotifyevent;
    FQueryError:TNotifyevent;
  public
    procedure Execute;
  Published
    Property Query:TQuery read FQuery write FQuery;
    property OnQueryReady:Tnotifyevent read FQueryReady write FQueryReady;
    property OnQueryError:Tnotifyevent read FQueryError write FQueryError;
  end;


// procedure Register;

implementation
{------------------------------------------------------------------------------
                           TTomQueryThread
 ------------------------------------------------------------------------------}
constructor TTomQueryThread.Create(Query: TQuery);
begin
  inherited Create(True);
  FQuery := Query;
  FreeOnTerminate := True;
  Resume;
end;

procedure TTomQueryThread.Execute;
begin
  try
    FQuery.Open;
    Synchronize(CallReady);
  except
    FQueryException := ExceptObject as Exception;
    Synchronize(ShowQryError);
  end;
end;

procedure TTomQueryThread.CallReady;
begin
  if Assigned(FQueryThreadReady) then FQueryThreadReady(self);
end;

procedure TTomQueryThread.ShowQryError;
begin
  if Assigned(FQueryThreadError)
   then FQueryThreadError(self)
   else Application.ShowException(FQueryException);
end;

{------------------------------------------------------------------------------
                           TTomBackGroundQuery
 ------------------------------------------------------------------------------}
procedure TTomBackgroundQuery.Execute;
begin
  with TTomQueryThread.Create(FQuery) do
   begin
     OnQueryThreadReady:=FQueryReady;
     OnQueryThreadError:=FQueryError;
   end;
end;

{-----------------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('TomDB', [TTomBackgroundQuery]);
end;

end.
