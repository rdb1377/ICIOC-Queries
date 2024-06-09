create function GetPostAPI
(
    @method varchar(5),
    @url varchar(8000),
    @token NVARCHAR(2000),
    @params NVARCHAR(2000)
)
returns varchar(8000)
as 

BEGIN
DECLARE @authHeader NVARCHAR(2000);
DECLARE @contentType NVARCHAR(64);
DECLARE @postData NVARCHAR(2000);
DECLARE @responseText NVARCHAR(2000);
DECLARE @responseXML NVARCHAR(2000);

DECLARE @ret INT;
DECLARE @status NVARCHAR(32);
DECLARE @statusText NVARCHAR(32);
DECLARE @internalToken INT;

SET @authHeader= 'Bearer ' + @token;
SET @contentType = 'application/json';

-- Open the connection.
--EXEC @ret = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT;
EXEC @ret = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @internalToken OUT;
--IF @ret <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1);

-- Send the request.
EXEC @ret = sp_OAMethod @internalToken, 'open', NULL, @method, @url, 'false';
EXEC @ret = sp_OAMethod @internalToken, 'setRequestHeader', NULL, 'Authorization', @authHeader; 
if @ret <> 0 
      begin 
            set @ret = 1
      end
EXEC @ret = sp_OAMethod @internalToken, 'setRequestHeader', NULL, 'Content-type', @contentType;

EXEC @ret = sp_OAMethod @internalToken, 'send', NULL, @params;

-- Handle the response.
EXEC @ret = sp_OAGetProperty @internalToken, 'status', @status OUT;
EXEC @ret = sp_OAGetProperty @internalToken, 'statusText', @statusText OUT;
EXEC @ret = sp_OAGetProperty @internalToken, 'responseText', @responseText OUT;

-- Show the response.
--PRINT 'Status: ' + @status + ' (' + @statusText + ')';
--PRINT 'Response text: ' + @responseText;

-- Close the connection.
EXEC @ret = sp_OADestroy @internalToken;
--IF @ret <> 0 RAISERROR('Unable to close HTTP connection.', 10, 1);
return @responseText 
END

DECLARE @method varchar(5)
DECLARE @url varchar(8000)
DECLARE @token NVARCHAR(2000)
DECLARE @params NVARCHAR(2000)



SET @method='POST';
SET @url = 'http://it.icioc.org/api/v1/Token/GetToken';
SET @token=''
SET @params = '{
    "secret":"27F748EC005E404A310B8A104BCAED924B21F016",
    "username": "admin",
    "password": "admin4431"
}';  


select dbo.GetPostAPI(@method,@url,@token,@params) as sonuc 

set @token= (select value from OPENJSON( dbo.GetPostAPI(@method,@url,@token,@params)  ) where [key] = 'ResultData')

set @token = (select value from openjson(@token) where [key] = 'access_token')

SET @url = 'http://it.icioc.org/api/V1/users/add/user';

DECLARE @fname NVARCHAR(50)
DECLARE @lname NVARCHAR(50)
DECLARE @fullname NVARCHAR(50)
DECLARE @empid NVARCHAR(10)
DECLARE @phoneNo NVARCHAR(15)
Declare @cr Cursor
set @cr = Cursor
for

SELECT firstname , lastname ,fullname , k.empid   FROM rayvarzBPMS.ray.BPMAPP_Karkard_KarkardMonthly as k join rayvarzBPMS.ray.bpmapp_employeeinfo_person as p on p.empid= k.empid  where k.EmpId  not in ( select personalcode from [DATASRV4].DanaDB.dbo.Dana_Users where IsRemoved = '0') and PostCode is not null

Open @cr

          fetch next from @cr into @fname,@lname,@fullname,@empid 

		  WHILE @@FETCH_STATUS = 0
		  begin	
		SET @params = '
		{
		"FirstName": "'+ @fname+'",
		"LastName": "'+ @lname+ '-' + @empid+'",
		"FullName": "'+ @fullname+'",
		"PersonalCode": "'+ @empid+'",
		"Email": "",
		"Tel": "",
		"TelExt": "",
		"MobilePhone": ,
		"Address": "",
		"Description":"",
		"PositionId": "",
		"PS": "12345678",
		"RepPS": "12345678",
		"IPAddress": "",
		"CheangePasswordAtNextLogin": false,
		"CannotChangePassword": false,
		"PasswordNeverExpires": false,
		"DepartmentID": "",
		"DomainId": "00000000-0000-0000-0000-000000000000",
		"UserType": 1,
		"UN": '+ @empid+',
		"AvatarPath": "",
		"IsActiveDirectory": false,
		"IsLockedOut": false,
		"IsActive": false,
		"HasAccessToUserGroupRequests": false,
		"HasAccessToCompanyRequests": false,
		"HasAccessToDepartmentRequests": false,
		"HasAccessToItsDepartmentAndSubDepartments": false,
		"HasAccessToUserAssetDepartment": false,
		"HasAccessToUserAssetCompany": false,
		"EnableNotification": 7,
		"SendInvitationEmail": false
	}';


	print (@params)

			select dbo.GetPostAPI(@method,@url,@token,@params) as sonuc 
			fetch next from @cr into @fname,@lname,@fullname,@empid 
			
		  end

Close @cr

Deallocate @cr

