Attribute VB_Name = "SQLiteCHeaderExamples"
'@Folder "SQLiteDBdev.Extra"
Option Explicit


Private Sub ReadDbHeader()
    Dim dbc As SQLiteCConnection
    Set dbc = SQLiteCConnection("blank.db") '''' FixObjC.GetDBCTempInit
    Dim dbh As SQLiteCHeader
    Set dbh = SQLiteCHeader(dbc.DbPathName)
    dbh.LoadHeader
    Set dbc = FixObjC.GetDBCTmpFuncWithData
    Set dbh = SQLiteCHeader(dbc.DbPathName)
    dbh.LoadHeader
End Sub


Private Sub GenDbHeader()
    Dim dbh As SQLiteCHeader
    Set dbh = SQLiteCHeader.Create(vbNullString)
    Dim HeaderBuffer() As Byte
    HeaderBuffer = dbh.GenBlankDbHeader( _
        UserVersion:=&H11223344, ApplicationId:=&HAABBCCDD)
    Dim PackedHeader As SQLiteCHeaderPacked
    PackedHeader = dbh.PackedHeaderFromBytes(HeaderBuffer)
    dbh.UnpackHeader PackedHeader
End Sub
