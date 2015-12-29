object MainForm: TMainForm
  Left = 413
  Top = 132
  Caption = 'IP'
  ClientHeight = 362
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    584
    362)
  PixelsPerInch = 96
  TextHeight = 12
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 553
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '114.114.114.114'
  end
  object Edit2: TEdit
    Left = 16
    Top = 48
    Width = 553
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Find'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 104
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Dll'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ListView1: TListView
    Left = 16
    Top = 120
    Width = 553
    Height = 224
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Alignment = taCenter
        Caption = #36215#22987' IP'
        Width = 120
      end
      item
        Alignment = taCenter
        Caption = #32456#27490' IP'
        Width = 120
      end
      item
        Caption = #22320#21306
        Width = 120
      end
      item
        Caption = #20301#32622
        Width = 185
      end>
    GridLines = True
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
    OnData = ListView1Data
    OnInfoTip = ListView1InfoTip
  end
end
