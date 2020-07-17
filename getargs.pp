{ getargs - output exact content of command line

  Copyright (C) 2020 by Bill Stewart (bstewart at iname.com)

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
{$H+}
{$IFDEF GUI}
  {$APPTYPE GUI}
  {$R getargsg.res}
{$ELSE}
  {$APPTYPE CONSOLE}
  {$R getargs.res}
{$ENDIF}

program
  getargs;

uses
  windows;

const
  APP_NAME = 'getargsg';

var
  CommandTail: pwidechar;

// The GetCommandLineW() Windows API function returns a pointer to the entire
// command line (this includes quotes around the executable name if present).
// This function returns a pointer to the first parameter on the command line
// after the executable name.
function GetCommandTail(): pwidechar;
  const
    WHITESPACE: set of char = [#9, #32];
  var
    pCL, pTail: pwidechar;
    InQuote: boolean;
    ArgNo, N: longint;
  begin
  pCL := GetCommandLineW();
  pTail := nil;
  if pCL^ <> #0 then
    begin
    InQuote := false;
    pTail := pCL;
    ArgNo := 0;
    for N := 0 To Length(pCL) do
      begin
      case pCL[N] of
        #0:
          break;
        '"':
          begin
          InQuote := not InQuote;
          if InQuote then
            begin
            if ArgNo = 1 then
              break;
            end;
          Inc(pTail);
          end;
        #9,#32:
          begin
          if (not InQuote) and (not (pCL[N - 1] in WHITESPACE)) then
            Inc(ArgNo);
          Inc(pTail);
          end;
        else
          begin
          if ArgNo = 1 then
            break
          else
            Inc(pTail);
          end;
        end; //case
      end;
    end;
  result := pTail;
  end;

begin
  CommandTail := GetCommandTail();
{$IFDEF GUI}
  MessageBoxW(0, CommandTail, APP_NAME, 0);
{$ELSE}
  WriteLn(unicodestring(CommandTail));
{$ENDIF}
end.
