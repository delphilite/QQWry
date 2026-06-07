{ *********************************************************************** }
{                                                                         }
{   QQWry 单元测试项目单元                                                }
{                                                                         }
{   设计：Lsuper 2026.04.01                                               }
{   备注：                                                                }
{   审核：                                                                }
{                                                                         }
{   Copyright (c) 1998-2026 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

program UnitTest;

{$DEFINE CONSOLE_TESTRUNNER}

{$IFDEF CONSOLE_TESTRUNNER}
  {$APPTYPE CONSOLE}
{$ENDIF}

{$IF CompilerVersion >= 21.0}
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  SysUtils,

  TestFramework,
  TextTestRunner,
  GuiTestRunner,

  QQWryTests in 'QQWryTests.pas';

begin
  if FindCmdLineSwitch('c') or FindCmdLineSwitch('console') then
  begin
    // NOTE:
    // UnitTest is built as a console application (see UnitTest.dproj <AppType>Console</AppType>).
    // When running from PowerShell/Cmd with output redirection, calling AttachConsole/AllocConsole
    // can detach stdout/stderr from the parent process and make console output disappear.
    // Keep the existing console/std handles so TextTestRunner output is visible and redirectable.
    with TextTestRunner.RunRegisteredTests do
      Free;
    if DebugHook <> 0 then
      Readln;
  end
  else begin
    ReportMemoryLeaksOnShutdown := True;
    GuiTestRunner.RunRegisteredTests;
  end;
end.
