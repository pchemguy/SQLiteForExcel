Attribute VB_Name = "DllManagerDemo"
'@Folder "DllManager"
'@IgnoreModule ProcedureNotUsed, IndexedDefaultMemberAccess, FunctionReturnValueDiscarded
Option Explicit
Option Private Module

#If VBA7 Then
'''' System library
Private Declare PtrSafe Function winsqlite3_libversion_number Lib "WinSQLite3" Alias "sqlite3_libversion_number" () As Long
'''' User library
Private Declare PtrSafe Function sqlite3_libversion_number Lib "SQLite3" () As Long
#Else
'''' System library
Private Declare Function winsqlite3_libversion_number Lib "WinSQLite3" Alias "sqlite3_libversion_number" () As Long
'''' User library
Private Declare Function sqlite3_libversion_number Lib "SQLite3" () As Long
#End If


Private Type TDllManagerDemo
    DllMan As DllManager
End Type
Private this As TDllManagerDemo


Private Sub GetWinSQLite3VersionNumber()
    Debug.Print winsqlite3_libversion_number()
End Sub


Private Sub GetSQLite3VersionNumber()
    SQLiteLoadMultipleArray
    
    Debug.Print sqlite3_libversion_number()
    Set this.DllMan = Nothing
End Sub


Private Sub SQLiteLoadMultipleArray()
    '''' Absolute or relative to ThisWorkbook.Path
    Dim DllPath As String
    Dim DllNames As Variant
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
        DllNames = "sqlite3.dll"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
        DllNames = Array( _
            "icudt68.dll", _
            "icuuc68.dll", _
            "icuin68.dll", _
            "icuio68.dll", _
            "icutu68.dll", _
            "sqlite3.dll" _
        )
    #End If
    Dim DllMan As DllManager
    Set DllMan = DllManager.Create(DllPath)
    Set this.DllMan = DllMan
    DllMan.LoadMultiple DllNames
End Sub


' ========================= '
' Additional usage examples '
' ========================= '
Private Sub SQLiteLoadMultipleArrayCompact()
    '''' Absolute or relative to ThisWorkbook.Path
    Dim DllPath As String
    Dim DllNames As Variant
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
        DllNames = "sqlite3.dll"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
        DllNames = Array( _
            "icudt68.dll", _
            "icuuc68.dll", _
            "icuin68.dll", _
            "icuio68.dll", _
            "icutu68.dll", _
            "sqlite3.dll" _
        )
    #End If
    Dim DllMan As DllManager
    Set DllMan = DllManager.Create(DllPath, DllNames)
    Debug.Assert Not DllMan Is Nothing
End Sub


Private Sub SQLiteLoadMultipleParamArray()
    Dim DllPath As String
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
    #End If
    Dim DllMan As DllManager
    Set DllMan = DllManager.Create(DllPath)
    #If WIN64 Then
        DllMan.LoadMultiple "sqlite3.dll"
    #Else
        DllMan.LoadMultiple _
            "icudt68.dll", _
            "icuuc68.dll", _
            "icuin68.dll", _
            "icuio68.dll", _
            "icutu68.dll", _
            "sqlite3.dll"
    #End If
End Sub


Private Sub SQLiteLoad()
    Dim DllPath As String
    Dim DllNames As Variant
    #If WIN64 Then
        DllPath = "Library\SQLiteCforVBA\dll\x64"
        DllNames = Array("sqlite3.dll")
    #Else
        DllPath = "Library\SQLiteCforVBA\dll\x32"
        DllNames = Array( _
            "icudt68.dll", _
            "icuuc68.dll", _
            "icuin68.dll", _
            "icuio68.dll", _
            "icutu68.dll", _
            "sqlite3.dll" _
        )
    #End If
    Dim DllMan As DllManager
    Set DllMan = DllManager.Create(DllPath)
    Dim DllNameIndex As Long
    For DllNameIndex = LBound(DllNames) To UBound(DllNames)
        Dim DllName As String
        DllName = DllNames(DllNameIndex)
        DllMan.Load DllName, DllPath
    Next DllNameIndex
End Sub
