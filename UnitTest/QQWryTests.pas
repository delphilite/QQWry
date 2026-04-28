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
    procedure TestIp114ContainsDns;
    procedure TestIp162ContainsPekingUniversity;
    procedure TestIp166ContainsTsinghuaUniversity;
    procedure TestIp888ContainsGoogle;
  end;

  TQQWryUtilsTest = class(TTestCase)
  published
    procedure TestGetIpAddress;
  end;

  TQQWryFileTest = class(TQQWryBaseTest)
  protected
    procedure SetUp; override;
  end;

  TQQWryMemoryFileTest = class(TQQWryBaseTest)
  protected
    procedure SetUp; override;
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

{ TQQWryUtilsTest }

procedure TQQWryUtilsTest.TestGetIpAddress;
var
  Address: string;
begin
  CheckTrue(GetIpAddress('8.8.8.8', Address));
  CheckTrue(Pos('谷歌', Address) > 0);
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

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2018.12.25
//功能：Register any test cases with the test runner
//参数：
////////////////////////////////////////////////////////////////////////////////
initialization
  RegisterTest(TQQWryUtilsTest.Suite);
  RegisterTest(TQQWryFileTest.Suite);
  RegisterTest(TQQWryMemoryFileTest.Suite);

end.
