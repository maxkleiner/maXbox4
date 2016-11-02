{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence              2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10063: IdAntiFreeze.pas #sign:Max: MAXBOX10: 15/05/2016 23:16:07 
{
{   Rev 1.0    2002.11.12 10:29:54 PM  czhower
        1.1    2016 tester for maXbox
}
unit IdAntiFreeze;

{$DEFINE MSWINDOWS}

{
NOTE - This unit must NOT appear in any Indy uses clauses. This is a ONE way relationship
and is linked in IF the user uses this component. This is done to preserve the isolation from the
massive FORMS unit.
}

interface

{uses
  Classes,
  IdAntiFreezeBase,
  IdBaseComponent;    }
{Directive needed for C++Builder HPP and OBJ files for this that will force it
to be statically compiled into the code}

//{$I IdCompilerDefines.inc}

{$IFDEF MSWINDOWS}

//{$HPPEMIT '#pragma link "IdAntiFreeze.obj"'}    {Do not Localize}

{$ENDIF}

{$IFDEF LINUX}

//{$HPPEMIT '#pragma link "IdAntiFreeze.o"'}    {Do not Localize}

{$ENDIF}
//type
  //TIdAntiFreeze = class(TIdAntiFreezeBase)
  //public
    procedure Process; //override;
  //end;

  var ApplicationHasPriority: boolean;
      GAntiFreeze: TIdAntiFreezeBase; // = nil;

implementation

(*uses
{$IFDEF LINUX}
  QForms;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Forms,
  Messages,
  Windows;
{$ENDIF}
  *)
{$IFDEF LINUX}
procedure TIdAntiFreeze.Process;
begin
  //TODO: Handle ApplicationHasPriority
  Application.ProcessMessages;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure Process;
var
  Msg: TMsg;
begin
  if ApplicationHasPriority then begin
    Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Application.HandleMessage;
    end;
  end;
end;

{class} function TIdAntiFreezeBase_ShouldUse: boolean;
begin
  // InMainThread - Only process if calling client is in the main thread
  Result := (GAntiFreeze <> nil) and InMainThread;
  if Result then begin
    Result := GAntiFreeze.Active;
  end;
end;

{$ENDIF}

begin
  ApplicationHasPriority:= true;
  Process;
  //class procedure DoProcess(const AIdle: boolean = true; const AOverride: boolean = false);
  with TIdAntiFreezeBase.create(self) do begin
    writeln(botostr(shoulduse));
    //DoProcess(true, false)
    active:= false;
    Free;
    //TIdBaseComponent().Free
  end;  
    
end.
