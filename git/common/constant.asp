<%
'------ 공통사용 변수
'사이트구분값
Const SiteKey =  "AT"

'암호화 키
Const CIPHER_KEY = "career"

'메뉴코드
Dim g_MenuID
Dim g_MenuID_Navi

'디버그
Dim g_Debug

'페이지처리 시작시간
Dim g_STimer

'롤백URL
Dim redir

'로그인 체크
Dim g_LoginChk

'------ 개인 쿠키 변수
Dim user_id, user_name, user_phone, user_email, user_photo, user_join_type

'------ 기업 쿠키 변수
Dim com_id, com_name, com_kind, com_logo

'------ 퍼블리싱(css, js) 최종수정일 반영 변수
Dim publishUpdateDt : publishUpdateDt = "20211105"

'------ AES256 암호화 키값
Dim aesKeyValue : aesKeyValue = "2a57476371324036504e43242e736e63"

'------ 회사정보 및 대표번호, 이메일 주소(고객센터), 고객센터 운영시간, 사업자등록번호, 직업정보제공사업 신고번호, 통신판매업 신고번호
Dim site_ceo_name, site_addr_info, site_callback_phone, site_helpdesk_mail, site_helpdesk_opertime, site_com_license, site_jobinfo_license, site_electro_license, site_com_name
site_ceo_name			= "윤태운"
site_addr_info			= "(08381)서울특별시 구로구 디지털로 273, 2층(구로동, 에이스트윈타워 2차)"
site_callback_phone		= "1577-0221(수도권), 1577-8505(지방거점)"
site_helpdesk_mail		= "matchingbank@matchingbank.kr"
site_helpdesk_opertime	= "평일 09:00~18:00 (주말, 공휴일 휴무)"
site_com_license		= "220-86-73547"
site_jobinfo_license	= "서울관악 제 2010-10호"
site_electro_license	= "2010-서울구로-0401"
site_com_name			= "대체인력뱅크"
%>
