// TeeChart Pro Defines
// See modifiable User Options below ...
{$IFDEF ADRENOCHROME}
{$DEFINE CHROME}
{$ELSE}
{$H+}
{$ENDIF}

{.$DEFINE TEEBETA} // Enable to compile in "BETA" mode (About Box, etc)

{$IFDEF CLR}

{$DEFINE TEENOASM}   // ASM (Inline Assembler) not supported in .NET
{$DEFINE TEESAFECLR} // Force "Safe" managed code only.

{$IFNDEF CHROME}
{$FINITEFLOAT OFF}   // Turn off floating-point exceptions to speed performance
{$ENDIF}

{$ENDIF}

{$DEFINE TEEVCL}  // Internal. Do not undefine TEEVCL !

 // {$DEFINE D11}


{$DEFINE TEEEDITORS}

{$IFDEF FPC}
{$DEFINE LCL}
{$ENDIF}

{$IFDEF LCL}
  {$MODE DELPHI}
  {$DEFINE D3}
  {$DEFINE D4}
{$ENDIF}

{$IFDEF VER190}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
  {$DEFINE D9}
  {$DEFINE D10}
  {$DEFINE D11}
{$ENDIF}

{$IFDEF VER185}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
  {$DEFINE D9}
  {$DEFINE D10}
  {$DEFINE D105}
{$ENDIF}

{$IFDEF VER180}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
  {$DEFINE D9}
  {$DEFINE D10}
{$ENDIF}

{$IFDEF VER170}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
  {$DEFINE D9}
{$ENDIF}

{$IFDEF VER160}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$IFDEF BCB}
    {$DEFINE C5}
    {$DEFINE C6}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER145}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$IFDEF BCB}
    {$DEFINE C5}
    {$DEFINE C6}
  {$ENDIF}
  {$DEFINE K3}
{$ENDIF}

{$IFDEF CONDITIONALEXPRESSIONS}

  {$IFDEF LINUX}
   {$IF Declared(RTLVersion) and (RTLVersion>14.0)}
    {$DEFINE K3}
   {$IFEND}
  {$ENDIF}

  {$IFDEF BCB}
   {$IF Declared(RTLVersion) and (RTLVersion>=14.5)}

    {$DEFINE D3}
    {$DEFINE D4}
    {$DEFINE D5}
    {$DEFINE C5}
    {$DEFINE D6}
    {$DEFINE D7}
    {$DEFINE C7}
   {$IFEND}
  {$ENDIF}

{$ENDIF}

{$IFDEF VER140}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$IFDEF BCB}
    {$DEFINE C5}
    {$DEFINE C6}
  {$ENDIF}  
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE C4}
  {$DEFINE C5}
{$ENDIF}

{$IFDEF VER125}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE C3D4}
  {$DEFINE C4}
  {$DEFINE BCB}
{$ENDIF}

{$IFDEF VER120}
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE C3D4}
{$ENDIF}

{$IFDEF VER110}
  {$DEFINE D3}
  {$IFDEF BCB}
    {$DEFINE C3}
    {$DEFINE C3D4}
  {$ELSE}
    {$DEFINE D4}
    {$DEFINE C3D4}
  {$ENDIF}
{$ENDIF}

{$IFDEF DECLARE_GPL}
{$DEFINE KYLIXOPEN}
{$ENDIF}

{$IFDEF BCB}
{$ObjExportAll On}
{$ENDIF}

{$IFDEF VER110}
  'Error: This TeeChart version does not support Delphi 4. Please use TeeChart version 7.'
{$ENDIF}

{$IFDEF VER100}
  'Error: This TeeChart version does not support Delphi 3. Please use TeeChart version 5.'
{$ENDIF}

{$IFDEF VER80}
  'Error: This TeeChart version does not support Delphi 1 and 2. Please use TeeChart version 4.'
{$ENDIF}

{$IFDEF LINUX}
{$DEFINE CLX}
{$ENDIF}

{$IFDEF D6}
{$DEFINE D6DESIGNER}
{$ELSE}
{$IFDEF CLX}
{$DEFINE D6DESIGNER}
{$ENDIF}
{$ENDIF}

{$IFDEF D7}
{$IFNDEF K3}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
{$ENDIF}

{$IFDEF D6} 
{$WARN UNIT_PLATFORM OFF}   // Hide unit platform warnings
{$WARN SYMBOL_PLATFORM OFF} // Hide symbol platform warnings (streaming read/write)
{$ENDIF}

// User Options
// =====================

{$IFDEF CHROME}
{$UNDEF D9}
{$ENDIF}

{$IFDEF D9}
{$INLINE ON}  // Enable or disable inlining in Delphi 9
{$ENDIF}

{.$DEFINE NOUSE_BDE}      // <-- remove the "." to avoid using the BDE (in QRChart, etc)
{.$DEFINE TEEMULTIPLIER}  // <-- remove the "." to enable obsolete "Multiplier" property,                           //     (slower performance)

{$IFDEF D5}
{.$DEFINE TEEENTERPRISE}  // <-- remove the "." to add ADO support in TeeChart Wizard
{$ENDIF}

{$IFDEF D4}

// TList     = less speed modifying values, more speed deleting values, much MORE memory
// Dyn Array = Direct access to values, more speed modifying values, much LESS memory,
//             less speed deleting values. Not for Delphi 3.

{$DEFINE TEEARRAY}  // <-- put a "." in front to use TList instead of Dynamic Arrays

{$ENDIF}

{$IFNDEF TEEVALUESINGLE}
{$IFNDEF TEEVALUEEXTENDED}

// "Value" type for point values data.  
// Remove the "." on ONLY one of the items below:

{$DEFINE TEEVALUEDOUBLE}
{.$DEFINE TEEVALUESINGLE}
{.$DEFINE TEEVALUEEXTENDED}

{$ENDIF}
{$ENDIF}

// Unicode support from D6 and up,
// but not for BCB6 due to overload ambiguity. Not for CLX.
{$IFDEF BCB}
 {$IFDEF D10}
   {$DEFINE TEEUNICODE}
 {$ENDIF}
{$ELSE}
 {$IFNDEF CLR}
  {$IFDEF D6}
   {$DEFINE TEEUNICODE}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

