<%
'--------------------------------------------------------------------
'   기업회원 가입 > 사업자번호 유효성 검증
' 	최초 작성일	: 2021-08-13
'	최초 작성자	: 이샛별
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
Dim f_bizNum : f_bizNum = RTrim(LTrim(Replace(Request("bizNum"), "-", "")))	' 사업자등록번호


' 입력 사업자번호 유효성 체크 > 1)기업회원 가입 차단기업으로 분류되었는지 여부 검증
ConnectDB DBCon2, Application("DBInfo_REAL")

Dim spName, param(0)
spName = "USP_BLOCKED_COMPANY_SELECT"
param(0)	= makeParam("@BizCode", adVarChar, adParamInput, 10, f_bizNum)
ArrRsResult = arrGetRsSP(DBCon2, spName, param, "", "")

DisconnectDB DBCon2

Dim v_rtnCd
If isArray(ArrRsResult) Then	' 해당 사업자번호가 가입 차단 기업 리스트에 있을 경우 가입 불가 처리 코드 리턴
	v_rtnCd = "X"
Else
	' 입력 사업자번호 유효성 체크 > 2)해당 사업자번호로 기존 가입된 기업회원 정보가 있는지 체크
	ConnectDB DBCon, Application("DBInfo")

		Dim SpName2, param2(0)
		SpName2 = "SPU_BIZ_SIGNUP_ID_LIST"
		param2(0)		= makeParam("@BizCode", adVarChar, adParamInput, 10, f_bizNum)
		ArrRsResult2	= arrGetRsSP(DBCon, SpName2, param2, "", "")
		If isArray(ArrRsResult2) Then	' 해당 사업자번호로 가입된 정보가 존재한다면
			cntJoin = CInt(UBound(ArrRsResult2, 2)) + 1
		Else
			cntJoin = 0
		End If

	DisconnectDB DBCon

	If cntJoin = 0 Then
		v_rtnCd = "I"	' 동일 사업자번호로 가입된 내역 없음(최초 가입) - Insert
	Else
		v_rtnCd = "A"	' 해당 사업자번호로 가입된 내역 존재(추가) - Add
	End If

End If

Response.write v_rtnCd&"§"

' 해당 사업자번호로 가입된 기업회원 정보가 있다면 내역 리턴
If v_rtnCd = "A" Then
	Response.write "<div class='titTxt MT15'>"+VBCRLF
	Response.write "현재 인증하신 사업자등록번호로 <span class='org'>"&cntJoin&"개</span>의 아이디가 검색 되었습니다."+VBCRLF
	Response.write "<a href='/search/Find_Id_Biz.asp' class='blue FWB HOVER_UNDERLINE'>아이디 찾기<small class='ML05'>&gt;</small></a>"+VBCRLF
	Response.write "</div><div class='grid clearfix'>"+VBCRLF

	If isArray(ArrRsResult2) Then
		For i=0 To UBound(ArrRsResult2, 2)
			Response.write "<div class='cbox'><span class='nm'>"&ArrRsResult2(4,i)&"<span class='dat'>("&ArrRsResult2(1,i)&")</span></span></div>"+VBCRLF
		Next
	End If

	Response.write "</div>"+VBCRLF
End If
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
