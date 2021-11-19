<%
'====================================================================
'	개인회원 서비스 - 이력서등록 - 사진변경팝업
'	최초작성일	: 2021-03-24
'====================================================================
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
Dim temppath, sourcepath
temppath = "\\218.145.70.142\fdrive$\temp\"
sourcepath = "\\218.145.70.142\fdrive$\mypic\"

Dim targetpath, datepath
datepath	= Left(replace(FormatDateTime(Now(), 2),"-",""), 6)
targetpath	= sourcepath & datepath & "\"

Dim objFS
Set objFS = CreateObject("Scripting.FileSystemObject")

Dim Post, UploadedFile
Dim fileName, fileExtension, fileSize
Dim strsql
'developer00@218.145.70.187:42:/www/renew/user/resume/Pop_Userinfo_Photo_Upload.asp
'이미지 올리기
If InStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 Then
	'Perform the upload
	Set Post = Server.CreateObject("ActiveFile.Post")

	On Error Resume Next

	'Post.Upload sourcepath
	Post.upload temppath

	Set UploadedFile = Post("uploadFile").File
	fileExtension = UploadedFile.FileExtension
	fileSize = UploadedFile.Size
	fileName = UploadedFile.FileName

	'Response.write "Extension : " & fileExtension & "<br>"
	'Response.write "fileSize : " & fileSize & "<br>"
	'Response.write "fileName : " & fileName & "<br>"
	
	Dim maxFileSize : maxFileSize = 1024 * 1024 * 10
	
	'파일 사이즈 체크
	If CLng(fileSize) > maxFileSize Then
		UploadedFile.Delete
		Set UploadedFile = Nothing
		
		Post.Flush
		Set Post = Nothing
		
		Response.write "Fail<br>" & "첨부파일을 등록할 수 없습니다. 등록할 수 있는 파일 사이즈는 최대" & (maxFileSize/1024/1024) & "MB 입니다."
		Response.end
	Else
		'폴더없을 시 생성
		If objFs.FolderExists(targetpath) = False Then
			objFs.CreateFolder(targetpath)
		End If

		dim newFileName : newFileName = user_id

		UploadedFile.Copy targetpath & newFileName & "." & fileExtension
		UploadedFile.Delete

		Post.Flush

		set UploadedFile=Nothing
		set Post=Nothing

		ConnectDB DBCon, Application("DBInfo")
			
			strsql = ""
			strsql = strsql & " UPDATE 개인회원정보 SET 사진파일 = '" & datepath & "/" & newFileName & "." & fileExtension & "' WHERE 개인아이디 = '" & user_id & "';"
			strsql = strsql & " UPDATE 이력서공통정보 SET 사진파일='" & datepath & "/" & newFileName & "." & fileExtension & "' WHERE 개인아이디 = '" & user_id & "';"

			DBCon.Execute(strsql)

		DisconnectDB DBCon
		
		Dim strDT, SetPhotoPath
		strDT = Year(Now()) & Month(Now()) & Day(Now()) & Hour(Now()) & Minute(Now()) & Second(Now())
		SetPhotoPath = "Success<br>" & "//www2.career.co.kr/mypic/<br>" & datepath & "/" & newFileName & "." & fileExtension & "<br>?" & strDT

		Response.write SetPhotoPath
	End If
End If
%>
