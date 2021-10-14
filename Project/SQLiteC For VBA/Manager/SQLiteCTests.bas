Attribute VB_Name = "SQLiteCTests"
'@Folder "SQLiteC For VBA.Manager"
'@TestModule
'@IgnoreModule LineLabelNotUsed, IndexedDefaultMemberAccess, FunctionReturnValueDiscarded
'@IgnoreModule UseMeaningfulName
Option Explicit
Option Private Module

Private Const LITE_LIB As String = "SQLiteCforVBA"
Private Const PATH_SEP As String = "\"
Private Const LITE_RPREFIX As String = "Library" & PATH_SEP & LITE_LIB & PATH_SEP

#Const LateBind = LateBindTests
#If LateBind Then
    Private Assert As Object
#Else
    Private Assert As Rubberduck.PermissiveAssertClass
#End If


'This method runs once per module.
'@ModuleInitialize
Private Sub ModuleInitialize()
    #If LateBind Then
        Set Assert = CreateObject("Rubberduck.PermissiveAssertClass")
    #Else
        Set Assert = New Rubberduck.PermissiveAssertClass
    #End If
End Sub


'This method runs once per module.
'@ModuleCleanup
Private Sub ModuleCleanup()
    Set Assert = Nothing
End Sub


'===================================================='
'===================== FIXTURES ====================='
'===================================================='

Private Function zfxGetDefaultDBM() As SQLiteC
    Dim DllPath As String
    DllPath = LITE_RPREFIX & "dll\" & ARCH
    Dim dbm As SQLiteC
    '''' Using default library names hardcoded in the SQLiteC constructor.
    '@Ignore IndexedDefaultMemberAccess
    Set dbm = SQLiteC(DllPath)
    If dbm Is Nothing Then Err.Raise ErrNo.UnknownClassErr, _
        "SQLiteCTests", "Failed to create an SQLiteC instance."
    Set zfxGetDefaultDBM = dbm
End Function

Private Function zfxGetConnection(ByVal DbPathName As String) As SQLiteCConnection
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM()
    Dim DbConn As SQLiteCConnection
    Set DbConn = dbm.CreateConnection(DbPathName)
    If DbConn Is Nothing Then Err.Raise ErrNo.UnknownClassErr, _
        "SQLiteCTests", "Failed to create an SQLiteCConnection instance."
    Set zfxGetConnection = DbConn
End Function

Private Function zfxGetConnDbRegular() As SQLiteCConnection
    Dim DbPathName As String
    DbPathName = ThisWorkbook.Path & PATH_SEP & LITE_RPREFIX & LITE_LIB & ".db"
    Set zfxGetConnDbRegular = zfxGetConnection(DbPathName)
End Function

Private Function zfxGetConnDbMemory() As SQLiteCConnection
    Dim DbPathName As String
    DbPathName = ":memory:"
    Set zfxGetConnDbMemory = zfxGetConnection(DbPathName)
End Function

Private Function zfxGetConnDbTemp() As SQLiteCConnection
    Dim DbPathName As String
    DbPathName = vbNullString
    Set zfxGetConnDbTemp = zfxGetConnection(DbPathName)
End Function

Private Function zfxGetConnDbInvalidPath() As SQLiteCConnection
    Dim DbPathName As String
    DbPathName = "_:_/\_BAD PATH_<>;"
    Set zfxGetConnDbInvalidPath = zfxGetConnection(DbPathName)
End Function


'===================================================='
'==================== TEST CASES ===================='
'===================================================='


'@TestMethod("SQLiteVersion")
Private Sub ztcSQLite3Version_VerifiesVersionInfo()
    On Error GoTo TestFail

Arrange:
    Dim DllPath As String
    Dim DllNames As Variant
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
        DllNames = "sqlite3.dll"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
        DllNames = Array("icudt68.dll", "icuuc68.dll", "icuin68.dll", "icuio68.dll", "icutu68.dll", "sqlite3.dll")
    #End If
    Dim dbm As SQLiteC
    Set dbm = SQLiteC(DllPath, DllNames)
Act:
    Dim DbConn As SQLiteCConnection
    Set DbConn = dbm.CreateConnection(vbNullString)
    Dim VersionS As String
    VersionS = Replace(DbConn.Version(False), ".", "0") & "0"
    Dim VersionN As String
    VersionN = CStr(DbConn.Version(True))
Assert:
    Assert.AreEqual VersionS, VersionN, "Unfolding error"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("SQLiteVersion")
'@Ignore UseMeaningfulName
Private Sub ztcSQLite3Version_VerifiesVersionInfoV2()
    On Error GoTo TestFail

Arrange:
    Dim DllPath As String
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
    #End If
    Dim dbm As SQLiteC
    Set dbm = SQLiteC(DllPath)
Act:
    Dim DbConn As SQLiteCConnection
    Set DbConn = dbm.CreateConnection(vbNullString)
    Dim VersionS As String
    VersionS = Replace(DbConn.Version(False), ".", "0") & "0"
    Dim VersionN As String
    VersionN = CStr(DbConn.Version(True))
Assert:
    Assert.AreEqual VersionS, VersionN, "Unfolding error"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Factory")
Private Sub ztcCreate_VerifiesDefaultManager()
    On Error GoTo TestFail

Arrange:
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM
Assert:
    Assert.IsNotNothing dbm, "Default manager is not set."

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Factory")
Private Sub ztcGetMainDbId_VerifiesIsNull()
    On Error GoTo TestFail

Arrange:
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM
Assert:
    Assert.IsTrue IsNull(dbm.MainDbId), "Main db is not null."

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Factory")
Private Sub ztcGetDllMan_VerifiesIsSet()
    On Error GoTo TestFail

Arrange:
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM
Assert:
    Assert.IsNotNothing dbm.DllMan, "Dll manager is not set"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("ConnMan")
Private Sub ztcConnDb_VerifiesIsNotSet()
    On Error GoTo TestFail

Arrange:
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM
Assert:
    Assert.IsNothing dbm.ConnDb(vbNullString), "Connection should be nothing"

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Factory")
Private Sub ztcCreate_ThrowsGivenWrongDllBitness()
    On Error Resume Next
    Dim DllPath As String
    Dim DllNames As Variant
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x32"
        DllNames = "sqlite3.dll"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x64"
        DllNames = "sqlite3.dll"
    #End If
    Dim dbm As SQLiteC
    Set dbm = SQLiteC(DllPath, DllNames)
    Guard.AssertExpectedError Assert, LoadingDllErr
End Sub


'@TestMethod("Factory")
Private Sub ztcCreate_ThrowsOnInvalidDllPath()
    On Error Resume Next
    Dim DllPath As String
    DllPath = "____INVALID PATH____"
    Dim dbm As SQLiteC
    Set dbm = SQLiteC(DllPath)
    Guard.AssertExpectedError Assert, ErrNo.FileNotFoundErr
End Sub


'@TestMethod("Connection")
Private Sub ztcCreateConnection_VerifiesSQLiteCConnectionWithValidDbPath()
    On Error GoTo TestFail

Arrange:
    Dim dbc As SQLiteCConnection
    Set dbc = zfxGetConnDbRegular
Assert:
    Assert.IsNotNothing dbc, "Default SQLiteCConnection is not set."

CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


'@TestMethod("Connection")
Private Sub ztcGetDbConn_VerifiesSavedConnectionReference()
    On Error GoTo TestFail

Arrange:
    Dim dbm As SQLiteC
    Set dbm = zfxGetDefaultDBM()
    Dim DbPathName As String
    DbPathName = ThisWorkbook.Path & PATH_SEP & LITE_RPREFIX & LITE_LIB & ".db"
    Dim DbConn As SQLiteCConnection
    Set DbConn = dbm.CreateConnection(DbPathName)
Assert:
    Assert.IsNotNothing DbConn, "Default SQLiteCConnection is not set."
    Assert.AreSame DbConn, dbm.ConnDb(DbPathName)
    
CleanExit:
    Exit Sub
TestFail:
    Assert.Fail "Error: " & Err.Number & " - " & Err.Description
End Sub


