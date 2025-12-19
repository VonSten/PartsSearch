codeunit 84400 PartsUtil
{
    procedure CorrectItemDescriptions()
    var
        _Item: Record item;
        _description: Text;
        _Counter: Integer;
        _CompleteMessage: Label '%1 item descriptions corrected';

    begin

        if _Item.FindSet() then begin
            repeat
                _description := ApplyTextRules(_Item.Description);
                if _description <> _Item.description then begin
                    _Item.Description := _description;
                    _Item.Modify(false);
                    _Counter += 1;
                end;
            Until _Item.next() = 0;
            Message(_CompleteMessage, _Counter);
        end;
    end;


    procedure ApplyTextRules(_description: Text): Text
    var
        _nbsp: Text;
        _c: Char;
        _value: Text;
        _ValuesToCorrect: List of [Text];
        _Setup: Record "Parts Code Retriever Setup";
    begin
        _c := 160;
        _nbsp := Format(_c);
        _ValuesToCorrect.AddRange(_setup.TextReplaceValues.Split(';'));
        _description := _description.Trim().Replace(_nbsp, ' ');
        foreach _value in _ValuesToCorrect do begin
            _Value := _Value.Trim();
            if _Value <> '' then begin
                _description := _description.Replace(' ' + _Value.Trim(), _Value.Trim());
                _description := _description.Replace(' x ', 'x');
                _description := _description.Replace(' X ', 'X');
                _description := _description.Replace('RAL', ' RAL');
            end;
        end;
        exit(_description.Trim());
    end;

    local procedure CreatePartNumberWithoutPunctuation(_description: Text): Text
    var
        _i: Integer;
        _c: Char;
        _foundCode: Text;
        _stopLoop: Boolean;
    begin
        if _description = '' then exit('');
        _stopLoop := false;
        for _i := 1 to StrLen(_description) do begin
            if _stopLoop then
                break;
            _c := _description[_i];
            case _c of
                '0' .. '9':
                    _foundCode += Format(_c);
                '.', '-', '/', '\', '_':
                    ;
                else
                    _stopLoop := true;
            end;
        end;
        exit(_foundCode.Trim());
    end;

    procedure CreateItemReferenceWithoutPunctuation(Item: Record Item)
    var
        reference: Record "Item Reference";
        partcode: text;
    begin
        partcode := CreatePartNumberWithoutPunctuation(Item.Description);
        if StrLen(partcode) < 3 then
            exit;
        reference.reset();
        reference.SetRange("Item No.", Item."No.");
        reference.SetRange("Reference No.", partcode);
        if reference.FindFirst() then
            exit;
        reference.Init();
        reference.Validate("Item No.", Item."No.");
        reference.Validate("Reference No.", CopyStr(partcode, 1, MaxStrLen(reference."Reference No.")));
        reference.Validate("Reference Type No.", 'XBATCH');
        reference.Validate("Unit of Measure", Item."Base Unit of Measure");
        reference.Insert(false);

    end;


    procedure CreateItemReferencesWithoutPunctuation()
    var
        item: Record "Item";
        doneLabel: Label 'Done!';
    begin
        if item.FindSet then begin
            repeat
                CreateItemReferenceWithoutPunctuation(item);
            until item.next() = 0;
        end;
        Message(doneLabel);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Item: Record Item; var xItem: Record Item)
    var
        PartsUtil: Codeunit "PartsUtil";
    begin
        PartsUtil.CreateItemReferenceWithoutPunctuation(Item);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnModifyOnBeforePlanningAssignmentItemChange', '', false, false)]
    local procedure OnAfterOnModify(var Item: Record Item; xItem: Record Item; PlanningAssignment: Record "Planning Assignment"; var IsHandled: Boolean)
    var
        PartsUtil: Codeunit "PartsUtil";
    begin
        PartsUtil.CreateItemReferenceWithoutPunctuation(Item);
    end;
}