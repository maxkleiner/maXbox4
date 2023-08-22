{ **************************************************************************** }
{                                                                              }
{    Pascal PreProcessor                                                       }
{    Copyright (c) 2001 Barry Kelly.                                           }
{    barry_j_kelly@hotmail.com                                                 }
{                                                                              }
{    The contents of this file are subject to the Mozilla Public License       }
{    Version 1.1 (the "License"); you may not use this file except in          }
{    compliance with the License. You may obtain a copy of the License at      }
{    http://www.mozilla.org/MPL/                                               }
{                                                                              }
{    Software distributed under the License is distributed on an "AS IS"       }
{    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the   }
{    License for the specific language governing rights and limitations        }
{    under the License.                                                        }
{                                                                              }
{    The Original Code is ppp.dpr                                              }
{                                                                              }
{    The Initial Developer of the Original Code is Barry Kelly.                }
{    Portions created by Barry Kelly are Copyright (C) 2001 Barry Kelly.       }
{    Portions created by Alexey Barkovoy are Copyright (C) Alexey Barkovoy.    }
{     All Rights Reserved.                                                     }
{                                                                              }
{    Alternatively, the contents of this file may be used under the terms      }
{    of the Lesser GNU Public License (the  "LGPL License"), in which case     }
{    the provisions of LGPL License are applicable instead of those            }
{    above.  If you wish to allow use of your version of this file only        }
{    under the terms of the LPGL License and not to allow others to use        }
{    your version of this file under the MPL, indicate your decision by        }
{    deleting  the provisions above and replace  them with the notice and      }
{    other provisions required by the LGPL License.  If you do not delete      }
{    the provisions above, a recipient may use your version of this file       }
{    under either the MPL or the LPGL License.                                 }
{                                                                              }
{ **************************************************************************** }
{ $Id: ppp.dpr,v 1.7 2001/09/07 05:32:34 Administrator Exp $ }

{$APPTYPE CONSOLE}
program ppp;

uses
  Windows,
  SysUtils,
  Classes,
  IniFiles,
  JclStrings,
  JclStrHashMap,
  PppState in 'PppState.pas',
  PppParser in 'PppParser.pas',
  FindFileIter in 'FindFileIter.pas',
  PppLexer in 'PppLexer.pas',
  PCharUtils in 'PCharUtils.pas';

const
  ProcessedExtension = '.pi';
  RenameExtension = '.bak';

procedure Syntax;
begin
  Writeln(
    'Pascal PreProcessor v0.9'#10,
    'Derived code is copyright (C) 2001-2002 by Alexey Barkovoy'#10,
    'Original code is copyright (C) 2001 by Barry Kelly(barry_j_kelly@hotmail.com)'#10,
    #10,
    'Syntax:'#10,
    '  ppp.exe [-options] <input files>...'#10,
    #10,
    'Options:'#10,
    ' h, ?  - This help'#10,
    ' c     - Process conditional directives'#10,
    ' sxxx  - Simulates XXX compiler (see ppp.ini file)'#10,
    ' i     - Process includes'#10,
    ' C     - Strip comments'#10,
    ' t     - Assign old timestamps to new files'#10,
    ' r     - Rename old files to ',
        RenameExtension, ' and write new files to original filename'#10,
    ' u     - Count statistics on define usage '#10,
    '         (in this case only i,c,p,b,xp,xb options are meaningfull)'#10,
    ' pxxx  - Add xxx to include path'#10,
    ' dxxx  - Define xxx as a preprocessor conditional symbol'#10,
    ' gxxx  - Passthrough any conditional defines using xxx'#10,
    ' bxxx  - Process includes with filanemes xxx for defines,'#10,
    '         but bypass include text and leave include compiler directive'#10,
    ' yxxx  - Strip xxx compiler directives'#10,
    ' xd,xg,xb - Invert meanings of d, g, b options so they mean: all but defined.'#10,
    #10,
    'Options "-i -c -C" are assumed if nothing is selected.'#10,
    'Preprocessed files will be written to new files with extension ', ProcessedExtension, #10,
    'WARNING: If output files already exist, they will be deleted without warning.'#10,
    'If you have any suggestions or bug-reports, contact at:'#10,
    '  Alexey Barkovoy:   clootie@reactor.ru'#10
  );
  Halt(2);
end;

procedure Process(AState: TPppState; const AOld, ANew: string);
var
  parse: TPppParser;
  fsIn, fsOut: TStream;
  answer: string;
  i: Integer;

  CreationTime: TFileTime;
  LastAccessTime: TFileTime;
  LastWriteTime: TFileTime;
begin
  fsOut := nil;
  parse := nil;
  fsIn := nil;
  AState.PushState;
  try
    fsIn := TFileStream.Create(AOld, fmOpenRead);
    parse := TPppParser.Create(fsIn, AState);
    answer := parse.Parse;

    if (poCountUsage in AState.Options) then
    begin // Output Statistics
      WriteLn('=== Statistics for "' + AOld + '" ===');
      for i:= 0 to parse.Statistics.Count - 1 do
        WriteLn(parse.Statistics[i] + #9 + '= ' +
          IntToStr(Integer(parse.Statistics.Objects[i])));
    end else
    try // Output results to file
      fsOut := TFileStream.Create(ANew, fmCreate);
      fsOut.WriteBuffer(Pointer(answer)^, Length(answer));
    finally
      if (poTimestamps in AState.Options) then 
      begin
        GetFileTime((fsIn as TFileStream).Handle, @CreationTime, @LastAccessTime, @LastWriteTime);
        SetFileTime((fsOut as TFileStream).Handle, @CreationTime, @LastAccessTime, @LastWriteTime);
      end;

      fsOut.Free;
    end;
  finally
    AState.PopState;
    parse.Free;
    fsIn.Free;
  end;
end;

procedure Params(ACommandLine: PChar);
var
  pppState: TSimplePppState;
  processed: TStringHashMap; // avoid processing files twice

  function HandleOptions(cp: PChar): PChar;

    function CheckOpt(cp: PChar; AOpt: TPppOption): PChar;
    begin
      case cp^ of
        '+':
          pppState.Options := pppState.Options + [AOpt];
        '-':
          pppState.Options := pppState.Options - [AOpt];
      else
        pppState.Options := pppState.Options + [AOpt];
      end;
      if cp^ in ['+', '-'] then
        Result := cp + 1
      else
        Result := cp;
    end;

    function CheckCompiler(cp: PChar): PChar;
    var
      Compiler: String;
      Defines: TStringList;
      i: Integer;
    begin
      Result := ReadIdent(cp, Compiler);
      with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
      try
        Defines:= TStringList.Create;
        try
          StrToStrings(ReadString('Defines', Compiler, ''), ',', Defines);
          for i:= 0 to Defines.Count - 1 do
            pppState.Define(Defines[i]);
        finally
          Defines.Free;
        end;
      finally
        Free;
      end;
    end;

  var
    tmp: string;
  begin
    cp := SkipWhite(cp);

    while cp^ = '-' do
    begin
      Inc(cp);

      case cp^ of
        'h', 'H', '?':
          Syntax;

        'i', 'I':
          cp := CheckOpt(cp + 1, poProcessIncludes);

        'c':
          cp := CheckOpt(cp + 1, poProcessDefines);

        's', 'S':
          cp := CheckCompiler(cp + 1);

        'C':
          cp := CheckOpt(cp + 1, poStripComments);

        'x', 'X':
        begin
          Inc(cp);
          case cp^ of
            'd', 'D': // dxxx    Define xxx as a preprocessor conditional symbol
              cp := CheckOpt(cp + 1, poInvDefines);
            'g', 'G': // gxxx    Passthrough any conditional defines using xxx
              cp := CheckOpt(cp + 1, poInvPassthrough);
            'b', 'B': // bxxx    Process includes with filanemes xxx for defines
              cp := CheckOpt(cp + 1, poInvIncludes);
          end;
        end;

        'u', 'U':
          cp := CheckOpt(cp + 1, poCountUsage);

        't', 'T':
          cp := CheckOpt(cp + 1, poTimestamps);

        'r', 'R':
          cp := CheckOpt(cp + 1, poRename);

        'p', 'P':
        begin
          Inc(cp);
          cp := ReadStringDoubleQuotedMaybe(cp, tmp);
          pppState.SearchPath.Add(tmp);
        end;

        'd', 'D':
        begin
          Inc(cp);
          cp := ReadIdent(cp, tmp);
          pppState.Define(tmp);
        end;

        'g', 'G':
        begin
          Inc(cp);
          cp := ReadIdent(cp, tmp);
          pppState.PassThrough(tmp);
        end;

        'b', 'B':
        begin
          Inc(cp);
          cp := ReadStringDoubleQuotedMaybe(cp, tmp);
          pppState.BypassInclude(tmp);
        end;

        'y', 'Y':
        begin
          Inc(cp);
          cp := ReadStringDoubleQuotedMaybe(cp, tmp);
          pppState.SkipSomeDirectives(tmp);
        end;

      else
        Syntax;
      end;

      cp := SkipWhite(cp);
    end;
    Result := cp;
  end;

  function HandleFiles(cp: PChar): PChar;
  var
    tmp: string;
    iter: IFindFileIterator;
  begin
    while not (cp^ in ['-', #0]) do
    begin
      cp := SkipWhite(ReadStringDoubleQuotedMaybe(cp, tmp));
      if CreateFindFile(tmp, faAnyFile and not faDirectory, iter) then
        repeat
          try
            if not processed.Has(iter.Name) then
            begin
              processed.Add(iter.Name, tmp);
              tmp := ExtractFileDir(iter.Name);
              if pppState.SearchPath.IndexOf(tmp) = -1 then
                pppState.SearchPath.Add(tmp);
              if poRename in pppState.Options then
              begin
                tmp := ChangeFileExt(iter.Name, RenameExtension);
                if not RenameFile(iter.Name, tmp) then
                  raise Exception.CreateFmt('Couldn''t rename %s to %s',
                    [iter.Name, tmp]);
                Process(pppState, tmp, iter.Name);
              end
              else
                Process(pppState, iter.Name, ChangeFileExt(iter.Name, ProcessedExtension));
            end;
          except
            on e: Exception do
              Writeln('Error: ', iter.Name, ': ', e.Message);
          end;
        until not iter.Next
      else
        Writeln('Could not find ', tmp);
    end;
    Result := cp;
  end;

var
  cp: PChar;
begin
  cp := ACommandLine;

  processed := nil;
  pppState := TSimplePppState.Create;
  try
    processed := TStringHashMap.Create(CaseInsensitiveTraits, 257);
    repeat
      cp := HandleOptions(cp);
      if pppState.Options = [] then
      begin
        pppState.Options := [poProcessIncludes, poProcessDefines, poStripComments];
        Writeln('Hint: "-i -c -C" options assumed.');
        cp := HandleFiles(cp);
        pppState.Options := [];
      end
      else
        cp := HandleFiles(cp);
    until cp^ = #0;
  finally
    processed.Free;
    pppState.Free;
  end;
end;

var
  CommandLine: String;
  i: Integer;
begin
  try
    i := 1;
    if ParamCount = 0 then
      Syntax
    else
    begin
      while i <= ParamCount do
      begin
        CommandLine := CommandLine + ' ' + ParamStr(i);
        Inc(i);
      end;
      Params(PChar(CommandLine));
    end;
  except
    on e: Exception do
    begin
      Writeln(e.Message);
      Halt(1);
    end;
  end;
end.
