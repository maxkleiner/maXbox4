{$ifndef FPC}
  {$define WINDOWS} // TODO: FIX FOR KYLIX
{$endif}

{$ifdef FPC} {$mode objfpc}{$H+}
{$endif}

{$ifdef EXTRA_SECURE}
  {$R+}
  {$IFDEF FPC}{$Q+}{$CHECKPOINTER ON}{$ENDIF}
{$endif}
