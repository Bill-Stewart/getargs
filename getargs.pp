{ getargs - output exact content of command line

  Copyright (C) 2020-2023 by Bill Stewart (bstewart at iname.com)

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

{$IFDEF GUI}
{$APPTYPE GUI}
{$R getargsg.res}
{$ELSE}
{$APPTYPE CONSOLE}
{$R getargs.res}
{$ENDIF}

program getargs;

// wargcv unit: https://github.com/Bill-Stewart/wargcv/
uses
  windows,
  wargcv,
  wwrite;

const
  APP_NAME = 'getargsg';

var
  CommandTail: PChar;

begin
  CommandTail := GetCommandTail(GetCommandLineW(), 1);
{$IFDEF GUI}
  MessageBoxW(0, CommandTail, APP_NAME, 0);
{$ELSE}
  WWriteLn(CommandTail);
{$ENDIF}
end.
