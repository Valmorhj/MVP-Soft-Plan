program ProjectMVP;

uses
  Vcl.Forms,
  uMainMVP in 'uMainMVP.pas' {frPrincipal},
  uConexaoDao in 'uConexaoDao.pas',
  uViaCEPClient in 'uViaCEPClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
