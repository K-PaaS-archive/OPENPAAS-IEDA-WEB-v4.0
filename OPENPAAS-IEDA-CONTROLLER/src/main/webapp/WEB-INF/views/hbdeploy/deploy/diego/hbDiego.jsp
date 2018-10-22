<%
/* =================================================================
 * 상세설명 : Diego 설치
 * =================================================================
 */ 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri = "http://www.springframework.org/tags" %>

<script type="text/javascript">

var text_required_msg = '<spring:message code="common.text.vaildate.required.message"/>';//을(를) 입력하세요.
var select_required_msg='<spring:message code="common.select.vaildate.required.message"/>';//을(를) 선택하세요.
/******************************************************************
 * 설명 :    변수 설정
 ***************************************************************** */
var iaas ="";
var diegoInfo = "";
var installStatus ="";//설치 상태
var installClient = "";//설치 client
var deleteClient = "";//삭제 client
$(function() {    
    /********************************************************
     * 설명 :  Diego 목록 설정
     *********************************************************/
     $('#config_diegoGrid').w2grid({
        name: 'config_diegoGrid',
        header: '<b>Diego 목록</b>',
        method: 'GET',
         multiSelect: false,
        show: {    
                selectColumn: true,
                footer: true},
        style: 'text-align: center',
        columns:[
              {field: 'recid',     caption: 'recid', hidden: true}
            , {field: 'diegoConfigName', caption: 'Diego 정보 별칭', size: '20%'}
            , {field: 'iaasType', caption: '인프라 환경 타입', size:'120px', style:'text-align:center;' ,render: function(record){ 
                if(record.iaasType.toLowerCase() == "aws"){
                    return "<img src='images/iaasMgnt/aws-icon.png' width='80' height='30' />";
                }else if (record.iaasType.toLowerCase() == "openstack"){
                    return "<img src='images/iaasMgnt/openstack-icon.png' width='90' height='35' />";
                }
            }}
            , {field: 'defaultConfigInfo', caption: '기본 정보 별칭', size: '20%'}
            , {field: 'networkConfigInfo', caption: '네트워크 정보 별칭', size: '20%'}
            , {field: 'resourceConfigInfo', caption: '리소스 정보 별칭 ', size: '20%'}
            , {field: 'instanceConfigInfo', caption: '인스턴스 정보 별칭 ', size: '20%'}
            , {field: 'deploymentFile', caption: '배포파일명', size: '250px',
                render: function(record) {
                    if ( record.deploymentFile != null ){
                        var deplymentParam = {
                                service : "bootstrap"
                               ,iaas    : record.iaas
                               ,id      : record.id
                            } 
                        var fileName = record.deploymentFile;
                        return '<a style="color:#333;" href="/common/deploy/download/manifest/' + fileName +'" onclick="window.open(this.href); return false;">' + record.deploymentFile + '</a>';
                  }else {
                       return '&ndash;';
                     }
                 }
             }
            ],
        onSelect : function(event) {
            event.onComplete = function() {
                $('#modifyBtn').attr('disabled', false);
                $('#deleteBtn').attr('disabled', false);
                $('#manifestBtn').attr('disabled', false);
                return;
            }
        },
        onDblClick: function (event) {
            var grid = this;
            // need timer for nicer visual effect that record was selected
            setTimeout(function () {
                w2ui['config_diegoGrid2'].add( $.extend({}, grid.get(event.recid), { selected : false }) );
                grid.selectNone();
                grid.remove(event.recid);
            }, 150);
        }
        ,onUnselect : function(event) {
            event.onComplete = function() {
                $('#modifyBtn').attr('disabled', true);
                $('#deleteBtn').attr('disabled', true);
                $('#manifestBtn').attr('disabled', true);
                return;
            }
        },onLoad:function(event){
            if(event.xhr.status == 403){
                location.href = "/abuse";
                event.preventDefault();
            }
        },onError : function(event) {
        }
    });
    
     $('#config_diegoGrid2').w2grid({ 
         name: 'config_diegoGrid2', 
         header: '<b>Diego 목록</b>',
         columns:[
             {field: 'recid',     caption: 'recid', hidden: true}
             , {field: 'diegoConfigName', caption: 'Diego 정보 별칭', size: '20%'}
             , {field: 'iaasType', caption: '인프라 환경 타입', size:'120px', style:'text-align:center;' ,render: function(record){ 
                 if(record.iaasType.toLowerCase() == "aws"){
                     return "<img src='images/iaasMgnt/aws-icon.png' width='80' height='30' />";
                 }else if (record.iaasType.toLowerCase() == "openstack"){
                     return "<img src='images/iaasMgnt/openstack-icon.png' width='90' height='35' />";
                 }
             }}
             , {field: 'defaultConfigInfo', caption: '기본 정보 별칭', size: '20%'}
             , {field: 'networkConfigInfo', caption: '네트워크 정보 별칭', size: '20%'}
             , {field: 'resourceConfigInfo', caption: '리소스 정보 별칭 ', size: '20%'}
             , {field: 'instanceConfigInfo', caption: '인스턴스 정보 별칭 ', size: '20%'}
             , {field: 'deploymentFile', caption: '배포파일명', size: '250px',
                 render: function(record) {
                     if ( record.deploymentFile != null ){
                         var deplymentParam = {
                                 service : "bootstrap"
                                ,iaas    : record.iaas
                                ,id      : record.id
                             } 
                         var fileName = record.deploymentFile;
                         return '<a style="color:#333;" href="/common/deploy/download/manifest/' + fileName +'" onclick="window.open(this.href); return false;">' + record.deploymentFile + '</a>';
                   }else {
                        return '&ndash;';
                      }
                  }
              }
           ],
           onSelect : function(event) {
               event.onComplete = function() {
                   $('#installVmBtn').attr('disabled', false);
               }
           },onDblClick: function (event) {
             var record = w2ui['config_diegoGrid2'].get(event.recid);
             var grid = this;
             var gridName = "";
             if(record.deployStatus != null){
                 gridName = "config_diegoGrid3";
             }else{
                 gridName = "config_diegoGrid";
             }
             // need timer for nicer visual effect that record was selected
             setTimeout(function () {
                 w2ui[''+gridName+''].add( $.extend({}, grid.get(event.recid), { selected : false }) );
                 grid.selectNone();
                 grid.remove(event.recid);
             }, 150);
           },onUnselect : function(event) {
               event.onComplete = function() {
                   
               }
           },onLoad:function(event){
               if(event.xhr.status == 403){
                   location.href = "/abuse";
                   event.preventDefault();
               }
           },onError : function(event) {
        	   
           }
     });
     
     $('#config_diegoGrid3').w2grid({
         name: 'config_diegoGrid3',
         header: '<b>Diego 목록</b>',
         method: 'GET',
          multiSelect: false,
         show: {    
                 selectColumn: true,
                 footer: true},
         style: 'text-align: center',
         columns:[
               {field: 'id',     caption: 'id', hidden: true}
             , {field: 'recid',     caption: 'recid', hidden: true}
             , {field: 'diegoConfigName', caption: 'Diego 정보 별칭', size: '140px'}
             , {field: 'iaasType', caption: '인프라 환경 타입', size:'120px', style:'text-align:center;' ,render: function(record){ 
                 if(record.iaasType.toLowerCase() == "aws"){
                     return "<img src='images/iaasMgnt/aws-icon.png' width='80' height='30' />";
                 }else if (record.iaasType.toLowerCase() == "openstack"){
                     return "<img src='images/iaasMgnt/openstack-icon.png' width='90' height='35' />";
                 }
             }}
             , {field: 'deployStatus', caption: '배포상태', size: '100px', 
                 render: function(record) {
                     if ( record.deployStatus == 'DEPLOY_STATUS_PROCESSING' )
                         return '<span class="btn btn-primary" style="width:60px">배포중</span>';
                     else if ( record.deployStatus == 'DEPLOY_STATUS_DONE' )
                         return '<span class="btn btn-primary" style="width:60px">성공</span>';
                     else    if ( record.deployStatus == 'DEPLOY_STATUS_CANCELLED' )
                         return '<span class="btn btn-danger" style="width:60px">취소</span>';
                     else    if ( record.deployStatus == 'DEPLOY_STATUS_FAILED' )
                         return '<span class="btn btn-danger" style="width:60px">실패</span>';
                     else    if ( record.deployStatus == 'DEPLOY_STATUS_DELETING' )
                         return '<span class="btn btn-primary" style="width:60px">삭제중</span>';
                     else
                         return '&ndash;';
                        }
               }
             , {field: 'defaultConfigVO.diegoReleaseName', caption: 'DIEGO 릴리즈 명', size: '130px'}
             , {field: 'defaultConfigVO.diegoReleaseVersion', caption: 'DIEGO 릴리즈 버전', size: '100px'}
             , {field: 'defaultConfigVO.gardenReleaseName', caption: 'GARDEN 릴리즈 명', size: '130px'}
             , {field: 'defaultConfigVO.gardenReleaseVersion', caption: 'GARDEN 릴리즈 버전', size: '100px'}
             , {field: 'defaultConfigVO.cflinuxfs2rootfsreleaseName', caption: 'cflinuxfs2 릴리즈 명', size: '150px'}
             , {field: 'defaultConfigVO.cflinuxfs2rootfsreleaseVersion', caption: 'cflinuxfs2 릴리즈 버전', size: '100px'}
             , {field: 'resourceConfigVO.smallFlavor', caption: 'S Instance Type', size: '120px'}
             , {field: 'resourceConfigVO.mediumFlavor', caption: 'M Instance Type', size: '120px'}
             , {field: 'resourceConfigVO.largeFlavor', caption: 'L Instance Type', size: '120px'}
             , {field: 'resourceConfigVO.stemcellName', caption: '스템셀 명', size: '300px'}
             , {field: 'resourceConfigVO.stemcellVersion', caption: '스템셀 버전', size: '100px'}
             , {field: 'resourceConfigVO.boshPassword', caption: '스템셀 패스워드', size: '140px'}
             , {field: 'deploymentFile', caption: '배포파일명', size: '250px',
                 render: function(record) {
                     if ( record.deploymentFile != null ){
                         var deplymentParam = {
                                 service : "bootstrap"
                                ,iaas    : record.iaas
                                ,id      : record.id
                             } 
                         var fileName = record.deploymentFile;
                         return '<a style="color:#333;" href="/common/deploy/download/manifest/' + fileName +'" onclick="window.open(this.href); return false;">' + record.deploymentFile + '</a>';
                   }else {
                        return '&ndash;';
                      }
                  }
              }
             ],
         onSelect : function(event) {
             event.onComplete = function() {
                 $('#modifyVmBtn').attr('disabled', false);
                 $('#deleteVmBtn').attr('disabled', false);
                 $('#manifestVmBtn').attr('disabled', false);
                 return;
             }
         },onDblClick: function (event) {
             var grid = this;
             setTimeout(function () {
                 w2ui['config_diegoGrid2'].add( $.extend({}, grid.get(event.recid), { selected : false }) );
                 grid.selectNone();
                 grid.remove(event.recid);
             }, 150);
         },onUnselect : function(event) {
             event.onComplete = function() {
                 $('#modifyVmBtn').attr('disabled', true);
                 $('#deleteVmBtn').attr('disabled', true);
                 $('#manifestVmBtn').attr('disabled', true);
                 return;
             }
         },onLoad:function(event){
             if(event.xhr.status == 403){
                 location.href = "/abuse";
                 event.preventDefault();
             }
         },onError : function(event) {
         }
     });
    
    /******************************************************************
     * 설명 : Diego 설치 버튼
     ***************************************************************** */
     $("#installBtn").click(function(){
         w2popup.open({
            width   : 730,
            height  : 460,
            title : '<b>이종 DIEGO 정보 등록</b>',
            body : $("#diegoRegistInfoDiv").html(),
            buttons: $("#diegoRegistInfoBtnDiv").html(),
            modal : true,
            onOpen:function(event){
                event.onComplete = function(){
                    getDiegoInstanceInfo();
                    getDiegoResourceInfo();
                    getDiegoNetworkInfo();
                    getDiegoDefaultInfo();
                }
            },onClose:function(event){
                w2ui['config_diegoGrid'].clear();
                doSearch();
            }
        });
     });
     
     /******************************************************************
     * 설명 : Diego 수정 버튼
     ***************************************************************** */
    $("#modifyBtn").click(function(){
        if($("#modifyBtn").attr('disabled') == "disabled") return;
        
        var selected = w2ui['config_diegoGrid'].getSelection();
        if( selected.length == 0 ){
            w2alert("선택된 정보가 없습니다.", "Diego 등록 정보 수정");
            return;
        }
        var record = w2ui['config_diegoGrid'].get(selected);
        diegoInfo = record;
        w2popup.open({
            width   : 730,
            height  : 460,
            title : '<b>이종 Diego 정보 수정</b>',
            body : $("#diegoRegistInfoDiv").html(),
            buttons: $("#diegoRegistInfoBtnDiv").html(),
            modal : true,
            onOpen:function(event){
                event.onComplete = function(){
                    $(".w2ui-msg-body input[name='diegoInfoId']").val(record.id)
                    $(".w2ui-msg-body input[name='diegoConfigName']").val(record.diegoConfigName)
                    $(".w2ui-msg-body select[name='iaasType']").val(record.iaasType)
                    getDiegoInstanceInfo();
                    getDiegoResourceInfo();
                    getDiegoNetworkInfo();
                    getDiegoDefaultInfo();
                }
            },onClose:function(event){
                w2ui['config_diegoGrid'].clear();
                doSearch();
            }
        });
     });
     
     /******************************************************************
     * 설명 : Diego 삭제 버튼
     ***************************************************************** */
    $("#deleteBtn").click(function(){
        if($("#deleteBtn").attr('disabled') == "disabled") return;
        
        var selected = w2ui['config_diegoGrid'].getSelection();
        var record = w2ui['config_diegoGrid'].get(selected);
        var message = "";
        
        if ( record.cfConfigName ){
            message = "Diego 정보 (" + record.cfConfigName + ")를 삭제하시겠습니까?";
        }else message = "선택된 Diego을 삭제하시겠습니까?";
        
        w2confirm({
            title        : "Diego 삭제",
            msg          : message,
            yes_text     : "확인",
            yes_callBack : function(event){
                deleteDiegoInfo(record);
            },
            no_text : "취소",
            no_callBack : function(event){
                w2ui['config_diegoGrid'].clear();
                doSearch();
            }
        });
     });
    /******************************************************************
     * 설명 : Diego 설치 버튼
     ***************************************************************** */
    $("#installVmBtn").click(function(){
        if($("#installVmBtn").attr('disabled') == "disabled") return;
        
        var selectAll = w2ui['config_diegoGrid2'].selectAll();
        var selected = w2ui['config_diegoGrid2'].getSelection();
        
        if(selected.length == 3) {
            w2alert("최대 2개의 Diego이 설치 가능 합니다. ", "Diego 설치");
            return;
        }else if(selected.length == 0){
            w2alert("설치할 Diego이 없습니다.", "Diego 설치");
            return;
        }
        
        var record = new Array();
        for(var i=0; i<selected.length; i++){
            record.push(w2ui['config_diegoGrid2'].get(selected[i]));
            //createSettingFile(record[i]);
        }
        if(record == ""){
            w2alert("배포할 Diego가 존재하지 않습니다.");
        }else{
            firstInstallPopup(record);
        }
    });
    
    /******************************************************************
     * 설명 : Diego 삭제 버튼
     ***************************************************************** */
    $("#deleteVmBtn").click(function(){
        if($("#deleteVmBtn").attr('disabled') == "disabled") return;
        
        var selected = w2ui['config_diegoGrid3'].getSelection();
        var record = w2ui['config_diegoGrid3'].get(selected);
        var message = "";
        
        if ( record.cfConfigName ){
            message = "Diego 정보 (" + record.cfConfigName + ")를 삭제하시겠습니까?";
        }else message = "선택된 Diego을 삭제하시겠습니까?";
        
        w2confirm({
            title        : "Diego 삭제",
            msg          : message,
            yes_text     : "확인",
            yes_callBack : function(event){
                deleteDiegoVmInfo(record);
            },
            no_text : "취소",
            no_callBack : function(event){
                w2ui['config_diegoGrid3'].clear();
                doSearch();
            }
        });
     });
    
    doSearch();
});

/******************************************************************
 * 설명 : DIEGO 수정 버튼
 ***************************************************************** */
 $("#modifyVmBtn").click(function(){
     if($("#modifyVmBtn").attr('disabled') == "disabled") return;
     
     var selected = w2ui['config_diegoGrid3'].getSelection();
     if( selected.length == 0 ){
         w2alert("선택된 정보가 없습니다.", "Diego 등록 정보 수정");
         return;
     }
     var record = w2ui['config_diegoGrid3'].get(selected);
     diegoInfo = record;
     w2popup.open({
         width   : 730,
         height  : 460,
         title : '<b>이종 Diego 정보 수정</b>',
         body : $("#diegoRegistInfoDiv").html(),
         buttons: $("#diegoRegistInfoBtnDiv").html(),
         modal : true,
         onOpen:function(event){
             event.onComplete = function(){
                 $(".w2ui-msg-body input[name='diegoInfoId']").val(record.id)
                 $(".w2ui-msg-body input[name='diegoConfigName']").val(record.diegoConfigName)
                 $(".w2ui-msg-body select[name='iaasType']").val(record.iaasType)
                 getDiegoInstanceInfo();
                 getDiegoResourceInfo();
                 getDiegoNetworkInfo();
                 getDiegoDefaultInfo();
             }
         },onClose:function(event){
             w2ui['config_diegoGrid3'].clear();
             doSearch();
         }
     });
  });
  
  
  
 /******************************************************************
  * 설명 : Diego 배포 파일 확인 버튼
  ***************************************************************** */
  $("#manifestBtn").click(function(){
      if($("#manifestBtn").attr('disabled') == "disabled") return;
      
      var selected = w2ui['config_diegoGrid'].getSelection();
      if( selected.length == 0 ){
          w2alert("선택된 정보가 없습니다.", "배포 파일 확인");
          return;
      }
      var record = w2ui['config_diegoGrid'].get(selected);
      if(record.deploymentFile == ""){
          w2alert("배포 파일이 존재 하지 않습니다.", "배포 파일 확인");
      }
      w2popup.open({
          width   : 730,
          height  : 600,
          title : '<b>배포 파일 확인</b>',
          body : $("#DeployDiv").html(),
          modal : true,
          onOpen:function(event){
              event.onComplete = function(){
                  getDeployInfo(record.deploymentFile);
              }
          },onClose:function(event){
              w2ui['config_diegoGrid'].clear();
              doSearch();
          }
      });
   });
   
  /******************************************************************
   * 설명 : Diego VM 배포 파일 확인 버튼
   ***************************************************************** */
   $("#manifestVmBtn").click(function(){
       if($("#manifestVmBtn").attr('disabled') == "disabled") return;
       
       var selected = w2ui['config_diegoGrid3'].getSelection();
       if( selected.length == 0 ){
           w2alert("선택된 정보가 없습니다.", "배포 파일 확인");
           return;
       }
       var record = w2ui['config_diegoGrid3'].get(selected);
       if(record.deploymentFile == ""){
           w2alert("배포 파일이 존재 하지 않습니다.", "배포 파일 확인");
       }
       
       w2popup.open({
           width   : 730,
           height  : 600,
           title : '<b>배포 파일 확인</b>',
           body : $("#DeployDiv").html(),
           modal : true,
           onOpen:function(event){
               event.onComplete = function(){
                   getDeployInfo(record.deploymentFile);
               }
           },onClose:function(event){
               w2ui['config_diegoGrid3'].clear();
               doSearch();
           }
       });
    });
   
   
/******************************************************************
 * 기능 : privateInstallPopup
 * 설명 : Private Type Diego 설치
 ***************************************************************** */
var diegoInstallSocket = null;
function firstInstallPopup(diegoInfo){
    
    var firstDeploy = diegoInfo[0];
    
    if(!lockFileSet(firstDeploy.diegoConfigName)) return;
    var message = firstDeploy.iaasType + " Diego ";
    var requestParameter = {
           id : firstDeploy.id,
           iaasType: firstDeploy.iaasType
    };
    w2popup.open({
        title   : "<b>"+firstDeploy.iaasType.toUpperCase()+" 클라우드 환경 Diego 설치</b>",
        width   : 800,
        height  : 620,
        modal   : true,
        showMax : true,
        body    : $("#InstallDiv1").html(),
        buttons : $("#InstallDivButtons").html(),
        onOpen : function(event){
            event.onComplete = function(){
                if(diegoInstallSocket != null) diegoInstallSocket = null;
                if(installClient != null) installClient = null;
                diegoInstallSocket = new SockJS('/deploy/hbDiego/install/diegoInstall');
                installClient = Stomp.over(diegoInstallSocket);
                installClient.connect({}, function(frame) {
                    installClient.subscribe('/user/deploy/hbDiego/install/logs', function(data){
                        var installLogs = $(".w2ui-msg-body #installLogs");
                        var response = JSON.parse(data.body);
                        if ( response.messages != null ){
                            for ( var i=0; i < response.messages.length; i++) {
                                installLogs.append(response.messages[i] + "\n").scrollTop( installLogs[0].scrollHeight );
                            }
                            if ( response.state.toLowerCase() != "started" ) {
                                if ( response.state.toLowerCase() == "done" )    message = message + " 설치가 완료되었습니다."; 
                                if ( response.state.toLowerCase() == "error" ) message = message + " 설치 중 오류가 발생하였습니다.<br>설정을 확인해주세요.";
                                if ( response.state.toLowerCase() == "cancelled" ) message = message + " 설치 중 취소되었습니다.";
                                
                                installStatus = response.state.toLowerCase();
                                $('.w2ui-msg-buttons #deployPopupBtn').prop("disabled", false);
                                
                                if(diegoInfo.length == 2){
                                    installClient.disconnect(secondInstallPopup(diegoInfo[1]));
                                }else{
                                    installClient.disconnect();
                                }
                                w2alert(message, "Diego 설치");
                            }
                        }
                    });
                    installClient.send('/send/deploy/hbDiego/install/diegoInstall', {}, JSON.stringify(requestParameter));
                });
            }
        }, onClose : function(event){
               event.onComplete = function(){
                   w2ui['config_diegoGrid2'].clear();
                   w2ui['config_diegoGrid3'].clear();
                   doSearch();
                   if( installClient != ""  ){
                       installClient.disconnect();
                   }
                   popupClose();
               }
           }
    });
}
/******************************************************************
 * 기능 : InstallPopup1
 * 설명 : Diego 설치1
 ***************************************************************** */
function secondInstallPopup(diegoInfo){
    if(installStatus != "done") return;
    if(!lockFileSet(diegoInfo.deploymentFile)) return;
    
    var message = diegoInfo.iaasType+" Diego ";
    var requestParameter = {
           id : diegoInfo.id,
           iaasType: diegoInfo.iaasType
    };
    w2popup.open({
        title   : "<b>"+ diegoInfo.iaasType.toUpperCase()+" 클라우드 환경 Diego 설치</b>",
        width   : 800,
        height  : 620,
        modal   : true,
        showMax : true,
        body    : $("#InstallDiv2").html(),
        buttons : $("#InstallDivButtons").html(),
        onOpen : function(event){
            event.onComplete = function(){
                if(diegoInstallSocket != null) diegoInstallSocket = null;
                if(installClient != null) installClient = null;
                diegoInstallSocket = new SockJS('/deploy/hbDiego/install/diegoInstall');
                installClient = Stomp.over(diegoInstallSocket);
                installClient.connect({}, function(frame) {
                    installClient.subscribe('/user/deploy/hbDiego/install/logs', function(data){
                        var installLogs = $(".w2ui-msg-body #installLogs");
                        var response = JSON.parse(data.body);
                        if ( response.messages != null ){
                            for ( var i=0; i < response.messages.length; i++) {
                                installLogs.append(response.messages[i] + "\n").scrollTop( installLogs[0].scrollHeight );
                            }
                            if ( response.state.toLowerCase() != "started" ) {
                                if ( response.state.toLowerCase() == "done" ) message = message + " 설치가 완료되었습니다."; 
                                if ( response.state.toLowerCase() == "error" ) message = message + " 설치 중 오류가 발생하였습니다.<br>설정을 확인해주세요.";
                                if ( response.state.toLowerCase() == "cancelled" ) message = message + " 설치 중 취소되었습니다.";
                                
                                installStatus = response.state.toLowerCase();
                                $('.w2ui-msg-buttons #deployPopupBtn').prop("disabled", false);
                                    
                                installClient.disconnect();
                                w2alert(message, "Diego 설치");
                            }
                        }
                    });
                    installClient.send('/send/deploy/hbDiego/install/diegoInstall', {}, JSON.stringify(requestParameter));
                });
            }
        }, onClose : function(event){
               event.onComplete = function(){
                   w2ui['config_diegoGrid2'].clear();
                   w2ui['config_diegoGrid3'].clear();
                   doSearch();
                   if( installClient != ""  ){
                       installClient.disconnect();
                   }
                   popupClose();
               }
           }
    });
}

/******************************************************************
 * 기능 : lockFileSet
 * 설명 : Lock 파일 생성
 ***************************************************************** */
var lockFile = false;
function lockFileSet(deployFile){
    if(!checkEmpty(deployFile) ){
        var FileName = "hybird_diego";
        var message = "현재 다른 설치 관리자가 Diego를 사용 중 입니다.";
        lockFile = commonLockFile("<c:url value='/common/deploy/lockFile/"+FileName+"'/>",message);
    }
    return lockFile;
}


/******************************************************************
 * 기능 : getDiegoDefaultInfo
 * 설명 : DIEGO 기본 정보 조회
 ***************************************************************** */
function getDiegoDefaultInfo(){
    $.ajax({
        type : "GET",
        url : "/deploy/hbDiego/default/list",
        contentType : "application/json",
        async : true,
        success : function(data, status) {
            if( data.length == 0 ){
                return;
            }
            var options = "<option value=''>Diego 기본 정보를 선택하세요.</option>";
            for( var i=0; i<data.records.length; i++ ){
                if( data.records[i].defaultConfigName == diegoInfo.defaultConfigInfo ){
                    options += "<option value='"+data.records[i].defaultConfigName+"' selected>"+data.records[i].defaultConfigName+"</option>";
                }else options += "<option value='"+data.records[i].defaultConfigName+"'>"+data.records[i].defaultConfigName+"</option>";
            }
            $(".w2ui-msg-body select[name='defaultConfigInfo']").html(options);
        },
        error : function( e, status ) {
            w2alert("Diego Default 정보 "+search_data_fail_msg, "Diego 설치");
        }
    });
}

/******************************************************************
 * 기능 : getDiegoNetworkInfo
 * 설명 : DIEGO 네트워크 정보 조회
 ***************************************************************** */
function getDiegoNetworkInfo(){
    $.ajax({
        type : "GET",
        url : "/deploy/hbDiego/network/list",
        contentType : "application/json",
        async : true,
        success : function(data, status) {
            if( data.length == 0 ){
                return;
            }
            var options = "<option value=''>Diego 네트워크 정보를 선택하세요.</option>";
            for( var i=0; i<data.records.length; i++ ){
                if( data.records[i].networkConfigName == diegoInfo.networkConfigInfo ){
                    options += "<option value='"+data.records[i].networkConfigName+"' selected>"+data.records[i].networkConfigName+"</option>";
                }else options += "<option value='"+data.records[i].networkConfigName+"'>"+data.records[i].networkConfigName+"</option>";
            }
            $(".w2ui-msg-body select[name='networkConfigInfo']").html(options);
        },
        error : function( e, status ) {
            w2alert("네트워크 기본 정보 "+search_data_fail_msg, "Diego 설치");
        }
    });
}


/******************************************************************
 * 기능 : getDiegoResourceInfo
 * 설명 : DIEGO 리소스 정보 조회
 ***************************************************************** */
function getDiegoResourceInfo(){
    $.ajax({
        type : "GET",
        url : "/deploy/hbDiego/resource/list",
        contentType : "application/json",
        async : true,
        success : function(data, status) {
            if( data.length == 0 ){
                return;
            }
            var options = "<option value=''>Diego 리소스 정보를 선택하세요.</option>";
            for( var i=0; i<data.records.length; i++ ){
                if( data.records[i].resourceConfigName == diegoInfo.resourceConfigInfo ){
                    options += "<option value='"+data.records[i].resourceConfigName+"' selected>"+data.records[i].resourceConfigName+"</option>";
                }else options += "<option value='"+data.records[i].resourceConfigName+"'>"+data.records[i].resourceConfigName+"</option>";
            }
            $(".w2ui-msg-body select[name='resourceConfigInfo']").html(options);
        },
        error : function( e, status ) {
            w2alert("Diego 리소스 정보 "+search_data_fail_msg, "Diego 설치");
        }
    });
}

/******************************************************************
 * 기능 : getDiegoInstanceInfo
 * 설명 : DIEGO 인스턴스 정보 조회
 ***************************************************************** */
function getDiegoInstanceInfo(){
    $.ajax({
        type : "GET",
        url : "/deploy/hbDiego/instance/list",
        contentType : "application/json",
        async : true,
        success : function(data, status) {
            if( data.length == 0 ){
                return;
            }
            var options = "<option value=''>Diego 인스턴스 정보를 선택하세요.</option>";
            for( var i=0; i<data.records.length; i++ ){
                if( data.records[i].instanceConfigName == diegoInfo.instanceConfigInfo ){
                    options += "<option value='"+data.records[i].instanceConfigName+"' selected>"+data.records[i].instanceConfigName+"</option>";
                }else options += "<option value='"+data.records[i].instanceConfigName+"'>"+data.records[i].instanceConfigName+"</option>";
            }
            $(".w2ui-msg-body select[name='instanceConfigInfo']").html(options);
        },
        error : function( e, status ) {
            w2alert("Diego 인스턴스 정보 "+search_data_fail_msg, "Diego 설치");
        }
    });
}

/******************************************************************
 * 기능 : saveDiegoInfo
 * 설명 : DIEGO 정보 저장
 ***************************************************************** */
function saveDiegoInfo(){
    w2popup.lock( save_lock_msg, true); 
    diegoInfo = {
        id                     : $(".w2ui-msg-body input[name='diegoInfoId']").val(),
        diegoConfigName           : $(".w2ui-msg-body input[name='diegoConfigName']").val(),
        iaasType               : $(".w2ui-msg-body select[name='iaasType']").val(),
        networkConfigInfo      : $(".w2ui-msg-body select[name='networkConfigInfo']").val(),
        defaultConfigInfo      : $(".w2ui-msg-body select[name='defaultConfigInfo']").val(),
        resourceConfigInfo     : $(".w2ui-msg-body select[name='resourceConfigInfo']").val(),
        instanceConfigInfo     : $(".w2ui-msg-body select[name='instanceConfigInfo']").val()
    }
    
    $.ajax({
        type : "PUT",
        url : "/deploy/hbDiego/install/save",
        contentType : "application/json",
        async : true,
        data : JSON.stringify(diegoInfo),
        success : function(status) {
            // ajax가 성공할때 처리...
            w2popup.unlock();
            w2popup.close();
            w2ui['config_diegoGrid'].clear();
            w2ui['config_diegoGrid2'].clear();
            doSearch();
        },
        error : function(request, status, error) {
            // ajax가 실패할때 처리...
            w2popup.unlock();
            w2ui['config_diegoGrid'].clear();
            w2ui['config_diegoGrid2'].clear();
            doSearch();
            w2popup.close();
            var errorResult = JSON.parse(request.responseText);
            w2alert(errorResult.message);
        }
    });
}

/******************************************************************
 * 기능 : deleteDiegoInfo
 * 설명 : DIEGO 정보 삭제
 ***************************************************************** */
function deleteDiegoInfo(record){
	 diegoInfo = {
            id               : record.id,
            diegoConfigName  : record.diegoConfigName
    }
    $.ajax({
        type : "DELETE",
        url : "/deploy/hbDiego/delete/data",
        contentType : "application/json",
        async : true,
        data : JSON.stringify(diegoInfo),
        success : function(status) {
            // ajax가 성공할때 처리...
            w2popup.unlock();
            w2popup.close();
            w2ui['config_diegoGrid'].clear();
            w2ui['config_diegoGrid2'].clear();
            doSearch();
        },
        error : function(request, status, error) {
            // ajax가 실패할때 처리...
            w2ui['config_diegoGrid'].clear();
            w2ui['config_diegoGrid2'].clear();
            doSearch();
            w2popup.close();
            var errorResult = JSON.parse(request.responseText);
            w2alert(errorResult.message);
        }
    });
}

/******************************************************************
 * 기능 : deleteDiegoVmInfo
 * 설명 : DIEGO VM 삭제
 ***************************************************************** */
function deleteDiegoVmInfo(record){
    var requestParameter = {
            id:record.id,
            iaasType:record.iaasType
    };
    if ( record.deployStatus == null || record.deployStatus == '' ) {
        // 단순 레코드 삭제
        var url = "/deploy/hbDiego/delete/data";
        $.ajax({
            type : "DELETE",
            url : url,
            data : JSON.stringify(requestParameter),
            contentType : "application/json",
            success : function(data, status) {
                w2ui['config_diegoGrid'].clear();
                w2ui['config_diegoGrid2'].clear();
                w2ui['config_diegoGrid3'].clear();
                doSearch();
            },
            error : function(request, status, error) {
                var errorResult = JSON.parse(request.responseText);
                w2alert(errorResult.message, "DIEGO 삭제");
            }
        });
    } else {
        if(!lockFileSet(record.deploymentFile)) return;
        var message = "Diego";
        var body = '<textarea id="deleteLogs" style="width:95%;height:90%;overflow-y:visible;resize:none;background-color: #FFF; margin:2%" readonly="readonly"></textarea>';
        
        w2popup.open({
            width   : 700,
            height  : 500,
            title   : "<b>Diego 삭제</b>",
            body    : body,
            buttons : '<button class="btn" style="float: right; padding-right: 15%;" onclick="popupComplete();">닫기</button>',
            modal   : true,
            showMax : true,
            onOpen  : function(event){
                event.onComplete = function(){
                    var socket = new SockJS('/deploy/hbDiego/delete/instance');
                    deleteClient = Stomp.over(socket);
                     deleteClient.connect({}, function(frame) {
                        deleteClient.subscribe('/user/deploy/hbDiego/delete/logs', function(data){
                            
                            var deleteLogs = $(".w2ui-msg-body #deleteLogs");
                            var response = JSON.parse(data.body);
                            
                            if ( response.messages != null ) {
                                   for ( var i=0; i < response.messages.length; i++) {
                                       deleteLogs.append(response.messages[i] + "\n").scrollTop( deleteLogs[0].scrollHeight );
                                   }
                                   if ( response.state.toLowerCase() != "started" ) {
                                    if ( response.state.toLowerCase() == "done" )    message = message + " 삭제가 완료되었습니다."; 
                                    if ( response.state.toLowerCase() == "error" ) message = message + " 삭제 중 오류가 발생하였습니다.<br>설정을 확인해주세요.";
                                    if ( response.state.toLowerCase() == "cancelled" ) message = message + " 삭제 중 취소되었습니다.";
                                    
                                    installStatus = response.state.toLowerCase();
                                    deleteClient.disconnect();
                                    w2alert(message, "Diego 삭제");
                                   }
                            }
                        });
                        deleteClient.send('/send/deploy/hbDiego/delete/instance', {}, JSON.stringify(requestParameter));
                    });
                }
            }, onClose : function (event){
                event.onComplete= function(){
                    w2ui['config_diegoGrid3'].clear();
                    if( deleteClient != ""  ){
                        deleteClient.disconnect();
                    }
                    popupClose();
                }
            } 
        });
    }
}

/******************************************************************
 * 기능 : 팝업창 닫을 경우
 * 설명 : popupClose
 ***************************************************************** */
function popupClose() {
   //grid Reload
   doSearch();
   doButtonStyle();
}

/******************************************************************
 * 기능 : getDeployInfo
 * 설명 : Manifest 파일 내용 출력
 ***************************************************************** */
function getDeployInfo(deployFileName){
    $.ajax({
        type : "GET",
        url :"/common/use/deployment/"+deployFileName,
        contentType : "application/json",
        async : true,
        success : function(data, status) {
            if(data == ""){
                $(".w2ui-msg-body #deployInfo").text("배포 파일이 작성되지 않았습니다.")
            } else {
                if(status == "success"){
                    $(".w2ui-msg-body #deployInfo").text(data);
                }
            }
        },
        error : function( e, status ) {
            w2alert("Temp 파일을 가져오는 중 오류가 발생하였습니다. ", "Diego 설치");
        }
    });
}

/******************************************************************
 * 기능 : doSearch
 * 설명 : Bootstrap 목록 조회
 ***************************************************************** */
function doSearch() {
    //doButtonStyle();
    diegoInfo = "";
    w2ui['config_diegoGrid'].load("<c:url value='/deploy/hbDiego/list/installAble'/>",
            function (){ doButtonStyle(); });
    w2ui['config_diegoGrid3'].load("<c:url value='/deploy/hbDiego/list/installed'/>");
}
 /******************************************************************
  * 기능 : doButtonStyle
  * 설명 : Button 제어
  ***************************************************************** */
function doButtonStyle(){
    $('#modifyBtn').attr('disabled', true);
    $('#deleteBtn').attr('disabled', true);
    $('#deleteVmBtn').attr('disabled', true);
    $('#modifyVmBtn').attr('disabled', true);
    $('#manifestBtn').attr('disabled', true);
    $('#manifestVmBtn').attr('disabled', true);
}

 /******************************************************************
  * 기능 : clearMainPage
  * 설명 : 다른페이지 이동시 Bootstrap Grid clear
  ***************************************************************** */
function clearMainPage() {
    $().w2destroy('config_diegoGrid');
    $().w2destroy('config_diegoGrid2');
    $().w2destroy('config_diegoGrid3');
}

 /******************************************************************
  * 설명 : 화면 리사이즈시 호출 
  ***************************************************************** */
$( window ).resize(function() {
    setLayoutContainerHeight();
});

/******************************************************************
 * 기능 : popupComplete
 * 설명 : 설치 화면 닫기
 ***************************************************************** */
function popupComplete(){
    var msg;
    if(installStatus == "done" || installStatus == "error"){
        msg = $(".w2ui-msg-title b").text() + " 화면을 닫으시겠습니까?";
    }else{
        msg = $(".w2ui-msg-title b").text() + " 화면을 닫으시겠습니까?<BR>(닫은 후에도 완료되지 않는 설치 또는 삭제 작업은 계속 진행됩니다.)";
    }
    w2confirm({
        title   : $(".w2ui-msg-title b").text(),
        msg     : msg,
        yes_text: "확인",
        yes_callBack : function(envent){
            popupClose();
            w2popup.close();
        },
        no_text : "취소"
    });
}
</script>

<div id="main">
    <div class="page_site">이종 DIEGO 설치 > <strong>이종 DIEGO 설치</strong></div>
    <!-- BOOTSTRAP 목록-->
    <div class="pdt20"> 
        <div class="title fl">배포 가능 한 Private/Public DIEGO 목록 (더블 클릭) </div>
        <div class="fr"> 
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="installBtn" class="btn btn-primary"  style="width:120px">정보 등록</span>
            </sec:authorize>
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="modifyBtn" class="btn btn-info" style="width:120px">정보 수정</span>
            </sec:authorize>
            
           <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="manifestBtn" class="btn btn-warning" style="width:120px">배포 파일 확인</span>
            </sec:authorize>
            
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="deleteBtn" class="btn btn-danger" style="width:120px">정보 삭제</span>
            </sec:authorize>
        </div>
    </div>
    <div id="config_diegoGrid" style="width:100%; height:300px"></div>
    
    
    <div class="pdt20"> 
        <div class="title fl">배포 할 Private/Public DIEGO 목록 (더블 클릭)</div>
        <div class="fr"> 
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="installVmBtn" class="btn btn-primary"  style="width:120px">VM 설치</span>
            </sec:authorize>
        </div>
    </div>
    <div id="config_diegoGrid2" style="width:100%; height:300px"></div>
    
    <div class="pdt20"> 
        <div class="title fl">배포 한 Private/Public DIEGO 목록 </div>
        <div class="fr">
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="modifyVmBtn" class="btn btn-info"  style="width:120px">VM 수정</span>
            </sec:authorize>
             <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="manifestVmBtn" class="btn btn-warning" style="width:120px">배포 파일 확인</span>
            </sec:authorize>
            
            <sec:authorize access="hasAuthority('CONFIG_DIRECTOR_MENU')">
            <span id="deleteVmBtn" class="btn btn-danger"  style="width:120px">VM 삭제</span>
            </sec:authorize>
        </div>
    </div>
    <div id="config_diegoGrid3" style="width:100%; height:300px"></div>
</div>

<div id="diegoRegistInfoDiv" style="width:100%;height:100%;" hidden="true">
    <form id="settingForm" action="POST">
    <input class="form-control" name = "diegoInfoId" type="hidden"/>
        <div class="w2ui-page page-0" style="margin-top:30px;padding:0 3%;">
            <div class="panel panel-info"> 
                <div class="panel-heading" style = "text-align: left; font-size:15px;"><b>이종 Diego 설치 정보</b></div>
                <div class="panel-body" style="padding:5px 5% 7px 5%;">
                   <div class="w2ui-field">
                       <label style="width:40%; text-align: left;padding-left: 20px;">Diego 정보 별칭</label>
                       <div>
                           <input class="form-control" name = "diegoConfigName" type="text"  maxlength="100" style="width: 320px; margin-left: 20px;" placeholder="Diego 정보 별칭을 입력 하세요."/>
                       </div>
                   </div>
                  <div class="w2ui-field">
                       <label style="width:40%;text-align: left;padding-left: 20px;">클라우드 인프라 환경</label>
                       <div>
                           <select class="form-control" onchange="" name="iaasType" style="width: 320px; margin-left: 20px;">
                               <option value="">인프라 환경을 선택하세요.</option>
                               <option value="aws">AWS</option>
                               <option value="openstack">Openstack</option>
                           </select>
                       </div>
                   </div>
                   <div class="w2ui-field">
                      <label style="width:40%;text-align: left;padding-left: 20px;">Diego 기본 정보 별칭</label>
                      <div style="width: 60%">
                          <select class="form-control" name="defaultConfigInfo" onchange="" style="width: 320px; margin-left: 20px;">
                              <option value="">Diego 기본 정보를 선택하세요.</option>
                          </select>
                      </div>
                   </div>
                   <div class="w2ui-field">
                      <label style="width:40%;text-align: left;padding-left: 20px;">Diego 네트워크 정보 별칭</label>
                      <div style="width: 60%">
                          <select class="form-control" name="networkConfigInfo" onchange="" style="width: 320px; margin-left: 20px;">
                              <option value="">Diego 네트워크 정보를 선택하세요.</option>
                          </select>
                      </div>
                    </div>
                    <div class="w2ui-field">
                      <label style="width:40%;text-align: left;padding-left: 20px;">Diego 리소스 정보 별칭</label>
                      <div style="width: 60%">
                          <select class="form-control" name="resourceConfigInfo" onchange="" style="width: 320px; margin-left: 20px;">
                              <option value="">Diego 리소스 정보를 선택하세요.</option>
                          </select>
                      </div>
                    </div>
                    
                    <div class="w2ui-field">
                      <label style="width:40%;text-align: left;padding-left: 20px;">Diego 인스턴스 정보 별칭</label>
                      <div style="width: 60%">
                          <select class="form-control" name="instanceConfigInfo" onchange="" style="width: 320px; margin-left: 20px;">
                              <option value="">Diego 인스턴스 정보를 선택하세요.</option>
                          </select>
                      </div>
                    </div>
                    
                </div>
            </div>
        </div>
        <div class="w2ui-buttons" id="diegoRegistInfoBtnDiv" hidden="true">
            <button class="btn" id="registDiegoInfoBtn" onclick="$('#settingForm').submit();">확인</button>
            <button class="btn" id="popClose" onclick="w2popup.close();">취소</button>
        </div>
    </form>
</div>


<!-- Deploy DIV -->
<div id="DeployDiv" style="width:100%;height:100%;" hidden="true">
    <div style="width:93%;height:98%;float: left;display: inline-block;margin:10px 0 0 1%;">
        <textarea id="deployInfo" style="width:100%;height:99%;overflow-y:visible;resize:none;background-color: #FFF;margin-left:3%;" readonly="readonly"></textarea>
    </div>
</div>

<!-- Install DIV -->
<div id="InstallDiv1" style="width:100%;height:100%;" hidden="true">
    <div style="margin-left:2%;display:inline-block;width:97%;padding-top:20px;">
        <ul class="progressStep_7" >
            <li style="font-size: 15px; width: 370px;" class="active">1 Diego Install Log</li>
            <li style="font-size: 15px; width: 370px;" class="before">2 Diego Install Log</li>
        </ul>
    </div>
    <div style="width:93%;height:84%;float: left;display: inline-block;margin:10px 0 0 1%;">
        <textarea id="installLogs" style="width:100%;height:99%;overflow-y:visible;resize:none;background-color: #FFF;margin-left:3%;" readonly="readonly"></textarea>
    </div>
    <div class="w2ui-buttons" id="InstallDivButtons" hidden="true">
            <button class="btn" style="float: right; padding-right: 15%" onclick="popupComplete();">닫기</button>
    </div>
</div>

<!-- Install DIV -->
<div id="InstallDiv2" style="width:100%;height:100%;" hidden="true">
    <div style="margin-left:2%;display:inline-block;width:97%;padding-top:20px;">
        <ul class="progressStep_7" >
            <li style="font-size: 15px; width: 370px;" class="pass">1 Diego Install Log</li>
            <li style="font-size: 15px; width: 370px;" class="active">2 Diego Install Log</li>
        </ul>
    </div>
    <div style="width:93%;height:84%;float: left;display: inline-block;margin:10px 0 0 1%;">
        <textarea id="installLogs" style="width:100%;height:99%;overflow-y:visible;resize:none;background-color: #FFF;margin-left:3%;" readonly="readonly"></textarea>
    </div>
    <div class="w2ui-buttons" id="InstallDivButtons" hidden="true">
            <button class="btn" style="float: right; padding-right: 15%" onclick="popupComplete();">닫기</button>
    </div>
</div>

<script>
$(function() {
    $("#settingForm").validate({
        ignore : "",
        onfocusout: true,
        rules: {
            diegoConfigName : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body input[name='diegoConfigName']").val() );
                }
            },
            iaasType : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body select[name='iaasType']").val() );
                }
            },
            defaultConfigInfo : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body select[name='defaultConfigInfo']").val() );
                }
            },
            networkConfigInfo : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body select[name='networkConfigInfo']").val() );
                }
            },
            resourceConfigInfo : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body select[name='resourceConfigInfo']").val() );
                }
            },
            instanceConfigInfo : {
                required : function(){
                  return checkEmpty( $(".w2ui-msg-body select[name='instanceConfigInfo']").val() );
                }
            }
        }, messages: {
        	diegoConfigName: { 
                 required:  "Diego 정보 별칭" + text_required_msg
            },
            iaasType: { 
                required:  "인프라 환경" + select_required_msg
            },
            defaultConfigInfo: { 
                required:  "기본 정보 별칭" + select_required_msg
            },
            networkConfigInfo: { 
                required:  "네트워크 정보 별칭" + select_required_msg
            },
            resourceConfigInfo: { 
                required:  "리소스 정보 별칭" + select_required_msg
            },
            instanceConfigInfo: { 
                required:  "인스턴스 정보 별칭" + select_required_msg
            },
        }, unhighlight: function(element) {
            setSuccessStyle(element);
        },errorPlacement: function(error, element) {
            //do nothing
        }, invalidHandler: function(event, validator) {
            var errors = validator.numberOfInvalids();
            if (errors) {
                setInvalidHandlerStyle(errors, validator);
            }
        }, submitHandler: function (form) {
            saveDiegoInfo();
        }
    });
});

</script>