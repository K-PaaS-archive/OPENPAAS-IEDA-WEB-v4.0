package org.openpaas.ieda.hbdeploy.web.deploy.cfDeployment.dao;

import java.sql.Array;
import java.util.Date;

import javax.validation.constraints.NotNull;

public class HbCfDeploymentNetworkConfigVO {
    @NotNull
    private Integer id;
    @NotNull
    private Integer recid;
    private String iaasType;
    private String networkName;
    private String direction; //network direction :internal or external
    private String publicStaticIp;
    private Array subnetId;
    private Array securityGroup;
    private Array subnetRange;
    private Array subnetGateway;
    private Array subnetDns;
    private Array subnetReservedFrom;
    private Array subnetReservedTo;
    private Array subnetStaticFrom;
    private Array subnetStaticTo;
    private String subnetId1;
    private String securityGroup1;
    private String subnetRange1;
    private String subnetGateway1;
    private String subnetDns1;
    private String subnetReservedFrom1;
    private String subnetReservedTo1;
    private String subnetStaticFrom1;
    private String subnetStaticTo1;
    private String subnetId2;
    private String securityGroup2;
    private String subnetRange2;
    private String subnetGateway2;
    private String subnetDns2;
    private String subnetReservedFrom2;
    private String subnetReservedTo2;
    private String subnetStaticFrom2;
    private String subnetStaticTo2;
    private String createUserId;//등록자 아이디
    private String updateUserId;//수정자 아이디
    private Date createDate;//등록일
    private Date updateDate;//수정일
    
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Integer getRecid() {
        return recid;
    }
    public void setRecid(Integer recid) {
        this.recid = recid;
    }
    public String getIaasType() {
		return iaasType;
	}
	public void setIaasType(String iaasType) {
		this.iaasType = iaasType;
	}
	public String getNetworkName() {
        return networkName;
    }
    public void setNetworkName(String networkName) {
        this.networkName = networkName;
    }
    public String getDirection() {
        return direction;
    }
    public void setDirection(String direction) {
        this.direction = direction;
    }
    public String getPublicStaticIp() {
        return publicStaticIp;
    }
    public void setPublicStaticIp(String publicStaticIp) {
        this.publicStaticIp = publicStaticIp;
    }

	public Array getSubnetId() {
		return subnetId;
	}
	public void setSubnetId(Array subnetId) {
		this.subnetId = subnetId;
	}
	public Array getSecurityGroup() {
		return securityGroup;
	}
	public void setSecurityGroup(Array securityGroup) {
		this.securityGroup = securityGroup;
	}
	public Array getSubnetRange() {
		return subnetRange;
	}
	public void setSubnetRange(Array subnetRange) {
		this.subnetRange = subnetRange;
	}
	public Array getSubnetGateway() {
		return subnetGateway;
	}
	public void setSubnetGateway(Array subnetGateway) {
		this.subnetGateway = subnetGateway;
	}
	public Array getSubnetDns() {
		return subnetDns;
	}
	public void setSubnetDns(Array subnetDns) {
		this.subnetDns = subnetDns;
	}
	public Array getSubnetReservedFrom() {
		return subnetReservedFrom;
	}
	public void setSubnetReservedFrom(Array subnetReservedFrom) {
		this.subnetReservedFrom = subnetReservedFrom;
	}
	public Array getSubnetReservedTo() {
		return subnetReservedTo;
	}
	public void setSubnetReservedTo(Array subnetReservedTo) {
		this.subnetReservedTo = subnetReservedTo;
	}
	public Array getSubnetStaticFrom() {
		return subnetStaticFrom;
	}
	public void setSubnetStaticFrom(Array subnetStaticFrom) {
		this.subnetStaticFrom = subnetStaticFrom;
	}
	public Array getSubnetStaticTo() {
		return subnetStaticTo;
	}
	public void setSubnetStaticTo(Array subnetStaticTo) {
		this.subnetStaticTo = subnetStaticTo;
	}
	public String getSubnetId1() {
		return subnetId1;
	}
	public void setSubnetId1(String subnetId1) {
		this.subnetId1 = subnetId1;
	}
	public String getSecurityGroup1() {
		return securityGroup1;
	}
	public void setSecurityGroup1(String securityGroup1) {
		this.securityGroup1 = securityGroup1;
	}
	public String getSubnetRange1() {
		return subnetRange1;
	}
	public void setSubnetRange1(String subnetRange1) {
		this.subnetRange1 = subnetRange1;
	}
	public String getSubnetGateway1() {
		return subnetGateway1;
	}
	public void setSubnetGateway1(String subnetGateway1) {
		this.subnetGateway1 = subnetGateway1;
	}
	public String getSubnetDns1() {
		return subnetDns1;
	}
	public void setSubnetDns1(String subnetDns1) {
		this.subnetDns1 = subnetDns1;
	}
	public String getSubnetReservedFrom1() {
		return subnetReservedFrom1;
	}
	public void setSubnetReservedFrom1(String subnetReservedFrom1) {
		this.subnetReservedFrom1 = subnetReservedFrom1;
	}
	public String getSubnetReservedTo1() {
		return subnetReservedTo1;
	}
	public void setSubnetReservedTo1(String subnetReservedTo1) {
		this.subnetReservedTo1 = subnetReservedTo1;
	}
	public String getSubnetStaticFrom1() {
		return subnetStaticFrom1;
	}
	public void setSubnetStaticFrom1(String subnetStaticFrom1) {
		this.subnetStaticFrom1 = subnetStaticFrom1;
	}
	public String getSubnetStaticTo1() {
		return subnetStaticTo1;
	}
	public void setSubnetStaticTo1(String subnetStaticTo1) {
		this.subnetStaticTo1 = subnetStaticTo1;
	}
	public String getSubnetId2() {
		return subnetId2;
	}
	public void setSubnetId2(String subnetId2) {
		this.subnetId2 = subnetId2;
	}
	public String getSecurityGroup2() {
		return securityGroup2;
	}
	public void setSecurityGroup2(String securityGroup2) {
		this.securityGroup2 = securityGroup2;
	}
	public String getSubnetRange2() {
		return subnetRange2;
	}
	public void setSubnetRange2(String subnetRange2) {
		this.subnetRange2 = subnetRange2;
	}
	public String getSubnetGateway2() {
		return subnetGateway2;
	}
	public void setSubnetGateway2(String subnetGateway2) {
		this.subnetGateway2 = subnetGateway2;
	}
	public String getSubnetDns2() {
		return subnetDns2;
	}
	public void setSubnetDns2(String subnetDns2) {
		this.subnetDns2 = subnetDns2;
	}
	public String getSubnetReservedFrom2() {
		return subnetReservedFrom2;
	}
	public void setSubnetReservedFrom2(String subnetReservedFrom2) {
		this.subnetReservedFrom2 = subnetReservedFrom2;
	}
	public String getSubnetReservedTo2() {
		return subnetReservedTo2;
	}
	public void setSubnetReservedTo2(String subnetReservedTo2) {
		this.subnetReservedTo2 = subnetReservedTo2;
	}
	public String getSubnetStaticFrom2() {
		return subnetStaticFrom2;
	}
	public void setSubnetStaticFrom2(String subnetStaticFrom2) {
		this.subnetStaticFrom2 = subnetStaticFrom2;
	}
	public String getSubnetStaticTo2() {
		return subnetStaticTo2;
	}
	public void setSubnetStaticTo2(String subnetStaticTo2) {
		this.subnetStaticTo2 = subnetStaticTo2;
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