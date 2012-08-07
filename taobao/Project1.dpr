program Project1;

uses
  Forms,
  Unit4 in 'Unit4.pas' {Form4},
  TradesClass in 'TradesClass.pas',
  xmlTrans in 'xmlTrans.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
