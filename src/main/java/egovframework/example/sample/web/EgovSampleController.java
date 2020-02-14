/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.example.sample.web;

import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.example.sample.service.EgovSampleService;
import egovframework.example.sample.service.SampleDefaultVO;
import egovframework.example.sample.service.SampleVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @Class Name : EgovSampleController.java
 * @Description : EgovSample Controller Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class EgovSampleController {

	/** EgovSampleService */
	@Resource(name = "sampleService")
	private EgovSampleService sampleService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;
	
	@Resource(name = "uploadPath")
	   String uploadPath;

	/**
	 * 글 목록을 조회한다. (pageing)
	 * @param searchVO - 조회할 정보가 담긴 SampleDefaultVO
	 * @param model
	 * @return "egovSampleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/egovSampleList.do")
	public String selectSampleList(@ModelAttribute("searchVO") SampleDefaultVO searchVO, ModelMap model) throws Exception {

		/** EgovPropertyService.sample */
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> sampleList = sampleService.selectSampleList(searchVO);
		model.addAttribute("resultList", sampleList);
		
		System.out.println("searchRegDate : " + searchVO.getSearchRegDate());
		System.out.println("sampleList : " + sampleList);
		
		List <SampleVO> excelVO = sampleService.excelList(searchVO);
		  
		System.out.println("List excelVO searchVO: " + searchVO);
		System.out.println("list excelVO : " + excelVO);
		

		int totCnt = sampleService.selectSampleListTotCnt(searchVO);
		
		System.out.println("totcnt : " + totCnt);
		
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("paginationInfo", paginationInfo);

		return "sample/egovSampleList";
	}

	/**
	 * 글 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSampleView.do", method = RequestMethod.POST)
	public String addSampleView(@ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("sampleVO", new SampleVO());
		System.out.println("SELECT UPDATE searchVO : " + searchVO);
		return "sample/egovSampleRegister";
	}

	/**
	 * 글을 등록한다.
	 * @param sampleVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSample.do", method = RequestMethod.POST)
	public String addSample(@ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO, BindingResult bindingResult, Model model, SessionStatus status,
			@RequestParam(name="rec_o", required=false) MultipartFile file) throws Exception {
		
		String savedName = file.getOriginalFilename();
		
		savedName = uploadFile(savedName, file.getBytes());
	      
	     sampleVO.setReceipt_o(file.getOriginalFilename());
	      
	     sampleVO.setReceipt_r(savedName);
	     
	     
		
		// Server-Side Validation
				beanValidator.validate(sampleVO, bindingResult);

				if (bindingResult.hasErrors()) {
					model.addAttribute("sampleVO", sampleVO);
					return "sample/egovSampleRegister";
				}

				sampleService.insertSample(sampleVO);
				status.setComplete();
				return "forward:/egovSampleList.do";
	}
	
	private String uploadFile(String originalName, byte[] fileData) throws Exception {
	      UUID uuid = UUID.randomUUID();
	      String savedName = uuid.toString() + "-" + originalName;
	      File target = new File(uploadPath, savedName);
	      FileCopyUtils.copy(fileData, target);
	      return savedName;
	   }

	/**
	 * 글 수정화면을 조회한다.
	 * @param id - 수정할 글 id
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateSampleView.do")
	public String updateSampleView(@RequestParam("selectedId") String id, @ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO, Model model) throws Exception {
		
		sampleVO.setId(id);
		sampleVO = sampleService.selectSample(sampleVO);
		// 변수명은 CoC 에 따라 sampleVO
		model.addAttribute(selectSample(sampleVO, searchVO));
		model.addAttribute("sampleVO", sampleVO);
		System.out.println("UPDATE searchVO" + searchVO);
		System.out.println("UPDATE SAMPLEVO : " + sampleVO);
		return "sample/egovSampleRegister";
	}

	/**
	 * 글을 조회한다.
	 * @param sampleVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return @ModelAttribute("sampleVO") - 조회한 정보
	 * @exception Exception
	 */
	public SampleVO selectSample(SampleVO sampleVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO) throws Exception {
		System.out.println("SELECT sampleVO : " + sampleVO);
		return sampleService.selectSample(sampleVO);
	}

	/**
	 * 글을 수정한다.
	 * @param sampleVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateSample.do")
	public String updateSample(@ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO, BindingResult bindingResult, Model model, SessionStatus status,
			@RequestParam(name="rec_o", required=false) MultipartFile file,
			@RequestParam(name="rec_o2", required=false) String rec_o2) throws Exception {
		
			if(!file.isEmpty()) {
				
				String savedName = file.getOriginalFilename();
				
				savedName = uploadFile(savedName, file.getBytes());
			      
			     sampleVO.setReceipt_o(file.getOriginalFilename());
			      
			     sampleVO.setReceipt_r(savedName);
			} else {
				sampleVO.setReceipt_o(rec_o2);
				sampleVO.setReceipt_r(sampleVO.getReceipt_r());
			}

			
	     
		beanValidator.validate(sampleVO, bindingResult);
			


		if (bindingResult.hasErrors()) {
			model.addAttribute("sampleVO", sampleVO);
			return "sample/egovSampleRegister";
		}
		
		System.out.println("update sampleVO1 : " + sampleVO);

		sampleService.updateSample(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}
	
	@RequestMapping("/updateSample2.do")
	public String updateSample2(@ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO, BindingResult bindingResult, Model model, SessionStatus status
			, @RequestParam(name="rec_o", required=false) MultipartFile file)
			throws Exception {

		beanValidator.validate(sampleVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("sampleVO", sampleVO);
			return "sample/egovSampleRegister";
		}

		System.out.println("update sampleVO2 : " + sampleVO);
		
		sampleService.updateSample2(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}

	/**
	 * 글을 삭제한다.
	 * @param sampleVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteSample.do")
	public String deleteSample(SampleVO sampleVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO, SessionStatus status) throws Exception {
		sampleService.deleteSample(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}
	
	@RequestMapping(value="/ExcelPoi.do")
	  public void ExcelPoi(HttpServletResponse response, @ModelAttribute("searchVO") SampleDefaultVO searchVO, ModelMap model, SampleVO sampleVO,
			  @RequestParam(defaultValue = "test", required=false) String fileName,
			  @RequestParam(defaultValue = "cellTitle", required=false) String[] cellTitle) throws Exception {
	
		System.out.println("엑셀다운 확인/파일명 : " + fileName);
		System.out.println("searchVO 서비스 전 : " + searchVO);
	  List <SampleVO> excelVO = sampleService.excelList(searchVO);
	  
	  System.out.println("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
	
	  HashMap<String, Object> test = new HashMap<String, Object>();
	  
	  for(SampleVO vo : excelVO) {
		  if(Arrays.asList(cellTitle).contains("사용일")) { 
			  test.put("ud", vo.getUsage_date());		  
		  } 
		  if(Arrays.asList(cellTitle).contains("사용내역")) {
			  test.put("ucn", vo.getU_codeName());	
		  }
	  }
	  System.out.println("ud : " + test.get("ud"));
	  System.out.println("ucn : " + test.get("ucn"));
	  System.out.println("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
	  
	  
      HSSFWorkbook objWorkBook = new HSSFWorkbook();
      HSSFSheet objSheet = null;
      HSSFRow objRow = null;
      HSSFCell objCell = null;       //셀 생성

	        //제목 폰트
	  HSSFFont font = objWorkBook.createFont();
	  font.setFontHeightInPoints((short)9);
	  font.setBoldweight((short)font.BOLDWEIGHT_BOLD);
	  font.setFontName("맑은고딕");

	  //제목 스타일에 폰트 적용, 정렬
	  HSSFCellStyle styleHd = objWorkBook.createCellStyle();    //제목 스타일
	  styleHd.setFont(font);
	  styleHd.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	  styleHd.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

	  objSheet = objWorkBook.createSheet("첫번째 시트");     //워크시트 생성
	 
	

	  
	  // 1행
/*	  objRow = objSheet.createRow(0);
	  objRow.setHeight ((short) 0x150);

*/
	 /* objCell = objRow.createCell(0);
	  objCell.setCellValue("사용일");
	  objCell.setCellStyle(styleHd);

	  objCell = objRow.createCell(1);
	  objCell.setCellValue("사용내역");
	  objCell.setCellStyle(styleHd);
	  
	  objCell = objRow.createCell(2);
	  objCell.setCellValue("사용금액");
	  objCell.setCellStyle(styleHd);
	  
	  objCell = objRow.createCell(3);
	  objCell.setCellValue("승인금액");
	  objCell.setCellStyle(styleHd);
	  
	  objCell = objRow.createCell(4);
	  objCell.setCellValue("처리상태");
	  objCell.setCellStyle(styleHd);
	  
	  objCell = objRow.createCell(5);
	  objCell.setCellValue("등록일");
	  objCell.setCellStyle(styleHd);*/
	
	  int r1index = 0;
	  int c1index = 0;

	  int ctc = cellTitle.length;
	  
	  objRow = objSheet.createRow(r1index);
	  objRow.setHeight ((short) 0x150);



	  System.out.println("ctc : " + ctc);
	  
	  for(String ct :cellTitle) {

		  objCell = objRow.createCell(c1index);
		  objCell.setCellValue(ct);
		  objCell.setCellStyle(styleHd);
		  	  
		  System.out.println("c1index : " + c1index);
		  System.out.println("ct : " + ct);
		  
		  c1index++;

		}
	  
	  System.out.println("for 후 c1index : " + c1index);
	
	  // 2행
	  int index = 0;
	  int r2index = 1;
	  int c2index = 0;
	  int c2index2 = 0;
	  int count = 0;
	/*  
	  HashMap<String, Object> test2 = new HashMap<String, Object>();
	  
	  for(int i = 0; i < cellTitle.length;  i ++) {
		  System.out.println("i : " + i);
		  test2.put("cindex" + i, i);
	  }
	  
	  System.out.println("test2 : " + test2);

	  
	  
	  for(int i = 0; i < cellTitle.length;  i ++) {

			  
			if(Arrays.asList(cellTitle).contains("사용일")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
				objCell = objRow.createCell(0);
				objCell.setCellValue(vo.getUsage_date());
				objCell.setCellStyle(styleHd);
				System.out.println("사용일");
				r2index++;
				  }
			} 
			  
			if(Arrays.asList(cellTitle).contains("사용내역")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
				objCell = objRow.createCell(1);
			    objCell.setCellValue(vo.getU_codeName());
			    objCell.setCellStyle(styleHd);
			    System.out.println("사용내역");
			    r2index++;
				  }
			}
		    
			if(Arrays.asList(cellTitle).contains("사용금액")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
			    objCell = objRow.createCell(2);
			    objCell.setCellValue(vo.getUsage_cost());
			    objCell.setCellStyle(styleHd);
			    System.out.println("사용금액");
			    r2index++;
				  }
			}
		    
			if(Arrays.asList(cellTitle).contains("승인금액")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
			    objCell = objRow.createCell(3);
			    objCell.setCellValue(vo.getOk_cost());
			    objCell.setCellStyle(styleHd);
			    r2index++;
				  }
		    }
		    
			if(Arrays.asList(cellTitle).contains("처리상태")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
			    objCell = objRow.createCell(4);
			    objCell.setCellValue(vo.getS_codeName());
			    objCell.setCellStyle(styleHd);
			    r2index++;
				  }
			}
		    
			if(Arrays.asList(cellTitle).contains("등록일")) {
				  for(SampleVO vo : excelVO) {
					  	objRow = objSheet.createRow(r2index);
						objRow.setHeight((short) 0x150);
			    objCell = objRow.createCell(5);
			    objCell.setCellValue(vo.getReg_date());
			    objCell.setCellStyle(styleHd);
			    r2index++;
				  }
			}
			
		    
		  
	  }*/
	  
	  for(SampleVO vo : excelVO) {
		  	objRow = objSheet.createRow(r2index);
			objRow.setHeight((short) 0x150);
			  
			if(Arrays.asList(cellTitle).contains("사용일")) {
				objCell = objRow.createCell(0);
				objCell.setCellValue(vo.getUsage_date());
				objCell.setCellStyle(styleHd);
				System.out.println("사용일");
			} 
			  
			if(Arrays.asList(cellTitle).contains("사용내역")) {
				objCell = objRow.createCell(1);
			    objCell.setCellValue(vo.getU_codeName());
			    objCell.setCellStyle(styleHd);
			    System.out.println("사용내역");
			}
		    
			if(Arrays.asList(cellTitle).contains("사용금액")) {
			    objCell = objRow.createCell(2);
			    objCell.setCellValue(vo.getUsage_cost());
			    objCell.setCellStyle(styleHd);
			    System.out.println("사용금액");
			}
		    
			if(Arrays.asList(cellTitle).contains("승인금액")) {
			    objCell = objRow.createCell(3);
			    objCell.setCellValue(vo.getOk_cost());
			    objCell.setCellStyle(styleHd);
		    }
		    
			if(Arrays.asList(cellTitle).contains("처리상태")) {
			    objCell = objRow.createCell(4);
			    objCell.setCellValue(vo.getS_codeName());
			    objCell.setCellStyle(styleHd);
			}
		    
			if(Arrays.asList(cellTitle).contains("등록일")) {
			    objCell = objRow.createCell(5);
			    objCell.setCellValue(vo.getReg_date());
			    objCell.setCellStyle(styleHd);
			}
			
		    r2index++;
		  
	  }
	  
	 /* 
	  for(int i = 0; i < cellTitle.length;  i ++) {

	  System.out.println("c2index■■■■■■■■■■■■■■■■■■■■■■■■ : " + c2index);
	  for (SampleVO vo : excelVO) {
		objRow = objSheet.createRow(r2index);
		objRow.setHeight((short) 0x150);
	    
	    switch(cellTitle[i]) {
	    
	    	case "사용일" :
			    objCell = objRow.createCell(c2index);
			    objCell.setCellValue(vo.getUsage_date());
			    objCell.setCellStyle(styleHd);    
			break;
		
	    	case "사용내역" :
			    objCell = objRow.createCell(c2index + 1);
			    objCell.setCellValue(vo.getU_codeName());
			    objCell.setCellStyle(styleHd);
			    
		    break;
	    	case "사용금액" :
			    objCell = objRow.createCell(c2index + 2);
			    objCell.setCellValue(vo.getUsage_cost());
			    objCell.setCellStyle(styleHd);
		    break;
		    
	    	case "승인금액" :
			    objCell = objRow.createCell(c2index + 3);
			    objCell.setCellValue(vo.getOk_cost());
			    objCell.setCellStyle(styleHd);
		    break;
		    
	    	case "처리상태" :  
			    objCell = objRow.createCell(c2index + 4);
			    objCell.setCellValue(vo.getS_codeName());
			    objCell.setCellStyle(styleHd);
			break;
			    
	    	case "등록일" :
			    objCell = objRow.createCell(c2index + 5);
			    objCell.setCellValue(vo.getReg_date());
			    objCell.setCellStyle(styleHd);
		    break;
	    }
	    

	    System.out.println("r2index : " + r2index);
	    
	    r2index++;
	    
	    }
	    System.out.println("주석 ------");
		  r2index = 1;
	    
		try {
		    switch(cellTitle[c2index].toString()) {
		  		case "사용일" : 

				    System.out.println("c2index■■■■■■■■■■■■■■■■■■■■■■■■ : " + c2index);
		  			for (SampleVO vo : excelVO) {
		  		    objRow = objSheet.createRow(r2index);
		  		    objRow.setHeight((short) 0x150);
			  		    objCell = objRow.createCell(0);
					    objCell.setCellValue(vo.getUsage_date());
					    objCell.setCellStyle(styleHd);
					    System.out.println("사용일 r2index : " + r2index);
					    r2index++;
		  			}
			    break;
			    
		  		case "사용내역" : 

				    System.out.println("c2index■■■■■■■■■■■■■■■■■■■■■■■■ : " + c2index);
		  			for (SampleVO vo : excelVO) {
		  			objRow = objSheet.createRow(r2index);
			  		objRow.setHeight((short) 0x150);
		  		    objCell = objRow.createCell(1);
				    objCell.setCellValue(vo.getU_codeName());
				    objCell.setCellStyle(styleHd);
				    System.out.println("사용내역 r2index : " + r2index);
				    r2index++;
		  			}
			    break;
				    
		  		case "사용금액" :

				    System.out.println("c2index■■■■■■■■■■■■■■■■■■■■■■■■ : " + c2index);
		  			for (SampleVO vo : excelVO) {
		  		    objRow = objSheet.createRow(r2index);
		  		    objRow.setHeight((short) 0x150);
		  		    objCell = objRow.createCell(2);
				    objCell.setCellValue(vo.getUsage_cost());
				    objCell.setCellStyle(styleHd);
				    System.out.println("사용금액 r2index : " + r2index);
				    r2index++;
		  			}
			    break;
				    
		  		case "승인금액" : 

				    System.out.println("c2index■■■■■■■■■■■■■■■■■■■■■■■■ : " + c2index);
		  			for (SampleVO vo : excelVO) {
		  		    objRow = objSheet.createRow(r2index);
		  		    objRow.setHeight((short) 0x150);
		  		    objCell = objRow.createCell(3);
				    objCell.setCellValue(vo.getOk_cost());
				    objCell.setCellStyle(styleHd);
				    System.out.println("승인금액 r2index : " + r2index);
				    r2index++;
		  			}
			    break;
		}
		    
		} catch(IndexOutOfBoundsException e) {
			System.out.println(e);
		}
		
	    System.out.println("주석 끝 -----");
		c2index++;

	}
*/
	  for (int i = 0; i < excelVO.size(); i++) {
	    objSheet.autoSizeColumn(i);
	  }


	  response.setContentType("Application/Msexcel");
	  response.setHeader("Content-Disposition", "ATTachment; Filename="+URLEncoder.encode(fileName,"UTF-8")+".xls");

	  OutputStream fileOut  = response.getOutputStream();
	  objWorkBook.write(fileOut);
	  fileOut.close();

	  response.getOutputStream().flush();
	  response.getOutputStream().close();
	}
	
}
