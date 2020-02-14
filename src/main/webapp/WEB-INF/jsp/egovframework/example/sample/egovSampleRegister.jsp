<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : egovSampleRegister.jsp
  * @Description : Sample Register 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
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
    <c:set var="registerFlag" value="${empty sampleVO.id ? 'create' : 'modify'}"/>
    <title>Sample <c:if test="${registerFlag == 'create'}"><spring:message code="button.create" /></c:if>
                  <c:if test="${registerFlag == 'modify'}"><spring:message code="button.modify" /></c:if>
    </title>
    
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>"/>
    
    <!--For Commons Validator Client Side-->
    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
    <script src="//code.jquery.com/jquery.min.js"></script>
    <script type="text/javaScript" language="javascript" defer="defer">
  
        /* 글 목록 화면 function */
        function fn_egov_selectList() {
           	document.detailForm.action = "<c:url value='/egovSampleList.do'/>";
           	document.detailForm.submit();
           	window.close();
        }  

        /* 글 삭제 function */
        function fn_egov_delete() {
        	if(confirm("삭제하시겠습니까?")) {
       		opener.name = "list";
       		document.detailForm.target = opener.name;
           	document.detailForm.action = "<c:url value='/deleteSample.do'/>";
           	document.detailForm.submit();
           	window.close();
        	}
        }
        
        
        /* 글 등록 function */
        function fn_egov_save() {
        	if($("#formDate").val() == 0) {	
        		alert("사용일을 입력하세요");
        		return;
        	}
        	
        	if($("#u_cost").val() == 0) {	
        		alert("금액을 입력하세요");
        		return;
        	}

        	if(${registerFlag == "create"}) {
        		
            	if($("#rec_o").val() == 0) {	
            		alert("영수증을 등록하세요");
            		return;
            	} 
            	
	            if(confirm("등록하시겠습니까?")) {
		        	frm = document.detailForm;
		         	if(!validateSampleVO(frm)){
		                return;
		            }else {
		            	opener.name = "list";
		            	frm.target = opener.name;
		            	frm.action = "<c:url value="${registerFlag == 'create' ? '/addSample.do' : '/updateSample.do'}"/>";
		              	frm.submit();
		              	window.close();
		            }
	            		}  	
        } else {
        	
        	
        	if(confirm("수정하시겠습니까?")) {
	        	frm = document.detailForm;
	         	if(!validateSampleVO(frm)){
	                return;
	            }else{
	            	opener.name = "list";
	            	frm.target = opener.name;
	            	frm.action = "<c:url value="${registerFlag == 'create' ? '/addSample.do' : '/updateSample.do'}"/>";
	                frm.submit();
	                window.close();
	            }
            		}  	
        }
        	
    }
        
        function fn_egov_save2() {
      	
        	if($("#sc").val() == "S01") {
        		alert("접수 상태로 승인 요청 할 수 없습니다.");
        		return;
        	}
        	
    		if($("#ok_cost").val() == 0) {	
        		alert("승인금액을 입력하세요");
        		return;
    		}
    		
    		if($("#ok_cost").val() > $("#u_cost").val()) {	
        		alert("승인금액은 사용금액보다 클 수 없습니다");
        		return;
    		}
        	
        	if(confirm("승인하시겠습니까?")) {
        	
        		
	        	frm = document.detailForm;
	         	if(!validateSampleVO(frm)){
	                return;
	            }else{
	            	opener.name = "list";
	            	frm.target = opener.name;
	            	frm.action = "<c:url value="${registerFlag == 'create' ? '/addSample.do' : '/updateSample.do'}"/>";
	               frm.submit();
	            }
            		}  	
        	window.close();
    }
        
        
    	$(function(){
			$("#useDate").on("change", function(){
	        	var date = $("#useDate").val().replace(/\-/g,"/");
	        	console.log(date);
				$("#formDate").val(date);
	        });
		});
    
    	
    	
    </script>
</head>
<body style="text-align:center; margin:0 auto; display:inline; padding-top:100px;">
<form:form commandName="sampleVO" id="detailForm" name="detailForm" method="post" enctype="multipart/form-data">
<form:hidden path="id"/>
<form:hidden path="reg_date"/>
<form:hidden path="receipt_o"/>
<form:hidden path="receipt_r"/>

    <div id="content_pop">
    	<!-- 타이틀 -->
    	<div id="title">
    		<ul>
    			<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}"><spring:message code="button.create" /></c:if>
                    <c:if test="${registerFlag == 'modify'}"><spring:message code="button.modify" /></c:if>
                </li>
    		</ul>
    	</div>
    	<div id="sysbtn">
    		<ul>
	    		<li>
	    			<h2 style="margin-right:452px;">청구내역</h2>
	    		</li>
    			<li><c:if test="${registerFlag == 'create'}">
                    <span class="btn_blue_l">
                        <a href="javascript:fn_egov_save();">
                           <spring:message code="button.create" />
                        </a>
                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                    </span>
                    </c:if>
                    <c:if test="${registerFlag == 'modify'}">
                    	<c:if test="${ sampleVO.s_code.equals('S01') }">
		                    <span class="btn_blue_l">
		                        <a href="javascript:fn_egov_save();">
		                            <spring:message code="button.modify" />
		                        </a>
		                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
		                    </span>
		                </c:if>
                    </c:if>
                </li>
                <li>
                    <span class="btn_blue_l">
                        <a href="javascript:fn_egov_selectList();"><spring:message code="button.list" /></a>
                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                    </span>
                </li>
    			<c:if test="${registerFlag == 'modify'}">
    				<c:if test="${ sampleVO.s_code.equals('S01') }">
	                    <li>
	                        <span class="btn_blue_l">
	                            <a href="javascript:fn_egov_delete();"><spring:message code="button.delete" /></a>
	                            <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
	                        </span>
	                    </li>
                    </c:if>
                    <c:if test="${ !sampleVO.s_code.equals('S01') }">
	                    <li>
	                    </li>
                    </c:if>
    			</c:if>
            </ul>
    	</div>
    	<!-- // 타이틀 -->
    	<div id="table">
    	<table width="100%" border="1" cellpadding="0" cellspacing="0" style="bordercolor:#D3E2EC; bordercolordark:#FFFFFF; BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
    		<colgroup>
    			<col width="150"/>
    			<col width="?"/>
    		</colgroup>
    		<tr>
    			<td class="tbtd_caption"><label for="u_code"><spring:message code="title.cost.usagelist" /></label></td>
    			<td class="tbtd_content">
    					<c:if test='${ sampleVO.s_code eq null or sampleVO.s_code.equals("S01") }'>
	    					<form:select path="u_code" cssClass="use">
	   							<form:option value="U01" label="식대(야근)"/>
	   							<form:option value="U02" label="택시비(야근)"/>
	   							<form:option value="U03" label="택시비(회식)"/>
	   							<form:option value="U04" label="사무용품 구매"/>
	   							<form:option value="U05" label="교육비"/>
	   							<form:option value="U06" label="접대비"/>
	   						</form:select>
   						</c:if>
   						<c:if test='${ sampleVO.s_code ne null and !sampleVO.s_code.equals("S01") }'>
	    					<form:input path="u_code" value="${ sampleVO.u_codeName }" readonly="true" />
   						</c:if>
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="usage_date"><spring:message code="title.cost.usagedate" /></label></td>
    			<td class="tbtd_content">
	    			<c:if test='${sampleVO.s_code eq null or sampleVO.s_code.equals("S01") }'>
	    				<input type="date"  id="useDate" value="${ sampleVO.usage_date }"/>
	    				<form:hidden path="usage_date"  id="formDate" value="${ useDate }"/>
	    				<form:errors id="uder" path="usage_date" />
	    			</c:if>
	    			<c:if test='${ sampleVO.s_code ne null and !sampleVO.s_code.equals("S01") }'>
	    				<form:input path="usage_date" id="formDate" value="${ sampleVO.usage_date }" readonly="true"/>
	    			</c:if>
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="usage_cost"><spring:message code="title.cost.cost" /></label></td>
    			<td class="tbtd_content">
    				<c:if test='${ sampleVO.s_code eq null or sampleVO.s_code.equals("S01") }'>
    					<form:input path="usage_cost" id="u_cost" cssClass="txt"/>
    				</c:if>
    				<c:if test='${ sampleVO.s_code ne null and !sampleVO.s_code.equals("S01") }'>
    					<form:input path="usage_cost"  cssClass="txt" readonly="true"/>
    				</c:if>
                </td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="receipt_o"><spring:message code="title.cost.receipt" /></label></td>
    			<td class="tbtd_content">
                    <c:if test="${registerFlag == 'modify'}">
                    	<c:if test='${ sampleVO.s_code.equals("S01") }'>
	        				<input type="file" id="rec_o" name="rec_o"/>
	        				<c:if test="${ sampleVO.receipt_o != null }">
		        				 ${ sampleVO.receipt_o }
		        				<img src="\cost\images\egovframework\receipt\<c:out value="${ sampleVO.receipt_r }"/>"  width="300px;" height="auto" />
		        				<input type="hidden" name="rec_o2" value="${ sampleVO.receipt_o }"/>
	        				</c:if>
	        			</c:if>
	        			<c:if test='${ !sampleVO.s_code.equals("S01") }'>
	        				${ sampleVO.receipt_o }
	        				<img src="\cost\images\egovframework\receipt\<c:out value="${ sampleVO.receipt_r }"/>" width="300px;" height="auto" /> 
	        			</c:if>
                    </c:if>
                    <c:if test="${registerFlag != 'modify'}">
        				<input type="file" id="rec_o" name="rec_o"/>	
                    </c:if>
                </td>    
    		</tr>
    		
    	</table>
      </div>
  </div>
  
<c:if test="${registerFlag == 'modify'}">
<div id="content_pop">  	

	    	<div id="sysbtn">
	    		<ul>
		    		<li>
		    			<h2 style="margin-right:550px;">처리내역</h2>
		    		</li>
	    			<li><c:if test="${registerFlag == 'modify'}">
	    					<c:if test='${ sampleVO.s_code.equals("S01") }'>
			                    <span class="btn_blue_l">
			                        <a href="javascript:fn_egov_save2();">
			                            <spring:message code="button.cost.ok" />
			                        </a>
			                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
			                    </span>
			                </c:if>
			                <c:if test='${ !sampleVO.s_code.equals("S01") }'>
			                    
			                   
			                </c:if>
	                    </c:if>
	                </li>	               
	            </ul>
	    	</div>
	    	<!-- // 타이틀 -->
	    	<div id="table">
	    	<table width="100%" border="1" cellpadding="0" cellspacing="0" style="bordercolor:#D3E2EC; bordercolordark:#FFFFFF; BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
	    		<colgroup>
	    			<col width="150"/>
	    			<col width="?"/>
	    		</colgroup>
	    			<td class="tbtd_caption"><label for="s_code"><spring:message code="title.cost.status" /></label></td>
	    			<td class="tbtd_content">
	    					<c:if test='${ sampleVO.s_code.equals("S01") }'>
	    						<form:select path="s_code" id="sc" cssClass="use">
            							<form:option value="S01" label="접수"/>
            							<form:option value="S02" label="승인"/>
            							<form:option value="S03" label="지급완료"/>
            							<form:option value="S04" label="반려"/>
            						</form:select>
            				</c:if>
            				<c:if test='${ !sampleVO.s_code.equals("S01") }'>
	    						<form:input path="s_codeName"  cssClass="txt" readonly="true"/>
            				</c:if>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td class="tbtd_caption"><label for="processing_date"><spring:message code="title.cost.processingdate" /></label></td>
	    			<td class="tbtd_content">
	    					<form:input path="processing_date"  value="${ sampleVO.processing_date }" cssClass="txt" readonly="true"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td class="tbtd_caption"><label for="ok_cost"><spring:message code="title.cost.okcost" /></label></td>
	    			<td class="tbtd_content">
		    			<c:if test='${ sampleVO.s_code.equals("S01") }'>
		    				<form:input path="ok_cost"  cssClass="txt"/>
		    			</c:if>
		    			<c:if test='${ !sampleVO.s_code.equals("S01") }'>
		    				<form:input path="ok_cost"  cssClass="txt" readonly="true"/>
		    			</c:if>
	                </td>
	    		</tr>
	    		<tr>
	    			<c:if test='${ sampleVO.s_code.equals("S01") }'>
		    			<td class="tbtd_caption"><label for="note"><spring:message code="title.cost.note" /></label></td>
		    			<td class="tbtd_content"><form:input path="note"  cssClass="txt"/></td>
	  				</c:if>
	  				<c:if test='${ !sampleVO.s_code.equals("S01") }'>
		    			<td class="tbtd_caption"><label for="note"><spring:message code="title.cost.note" /></label></td>
		    			<td class="tbtd_content"><form:input path="note"  cssClass="txt" readonly="true"/></td>
	  				</c:if>
	    		</tr>
	    	</table>
	      </div>
	    
</div>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
    </c:if>
</form:form>

</body>
</html>