
Public Function fn_CloseProcessByname(strProcessName)
	fn_CloseProcessByname=True
	
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_CloseProcessByname" , "Inside the Function")
	
	If strProcessName="" Then
'		print "Process name is empty"
		Call fn_Logging ("DEBUG"  , "fn_CloseProcessByname" , "Process name is empty")
		Exit Function
	End If
	
	systemutil.CloseProcessByName (strProcessName)
	
	If Err.Number <> 0 Then
'		print "Run time error " + Err.Number
		Call fn_Logging ("ERROR"  , "fn_CloseProcessByname" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CloseProcessByname=False
	Else
'		print "Successfully Closed the process " + strProcessName
		Call fn_Logging ("DEBUG"  , "fn_CloseProcessByname" , "Successfully Closed the process " + strProcessName)
	End If
	
End Function

Public Function fn_ResetGlobalVariable
	fn_ResetGlobalVariable=True
	
	On Error Resume Next
	Err.Clear
	
	gintTCPassCount=0
	gintTCFailCount=0
	gintTCWarningCount=0
	gstrTCStatus="Failed"
	
End Function

Public Function fn_ValidateFrameworFolders()
	fn_ValidateFrameworFolders=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_ValidateFrameworFolders" , "Inside the Function")
	
	strFrameworkRootFolder=Environment("FrameworkRootFolder")
	strConfigFolder=strFrameworkRootFolder + "\" + Environment("ConfigFolder")
	strFunctionLibraryFolder=strFrameworkRootFolder + "\" + Environment("FunctionLibraryFolder")
	strObjectRepositoryFolder=strFrameworkRootFolder + "\" + Environment("ObjectRepositoryFolder")
	strTestDriverFolder=strFrameworkRootFolder + "\" + Environment("TestDriverFolder")
	strTestRunResultFolder=strFrameworkRootFolder + "\" + Environment("TestRunResultFolder")
	
	if NOT fn_FolderExist(strConfigFolder) Then
		fn_ValidateFrameworFolders=False
	End if
	
	if NOT fn_FolderExist(strFunctionLibraryFolder) Then
		fn_ValidateFrameworFolders=False
	End if
	
	if NOT fn_FolderExist(strObjectRepositoryFolder) Then
		fn_ValidateFrameworFolders=False
	End if
	
	if NOT fn_FolderExist(strTestDriverFolder) Then
		fn_ValidateFrameworFolders=False
	End if
	
	if NOT fn_FolderExist(strTestRunResultFolder) Then
		fn_ValidateFrameworFolders=False
	End if
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_ValidateFrameworFolders" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ValidateFrameworFolders=False
	End If
	
End Function

Public Function fn_FolderExist(strFolderPath)
	fn_FolderExist=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_FolderExist" , "Inside the Function")
	
	Set objFSO=CreateObject("Scripting.FileSystemObject")
	if Not objFSO.FolderExists(strFolderPath ) Then 
'		Print "Folder " + strFolderPath + " does not exist"
		Call fn_Logging ("DEBUG"  , "fn_FolderExist", "Folder " + strFolderPath + " does not exist")
		fn_FolderExist=False
	Else
'		Print "Folder " + strFolderPath + " exists"
		Call fn_Logging ("DEBUG"  , "fn_FolderExist", "Folder " + strFolderPath + " exists")
	End If
	
	Set objFSO=Nothing
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_FolderExist" , " Run Time error " + Err.Description)
		Err.Clear
		fn_FolderExist=False
	End If
	
End Function

Public Function fn_FileExists(strFilePath)
	fn_FileExists=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_FileExists" , "Inside the Function")
	
	Set objFSO=CreateObject("Scripting.FileSystemObject")
	if Not objFSO.FileExists(strFilePath ) Then 
'		Print "File " + strFilePath + " does not exist"
		Call fn_Logging ("DEBUG"  , "fn_FileExists ", "FIle "+ strFilePath + " does not exist")
		
		fn_FileExists=False
	Else
'		Print "File " + strFilePath + " exists"
		Call fn_Logging ("DEBUG"  , "fn_FileExists" , "File " + strFilePath + " exists")
	End If
	
	Set objFSO=Nothing
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_FileExists" , " Run Time error " + Err.Description)
		Err.Clear
		fn_FileExists=False
	End If
	
End Function

Public Function fn_Logging(strLogLevel,strFunctionName,strLogString)
	fn_Logging=True
	
	On Error Resume Next
	Err.Clear
	
	strLoglevelFlag=Environment("LOGLEVEL")
	
	If (instr(strLoglevelFlag,strLogLevel)) <= 0 and (NOT strLogLevel=ERROR)   Then
		Exit Function
	End If
	
	strLogFile=gResultFolder +"\" + gLogFile 
	intAppend=8
	strNow=MonthName(Month(Date),True) + " " + cstr(Day (Date)) + " " + cstr(Year(Date)) + " : " + cstr(Time)
		
	Set objFso=CreateObject ("Scripting.FileSystemObject")
	If (NOT objFso.FileExists(strLogFile)) Then
		If Ucase(strLogLevel)="ERROR" Then
			print strNow + "  : " + strLogLevel + " : " + strFunctionName + " : " +  strLogString
			call fn_ReportResult(strFunctionNam,strLogString,"FAILED","IMG_NO")
		End If
		Exit Function
	End If
	
	Set objFStream=objFso.OpenTextFile(strLogFile,intAppend)
'	objFStream.Write strNow + "  : " + strLogLevel + " : " + strFunctionName + " : " +  strLogString
'	objFstream.WriteBlankLines(1)
	objFStream.WriteLine strNow + "  : " + strLogLevel + " : " + strFunctionName + " : " +  strLogString
	
	If Ucase(strLogLevel)="ERROR"  Then
		print strNow + "  : " + strLogLevel + " : " + strFunctionName + " : " +  strLogString
	End If
	
	Set objFStream=Nothing
	Set objFso=Nothing
	
	If err.Number <> 0 Then
		print strNow + "  : fn_Logging: Run Time error " + Err.Description
		Err.Clear
		fn_Logging=False
	End If
	
End Function

Public Function fn_ValidateFrameworResources
	fn_ValidateFrameworResources=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_ValidateFrameworResources" , "Inside the Function") 
	
	Dim strFrameworkRootFolder
	Dim strTestDriverFile	
	Dim strTestDriverSheetName
	
	strFrameworkRootFolder=Environment("FrameworkRootFolder")
	strTestDriverFile=Environment("FrameworkRootFolder") + "\" + Environment("TestDriverFolder")+ "\" +Environment("TestDriverName")
	
	strTestDriverSheetName=Environment("TestDriverSheets")   
	strTestDriverSheet= split(strTestDriverSheetName,"|")(0)
	strTestScriptSheet= split(strTestDriverSheetName,"|")(1)
	StrTestDataSheet=split(strTestDriverSheetName,"|")(2)
	
	
	If NOT fn_FileExists(strTestDriverFile) Then
		fn_ValidateFrameworResources=False
	End If
	
	If NOT fn_ValidateExcelSheetName(strTestDriverFile,strTestDriverSheet) Then
		fn_ValidateFrameworResources=False
	End If
	
	If NOT fn_ValidateExcelSheetName(strTestDriverFile,strTestScriptSheet) Then
		fn_ValidateFrameworResources=False
	End If
	
	If NOT fn_ValidateExcelSheetName(strTestDriverFile,StrTestDataSheet) Then
		fn_ValidateFrameworResources=False
	End If
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_ValidateFrameworResources" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ValidateFrameworResources=False
	End If
	
End Function

Public Function fn_ValidateExcelSheetName(strExcel,strSheetName)
	fn_ValidateExcelSheetName=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_ValidateExcelSheetName" , "Inside the Function") 
	
	Dim blnFound
	
	blnFound=False
	
	Set objExcel=CreateObject("Excel.Application")
	Set ObjWb=objExcel.Workbooks.open(strExcel)
	intSheetCount=objWb.Worksheets.Count
	
	For sheet= 1 To intSheetCount Step 1
		If Trim(objWb.Worksheets(sheet).name)=Trim(strSheetName) Then
			blnFound=True
			Exit For	
		End If
	Next
	
	if Not blnFound Then 
'		Print strSheetName + " sheet does NOT exist in excel " + strExcel
		Call fn_Logging ("ERROR"  , "fn_ValidateExcelSheetName" , strSheetName + " sheet does NOT exist in excel " + strExcel)
		fn_ValidateExcelSheetName=False
	Else
'		Print strSheetName + " sheet exists in excel " + strExcel
		Call fn_Logging ("DEBUG", "fn_ValidateExcelSheetName" , strSheetName + " sheet exists in excel " + strExcel)
	End If
	
	objWb.Close
	Set ObjWb=Nothing
	Set objExcel=Nothing
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR" , "fn_ValidateExcelSheetName" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ValidateExcelSheetName=False
	End If
	
End Function

Public Function fn_ImportDriverSheet()
	
	fn_ImportDriverSheet=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("INFO"  , "fn_ImportDriverSheet" , "Inside the Function") 
	
	Dim strTestDriverFile	
	Dim strTestDriverSheetName
	
	strFrameworkRootFolder=Environment("FrameworkRootFolder")
	strTestDriverFile=Environment("FrameworkRootFolder") + "\" + Environment("TestDriverFolder")+ "\" +Environment("TestDriverName")
	
	strTestDriverSheetName=Environment("TestDriverSheets")   
	strTestDriverSheet= split(strTestDriverSheetName,"|")(0)
	
	DataTable.ImportSheet strTestDriverFile,strTestDriverSheet,1
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_ImportDriverSheet" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ImportDriverSheet=False
	Else 
'		Print "Driver sheet is imported to DataTable"
		Call fn_Logging ("DEBUG"  , "Driver sheet is imported to DataTable")
	End If
	
End Function

Public Function fn_DateFormat(strDate,ByRef oStrDate)
	fn_DateFormat=True
	
	On Error Resume Next
	Err.Clear
	Call fn_Logging ("FNENTRY"  , "fn_DateFormat" , "Inside Function")
	oStrDate=strDate
	
	dtDate=Cdate(strDate)
	intDay=DatePart("d",dtDate)
	intMonth=DatePart("m",dtDate)
	intYear=DatePart("yyyy",dtDate)
	strMonth=MonthName(intMonth,True)

	StrDateFormated= cstr(intDay) + "-" + strMonth + "-" + cstr(intYear)
	oStrDate=StrDateFormated
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_DateFormat" , " Run Time error " + Err.Description)
		Err.Clear
		fn_DateFormat=False
	End If
	
End Function

Public Function fn_CreateResultFolder()
	fn_CreateResultFolder=True
	On Error Resume Next
	Err.Clear
	Dim strToday
	
	strFrameworkRootFolder=Environment("FrameworkRootFolder")
	strResultFolder=strFrameworkRootFolder + "\" + Environment("TestRunResultFolder")
	
	if not fn_CreateResultFolderbyDate (strResultFolder) Then
		fn_CreateResultFolder=False
		Exit Function
	End  if 
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateResultFolder" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateResultFolder=False
	End If
	
End Function

Public Function fn_CreateResultFolderbyDate(strResultFolder)
	fn_CreateResultFolderbyDate=True
	On Error Resume Next
	Err.Clear
	
	'Create Folder for today's date if it is not available
	If NOT fn_DateFormat(Date,ostrFormatDate) Then
'		print "Unable to change the date format"
		Call fn_Logging ("ERROR"  , "fn_CreateResultFolderbyDate" , "Unable to change the date format")
		fn_CreateResultFolderbyDate=False
	End If
	
	If NOT fn_CreateFolder(strResultFolder,ostrFormatDate) Then
'		print "Unable to change the date format"
		Call fn_Logging ("ERROR"  , "fn_CreateResultFolderbyDate" , "Unable to create Folder " + strResultFolder)
		fn_CreateResultFolderbyDate=False
	End If
	
	strResultFolderActual= strResultFolder + "\" + ostrFormatDate
	strFolderName="TestResult_" + Replace(Replace(Replace(Replace(Replace(cstr(now),"/",""),"\",""),"-",""),":","")," ","")
	
	If NOT fn_CreateFolder(strResultFolderActual,strFolderName) Then
		fn_CreateResultFolderbyDate=False
		Exit Function
	End If
	gResultFolder=strResultFolderActual + "\" + strFolderName

	Call fn_Logging ("INFO"  , "fn_CreateResultFolderbyDate" , "Result Folder :" + gResultFolder)
'	print "oResultFolder" + oResultFolder
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateResultFolderbyDate" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateResultFolderbyDate=False
	End If
	
End Function

Public Function fn_CreateFolder(FolderPath,FolderName)
	fn_CreateFolder=True
	
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_CreateFolder" ,"Inside Function")
	
	strFolder=FolderPath +"\" + FolderName
	If fn_FolderExist(strFolder) Then
'		print strFolder + " Folder already exist"
		Call fn_Logging ("DEBUG"  , "fn_CreateFolder" , strFolder + " Folder already exist")
		Exit Function
	End If
	
	Set objFSO=CreateObject("Scripting.FileSystemObject")
	objFSO.CreateFolder(strFolder)
	
	Set objFSO=Nothing
	
	If NOT fn_FolderExist(strFolder) Then
'		print "Unable to create folder "+ strFolder
		Call fn_Logging ("ERROR"  , "fn_CreateFolder" , "Unable to create folder "+ strFolder)
		fn_CreateFolder=False
		Exit Function
	else
'		print "Successfully created folder " + strFolder
		Call fn_Logging ("DEBUG"  , "fn_CreateFolder" , "Successfully created folder " + strFolder)
	End If
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateFolder" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateFolder=False
	End If
End Function

Public Function fn_CreateAnyFile(strFileFormat,strFolder,strFileName)
	fn_CreateAnyFile=True
	
	On Error Resume Next
	Err.Clear
	
	Select Case Ucase(strFileFormat)
		Case "EXCEL"
			If NOT fn_CreateExcelFile(strFolder,strFileName) Then
				fn_CreateAnyFile=False
			End If
		Case "TEXT"
			If NOT fn_CreateTextFile(strFolder,strFileName) Then
				fn_CreateAnyFile=False
			End If
		Case "XML"
		
		Case "HTML"
		
		Case Else
'			Print "Unable to get the file format:"
			Call fn_Logging ("ERROR"  , "fn_CreateAnyFile" ,  "Unable to get the file format:")
			
			fn_CreateAnyFile=False
	End Select
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateAnyFile" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateAnyFile=False
	End If
	
End  FUnction

Public Function fn_CreateTextFile(strFolder,strFileName)
	fn_CreateTextFile=True
	
	On Error Resume Next
	Err.CLear
	Call fn_Logging ("FNENTRY"  , "fn_CreateTextFile" ,"InSide Function")
	strFile=strFolder +"\" + strFileName +".txt"
	Set objFSO=CreateObject("Scripting.FileSystemObject")
	
	If not fn_FolderExist(strFolder) Then
'		print strFolder + " does NOT exist, Creating it"
		Call fn_Logging ("INFO"  , "fn_CreateTextFile" ,strFolder + " does NOT exist, Creating it")
		objFSO.CreateFolder(strFolder)
	End If
	
	If fn_FileExists(strFile) Then
'		print strFile + " exist already!"
		Call fn_Logging ("INFO"  , "fn_CreateTextFile" ,strFile + " exist already!")
		Exit Function
	End If
	
	objFSO.CreateTextFile(strFile)	
	Set objFSO=Nothing
	
	If NOT fn_FileExists(strFile) Then
'		print "Unable to create file "+ strFile
		Call fn_Logging ("ERROR"  , "fn_CreateTextFile" ,"Unable to create file "+ strFile)
		fn_CreateTextFile=False
		Exit Function
	else
'		print "Successfully created Text File " + strFile
		Call fn_Logging ("DEBUG"  , "fn_CreateTextFile" ,"Successfully created Text File " + strFile)
	End If
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateTextFile" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateTextFile=False
	End If
	
End Function

Public Function fn_CreateExcel(strFolder,strFileName)
	fn_CreateExcel=True
	
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_CreateExcel" ,"Inside Function")
		
	strFile=strFolder +"\" + strFileName +".xls"
	Set objExcel=CreateObject("Excel.Application")
	Set objFSO=createObject("Scripting.FileSystemObjec")
	
	If not fn_FolderExist(strFolder) Then
'		print strFolder + " does NOT exist, Creating it"
		Call fn_Logging ("INFO"  , "fn_CreateExcel" ,strFolder + " does NOT exist, Creating it")
		objFSO.CreateFolder(strFolder)
	End If
	Set objFSO=Nothing
	
	If fn_FileExists(strFile) Then
'		print strFile + " exist already!"
		Call fn_Logging ("INFO"  , "fn_CreateExcel" , strFile + " exist already!")
		Exit Function
	End If
	
	Set ObjWs=ObjExcel.Workbooks.Add
	ObjWs.SaveAs(strFile)
	objWs.Close
	
	Set ObjWs=Nothing
	Set ObjExcel=Nothing
	
	If NOT fn_FileExists(strFile) Then
'		print "Unable to create "+ strFile
		Call fn_Logging ("ERROR"  , "fn_CreateExcel" , "Unable to create " + strFile)
		fn_CreateExcel=False
		Exit Function
	else
'		print "Successfully created " + strFile
		Call fn_Logging ("DEBUG"  , "fn_CreateExcel" , "Successfully created " + strFile)
	End If
	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateExcel" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateExcel=False
	End If 
	
End Function

Public Function fn_CreateResultFile()
	fn_CreateResultFile=true
	On Error Resume Next
	Err.Clear
	Call fn_Logging ("FNENTRY"  , "fn_CreateResultFile" , "Inside Function")
	
	'Result File
	strTimeStamp=Replace(Replace(Replace(Replace(Replace(cstr(Time),"/",""),"\",""),"-",""),":","")," ","")
	
	strResultFileName="TestResult_" + strTimeStamp
	strLogFileName="Log_"+strTimeStamp
	gResultFile=strResultFileName + ".html" 
	gLogFile=strLogFileName + ".txt"
	
	
'	Create the file 
'	If Not fn_CreateTextFile( gResultFolder, strResultFileName) Then
'		fn_CreateResultFile=False
'	End If

	'Create Logfile
	If Not fn_CreateTextFile( gResultFolder, strLogFileName) Then
		fn_CreateResultFile=False
	End If
	
'	copy the template content
	If Not fn_CopyHTMLTemplateToResultFile Then
		fn_CreateResultFile=False
	End If
		
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_CreateResultFile" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CreateResultFile=False
	End If
	
End Function

Public Function fn_CopyHTMLTemplateToResultFile
	fn_CopyHTMLTemplateToResultFile=True
	
	On Error Resume Next
	Err.Clear
	Dim objFso
	
	strResultFolder=Environment("FrameworkRootFolder") + "\" + Environment("TestRunResultFolder")
	strResultFileTemplate=strResultFolder +"\"+Environment("TestResultTemplate")
	
	strResultFile=gResultFolder +"\"+ gResultFile
	If isobject(objFso) Then
		Set objFSO=Nothing
	End If
	Set objFso=CreateObject ("Scripting.FileSystemObject")
	If (NOT objFso.FileExists(strResultFileTemplate)) Then
		Call fn_Logging ("ERROR"  , "fn_CopyHTMLTemplateToResultFile" , strResultFileTemplate + " file does not exist" )
		fn_CopyHTMLTemplateToResultFile=False
		Exit Function
	End If
		
	strResultFolder1=gResultFolder+"\"
	objFso.CopyFile strResultFileTemplate,strResultFolder1,True
	objFso.MoveFile strResultFolder1 +Environment("TestResultTemplate"), strResultFile
	gResultFile=strResultFile
	print "Result FIle - gResultFile =" + gResultFile
	Set objFSO=Nothing
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_CopyHTMLTemplateToResultFile" , " Run Time error " + Err.Description)
		Err.Clear
		fn_CopyHTMLTemplateToResultFile=False
	End If

End Function

Public Function fn_ConnectExcelDB(strExcel,strSQLQuery,oObjRS)
	fn_ConnectExcelDB=True
	
	On error resume next
	Err.Clear
	Call fn_Logging ("FNENTRY"  , "fn_ConnectExcelDB" , "Inside the Function") 
	
	Set objCon=CreateObject("ADODB.Connection")
	Set objRS=CreateObject("ADODB.RecordSet")
	objCon.Open "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" + strExcel+";Readonly=True"
	objRS.Open strSQLQuery,objCon
	oObjRS=objRS
	
	Set objCon=Nothing
	Set objRS= Nothing	
	If err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_ConnectExcelDB" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ConnectExcelDB=False
	End If
''retrieving the result
'Msgbox rs.getstring 

End Function

Public Function fn_AddValueToDataTable(strSheetName,strFieldName,strValue)
	fn_AddValueToDataTable=True
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_AddValueToDataTable" , "Inside the Function") 
	 
	Dim intFlagParameterFound
	Dim intTblColCount
	Dim strColName
	
	
	intFlagParameterFound=0
	strFieldName=Ucase(strFieldName)
	
'	Get the Data table cloumn count (Parameter Count)
'	get the corresponding column based on the field name'
'	if the column not present then create a new column with the given field value
'	if the column present then add the value under the column 
'	NOTE: current row will selected by default based on the test case

	intTblColCount=DataTable.GetSheet(strSheetName).GetParameterCount
	
	For col = 1 To intTblColCount
		strColName=Ucase(DataTable.GetSheet(strSheetName).GetParameter(col).Name)
		If strColName =strFieldName Then
			intFlagParameterFound=1
			Exit For
		End If
	Next
	
	If intFlagParameterFound=1 Then
		DataTable.value(strFieldName,strSheetName)=Trim(strValue)
	Else
		DataTable.GetSheet(strSheetName).AddParameter strFieldName,""
		DataTable.SetCurrentRow(gintDTSheetCurrentRow)
		DataTable.value(strFieldName,strSheetName)=Trim(strValue)
	End If
	
	If Err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_AddValueToDataTable" , " Run Time error " + Err.Description)
		Err.Clear
		fn_AddValueToDataTable=False
	End If
	
End Function

Public Function fn_ExecuteTestCase(arrTestScriptFunctions)
	fn_ExecuteTestCase=True
	
	On Error Resume Next
	Err.Clear
	
	Call fn_Logging ("FNENTRY"  , "fn_ExecuteTestCase" , "Inside the Function") 
	
'	Make the gstrTCStatus as Passed
'	verify the test case flow functions are present, initially it should not be empty, END_SCANARIO or first function is empty
'   While iterating through the function if END_SCANARIO or current function value is empty then stop the execution
'	Execute the current function using EVAL or EXECUTE 

	gstrTCStatus="Passed"
	
	intFunctionCount=Ubound(arrTestScriptFunctions)
	
	If intFunctionCount=0 or arrTestScriptFunctions(0)=EMPTY Then
'		print "Unable to find the test execution flow functions"
		Call fn_Logging ("ERROR"  , "fn_ExecuteTestCase" , "Unable to find the test execution flow functions") 
		fn_ExecuteTestCase=False
		Exit Function
	End If

	For each strFunction in arrTestScriptFunctions
		If strFunction="END_SCANARIO" or strFunction="" Then
'			print "Stopping the test execution flow cases as current testcase flow name is ["& strFunction & "]"
			Call fn_Logging ("DEBUG"  , "fn_ExecuteTestCase" , "Stopping the test execution flow cases as current testcase flow name is ["& strFunction & "]")
			Exit For
		End If
		
		Call fn_Logging ("DEBUG"  , "fn_ExecuteTestCase" , "Executing the function ["& strFunction & "]")
		
		If NOT Eval(strFunction) Then
			gstrTCStatus=Failed
'			print "Execution of Function ["& strFunction & "] is [FAILED]"
			Call fn_Logging ("ERROR"  , "fn_ExecuteTestCase" , "Execution of Function ["& strFunction & "] is [FAILED]")
			fn_ExecuteTestCase=False
			Exit For
		Else
			Call fn_Logging ("DEBUG"  , "fn_ExecuteTestCase" , "Execution of Function ["& strFunction & "] is [COMPLETED]")
		End If
	Next
	
	If Err.Number <> 0 Then
'		print " Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_ExecuteTestCase" , " Run Time error " + Err.Description)
		Err.Clear
		fn_ExecuteTestCase=False
	End If
	
End Function

Public Function fn_ReportResult(strExpected,strActual,strStatus,strImageCapture)
	fn_ReportResult=True
	
	Call fn_Logging ("FNENTRY"  , "fn_ReportResult" ,"Inside Function")
	
	On Error Resume Next
	Err.Clear
	strStatus=UCASE(strStatus)
	Set objFso=CreateObject ("Scripting.FileSystemObject")
	If (NOT objFso.FileExists(gResultFile)) Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult" , gResultFile + " File does not exist")
		Exit Function
	End If
	
	Call fn_Logging ("DEBUG"  , "fn_ReportResult" , "Adding the test step as HTML Tanle data")
	
	If strStatus="PASSED" Then
		strString= "<tr><td align = 'center'>" + cstr(time) + "<td align = 'center'>" + strExpected +_
	     "<td align = 'center'>"+strActual+"<td align = 'center'><font color=" + chr(34) +"green" + chr(34) +">PASSED</font>"
	Else
		strString= "<tr><td align = 'center'>" + cstr(time) + "<td align = 'center'>" + strExpected +_
	     "<td align = 'center'>"+strActual+"<td align = 'center'><font color=" + chr(34) +"red" + chr(34) +">" + strStatus+ "</font>"
	End If
	
	Set objFStream=objFso.OpenTextFile(gResultFile,8)

	objFStream.WriteLine strString
	Set objFStream=Nothing
	Set objFso=Nothing
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult" , "Run Time error " + Err.Description)
		Err.Clear
		fn_ReportResult=False
	Else
		Call fn_Logging ("DEBUG"  , "fn_ReportResult:"+ strExpected, strActual + "::"+ strStatus )
		Call fn_Logging ("FNEXIT"  , "fn_ReportResult" ,"EXIT Function")
	End If
	
End Function

Public Function fn_ReportResult_TCHeader
	fn_ReportResult_TCHeader=True
	Call fn_Logging ("FNENTRY"  , "fn_ReportResult_TCHeader" ,"Inside Function")
	On Error Resume Next
	Err.Clear

	Set objFso=CreateObject ("Scripting.FileSystemObject")
	
	If (NOT objFso.FileExists(gResultFile)) Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_TCHeader" , gResultFile + " File does not exist")
		Exit Function
	End If
	
'	<table class = "table" align = "center" cellspacing = '5' cell
'	<tr><td align = 'Left' colspan='2'> <b> TC_2 </b><td align = 'right'>Status:<td align = 'left'><font color="green">Passed</font>padding = '10'>
'	<tr><th align = 'center'>TIME<th align = 'center'>Expected Steps<th align = 'center'>Actual Steps<th align = 'center'>Status
	
	strTableLayout="<table class = " + chr(34) +"table" + chr(34) +" align = " + chr(34) +"center" + chr(34) +" cellspacing = '5' cellpadding = '10'>"
	strTableTCData="<tr><td align = 'Left' colspan='2'> <b>strTestCaseFullName</b><td align = 'right'>Status:<td align = 'left'>strTCStatus"
	strTableHeader="<tr><th align = 'center'>TIME<th align = 'center'>Expected Steps<th align = 'center'>Actual Steps<th align = 'center'>Status"
'	add as below	
'	strTCSTatus=<font color="green">Passed</font>		

	Set objFStream=objFso.OpenTextFile(gResultFile,8)

	objFStream.WriteLine strTableLayout
	objFStream.WriteLine strTableTCData
	objFStream.WriteLine strTableHeader
	
	Set objFStream=Nothing
	Set objFso=Nothing
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_TCHeader" , "Run Time error " + Err.Description)
		Err.Clear
		fn_ReportResult_TCHeader=False
	Else
		Call fn_Logging ("FNEXIT"  , "fn_ReportResult_TCHeader" ,"EXIT Function")
	End If
	
End Function

Public Function fn_ReportResult_TCTailer(strTestCaseFullName)
	fn_ReportResult_TCTailer=True
	Call fn_Logging ("FNENTRY"  , "fn_ReportResult_TCTailer" ,"Inside Function")
	On Error Resume Next
	Err.Clear

	Set objFso=CreateObject ("Scripting.FileSystemObject")
	
	If (NOT objFso.FileExists(gResultFile)) Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_TCTailer" , gResultFile + " File does not exist")
		Exit Function
	End If
		
	strTableTailer="<" + chr(47)+ "table>"
	
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_TCTailer" , "Appending the tailer in the  HTML file")
		
	Set objFStream=objFso.OpenTextFile(gResultFile,8)

	objFStream.WriteLine strTableTailer
	objFStream.WriteBlankLines
	objFStream.Close
	Set objFStream=Nothing
	
	Set objFStreamRead=objFso.OpenTextFile(gResultFile,1)
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_TCTailer" , "Reading all content from HTML file")
	strString=objFStreamRead.ReadAll
	objFStreamRead.Close
	
	If Ucase(gstrTCStatus)="PASSED" Then
		strTCSTatus="<font color="+ chr(34) +"green" + chr(34) +">PASSED</font>"
	Else
		strTCSTatus="<font color="+ chr(34) +"red" + chr(34) +">FAILED</font>"
	End If
	
'	If Ucase(gstrTCStatus)="PASSED" Then
'		strTCSTatus="PASSED"
'	Else
'		strTCSTatus="FAILED"
'	End If

	Set objFStreamRead=Nothing
	
	strString=Replace(strString,"strTCStatus",strTCSTatus)
	strString=Replace(strString,"strTestCaseFullName",strTestCaseFullName)
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_TCTailer" , "writing the updated content to the HTML file")
	Set objFStreamWrite=objFso.OpenTextFile(gResultFile,2)
	objFStreamWrite.Write strString
	Set objFStreamWrite=Nothing
	Set objFso=Nothing
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_TCTailer" , "Run Time error " + Err.Description)
		Err.Clear
		fn_ReportResult_TCTailer=False
	Else
		Call fn_Logging ("FNEXIT"  , "fn_ReportResult_TCTailer" ,"EXIT Function")
	End If
	
End Function

Public Function fn_ReportResult_Consolidate

	fn_ReportResult_Consolidate=True
	Call fn_Logging ("FNENTRY"  , "fn_ReportResult_Consolidate" ,"Inside Function")
	On Error Resume Next
	Err.Clear
	
	strProjectName = Environment("Appliaction_Name")
	strExecutionDate=cstr(Date)
	strExecutionDate
	strExecutedBy=Environment.Value("UserName")
	strOStype=Environment.Value("OS")
	strOSVersion=Environment.Value("OSVersion")
	
	strExecutionStartTime=gTestExecutionStartTime
	strExecutionEndTime=gTestExecutionEndTime
	

	StrTotalTCCount=gintTCPassCount + gintTCFailCount + gintTCWarningCount
	StrTotalPassedTCCount=gintTCPassCount
	StrTotalFailedTCCount=gintTCFailCount
	StrTotalNETCCount=gintTCWarningCount
	
	
	SecTotal= Cint(DateDiff("s",Cdate(strExecutionStartTime),Cdate(strExecutionEndTime)))
	Hrs=Cstr(Cint(SecTotal/3600))
	Min=Cstr(int((SecTotal Mod 3600)/60))
	Sec=Cstr(Cint((SecTotal Mod 60) Mod 60))
	
	strExecutionDuration= Hrs + "Hrs:" + Min + "Min:" +Sec + "Sec:" 
	
	Set objFso=CreateObject ("Scripting.FileSystemObject")
	
	If (NOT objFso.FileExists(gResultFile)) Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_Consolidate" , gResultFile + " File does not exist")
		Exit Function
	End If
	
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_Consolidate" ,"Rading the existing HTML file to replace the variables")
	
	Set objFStreamRead=objFso.OpenTextFile(gResultFile,1)
	strString=objFStreamRead.ReadAll
	objFStreamRead.Close
	Set objFStreamRead=Nothing
	
	strString=Replace(strString,"strProjectName",strProjectName)
	strString=Replace(strString,"strExecutionDate",strExecutionDate,2)
	strString=Replace(strString,"strExecutedBy",strExecutedBy)
	strString=Replace(strString,"strOStype",strOStype)
	strString=Replace(strString,"strOSVersion",strOSVersion)
	
	strString=Replace(strString,"strExecutionStartTime",strExecutionStartTime)
	strString=Replace(strString,"strExecutionEndTime",strExecutionEndTime)
	strString=Replace(strString,"strExecutionDuration",strExecutionDuration)
	strString=Replace(strString,"StrTotalTCCount",StrTotalTCCount)
	strString=Replace(strString,"StrTotalPassedTCCount",StrTotalPassedTCCount)
	strString=Replace(strString,"StrTotalFailedTCCount",StrTotalFailedTCCount)
	strString=Replace(strString,"StrTotalNETCCount",StrTotalNETCCount)
	
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_Consolidate" ,"Writing updated HTML string back to the HTML file")
	
	Set objFStreamWrite=objFso.OpenTextFile(gResultFile,2)
	objFStreamWrite.Write strString
	objFStreamWrite.Close
	Set objFStreamWrite=Nothing
	
	Call fn_Logging ("DEBUG"  , "fn_ReportResult_Consolidate" ,"Appending the final HTML Tag string to the HTML file")
	Set objFStreamAppend=objFso.OpenTextFile(gResultFile,8)
	objFStreamAppend.WriteLine "<"+chr(47)+"div>"
	objFStreamAppend.WriteLine "<"+chr(47)+"div>"
	objFStreamAppend.WriteLine "<"+chr(47)+"div>"
	objFStreamAppend.WriteLine "<"+chr(47)+"body>"
	objFStreamAppend.WriteLine "<"+chr(47)+"html>"
	
	set objFStreamAppend=Nothing
	Set objFso=Nothing
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_ReportResult_TCHeader" , "Run Time error " + Err.Description)
		Err.Clear
		fn_ReportResult_TCHeader=False
	Else
		Call fn_Logging ("FNEXIT"  , "fn_ReportResult_TCHeader" ,"EXIT Function")
	End If
	
End Function

Public Function fn_LaunchApplication
	fn_LaunchApplication=True
	On Error resume Next
	Err.clear
	
	Call fn_Logging ("FNENTRY"  , "fn_LaunchApplication" , "Inside Function")
	
	strApplication =Environment("Appliaction_URL")
	strApplicationName=Environment("Appliaction_Name")
	
	If strApplication="" Then
		Call fn_Logging ("ERROR"  , "fn_LaunchApplication" , "Application name is empty [" & strApplicationName & "] ")
		fn_LaunchApplication=False
	End If
	
	systemutil.Run "iexplore.exe",strApplication
		
	If Err.Number <> 0 Then
'		print "fn_LaunchApplication: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_LaunchApplication" , " Run Time error " + Err.Description)
		call fn_ReportResult("To Launch the application [" & strApplicationName & "]"," Run Time error " + Err.Description,"FAILED","IMG_NO")
		Err.Clear
		fn_LaunchApplication=False
	Else
'		print "Launched the application [" & strApplicationName & "]"
		Call fn_Logging ("DEBUG"  , "fn_LaunchApplication" , "Launched the application [" & strApplicationName & "]")
		call fn_ReportResult("To Launch the application [" & strApplicationName & "]","[" & strApplicationName & "] is launched","PASSED","IMG_NO")
	End If
	
End Function

Function LaunchApplicationOnIE

	LaunchApplicationOnIE=True
	On Error resume Next
	Err.clear

	Call fn_Logging ("FNENTRY"  , "LaunchApplicationOnIE" , "Inside Function")
	
	strApplication =Environment("Appliaction_URL")
	strApplicationName=Environment("Appliaction_Name")
	Dim intZoomLevel, objIE
	intZoomLevel = 100
 	Const OLECMDID_OPTICAL_ZOOM = 63
 	Const OLECMDEXECOPT_DONTPROMPTUSER = 2
 
	If strApplication="" Then
		Call fn_Logging ("ERROR"  , "LaunchApplicationOnIE" , "Application name is empty [" & strApplicationName & "] ")
		LaunchApplicationOnIE=False
	End If
	
	Set objIE = CreateObject("InternetExplorer.Application")
	objIE.Visible = True
	objIE.Navigate (strApplication)
	
	While objIE.Busy = True
		wait 2
	Wend
	objIE.ExecWB OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, CLng(intZoomLevel), vbNull
	
	strHWnd=objIE.HWND
	
	Window("hwnd:=" & strHwnd).Maximize
		
	If Err.Number <> 0 Then
'		print "fn_LaunchApplication: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "LaunchApplicationOnIE" , " Run Time error " + Err.Description)
		call fn_ReportResult("To Launch the application on IE"," Run Time error " + Err.Description,"FAILED","IMG_NO")
		Err.Clear
		LaunchApplicationOnIE=False
	Else
'		print "Launched the application [" & strApplicationName & "]"
		Call fn_Logging ("DEBUG"  , "LaunchApplicationOnIE" , "Launched the application [" & strApplicationName & "]")
		call fn_ReportResult("To Launch the application on IE","Launched the application [" & strApplicationName & "]","PASSED","IMG_NO")
	End If

End Function

Public Function fn_object_Exist(Object,strObjectName,intWaitInSec)
	fn_object_Exist=true
	
	On Error Resume Next
	Err.CLear
	
	Call fn_Logging ("FNENTRY"  , "fn_object_Exist" , "inside Function")
	
'	If NOT isobject(objObject) Then
'		print strObjectName & " is not an object"
'		Exit Function
'	End If
	If Object.exist(Cint(intWaitInSec)) Then
		Object.Highlight
'		print strObjectName & " exists"
		Call fn_Logging ("DEBUG"  , "fn_object_Exist" , "[" & strObjectName & "] exists")
	Else
'		print strObjectName & " deos NOT exist"
		Call fn_Logging ("ERROR"  , "fn_object_Exist" , "[" & strObjectName & "] does NOT exist")
		fn_object_Exist=False
	End If
	
	If Err.Number <> 0 Then
'		print "fn_object_Exist: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_object_Exist" , " Run Time error " + Err.Description)
		Err.Clear
		fn_object_Exist=False
	End If
End Function

Public Function fn_objectNOTExist(Object,strObjectName,intWaitInSec)
	fn_objectNOTExist=true
	
	On Error Resume Next
	Err.CLear
	
	Call fn_Logging ("FNENTRY"  , "fn_objectNOTExist" , "inside Function")
	
'	If NOT isobject(objObject) Then
'		print strObjectName & " is not an object"
'		Exit Function
'	End If
	
	If Object.exist(Cint(intWaitInSec)) Then
'		print strObjectName & " exists"
		Call fn_Logging ("ERROR"  , "fn_objectNOTExist" , "[" & strObjectName & "] exists")
		
		fn_objectNOTExist=False
	Else
'		print strObjectName & " deos NOT exist"
		Call fn_Logging ("DEBUG"  , "fn_objectNOTExist" , "[" & strObjectName & "] deos NOT exist")
		
	End If
	
	If Err.Number <> 0 Then
'		print "fn_objectNOTExist:Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_objectNOTExist" , " Run Time error " + Err.Description)
		Err.Clear
		fn_objectNOTExist=False
	End If
End Function

''' To be continued
Public Function fn_WebEdit_Set(strObject,strFieldtName, strValue)
	fn_WebEdit_Set=true
	
	On Error Resume Next
	Err.CLear
	
	all fn_Logging ("FNENTRY"  , "fn_WebEdit_Set" , "inside Function")
	
	If not strObject.Exist(2) Then
'		print strObject & " deos NOT exist"
		Call fn_Logging ("ERROR"  , "fn_WebEdit_Set" , "[" & strObject & "] deos NOT exist")
		
		fn_WebEdit_Set=False
		Exit Function
	End If
	strObject.Highlight
	strObject.set strValue
	
	
	If Err.Number <> 0 Then
'		print "fn_WebEdit_Set: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_WebEdit_Set" , " Run Time error " + Err.Description)
		Err.Clear
		fn_WebEdit_Set=False
	Else
'		print "Add value [" & strValue & "] to the field ["& strFieldtName & "]"
		Call fn_Logging ("DEBUG"  , "fn_WebEdit_Set" , "Add value [" & strValue & "] to the field ["& strFieldtName & "]")
		call fn_ReportResult("To Add value [" & strValue & "] to the field ["& strFieldtName & "]","Added value [" & strValue & "] to the field ["& strFieldtName & "]","PASSED","IMG_NO")
	End If
	
	
End Function

Public Function fn_WebEdit_SetSecure(strObject,strFieldtName, strValue)
	fn_WebEdit_SetSecure=true
	
	On Error Resume Next
	Err.CLear
	
	Call fn_Logging ("FNENTRY"  , "fn_WebEdit_SetSecure" , "Inside Function")
	
	If NOT strObject.Exist(2) Then
'		print strObject & " deos NOT exist"
		Call fn_Logging ("ERROR"  , "fn_WebEdit_SetSecure" , "["& strObject & "] object deos NOT exist")
		fn_WebEdit_SetSecure=False
		Exit Function
	End If
	strObject.Highlight
	strObject.SetSecure strValue
	
	
	If Err.Number <> 0 Then
'		print "fn_WebEdit_SetSecure: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_WebEdit_SetSecure" , " Run Time error " + Err.Description)
		Err.Clear
		fn_WebEdit_SetSecure=False
	Else
'		print "Add value [*********] to the field ["& strFieldtName & "]"
		Call fn_Logging ("DEBUG"  , "fn_WebEdit_SetSecure" ,"Add value [*********] to the field ["& strFieldtName & "]")
		call fn_ReportResult("To Add value [*********] to the field ["& strFieldtName & "]","Added value [*********] to the field ["& strFieldtName & "]","PASSED","IMG_NO")
	End If
	
	
End Function

Public Function fn_Link_Click(strObject,strFieldtName)
	fn_Link_Click=true
	
	On Error Resume Next
	Err.CLear
	
	Call fn_Logging ("FNENTRY"  , "fn_Link_Click","Inside Function")
	
	If not strObject.Exist(2) Then
'		print strObject & " deos NOT exist"
		Call fn_Logging ("ERROR"  , "fn_Link_Click" , "["& strObject & "] object deos NOT exist")
		fn_Link_Click=False
		Exit Function
	End If
	strObject.Highlight
	strObject.Click
	
	
	If Err.Number <> 0 Then
'		print "fn_Link_Click: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_Link_Click" , " Run Time error " + Err.Description)
		Err.Clear
		fn_Link_Click=False
	Else
'		print "Successfully clicked the link  ["& strFieldtName & "]"
		Call fn_Logging ("DEBUG"  , "fn_Link_Click" , "Successfully clicked the link  ["& strFieldtName & "]")
		call fn_ReportResult("To Click the Link ["& strFieldtName & "]","Successfully clicked the Link  ["& strFieldtName & "]","PASSED","IMG_NO")
	End If
	
	
End Function

Public Function fn_WebButton_Click(strObject,strFieldtName)
	fn_WebButton_Click=true
	Call fn_Logging ("FNENTRY"  , "fn_WebButton_Click" , "Inside Function")
	
	On Error Resume Next
	Err.CLear
	
	If not strObject.Exist(5) Then
'		print strObject & " deos NOT exist"
		Call fn_Logging ("ERROR"  , "fn_WebButton_Click" , "["& strObject & "] object deos NOT exist")
		fn_WebButton_Click=False
		Exit Function
	End If
	
	strObject.Highlight
	strObject.Click
	
	
	If Err.Number <> 0 Then
'		print "fn_WebButton_Click: Run Time error " + Err.Description
		Call fn_Logging ("ERROR"  , "fn_WebButton_Click" , " Run Time error " + Err.Description)
		Err.Clear
		fn_WebButton_Click=False
	Else
'		print "Successfully clicked the Button  ["& strFieldtName & "]"
		Call fn_Logging ("INFO"  , "fn_WebButton_Click" , "Successfully clicked the Button  ["& strFieldtName & "]")
		call fn_ReportResult("To Click the button ["& strFieldtName & "]","Successfully clicked the Button  ["& strFieldtName & "]","PASSED","IMG_NO")
	End If
		
End Function

