program Demo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,

  QQWry in '..\Source\QQWry.pas';

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
  try
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  if DebugHook > 0 then
    Readln;
end.
