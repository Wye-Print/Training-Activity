page 50002 "Training Activity"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Training Activity';
    SourceTable = "Training Activity Buf";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Employees)
            {
                field("Full Name"; Rec."Full Name")
                {
                    Caption = 'Employee';
                    ToolTip = 'Specifies the employee (Business Central user) credited with the activity.';
                }
                field("Customer"; Rec."Customer")
                {
                    ToolTip = 'Specifies how many customers this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(1); end;
                }
                field("Vendor"; Rec."Vendor")
                {
                    ToolTip = 'Specifies how many vendors this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(2); end;
                }
                field("Item"; Rec."Item")
                {
                    ToolTip = 'Specifies how many items this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(3); end;
                }
                field("Estimate"; Rec."Estimate")
                {
                    ToolTip = 'Specifies how many cases this employee completed an estimate for and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(4); end;
                }
                field("Quote to Order"; Rec."Quote to Order")
                {
                    ToolTip = 'Specifies how many cases this employee moved to order and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(5); end;
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ToolTip = 'Specifies how many sales orders this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(6); end;
                }
                field("Schedule"; Rec."Schedule")
                {
                    ToolTip = 'Specifies how many production orders this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(7); end;
                }
                field("Purchasing"; Rec."Purchasing")
                {
                    ToolTip = 'Specifies how many purchase orders this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(8); end;
                }
                field("Receipt"; Rec."Receipt")
                {
                    ToolTip = 'Specifies how many purchase receipts this employee posted and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(9); end;
                }
                field("Shop Floor"; Rec."Shop Floor")
                {
                    ToolTip = 'Specifies how many shop floor registrations this employee posted and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(10); end;
                }
                field("Released"; Rec."Released")
                {
                    ToolTip = 'Specifies how many positive item ledger entries this employee created and the date of the last one. Drill down for the list.';
                    trigger OnDrillDown() begin DrillCell(11); end;
                }
                field("Completed"; Rec."Completed")
                {
                    ToolTip = 'Specifies how many of the 11 monitored activities this employee has done at least once.';
                    StyleExpr = CompletedStyle;
                }
                field("Last Activity"; Rec."Last Activity")
                {
                    ToolTip = 'Specifies the most recent date this employee did any monitored activity.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Rebuild the activity snapshot from current data.';

                trigger OnAction()
                begin
                    LoadData();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        CompletedStyle: Text;

    trigger OnOpenPage()
    begin
        LoadData();
    end;

    local procedure LoadData()
    var
        TrainingActivityMgt: Codeunit "Training Activity Mgt";
    begin
        TrainingActivityMgt.Build(Rec);
        Rec.SetCurrentKey("Completed", "Last Activity");
        Rec.Ascending(true);
        if Rec.FindFirst() then;
    end;

    local procedure DrillCell(ItemNo: Integer)
    var
        DetailPage: Page "Training Activity Detail";
    begin
        DetailPage.SetContext(Rec."User Security ID", ItemNo, StrSubstNo('%1 - %2', Rec."Full Name", ItemName(ItemNo)));
        DetailPage.Run();
    end;

    local procedure ItemName(ItemNo: Integer): Text
    begin
        case ItemNo of
            1:
                exit('Customer');
            2:
                exit('Vendor');
            3:
                exit('Item');
            4:
                exit('Estimate');
            5:
                exit('Quote to Order');
            6:
                exit('Sales Order');
            7:
                exit('Schedule');
            8:
                exit('Purchasing');
            9:
                exit('Receipt');
            10:
                exit('Shop Floor');
            11:
                exit('Released');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Completed" = 0 then
            CompletedStyle := 'Unfavorable'
        else
            CompletedStyle := 'Favorable';
    end;
}
