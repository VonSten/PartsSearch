
table 84401 "Picked Items Table"
{

    Caption = 'Picked Items Table';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Item Name';
        }
        field(3; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            trigger OnValidate()
            var
                _Item: Record Item;
                _Label: Label 'Hetke Laoseis %1 tk';
            begin
                _Item.Reset();
                _Item.Get("Item No.");
                _Item.CalcFields(Inventory);
                if ("Quantity" > _Item."Inventory") then begin
                    message(StrSubstNo(_Label, format(_Item."Inventory")));
                end;
            end;
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(PK; "Item No.", "User ID")
        {
            Clustered = true;
        }

    }
    procedure CreateSalesQuoteFromPickedItems()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PickedItem: Record "Picked Items Table";
        SalesLineNo: Integer;
        PickedItemHeader: Record "PickedItemsHeader";
        PartSearchCardPage: Page "Part Search Card";
    begin
        // Header
        PickedItemHeader.SetRange(UserID, UserId());
        if not PickedItemHeader.FindFirst() then
            exit;
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        Salesheader.Validate("Sell-to Customer No.", PickedItemHeader.SellToCustomerNo);
        SalesHeader."Salesperson Code" := UserId();
        SalesHeader.Insert(true);
        SalesHeader.Validate("Location Code", PickedItemHeader.LocationCode);
        SalesHeader.Modify(true);

        SalesLineNo := 10000;

        // Content
        PickedItem.SetRange("User ID", UserId());
        if PickedItem.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", PickedItem."Item No.");
                SalesLine.Validate(Quantity, PickedItem.Quantity);
                SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                SalesLine.Validate("Line No.", SalesLineNo);
                SalesLine."Location Code" := PickedItemHeader.LocationCode;
                SalesLine.Insert(true);
                SalesLineNo += 10000;
            until PickedItem.Next() = 0;
        PartSearchCardPage.clearSearch();
        Page.Run(Page::"Sales Quote", SalesHeader);
    end;

}
