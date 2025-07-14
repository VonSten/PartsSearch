page 84407 "Oem Numbers for Items"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Oem Numbers for Items";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field(OemNumber; Rec.OemNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Oem Number';
                }
            }
        }

    }
}