/****** Script for SelectTopNRows command from SSMS  ******/
--BPH
SELECT  EnSerial,
		cast(TelNumber as nvarchar(100)) as TelNumber,
		LocalPulse ,
		NationalPulse , 
		MobilePulse ,
		LocalPulse* 45 AS LocalRial , 
		NationalPulse *330 AS NationalRial, 
		MobilePulse * 625 AS MobileRial , 
		LocalPulse* 45 + NationalPulse *330 + MobilePulse * 625 AS SumRial , 
		TotalPermit ,
		GREATEST(LocalPulse* 45 + NationalPulse *330 + MobilePulse * 625- TotalPermit  , 0) AS DiffSumPermit ,
		TotalPermit / 30 as DayPermit,
		cast(ROUND((case when TotalPermit!=0 then GREATEST(LocalPulse* 45 + NationalPulse *330 + MobilePulse * 625- TotalPermit  , 0) / (TotalPermit/30) else 0 end) , 0) as int) AS DayStop,
	    14030101 AS firstdate,
	    14030131 AS lastdate,
		cast(Snhazine as int) as Snhazine  ,
		OfiCode,
		SnClass,
		283 AS ImportSerial
		FROM (

SELECT
		ROW_NUMBER() OVER (ORDER BY SubscriberTelNo) as EnSerial
		,SubscriberTelNo as TelNumber
		,sum( case when RegisterID=1 then CEILING(CallDuration/60.0) else 0 end) as LocalPulse
		,sum( case when RegisterID=2 then CEILING(CallDuration/60.0) else 0 end) as NationalPulse
		,sum( case when RegisterID=3 then CEILING(CallDuration/60.0) else 0 end) as MobilePulse 	  
		,(case when permit is not null then permit else 0 end) as TotalPermit
		,Snhazine
		,OfiCode
		,SnClass

  FROM [SMDA].[dbo].[tblSubscriberCallDetail] as CD
  JOIN [SMDA].[dbo].[tblSubscriber] as S on CD.SubscriberID = S.SubscriberID
  Join [Mokhaberat].[dbo].[MoshtarakinTbl] as M on M.telnumber = s.SubscriberTelNo
  left Join [Mokhaberat].[dbo].[PermitTbl] as p on p.telnumber = s.SubscriberTelNo

  where MeteringAlgorithm = 'P'   and CallDateTime < '2024-04-20 00:00:00.000'  and CallDateTime > '2024-03-20 00:00:00.000'
  group by SubscriberTelNo , snhazine , oficode , snclass , permit
  ) i
  ORDER BY i.TelNumber



  --------------


--CPH

 SELECT
		ROW_NUMBER() OVER (ORDER BY SubscriberTelNo ,calldatetime ) as EnSerial
		,cast(SubscriberTelNo as varchar(12)) as EnTelNumber1 
		,cast(substring(CalledTelNo , 1 , 12) as varchar(12)) as EnTelNumber2
		,Convert(VarChar(20),CallDateTime,112) as EnDate
		, cast(format(CallDateTime ,'hhmmss')as int) as EnTime
		,calculatedcallmeter as EnDurSecond
		,systemcalculatedpulses as EnPulse
		,'14021001' as EnDate1
		,'14021030' as EnDate2
		,280 as ImportSerial
		

  FROM [SMDA].[dbo].[tblSubscriberCallDetail] as CD
  JOIN [SMDA].[dbo].[tblSubscriber] as S on CD.SubscriberID = S.SubscriberID
  Join [Mokhaberat].[dbo].[MoshtarakinTbl] as M on M.telnumber = s.SubscriberTelNo
  left Join [Mokhaberat].[dbo].[PermitTbl] as p on p.telnumber = s.SubscriberTelNo

  where (MeteringAlgorithm = 'P' or BGroupID = '5')  and CallDateTime < '2024-01-21 00:00:00.000'  and CallDateTime > '2023-12-22 00:00:00.000'

  


