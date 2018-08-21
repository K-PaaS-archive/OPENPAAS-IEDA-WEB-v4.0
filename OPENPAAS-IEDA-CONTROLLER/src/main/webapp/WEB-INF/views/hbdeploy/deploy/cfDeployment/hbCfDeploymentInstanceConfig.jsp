<%
/* =================================================================
 * 작성일 : 2018.07
 * 작성자 : 이정윤
 * 상세설명 : CF Deploymnet 인스턴스 정보 관리 화면
 * =================================================================
 */ 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri = "http://www.springframework.org/tags" %>

<script type="text/javascript">
var text_required_msg = '<spring:message code="common.text.vaildate.required.message"/>';//을(를) 입력하세요.
var select_required_msg = '<spring:message code="common.select.vaildate.required.message"/>';//을(를) 선택하세요.
var search_data_fail_msg = '클라우드 인프라 환경을 선택하세요.';
var instanceConfigInfo = "";//인스턴스 정보
var iaas = "";
var jobsInfo=[];
var resourceLayout = {
        layout2: {
            name: 'layout2',
            padding: 4,
            panels: [
                { type: 'left', size: '65%', resizable: true, minSize: 300 },
                { type: 'main', minSize: 300 }
            ]
        },
        /********************************************************
         *  설명 : 인스턴스 정보 목록 Grid
        *********************************************************/
        grid: {
            name: 'instance_grid',
            header: '<b>Instance 정보</b>',
            method: 'GET',
                multiSelect: false,
            show: {
                    selectColumn: true,
                    footer: true},
            style: 'text-align: center',
            columns:[
                   { field: 'recid', hidden: true },
                   { field: 'id', hidden: true },
                   { field: 'instanceConfigName', caption: '인스턴스 정보 별칭', size:'100px', style:'text-align:center;' },
                   { field: 'iaasType', caption: '인프라 환경 타입', size:'100px', style:'text-align:center;' ,render: function(record){ 
                       if(record.iaasType.toLowerCase() == "aws"){
                           return "<img src='images/iaasMgnt/aws-icon.png' width='80' height='30' />";
                       }else if (record.iaasType.toLowerCase() == "openstack"){
                           return "<img src='images/iaasMgnt/openstack-icon.png' width='90' height='35' />";
                       }
                   }},
                   { field: 'adapter', caption: 'Adapter', size:'90px', style:'text-align:center;'},
                   { field: 'api', caption: 'API', size:'90px', style:'text-align:center;'},
                   { field: 'ccWorker', caption: 'CC-Worker', size:'90px', style:'text-align:center;'},
                   { field: 'consul', caption: 'Consul', size:'90px', style:'text-align:center;'},
                   { field: 'theDatabase', caption: 'Database', size:'90px', style:'text-align:center;'},
                   { field: 'diegoApi', caption: 'Diego-API', size:'90px', style:'text-align:center;'},
                   { field: 'diegoCell', caption: 'Diego-Cell', size:'90px', style:'text-align:center;'},
                   { field: 'doppler', caption: 'Doppler', size:'90px', style:'text-align:center;'},
                   { field: 'haproxy', caption: 'HA-Proxy', size:'90px', style:'text-align:center;'},
                   { field: 'logApi', caption: 'Log-API', size:'90px', style:'text-align:center;'},
                   { field: 'nats', caption: 'NATS', size:'90px', style:'text-align:center;'},
                   { field: 'router', caption: 'Router', size:'90px', style:'text-align:center;'},
                   { field: 'singletonBlobstore', caption: 'Singleton-Blobstore', size:'130px', style:'text-align:center;'},
                   { field: 'tcpRouter', caption: 'TCP-Router', size:'90px', style:'text-align:center;'},
                   { field: 'uaa', caption: 'UAA', size:'90px', style:'text-align:center;'}

                  ],
            onSelect : function(event) {
                event.onComplete = function() {
                    $('#deleteBtn').attr('disabled', false);
                    settingResourceInfo();
                    return;
                }
            },
            onUnselect : function(event) {
                event.onComplete = function() {
                    resetForm();
                    $('#deleteBtn').attr('disabled', true);
                    return;
                }
            },onLoad:function(event){
                if(event.xhr.status == 403){
                    location.href = "/abuse";
                    event.preventDefault();
                }
            },onError : function(event) {
            },
        form: { 
            header: 'Edit Record',
            name: 'regPopupDiv',
            fields: [
                { name: 'recid', type: 'text', html: { caption: 'ID', attr: 'size="10" readonly' } },
                { name: 'fname', type: 'text', required: true, html: { caption: 'First Name', attr: 'size="40" maxlength="40"' } },
                { name: 'lname', type: 'text', required: true, html: { caption: 'Last Name', attr: 'size="40" maxlength="40"' } },
                { name: 'email', type: 'email', html: { caption: 'Email', attr: 'size="30"' } },
                { name: 'sdate', type: 'date', html: { caption: 'Date', attr: 'size="10"' } }
            ],
            actions: {
                Reset: function () {
                    this.clear();
                },
                Save: function () {
                    var errors = this.validate();
                    if (errors.length > 0) return;
                    if (this.recid == 0) {
                        w2ui.grid.add($.extend(true, { recid: w2ui.grid.records.length + 1 }, this.record));
                        w2ui.grid.selectNone();
                        this.clear();
                    } else {
                        w2ui.grid.set(this.recid, this.record);
                        w2ui.grid.selectNone();
                        this.clear();
                    }
                }
            }
        }
    }
}

$(function(){
	settingCfJobs();
    $('#instance_grid').w2layout(resourceLayout.layout2);
    w2ui.layout2.content('left', $().w2grid(resourceLayout.grid));
    w2ui['layout2'].content('main', $('#regPopupDiv').html());
    doSearch();
    
    $("#deleteBtn").click(function(){
        if($("#deleteBtn").attr('disabled') == "disabled") return;
        var selected = w2ui['instance_grid'].getSelection();
        if( selected.length == 0 ){
            w2alert("선택된 정보가 없습니다.", "인스턴스 삭제");
            return;
        }
        else {
            var record = w2ui['instance_grid'].get(selected);
            w2confirm({
                title        : "인스턴스 정보",
                msg            : "인스턴스 정보 ("+record.instanceConfigName + ")을 삭제하시겠습니까?",
                yes_text    : "확인",
                no_text        : "취소",
                yes_callBack: function(event){
                    deleteHbCfDeploymnetInstanceConfigInfo(record.recid, record.instanceConfigName);
                },
                no_callBack    : function(){
                    w2ui['instance_grid'].clear();
                    doSearch();
                }
            });
        }
    });
});
/********************************************************
 * 설명 : CF 고급 설정 paasta release version 설정
 * 기능 : settingReleaseVersion
 *********************************************************/
function settingReleaseVersion( version ){
    return version;
}
/********************************************************
 * 설명 : CF Jobs 정보 설정
 * 기능 : settingCfJobs
 *********************************************************/
function settingCfJobs(){
    console.log("1");
    var instanceConfigInfo ="";
    /* var instanceInfo = "";
    var release_version = defaultInfo.releaseVersion;
    release_version = settingReleaseVersion(release_version); */
    //var release_version = instanceConfigInfo.releaseVersion;
    var release_version = "287";
    var deploy_type = "DEPLOY_TYPE_HYBRID_CF";
   
    $.ajax({
        type : "GET",
        url : "/deploy/hbCfDeployment/instanceConfig/job/list/"+release_version+"/"+ deploy_type,
        contentType : "application/json",
        success : function(data, status) {
            
            console.log(JSON.stringify(data)+ "TESTTESTTEST AAA BBB"+ status +"ccc");
            
            if( data != null ){
                var div = "";
                var html = "";
                html += '<div class="panel panel-info" style="height: 100%; overflow: auto;" >';
                html += '<div class="panel-body">';
                html += '<div id="cfJobListDiv">';
                html += '<p style="color:red;">- 고급 설정 값을 변경하지 않을 경우 아래에 입력 된 기본 값으로 자동 설정됩니다.</p>';
                html += '<p style="color:red;">- 해당 Job의 인스턴스 수는 0-100까지 입력하실 수 있습니다.</p>';
                
                for( var j=1; j< instanceConfigInfo.length; j++ ){
                    html += "<p style='color: #565656;font-size: 13px;font-weight:bolder;margin-top: 20px;'>[Internal 네트워크_"+ j+ "]</p>"
                    for( var i=0; i<data.length; i++ ){
                        if( j == 1 && data[i].zone_z1 == "true" ){
                            html += setJobSettingHtml(data[i], j );
                        }else if( j == 2 && data[i].zone_z2 == "true"  ){
                            html += setJobSettingHtml(data[i], j);
                        }
                    }
                }
                html +='</div></div></div>';
               // $("#cfDetailForm").html(html);
                $(".w2ui-msg-body #cfDetailForm").html("<div> aaaaaaaaaa </div>");
                
                if( jobsInfo.length > 0 ){
                    for( var i=0; i<jobsInfo.length; i++ ){
                        $(".w2ui-msg-body input[name='"+jobsInfo[i].job_name+"_"+jobsInfo[i].zone+"']").val(jobsInfo[i].instances);
                    }
                }
            }
        },
        error : function(e, status) {
            w2alert(JSON.parse(e.responseText).message, "CF Deployment");
        }
    });
}

/********************************************************
 * 설명 : CF 고급 설정 HTML 설정
 * 기능 : setJobSettingHtml
 *********************************************************/
function setJobSettingHtml(data, j){
	 console.log(data.job_name+"TEST DATA BBB");
    var html = "";
    if( !(diegoUse == "true" && ( data.job_name == "hm9000" || data.job_name == "stats" || data.job_name == "runner")) ){
        html += '<ul class="w2ui-field" style="border: 1px solid #c5e3f3;padding: 10px;">';
        html +=     '<li style="display:inline-block; width:35%;">';
        html +=         '<label style="text-align: left;font-size:11px;">'+data.job_name+'</label>';
        html +=     '</li>';
        html +=     '<li style="display:inline-block; width:60%;vertical-align:middle; line-height:3; text-align:right;">';
        html +=         '<ul>';
        html +=             '<li>';
        html +=                 '<label style="display:inline-block;">인스턴스 수 : </label>&nbsp;&nbsp;&nbsp;';
        if( iaas.toLowerCase() == "vsphere" && networkInfo.length > 2 && j == 1 && ( data.job_name == "consul" || data.job_name == "etcd" ) ){
            //vsphere Internal 네트워크가 2개 이상일 경우 etcd_z1, consul_z1의 instance 2 
            html +=                 '<input class="form-control" style="width:60%; display:inline-block;" onblur="instanceControl(this);" onfocusin="instanceControl(this);" onfocusout="instanceControl(this);" maxlength="1" type="number" min="0" max="3" value="2" id="'+data.id+'" name="'+data.job_name+'_z'+j+'"/>';
        }else{
            html +=                 '<input class="form-control" style="width:60%; display:inline-block;" onblur="instanceControl(this);" onfocusin="instanceControl(this);" onfocusout="instanceControl(this);" maxlength="1" type="number" min="0" max="3" value="1" id="'+data.id+'" name="'+data.job_name+'_z'+j+'"/>';
        }
        html +=              '</li>';
        html +=         '</ul>';
        html +=     '</li>';
        html += '</ul>';
    }
    return html;
}

/********************************************************
 * 설명 : 인스턴스 정보 목록 조회
 * 기능 : doSearch
 *********************************************************/
function doSearch() {
    instanceConfigInfo="";//인스턴스 정보
    iaas = "";
    resetForm();
    
    w2ui['instance_grid'].clear();
    w2ui['instance_grid'].load('/deploy/hbCfDeployment/instanceConfig/list');
    doButtonStyle(); 
}

/********************************************************
 * 설명 : 초기 버튼 스타일
 * 기능 : doButtonStyle
 *********************************************************/
function doButtonStyle() {
    $('#deleteBtn').attr('disabled', true);
}


/********************************************************
 * 설명 : 화면 리사이즈시 호출
 *********************************************************/
$( window ).resize(function() {
    setLayoutContainerHeight();
});

/********************************************************
 * 설명 : Lock 팝업 메세지 Function
 * 기능 : lock
 *********************************************************/
function lock (msg) {
    w2popup.lock(msg, true);
}
/********************************************************
 * 설명 : 다른 페이지 이동 시 호출 Function
 * 기능 : clearMainPage
 *********************************************************/
function clearMainPage() {
    $().w2destroy('layout2');
    $().w2destroy('instance_grid');
}
/********************************************************
 * 설명 : 인스턴스 정보 리셋
 * 기능 : resetForm
 *********************************************************/
function resetForm(status){
    $(".panel-body").find("p").remove();
    $(".panel-body").children().children().children().css("borderColor", "#bbb");
    $("input[name=instanceConfigName]").val("");
    $("select[name=iaasType]").val("");
    if(status=="reset"){
        w2ui['instance_grid'].clear();
        $("select[name=iaasType]").html("<option value=''>인프라 환경을 선택하세요.</option>");
        doSearch();
    }
    document.getElementById("cfDetailForm").reset();
}

</script>
<div id="main">
    <div class="page_site">이종 CF Deployment > <strong>Instance 정보 관리</strong></div>
    <!-- 사용자 목록-->
    <div class="pdt20">
        <div class="title fl"> 인스턴스 정보 목록</div>
    </div>
    <div id="instance_grid" style="width:100%;  height:700px;"></div>

</div>


<div id="regPopupDiv" hidden="" >
   <!--  <form id="settingForm" action="POST" > -->
    <input type="hidden" name="resourceInfoId" />
        <div class="w2ui-page page-0" style="">
           <div class="panel panel-default">
               <div class="panel-heading"><b>인스턴스 정보 ( CF 고급 설정 ) </b></div>
               <div class="panel-body" style="height:205px; overflow-y:auto;">
                   <div class="w2ui-field">
                       <label style="width:40%;text-align: left;padding-left: 20px;">인스턴스 정보 별칭</label>
                       <div>
                           <input class="form-control" name = "instanceConfigName" type="text"  maxlength="100" style="width: 320px; margin-left: 20px;" placeholder="인스턴스 별칭을 입력 하세요."/>
                       </div>
                   </div>
                   <div class="w2ui-field">
                       <label style="width:40%;text-align: left;padding-left: 20px;">클라우드 인프라 환경</label>
                       <div>
                           <select class="form-control" name="iaasType" style="width: 320px; margin-left: 20px;">
                               <option value="">인프라 환경을 선택하세요.</option>
                               <option value="aws">AWS</option>
                               <option value="openstack">Openstack</option>
                           </select>
                       </div>
                   </div>
                   <div class="w2ui-field">
                   </div>
               </div>
               <form id="cfDetailForm" style="width:100%; height:400px;"></form>
           </div>
        </div>
    <!-- </form> -->
    
    <div id="regPopupBtnDiv" style="text-align: center; margin-top: 5px;">
        <span id="installBtn" onclick="$('#cfDetailForm').submit();" class="btn btn-primary">등록</span>
        <span id="resetBtn" onclick="resetForm('reset');" class="btn btn-info">취소</span>
        <span id="deleteBtn" class="btn btn-danger">삭제</span>
    </div>
</div>
<script>
$(function() {
    
    
    $("#cfDetailForm").validate({
        ignore : [],
        //onfocusout: function(element) {$(element).valid()},
        rules: {
            instanceConfigName: { 
                required: function(){
                    return checkEmpty( $("input[name='instanceConfigName']").val() );
                }
            }, iaasType: { 
                required: function(){
                    return checkEmpty( $("select[name='iaasType']").val() );
                }
            }
            
        }, messages: {
            instanceConfigName: { 
                required:  "인스턴스 별칭"+text_required_msg
            }, iaasType: { 
                required:  "클라우드 인프라 환경 타입"+select_required_msg,
            }
            
        }, unhighlight: function(element) {
            setHybridSuccessStyle(element);
        },errorPlacement: function(error, element) {
            //do nothing
        }, invalidHandler: function(event, validator) {
            var errors = validator.numberOfInvalids();
            if (errors) {
                setHybridInvalidHandlerStyle(errors, validator);
            }
        }, submitHandler: function (form) {
        	registHbCfDeploymnetInstanceConfigInfo();
        }
    });
});


</script>