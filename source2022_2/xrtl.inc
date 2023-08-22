{$BOOLEVAL       OFF} // Boolean shortcut evaluation
{$LONGSTRINGS    ON}  // Long strings
{$WRITEABLECONST OFF} // Read-only typed constants
{$TYPEDADDRESS   OFF} // Type checked pointers off
{$RANGECHECKS    OFF} // Range checking off
{$OVERFLOWCHECKS OFF} // Overflow checking off

//{$INCLUDE xrtl_compiler.inc}

{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}  // Platform warnings off
{$ENDIF}

{$IFDEF DELPHI7_UP}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

