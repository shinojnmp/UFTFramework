Public gResultFolder
Public gResultFile
Public gLogFile
Public gTestExecutionStartTime
Public gTestExecutionEndTime
Public objTestParameter
Public objRunTimeParameter
Public gintDTSheetCurrentRow

Public gintTCPassCount
Public gintTCFailCount
Public gintTCWarningCount
Public gstrTCStatus

Function fn_Driver()
	fn_Driver=True
	
	Dim objRS
	Dim strSQLQuery
	Dim strSheetName
	Dim StrSiNo
	Dim strTestIteration
	Dim arrIteration
	Dim intCurIteration
	Dim arrTestScriptFunctions()
	Dim intFunctionCnt
	Dim strTestCondition
	Dim strTestCaseNameForReport
	
	strTestDriverSheetName=Environment("TestDriverSheets")
	strDriverPath=	Environment("FrameworkRootFolder") + "\" + Environment("TestDriverFolder") +"\" + Environment("TestDriverName")   	
	strTestDriverSheet= split(strTestDriverSheetName,"|")(0)
	strTestScriptSheet= split(strTestDriverSheetName,"|")(1)
	StrTestDataSheet=split(strTestDriverSheetName,"|")(2)
	
	StrDtSheetName="Action1"
	Set objTestParameter=CreateObject("Scripting.dictionary")
	Set objRunTimeParameter=CreateObject("Scripting.dictionary")
	
	Call fn_Logging ("INFO" , "fn_Driver" , "Verifying the frameork Folder")
'	Verify the FOlder structure
	If not fn_ValidateFrameworFolders Then
'		print "Framework Folders are not avilable"
		Call fn_Logging ("ERROR" , "fn_Driver" , "Framework Folders are not avilable")
		Exit Function
	End If
	
	'Create the result path, HTNL reports & log file (Excel reault later HTML)
	If NOT fn_CreateResultFolder Then
'		print "Unable to create the result Folder path"
		Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to create the result Folder path")
		Exit Function
	End If

	If NOT fn_CreateResultFile Then
'		print "Unable to create the result File"
		Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to create the result File")
		Exit Function
	End If
	
'	Close all excels & IE - systemuti.closeproessbyname
	if not fn_CloseProcessByname("EXCEL.EXE") Then
'		print "Unable to Close the process EXCEL.EXE" 
		Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to Close the process EXCEL.EXE" )
	End If
	
	if not fn_CloseProcessByname("IEXPLORE.EXE") Then
'		print "Unable to Close the process IEXPLORE.EXE" 
		Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to Close the process IEXPLORE.EXE" )
	End If
		
		
	'Verify the test resources
	Call fn_Logging ("INFO" , "fn_Driver" , "Verifying the test resources")
	
	If not fn_ValidateFrameworResources Then
'		print "Framework resources are not avilable"
		Call fn_Logging ("ERROR" , "fn_Driver" , "Framework resources are not avilable")
		Exit Function
	End If
'	
'	import the driver sheet to data table (GLobal sheet)
	Call fn_Logging ("INFO" , "fn_Driver" , "import the driver sheet to data table (GLobal sheet)")
	If NOT fn_ImportDriverSheet Then
'		print "Driver sheet is not been imported to Data Table"
		Call fn_Logging ("ERROR" , "fn_Driver" , "Driver sheet is not been imported to Data Table")
		Exit Function
	End If
	
'Navigate through the data table and check for execution status = YES
	Call fn_Logging ("DEBUG" , "fn_Driver" , "Navigating through the data table and checking for execution status = YES")
	gTestExecutionStartTime=Now
	Call fn_Logging ("DEBUG" , "fn_Driver" , "Test Execution start time " + cstr(gTestExecutionStartTime))
	
	intDataTableRowCnt=DataTable.GetRowCount
	For gintDTSheetCurrentRow  = 1 To intDataTableRowCnt Step 1
		fn_driver=True
		DataTable.SetCurrentRow (gintDTSheetCurrentRow)
'		if the execution status is YES then fetch the test data and test scenario flow from test script and test controller sheet
		If Ucase(DataTable.Value("Execute",1))="YES" Then
			Call fn_ResetGlobalVariable()
			Call fn_Logging ("DEBUG" , "fn_Driver" , "Data Table Row " + Cstr(gintDTSheetCurrentRow) + " Found Test execution status as YES")
			intFunctionCnt=0
'			ostrTestExeFlag=Empty
'			gstrTCStatus="Failed"
			
			'deleting the content from the test script function array
			Call fn_Logging ("DEBUG" , "fn_Driver" , "Deleting the content from the test script function array")
			Erase arrTestScriptFunctions
			
			'redimensioning to zero length
			ReDim arrTestScriptFunctions(0)
			
			strSINO=DataTable.Value("SI_NO")
			strTestCaseName=DataTable.Value("TestCaseName")
			strTestScenario=DataTable.Value("TestScenario")
			strTestScenarioDesc=DataTable.Value("TestScnarioDescription")
			strTestIteration=DataTable.Value("Iteration")
			strErrorHandler=DataTable.Value("ErrorHandler")
			strTestCondition=DataTable.Value("TestCondition")
			strTestCaseFullName=strSINO + "_"+ strTestCaseName + "_"+ strTestIteration
			
			Call fn_Logging ("INFO" , "fn_Driver" , "strSINO " + strSINO)
			Call fn_Logging ("INFO" , "fn_Driver" , "strTestCaseName " + strTestCaseName)
			Call fn_Logging ("INFO" , "fn_Driver" , "strTestScenario " + strTestScenario)
			Call fn_Logging ("INFO" , "fn_Driver" , "strTestScenarioDesc " + strTestScenarioDesc)
			Call fn_Logging ("INFO" , "fn_Driver" , "strTestIteration " + strTestIteration)
			Call fn_Logging ("INFO" , "fn_Driver" , "strErrorHandler " + strErrorHandler)
			Call fn_Logging ("INFO" , "fn_Driver" , "strTestCondition " + strTestCondition)
			
			If strTestIteration="" Then
				strTestIteration=Cstr(1)
			End If
			
			'Fetching corresponding test scripti (tets Functions)
			strSQLQuery="SELECT * FROM [" & strTestScriptSheet & "$] where TestScenario=" &  chr(39) & strTestScenario & chr(39)
			Call fn_Logging ("DEBUG" , "fn_Driver" , "strSQLQuery :" + strSQLQuery)
			if NOT fn_ConnectExcelDB(strDriverPath,strSQLQuery,objRS) then
'				Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to Get the test script for the test case [" + strTestCaseName + "] and test scenario [" +strTestScenario + "]")
				print "Unable to Get the test script for the test case [" + strTestCaseName + "] and test scenario [" +strTestScenario + "]"
				Exit Function
			End If
			intFunctionCntFromExcel=objRs.count
			
			If intFunctionCntFromExcel =0 Then
'				print "Unable to find the functions to execute"
				Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to find the functions to execute - Function count is " + intFunctionCntFromExcel )
				Exit Function
			End If
			
			For intFunction = 2 To intFunctionCntFromExcel-1
				ReDim preserve arrTestScriptFunctions(intFunctionCnt)
				If NOT objRs.Item(intFunction).value ="" Then
					arrTestScriptFunctions(intFunctionCnt)=objRs.Item(intFunction).value
					intFunctionCnt=intFunctionCnt+1
				End If
			Next
			
			If strTestIteration="" Then
				strTestIteration=1
			End If
			arrTestIteration=Split(strTestIteration,",")
						
			For each intTestIteration in arrTestIteration
				strSQLQuery=""
				objTestParameter.RemoveAll	

				'Fetching corresponding test data
				Call fn_Logging ("DEBUG" , "fn_Driver" , "Fetching test data for corresponding Test Iteration")

				strSQLQuery="SELECT * FROM [" & StrTestDataSheet & "$] where TestCaseName=" &  chr(39) & Trim(strTestCaseName) & chr(39) & " and TestIteration=" & intTestIteration
				Call fn_Logging ("DEBUG" , "fn_Driver" , "strSQLQuery :" + strSQLQuery)
				if NOT fn_ConnectExcelDB(strDriverPath,strSQLQuery,objRS) then
'					print "Unable to Get the test data for the test case [" + strTestCaseName + "] and iteration [" +Cstr(intTestIteration) + "]"
					Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to Get the test data for the test case [" + strTestCaseName + "] and iteration [" +Cstr(intTestIteration) + "]" )
					Exit Function
				End If
				
				intDataCountFromExcel=objRS.Count
				Call fn_Logging ("DEBUG" , "fn_Driver" , "Test Data Count from Data Sheet " + cstr(intDataCountFromExcel))
				' adding the Data  to Static Dixtionary object
				For intData = 3 To intDataCountFromExcel-1
					strTestDataPair=objRs.Item(intData).value
					If not strTestDataPair = "" Then
						TestData=Split(Trim(strTestDataPair),"=")(0)
						Value=Split(Trim(strTestDataPair),"=")(1)
						If not objTestParameter.Exists(TestData) Then
							objTestParameter.Add TestData,value
						Else
							objTestParameter.Key(TestData) = value
						End If
					End If
				Next
				
				strTestReprtNameForFReport="SI NO: " & strSINO & " TCName:" &strTestCaseName
				
				print "*******Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] *****"
				Call fn_Logging ("DEBUG" , "fn_Driver" , "*******Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] *****")
				
				if not fn_ReportResult_TCHeader Then
					Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to add the header to the HTML reports")
'					fn_Driver=False	
'					Exit Function
				End If  
				
				'Naviagate through the function arrau and run the array until End Function Keyword
				
				if not fn_ExecuteTestCase(arrTestScriptFunctions) Then
'					print "Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] is [Failed]"
					Call fn_Logging ("ERROR" , "fn_Driver" , "Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] is [Failed]")
					gstrTCStatus="Failed"
					gintTCFailCount=gintTCFailCount+1
					fn_Driver=False					
				Else
					print "Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] is [Passed]"
					gintTCPassCount=gintTCPassCount+1
					Call fn_Logging ("DEBUG" , "fn_Driver" , "Test execution of Test case [" &  strTestCaseName & "] and Iteration ["& intTestIteration &"] is [Passed]")
				End If
				
				if not fn_ReportResult_TCTailer(strTestCaseFullName) Then
					Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to add the Tail string to the HTML reports")
'					fn_Driver=False	
'					Exit Function
				End If 
				
				If (NOT Ucase(gstrTCStatus)="PASSED") AND (NOT isEmpty(strErrorHandler)) Then
'					print "Activating Error Handler [" & strErrorHandler & "]"
					Call fn_Logging ("DEBUG" , "fn_Driver" , "Activating Error Handler [" & strErrorHandler & "]")
					
					Select Case UCase(strErrorHandler)
						Case "NEXT_ITERATION"
							
						Case "NEXT_TC"
							Exit For
							
						Case "STOP_EXECUTION","STOP"
							gTestExecutionEndTime=Now
							Call fn_Logging ("DEBUG" , "fn_Driver" , "Test Execution End time " + cstr(gTestExecutionEndTime))
							Exit Function
						Case else
'							print "Unexpected erro handler string"
							Call fn_Logging ("ERROR" , "fn_Driver" , "Unexpected erro handler string")
					End Select
				End If
			Next
			
'			gintDTSheetCurrentRow=gintDTSheetCurrentRow+1
'			DataTable.SetCurrentRow(gintDTSheetCurrentRow)
		End If
	next
	gTestExecutionEndTime=Now
	if not fn_ReportResult_Consolidate Then
		Call fn_Logging ("ERROR" , "fn_Driver" , "Unable to add the Tail string to the HTML reports")
'		fn_Driver=False	
'		Exit Function
	End If 
					
	Call fn_Logging ("DEBUG" , "fn_Driver" , "Test Execution End time " + cstr(gTestExecutionEndTime))
	
	If err.Number <> 0 Then
		Call fn_Logging ("ERROR"  , "fn_Driver" , "Run Time error " + Err.Description)
		Err.Clear
		fn_Driver=False
	End If
	
End Function




'RegisterUserFunc (
'Public Function PrintPropertyChange(blnPrintPropertyChange)
'	PrintPropertyChange=True
'	if not blnPrintPropertyChange = "TRUE" Then
'		Exit Function
'	End if
'	
'	
'	If Err.Number <> 0 Then
'		print "PrintPropertyChange: Run Time error " + Err.Description
'		Err.Clear
'		PrintPropertyChange=False
'	End  If
'End Function
