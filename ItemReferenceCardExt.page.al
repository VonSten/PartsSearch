page 84410 "Item Referenece Card EXT"
{
    PageType = "CardPart";
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "item reference";
    Caption = 'Item Reference Card';

    layout
    {
        area(Content)
        {
            repeater(References)
            {

                field("Reference No."; rec."Reference No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Reference Type"; rec."Reference Type")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

            }
        }
    }

}