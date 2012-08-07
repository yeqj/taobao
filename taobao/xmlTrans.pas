unit xmlTrans;

interface

uses
  XMLDoc, XMLIntf, Generics.Collections, Classes;

type
  TBaseTrans = class
  private
    { private declarations }

  protected
    FXmlNode : IXMLNode;
  public
    { public declarations }
    constructor Create(Stream: TStream);
  end;

  TProductcatInfo = record
    cat_name : string;
    name : string;
  end;

  TProductcatsXML = class(TBaseTrans)
  private
    function GetProductcats: TList<TProductcatInfo>;
  public
    property Productcats : TList<TProductcatInfo> read GetProductcats;
  end;

implementation

uses
  Variants;

{ TBaseTrans }

constructor TBaseTrans.Create(Stream: TStream);
var
  aXmlDoc : IXMLDocument;
begin
  aXmlDoc := NewXMLDocument();
  aXmlDoc.LoadFromStream(Stream);
  aXmlDoc.Active := true;
  FXmlNode := aXmlDoc.DocumentElement;
end;

{ TProductcatsXML }

function TProductcatsXML.GetProductcats: TList<TProductcatInfo>;
var
  i: Integer;
  aProductcatInfo : TProductcatInfo;
  aNode : IXMLNode;
begin
  Result := TList<TProductcatInfo>.Create;
  FXmlNode := FXmlNode.ChildNodes.FindNode('products');
  for i := 0 to FXmlNode.ChildNodes.Count-1 do
  try
    aNode := FXmlNode.ChildNodes.Get(i);
    aProductcatInfo.cat_name := VarToStr(aNode.ChildNodes.FindNode('cat_name').NodeValue);
    aProductcatInfo.name := VarToStr(aNode.ChildNodes.FindNode('name').NodeValue);
    Result.Add(aProductcatInfo);
  except
  end;
end;

end.
