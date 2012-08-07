unit TradesClass;

interface

uses
  IdHashMessageDigest, Classes, Generics.Collections;

type
  TBaseTrade = class
  private
    FParam : TStringlist;
    Fapp_secret: string;
    procedure SetSign();
    function GetMD5(Str: string): string;
    procedure Setapp_secret(const Value: string);
    function getURL: string;
    procedure SetNick(const Value: string);
    procedure SetMethod(const Value: string);
    procedure SetApp_key(const Value: string);
    procedure SetFields(const Value: string);
    procedure SetSession(const Value: string);
  protected
    procedure AddParam(Name, Value : string);
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
    property app_secret : string read Fapp_secret write Setapp_secret;
    property URL : string read getURL;
    property Nick : string write SetNick;
    property Method : string write SetMethod;
    property App_key : string write SetApp_key;
    property Session : string write SetSession;
  end;

  /// <summary>
  /// 获取单个用户信息
  /// </summary>
  TUser = Class(TBaseTrade)
  private
    property Method : string write SetMethod;
  public
    constructor Create(); override;
  End;

  /// <summary>
  /// 获取店铺信息
  /// </summary>
  TShop = Class(TBaseTrade)
  private
    property Method : string write SetMethod;
  public
    constructor Create(); override;
  End;

  /// <summary>
  /// 交易订单帐务查询
  /// </summary>
  TAmount = Class(TBaseTrade)
  private
    procedure Settid(const Value: string);
    property Method : string write SetMethod;
  public
    constructor Create(); override;
    property tid : string write Settid;
  End;

  /// <summary>
  /// 获取产品列表
  /// </summary>
  TProductcats = Class(TBaseTrade)
  private
    procedure SetPage_no(const Value: string);
    property Method : string write SetMethod;
  public
    constructor Create(); override;
    property Page_no : string write SetPage_no;
  End;

  /// <summary>
  /// 获取单个产品
  /// </summary>
  TProductcat = Class(TBaseTrade)
  private
    procedure Setproduct_id(const Value: string);
  published
  public
    constructor Create(); override;
    property product_id : string write Setproduct_id;
  End;

  /// <summary>
  /// 淘宝系统时间
  /// </summary>
  TServerTime = Class(TBaseTrade)
  public
    constructor Create(); override;
  end;

  /// <summary>
  /// 物流查询
  /// </summary>
  TAreasGet = Class(TBaseTrade)
  public
    constructor Create(); override;
  end;

implementation

uses
  SysUtils, HTTPApp;

{ TBaseTrade }

procedure TBaseTrade.AddParam(Name, Value: string);
begin
  if FParam.IndexOfName(LowerCase(Name))<0 then
    FParam.Add(LowerCase(Name) +'=' + Value)
  else
    FParam.Values[LowerCase(Name)] := Value;
end;

constructor TBaseTrade.Create;
begin
  FParam := TStringList.Create;
  AddParam('Timestamp', FormatDateTime('yyyy-mm-dd hh:nn:ss', now));
  AddParam('v','2.0');
  AddParam('format','xml');
  AddParam('sign_method','md5');
end;

destructor TBaseTrade.Destroy;
begin
  FParam.Free;
  inherited;
end;

function TBaseTrade.GetMD5(Str: string): string;
var
  md5: TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(md5.HashStringAsHex(Str, TEncoding.UTF8)); // 设置编码汉字才能正确
  finally
    FreeAndNil(md5);
  end;
end;

function TBaseTrade.getURL: string;
var
  I: Integer;
begin
  SetSign();
  Result := '';
  for I := 0 to FParam.Count - 1 do
    Result := Result  + '&' + FParam.Names[i] + '=' + HTTPEncode(UTF8Encode(FParam.ValueFromIndex[i]));
  Result := 'http://gw.api.taobao.com/router/rest?' + copy(Result , 2, length(Result)-1);
end;

procedure TBaseTrade.SetApp_key(const Value: string);
begin
  AddParam('app_key', Value);
end;

procedure TBaseTrade.Setapp_secret(const Value: string);
begin
  Fapp_secret := Value;
end;

procedure TBaseTrade.SetFields(const Value: string);
begin
  AddParam('fields', Value);
end;

procedure TBaseTrade.SetMethod(const Value: string);
begin
  AddParam('method', Value);
end;

procedure TBaseTrade.SetNick(const Value: string);
begin
  AddParam('nick', Value);
end;

procedure TBaseTrade.SetSession(const Value: string);
begin
  AddParam('session', Value);
end;

procedure TBaseTrade.SetSign;
var
  i: Integer;
  SignStr : string;
begin
  FParam.Sort;
  SignStr := '';
  for i :=0 to FParam.Count -1 do
    SignStr := SignStr + FParam.Names[i] + FParam.ValueFromIndex[i];
  SignStr := Fapp_secret + SignStr + Fapp_secret;
  SignStr := UpperCase(GetMD5(SignStr));
  AddParam('sign', SignStr);
end;

{ TAmount }

constructor TAmount.Create;
begin
  inherited;
  AddParam('fields', 'tid,oid,alipay_no,total_fee,post_fee');
  AddParam('method', 'taobao.trade.amount.get');
end;

procedure TAmount.Settid(const Value: string);
begin
  AddParam('tid', Value);
end;

{ TProductcats }

constructor TProductcats.Create;
begin
  inherited;
  AddParam('method', 'taobao.products.get');
  AddParam('fields', 'product_id,tsc,name');
end;

procedure TProductcats.SetPage_no(const Value: string);
begin
  AddParam('page_no', Value);
end;

{ TUser }

constructor TUser.Create;
begin
  inherited;
  AddParam('method', 'taobao.user.get');
  AddParam('fields', 'user_id,nick,seller_credit,buyer_credit');
end;

{ TProductcat }

constructor TProductcat.Create;
begin
  inherited;
  AddParam('method', 'taobao.product.get');
  AddParam('fields', 'name,product_id');
end;

procedure TProductcat.Setproduct_id(const Value: string);
begin
  AddParam('product_id', Value);
end;

{ TServerTime }

constructor TServerTime.Create;
begin
  inherited;
  AddParam('method', 'taobao.time.get');
end;

{ TShop }

constructor TShop.Create;
begin
  inherited;
  AddParam('method', 'taobao.shop.get');
  AddParam('fields', 'sid,cid,title,nick,desc,bulletin,pic_path,created,modified');
end;

{ TAreasGet }

constructor TAreasGet.Create;
begin
  inherited;
  AddParam('method', 'taobao.areas.get');
  AddParam('fields', 'id,type,name');
end;

end.
