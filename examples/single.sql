USE [run]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

if exists(select * from sys.objects where name = 'up_o32_gmdzdall')
drop proc up_o32_gmdzdall
go

CREATE proc [dbo].[up_o32_gmdzdall] 
  @p_orgid    dtorgid,
  @p_custid   dtcustid,
  @p_flag     dtkind
 as

  declare @serverid dtsno, @sysdate dtdate,@p_qsdm dtchar255
  declare @moneytype_rmb dtkind, @moneytype_hk dtkind

  select @moneytype_rmb = dbo.convertmoneytype('RMB') --0 人民币
  select @moneytype_hk = dbo.convertmoneytype('HK')   --1 港币
  declare @szAmarket dtkind,@szBmarket dtkind,@thirdAmarket dtkind, @thirdBmarket dtkind,@HGTmarket dtkind,@shBmarket dtkind
  select @szAmarket = dbo.convertmarket('SZAG')   --0 深A 转2，沪市1不转换
  select @szBmarket = dbo.convertmarket('SZBG')   --2 深B 转H
  select @shBmarket = dbo.convertmarket('SHBG')   --3 沪B 转D
  select @thirdAmarket = dbo.convertmarket('ZRA') --6 股转A 转9
  select @thirdBmarket = dbo.convertmarket('ZRB') --7 股转B 转A
  select @HGTmarket = dbo.convertmarket('HGT')    --5 沪港通 转G，深港S不转换
  select  @serverid = 0
  select top 1 @sysdate = sysdate,@serverid = serverid from sysconfig
  select @p_qsdm = paravalue from dbo.mixedconfig where paraid = 'oes_zqgsdm_zy'
  select errorcode = 0 , errormsg =  '查询含出入金对账单数据成功'

  begin
    select sum(cn.num) as num from(
      select count(1) as num
        from dbo.logasset a 
        inner join dbo.custbaseinfo c on a.custid = c.custid and a.serverid = c.serverid 
        where a.serverid = @serverid and a.digestid in (220000,221001) 
          and a.bizdate = @sysdate and a.orgid = @p_orgid and a.custid = @p_custid
    union all 
      select count(1) as num
        from dbo.logmateno a
        inner join dbo.custbaseinfo c on a.custid = c.custid and a.serverid = c.serverid 
        where a.serverid = @serverid and a.bizdate = @sysdate and a.orgid = @p_orgid and a.custid = @p_custid
      union all
      select count(1) as num 
        from dbo.logasset a 
      inner join dbo.custbaseinfo c on a.custid = c.custid and a.serverid = c.serverid
      where a.digestid in(221008,221009,250163)
      and a.bizdate = @sysdate and a.serverid = @serverid 
      and a.orgid = @p_orgid and a.custid = @p_custid) cn


  end 
  return 0

GO