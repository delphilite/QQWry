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

{$mode delphi}

uses
  SysUtils, QQWry;

procedure Test(const AFile: string; const AIP: string);
var
  QQWryFile: TQQWry;
  S: string;
begin
  QQWryFile := TQQWryFile.Create(AFile);
  with QQWryFile do
  try
    Writeln(Format('FileName: %s', [AFile]));
    Writeln('');
    Writeln(Format('Author: %s', [Author]));
    Writeln(Format('DateTime: %s', [DateTime]));
    Writeln(Format('RecCount: %d', [RecCount]));
    Writeln('');
    if Find(AIP, S) then
      Writeln(Format('Find %s values: %s', [AIP, S]))
    else Writeln(Format('Find %s Error!', [AIP]));
  finally
    Free;
  end;
end;

begin
  try
    Test('..\QQWry.dat', '8.8.8.8');
    Writeln('');
    Test('..\QQWry_zh-hant.dat', '8.8.8.8');
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
