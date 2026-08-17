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

uses
  windows;

procedure WWrite(const S: string; Handle: THandle = STD_OUTPUT_HANDLE);

procedure WWriteLn(const S: string; const Handle: THandle = STD_OUTPUT_HANDLE);

implementation

function TrimNewLine(S: string): string;
var
  I, J: Integer;
begin
  I := Length(S);
  if I > 0 then
  begin
    J := I;
    while (J > 0) and ((S[J] = #13) or (S[J] = #10)) do
      Dec(J);
    if J <> I Then
      SetLength(S, J);
  end;
  result := S;
end;

function UTF16ToUTF8String(const S: string): UTF8String;
var
  BufSize: DWORD;
  pBuffer: PUTF8Char;
begin
  result := '';
  BufSize := WideCharToMultiByte(CP_UTF8,  // UINT   CodePage
    0,                                     // DWORD  dwFlags
    PChar(S),                              // LPCWCH lpWideCharStr
    -1,                                    // int    cchWideChar
    nil,                                   // LPSTR  lpMultiByteStr
    0,                                     // int    cbMultiByte
    nil,                                   // LPCCH  lpDefaultChar
    nil);                                  // LPBOOL lpUsedDefaultChar
  if BufSize = 0 then
    exit;
  GetMem(pBuffer, BufSize);
  if WideCharToMultiByte(CP_UTF8,  // UINT   CodePage
    0,                             // DWORD  dwFlags
    PChar(S),                      // LPCWCH lpWideCharStr
    -1,                            // int    cchWideChar
    pBuffer,                       // LPSTR  lpMultiByteStr
    BufSize,                       // int    cbMultiByte
    nil,                           // LPCCH  lpDefaultChar
    nil) > 0 then                  // LPBOOL lpUsedDefaultChar
  begin
    result := UTF8String(pBuffer);
  end;
  FreeMem(pBuffer);
end;

procedure WWrite(const S: string; Handle: THandle = STD_OUTPUT_HANDLE);
var
  UTF8Str: UTF8String;
  BytesWritten: DWORD;
begin
  case Handle of
    STD_OUTPUT_HANDLE, STD_ERROR_HANDLE:
      Handle := GetStdHandle(Handle);
  end;
  if GetFileType(Handle) = FILE_TYPE_CHAR then
  begin
    // No UTF8 conversion needed for writing to FILE_TYPE_CHAR handle
    WriteConsoleW(Handle,  // HANDLE  hConsoleOutput
      PChar(S),            // VOID    *lpBuffer
      Length(S),           // DWORD   nNumberOfCharsToWrite
      nil,                 // LPDWORD lpNumberOfCharsWritten
      nil);                // LPVOID  lpReserved
  end
  else
  begin
    // Convert to UTF8 without trailing newlines for writing to handle other
    // than FILE_TYPE_CHAR
    UTF8Str := UTF16ToUTF8String(TrimNewLine(S));
    WriteFile(Handle,   // HANDLE       hFile
      UTF8Str[1],       // LPCVOID      lpBuffer
      Length(UTF8Str),  // DWORD        nNumberOfBytesToWrite
      BytesWritten,     // LPDWORD      lpNumberOfBytesWritten
      nil);             // LPOVERLAPPED lpOverlapped
  end;
end;

procedure WWriteLn(const S: string; const Handle: THandle = STD_OUTPUT_HANDLE);
begin
  WWrite(S + sLineBreak, Handle);
end;

begin
end.
