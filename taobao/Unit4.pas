unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdHTTP, TradesClass;

type
  TForm4 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function getXml(urlStr: string): TStream;
    procedure IniBaseTrade(aBaseTrade : TBaseTrade);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses xmlTrans;


{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var
  aTrade : TShop;
  aStream: TStream;
begin
  aTrade := TShop.Create;
  IniBaseTrade(aTrade);
  aStream := getXml(aTrade.URL);
  Memo1.Lines.LoadFromStream(aStream, TUTF8Encoding.Create);
  aStream.Free;
end;

function TForm4.getXml(urlStr: string): TStream;
var
  MyStream: TMemoryStream;
  IdHTTP1 : TIdHTTP;
begin
  MyStream          := TMemoryStream.Create;
  IdHTTP1           := TIdHTTP.Create(nil);
  try
    with IdHTTP1 do
      begin
        Request.Accept            := 'text/html, */*';
        Request.ContentType       := 'application/x-www-form-urlencoded';
        Request.ContentLength     := 0;
        Request.ContentRangeEnd   := 0;
        Request.ContentRangeStart := 0;
        Request.UserAgent         := 'Mozilla/3.0 (compatible; Indy Library)';
      end;
    try
      IdHTTP1.Get(urlStr, MyStream);
      MyStream.Position := 0;
      Result := MyStream;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  finally
    IdHTTP1.Disconnect;
    IdHTTP1.Free;
  end;
end;

procedure TForm4.IniBaseTrade(aBaseTrade : TBaseTrade);
begin
  aBaseTrade.app_secret := '855d4eafe9e7f8570065c047a36bb144';
  aBaseTrade.App_key := '21041405';
  aBaseTrade.Nick := '小猪班纳绿光之城店';
  aBaseTrade.Session := '6102626ba734b751201abde03f87b08b741af690135563a33649219';
end;

end.
