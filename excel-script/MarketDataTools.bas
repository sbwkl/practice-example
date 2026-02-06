Attribute VB_Name = "MarketDataTools"
Sub RefreshFiles(fileNames As Variant)
    Dim wbSource As Workbook
    Dim fullPath As String
    Dim currentPath As String
    Dim i As Long
    Dim con As Object
    
    currentPath = ActiveWorkbook.path
    
    On Error GoTo ErrorHandler
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    
    For i = LBound(fileNames) To UBound(fileNames)
        fullPath = currentPath & "\" & fileNames(i)
        Application.StatusBar = "Processing: " & fileNames(i)
        
        If Dir(fullPath) <> "" Then
            Set wbSource = Workbooks.Open(fullPath)
            wbSource.RefreshAll
            DoEvents
            wbSource.Close SaveChanges:=True
        Else
            MsgBox "File Not Found: " & fullPath, vbExclamation
        End If
    Next i

    Application.StatusBar = "Refreshing Active Workbook..."
    ActiveWorkbook.RefreshAll
    
    Application.StatusBar = False
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    MsgBox "Global Sync Completed!", vbInformation
    Exit Sub

ErrorHandler:
    Application.StatusBar = False
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    MsgBox "Error: " & Err.Description, vbCritical
End Sub

Sub RefreshMarketDataFund()
    Dim list As Variant
    list = Array("Market-Data-Fund.xlsx")
    Call RefreshFiles(list)
End Sub
