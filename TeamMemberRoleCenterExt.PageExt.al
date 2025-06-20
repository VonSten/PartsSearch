pageextension 84400 "Team Member Role Center Ext" extends "Team Member Role Center"
{


    Caption = 'Varuosaotsing';

    actions
    {
        addfirst(embedding)
        {
            action(PartSearchList)
            {
                ApplicationArea = All;
                Caption = 'Varuosaotsing';
                RunObject = page "Part Search Card";
                ToolTip = 'Varuosaode ja ristviidete otsing';

            }
        }
    }

}