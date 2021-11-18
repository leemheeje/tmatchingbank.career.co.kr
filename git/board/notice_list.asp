<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/paging.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: 공지사항 리스트
' 	History		: 2020-07-24, 이샛별
'--------------------------------------------------------------------
Dim gubun		: gubun			= Request("gubun")		' 게시판 구분
Dim target		: target		= Request("target")		' 검색구분(제목:1, 내용:2)
Dim schKeyword	: schKeyword	= Request("schKeyword") ' 검색어(제목/내용)
Dim page		: page			= Request("page")
Dim pageSize	: pageSize		= 10

If page="" Then page=1
page = CInt(page)

If gubun	= "" Then gubun		= "1"
If target	= "" Then target	= "1"

ConnectDB DBCon, Application("DBInfo")

'Dim Param(6)
'Param(0) = makeparam("@gubun",adChar,adParamInput,1,gubun)
'Param(1) = makeparam("@target",adChar,adParamInput,1,target)
'Param(2) = makeparam("@kw",adVarChar,adParamInput,100,schKeyword)
'Param(3) = makeparam("@page",adInteger,adParamInput,4,page)
'Param(4) = makeparam("@pagesize",adInteger,adParamInput,4,pagesize)
'Param(5) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")
'
'Dim arrayList(2)
'arrayList(0) = arrGetRsSP(DBcon,"usp_board_list",Param,"","")
'arrayList(1) = getParamOutputValue(Param,"@totalcnt")
'
'Dim arrRs		: arrRs		= arrayList(0)
'Dim Tcnt		: Tcnt		= arrayList(1)
'DIm pageCount	: pageCount = Fix(((Tcnt-1)/PageSize) +1)

DisconnectDB DBCon


Dim stropt
stropt = "gubun="&gubun&"&schKeyword="&schKeyword
%>
<!--#include virtual = "/common/header.asp"-->

<script type="text/javascript">
<!--
function fn_board_add() {
	var url = "board_form.asp";
	location.href = url;
}

// 키워드 검색
function fn_search() {
	var obj = document.frm_list;
	if ($("#schKeyword").val() == "") {
		alert("검색어를 입력해 주세요.");
		$("#schKeyword").focus();
		return false;
	}
	obj.action	= "notice_list.asp";
	obj.submit();
}

// 검색 초기화
function fn_reset() {
	var obj = document.frm_list;
	obj.schKeyword.value	= "";
	obj.action				= "notice_list.asp";
	obj.submit();
}
//-->
</script>
</head>
<body>

<!-- 상단 -->
<!--#include virtual = "/common/gnb/gnb_main.asp"-->
<!-- 상단 -->

<!-- 본문 -->
<form method="post" id="frm_list" name="frm_list">
<input type="hidden" id="gubun" name="gubun" value="<%=gubun%>">

<div id="contents" class="sub_page">
	<div class="sub_visual notice">
		<div class="visual_area">
			<%
			Select Case gubun
				Case "1" : Response.write "<h2>공지사항</h2>"
				Case "4" : Response.write "<h2>특강/채용설명회</h2>"
				Case "6" : Response.write "<h2>카드뉴스</h2>"
			End Select
			%>

		</div>
	</div>

	<div class="content">
		<div class="con_box">
			<div class="notice_area">
				<div class="searchArea">
					<div class="searchInner">
						<div class="fr">
							<div class="searchBox">
								<div>
									<input type="text" class="txt" id="schKeyword" name="schKeyword" placeholder="제목 또는 내용을 입력해 주세요" value="<%=schKeyword%>" style="width:377px;">
									<button type="button" class="btn typegray" onclick="fn_search();"><strong>검색</strong></button>
									<button type="button" class="btn typegray" onclick="fn_reset();"><strong>초기화</strong></button>
								</div>
							</div><!-- .searchBox -->
						</div><!--.fr-->
					</div><!--.searchInner-->
				</div>
				<div class="board_area">
					<table class="tb" summary="공지사항">
						<caption>공지사항</caption>
						<colgroup>
							<col style="width:100px">
							<col>
							<col style="width:200px">
							<col style="width:200px">
						</colgroup>
						<thead>
							<tr>
								<th>NO</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody>
							
							<!-- 샘플 리스트 -->
							<tr>
								<td>1</td>
								<td><a href="javascript:">제목입니다.</a></td>
								<td>박람회 운영사무국</td>
								<td>2020-11-11</td>
							</tr>
							<tr>
								<td>2</td>
								<td><a href="javascript:">제목입니다.</a></td>
								<td>박람회 운영사무국</td>
								<td>2020-11-11</td>
							</tr>
							<tr>
								<td>3</td>
								<td><a href="javascript:">제목입니다.</a></td>
								<td>박람회 운영사무국</td>
								<td>2020-11-11</td>
							</tr>


						<%
							Dim No : No = Tcnt - (PageSize * (page -1))
							Dim i, rs_seq, rs_gubun, rs_gubun_str, rs_title, rs_content, rs_regNm, rs_viewCnt, rs_regDt
							If IsArray(arrRs) Then
								For i=0 To UBound(arrRs,2)
									rs_seq		= Trim(arrRs(0,i))	' 등록번호
									rs_gubun	= Trim(arrRs(1,i))	' 게시판구분
									rs_title	= Trim(arrRs(5,i))	' 제목
									rs_content	= Trim(arrRs(6,i))	' 내용
									rs_regNm	= Trim(arrRs(3,i))	' 등록자명
									rs_viewCnt	= Trim(arrRs(7,i))	' 조회수
									rs_regDt	= Left(Trim(arrRs(9,i)),10)	' 등록일자

									Select Case rs_gubun
										Case 1 : rs_gubun_str = "공지사항"
										Case 2 : rs_gubun_str = "자주묻는질문(FAQ)"
										Case 3 : rs_gubun_str = "이벤트"
									End Select
						%>
									<tr>
										<td><%=No%></td>
										<td><a href="notice_view.asp?seq=<%=rs_seq%>&<%=stropt%>&page=<%=page%>"><%=rs_title%></a></td>
										<!--<td>박람회 운영사무국</td>-->
										<td><%=rs_regDt%></td>
									</tr>
						<%
									No = No - 1
								Next
							Else
								Dim strRslt
								If schKeyword<>"" Then
									strRslt = "해당 키워드로 검색된 결과가 없습니다."
								Else
									strRslt = "등록된 내역이 없습니다."
								End If
								Response.write "<tr><td colspan='4' class='no_data'>"&strRslt&"</td></tr>"
							End If

							DisconnectDB DBCon
						%>
						</tbody>
					</table>

					<%Call putPage(page, strParam, pageCount) %>

				</div><!--//board_area-->
			</div><!--//notice_area-->
		</div><!--//con_box-->
	</div><!-- .content -->

</div>
</form>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/common/footer.asp"-->
<!-- 하단 -->

</body>
</html>
