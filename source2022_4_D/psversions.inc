////////////////////////////////////////////////////////////////////////////////
// File        : VERSIONS.INC
// Description : Supply a better list of defines than simply VERxxx
// Author      : Lasse Vågsæther Karlsen <lasse@cintra.no>
// Copyright   : (C) 1999 Lasse Vågsæther Karlsen

// Used with permission.
// Modified for D6/Kylix.  efg, June/July 2001.
// Modified for D7         Jim McKeeth, January 2003
// Modified for D8-2007    David Emami, April 2008

// $Author: Lasse $
// $Revision: 1 $
// $Date: 1.10.99 14:17 $
// $Archive: /Komponenter/Utils/VERSIONS.INC $

////////////////////////////////////////////////////////////////////////////////
// First define the proper version define
{$UNDEF DELPHI1}    {$IFDEF VER80}  {$DEFINE DELPHI1}    {$ENDIF}
{$UNDEF DELPHI2}    {$IFDEF VER90}  {$DEFINE DELPHI2}    {$ENDIF}
{$UNDEF BCB1}       {$IFDEF VER93}  {$DEFINE BCB1}       {$ENDIF}
{$UNDEF DELPHI3}    {$IFDEF VER100} {$DEFINE DELPHI3}    {$ENDIF}
{$UNDEF BCB3}       {$IFDEF VER110} {$DEFINE BCB3}       {$ENDIF}
{$UNDEF DELPHI4}    {$IFDEF VER120} {$DEFINE DELPHI4}    {$ENDIF}
{$UNDEF BCB4}       {$IFDEF VER125} {$DEFINE BCB4}       {$ENDIF}
{$UNDEF DELPHI5}    {$IFDEF VER130} {$DEFINE DELPHI5}    {$ENDIF}
{$UNDEF DELPHI6}    {$IFDEF VER140} {$DEFINE DELPHI6}    {$ENDIF}
{$UNDEF DELPHI7}    {$IFDEF VER150} {$DEFINE DELPHI7}    {$ENDIF}
{$UNDEF DELPHI8}    {$IFDEF VER160} {$DEFINE DELPHI8}    {$ENDIF}
{$UNDEF DELPHI2005} {$IFDEF VER170} {$DEFINE DELPHI2005} {$ENDIF}
{$UNDEF DELPHI2006} {$IFDEF VER180} {$DEFINE DELPHI2006} {$ENDIF}
{$UNDEF DELPHI2007} {$IFDEF VER185} {$DEFINE DELPHI2007} {$ENDIF}

{$IFDEF DELPHI2007}   {$DEFINE DELPHI2007UP} {$ENDIF}
{$IFDEF DELPHI2006}   {$DEFINE DELPHI2006UP} {$ENDIF}
{$IFDEF DELPHI2005}   {$DEFINE DELPHI2005UP} {$ENDIF}
{$IFDEF DELPHI8}      {$DEFINE DELPHI8UP}    {$ENDIF}
{$IFDEF DELPHI7}      {$DEFINE DELPHI7UP}    {$ENDIF}
{$IFDEF DELPHI6}      {$DEFINE DELPHI6UP}    {$ENDIF}
{$IFDEF DELPHI5}      {$DEFINE DELPHI5UP}    {$ENDIF}
{$IFDEF DELPHI4}      {$DEFINE DELPHI4UP}    {$ENDIF}
{$IFDEF DELPHI3}      {$DEFINE DELPHI3UP}    {$ENDIF}
{$IFDEF DELPHI2}      {$DEFINE DELPHI2UP}    {$ENDIF}
{$IFDEF DELPHI1}      {$DEFINE DELPHI1UP}    {$ENDIF}

{$IFDEF LINUX}        {$DEFINE DELPHI7UP}    {$ENDIF}

{$IFDEF DELPHI2007UP} {$DEFINE DELPHI2006UP} {$ENDIF}
{$IFDEF DELPHI2006UP} {$DEFINE DELPHI2005UP} {$ENDIF}
{$IFDEF DELPHI2005UP} {$DEFINE DELPHI8UP}    {$ENDIF}
{$IFDEF DELPHI8UP}    {$DEFINE DELPHI7UP}    {$ENDIF}
{$IFDEF DELPHI7UP}    {$DEFINE DELPHI6UP}    {$ENDIF}
{$IFDEF DELPHI6UP}    {$DEFINE DELPHI5UP}    {$ENDIF}
{$IFDEF DELPHI5UP}    {$DEFINE DELPHI4UP}    {$ENDIF}
{$IFDEF DELPHI4UP}    {$DEFINE DELPHI3UP}    {$ENDIF}
{$IFDEF DELPHI3UP}    {$DEFINE DELPHI2UP}    {$ENDIF}
{$IFDEF DELPHI2UP}    {$DEFINE DELPHI1UP}    {$ENDIF}
{$IFDEF DELPHI1UP}    {$DEFINE DELPHI}       {$ENDIF}

{$IFDEF BCB4}         {$DEFINE BCB4UP}       {$ENDIF}
{$IFDEF BCB3}         {$DEFINE BCB3UP}       {$ENDIF}
{$IFDEF BCB1}         {$DEFINE BCB1UP}       {$ENDIF}

{$IFDEF BCB4UP}       {$DEFINE BCB3UP}       {$ENDIF}
{$IFDEF BCB3UP}       {$DEFINE BCB1UP}       {$ENDIF}
{$IFDEF BCB1UP}       {$DEFINE BCB}          {$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// Require one of the 'known' compiler versions at this time
{$IFNDEF DELPHI}{$IFNDEF BCB}
  This unit requires Delphi version 1.x-2007.x, Kylix 1 - 3, BCB version 1, 3 or 4
{$ENDIF}{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// Now set the integer-size for this compiler
{$IFDEF DELPHI}
  {$IFDEF DELPHI2UP}
    {$DEFINE SIZE_32}
  {$ELSE}
    {$DEFINE SIZE_16}
  {$ENDIF}
{$ELSE}
  // BCB
  {$DEFINE SIZE_32}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// Set language feature defines
{$IFDEF DELPHI}
  {$IFDEF DELPHI3UP}
    {$DEFINE HAS_INTERFACE}     // Compiler has support for interfaces
  {$ENDIF}
  {$IFDEF DELPHI4UP}
    {$DEFINE HAS_LONGWORD}      // Compiler has the data type LONGWORD
    {$DEFINE HAS_DEFAULTPARAMS} // Compiler supports default parameters
    {$DEFINE HAS_OVERLOAD}      // Compiler has the OVERLOAD directive
    {$DEFINE HAS_INT64}         // Compiler has the data type INT64
    {$DEFINE HAS_DYNAMICARRAYS} // Compiler support dynamic arrays
    {$DEFINE HAS_NEWVCL}        // VCL has new properties like Constraints etc.
    {$DEFINE HAS_IMPLEMENTS}    // Compiler has the IMPLEMENTS keyword
  {$ENDIF}
{$ELSE}
  {$IFDEF BCB3UP}
    {$DEFINE HAS_INTERFACE}     // Compiler has support for interfaces
  {$ENDIF}
  {$IFDEF BCB4UP}
    {$DEFINE HAS_LONGWORD}      // Compiler has the data type LONGWORD
    {$DEFINE HAS_DEFAULTPARAMS} // Compiler supports default parameters
    {$DEFINE HAS_OVERLOAD}      // Compiler has the OVERLOAD directive
    {$DEFINE HAS_INT64}         // Compiler has the data type INT64
    {$DEFINE HAS_DYNAMICARRAYS} // Compiler support dynamic arrays
    {$DEFINE HAS_NEWVCL}        // VCL has new properties like Constraints etc.
    {$DEFINE HAS_IMPLEMENTS}    // Compiler has the IMPLEMENTS keyword
  {$ENDIF}
{$ENDIF}