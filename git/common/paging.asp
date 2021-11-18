<%
Dim pageUrl : pageUrl = Request.ServerVariables("URL")

Sub putPage(Page, stropt, PageCount)
	If int(PageCount) > 1 Then
		Const divPage = 10
		Dim tPage		: tPage = Int((Page - 1) / divPage) * divPage + 1
		Dim str_write	: str_write = ""
		
		str_write = str_write & "<div class='pagination MT30'>"
		If PageCount > divPage Then
			If Page > 10 Then
				str_write = str_write & "<div class='ptp contr prev'><a href='"& pageUrl &"?page="& tPage - divPage &"&"& stropt &"' class='txt'></a></div>"
			Else

			End If

			For ii = tPage To tPage + divPage - 1
				If ii> PageCount Then Exit For

				If Trim(ii) = Trim(Page) Then
					str_write = str_write & "<div class='ptp active'><a href='javascript:' class='txt'>"& ii &"</a></div>"
				Else
					str_write = str_write & "<div class='ptp'><a href='"& pageUrl &"?page="& ii &"&"& stropt &"' class='txt'>"& ii &"</a></div>"
				End If
			Next

			If PageCount >= ii Then
				str_write = str_write & "<div class='ptp contr next'><a href='"& pageUrl &"?page="& ii &"&"& stropt &"' class='txt'></a></div>"
			Else

			End If
		Else

			If Page > 10 Then 
				str_write = str_write & "<div class='ptp contr prev'><a href='"& pageUrl &"?page="& tPage - divPage &"&"& stropt &"' class='txt'></a></div>"
			End If

			For ii = 1 To PageCount
				If Trim(ii) = Trim(Page) Then
					str_write = str_write & "<div class='ptp active'><a href='javascript:' class='txt'>"& ii &"</a></div>"
				Else
					str_write = str_write & "<div class='ptp'><a href='"& pageUrl &"?page="& ii &"&"& stropt &"' class='txt'>"& ii &"</a></div>"
				End If
			Next

			If PageCount > ii Then
				str_write = str_write & "<div class='ptp contr next'><a href='"& pageUrl &"?page="& ii &"&"& stropt &"' class='txt'></a></div>"
			Else 

			End If
		End If

		str_write = str_write & "</div>"

		Response.write str_write
	End If
End Sub


Sub putPage_Mobile(Page, stropt, PageCount)
	If int(PageCount) > 1 Then
		Const divPage = 5
		Dim tPage		: tPage = Int((Page - 1) / divPage) * divPage + 1
		Dim str_write	: str_write = ""
		
		str_write = str_write & "<div class='paging'>"
		If PageCount > divPage Then
			If Page > 5 Then
				str_write = str_write & "<a class='btn prev' href='"& pageUrl &"?page="& tPage - divPage &"&"& stropt &"'><span>이전</span></a>"
			Else

			End If

			For ii = tPage To tPage + divPage - 1
				If ii> PageCount Then Exit For

				If Trim(ii) = Trim(Page) Then
					str_write = str_write & "<a href='javascript:' class='on'>"& ii &"</a>"
				Else
					str_write = str_write & "<a href='"& pageUrl &"?page="& ii &"&"& stropt &"'>"& ii &"</a>"
				End If
			Next

			If PageCount >= ii Then
				str_write = str_write & "<a class='btn next' href='"& pageUrl &"?page="& ii &"&"& stropt &"'></a>"
			Else

			End If
		Else

			If Page > 5 Then 
				str_write = str_write & "<a class='btn prev' href='"& pageUrl &"?page="& tPage - divPage &"&"& stropt &"'></a>"
			End If

			For ii = 1 To PageCount
				If Trim(ii) = Trim(Page) Then
					str_write = str_write & "<a href='javascript:' class='on'>"& ii &"</a>"
				Else
					str_write = str_write & "<a href='"& pageUrl &"?page="& ii &"&"& stropt &"'>"& ii &"</a>"
				End If
			Next

			If PageCount > ii Then
				str_write = str_write & "<a class='btn next' href='"& pageUrl &"?page="& ii &"&"& stropt &"'></a>"
			Else 

			End If
		End If

		str_write = str_write & "</div>"

		Response.write str_write
	End If
End Sub
%>
