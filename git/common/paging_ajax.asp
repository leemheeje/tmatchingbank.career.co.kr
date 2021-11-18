<%
Dim pageUrl : pageUrl = Request.ServerVariables("URL")

Sub putPage(Page, strOpt, totalPage, function_name)

	Const divPage = 10
	Dim PageCount : PageCount = totalPage
	Dim tPage : tPage = Int((Page - 1) / divPage) * divPage + 1

	Response.write "<div class='pagination'>"

	If PageCount > divPage Then

		If Page > 10 Then
			Response.write "<div class='ptp contr prev'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& tPage-divPage &")' class='txt'></a></div>"
		Else

		End If

		For ii = tPage To tPage + divPage - 1
			If ii> PageCount Then Exit For

			If Trim(ii) = Trim(Page) Then
				Response.write "<div class='ptp active'><a href='javascript:' class='txt'>" & ii & "</a></div>"
			Else
				Response.write "<div class='ptp'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& ii &")' class='txt'>" & ii & "</a></div>"
			End If
		Next

		If PageCount >= ii Then
			Response.write "<div class='ptp contr next'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& ii &")' class='txt'></a></div>"
		End If
	Else

		If Page > 10 Then 
			Response.write "<div class='ptp contr prev'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& tPage-divPage &")' class='txt'></a></div>"
		End If

		For ii = 1 To PageCount
			If Trim(ii) = Trim(Page) Then
				Response.write "<div class='ptp active'><a href='javascript:' class='txt'>" & ii & "</a></div>"
			Else
				Response.write "<div class='ptp'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& ii &")' class='txt'>" & ii & "</a></div>" 
			End If
		Next

		If PageCount > ii Then
			Response.write "<div class='ptp contr next'><a href='javascript:' onclick='"&function_name&"("""& strOpt &""", "& ii &")' class='txt'></a></div>"
		End If

	End If

	Response.write "</div>"

End Sub	
%>
