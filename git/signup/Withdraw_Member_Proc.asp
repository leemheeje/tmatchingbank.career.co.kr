<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 > 회원 탈퇴
' 	History		: 2021-08-05, 이샛별
'   DB TABLE	: dbo.개인회원정보
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/auth/clearCookie.asp"-->
<%
' 로그인 상태 접근 제한
Dim strLink : strLink = "/"
If Len(user_id)=0 Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다.",strLink)	
End If

f_txtName		= Request("txtName")		' 이름
f_txtPhone		= Request("txtPhone")		' 휴대폰번호
f_txtOutReason	= Request("txtOutReason")	' 탈퇴사유

ConnectDB DBCon, Application("DBInfo")

	Dim v_chkRsltCd : v_chkRsltCd = ""
	strQuery = "SPC_USER_INFO_SELECT '"& user_id &"'"
	rowRs = arrGetRsSql(DBCon, strQuery, "", "")
	If IsArray(rowRs) Then
		rs_memName		= Trim(rowRs(0,0))	' 회원명
		rs_memPhone		= Trim(rowRs(1,0))	' 휴대폰

		If CStr(f_txtName) <> CStr(rs_memName) Then
			v_chkRsltCd = "E1"
		Else
			If user_join_type="2" Then
				If CStr(f_txtPhone) <> CStr(rs_memPhone) Then
					v_chkRsltCd = "E2"
				Else 
					v_chkRsltCd = ""
				End If
			Else
				v_chkRsltCd = ""
			End If
		End If
	Else
		v_chkRsltCd = "E3"
	End If

	If v_chkRsltCd="" Then
		Dim SpName, param(8)
		SpName="SPU_WITHDRAW_USER_DELETE"
			param(0) = makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, user_id)
			param(1) = makeParam("@IN_V_WITHDRAW_TYPE", adChar, adParamInput, 1, "")
			param(2) = makeParam("@IN_V_WITHDRAW_REASON", adVarChar, adParamInput, 1000, f_txtOutReason)
			param(3) = makeParam("@IN_V_MEM_TYPE", adVarChar, adParamInput, 10, "mem")
			param(4) = makeParam("@IN_V_JOIN_GUBUN_CD", adChar, adParamInput, 2, user_join_type)
			param(5) = makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
			param(6) = makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
			param(7) = makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
			param(8) = makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

			Call execSP(DBCon, SpName, param, "", "")

			sp_rtn = getParamOutputValue(param, "@OUT_V_RTN")	' 저장 결과 리턴 값(S: 성공, F: 실패)

			If sp_rtn = "S" Then
				Call Sub_clearCookie  ' 모든 쿠키 정보 초기화
			End If

			v_chkRsltCd = sp_rtn
	Else 
		v_chkRsltCd = v_chkRsltCd
	End If

DisconnectDB DBCon

Response.write v_chkRsltCd
%>
