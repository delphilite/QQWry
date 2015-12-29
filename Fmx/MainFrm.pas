unit MainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Layouts, FMX.Grid,
  FMX.Edit, QQWry, System.Rtti, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringGrid1: TGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

{.$R QQWry.res}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
var
  S: string;
begin
  Caption := BoolToStr(FFile.Find(Edit1.Text, S), True);
  Edit2.Text := S;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  S: string;
begin
  Caption := BoolToStr(GetLocation(Edit1.Text, S), True);
  Edit2.Text := S;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
{
  FFile := TQQWryResFile.Create('QQWry', RT_RCDATA);
}
  FFile := TQQWryFile.Create;

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
