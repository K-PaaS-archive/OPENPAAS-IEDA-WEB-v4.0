package org.openpaas.ieda.controller.hbdeploy.web.deploy.cfDeployment;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;

import org.openpaas.ieda.controller.common.BaseController;
import org.openpaas.ieda.hbdeploy.web.deploy.cfDeployment.dao.HbCfDeploymentDefaultConfigVO;
import org.openpaas.ieda.hbdeploy.web.deploy.cfDeployment.dto.HbCfDeploymentDefaultConfigDTO;
import org.openpaas.ieda.hbdeploy.web.deploy.cfDeployment.service.HbCfDeploymentDefaultConfigService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HbCfDeploymentDefaultConfigController extends BaseController{
	@Autowired private HbCfDeploymentDefaultConfigService service;
	private final static Logger LOGGER = LoggerFactory.getLogger(HbCfDeploymentDefaultConfigController.class);
    /***************************************************
     * @project : Paas 이종 플랫폼 설치 자동화
     * @description : Hybrid CfDeployment 리소스 정보 화면 이동
     * @title : goCfDeployment
     * @return : String
    ***************************************************/
    @RequestMapping(value = "/deploy/hbCfDeployment/defaultConfig", method = RequestMethod.GET)
    public String goNetworkConfig() {
        if (LOGGER.isInfoEnabled()) { LOGGER.info("====================================> /deploy/hbCfDeployment/defaultConfig"); }
        return "/hbdeploy/deploy/cfDeployment/hbCfDeploymentDefaultConfig";
    }
    
    /****************************************************************
     * @project : Paas 이종 플랫폼 설치 자동화
     * @description : 리소스 목록 정보 조회
     * @title : selectDefaultConfigInfoList
     * @return : ResponseEntity<CfDeploymentVO>
    *****************************************************************/
    @RequestMapping(value = "/deploy/hbCfDeployment/defaultConfig/list", method = RequestMethod.GET)
    public ResponseEntity<HashMap<String, Object>> getRecourceConfigInfoList() {
        if (LOGGER.isInfoEnabled()) { LOGGER.info("====================================> /deploy/hbCfDeployment/defaultConfig/list"); }
        List<HbCfDeploymentDefaultConfigVO> DefaultConfigList = service.getDefaultConfigInfoList();
        HashMap<String, Object> list = new HashMap<String, Object>();
        int size =0;
        if( DefaultConfigList.size() > 0  ) {
            size = DefaultConfigList.size();
        }
        list.put("total", size);
        list.put("records", DefaultConfigList);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }
    
    /****************************************************************
     * @project : Paas 이종 플랫폼 설치 자동화
     * @description : 리소스 정보 등록/수정
     * @title : saveDefaultConfigInfo
     * @return : ResponseEntity<>
    *****************************************************************/
    @RequestMapping(value = "/deploy/hbCfDeployment/defaultConfig/save", method = RequestMethod.PUT)
    public ResponseEntity<?> saveDefaultConfigInfo(@RequestBody HbCfDeploymentDefaultConfigDTO dto, Principal principal) {
        if (LOGGER.isInfoEnabled()) { LOGGER.info("====================================> /deploy/hbCfDeployment/defaultConfig/save"); }
        service.saveDefaultConfigInfo(dto, principal);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    
    /****************************************************************
     * @project : Paas 이종 플랫폼 설치 자동화
     * @description : 리소스 정보 삭제
     * @title : deleteDefaultConfigInfo
     * @return : ResponseEntity<>
    *****************************************************************/
    @RequestMapping(value = "/deploy/hbCfDeployment/defaultConfig/delete", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteDefaultConfigInfo(@RequestBody HbCfDeploymentDefaultConfigDTO dto, Principal principal) {
        if (LOGGER.isInfoEnabled()) { LOGGER.info("====================================> /deploy/hbCfDeployment/defaultConfig/delete"); }
        service.deleteDefaultConfigInfo(dto, principal);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
    
    
	
}