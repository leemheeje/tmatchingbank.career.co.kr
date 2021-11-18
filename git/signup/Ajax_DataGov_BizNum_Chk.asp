<%
'--------------------------------------------------------------------
'   기업회원 가입 > 사업자번호 유효성 검증> 국세청 오픈 API 제공 기업정보 조회
' 	최초 작성일	: 2021-11-03
'	최초 작성자	: 이샛별
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/aspJSON1.17.asp"-->
<%
Dim f_bizNum : f_bizNum = RTrim(LTrim(Replace(Request("bizNum"), "-", "")))	' 사업자등록번호

If Len(f_bizNum)=0 Then 
	f_bizNum = ""
Else 
	f_bizNum = f_bizNum
End If 

Dim v_rtnCd : v_rtnCd = ""
sData = "{""b_no"":["""&f_bizNum&"""]}"
Set objXMLHTTP = server.CreateObject("MSXML2.ServerXMLHTTP.3.0")
objXMLHTTP.Open "POST", "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=%2B2rGLZJ0QTl0EjeN5eToKBnfGvW26Uf6rnYvfacrBHGFnmeI%2FK3H21a4sPOPy1vkMJAckK%2BXVbS44kPAYE2EzA%3D%3D", False
objXMLHTTP.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
objXMLHTTP.Send sData

If objXMLHTTP.status = 200 Then

	Set oJSON = New aspJSON

	'Load JSON string
	oJSON.loadJSON(objXMLHTTP.responseText)

	For Each rslt In oJSON.data("data")
	    Set this = oJSON.data("data").item(rslt)
	    If this.item("b_stt_cd")="01" Then	' 국세청 기업정보 조회 결과 존재(국세청 기업정보에 없으면 '', 폐업상태로 확인되면 '03' 코드 리턴)
			v_rtnCd = "S"
		Else 
			v_rtnCd = "F"
		End If 
	Next
Else 
	v_rtnCd = "X"
End If 

objXMLHTTP.abort()
Set objXMLHTTP=Nothing


Response.write v_rtnCd
%>