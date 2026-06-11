page 50005 "Training Activity Detail"
{
    Caption = 'Training Activity Detail';
    PageType = List;
    SourceTable = "Training Activity Detail";
    SourceTableTemporary = true;
    SourceTableView = sorting("Activity Date") order(descending);
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Activities)
            {
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies when the activity happened. Drill down to open the actual record.';
                    trigger OnDrillDown()
                    begin
                        OpenRecord();
                    end;
                }
                field("Description"; Rec."Description")
                {
                    ToolTip = 'Specifies the record behind the activity. Drill down to open it.';
                    trigger OnDrillDown()
                    begin
                        OpenRecord();
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenRec)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Image = View;
                Scope = Repeater;
                ToolTip = 'Open the actual record for the selected activity.';

                trigger OnAction()
                begin
                    OpenRecord();
                end;
            }
        }
    }

    var
        ContextUser: Guid;
        ContextItem: Integer;
        ContextCaption: Text;

    procedure SetContext(UserSID: Guid; ItemNo: Integer; CaptionText: Text)
    begin
        ContextUser := UserSID;
        ContextItem := ItemNo;
        ContextCaption := CaptionText;
    end;

    trigger OnOpenPage()
    var
        TrainingActivityMgt: Codeunit "Training Activity Mgt";
    begin
        TrainingActivityMgt.BuildDetail(ContextUser, ContextItem, Rec);
        if ContextCaption <> '' then
            CurrPage.Caption := ContextCaption;
        if Rec.FindFirst() then;
    end;

    local procedure OpenRecord()
    var
        TrainingActivityMgt: Codeunit "Training Activity Mgt";
    begin
        TrainingActivityMgt.OpenRecord(Rec."Record ID");
    end;
}
