program Exifdate;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  CommonFunctions in 'C:\_s.mile Software\D_2007\Source\Common\CommonFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Exifdate';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
