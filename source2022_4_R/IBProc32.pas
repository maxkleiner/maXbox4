{**********************************************************}
{                                                          }
{       Borland Deplphi                                    }
{       InterBase EventAlerter components                  }
{       Copyright (c) 1995, 1999-2002 Borland Corporation  }
{                                                          }
{       Written by:                                        }
{         James Thorpe                                     }
{         CSA Australasia                                  }
{         Compuserve: 100035,2064                          }
{         Internet:   csa@csaa.com.au                      }
{                                                          }
{**********************************************************}

unit IBProc32;

interface
uses sysutils;
{$F+}

const
  isc_dpb_version1  = 1;
  isc_dpb_user_name = 28;
  isc_dpb_password  = 29;

  isc_tpb_concurrency = 2;
  isc_tpb_version3  = 3;
  isc_tpb_wait      = 6;
  isc_tpb_write     = 9;

type
  isc_db_handle = pointer;
  pisc_db_handle = ^isc_db_handle;
  isc_long = longint;
  pisc_long = ^isc_long;
  isc_status = longint;
  pisc_status = ^isc_status;
  isc_tr_handle = pointer;
  pisc_tr_handle = ^isc_tr_handle;

  status_vector = array[0..19] of isc_status;
  pstatus_vector = ^status_vector;
  ppstatus_vector = ^pstatus_vector;

  Short = word;

  isc_teb = record
    db_ptr: pisc_db_handle;
    tpb_len: longint;
    tpb_ptr: pchar;
  end;
  pisc_teb = ^isc_teb;

  TXSQLVar = record
  end;

  TXSQLDA = record
  end;
  PTXSQLDA = ^TXSQLDA;

  isc_callback = procedure( ptr: pointer; length: short; updated: pchar);

{ Interbase LIBS definitions }

//isc_attach_database
TIscAttachDatabase = function(
  status: pstatus_vector;
  db_name_length: short;
  db_name: pchar;
  db_handle: pisc_db_handle;
  parm_buffer_length: short;
  parm_buffer: pchar
  ): isc_status; stdcall;

// isc_cancel_events
TIscCancelEvents = function(
  status: pstatus_vector;
  db_handle: pisc_db_handle;
  event_id: pisc_long
  ): isc_status; stdcall;

// isc_commit_transaction
TIscCommitTransaction = function(
  status: pstatus_vector;
  trans_handle: pisc_tr_handle
  ): isc_status; stdcall;

// isc_detach_database
TIscDetachDatabase = function(
  status: pstatus_vector;
  db_handle: pisc_db_handle
  ): isc_status; stdcall;

// isc_drop_database
TIscDropDatabase = function(
  status: pstatus_vector;
  db_handle: pisc_db_handle
  ): isc_status; stdcall;

// isc_dsql_execute_immediate
TIscDsqlExecuteImmediate = function(
  status: pstatus_vector;
  db_handle: pisc_db_handle;
  trans_handle: pisc_tr_handle;
  length: short;
  statement: PChar;
  dialect: short;
  xslqda: PTXSQLDA
  ): isc_status; stdcall;

// isc_event_block
TIscEventBlock = function(
  event_buf: pointer;
  result_buf: pointer;
  count: short;
  name1: pchar):  longint; cdecl;

// isc_event_counts
TIscEventCounts = procedure(
  status: pstatus_vector;
  buffer_length: short;
  event_buffer: pchar;
  result_buffer: pchar
  ); stdcall;

// isc_free
TIscFree = function(
  buffer: PChar
  ): isc_long; stdcall;

// isc_interprete
TIscInterprete = function(
  buffer: PChar;
  status: ppstatus_vector
  ): isc_status; stdcall;

// isc_que_events
TIscQueEvents = function(
  status: pstatus_vector;
  db_handle: pisc_db_handle;
  event_id: pisc_long;
  length: short;
  event_buffer: pchar;
  event_function: isc_callback;
  event_function_arg: pointer
  ): isc_status; stdcall;

// isc_rollback_transaction
TIscRollbackTransaction = function(
  status: pstatus_vector;
  trans_handle: pisc_tr_handle
  ): isc_status; stdcall;

// isc_start_multiple
TIscStartMultiple = function(
  status: pstatus_vector;
  trans_handle: pisc_tr_handle;
  db_handle_count: short;
  teb_vector_address: pisc_teb
  ): isc_status; stdcall;

// load DLL error exception
EDLLLoadError = class(Exception);

implementation

end.
