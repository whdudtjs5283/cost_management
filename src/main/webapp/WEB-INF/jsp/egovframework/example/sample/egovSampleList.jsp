<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : egovSampleList.jsp
  * @Description : Sample List 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용0
  *  -------    --------    ---------------------------
  *  2009.02.01            최초 생성
  *
  * author 실행환경 개발팀
  * since 2009.02.01
  *
  * Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>"/>
    <script src="//code.jquery.com/jquery.min.js"></script>
    <script type="text/javaScript" language="javascript" defer="defer">
     
        /* 글 수정 화면 function */
        function fn_egov_select(id) {
        	
          	var pop_title = "popup";
          	window.name = "list";
          	window.open("", pop_title, "width=730, height=600");
        	document.listForm.target = pop_title;
        	document.listForm.selectedId.value = id;
           	document.listForm.action = "<c:url value='/updateSampleView.do'/>";
           	document.listForm.submit();
           	
/*         	 document.listForm.selectedId.value = id;
           	document.listForm.action = "<c:url value='/updateSampleView.do'/>";
           	document.listForm.submit();  */
        }

        /* 글 등록 화면 function */
        function fn_egov_addView() {
        	
        	var pop_title = "popup";
        	window.name = "list";
        	window.open("", pop_title, "width=730, height=600");
        	document.listForm.target = pop_title;
            document.listForm.action = "<c:url value='/addSampleView.do'/>";
           	document.listForm.submit(); 
           	
          /*   document.listForm.action = "<c:url value='/addSampleView.do'/>";
           	document.listForm.submit(); */ 
        }
        
        /* 글 목록 화면 function */
        function fn_egov_selectList() {
        	document.listForm.action = "<c:url value='/egovSampleList.do'/>";
           	document.listForm.submit();
        }
        
		$(function(){
			$("#regDate").on("change", function(){
	        	var date = $("#regDate").val().replace(/\-/g,"/");
	        	console.log(date);
				$("#formDate").val(date);
	        });
		});

	    function reset() {
			$("#listForm")[0].reset();
	    }

        
        /* pagination 페이지 링크 function */
     /*    function fn_egov_link_page(pageNo){
        	document.listForm.pageIndex.value = pageNo;
        	document.listForm.action = "<c:url value='/egovSampleList.do'/>";
           	document.listForm.submit();
        } */
        
        //
    </script>
</head>

<body style="text-align:center; margin:0 auto; display:inline; padding-top:100px;">
 	 <form id="excelForm" name="excelForm" method="post" action="/cost/ExcelPoi.do">
	    <input type="hidden" name="fileName" value="경비_사용내역"/>
	    <input type="hidden" name="searchRegDate" value="${ searchVO.searchRegDate }" />
	    <input type="hidden" name="searchStatus" value=" ${ searchVO.searchStatus }"/>
	    <input type="hidden" name="searchUsage" value="${ searchVO.searchUsage }"/>
	    <div class="checkbox">
	  		<input type="checkbox" name="cellTitle" value="사용일"/><label>사용일</label>
	  		<input type="checkbox" name="cellTitle" value="사용내역"/><label>사용내역</label>
	  		<input type="checkbox" name="cellTitle" value="사용금액"/><label>사용금액</label>
	  		<input type="checkbox" name="cellTitle" value="승인금액"/><label>승인금액</label>
	  		
	    </div>
	    <input type="submit" value="엑셀 다운로드" />
	 </form>
    <form:form commandName="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId"/>
        <div id="content_pop">
        	<!-- 타이틀 -->
        	<div id="title">
        		<ul>
        			<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="title.cost"/></li>
        		</ul>
        	</div>
        	<!-- // 타이틀 -->
        	<div id="table">
        		<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="등록연월, 사용내역, 처리상태">
        			<caption style="visibility:hidden">등록연월, 사용내역, 처리상태</caption>
        			<colgroup>
        				<col width="?"/>
        				<col width="?"/>
						<col width="?"/>
        			</colgroup>
            			<tr>	
            				<td align="left" class="listtd">
            					<spring:message code="title.cost.regdateym" />&nbsp;<input type="month"  id="regDate"/>
            					<form:hidden path="searchRegDate" id="formDate" value="${ regDate }"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            					<spring:message code="title.cost.usagelist" />&nbsp;
            						<form:select path="searchUsage" cssClass="use">
            							<form:option value="U00" label="전체"/>
            							<form:option value="U01" label="식대(야근)"/>
            							<form:option value="U02" label="택시비(야근)"/>
            							<form:option value="U03" label="택시비(회식)"/>
            							<form:option value="U04" label="사무용품 구매"/>
            							<form:option value="U05" label="교육비"/>
            							<form:option value="U06" label="접대비"/>
            						</form:select>
            					<br/><br/>
            					<spring:message code="title.cost.status" />&nbsp;
            					<form:select path="searchStatus" cssClass="use">
            							<form:option value="S00" label="전체"/>
            							<form:option value="S01" label="접수"/>
            							<form:option value="S02" label="승인"/>
            							<form:option value="S03" label="지급완료"/>
            							<form:option value="S04" label="반려"/>
            						</form:select>
            				</td>
            				<td align="left" class="listtd"><br/><br/>
	            				<span class="btn_blue_l">
						        	<a href="javascript:reset();"><spring:message code="button.cost.reset" /></a>
						        	<img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" alt=""/>
						        </span>
            				</td>
            				<td align="left" class="listtd"><br/><br/>
            					 <span class="btn_blue_l">
						        	<a href="javascript:fn_egov_selectList();"><spring:message code="button.search" /></a>
						        	<img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" alt=""/>
						        </span>
            				</td>
            			</tr>
        		</table>
        	</div>
        	총 ${ paginationInfo.totalRecordCount }건
        	<div id="sysbtn">
        	  <ul>
        	      <li>
        	          <span class="btn_blue_l">
        	              <a href="javascript:fn_egov_addView();"><spring:message code="button.create" /></a>
                          <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                      </span>
                  </li>
              </ul>
        	</div>
        	<!-- List -->
        	<div id="table">
        		<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="순번, 사용일, 사용내역, 사용금액, 승인금액, 처리상태, 등록일">
        			<caption style="visibility:hidden">순번, 사용일, 사용내역, 사용금액, 승인금액, 처리상태, 등록일</caption>
        			<colgroup>
        				<col width="?"/>
        				<col width="?"/>
        				<col width="?"/>
        				<col width="?"/>
        				<col width="?"/>
        				<col width="?"/>
        				<col width="?"/>
        			</colgroup>
        			<tr>
        				<th align="center">순번</th>
        				<th align="center"><spring:message code="title.cost.usagedate" /></th>
        				<th align="center"><spring:message code="title.cost.usagelist" /></th>
        				<th align="center"><spring:message code="title.cost.usagecost" /></th>
        				<th align="center"><spring:message code="title.cost.okcost" /></th>
        				<th align="center"><spring:message code="title.cost.status" /></th>
        				<th align="center"><spring:message code="title.cost.regdate" /></th>
        			</tr>
        			<c:forEach var="result" items="${resultList}" varStatus="status">
            			<tr>		
            				<td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
            				<%-- <td align="center" class="listtd"><c:out value="${result.id}"/>&nbsp;</td> --%>
            				<td align="center" class="listtd"><c:out value="${result.usage_date}"/>&nbsp;</td>
            				<td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.id}"/>')"><c:out value="${result.u_codeName}"/></a></td>
            				<td align="center" class="listtd"><fmt:formatNumber value="${result.usage_cost}" pattern="#,###" />&nbsp;</td>
            				<td align="center" class="listtd"><fmt:formatNumber value="${result.ok_cost}" pattern="#,###" />&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.s_codeName}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.reg_date}"/>&nbsp;</td>
            			</tr>
            			<c:set var= "usageSum" value="${usageSum + result.usage_cost}"/>
						<c:set var= "okSum" value="${okSum + result.ok_cost}"/>
        			</c:forEach>
        			    <tr>
            				<td align="center" class="listtd">합계</td>
            				<td align="center" class="listtd"></td>
            				<td align="center" class="listtd"></td>
            				<td align="center" class="listtd"><fmt:formatNumber value="${usageSum}" pattern="#,###" /></td>
            				<td align="center" class="listtd"><fmt:formatNumber value="${okSum}" pattern="#,###" /></td>
            				<td align="center" class="listtd"></td>
            				<td align="center" class="listtd"></td>
            			</tr>
        		</table>
        	</div>
        	<!-- /List -->
        	<div id="paging">
        		
        	<%-- 	<form:hidden path="pageIndex" /> --%>
        	</div>
        	
        </div>
    </form:form>
</body>
</html>
