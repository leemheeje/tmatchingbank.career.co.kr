<%

Function URLDecode(strSText)
  dim deStr
  dim c,i,v
  deStr=""
  for i=1 to len(strSText)
  c=Mid(strSText,i,1)
  if c="%" then
  v=eval("&h"+Mid(strSText,i+1,2))
  if v<128 then
  deStr=deStr&chr(v)
  i=i+2
  else
  if isvalidhex(mid(strSText,i,3)) then
  if isvalidhex(mid(strSText,i+3,3)) then
  v=eval("&h"+Mid(strSText,i+1,2)+Mid(strSText,i+4,2))
  deStr=deStr&chr(v)
  i=i+5
  else
  v=eval("&h"+Mid(strSText,i+1,2)+cstr(hex(asc(Mid(strSText,i+3,1)))))
  deStr=deStr&chr(v)
  i=i+3 
  end if 
  else 
  destr=destr&c
  end if
  end if
  else
  if c="+" then
  deStr=deStr&" "
  else
  deStr=deStr&c
  end if
  end if
  next
  URLDecode=deStr
  end function

  function isvalidhex(str)
  Dim c
  isvalidhex=true
  str=ucase(str)
  if len(str)<>3 then isvalidhex=false:exit function
  if left(str,1)<>"%" then isvalidhex=false:exit function
  c=mid(str,2,1)
  if not (((c>="0") and (c<="9")) or ((c>="A") and (c<="Z"))) then isvalidhex=false:exit function
  c=mid(str,3,1)
  if not (((c>="0") and (c<="9")) or ((c>="A") and (c<="Z"))) then isvalidhex=false:exit function
  end function
%>