

update d
set d.personalcode = k.empid 
FROM rayvarzBPMS.ray.BPMAPP_Karkard_KarkardMonthly as k 
join rayvarzBPMS.ray.bpmapp_employeeinfo_person as p on p.empid= k.empid 
join wars.dbo.EmployeeInfo_Person as w on w.EmpId = p.EmpId
join wars.dbo.EmployeeInfo_Person as w1 on w1.NationalCode = w.NationalCode
join DanaDB.dbo.Dana_Users as d on w1.EmpId = d.PersonalCode
where k.EmpId  not in ( select personalcode from DanaDB.dbo.Dana_Users where IsRemoved = '0' and PersonalCode is not null) and k.PostCode is not null
and w1.logdate = (14021229)
and w.LogDate = (14030106)

