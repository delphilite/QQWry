{ *********************************************************************** }
{                                                                         }
{   QQWry for Delphi 2007-10.3, ansi/unicode, vcl/fmx, win/osx/linux      }
{                                                                         }
{   重构: Lsuper 2015.12.30                                               }
{   备注:                                                                 }
{   审核:                                                                 }
{   参考: http://topic.csdn.net/t/20041219/02/3657311.html                }
{                                                                         }
{ *********************************************************************** }

unit QQWry;

interface

uses
  SysUtils, Classes;

type
  EQQWry = class(Exception);

  TQQWry = class(TObject)
  private
    FStream: TStream;
{$IFDEF UNICODE}
    FEncoding: TEncoding;
{$ENDIF}
    FRecCount: LongWord;
    FFirstStartIp,
    FLastStartIp: LongWord;

    FAuthor,
    FDateTime: string;

    FStartIP,
    FEndIP: LongWord;
    FCountry: string;
    FLocal: string;

    FCountryFlag: Byte;
    FEndIpOff: LongWord;
  private
    function  GetRecCount: LongWord;

    function  GetAuthor: string;
    function  GetDateTime: string;

    function  GetStartIP: string;
    function  GetEndIP: string;
    function  GetCountry: string;
    function  GetLocal: string;
  private
    function  IpToInt(const AIp: string;
      out ARet: LongWord): Boolean;
    function  IntToIp(AIp: LongWord): string;

    function  Locate(AIp: LongWord): Boolean;
    procedure ReadRecord(ARecNo: LongWord);

    function  LoadHeader: Boolean;
    procedure LoadFileInfo;

    function  ReadDataStr(AOffset: LongWord): string;
    function  ReadFlagStr(AOffset: LongWord): string;

    procedure ReadCurInt3(out ARet: LongWord);

    procedure ReadStartIp(ARecNo: LongWord);
    procedure ReadEndIp;
    procedure ReadCountry;
  public
    constructor Create(const AStream: TStream);
    destructor Destroy; override;

    function  Find(const AIP: string;
      out AAddress: string): Boolean;
    function  Seek(ARecIndex: LongWord): Boolean;

    property  Author: string
      read GetAuthor;
    property  DateTime: string
      read GetDateTime;
    property  RecCount: LongWord
      read GetRecCount;

    property  StartIP: string
      read GetStartIP;
    property  EndIP: string
      read GetEndIP;
    property  Country: string
      read GetCountry;
    property  Local: string
      read GetLocal;
  end;

  TQQWryFile = class(TQQWry)
  private
    FStream: TStream;
    FFile: string;
  public
    constructor Create(const AFile: string = ''); reintroduce;
    destructor Destroy; override;
  end;

  TQQWryMemoryFile = class(TQQWry)
  private
    FStream: TMemoryStream;
  public
    constructor Create(const AFile: string = ''); reintroduce;
    destructor Destroy; override;
  end;

  TQQWryResFile = class(TQQWry)
  private
    FStream: TStream;
  public
    constructor Create(const AResName: string;
      AResType: PChar); reintroduce;
    destructor Destroy; override;
  end;

  function  GetIpAddress(const AIp: string;
    out AAddress: string): Boolean;

implementation

uses
  Math;

const
  defQQCodePage         = 936;
  defQQWryFile          = 'QQWry.dat';

  defDateTimePrex       = 'IP数据';

  defMarkPrex           = 'CZ88.NET';
  defIpFmt              = '%3d.%3d.%3d.%3d';

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2008.01.06
//功能: 查找
//参数:
//注意:
////////////////////////////////////////////////////////////////////////////////
function GetIpAddress(const AIp: string; out AAddress: string): Boolean;
begin
  with TQQWryFile.Create('') do
  try
    Result := Find(AIP, AAddress);
  finally
    Free;
  end;
end;

{ TQQWry }

constructor TQQWry.Create(const AStream: TStream);
begin
  Assert(AStream <> nil);
  FStream := AStream;
{$IFDEF UNICODE}
  FEncoding := TEncoding.GetEncoding(defQQCodePage);
{$ENDIF}
  if not LoadHeader then raise EQQWry.Create('LoadHeader Error');
end;

destructor TQQWry.Destroy;
begin
{$IFDEF UNICODE}
  FreeAndNil(FEncoding);
{$ENDIF}
  inherited;
end;

function TQQWry.Find(const AIP: string; out AAddress: string): Boolean;
var
  nIp: LongWord;
begin
  Result := IpToInt(AIp, nIp) and Locate(nIp);
  if Result then
  begin
    AAddress := FCountry + FLocal;
    AAddress := StringReplace(AAddress, defMarkPrex, '', [rfReplaceAll, rfIgnoreCase]);
    AAddress := Trim(AAddress);
  end;
end;

function TQQWry.GetAuthor: string;
begin
  LoadFileInfo;
  Result := FAuthor; 
end;

function TQQWry.GetCountry: string;
begin
  Result := StringReplace(FCountry, defMarkPrex, '', [rfReplaceAll, rfIgnoreCase]);
end;

function TQQWry.GetDateTime: string;
begin
  LoadFileInfo;
  Result := FDateTime; 
end;

function TQQWry.GetEndIP: string;
begin
  Result := IntToIp(FEndIP);
end;

function TQQWry.GetLocal: string;
begin
  Result := StringReplace(FLocal, defMarkPrex, '', [rfReplaceAll, rfIgnoreCase]);
end;

function TQQWry.GetRecCount: LongWord;
begin
  Result := FRecCount;
end;

function TQQWry.GetStartIP: string;
begin
  Result := IntToIp(FStartIP);
end;

function TQQWry.IntToIp(AIp: LongWord): string;
var
  D: LongRec absolute AIp;
begin
  with D do Result := Format(defIpFmt, [Bytes[3], Bytes[2], Bytes[1], Bytes[0]]);
end;

function TQQWry.IpToInt(const AIp: string; out ARet: LongWord): Boolean;
var
  B: Integer;
  I, nError: Integer;
  cList: TStrings;
begin
{
  ARet := inet_addr(PChar(AIp));
  Result := ARet <> LongWord(INADDR_NONE);
  if Result then ARet := ntohl(ARet);
}
  Result := False;
  ARet := 0;
  cList := TStringList.Create;
  with cList do
  try
    Delimiter := '.';
    DelimitedText := AIp;
    if Count <> 4 then
      Exit;
    for I := 0 to 3 do
    begin
      Val(cList[I], B, nError);
      if (nError <> 0) or not InRange(B, 0, 255) then
        Exit;
      Inc(ARet, B shl (24 - 8 * I));
    end;
    Result := True;
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2008.01.06
//功能: 读取文件信息
//参数:
//注意: 将被延后加载信息
////////////////////////////////////////////////////////////////////////////////
procedure TQQWry.LoadFileInfo;
var
  nIndex: Integer;
begin
  if (FAuthor <> '') or (FDateTime <> '') then
    Exit;
  ReadRecord(FRecCount);
  nIndex := Pos(defDateTimePrex, FLocal);
  if nIndex <> 0 then
    FDateTime := Copy(FLocal, 1, nIndex - 1)
  else FDateTime := FLocal;
  FAuthor := FCountry;
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2008.01.06
//功能: 读取头记录信息
//参数:
//注意:
////////////////////////////////////////////////////////////////////////////////
function TQQWry.LoadHeader: Boolean;
begin
  with FStream do
  try
    FFirstStartIp := 0;
    FLastStartIp := 0;
    FRecCount := 0;
    
    FStartIP := 0;
    FEndIP := 0;
    FEndIpOff := 0;
    FCountryFlag := 0;
    FCountry := '';
    FLocal := '';

    Position := 0;
    ReadBuffer(FFirstStartIp, SizeOf(Integer));
    ReadBuffer(FLastStartIp, SizeOf(Integer));
    FRecCount := (FLastStartIp - FFirstStartIp) div 7;
    Result := FRecCount > 1;
  except
    Result := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2008.01.06
//功能: 二分法定位
//参数: 
//注意: 
////////////////////////////////////////////////////////////////////////////////
function TQQWry.Locate(AIp: LongWord): Boolean;
var
  nRecNo, nRangB, nRangE: LongWord;
begin
  nRangB := 0;
  nRangE := FRecCount;
  while (nRangB < nRangE - 1) do
  begin
    nRecNo := (nRangB + nRangE) div 2;
    ReadStartIp(nRecNo);
    if AIp = FStartIP then
    begin
      nRangB := nRecNo;
      Break;
    end;
    if AIp > FStartIP then
      nRangB := nRecNo
    else nRangE := nRecNo;
  end;
  ReadStartIp(nRangB);
  ReadEndIp;
  Result := InRange(AIp, FStartIP, FEndIP);
  if Result then ReadCountry;
end;

procedure TQQWry.ReadCountry;
begin
  case FCountryFlag of
    1..2:
      begin
        FCountry := ReadFlagStr(FEndIpOff + 4);
        if FCountryFlag = 1 then
          FLocal := ''
        else FLocal := ReadFlagStr(FEndIpOff + 8);
      end;
  else
    begin
      FCountry := ReadFlagStr(FEndIpOff + 4);
      FLocal := ReadFlagStr(FStream.Position);
    end;
  end;
end;

procedure TQQWry.ReadCurInt3(out ARet: LongWord);
begin
  ARet := 0;
  FStream.Read(ARet, 3);
end;

function TQQWry.ReadDataStr(AOffset: LongWord): string;
var
  B: Byte;
  S: TStringStream;
begin
{$IFDEF UNICODE}
  S := TStringStream.Create('', FEncoding, False);
{$ELSE}
  S := TStringStream.Create('');
{$ENDIF}
  try
    with FStream do
    begin
      Position := AOffset;
      while Read(B, 1) > 0 do
        if B = 0 then
          Break
        else S.Write(B, 1);
    end;
    Result := S.DataString;
  finally
    S.Free;
  end;
end;

procedure TQQWry.ReadEndIp;
begin
  with FStream do
  begin
    Position := FEndIpOff;
    Read(FEndIP, SizeOf(Integer));
    Read(FCountryFlag, SizeOf(Byte));
  end;
end;

function TQQWry.ReadFlagStr(AOffset: LongWord): string;
var
  nFlag: Byte;
  nOffset: LongWord;
begin
  Result := '';
  nOffset := AOffset;
  while True do
  begin
    with FStream do
    begin
      Position := nOffset;
      if Read(nFlag, 1) = 0 then
        Exit;
    end;
    if (nFlag = 1) or (nFlag = 2) then
    begin
      if nFlag = 2 then
      begin
        FCountryFlag := 2;
        FEndIpOff := nOffset - 4;
      end;
      ReadCurInt3(nOffset);
    end
    else Break;
  end;
  if nOffset < 12 then
    Exit;
  Result := ReadDataStr(nOffset);
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2008.01.06
//功能: 读取指定记录
//参数: 
//注意: 
////////////////////////////////////////////////////////////////////////////////
procedure TQQWry.ReadRecord(ARecNo: LongWord);
begin
  ReadStartIp(ARecNo);
  ReadEndIp;
  ReadCountry;
end;

procedure TQQWry.ReadStartIp(ARecNo: LongWord);
begin
  with FStream do
  begin
    Position := FFirstStartIp + ARecNo * 7;
    Read(FStartIP, SizeOf(Integer));
    ReadCurInt3(FEndIpOff);
  end;
end;

function TQQWry.Seek(ARecIndex: LongWord): Boolean;
begin
  Result := InRange(ARecIndex, 0, FRecCount - 1);
  if Result then ReadRecord(ARecIndex);
end;

{ TQQWryFile }

constructor TQQWryFile.Create(const AFile: string);
begin
  if AFile = '' then
    FFile := defQQWryFile
  else FFile := AFile;
  FFile := ExpandFileName(FFile);
  FStream := TFileStream.Create(FFile, fmOpenRead or fmShareDenyWrite);

  inherited Create(FStream);
end;

destructor TQQWryFile.Destroy;
begin
  inherited;

  FreeAndNil(FStream);
end;

{ TQQWryMemoryFile }

constructor TQQWryMemoryFile.Create(const AFile: string);
begin
  FStream := TMemoryStream.Create;
  if AFile = '' then
    FStream.LoadFromFile(defQQWryFile)
  else FStream.LoadFromFile(AFile);

  inherited Create(FStream);
end;

destructor TQQWryMemoryFile.Destroy;
begin
  inherited;

  FreeAndNil(FStream);
end;

{ TQQWryResFile }

constructor TQQWryResFile.Create(const AResName: string;
  AResType: PChar);
begin
  FStream := TResourceStream.Create(HInstance, AResName, AResType);

  inherited Create(FStream);
end;

destructor TQQWryResFile.Destroy;
begin
  inherited;

  FreeAndNil(FStream);
end;

end.
