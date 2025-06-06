{ This file contains compiler distinctions and conditional defines for all
  source files in the KControls Development Suite. It has been created from
  several similar resources available. }

{$IFNDEF KCONTROLS_INC}
  {$DEFINE KCONTROLS_INC}

{ Default compiler directives for entire KControls Development Suite }

{$IFDEF FPC}
  {$MODE DELPHI}
  {$B-,H+,J+,Q-,R-,T-,X+}
{$ELSE}
  {$B-,H+,J+,Q-,R-,T-,X+}
{$ENDIF}

{ Specifies if native operating system theme support should be used (Themes.pas is needed) }

{$DEFINE USE_THEMES}

{ COMPILERx, DELPHIx and BCBx directives from VERx }

{$IFDEF VER290}
  {$DEFINE COMPILER21}
  {$IFDEF BCB}
    {$DEFINE BCBXE8}
  {$ELSE}
    {$DEFINE DELPHIXE8}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER280}
  {$DEFINE COMPILER20}
  {$IFDEF BCB}
    {$DEFINE BCBXE7}
  {$ELSE}
    {$DEFINE DELPHIXE7}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER270}
  {$DEFINE COMPILER19}
  {$IFDEF BCB}
    {$DEFINE BCBXE6}
  {$ELSE}
    {$DEFINE DELPHIXE6}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER260}
  {$DEFINE COMPILER18}
  {$IFDEF BCB}
    {$DEFINE BCBXE5}
  {$ELSE}
    {$DEFINE DELPHIXE5}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER250}
  {$DEFINE COMPILER17}
  {$IFDEF BCB}
    {$DEFINE BCBXE4}
  {$ELSE}
    {$DEFINE DELPHIXE4}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER240}
  {$DEFINE COMPILER16}
  {$IFDEF BCB}
    {$DEFINE BCBXE3}
  {$ELSE}
    {$DEFINE DELPHIXE3}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER230}
  {$DEFINE COMPILER15}
  {$IFDEF BCB}
    {$DEFINE BCBXE2}
  {$ELSE}
    {$DEFINE DELPHIXE2}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER220}
  {$DEFINE COMPILER14}
  {$IFDEF BCB}
    {$DEFINE BCBXE}
  {$ELSE}
    {$DEFINE DELPHIXE}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER210}
  {$DEFINE COMPILER13}
  {$IFDEF BCB}
    {$DEFINE BCB2010}
  {$ELSE}
    {$DEFINE DELPHI2010}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER200}
  {$DEFINE COMPILER12}
  {$IFDEF BCB}
    {$DEFINE BCB2009}
  {$ELSE}
    {$DEFINE DELPHI2009}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER180}
  {$IFDEF VER185}
    {$DEFINE COMPILER11}
    {$IFDEF BCB}
      {$DEFINE BCB2007}
    {$ELSE}
      {$DEFINE DELPHI2007}
    {$ENDIF}
  {$ELSE}
    {$DEFINE COMPILER10}
    {$IFDEF BCB}
      {$DEFINE BCB2006}
    {$ELSE}
      {$DEFINE DELPHI2006}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER170}
  {$DEFINE COMPILER9}
  {$DEFINE DELPHI2005}
{$ENDIF}

{$IFDEF VER160}
  {$DEFINE COMPILER8}
  {$DEFINE DELPHI8}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE COMPILER7}
  {$DEFINE DELPHI7}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE COMPILER6}
  {$IFDEF BCB}
    {$DEFINE BCB6}
  {$ELSE}
    {$DEFINE DELPHI6}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE COMPILER5}
  {$IFDEF BCB}
    {$DEFINE BCB5}
  {$ELSE}
    {$DEFINE DELPHI5}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER125}
  {$DEFINE COMPILER4}
  {$DEFINE BCB}
  {$DEFINE BCB4}
{$ENDIF}

{$IFDEF VER120}
  {$DEFINE COMPILER4}
  {$DEFINE DELPHI4}
{$ENDIF}

{$IFDEF VER110}
  {$DEFINE COMPILER3}
  {$DEFINE BCB}
  {$DEFINE BCB3}
{$ENDIF}

{$IFDEF VER100}
  {$DEFINE COMPILER3}
  {$DEFINE DELPHI3}
{$ENDIF}

{$IFDEF VER93}
  {$DEFINE COMPILER2}
  {$DEFINE BCB}
  {$DEFINE BCB1}
{$ENDIF}

{$IFDEF VER90}
  {$DEFINE COMPILER2}
  {$DEFINE DELPHI2}
{$ENDIF}

{ What is used: DELPHI or BCB ? (BCB is defined by C++Builder 5 and later) }

{$IFNDEF BCB}
  {$DEFINE DELPHI}
{$ENDIF}

{ COMPILERx_UP directives from COMPILERx }

{$IFDEF COMPILER21} {$DEFINE COMPILER21_UP} {$ENDIF}
{$IFDEF COMPILER20} {$DEFINE COMPILER20_UP} {$ENDIF}
{$IFDEF COMPILER19} {$DEFINE COMPILER19_UP} {$ENDIF}
{$IFDEF COMPILER18} {$DEFINE COMPILER18_UP} {$ENDIF}
{$IFDEF COMPILER17} {$DEFINE COMPILER17_UP} {$ENDIF}
{$IFDEF COMPILER16} {$DEFINE COMPILER16_UP} {$ENDIF}
{$IFDEF COMPILER15} {$DEFINE COMPILER15_UP} {$ENDIF}
{$IFDEF COMPILER14} {$DEFINE COMPILER14_UP} {$ENDIF}
{$IFDEF COMPILER13} {$DEFINE COMPILER13_UP} {$ENDIF}
{$IFDEF COMPILER12} {$DEFINE COMPILER12_UP} {$ENDIF}
{$IFDEF COMPILER11} {$DEFINE COMPILER11_UP} {$ENDIF}
{$IFDEF COMPILER10} {$DEFINE COMPILER10_UP} {$ENDIF}
{$IFDEF COMPILER9}  {$DEFINE COMPILER9_UP}  {$ENDIF}
{$IFDEF COMPILER8}  {$DEFINE COMPILER8_UP}  {$ENDIF}
{$IFDEF COMPILER7}  {$DEFINE COMPILER7_UP}  {$ENDIF}
{$IFDEF COMPILER6}  {$DEFINE COMPILER6_UP}  {$ENDIF}
{$IFDEF COMPILER5}  {$DEFINE COMPILER5_UP}  {$ENDIF}
{$IFDEF COMPILER4}  {$DEFINE COMPILER4_UP}  {$ENDIF}
{$IFDEF COMPILER3}  {$DEFINE COMPILER3_UP}  {$ENDIF}
{$IFDEF COMPILER2}  {$DEFINE COMPILER2_UP}  {$ENDIF}

{$IFDEF COMPILER21_UP} {$DEFINE COMPILER20_UP} {$ENDIF}
{$IFDEF COMPILER20_UP} {$DEFINE COMPILER19_UP} {$ENDIF}
{$IFDEF COMPILER19_UP} {$DEFINE COMPILER18_UP} {$ENDIF}
{$IFDEF COMPILER18_UP} {$DEFINE COMPILER17_UP} {$ENDIF}
{$IFDEF COMPILER17_UP} {$DEFINE COMPILER16_UP} {$ENDIF}
{$IFDEF COMPILER16_UP} {$DEFINE COMPILER15_UP} {$ENDIF}
{$IFDEF COMPILER15_UP} {$DEFINE COMPILER14_UP} {$ENDIF}
{$IFDEF COMPILER14_UP} {$DEFINE COMPILER13_UP} {$ENDIF}
{$IFDEF COMPILER13_UP} {$DEFINE COMPILER12_UP} {$ENDIF}
{$IFDEF COMPILER12_UP} {$DEFINE COMPILER11_UP} {$ENDIF}
{$IFDEF COMPILER11_UP} {$DEFINE COMPILER10_UP} {$ENDIF}
{$IFDEF COMPILER10_UP} {$DEFINE COMPILER9_UP}  {$ENDIF}
{$IFDEF COMPILER9_UP}  {$DEFINE COMPILER8_UP}  {$ENDIF}
{$IFDEF COMPILER8_UP}  {$DEFINE COMPILER7_UP}  {$ENDIF}
{$IFDEF COMPILER7_UP}  {$DEFINE COMPILER6_UP}  {$ENDIF}
{$IFDEF COMPILER6_UP}  {$DEFINE COMPILER5_UP}  {$ENDIF}
{$IFDEF COMPILER5_UP}  {$DEFINE COMPILER4_UP}  {$ENDIF}
{$IFDEF COMPILER4_UP}  {$DEFINE COMPILER3_UP}  {$ENDIF}
{$IFDEF COMPILER3_UP}  {$DEFINE COMPILER2_UP}  {$ENDIF}
{$IFDEF COMPILER2_UP}  {$DEFINE COMPILER1_UP}  {$ENDIF}

{ Unicode compiler directive for string type }
// Delphi 2009+ uses UTF16, Lazarus 0.9.25+ uses UTF8
{$IF DEFINED(COMPILER12_UP) OR DEFINED(FPC)}
  {$DEFINE STRING_IS_UNICODE}
{$IFEND}

{ Prefers usage of TCanvas methods instead of WinAPI mainly to avoid Lazarus bugs. }
{$DEFINE USE_CANVAS_METHODS}

{ Register new image formats into TPicture. }
{.$DEFINE REGISTER_PICTURE_FORMATS}

{ Allows to use WinAPI functions in Lazarus and Delphi }
{$IF NOT DEFINED(FPC) OR DEFINED(WINDOWS)}
  {$DEFINE USE_WINAPI}
{$IFEND}

{ Allows to use WideWinProcs unit }
{$IFDEF USE_WINAPI}
  {.$DEFINE USE_WIDEWINPROCS}
{$ENDIF}

{ Support Alphacontrols integration in Delphi and Lazarus,
  AlphaControlsLaz package needed for Lazarus. }
{.$DEFINE SUPPORT_ALPHASKINS}

{ Allow Alphacontrols integration to be used in Delphi }
{$IFnDEF FPC}
  {.$DEFINE USE_ALPHASKINS}
{$ENDIF}

{$IF DEFINED(SUPPORT_ALPHASKINS) OR DEFINED(USE_ALPHASKINS)}
  {$DEFINE SUPPORT_OR_USE_ALPHASKINS}
{$IFEND}

{$DEFINE LAZARUS_HAS_DC_MAPPING}

{$IF DEFINED(USE_WINAPI) OR DEFINED(LAZARUS_HAS_DC_MAPPING)}
  {$DEFINE USE_DC_MAPPING}
{$IFEND}

{ Conditional defines for unit KGrids: }
// we want TKGridObjectCell to be a descendant of TKGridAttrTextCell
{$DEFINE TKGRIDOBJECTCELL_IS_TKGRIDATTRTEXTCELL}

// we want TKGridObjectCell to be a descendant of TKGridTextCell
{.$DEFINE TKGRIDOBJECTCELL_IS_TKGRIDTEXTCELL}

// use JCLUnicode (only for TKGridAxisItem.Assign(Source: TWideStrings);)
{.$DEFINE TKGRID_USE_JCL}

{ Conditional defines for unit KDBGrids: }
// we want to use TKDBGrid
{$DEFINE TKDBGRID_USE}

// we want TKDBGridCell to be a descendant of TKGridAttrTextCell
{.$DEFINE TKDBGRIDCELL_IS_TKGRIDATTRTEXTCELL}

// PngImage can be used
{$IF DEFINED(FPC) OR DEFINED(COMPILER12_UP)}
  {$DEFINE USE_PNG_SUPPORT}
{$IFEND}

{ Disable kerning pairs. This is done by very simple manner - character by character measuring and output.
  Because different OSes output kerning pairs differently and there is no dedicated kerning pair API in Lazarus.
  My approach is slower but safe. Uncomment only when the memo rendering is slow.
  With kerning enabled you may get unpredictable behavior when selecting text on some fonts etc. }
{$DEFINE KMEMO_DISABLE_KERNING}

{$ENDIF ~KCONTROLS_INC}


