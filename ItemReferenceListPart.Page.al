page 84400 "Item Reference List Part"
{
    /*
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Item Reference";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'Viitenumber';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Kauba number';
                    Editable = false;
                }
                field("Item Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Kirjeldus';
                    Editable = false;
                }
            }
        }

    }

    procedure filterReferences(_ItemFilter: Text)
    var
        _ItemRef: Record "Item Reference";
    begin
        Rec.Reset();
        if Rec.IsTemporary() then
            Rec.DeleteAll();
        if _ItemFilter <> '' then begin
            _ItemRef.SetFilter("Item No.", _ItemFilter);
            if _ItemRef.FindSet() then
                repeat
                    Rec := _ItemRef;
                    Rec.Insert();
                until _ItemRef.Next() = 0;
        end;
        CurrPage.Update(false);
    end;
    */
}

