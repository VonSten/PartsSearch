report 84400 "Parts Code Retriever"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Parts Code Retriever';
    UseRequestPage = true;

    trigger OnInitReport()
    begin
        ProcessItems();
    end;



    local procedure ProcessItems()
    var
        _SparePartItemGroup: Record SparePartItemGroup;
        _Item: Record Item;
        Counter: Integer;
        PartNo: Text;
        _RequestError: Record "Request Error";
    begin
        if _SparePartItemGroup.FindSet() then
            repeat
                _Item.SetRange("Item Category Code", _SparePartItemGroup.Category);
                if _Item.FindSet() then
                    repeat
                        if (StrPos(_Item.Description, ' ') > 0) then begin
                            PartNo := GetPartNo(_Item.Description);
                            if Partno <> '' then begin
                                SaveOemNumber(_Item."No.", PartNo);
                                HttpRequestPartCodes(PartNo, _Item.Description, _Item."No.", _Item."Base Unit of Measure");
                                Counter := Counter + 1;
                            end;
                            Sleep(150);
                        end;
                    until _Item.Next() = 0;
            until _SparePartItemGroup.Next() = 0;
        _RequestError.Reset();
        _RequestError.Init();
        _RequestError.Description := Format(CurrentDateTime());
        _RequestError.ErrorMessage := 'Finished with count: ' + Format(Counter);
        _RequestError.Insert();
    end;

    local procedure HttpRequestPartCodes(partNo: text; partDescription: Text; itemWarehouseNo: Code[20]; baseUnitOfMeasure: Code[10])
    var
        _Setup: Record "Parts Code Retriever Setup";
        _RequestError: Record "Request Error";
        _HttpClient: HttpClient;
        _RapidApiHost: Label 'tecdoc-catalog.p.rapidapi.com';
        _url: Text;
        _response: HttpResponseMessage;
        _headers: HttpHeaders;
        _ErrorMessage: Label 'GET Request failed %1';
        _jsonResponse: Text;
        _jsonArray: JsonArray;
        _jsonToken: JsonToken;
        _oemArray: JsonArray;
        _oemToken: JsonToken;
        _oemDisplayNo: Text;
        _oemNoToken: JsonToken;
        _oemDisplayNoToken: JsonToken;
        _ItemReference: Record "Item Reference";

    begin
        _Setup.Get();
        _Setup.TestField("API Key");
        _Setup.TestField("Main url");
        _Setup.TestField("Sub url");
        _HttpClient.Timeout := 10000;
        _url := _Setup."Main url" + _Setup."Sub url" + partNo;
        _headers := _HttpClient.DefaultRequestHeaders();
        _headers.Add('X-Rapidapi-Key', _Setup."API Key");
        _headers.Add('X-Rapidapi-Host', _RapidApiHost);
        _HttpClient.Get(_url, _response);
        if not _response.IsSuccessStatusCode then begin
            _RequestError.Reset();
            _RequestError.Init();
            _RequestError.ErrorMessage := _response.ReasonPhrase();
            _RequestError.Description := partNo;
            _RequestError.Insert();
            exit;
        end;
        if not _response.Content().ReadAs(_jsonResponse) then
            exit;
        if _jsonArray.ReadFrom(_jsonResponse) then begin
            if _jsonArray.Count() > 0 then begin
                _jsonArray.Get(0, _jsonToken);

                if _jsonToken.AsObject().Get('oemNo', _oemNoToken) then begin
                    _oemArray := _oemNoToken.AsArray();
                    foreach _oemToken in _oemArray do begin
                        if _oemToken.AsObject().Get('oemDisplayNo', _oemDisplayNoToken) then begin
                            _oemDisplayNo := _oemDisplayNoToken.AsValue().AsText();
                            if not _ItemReference.Get(itemWarehouseNo, '', baseUnitOfMeasure, _ItemReference."Reference Type"::Vendor, 'XTECDOCAPI', _oemDisplayNo) then begin
                                _ItemReference.Reset();
                                _ItemReference.Init();
                                _ItemReference."Reference No." := _oemDisplayNo;
                                _ItemReference."Reference Type" := _ItemReference."Reference Type"::Vendor;
                                _ItemReference."Reference Type No." := 'XTECDOCAPI';
                                _ItemReference."Item No." := itemWarehouseNo;
                                _ItemReference.Description := partDescription;
                                _ItemReference."Unit of Measure" := baseUnitOfMeasure;
                                _ItemReference.Insert();
                            end;
                        end;
                    end;
                end;
            end
            else
                exit;
        end;
    end;

    local procedure GetPartNo(partDescription: Text): Text
    var
        _HttpClient: HttpClient;
        _OpenAIHost: Label 'https://api.openai.com/v1/responses';
        _OpenAIKKey: Label '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';
        _Content: Label 'Extract OEM part numbers (i.e., vehicle manufacturer-specific codes) from the input text string. Known OEM vehicle manufacturers include: Solaris, VW, VAG, Renault, Volvo, MAN, Mercedes-Benz, Scania, Isuzu, Citroën, Ford, and other automobile or truck manufacturers. You may include other recognized car/truck makers if clearly identifiable. Ignore and do not return any third-party spare part numbers, such as from: ZF, Knorr, Wabco, Bosch, Febi, Textar, etc. A part number is valid only if it''s tied to a vehicle manufacturer (OEM). If the string contains multiple OEM part numbers, return only the first. Keep the exact formatting (dashes, spaces, or prefixes like ''A'') of the OEM part number. If no OEM part number is found, return an empty string. Examples of valid OEM part numbers: 303496 (Scania) 2K5698151E (VW/VAG) 36.25514-0038 (MAN) OPTI-030-400 (Solaris) 9064202385, A9064203085 (Mercedes-Benz) 1444CZ (Citroën) 22033561 (Volvo) 1322152 (Ford) 226A42790R (Renault) Do not return part numbers that appear with or near the keywords: ZF, Knorr, Wabco, Bosch, Febi, Textar, or any other known 3rd party spare parts brands — even if the format resembles an OEM part number. If a part number is followed or preceded by ZF, Knorr, or similar, consider it 3rd party and ignore it. Do not return anything from a string where all numbers are associated with 3rd party brands. Only answer with part number or empty string';
        _Headers: HttpHeaders;
        _Response: Text;
        _OpenAIModel: Label 'gpt-4o-mini';
        _RequestObject: JsonObject;
        _RequestNestedObjectSystem: JsonObject;
        _RequestNestedObjectUser: JsonObject;
        _RequestArray: JsonArray;
        _ResponseJsonObject: JsonObject;
        _OutputArray: JsonArray;
        _OutputToken: JsonToken;
        _ContentArray: JsonArray;
        _ContentToken: JsonToken;
        _ResultText: Text;
        _HttpContent: HttpContent;
        _HttpResponse: HttpResponseMessage;
        _RequestJson: Text;
        _RequestError: Record "Request Error";
    begin
        _HttpClient.Timeout := 10000;
        _Headers := _HttpClient.DefaultRequestHeaders();
        _Headers.Add('Authorization', 'Bearer ' + _OpenAIKKey);
        _RequestNestedObjectSystem.Add('role', 'system');
        _RequestNestedObjectSystem.Add('content', _Content);
        _RequestNestedObjectUser.Add('role', 'user');
        _RequestNestedObjectUser.Add('content', partDescription);
        _RequestArray.Add(_RequestNestedObjectSystem);
        _RequestArray.Add(_RequestNestedObjectUser);
        _RequestObject.Add('model', _OpenAIModel);
        _RequestObject.Add('input', _RequestArray);
        _RequestJson := Format(_RequestObject);
        _HttpContent.WriteFrom(_RequestJson);
        _HttpContent.GetHeaders(_Headers);
        _Headers.Remove('Content-Type');
        _Headers.Add('Content-Type', 'application/json');
        if _HttpClient.Post(_OpenAIHost, _HttpContent, _HttpResponse) then begin
            if _HttpResponse.IsSuccessStatusCode then begin
                if _HttpResponse.Content().ReadAs(_Response) then begin
                    _ResponseJsonObject.ReadFrom(_Response);
                    _ResponseJsonObject.Get('output', _OutputToken);
                    _OutputArray := _OutputToken.AsArray();
                    _OutputArray.Get(0, _OutputToken);
                    _OutputToken.AsObject().Get('content', _OutputToken);
                    _ContentArray := _OutputToken.AsArray();
                    _ContentArray.Get(0, _ContentToken);
                    _ContentToken.AsObject().Get('text', _OutputToken);
                    _ResultText := _OutputToken.AsValue().AsText();
                    exit(_ResultText);
                end;
            end else begin
                _RequestError.Reset();
                _RequestError.Init();
                _RequestError.ErrorMessage := _HttpResponse.ReasonPhrase();
                _RequestError.Description := partDescription;
                _RequestError.Insert();
            end;
        end;
        exit('');

    end;

    local procedure SaveOemNumber(itemNo: Code[20]; OEMNo: Text);
    var
        _OemNumbersForItems: Record "Oem Numbers for Items";
    begin
        _OemNumbersForItems.Reset();
        if not _OemNumbersForItems.Get(itemNo) then begin
            _OemNumbersForItems.Init();
            _OemNumbersForItems.ItemNo := itemNo;
            _OemNumbersForItems.OemNumber := OEMNo;
            _OemNumbersForItems.Insert();
        end;
    end;

}