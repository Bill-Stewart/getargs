getargs/getargsg - Copyright (C) 2020 by Bill Stewart (bstewart at iname.com)

This is free software and comes with ABSOLUTELY NO WARRANTY.

SYNOPSIS

Windows utility program that outputs the exact command line passed to the
executable, without any parsing or interpretation. This can be useful for
troubleshooting and/or debugging commands passed to a shell or application.

SYNTAX

getargs command line

or

getargsg command line

The commands are identical, except that getargsg provides its output using a
GUI dialog box rather than the console.

NOTES

* Leading whitespace (spaces and/or tabs) on the command line are ignored.

EXAMPLES

1.  Show the exact command line that PowerShell will run:

       PS C:\> getargs cmd /c rd /s 'c:\sample directory\temp'
       cmd /c rd /s "c:\sample directory\temp"

  Note that ' is a valid quote character for PowerShell, so it sensibly
  translates the ' to " characters.

2.  Troubleshoot a python command from PowerShell:

       PS C:\> getargs python -c 'a; myfunc("arg")'
       python -c "a; myfunc("arg")"

  This command does not work correctly from PowerShell, because PowerShell
  changes the outer ' characters to " characters. Since you can quote "
  characters in python using \", one workaround is to double the innner "
  characters:

       PS C:\> getargs python -c "a; myfunc(\""arg\"")"
       python -c "a; myfunc(\"arg\")"

  Another workaround is to use ` to escape the inner " characters:

       PS C:\> getargs python -c "a; myfunc(\`"arg\`")"
       python -c "a; myfunc(\"arg\")"

  Either workaround produces the desired command line.

VERSION HISTORY

1.0 (2020-07-17)

  * Initial version.
