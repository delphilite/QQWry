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

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils, QQWry;

procedure Test;
var
  QQWryFile: TQQWry;
  S: string;
begin
  QQWryFile := TQQWryFile.Create;
  with QQWryFile do
  try
    Writeln(Format('作者：%s，时间：%s，数目：%d', [Author, DateTime, RecCount]));
    if Find('8.8.8.8', S) then
      Writeln('find 8.8.8.8: ' + S)
    else Writeln('find 8.8.8.8 error!');
  finally
    Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    Test;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
