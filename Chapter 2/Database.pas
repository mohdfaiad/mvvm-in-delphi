unit Database;

{********************************}
{ This unit resembles a storage  }
{ medium. It can implement access}
{ to databases, text files or    }
{ remote servers.                }
{********************************}

interface

uses Declarations, System.Generics.Collections;

type
  TDatabase = class
  private
    fCustomers: TObjectList<TCustomer>;
    fItems: TObjectList<TItem>;
    fFullFileName: string;
  public
    constructor Create;
    {$REGION 'Returns the list of the customers in the persistent medium.'}
    /// <summary>
    ///   Returns the list of the customers in the persistent medium.
    /// </summary>
    {$ENDREGION}
    function GetCustomerList: TObjectList<TCustomer>;
    {$REGION 'Finds the customer record from the customer name.'}
    /// <summary>
    ///   Finds the customer record from the customer name.
    /// </summary>
    {$ENDREGION}
    function GetCustomerFromName(const nameStr: string): TCustomer;
    function GetItems: TObjectList<TItem>;
    function GetItemFromDescription(const desc: string): TItem;
    function GetItemFromID(const id: Integer): TItem;
    {$REGION 'Retrieves the total sales from the text file.'}
    /// <summary>
    ///   Retrieves the total sales from the text file.
    /// </summary>
    {$ENDREGION}
    function GetTotalSales: Currency;
    {$REGION 'Updates the INI file with the current sales.'}
    /// <summary>
    ///   Updates the INI file with the current sales.
    /// </summary>
    {$ENDREGION}
    procedure SaveCurrentSales(const currentSales: Currency);
    destructor Destroy; override;
  end;

implementation

uses
  System.IniFiles, System.SysUtils, System.IOUtils;

{ TDatabase }

constructor TDatabase.Create;
var
  tmpCustomer: TCustomer;
  tmpItem: TItem;
begin
  inherited;
  fFullFileName:=TPath.Combine(ExtractFilePath(ParamStr(0)), 'POSApp.data');
  fCustomers:=TObjectList<TCustomer>.Create;

  //Create mock customers
  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=1;
  tmpCustomer.Name:='John';
  tmpCustomer.DiscountRate:=12.50;
  tmpCustomer.Balance:=-Random(5000);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=2;
  tmpCustomer.Name:='Alex';
  tmpCustomer.DiscountRate:=23.00;
  tmpCustomer.Balance:=-Random(2780);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=3;
  tmpCustomer.Name:='Peter';
  tmpCustomer.DiscountRate:=0.0;
  tmpCustomer.Balance:=-Random(9000);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=4;
  tmpCustomer.Name:='Retail Customer';
  tmpCustomer.DiscountRate:=0.0;
  tmpCustomer.Balance:=0.0;
  fCustomers.Add(tmpCustomer);


  fItems:=TObjectList<TItem>.Create;
  //Create mock items to sell
  tmpItem:=TItem.Create;
  tmpItem.ID:=100;
  tmpItem.Description:='T-shirt';
  tmpItem.Price:=13.55;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=200;
  tmpItem.Description:='Trousers';
  tmpItem.Price:=23.45;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=300;
  tmpItem.Description:='Coat';
  tmpItem.Price:=64.00;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=400;
  tmpItem.Description:='Shirt';
  tmpItem.Price:=28.00;
  fItems.Add(tmpItem);

end;

destructor TDatabase.Destroy;
begin
  fCustomers.Free;
  fItems.Free;
  inherited;
end;

function TDatabase.GetItemFromDescription(const desc: string): TItem;
var
  tmpItem: TItem;
begin
  result:=nil;
  if not Assigned(fItems) then Exit;
  for tmpItem in fItems do
  begin
    if tmpItem.Description=desc then
    begin
      result:=tmpItem;
      exit;
    end;
  end;
end;

function TDatabase.GetItemFromID(const id: Integer): TItem;
var
  tmpItem: TItem;
begin
  result:=nil;
  if not Assigned(fItems) then Exit;
  for tmpItem in fItems do
  begin
    if tmpItem.ID=id then
    begin
      result:=tmpItem;
      exit;
    end;
  end;
end;

function TDatabase.GeTItems: TObjectList<TItem>;
begin
  result:=fItems;
end;

procedure TDatabase.SaveCurrentSales(const currentSales: Currency);
var
  tmpSales: Currency;
  tmpINIFile: TIniFile;
begin
  tmpINIFile:=TIniFile.Create(fFullFileName);
  try
    tmpSales:=tmpINIFile.ReadFloat('Sales','Total Sales',0.00);
    tmpSales:=tmpSales+currentSales;
    tmpINIFile.WriteFloat('Sales','Total Sales', tmpSales);
  finally
    tmpINIFile.Free;
  end;
end;

function TDatabase.GetCustomerFromName(const nameStr: string): TCustomer;
var
  tmpCustomer: TCustomer;
begin
  if not Assigned(fCustomers) then Exit;
  result:=nil;
  for tmpCustomer in fCustomers do
  begin
    if tmpCustomer.Name=nameStr then
    begin
      result:=tmpCustomer;
      exit;
    end;
  end;
end;

function TDatabase.GetCustomerList: TObjectList<TCustomer>;
begin
  result:=fCustomers;
end;

function TDatabase.GetTotalSales: Currency;
var
  tmpINIFile: TIniFile;
  amount: Currency;
begin
  amount:=0.00;
  tmpINIFile:=TIniFile.Create(fFullFileName);
  try
    amount:=tmpINIFile.ReadFloat('Sales','Total Sales',0.00);
  finally
    tmpINIFile.Free;
    result:=amount;
  end;
end;

end.
