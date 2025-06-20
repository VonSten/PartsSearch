page 84402 "Part Search Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Varuosade otsing';

    layout
    {
        area(Content)
        {
            group(Filter)
            {
                field(SearchText; SearchText)
                {
                    ApplicationArea = All;
                    Caption = 'Otsing';
                    ToolTip = 'Otsi varuosi OEM koodi, kirjelduse või laokoodi järgi';
                    trigger OnValidate()
                    begin
                        SearchParts(Searchtext);
                    end;
                }
            }
            field(Location; Location)
            {
                ApplicationArea = All;
                Caption = 'Lao kood';
                ToolTip = 'Lao kood';
                TableRelation = Location;
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
                Caption = 'Loo müügitellimus';
                ToolTip = 'Loo müügitellimus valitud osadest';
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
                    _PickedItems: Record "Picked Items Table";
                begin
                    if Confirm(_Confirm) then begin
                        _PickedItems.Reset();
                        _PickedItems.SetRange("User ID", UserId());
                        _PickedItems.DeleteAll();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        SearchText: Text;
        Location: Code[10];

    local procedure SearchParts(inSearchtext: Text)
    var
        _ItemReference: Record "Item Reference" temporary;
        _ItemFilter: Text;
    begin
        _ItemFilter := CurrPage.ItemList.Page.SearchParts(inSearchtext);
        CurrPage.ReferenceList.Page.filterReferences(_ItemFilter);
        CurrPage.Update(false);
    end;

    local procedure CreateSalesQuoteFromParts()
    var
        _SalesQuote: Record "Sales Header";
        _PikedItemsTable: Record "Picked Items Table";

    begin
        if Location <> '' then begin
            if Confirm('Kas soovid müügitellimuse sisestada?', true) then
                _PikedItemsTable.CreateSalesQuoteFromPickedItems(Location);
        end;
    end;


}