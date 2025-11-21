page 84402 "Part Search Card"
{

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Varuosade otsing';

    layout
    {
        area(Content)

        {
            field(Location; Location)
            {
                ApplicationArea = All;
                Caption = 'Lao kood';
                ToolTip = 'Lao kood';
                TableRelation = Location;
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    InitializeOrUpdatePickedItemsHeader();
                end;
            }
            field(SellToCustomerNo; SellToCustomerNo)
            {
                ApplicationArea = All;
                Caption = 'Kliendi kood';
                ToolTip = 'Kliendi kood';
                TableRelation = Customer;
                trigger OnValidate()
                begin
                    InitializeOrUpdatePickedItemsHeader();
                end;
            }

            group(Filter)
            {
                field(SearchText; SearchText)
                {
                    ApplicationArea = All;
                    Caption = 'Otsing';
                    ToolTip = 'Otsi varuosi OEM koodi, kirjelduse või laokoodi järgi';
                    trigger OnValidate()
                    begin
                        SearchParts(SearchText, Location);
                    end;
                }
            }

            part(PickedItemsList; "Picked Items List")
            {
                ApplicationArea = All;
                Caption = 'Valitud osad';
            }
            part(ItemList; "Part Search List Page")
            {
                ApplicationArea = All;
                Caption = 'Otsingu tulemused';
            }
            part(ReferenceList; "Item Reference List Part")
            {
                ApplicationArea = All;
                Caption = 'Varuosade viited otsingule';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateSalesQuote)
            {
                ApplicationArea = All;
                Caption = 'Loo müügipakkumine';
                ToolTip = 'Loo müügipakkumine valitud osadest';
                Promoted = true;
                trigger OnAction()
                begin
                    CreateSalesQuoteFromParts();
                end;
            }
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Tühjenda nimekiri';
                ToolTip = 'Tühjenda nimekiri valitud osadest';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Delete;

                trigger OnAction()
                var
                    _Confirm: Label 'Kas soovid nimekirja tühjendada?';

                begin
                    if Confirm(_Confirm) then begin
                        clearSearch();
                        CurrPage.ItemList.Page.DelCurrRec();
                        CurrPage.Update(false);

                    end;

                end;
            }
        }

    }

    var
        SearchText: Text;
        Location: Code[10];
        SellToCustomerNo: Code[20];

    trigger OnOpenPage()
    begin
        LoadPickedItemsHeader();
    end;

    procedure clearSearch()
    var
        _PickedItems: Record "Picked Items Table";
        _ItemReference: Record "Item Reference" temporary;
    begin
        _PickedItems.Reset();
        _PickedItems.SetRange("User ID", UserId());
        _PickedItems.DeleteAll();
        DeletePickedItemsHeader();
        _ItemReference.Reset();


    end;

    local procedure SearchParts(inSearchtext: Text; InLocationCode: Code[10])
    var
        _ItemReference: Record "Item Reference" temporary;
        _ItemFilter: Text;
    begin
        _ItemFilter := CurrPage.ItemList.Page.SearchParts(inSearchtext, InLocationCode);
        CurrPage.ReferenceList.Page.filterReferences(_ItemFilter);
        CurrPage.Update(false);
    end;

    local procedure CreateSalesQuoteFromParts()
    var
        _SalesQuote: Record "Sales Header";
        _PikedItemsTable: Record "Picked Items Table";

    begin
        if SellToCustomerNo = '' then begin
            Error('Palun määra kliendi kood enne müügipakkumise loomist.');
        end;
        if Location <> '' then begin
            if Confirm('Kas soovid müügipakkumise sisestada?', true) then begin
                _PikedItemsTable.CreateSalesQuoteFromPickedItems();
                CurrPage.Close();
            end;
        end;
    end;

    local procedure InitializeOrUpdatePickedItemsHeader()
    var
        _PickedItemsHeader: Record "PickedItemsHeader";

    begin
        _PickedItemsHeader.SetRange(UserID, UserId());
        if _PickedItemsHeader.FindFirst() then begin
            _PickedItemsHeader.Validate(SellToCustomerNo, SellToCustomerNo);
            _PickedItemsHeader.Validate(LocationCode, Location);
            _PickedItemsHeader.Modify();
        end else begin
            _PickedItemsHeader.Init();
            _PickedItemsHeader.Validate(SellToCustomerNo, SellToCustomerNo);
            _PickedItemsHeader.Validate(LocationCode, Location);
            _PickedItemsHeader.Validate(UserID, UserId());
            _PickedItemsHeader.Insert();
        end;

    end;

    local procedure DeletePickedItemsHeader()
    var
        _PickedItemsHeader: Record "PickedItemsHeader";

    begin
        _PickedItemsHeader.SetRange(UserID, UserId());
        if _PickedItemsHeader.FindFirst() then begin
            _PickedItemsHeader.Delete();
        end;
        Location := '';
        SellToCustomerNo := '';
        SearchText := '';
        CurrPage.Update(false);
    end;

    local procedure LoadPickedItemsHeader()
    var
        _PickedItemsHeader: Record "PickedItemsHeader";
    begin
        _PickedItemsHeader.SetRange(UserID, UserId());
        if _PickedItemsHeader.FindFirst() then begin
            SellToCustomerNo := _PickedItemsHeader.SellToCustomerNo;
            Location := _PickedItemsHeader.LocationCode;
            CurrPage.Update(false);
        end;
    end;


}