Attribute VB_Name = "SQLiteCConnectionOpenCloseTests"
'@Folder "SQLiteC For VBA.Connection"
'@TestModule
'@IgnoreModule AssignmentNotUsed, LineLabelNotUsed, VariableNotUsed, ProcedureNotUsed, UnhandledOnErrorResumeNext
Option Explicit
Option Private Module

#Const LateBind = LateBindTests
#If LateBind Then
    Private Assert As Object
#Else
    Private Assert As Rubberduck.PermissiveAssertClass
#End If
Private FixObj As SQLiteCTestFixObj


'This method runs once per module.
'@ModuleInitialize
Private Sub ModuleInitialize()
    #If LateBind Then
        Set Assert = CreateObject("Rubberduck.PermissiveAssertClass")
    #Else
        Set Assert = New Rubberduck.PermissiveAssertClass
    #End If
    Set FixObj = New SQLiteCTestFixObj
End Sub


'This method runs once per module.
'@ModuleCleanup
Private Sub ModuleCleanup()
    Set Assert = Nothing
    Set FixObj = Nothing
End Sub


'===================================================='
'==================== TEST CASES ===================='
'===================================================='


'@TestMethod("Connection")
Private Sub ztcCreateConnection_VerifiesSQLiteCConnectionWithValidDbPath()
    On Error GoTo TestFail
    Set FixObj = New SQLiteCTestFixObj

Arrange:
Act:
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbRegular
Assert:
    Assert.IsNotNothing dbc, "Default SQLiteCConnection is not set."
    Assert.AreEqual 0, dbc.DbHandle, "DbHandle must be 0"
    Assert.IsNotNothing dbc.ErrorInfo, "ErrorInfo must be set."

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Connection")
Private Sub ztcGetDbPathName_VerifiesMemoryDbPathName()
    On Error GoTo TestFail

Arrange:
Act:
    Dim DbPathName As String
    DbPathName = ":memory:"
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbMemory
Assert:
    Assert.AreEqual DbPathName, dbc.DbPathName
    
CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Connection")
Private Sub ztcGetDbPathName_VerifiesAnonDbPathName()
    On Error GoTo TestFail

Arrange:
Act:
    Dim DbPathName As String
    DbPathName = vbNullString
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbAnon
Assert:
    Assert.AreEqual DbPathName, dbc.DbPathName
    
CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Connection")
Private Sub ztcAttachedDbPathName_ThrowsOnClosedConnection()
    On Error Resume Next
    
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbMemory
    Debug.Print dbc.DbPathName = dbc.AttachedDbPathName
    
    Guard.AssertExpectedError Assert, ConnectionNotOpenedErr
End Sub


'@TestMethod("Connection")
Private Sub ztcAttachedDbPathName_VerifiesTempDbPathName()
    On Error GoTo TestFail

Arrange:
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbTemp
    Dim ResultCode As SQLiteResultCodes
Act:
    ResultCode = dbc.OpenDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected OpenDb error"
Assert:
    Assert.AreEqual dbc.DbPathName, dbc.AttachedDbPathName, "AttachedDbPathName mismatch."
Cleanup:
    ResultCode = dbc.CloseDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected CloseDb error"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("DbConnection")
Private Sub ztcOpenDbCloseDb_VerifiesWithRegularDb()
    On Error GoTo TestFail

Arrange:
Act:
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbRegular
    Dim ResultCode As SQLiteResultCodes
Assert:
        ResultCode = dbc.OpenDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected OpenDb error"
    Assert.AreNotEqual 0, dbc.DbHandle, "DbHandle must not be 0"
        ResultCode = dbc.CloseDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected CloseDb error"
    Assert.AreEqual 0, dbc.DbHandle, "DbHandle must be 0"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("DbConnection")
Private Sub ztcOpenDbCloseDb_VerifiesWithTempDb()
    On Error GoTo TestFail

Arrange:
Act:
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbAnon
    Dim ResultCode As SQLiteResultCodes
Assert:
        ResultCode = dbc.OpenDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected OpenDb error"
    Assert.AreNotEqual 0, dbc.DbHandle, "DbHandle must not be 0"
        ResultCode = dbc.CloseDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected CloseDb error"
    Assert.AreEqual 0, dbc.DbHandle, "DbHandle must be 0"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("DbConnection")
Private Sub ztcOpenDbCloseDb_VerifiesWithMemoryDb()
    On Error GoTo TestFail

Arrange:
Act:
    Dim dbc As SQLiteCConnection
    Set dbc = FixObj.GetConnDbMemory
    Dim ResultCode As SQLiteResultCodes
Assert:
        ResultCode = dbc.OpenDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected OpenDb error"
    Assert.AreNotEqual 0, dbc.DbHandle, "DbHandle must not be 0"
        ResultCode = dbc.CloseDb
    Assert.AreEqual SQLITE_OK, ResultCode, "Unexpected CloseDb error"
    Assert.AreEqual 0, dbc.DbHandle, "DbHandle must be 0"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub
