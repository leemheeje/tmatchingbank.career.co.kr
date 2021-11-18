<div class="footer">
    <div class="fotSitemapArea">
        <div class="innerWrap">
            <ul class="lst">
                <li class="tp">
                    <!-- <a href="javascript:alert('준비 중 입니다.');" class="txt">회사소개</a> -->
					<!-- <a href="http://www2.career.co.kr/board/intro/%EC%BB%A4%EB%A6%AC%EC%96%B4_%ED%9A%8C%EC%82%AC%EC%86%8C%EA%B0%9C%EC%84%9C_20210414_v0.6.pdf" target="_blank" class="txt">회사소개</a> -->
					<a href="http://careernet.co.kr/" target="_blank" class="txt">회사소개</a>
                </li>
                <li class="tp">
                    <a href="/help/Terms_Service.asp" class="txt">이용약관</a>
                </li>
                <li class="tp">
                    <a href="/help/Privacy_Policy.asp" class="txt FWB">개인정보처리방침</a>
                </li>
                <li class="tp">
                    <a href="/help/Reject_Email.asp" class="txt">이메일무단수집거부</a>
                </li>
                <li class="tp">
                    <a href="javascript:alert('준비 중 입니다.');" class="txt">고객센터</a>
                </li>
                <li class="tp">
                    <a href="javascript:alert('준비 중 입니다.');" class="txt">광고문의</a>
                </li>
				<li class="tp">
					<a href="javaScript:void(0);" onclick="<%If g_LoginChk=0 Then%>fn_layerLogin()<%Else%>fn_layerQna()<%End If%>;" class="txt">1:1 맞춤상담</a>
				</li>
				<!-- <li class="tp">
                    <a href="javascript:alert('준비 중 입니다.');" class="txt">채용정보</a>
                </li>
				<li class="tp">
                    <a href="#" class="txt">API</a>
                </li> -->
            </ul>
        </div>
    </div>
    <div class="fotCopyArea">
        <div class="innerWrap">
            <div class="copy">
				<ul class="lst">
					<li class="tp inlable">
						<span class="lb ">커리어 고객센터 </span>
						<%=site_callback_phone%> (<%=site_helpdesk_opertime%>)
					</li>
					<li class="tp inlable">
						<span class="lb ">E-mail </span>
						<%=site_helpdesk_mail%>
					</li>
					<li class="tp inlable">
						<span class="lb ">Fax </span>
						<%=site_fax%>
					</li>
				</ul>
				<ul class="lst">
					<li class="tp ">
						Copyright (c) CareerNet All rights reserved.
					</li>
				</ul>
            </div>
        </div>
    </div>
</div>