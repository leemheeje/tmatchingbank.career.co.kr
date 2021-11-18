<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
Dim gubun		: gubun			= Request("gubun")		' 게시판 구분(2:개인, 3:기업)
Dim target		: target		= Request("target")		' 검색구분(제목:1, 내용:2)
Dim schKeyword	: schKeyword	= Request("schKeyword") ' 검색어(제목/내용)  
Dim page		: page			= Request("page")
Dim pageSize	: pageSize		= 100

If page = "" Then page = 1
page = CInt(page)

If gubun	= "" Then gubun		= "2"
If target	= "" Then target	= "1"

If gubun = "2" Then
	reDim arrGubun(4,1), arrRs(4)

	arrGubun(0,0) = "1" '회원가입.로그인
	arrGubun(1,0) = "2" '화상면접
	arrGubun(2,0) = "3" '이력서
	arrGubun(3,0) = "4" '입사지원
	arrGubun(4,0) = "5" '채용정보

	arrGubun(0,1) = "회원가입.로그인"
	arrGubun(1,1) = "화상면접"
	arrGubun(2,1) = "이력서"
	arrGubun(3,1) = "입사지원"
	arrGubun(4,1) = "채용정보"
ElseIf gubun = 3 Then
	reDim arrGubun(3,1), arrRs(3)

	arrGubun(0,0) = "1" '회원가입.로그인
	arrGubun(1,0) = "2" '화상면접
	arrGubun(2,0) = "6" '채용공고.관리
	arrGubun(3,0) = "7" '인재Pool

	arrGubun(0,1) = "회원가입.로그인"
	arrGubun(1,1) = "화상면접"
	arrGubun(2,1) = "이력서"
	arrGubun(2,1) = "채용공고.관리"
	arrGubun(3,1) = "인재Pool"
End If

'ConnectDB DBCon, Application("DBInfo_FAIR")
'	For i=0 To UBound(arrGubun)
'		reDim Param(6)
'		Param(0) = makeparam("@gubun",adChar,adParamInput,1,gubun)
'		Param(1) = makeparam("@target",adChar,adParamInput,1,target)
'		Param(2) = makeparam("@kw",adVarChar,adParamInput,100,schKeyword)
'		Param(3) = makeparam("@page",adInteger,adParamInput,4,page)
'		Param(4) = makeparam("@pagesize",adInteger,adParamInput,4,pagesize)
'		Param(5) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")
'		Param(6) = makeparam("@jobs_id",adInteger,adParamInput,4, arrGubun(i,0))
'		
'		arrRs(i) = arrGetRsSP(DBcon,"usp_board_list",Param,"","")
'	Next 
'DisconnectDB DBCon
%>

<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">
	function fn_tab_show(_val) {
		$('#tab1').hide();
		$('#tab2').hide();
		$('#tab3').hide();
		$('#tab4').hide();
		$('#tab5').hide();
		$('#tab6').hide();
		$('#tab7').hide();

		$('#tab' + _val).show();
	}

	function fn_hit_add(_seq) {
		$.ajax({
            type: "POST",
            url: "ajax_hit_add.asp",
			data: { seq : _seq },
            success: function (data) {
            },
            error:function(request,status,error){
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
        });
	}
</script>
</head>
<body>

<!-- 상단 -->
<!--#include virtual = "/common/gnb/gnb_main.asp"-->

<form id="frm" name="frm" method="get">
<input type="hidden" id="gubun" name="gubun" value="<%=gubun%>">
<input type="hidden" id="tab" name="tab" value="<%=tab%>">
</form>

<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="sub_visual faq">
		<div class="visual_area">
			<h2><img src="/images/h2_faq.png" alt="자주묻는 질문"></h2>
		</div>
	</div>
	<div class="content">
		<div class="con_box">
			<div class="faq_area">
				<div class="pickArea tabs">
					<ul>
						<% For i=0 To UBound(arrGubun) %>
						<li id="li_tab<%=arrGubun(i,0)%>" <% If gubun = "2" Then %>style="width:20%;"<% End If %>>
							<a href="#tab<%=arrGubun(i,0)%>" id="a_tab<%=arrGubun(i,0)%>" onclick="fn_tab_show('<%=arrGubun(i,0)%>');"><%=arrGubun(i,1)%></a>
						</li>
						<% Next %>
					</ul>
					
					<script>
						$(".faq_area .pickArea li").click(function() {
							$(this).removeClass("on");
							$(this).addClass("on"); 
							return false;
						});
					</script>

				</div>

				<%
				For i=0 To UBound(arrRs)
				%>
				<div id="tab<%=arrGubun(i,0)%>" class="acco_area tab_content">
					<ul class="acco">
					<%
					If isArray(arrRs(i)) Then
					For j=0 To UBound(arrRs(i), 2)
					%>
						<li>
							<a href="#none" onclick="fn_hit_add(<%=arrRs(i)(0, j)%>);">
								<span class="question">Q.</span>
								<%=arrRs(i)(5, j)%>
							</a>
							<div class="acco_txt">
								<%=arrRs(i)(6, j)%>
							</div>
						</li>
					<%
					Next
					End If 
					%>
					</ul>
				</div>
				<%
				Next
				%>
			</div>
		</div>
	</div><!-- .content -->

</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/common/footer.asp"-->
<!-- 하단 -->
