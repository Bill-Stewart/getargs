{ Copyright (C) 2023-2026 by Bill Stewart (bstewart at iname.com)

  This program is free software: you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free Software
  Foundation, either version 3 of the License, or (at your option) any later
  version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see https://www.gnu.org/licenses/.

}

{$MODE OBJFPC}
{$MODESWITCH UNICODESTRINGS}

unit wwrite;

interface

// Windows/Unicode output to console (or file if redirected), without newline
procedure WWrite(const S: string);

// Windows/Unicode output to console (or file if redirected), with newline
procedure WWriteLn(const S: string);

implementation

uses
  windows;

procedure WWrite(const S: string);
var
  StdOutput: HANDLE;
  BufLen, BytesWritten: DWORD;
begin
  StdOutput := GetStdHandle(STD_OUTPUT_HANDLE);
  if GetFileType(StdOutput) = FILE_TYPE_CHAR then
  begin
    WriteConsoleW(StdOutput,  // HANDLE  hConsoleOutput
      PChar(S),               // VOID    *lpBuffer
      Length(S),              // DWORD   nNumberOfCharsToWrite
      nil,                    // LPDWORD lpNumberOfCharsWritten
      nil);                   // LPVOID  lpReserved
  end
  else
  begin
    BufLen := Length(S) * SizeOf(Char);
    WriteFile(StdOutput,  // HANDLE       hFile
      S[1],               // LPCVOID      lpBuffer
      BufLen,             // DWORD        nNumberOfBytesToWrite
      BytesWritten,       // LPDWORD      lpNumberOfBytesWritten
      nil);               // LPOVERLAPPED lpOverlapped
  end;
end;

procedure WWriteLn(const S: string);
begin
  WWrite(S + sLineBreak);
end;

begin
end.
