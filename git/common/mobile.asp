<%
Dim MobileBm, i_mobile
MobileBm = Request.QueryString("bm")

g_mobile_wk = "http://m.career.co.kr"
Dim g_test_mobile_wk 

If InStr(request.servervariables("server_name"),"test.") > 0 Then
	g_mobile_wk = "http://tm.career.co.kr"
End If 

Dim arr_mobile, arr_str_mobile, mobile_user_agent, bln_mobile, mobile_reffer
Dim b_mobile_referer
Dim str_httphost 

str_httphost = request.ServerVariables("HTTP_HOST")
mobile_user_agent = Request.ServerVariables("HTTP_USER_AGENT")
mobile_reffer = Request.ServerVariables("HTTP_REFERER")

mobile_user_agent = Lcase(mobile_user_agent)

bln_mobile = false
'arr_mobile = "midp|j2me|avant|docomo|novarra|palmos|palmsource|240x320|opwv|chtml|pda|windows ce|mmp/|blackberry|mib/|symbian|wireless|nokia|hand|mobi|phone|cdm|up.b|audio|SIE-|SEC-|samsung|HTC|mot-|mitsu|sagem|sony|alcatel|lg|eric|vx|philips|mmm|xx|panasonic|sharp|wap|sch|rover|pocket|benq|java|pt|pg|vox|amoi|bird|compal|kg|voda|sany|kdd|dbt|sendo|sgh|gradi|dddi|moto|iphone|ipod|ipad|android|windows ce|Windows Phone|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|SonyEricsson"
arr_mobile = "android|iPhone|iPad"


arr_mobile = Lcase(arr_mobile)
arr_str_mobile = split(arr_mobile, "|")
FOR i_mobile=0 TO Ubound(arr_str_mobile)

	IF Instr(mobile_user_agent, arr_str_mobile(i_mobile)) > 0 THEN
		bln_mobile = True
		Exit For 
	END IF
Next

IF (bln_mobile = true) Then

	If LCase(MobileBm) = "1" Then
		Response.Cookies("BM") = "Y"
		b_mobile_referer = True
	Else 
		If mobile_reffer = "" Then 
			b_mobile_referer = False 
		ElseIf request.Cookies("BM") = "" Then 
			b_mobile_referer = False 
		Else 
			If request.Cookies("BM") = "Y" Then 
				If InStr(LCase(mobile_reffer),LCase(str_httphost)) < 0 Then 
					b_mobile_referer = False 
				ElseIf InStr(LCase(mobile_reffer),LCase(str_httphost)) >= 0  Then 
					b_mobile_referer = true 
				ElseIf  LCase(mobile_reffer) = "http://" & LCase(str_httphost) & "/index.html" Then 
					b_mobile_referer = true 
				End If 
			Else
				b_mobile_referer = False
			End If 

		End If  

	End If 


	If b_mobile_referer = False  Then

			Response.Cookies("BM") = ""
			Response.redirect g_mobile_wk
			
			Response.End 

	Else
		Response.Cookies("BM") = "Y"
	End If 
END If
%>
