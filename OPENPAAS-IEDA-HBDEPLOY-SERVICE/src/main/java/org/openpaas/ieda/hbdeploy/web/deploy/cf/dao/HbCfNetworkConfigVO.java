package org.openpaas.ieda.hbdeploy.web.deploy.cf.dao;

import java.util.Date;

public class HbCfNetworkConfigVO {
    private Integer id;//id
    private Integer recid;
    private String iaasType;
    private String networkConfigName;
    private String createUserId;//생성자
    private String updateUserId;//수정자
    private String publicStaticIP;
    private String net; //net 구분
    private Integer seq; //시퀀스
    private String subnetStaticFrom;//VM 할당 IP대역 From
    private String subnetStaticTo;//VM 할당 IP대역 To
    private String subnetReservedFrom;//할당된 IP대역 From
    private String subnetReservedTo;//할당된 IP대역 To
    private String subnetRange;//서브넷 범위
    private String subnetGateway;//게이트웨이
    private String subnetDns;//DNS
    private String subnetId; //네트워크 ID
    private String availabilityZone;
    private String cloudSecurityGroups;//시큐리티 그룹
    private Date createDate; // 생성일자
    private Date updateDate; // 수정일자
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Integer getRecid() {
        return recid;
    }
    public String getIaasType() {
        return iaasType;
    }
    public void setIaasType(String iaasType) {
        this.iaasType = iaasType;
    }
    public void setRecid(Integer recid) {
        this.recid = recid;
    }
    public String getNetworkConfigName() {
        return networkConfigName;
    }
    public void setNetworkConfigName(String networkConfigName) {
        this.networkConfigName = networkConfigName;
    }
    public String getCreateUserId() {
        return createUserId;
    }
    public void setCreateUserId(String createUserId) {
        this.createUserId = createUserId;
    }
    public String getUpdateUserId() {
        return updateUserId;
    }
    public void setUpdateUserId(String updateUserId) {
        this.updateUserId = updateUserId;
    }
    public String getPublicStaticIP() {
        return publicStaticIP;
    }
    public void setPublicStaticIP(String publicStaticIP) {
        this.publicStaticIP = publicStaticIP;
    }
    public String getNet() {
        return net;
    }
    public void setNet(String net) {
        this.net = net;
    }
    public Integer getSeq() {
        return seq;
    }
    public void setSeq(Integer seq) {
        this.seq = seq;
    }
    public String getSubnetStaticFrom() {
        return subnetStaticFrom;
    }
    public void setSubnetStaticFrom(String subnetStaticFrom) {
        this.subnetStaticFrom = subnetStaticFrom;
    }
    public String getSubnetStaticTo() {
        return subnetStaticTo;
    }
    public void setSubnetStaticTo(String subnetStaticTo) {
        this.subnetStaticTo = subnetStaticTo;
    }
    public String getSubnetReservedFrom() {
        return subnetReservedFrom;
    }
    public void setSubnetReservedFrom(String subnetReservedFrom) {
        this.subnetReservedFrom = subnetReservedFrom;
    }
    public String getSubnetReservedTo() {
        return subnetReservedTo;
    }
    public void setSubnetReservedTo(String subnetReservedTo) {
        this.subnetReservedTo = subnetReservedTo;
    }
    public String getSubnetRange() {
        return subnetRange;
    }
    public void setSubnetRange(String subnetRange) {
        this.subnetRange = subnetRange;
    }
    public String getSubnetGateway() {
        return subnetGateway;
    }
    public void setSubnetGateway(String subnetGateway) {
        this.subnetGateway = subnetGateway;
    }
    public String getSubnetDns() {
        return subnetDns;
    }
    public void setSubnetDns(String subnetDns) {
        this.subnetDns = subnetDns;
    }
    public String getSubnetId() {
        return subnetId;
    }
    public void setSubnetId(String subnetId) {
        this.subnetId = subnetId;
    }
    public String getAvailabilityZone() {
        return availabilityZone;
    }
    public void setAvailabilityZone(String availabilityZone) {
        this.availabilityZone = availabilityZone;
    }
    public String getCloudSecurityGroups() {
        return cloudSecurityGroups;
    }
    public void setCloudSecurityGroups(String cloudSecurityGroups) {
        this.cloudSecurityGroups = cloudSecurityGroups;
    }
    public Date getCreateDate() {
        return createDate;
    }
    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
    public Date getUpdateDate() {
        return updateDate;
    }
    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }
}
