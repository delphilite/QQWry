{ ***************************************************** }
{                                                       }
{  Pascal language binding for QQWry Database           }
{                                                       }
{  Unit Name: Demo                                      }
{     Author: Lsuper 2024.08.01                         }
{    Purpose: Demo                                      }
{    License: Mozilla Public License 2.0                }
{                                                       }
{  Copyright (c) 1998-2024 Super Studio                 }
{                                                       }
{ ***************************************************** }

program Demo;

{$IF CompilerVersion >= 21.0}
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
