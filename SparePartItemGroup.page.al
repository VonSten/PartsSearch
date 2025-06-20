page 84406 SparePartItemGroup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SparePartItemGroup;
    Caption = 'Spare Part Item Group';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Category of Spare Part"; Rec.Category)
                {
                    Caption = 'Category';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(CountParts)
            {
                Caption = 'Count Parts';
                trigger OnAction()
                begin
                    Rec.CountParts();
                end;
            }
        }
    }


}