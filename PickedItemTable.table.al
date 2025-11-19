/*
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
    // todo for each warehouse location
    procedure CreateSalesQuoteFromPickedItems(inLocationCode: Code[10])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PickedItem: Record "Picked Items Table";
    begin
        // Header    
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        SalesHeader."Location Code" := inLocationCode;
        SalesHeader."Salesperson Code" := UserId();
        SalesHeader.Insert(true);

        // Content
        PickedItem.SetRange("User ID", UserId());
        if PickedItem.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."No." := PickedItem."Item No.";
                SalesLine.Quantity := PickedItem.Quantity;
                SalesLine.Description := PickedItem.Description;
                SalesLine.Insert();
            until PickedItem.Next() = 0;

    end;

}
*/