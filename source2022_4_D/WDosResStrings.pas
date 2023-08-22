
{*******************************************************}
{                                                       }
{       WDosX Delphi Run-time Library                   }
{       WDosX common resource strings                   }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de                  }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
}

unit WDosResStrings;

interface

resourcestring
  { WDosCheck }
  SWDosXVersion = 'WDosX for Delphi 5 Version 1.1';
  SWithoutExtenderError = 'Cannot run without WDOSX DOS extender!';

  { WDosWfseStreams }
  SCantInitializeWfse = 'Can''t initialize WFSE';
  SCantWriteWfseStreamError = 'Can''t write into WFSE stream';

  { WDosAbiUtils }
  SAbiNoError = 'No Error';
  SAbiBadCall = 'Bad Call';
  SAbiCritical = 'Critical';
  SAbiNoHandle = 'No Handle';
  SAbiBadHandle = 'Bad Handle';
  SAbiTimeOut = 'Timeout';
  SAbiBadSession = 'Bad Session';
  SAbiNotOpen = 'Not Open';
  SAbiDpmiError = 'DPMI Error';
  SAbiUnknownError = 'Unknown Error';

  { WDosLptCtrls }
  sLptCtrlNotOpen ='Device %s is not open';
  sLptCtrlOnOpenError ='Operation on opened device %s not allowed';
  sLptCtrlOpenError ='Device %s can''t be opened';

  { WDosAbiDrvr }
  SAllocDosMemError = 'No DOS memory available.';
  SFreeDosMemError = 'Error at freeing DOS memory';

  { WDosScktComp }
  SWDosSocketError = 'WDosX socket error: %s (%d), at Abi function ''%s''';
  SResolverError = 'Resolver error: %s (%d), on method ''%s''';
  SLookupHandleZero = 'lookup handle is zero';
  SAbiInitializationError = 'TCP/IP Abi driver not detected';
  SAbiSocketError = 'TCP state: %d InBytes: %d OutBytes: %d';
  SCancelLookupOk = 'Lookup Ok';
  SCancelLookupNetDown = 'Lookup net down';
  SCancelLookupInval = 'Lookup invalidate';
  SCancelLookupAlready = 'Lookup already finished';
  SServerSocketCannotOpen = 'Server socket can not be opened';
  SNoListenSockets = 'Server Socket can not open listen sockets';

  { WDosTimers }
  SRequestAccessInstanceError = 'Illegal request %d in AccessInstance';
  SAccessThroughInstanceOnlyError = 'Access class %s through Instance only';
  STimerModeError = 'CTC timer 0 don''t works in mode 2 or 3';

  implementation

end.