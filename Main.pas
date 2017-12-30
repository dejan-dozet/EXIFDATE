unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, CommonFunctions, DateUtils, Mask, Buttons,
  ComCtrls;

type
  TString = class
    path: string;
  end;
  TPages = (pIntro, pChoose, pNames, pFinish);
  TfrmMain = class(TForm)
    pnlFormBottom: TPanel;
    pnlFormTop: TPanel;
    nb1: TNotebook;
    pnlTopChoose: TPanel;
    btnAddFiles: TButton;
    btnAddDie: TButton;
    btnClearList: TButton;
    pnlBottomChoose: TPanel;
    lblLegendChoose: TLabel;
    lstFilesChoose: TListBox;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    imgLogoIntro: TImage;
    flpndlg1: TFileOpenDialog;
    pnlNames: TPanel;
    pnlChoose: TPanel;
    pnlIntro: TPanel;
    rbFormat: TRadioButton;
    rbCustomFormat: TRadioButton;
    edtCustomFormat: TEdit;
    mmo1: TMemo;
    pnlFinish: TPanel;
    lstFinished: TListBox;
    lblWelcome: TLabel;
    lblIntro: TLabel;
    lblTitle: TLabel;
    lblURL: TLabel;
    lbldESCRIPTION: TLabel;
    pnlDescription: TPanel;
    btnRestart: TButton;
    lblShiftTimeBy: TLabel;
    btnPlus: TSpeedButton;
    btnMinus: TSpeedButton;
    dtpShiftTimeBy: TDateTimePicker;
    dtpTimeUpTo: TDateTimePicker;
    dtpDateUpTo: TDateTimePicker;
    lblUpTo: TLabel;
    chkJPG: TCheckBox;
    chkMP4: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure nb1PageChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddFilesClick(Sender: TObject);
    procedure btnClearListClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure btnAddDieClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function getFormat: string;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnAddDieClick(Sender: TObject);
var
  i: Integer; 
  SR      : TSearchRec;
  r: TString;
begin

  flpndlg1.Options := [fdoPathMustExist, fdoPickFolders];
  if flpndlg1.Execute then
  begin
    if FindFirst(IncludeTrailingBackslash(flpndlg1.FileName) + '*.jp*', faArchive, SR) = 0 then
    begin
      repeat
        r := TString.Create;
        r.path := IncludeTrailingBackslash(flpndlg1.FileName) + SR.Name;
        lstFilesChoose.AddItem(SR.Name, tobject(r));
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    if chkMP4.Checked then
    begin
      if FindFirst(IncludeTrailingBackslash(flpndlg1.FileName) + '*.mov', faArchive, SR) = 0 then
      begin
        repeat
          r := TString.Create;
          r.path := IncludeTrailingBackslash(flpndlg1.FileName) + SR.Name;
          lstFilesChoose.AddItem(SR.Name, tobject(r));
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;  
      if FindFirst(IncludeTrailingBackslash(flpndlg1.FileName) + '*.mp4', faArchive, SR) = 0 then
      begin
        repeat
          r := TString.Create;
          r.path := IncludeTrailingBackslash(flpndlg1.FileName) + SR.Name;
          lstFilesChoose.AddItem(SR.Name, tobject(r));
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;
    end;
  end;

  lblLegendChoose.Caption := IntToStr(lstFilesChoose.Count) + ' files found and loaded';
  btnNext.Visible := lstFilesChoose.Count <> 0;

end;

procedure TfrmMain.btnAddFilesClick(Sender: TObject);
var
  i: Integer;
  r: TString;
begin

  if chkMP4.Checked then
  with flpndlg1.FileTypes.Add do
  begin
    DisplayName := 'JPG, JPEG, MOV and MP4 Files';
    FileMask := '*.mov;*.mp4;*.jpg;*.jpeg';
  end
  else
  with flpndlg1.FileTypes.Add do
  begin
    DisplayName := 'JPG, JPEG Files';
    FileMask := '*.jpg;*.jpeg';
  end;

  flpndlg1.Options := [fdoAllowMultiSelect,fdoFileMustExist];
  if flpndlg1.Execute then
  for I := 0 to flpndlg1.Files.Count - 1 do
  begin
    r := TString.Create;
    r.path := flpndlg1.Files[i];
    lstFilesChoose.AddItem(ExtractFileName(flpndlg1.Files[i]), TObject(r));
  end;
  flpndlg1.FileTypes.Delete(0);
  lblLegendChoose.Caption := IntToStr(lstFilesChoose.Count) + ' pictures (JPEG) found and loaded';
  btnNext.Visible := lstFilesChoose.Count <> 0;
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  nb1.Tag := nb1.Tag - 1;
  nb1.PageIndex := nb1.Tag;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
var
  i: Integer;
begin
  if lstFilesChoose.Items.Count > 0 then
  for i := 0 to lstFilesChoose.Items.Count - 1 do
    TString(lstFilesChoose.Items.Objects[i]).Free;

  lstFilesChoose.Clear;
  lblLegendChoose.Caption := 'No photos loaded';
  btnNext.Visible := lstFilesChoose.Count <> 0;
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  nb1.Tag := nb1.Tag + 1;
  nb1.PageIndex := nb1.Tag;
end;

procedure TfrmMain.btnRestartClick(Sender: TObject);
begin    
  nb1.Tag := 1;
  nb1.PageIndex := nb1.Tag;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btnClearList.Click;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  nb1.PageIndex := 0;
end;

function TfrmMain.getFormat: string;
begin
  if rbFormat.Checked then
    Result := rbFormat.Caption
  else
    Result := edtCustomFormat.Text;
end;

procedure TfrmMain.nb1PageChanged(Sender: TObject);
var
  i, j: Integer;
  fileDate   : Integer;
  d, d_max: TDateTime;
  OldFileName, NewFileName: string;

  fad: TWin32FileAttributeData;
  ar: TStringArray;
begin
  case nb1.PageIndex of   
    Integer(pIntro):
    begin
      btnBack.Visible := False;
      btnNext.Visible := True;
      btnRestart.Visible := False;
      pnlDescription.Caption := '';
      lbldESCRIPTION.Caption := '';
    end;
    Integer(pChoose):
    begin          
      btnBack.Visible := True;
      btnRestart.Visible := False;
      lstFinished.Clear;
      btnNext.Visible := lstFilesChoose.Count <> 0;
      pnlDescription.Caption := 'Photos Selection';
      lbldESCRIPTION.Caption := 'Select photo files you want to rename';
    end;
    Integer(pNames):
    begin
      btnBack.Visible := True;
      btnNext.Visible := True;
      btnRestart.Visible := False;
      pnlDescription.Caption := 'Choose Format';
      lbldESCRIPTION.Caption := 'Choose preferred format for renaming';   

      OldFileName := TString(lstFilesChoose.Items.Objects[0]).path;
      d_max := getModifiedDate(OldFileName);

      for i := 1 to lstFilesChoose.Count - 1 do
      begin
        OldFileName := TString(lstFilesChoose.Items.Objects[i]).path;
        d := getModifiedDate(OldFileName);
        if d > d_max then
          d_max := d;
      end;  

      dtpDateUpTo.DateTime := d_max;
      dtpTimeUpTo.Time := d_max;
    end;
    Integer(pFinish):
    try
      btnBack.Visible := false;
      btnNext.Visible := false;
      btnRestart.Visible := false;
      dtpDateUpTo.Time := dtpTimeUpTo.Time;
      d_max := dtpDateUpTo.DateTime;
      for i := 0 to lstFilesChoose.Count - 1 do
      begin

        OldFileName := TString(lstFilesChoose.Items.Objects[i]).path;

        d := getModifiedDate(OldFileName);

        if d <= d_max then
        begin

          if btnPlus.Down then
          begin
            d := DateUtils.IncHour(d, DateUtils.HourOf(dtpShiftTimeBy.Time));
            d := DateUtils.IncMinute(d, DateUtils.MinuteOf(dtpShiftTimeBy.Time));
            d := DateUtils.IncSecond(d, DateUtils.SecondOf(dtpShiftTimeBy.Time));
          end
          else
          begin
            d := DateUtils.IncHour(d, - DateUtils.HourOf(dtpShiftTimeBy.Time));
            d := DateUtils.IncMinute(d, - DateUtils.MinuteOf(dtpShiftTimeBy.Time));
            d := DateUtils.IncSecond(d, - DateUtils.SecondOf(dtpShiftTimeBy.Time));
          end;

          ar := Split('~', StringReplace(OldFileName, ExtractFileExt(OldFileName), '', []));

          NewFileName := '';

          if (Length(ar) = 2) then
          if TryStrToInt(ar[1], j) then
            NewFileName := '~' + IntToStr(j);

          NewFileName :=  ExtractFilePath(OldFileName) + FormatDateTime(getFormat, d) + NewFileName + ExtractFileExt(OldFileName);

          if LowerCase(OldFileName)  <> LowerCase(NewFileName) then
          begin
            NewFileName := CreateUniqueFileName(NewFileName);
            if RenameFile(OldFileName, NewFileName) then
            begin
              lstFinished.AddItem(ExtractFileName(NewFileName) + ' - finished', nil);
            end
            else
              lstFinished.AddItem(ExtractFileName(NewFileName) + ' - ERROR', nil);
          end
          else
            lstFinished.AddItem(ExtractFileName(NewFileName) + ' - already processed before', nil);
        end
        else
          lstFinished.AddItem(ExtractFileName(NewFileName) + ' - out of date range', nil);
        lstFinished.TopIndex := lstFinished.Items.Count - 1;
        Application.ProcessMessages;
      end;
      lstFinished.Sorted := True;
      btnBack.Visible := false;
      btnNext.Visible := false;
      btnRestart.Visible := True;
      btnClearList.Click;  
      pnlDescription.Caption := 'Renaming';
      lbldESCRIPTION.Caption := 'Please wait while renaming your files...';

    except
      on e:Exception do
        Application.MessageBox(PChar(e.Message), 'Error', MB_ICONERROR);

    end;
  end;
end;

end.
