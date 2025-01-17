Attribute VB_Name = "PlainADODBSampleCode"
'@Folder "SQLiteDBdev.Drafts.Basic"
'@IgnoreModule
Option Explicit


Private Sub TestADODBSourceCMDCSV()
    Dim fso As New Scripting.FileSystemObject
    Dim sDriver As String
    Dim sOptions As String
    Dim sDatabase As String
    Dim sDatabaseExt As String
    Dim sTable As String

    Dim AdoConnStr As String
    Dim qtConnStr As String
    Dim sSQL As String
    Dim sQTName As String

    #If Win64 Then
        sDriver = "Microsoft Access Text Driver (*.txt, *.csv)"
    #Else
        sDriver = "{Microsoft Text Driver (*.txt; *.csv)}"
    #End If
    sDatabaseExt = ".csv"
    Dim ProjectName As String
    ProjectName = ThisWorkbook.VBProject.Name
    Dim LibPrefix As String
    LibPrefix = Application.PathSeparator & "Library" & Application.PathSeparator & ProjectName
    sDatabase = ThisWorkbook.Path & LibPrefix
    sTable = "people" & sDatabaseExt
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "DefaultDir=" & sDatabase & ";"

    sSQL = "SELECT * FROM """ & sTable & """"
    sSQL = sTable

    qtConnStr = "OLEDB;" + AdoConnStr

    sSQL = "SELECT * FROM """ & sTable & """ WHERE id <= 45 AND last_name <> 'machinery'"

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    Dim AdoCommand As ADODB.Command
    Set AdoCommand = New ADODB.Command

    With AdoCommand
        .CommandType = adCmdText
        .CommandText = sSQL
        .ActiveConnection = AdoConnStr
        .ActiveConnection.CursorLocation = adUseClient
    End With

    With AdoRecordset
        Set .Source = AdoCommand
        .CursorLocation = adUseClient
        .CursorType = adOpenStatic
        .LockType = adLockReadOnly
        .Open Options:=adAsyncFetch
        Set .ActiveConnection = Nothing
    End With
    AdoCommand.ActiveConnection.Close
End Sub


Private Sub TestADODBSourceSQL()
    Dim sDriver As String
    Dim sOptions As String
    Dim sDatabase As String

    Dim AdoConnStr As String
    Dim qtConnStr As String
    Dim sSQL As String
    Dim sQTName As String

    sDatabase = ThisWorkbook.Path + "\" + "ADODBTemplates.db"
    sDriver = "SQLite3 ODBC Driver"
    sOptions = "SyncPragma=NORMAL;FKSupport=True;"
    AdoConnStr = "Driver=" + sDriver + ";" + _
                 "Database=" + sDatabase + ";" + _
                 sOptions

    qtConnStr = "OLEDB;" + AdoConnStr

    sSQL = "SELECT * FROM people WHERE id <= 45 AND last_name <> 'machinery'"

    Dim AdoConnection As ADODB.Connection
    Set AdoConnection = New ADODB.Connection
    On Error Resume Next
    AdoConnection.Open AdoConnStr
    On Error GoTo 0
    If AdoConnection.State = ADODB.ObjectStateEnum.adStateOpen Then AdoConnection.Close

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseClient
    AdoRecordset.Open Source:=sSQL, ActiveConnection:=AdoConnStr, CursorType:=adOpenStatic, LockType:=adLockReadOnly, Options:=(adCmdText Or adAsyncFetch)
    Set AdoRecordset.ActiveConnection = Nothing
End Sub


Private Sub TestADODBSourceCMD()
    Dim sDriver As String
    Dim sOptions As String
    Dim sDatabase As String

    Dim AdoConnStr As String
    Dim qtConnStr As String
    Dim sSQL As String
    Dim sQTName As String

    sDatabase = ThisWorkbook.Path + "\" + "ADODBTemplates.db"
    sDriver = "SQLite3 ODBC Driver"
    sOptions = "SyncPragma=NORMAL;FKSupport=True;"
    AdoConnStr = "Driver=" + sDriver + ";" + _
                 "Database=" + sDatabase + ";" + _
                 sOptions

    qtConnStr = "OLEDB;" + AdoConnStr

    sSQL = "SELECT * FROM people WHERE id <= 45 AND last_name <> 'machinery'"

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    Dim AdoCommand As ADODB.Command
    Set AdoCommand = New ADODB.Command

    With AdoCommand
        .CommandType = adCmdText
        .CommandText = sSQL
        .ActiveConnection = AdoConnStr
        .ActiveConnection.CursorLocation = adUseClient
    End With

    With AdoRecordset
        Set .Source = AdoCommand
        .CursorLocation = adUseClient
        .CursorType = adOpenStatic
        .LockType = adLockReadOnly
        .Open Options:=adAsyncFetch
        Set .ActiveConnection = Nothing
    End With
    AdoCommand.ActiveConnection.Close
End Sub


Private Sub TestADODBSourceSQLite()
    Dim fso As New Scripting.FileSystemObject
    Dim sDriver As String
    Dim sDatabase As String
    Dim sDatabaseExt As String
    Dim sTable As String
    Dim AdoConnStr As String
    Dim sSQL As String

    sDriver = "SQLite3 ODBC Driver"
    sDatabaseExt = ".db"
    sTable = "people"
    sDatabase = ThisWorkbook.Path & Application.PathSeparator & fso.GetBaseName(ThisWorkbook.Name) & sDatabaseExt
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "Database=" & sDatabase & ";"

    sSQL = "SELECT * FROM """ & sTable & """"

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseClient
    AdoRecordset.Open _
            Source:=sSQL, _
            ActiveConnection:=AdoConnStr, _
            CursorType:=adOpenStatic, _
            LockType:=adLockReadOnly, _
            Options:=(adCmdText Or adAsyncFetch)
    Set AdoRecordset.ActiveConnection = Nothing
End Sub


Private Sub TestADODBSourceCSV()
    Dim fso As New Scripting.FileSystemObject

    Dim sDriver As String
    #If Win64 Then
        sDriver = "Microsoft Access Text Driver (*.txt, *.csv)"
    #Else
        sDriver = "{Microsoft Text Driver (*.txt; *.csv)}"
    #End If
    Dim ProjectName As String
    ProjectName = ThisWorkbook.VBProject.Name
    Dim LibPrefix As String
    LibPrefix = Application.PathSeparator & "Library" & Application.PathSeparator & ProjectName
    Dim sDatabase As String
    sDatabase = ThisWorkbook.Path & LibPrefix
    Dim sDatabaseExt As String
    sDatabaseExt = ".csv"
    Dim sTable As String
    sTable = fso.GetBaseName(ThisWorkbook.Name) & sDatabaseExt
    sTable = "people" & sDatabaseExt
    Dim AdoConnStr As String
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "DefaultDir=" & sDatabase & ";"

    Dim sSQL As String
    sSQL = "SELECT * FROM """ & sTable & """"
    sSQL = sTable

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseClient
    AdoRecordset.Open _
            Source:=sSQL, _
            ActiveConnection:=AdoConnStr, _
            CursorType:=adOpenStatic, _
            LockType:=adLockReadOnly, _
            Options:=(adCmdTable Or adAsyncFetch)
    Set AdoRecordset.ActiveConnection = Nothing
End Sub


Private Sub TestADODBConnectCSV()
    Dim fso As New Scripting.FileSystemObject
    Dim sDriver As String
    Dim sDatabase As String
    Dim sDatabaseExt As String
    Dim sTable As String
    Dim AdoConnStr As String
    Dim sSQL As String

    #If Win64 Then
        sDriver = "Microsoft Access Text Driver (*.txt, *.csv)"
    #Else
        sDriver = "{Microsoft Text Driver (*.txt; *.csv)}"
    #End If
    sDatabaseExt = ".csv"
    sDatabase = ThisWorkbook.Path
    sTable = fso.GetBaseName(ThisWorkbook.Name) & sDatabaseExt
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "DefaultDir=" & sDatabase & ";"

    sSQL = "SELECT * FROM """ & sTable & """"
    sSQL = sTable

    Dim AdoConnection As ADODB.Connection
    Set AdoConnection = New ADODB.Connection
    AdoConnection.ConnectionString = AdoConnStr

    On Error Resume Next
    AdoConnection.Open
    Debug.Print AdoConnection.Errors.Count
    Debug.Print AdoConnection.Properties("Transaction DDL")
    AdoConnection.BeginTrans
    On Error GoTo 0

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseClient
    AdoRecordset.Open _
            Source:=sSQL, _
            ActiveConnection:=AdoConnStr, _
            CursorType:=adOpenStatic, _
            LockType:=adLockReadOnly, _
            Options:=(adCmdTable Or adAsyncFetch)
    Set AdoRecordset.ActiveConnection = Nothing
End Sub


Private Sub TestADODBConnectSQLite()
    Dim fso As New Scripting.FileSystemObject

    Dim sDriver As String
    sDriver = "SQLite3 ODBC Driver"
    Dim sDatabaseExt As String
    sDatabaseExt = ".db"
    Dim sTable As String
    sTable = "people"
    
    Dim ProjectName As String
    ProjectName = ThisWorkbook.VBProject.Name
    Dim LibPrefix As String
    LibPrefix = Application.PathSeparator & "Library" & Application.PathSeparator & ProjectName
    Dim sDatabase As String
    sDatabase = ThisWorkbook.Path & LibPrefix & Application.PathSeparator & "people" & sDatabaseExt
    Dim AdoConnStr As String
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "Database=" & sDatabase & ";"

    Dim sSQL As String
    sSQL = "SELECT * FROM """ & sTable & """"

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseServer
    AdoRecordset.Open _
            Source:=sSQL, _
            ActiveConnection:=AdoConnStr, _
            CursorType:=adOpenStatic, _
            LockType:=adLockReadOnly, _
            Options:=(adCmdText Or adAsyncFetch)
    On Error Resume Next
    Set AdoRecordset.ActiveConnection = Nothing
    On Error GoTo 0
End Sub


Private Sub TestADODBConnectBlankSQLite()
    Dim fso As New Scripting.FileSystemObject

    Dim sDriver As String
    sDriver = "SQLite3 ODBC Driver"
    Dim sDatabaseExt As String
    sDatabaseExt = ".db"
    Dim sTable As String
    sTable = "people"
    
    Dim ProjectName As String
    ProjectName = ThisWorkbook.VBProject.Name
    Dim LibPrefix As String
    LibPrefix = Application.PathSeparator & "Library" & Application.PathSeparator & ProjectName
    Dim sDatabase As String
    sDatabase = vbNullString
    Dim AdoConnStr As String
    AdoConnStr = "Driver=" & sDriver & ";" & _
                 "Database=" & sDatabase & ";"

    Dim sSQL As String
    sSQL = "SELECT * FROM pragma_function_list()"

    Dim AdoRecordset As ADODB.Recordset
    Set AdoRecordset = New ADODB.Recordset
    AdoRecordset.CursorLocation = adUseServer
    AdoRecordset.Open _
            Source:=sSQL, _
            ActiveConnection:=AdoConnStr, _
            CursorType:=adOpenStatic, _
            LockType:=adLockReadOnly, _
            Options:=(adCmdText Or adAsyncFetch)
    On Error Resume Next
    Set AdoRecordset.ActiveConnection = Nothing
    On Error GoTo 0
End Sub
