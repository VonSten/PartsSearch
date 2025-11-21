page 84403 "Part Search List Page"
{


    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = Item;
    Caption = 'Part Search List';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Nr.';
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        _PickedItem: Record "Picked Items Table";
                        _Varuosa_otsas: Label 'Varuosa %1 on laost otsas';
                        _Kinnitus: Label 'Kas soovid varuosa %1 lisada valitud osade hulka?';
                        _Varuosa_lisatud: Label 'Varuosa %1 on juba valitud';
                    begin
                        if (Rec.Inventory <= 0) then
                            Message(StrSubstNo(_Varuosa_otsas, Rec.Description));
                        if _PickedItem.Get(Rec."No.", UserId()) then begin
                            Message(StrSubstNo(_Varuosa_lisatud, Rec.Description));
                            exit;
                        end;
                        if Confirm(StrSubstNo(_Kinnitus, Rec.Description)) then
                            _PickedItem.Init();
                        _PickedItem.Validate("Item No.", Rec."No.");
                        _PickedItem.Validate(Description, Rec.Description);
                        _PickedItem.Validate("User ID", UserId());
                        _PickedItem.Validate("Quantity", 1.0);
                        _PickedItem.Insert();
                        CurrPage.Update(false);

                    end;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Kirjeldus';
                    Editable = false;
                }
                field("Inventory"; Rec."Inventory")
                {
                    ApplicationArea = All;
                    Caption = 'Varud';
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Item Availability by Location", Rec);
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Liik';
                    Editable = false;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'Varud';
                    Editable = false;
                }
            }
        }
    }

    var
        SearchText: Text;

    procedure SearchParts(inSearchtext: Text; inLocationCode: Code[10]): Text;
    var
        _Item: Record Item;
        _ItemReference: Record "Item Reference";
        _ItemFilter: Text;
        _ItemFilterCounter: Integer;

    begin
        inSearchtext := inSearchtext.Trim();
        Rec.Reset();
        _ItemReference.Reset();
        DelCurrRec();
        _Item.Reset();
        _Item.SetFilter("No.", '*' + inSearchtext + '*');
        if _Item.FindSet() then
            repeat
                Rec := _Item;
                Rec.Insert();
            until _Item.Next() = 0;
        _Item.Reset();
        _Item.SetFilter(Description, '*' + inSearchtext + '*');
        if _Item.FindSet() then
            repeat
                if not Rec.Get(_Item."No.") then begin
                    Rec := _Item;
                    Rec.Insert();
                end;
            until _Item.Next() = 0;
        _ItemReference.Reset();
        _ItemReference.SetFilter("Reference No.", '*' + inSearchtext + '*');
        if _ItemReference.FindSet() then
            repeat
                if not Rec.Get(_ItemReference."Item No.") then begin
                    _Item.Reset();
                    _Item.SetRange("No.", _ItemReference."Item No.");
                    if _Item.FindFirst() then begin
                        Rec := _Item;
                        Rec.Insert();
                    end;
                end;
            until _ItemReference.Next() = 0;

        if Rec.FindSet() then
            repeat
                if _ItemFilter <> '' then
                    _ItemFilter += '|';
                _ItemFilter += Rec."No.";
                _ItemFilterCounter += 1;
                if _ItemFilterCounter > 2000 then
                    break; // Up to 2100 records per filter supported
            until Rec.Next() = 0;
        //todo this block
        if inLocationCode <> '' then begin
            Rec.Reset();                           // keeps temp records, clears filters
            Rec.SetRange("Location Filter", inLocationCode); // FlowFilter, not real field
        end;

        SearchText := '';
        exit(_ItemFilter);
    end;


    trigger OnOpenPage()
    begin
        SearchText := '';
    end;

    procedure DelCurrRec()
    begin
        if Rec.IsTemporary() then
            Rec.DeleteAll();
    end;

}
