# QQWry

![Version](https://img.shields.io/badge/version-v1.0-yellow.svg)
![License](https://img.shields.io/github/license/delphilite/QQWry)
![Lang](https://img.shields.io/github/languages/top/delphilite/QQWry.svg)
![stars](https://img.shields.io/github/stars/delphilite/QQWry.svg)

[English](./README.md) | [Chinese](./README.zh-CN.md)

QQWry 是一个 Delphi/Pascal 版纯真（QQWry）`.dat` 离线地址库读取器，适合在 Delphi 与 Free Pascal 应用中集成离线 IPv4 归属地查询。当前项目支持经典的 QQWry 二进制格式（`QQWry.dat`）。

## 功能特性

- 从文件路径、内存加载文件或 `TStream` 读取 QQWry `.dat` 数据库文件。
- 将 IPv4 地址解析为归属地和运营商地址文本。
- 支持多种加载模式：
  - 文件访问（`TQQWryFile`）
  - 内存加载访问（`TQQWryMemoryFile`）
  - 资源流访问（`TQQWryResFile`）
- 提供数据库元数据：作者、构建日期/时间、记录数量。
- 通过 `Seek` 和 `RecCount` 提供记录遍历支持。
- 自动去除返回地址文本中的 `CZ88.NET` 水印。
- 包含 DUnit 单元测试，以及 VCL、FMX、Delphi 控制台与 Free Pascal 示例。

## 环境要求

- Delphi 2007+，或启用 `{$MODE DELPHI}` 的 Free Pascal
- 合法的 `QQWry.dat` 数据库文件

## 安装方式

### 手工安装

1. 克隆本仓库。
2. 将 `Source` 目录加入 Delphi 或 Lazarus 工程搜索路径。
3. 在代码中引用 `QQWry` 单元。
4. 将 `QQWry.dat` 数据库文件放到应用可以读取的位置。

```pascal
uses
  SysUtils, QQWry;
```

### Delphinus

仓库包含 Delphinus 元数据：

- `Delphinus.Info.json`
- `Delphinus.Install.json`

项目发布到 GitHub 后，可作为源码包接入 [Delphinus](https://github.com/Memnarch/Delphinus)。

安装后请重启 Delphi，否则测试工程可能找不到单元。

## 数据库文件

请从 [`nmgliangwei/qqwry`](https://github.com/nmgliangwei/qqwry) 项目下载最新的数据库文件，并放到应用可以访问的位置。

直接下载：

- `https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry.dat`（简体中文）
- `https://raw.githubusercontent.com/nmgliangwei/qqwry/main/qqwry_zh-hant.dat`（繁体中文）

默认情况下，文件构造器期望的数据库文件名为：

```text
QQWry.dat
```

如果传入空路径，库将使用该默认文件名。

数据库文件属于对应数据提供方的数据产品。公开发布或提交到仓库前，请确认授权和再分发条件。

## 使用示例

### 基础查询

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

### 一行式快捷查询

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

### 内存加载数据库

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

### 从资源流加载

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

### 枚举记录

`TQQWry` 支持按索引遍历地址段记录：

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

### 元数据

```pascal
Writeln(QQ.Author);
Writeln(QQ.DateTime);
Writeln(QQ.RecCount);
```

## 主要 API

### 类

| 类 | 说明 |
|----|------|
| `TQQWry` | 基于流的数据库访问基类 |
| `TQQWryFile` | 从文件流（`TFileStream`）读取 |
| `TQQWryMemoryFile` | 先将数据库加载到内存（`TMemoryStream`） |
| `TQQWryResFile` | 从编译资源流（`TResourceStream`）读取 |

### 核心方法

| 方法 | 说明 |
|------|------|
| `Find(const AIP: string; out AAddress: string): Boolean` | 查询 IPv4 地址，返回解析后的地址文本 |
| `Seek(ARecIndex: Cardinal): Boolean` | 按索引读取记录；更新 `StartIP`、`EndIP`、`Country`、`Local` |

### 辅助函数

| 函数 | 说明 |
|------|------|
| `GetIpAddress(const AIp: string; out AAddress: string): Boolean` | 使用默认数据库文件进行快捷查询的便利封装 |

### 属性

| 属性 | 说明 |
|------|------|
| `Author` | 数据库作者元数据 |
| `DateTime` | 数据库构建日期/时间 |
| `RecCount` | IP 地址段记录总数 |
| `StartIP` | 当前记录的起始 IP（`Find` 或 `Seek` 之后） |
| `EndIP` | 当前记录的结束 IP（`Find` 或 `Seek` 之后） |
| `Country` | 当前记录的国家/地区文本 |
| `Local` | 当前记录的本地/运营商文本 |

## 编码

Unicode 构建下，QQWry 数据使用代码页 **936**（GBK）处理。如果应用需要显示中文文本，请确保运行环境和 UI 控件已正确配置。

## 错误处理

数据库文件非法（如头部无法加载）时会抛出 `EQQWry`。向 `TQQWry.Create(TStream)` 传入 `nil` 会触发断言失败。实际应用中建议对数据库加载和查询调用使用 `try/except` 进行保护。

典型集成检查项：

- `QQWry.dat` 是否存在
- 文件是否可读
- 数据库文件是否有效且为最新版本

## 注意事项

- 源码文件使用 UTF-8 与 Windows CRLF。
- 返回的地址文本已自动去除 `CZ88.NET` 水印。
- 多数记录的格式类似"省/市"组合。
- 国外地址数据不如专业商业 GeoIP 数据集准确。
- 本库仅支持 **IPv4** 字符串输入。
- `GetIpAddress` 每次调用都会创建并释放 `TQQWryFile` 实例；如需反复查询，建议创建持久的 `TQQWryFile` 或 `TQQWryMemoryFile` 实例。

## 贡献

欢迎提交 issue 和 pull request。行为变更请尽量在 `UnitTest/` 中补充对应的 DUnit 测试。

## 许可证

本项目使用 Mozilla Public License 2.0。详见 [LICENSE](./LICENSE)。

## 特别感谢

感谢 QQWry / 纯真（CZ88）生态为本项目所使用的 IP 数据库格式提供支持。

纯真（CZ88.NET）自 2005 年起一直为广大社区用户提供社区版 IP 地址库，只要获得纯真的授权就能免费使用，并不断获取后续更新的版本。如果有需要免费版 IP 库的朋友可以前往纯真的官网进行申请。

纯真除了免费的社区版 IP 库外，还提供数据更加准确、服务更加周全的商业版 IP 地址查询数据。纯真围绕 IP 地址，基于「网络空间拓扑测绘 + 移动位置大数据」方案，对 IP 地址定位、IP 网络风险、IP 使用场景、IP 网络类型、秒拨侦测、VPN 侦测、代理侦测、爬虫侦测、真人度等均有近 20 年丰富的数据沉淀。

如需更准确或商业支持的数据集，可考虑 QQWry 数据提供方的官方商业产品。
