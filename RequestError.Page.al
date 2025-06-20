page 84405 "Request Error"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Request Error";
    Caption = 'Request Error';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    Caption = 'Error Message';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Delete)
            {
                Caption = 'Delete';
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to delete all records?', false) then
                        Rec.DeleteAll();
                end;
            }
        }
    }


}