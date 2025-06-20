page 84404 "Picked Items List"
{
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Picked Items Table";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Nr.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Kirjeldus';
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Kogus';

                }
            }
        }

    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId());
    end;

}