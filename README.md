# QQWry

![Version](https://img.shields.io/badge/version-v1.0-yellow.svg)
![License](https://img.shields.io/github/license/delphilite/QQWry)
![Lang](https://img.shields.io/github/languages/top/delphilite/QQWry.svg)
![stars](https://img.shields.io/github/stars/delphilite/QQWry.svg)

[English](./README.md) | [Chinese](./README.zh-CN.md)

QQWry is a Delphi/Pascal reader for the QQWry (CZ88) `.dat` IP geolocation database. It is designed for Delphi and Free Pascal applications that need simple offline IPv4 lookup support and currently focuses on the classic QQWry binary format (`QQWry.dat`).

## Features

- Reads QQWry `.dat` database files from a file path, memory-loaded file, or `TStream`.
- Resolves IPv4 addresses to location and ISP address strings.
- Supports multiple loading modes:
  - file-based access (`TQQWryFile`)
  - memory-loaded access (`TQQWryMemoryFile`)
  - resource-stream access (`TQQWryResFile`)
- Exposes database metadata: author, build date/time, and record count.
- Provides record navigation with `Seek` and `RecCount`.
- Strips the `CZ88.NET` watermark from returned address text.
- Includes DUnit tests and demos for VCL, FMX, Delphi console, and Free Pascal.

## Requirements

- Delphi 2007 or later, or Free Pascal with `{$MODE DELPHI}`
- A valid `QQWry.dat` database file

## Installation

### Manual

1. Clone this repository.
2. Add the `Source` directory to your Delphi or Lazarus project search path.
3. Add `QQWry` to your unit `uses` clause.
4. Place a `QQWry.dat` database file where your application can read it.

```pascal
uses
  SysUtils, QQWry;
```

### Delphinus

This repository includes Delphinus metadata:

- `Delphinus.Info.json`
- `Delphinus.Install.json`

After publishing the repository, it can be indexed by [Delphinus](https://github.com/Memnarch/Delphinus) as a source-only package.

Be sure to restart Delphi after installing via Delphinus otherwise the units may not be found in your test projects.

## Getting the database file

Please download the latest database files from the [`nmgliangwei/qqwry`](https://github.com/nmgliangwei/qqwry) project and place them where your application can access them.

Direct download:

- `https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry.dat` (Simplified Chinese)
- `https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry_zh-hant.dat` (Traditional Chinese)

By default, the file-based constructor expects the database file name to be:

```text
QQWry.dat
```

If you pass an empty path, the library uses that default file name.

The database files are data products from their respective providers. Check the provider license and redistribution terms before publishing them with a release or committing them to a public repository.

## Usage

### Basic Lookup

```pascal
uses
  SysUtils, QQWry;

procedure LookupIP;
var
  QQ: TQQWryFile;
  Address: string;
begin
  QQ := TQQWryFile.Create('QQWry.dat');
  try
    if QQ.Find('8.8.8.8', Address) then
      Writeln('Address: ', Address)
    else
      Writeln('IP not found');
  finally
    QQ.Free;
  end;
end;
```

### One-line Helper Lookup

```pascal
uses
  SysUtils, QQWry;

procedure SimpleLookup;
var
  Address: string;
begin
  if GetIpAddress('8.8.8.8', Address) then
    Writeln(Address)
  else
    Writeln('Lookup failed');
end;
```

### Load the Database into Memory

```pascal
uses
  SysUtils, QQWry;

procedure MemoryLookup;
var
  QQ: TQQWryMemoryFile;
  Address: string;
begin
  QQ := TQQWryMemoryFile.Create('QQWry.dat');
  try
    if QQ.Find('1.1.1.1', Address) then
      Writeln(Address);
  finally
    QQ.Free;
  end;
end;
```

### Load from a Resource Stream

```pascal
uses
  SysUtils, QQWry;

procedure ResourceLookup;
var
  QQ: TQQWryResFile;
  Address: string;
begin
  QQ := TQQWryResFile.Create('QQWry', RT_RCDATA);
  try
    if QQ.Find('8.8.8.8', Address) then
      Writeln(Address);
  finally
    QQ.Free;
  end;
end;
```

### Enumerate Records

`TQQWry` lets you iterate records by index:

```pascal
var
  QQ: TQQWryFile;
  I: Cardinal;
begin
  QQ := TQQWryFile.Create('QQWry.dat');
  try
    for I := 0 to QQ.RecCount - 1 do
    begin
      if QQ.Seek(I) then
        Writeln(Format('%s - %s: %s%s', [QQ.StartIP, QQ.EndIP, QQ.Country, QQ.Local]));
    end;
  finally
    QQ.Free;
  end;
end;
```

### Metadata

```pascal
Writeln(QQ.Author);
Writeln(QQ.DateTime);
Writeln(QQ.RecCount);
```

## Main API

### Classes

| Class | Description |
|-------|-------------|
| `TQQWry` | Base class for stream-based database access |
| `TQQWryFile` | Reads from a file stream (`TFileStream`) |
| `TQQWryMemoryFile` | Loads the database into memory first (`TMemoryStream`) |
| `TQQWryResFile` | Reads the database from a compiled resource stream (`TResourceStream`) |

### Core Methods

| Method | Description |
|--------|-------------|
| `Find(const AIP: string; out AAddress: string): Boolean` | Looks up an IPv4 address and returns the resolved address text |
| `Seek(ARecIndex: Cardinal): Boolean` | Reads a record by index; updates `StartIP`, `EndIP`, `Country`, `Local` |

### Helper Function

| Function | Description |
|----------|-------------|
| `GetIpAddress(const AIp: string; out AAddress: string): Boolean` | Convenience wrapper for quick lookups using the default database file |

### Properties

| Property | Description |
|----------|-------------|
| `Author` | Database author metadata |
| `DateTime` | Database build date/time |
| `RecCount` | Total number of IP range records |
| `StartIP` | Start IP of the current record (after `Find` or `Seek`) |
| `EndIP` | End IP of the current record (after `Find` or `Seek`) |
| `Country` | Country/region text of the current record |
| `Local` | Local/ISP text of the current record |

## Encoding

QQWry data is handled using code page **936** (GBK) in Unicode builds. If your application displays Chinese text, make sure your environment and UI controls are configured appropriately.

## Error Handling

The library raises `EQQWry` for invalid database files (e.g., when the header cannot be loaded). Passing `nil` to the `TQQWry.Create(TStream)` constructor triggers an assertion failure. Wrap database loading and lookups in normal Delphi `try/except` blocks when integrating into an application.

Typical integration checks should include:

- whether `QQWry.dat` exists
- whether the file is readable
- whether the database file is valid and up to date

## Notes

- Source files are kept as UTF-8 with Windows CRLF line endings.
- The returned address text has the `CZ88.NET` watermark stripped automatically.
- Many records are formatted in patterns similar to province/city combinations.
- International location data may be less accurate than dedicated commercial GeoIP datasets.
- The library works with **IPv4** string input only.
- `GetIpAddress` creates and frees a `TQQWryFile` instance on each call; for repeated lookups, prefer creating a persistent `TQQWryFile` or `TQQWryMemoryFile` instance.

## Contributing

Contributions are welcome! Please fork this repository and submit pull requests with your improvements. Behavior changes should include matching DUnit coverage in `UnitTest/`.

## License

This project is licensed under the Mozilla Public License 2.0. See [LICENSE](./LICENSE) for details.

## Acknowledgements

Thanks to the QQWry / CZ88 ecosystem for providing the IP database format used by this project.

If you need a more accurate or commercially supported dataset, consider the official commercial offerings from the QQWry provider.
