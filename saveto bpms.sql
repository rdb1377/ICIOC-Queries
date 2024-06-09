USE [BPMSSRV2]
GO

INSERT INTO [ray].[BPMAPP_Workstation_Repairs]
           ([Id]
           ,[BPMSProcessInfoString]
           ,[EnterDate]
           ,TicketNo
		   ,Type
           ,[UserId]
           ,[StaffId]
           )
     select
           newid() 
           ,'<BPMInfos xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><ProcessInfosList /></BPMInfos>'
           ,14020722
		   ,t.TicketNumber
		   ,'سیستم جدید'
		   ,u.id
		   ,su.StaffID

		 from [DATASRV4].[DanaDB].[dbo].[Ticket] as t	
		 join [DATASRV4].[DanaDB].[dbo].[dana_users] as D on t.applicantid = D.userid
		 join ray.MercUsers as u  on D.personalcode collate Arabic_100_CI_AS = u.login
		 join ray.mercstaffusers as su on su.userid = u.id
		 
		
	   where t.TicketNumber > 6662 and t.ticketnumber not in (select ticketNo from [ray].[BPMAPP_Workstation_Repairs] where ticketNo is not null ) and t.activity__c = 'DF46391E-AA29-4295-A545-C3DB61A5647E'

GO

