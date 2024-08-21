unit MainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Rtti, FMX.Grid.Style, FMX.StdCtrls, FMX.Edit, FMX.Forms, FMX.Grid, FMX.Types,
  FMX.Controls, FMX.Controls.Presentation, FMX.ScrollBox, QQWry;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringGrid1: TGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1GetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
  private
    FFile: TQQWry;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

{$R ..\Bin\QQWry.res}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
var
  S: string;
begin
  if FFile.Find(Edit1.Text, S) then
    Edit2.Text := S
  else Edit2.Text := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
{
  FFile := TQQWryFile.Create;
}
  FFile := TQQWryResFile.Create('QQWry', RT_RCDATA);

  with StringGrid1, FFile do
  begin
    Caption := Format('作者：%s，时间：%s，数目：%d', [Author, DateTime, RecCount]);
    RowCount := RecCount;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFile);
end;

procedure TMainForm.StringGrid1GetValue(Sender: TObject; const Col, Row: Integer;
  var Value: TValue);
var
  nRecIndex: LongWord;
begin
  with FFile do
  begin
    nRecIndex := Row;
    if not Seek(nRecIndex) then
      Exit;
    case Col of
      0:
        Value := Format('%6d', [nRecIndex]);
      1:
        Value := StartIP;
      2:
        Value := EndIP;
      3:
        Value := Country;
      4:
        Value := Local;
    end;
  end;
end;

end.
