# QQWry

![Version](https://img.shields.io/badge/version-v1.0-yellow.svg)
![License](https://img.shields.io/github/license/delphilite/QQWry)
![Lang](https://img.shields.io/github/languages/top/delphilite/QQWry.svg)
![stars](https://img.shields.io/github/stars/delphilite/QQWry.svg)

[English](./README.md) | [Chinese](./README.zh-CN.md)

QQWry is a widely used IP geolocation database in the Chinese developer ecosystem. This library makes it easier to integrate QQWry lookups into Delphi, Lazarus, Free Pascal, and related Pascal-based applications.

## Features

- Read location data from `QQWry.dat`
- Resolve IPv4 addresses to address strings
- Support multiple loading modes:
  - file-based access
  - memory-loaded access
  - resource-stream access
- Expose database metadata and record navigation helpers
- Simple API for quick integration

## Requirements

- Delphi 2007 or later
- A valid `QQWry.dat` database file

## Installation

### Manual

To install the QQWry binding, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/delphilite/QQWry.git
    ```

2. Add the QQWry\Source directory to the project or IDE's search path.
3. Make sure Everything is installed and running on your system.

### Delphinus

QQWry should now be listed in [Delphinus package manager](https://github.com/Memnarch/Delphinus/wiki/Installing-Delphinus).

Be sure to restart Delphi after installing via Delphinus otherwise the units may not be found in your test projects.

## Getting the database file

Please download the latest `qqwry.dat` from the [`nmgliangwei/qqwry`](https://github.com/nmgliangwei/qqwry) project and place it where your application can access it.

Direct download:

`https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry.dat`
`https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry_zh-hant.dat`

By default, the file-based constructor expects the database file name to be:

```text
QQWry.dat
```

If you pass an empty path, the library uses that default file name.

## Usage

### 1. Basic lookup with `TQQWryFile`

```pascal
uses
  SysUtils, QQWry;

procedure TestLookup;
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

### 2. One-line helper lookup

```pascal
uses
  SysUtils, QQWry;

procedure TestSimpleLookup;
var
  Address: string;
begin
  if GetIpAddress('8.8.8.8', Address) then
    Writeln(Address)
  else
    Writeln('Lookup failed');
end;
```

### 3. Load the database into memory

```pascal
uses
  SysUtils, QQWry;

procedure TestMemoryLookup;
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

## Main API

### Classes

* `TQQWry`
  * Base class for stream-based database access

* `TQQWryFile`
  * Reads from a file stream

* `TQQWryMemoryFile`
  * Loads the database into memory first

* `TQQWryResFile`
  * Reads the database from a compiled resource stream

### Core methods

* `Find(const AIP: string; out AAddress: string): Boolean`
  * Looks up an IPv4 address and returns the resolved address text

* `Seek(ARecIndex: Cardinal): Boolean`
  * Reads a record by index

### Helper function

* `GetIpAddress(const AIp: string; out AAddress: string): Boolean`
  * Convenience wrapper for quick lookups using the default database file

### Useful properties

* `Author`
* `DateTime`
* `RecCount`
* `StartIP`
* `EndIP`
* `Country`
* `Local`

## Notes and caveats

* The returned address text may require additional application-side normalization.
* Many records are formatted in patterns similar to province/city combinations.
* International location data may be less accurate than dedicated commercial GeoIP datasets.
* The library works with **IPv4** string input.

## Encoding

QQWry data is handled using code page **936** in Unicode builds. If your application displays Chinese text, make sure your environment and UI controls are configured appropriately.

## Error handling

The library raises an exception if the database header cannot be loaded. Typical integration checks should include:

* whether `QQWry.dat` exists
* whether the file is readable
* whether the database file is valid and up to date

## Where to get help

If you run into issues:

* open an issue in this repository
* check the `Demos` directory for usage examples
* verify that your `QQWry.dat` file is valid and accessible

## Contributing

Contributions are welcome! Please fork this repository and submit pull requests with your improvements.

## License

This project is licensed under the Mozilla Public License 2.0. See [LICENSE](./LICENSE) for details.

## Acknowledgements

Thanks to the QQWry / CZ88 ecosystem for providing the IP database format used by this project.

If you need a more accurate or commercially supported dataset, consider the official commercial offerings from the QQWry provider.
