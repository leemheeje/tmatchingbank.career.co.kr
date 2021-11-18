<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 > 회원 탈퇴 > 본인확인(비번 인증)
' 	History		: 2021-08-05, 이샛별
'   DB TABLE	: dbo.개인회원정보
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->
<%
f_txtPass	= RTrim(LTrim(Replace(Request("user_pw"), "'", "''")))	' 비밀번호

' 전달된 비번 암호화
v_pw_SHA256	= SHA256_Encrypt(f_txtPass)	' > /wwwconf_renew/function/library/KISA_SHA256.asp


ConnectDB DBCon, Application("DBInfo")

Dim rowRs, param(0)
Dim v_chkRsltCd : v_chkRsltCd = ""
param(0)	= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, user_id)
rowRs		= arrGetRsSP(DBCon, "SPC_USER_INFO_SELECT", param, "", "")
If IsArray(rowRs) Then
	rs_memPw = Trim(rowRs(18,0))	' 암호화 비번
Else
	v_chkRsltCd = "F"
End If

DisconnectDB DBCon

' 유효성 검증 - 입력한 비번과 DB 저장 비번 정보 비교, 불일치 시 리턴
If CStr(v_pw_SHA256) <> CStr(rs_memPw) Then 
	v_chkRsltCd = "F"
Else
	v_chkRsltCd = "S"
End If

Response.write v_chkRsltCd
%>
