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

unit QQWryTests;

interface

uses
  System.SysUtils, TestFramework, QQWry;

type
  TQQWryBaseTest = class(TTestCase)
  private
    FQQWry: TQQWry;
  private
    function  ResolveQQWryDatPath: string;
    procedure AssertIpAddressContains(const AIP, AExpectedSubstring: string);
  protected
    procedure TearDown; override;
  published
    procedure TestAuthorNotEmpty;
    procedure TestDateTimeNotEmpty;
    procedure TestFindInvalidIp;
    procedure TestFindResultProperties;
    procedure TestIp114ContainsDns;
    procedure TestIp162ContainsPekingUniversity;
    procedure TestIp166ContainsTsinghuaUniversity;
    procedure TestIp888ContainsGoogle;
    procedure TestRecCountGreaterThanZero;
    procedure TestSeekFirstRecord;
    procedure TestSeekLastRecord;
    procedure TestSeekOutOfRange;
    procedure TestSeekResultProperties;
  end;

  TQQWryUtilsTest = class(TTestCase)
  published
    procedure TestGetIpAddress;
    procedure TestGetIpAddressInvalidIp;
  end;

  TQQWryFileTest = class(TQQWryBaseTest)
  protected
    procedure SetUp; override;
  end;

  TQQWryMemoryFileTest = class(TQQWryBaseTest)
  protected
    procedure SetUp; override;
  end;

  TQQWryErrorTest = class(TTestCase)
  published
    procedure TestCreateWithEmptyStream;
    procedure TestCreateWithNilStream;
  end;

implementation

uses
  System.Classes;

{ TQQWryBaseTest }

procedure TQQWryBaseTest.AssertIpAddressContains(const AIP, AExpectedSubstring: string);
var
  Addr: string;
begin
  CheckTrue(FQQWry.Find(AIP, Addr), 'Find failed for ' + AIP);
  CheckTrue(Pos(AExpectedSubstring, Addr) > 0,
    Format('Expected "%s" in address for %s, got: %s', [AExpectedSubstring, AIP, Addr]));
end;

function TQQWryBaseTest.ResolveQQWryDatPath: string;
var
  D: string;
begin
  D := ExtractFileDir(GetModuleName(0));
  Result := Format('%s\QQWry.dat', [D]);
  if not FileExists(Result) then
    Result := Format('%s\..\QQWry.dat', [D]);
end;

procedure TQQWryBaseTest.TearDown;
begin
  FreeAndNil(FQQWry);
  inherited;
end;

procedure TQQWryBaseTest.TestAuthorNotEmpty;
begin
  CheckNotEquals('', FQQWry.Author, 'Author should not be empty');
end;

procedure TQQWryBaseTest.TestDateTimeNotEmpty;
begin
  CheckNotEquals('', FQQWry.DateTime, 'DateTime should not be empty');
end;

procedure TQQWryBaseTest.TestFindInvalidIp;
var
  Addr: string;
begin
  CheckFalse(FQQWry.Find('999.999.999.999', Addr), 'Find should fail for invalid IP');
  CheckFalse(FQQWry.Find('abc.def.ghi.jkl', Addr), 'Find should fail for non-numeric IP');
  CheckFalse(FQQWry.Find('1.2.3', Addr), 'Find should fail for incomplete IP');
  CheckFalse(FQQWry.Find('', Addr), 'Find should fail for empty IP');
end;

procedure TQQWryBaseTest.TestFindResultProperties;
var
  Addr: string;
begin
  CheckTrue(FQQWry.Find('8.8.8.8', Addr), 'Find failed for 8.8.8.8');
  CheckNotEquals('', FQQWry.Country, 'Country should not be empty after Find');
  CheckNotEquals('', FQQWry.StartIP, 'StartIP should not be empty after Find');
  CheckNotEquals('', FQQWry.EndIP, 'EndIP should not be empty after Find');
end;

procedure TQQWryBaseTest.TestIp114ContainsDns;
begin
  AssertIpAddressContains('114.114.114.114', 'DNS');
end;

procedure TQQWryBaseTest.TestIp162ContainsPekingUniversity;
begin
  AssertIpAddressContains('162.105.1.1', '北京大学');
end;

procedure TQQWryBaseTest.TestIp166ContainsTsinghuaUniversity;
begin
  AssertIpAddressContains('166.111.177.77', '清华大学');
end;

procedure TQQWryBaseTest.TestIp888ContainsGoogle;
begin
  AssertIpAddressContains('8.8.8.8', '谷歌');
end;

procedure TQQWryBaseTest.TestRecCountGreaterThanZero;
begin
  CheckTrue(FQQWry.RecCount > 0, 'RecCount should be greater than zero');
end;

procedure TQQWryBaseTest.TestSeekFirstRecord;
begin
  CheckTrue(FQQWry.Seek(0), 'Seek to first record should succeed');
  CheckNotEquals('', FQQWry.StartIP, 'StartIP should not be empty after Seek');
  CheckNotEquals('', FQQWry.EndIP, 'EndIP should not be empty after Seek');
end;

procedure TQQWryBaseTest.TestSeekLastRecord;
begin
  CheckTrue(FQQWry.Seek(FQQWry.RecCount - 1), 'Seek to last record should succeed');
  CheckNotEquals('', FQQWry.StartIP, 'StartIP should not be empty after Seek last');
  CheckNotEquals('', FQQWry.EndIP, 'EndIP should not be empty after Seek last');
end;

procedure TQQWryBaseTest.TestSeekOutOfRange;
begin
  CheckFalse(FQQWry.Seek(FQQWry.RecCount), 'Seek beyond last record should fail');
  CheckFalse(FQQWry.Seek(Cardinal(-1)), 'Seek with invalid index should fail');
end;

procedure TQQWryBaseTest.TestSeekResultProperties;
begin
  CheckTrue(FQQWry.Seek(0), 'Seek should succeed');
  CheckNotEquals('', FQQWry.Country, 'Country should not be empty after Seek');
  CheckNotEquals('', FQQWry.StartIP, 'StartIP should not be empty after Seek');
  CheckNotEquals('', FQQWry.EndIP, 'EndIP should not be empty after Seek');
end;

{ TQQWryUtilsTest }

procedure TQQWryUtilsTest.TestGetIpAddress;
var
  Address: string;
begin
  CheckTrue(GetIpAddress('8.8.8.8', Address));
  CheckTrue(Pos('谷歌', Address) > 0);
end;

procedure TQQWryUtilsTest.TestGetIpAddressInvalidIp;
var
  Address: string;
begin
  CheckFalse(GetIpAddress('999.999.999.999', Address), 'GetIpAddress should fail for invalid IP');
  CheckFalse(GetIpAddress('', Address), 'GetIpAddress should fail for empty IP');
end;

{ TQQWryFileTest }

procedure TQQWryFileTest.SetUp;
begin
  inherited;
  FQQWry := TQQWryFile.Create(ResolveQQWryDatPath);
end;

{ TQQWryMemoryFileTest }

procedure TQQWryMemoryFileTest.SetUp;
begin
  inherited;
  FQQWry := TQQWryMemoryFile.Create(ResolveQQWryDatPath);
end;

{ TQQWryErrorTest }

procedure TQQWryErrorTest.TestCreateWithEmptyStream;
var
  S: TMemoryStream;
begin
  S := TMemoryStream.Create;
  try
    CheckException(
      procedure begin TQQWry.Create(S); end,
      EQQWry,
      'Creating TQQWry with empty stream should raise EQQWry');
  finally
    S.Free;
  end;
end;

procedure TQQWryErrorTest.TestCreateWithNilStream;
begin
  CheckException(
    procedure begin TQQWry.Create(nil); end,
    EAssertionFailed,
    'Creating TQQWry with nil stream should raise assertion error');
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2018.12.25
//功能：Register any test cases with the test runner
//参数：
////////////////////////////////////////////////////////////////////////////////
initialization
  RegisterTest(TQQWryUtilsTest.Suite);
  RegisterTest(TQQWryFileTest.Suite);
  RegisterTest(TQQWryMemoryFileTest.Suite);
  RegisterTest(TQQWryErrorTest.Suite);

end.
