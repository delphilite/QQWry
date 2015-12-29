unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, QQWry;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    ListView1: TListView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure ListView1InfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
  private
    FFile: TQQWry;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

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
  with Screen.HintFont do
  begin
    Color := clPurple;
    Style := [fsBold];
  end;
{
  FFile := TQQWryResFile.Create('QQWry', RT_RCDATA);
}
  FFile := TQQWryFile.Create;

  with FFile do
  begin
    Caption := Format('作者：%s，时间：%s，数目：%d', [Author, DateTime, RecCount]);
    ListView1.Items.Count := RecCount;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFile);
end;

procedure TMainForm.ListView1Data(Sender: TObject; Item: TListItem);
var
  nRecIndex: LongWord;
begin
  nRecIndex := Item.Index;
  with FFile do
  begin
    if not Seek(nRecIndex) then
      Exit;
    Item.Caption := Format('%6d', [nRecIndex]);
    Item.SubItems.Add(StartIP);
    Item.SubItems.Add(EndIP);
    Item.SubItems.Add(Country);
    Item.SubItems.Add(Local);
  end;
end;

procedure TMainForm.ListView1InfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
var
  nRecIndex: LongWord;
begin
  nRecIndex := Item.Index;
  with FFile do
  begin
    if not Seek(nRecIndex) then
      Exit;
    InfoTip := StartIP + '-' + EndIP;
    InfoTip := StringReplace(InfoTip, ' ', '', [rfReplaceAll]);
    InfoTip := InfoTip + ': ' + Country + ' ' + Local;
  end;
end;

end.
