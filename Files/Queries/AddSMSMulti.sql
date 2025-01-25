create PROC dbo.usp_SMS_AddMulti
@FamilyIds VARCHAR(max),
@SendToMother BIT,
@SendToFather BIT,
@SMSText NVARCHAR(1001),
@CauserId BIGINT,
@HasError INT OUT,
@Message NVARCHAR(4000) out
AS
BEGIN TRY	
	DECLARE @FamilyList TABLE(id BIGINT,SMSText NVARCHAR(1001))
	INSERT INTO @FamilyList
	(
	    id
	)
	SELECT 
		CONVERT(BIGINT,Item)
	FROM dbo.Split(@FamilyIds,',')

	DECLARE @CountFamily INT=0
	SELECT @CountFamily=COUNT(1) FROM @FamilyList
	DECLARE @now DATETIME=GETDATE()
	IF @CountFamily=0 OR @CountFamily IS null
		BEGIN
			SET @Message=N'لطفا خانواده ای رو انتخاب کنید'	
			SET @HasError=1
			RETURN 0
		END
	IF @SMSText IS NULL OR LEN(LTRIM(RTRIM(@SMSText)))=0
		BEGIN
			SET @Message=N'لطفا متن پیام را مشخص کنید'	
			SET @HasError=1
			RETURN 0
		END
	IF @SendToMother=0 AND @SendToFather=0
		BEGIN
			SET @Message=N'ارسال به پدر و یا مادر را مشخص کنید'	
			SET @HasError=1
			RETURN 0
		END

	UPDATE fl SET fl.SMSText=REPLACE(
					REPLACE(
						REPLACE(@SMSText,N'{{عنوان خانوادگی}}',f.F_Title),
					  N'{{نام کامل پدر}}',(CASE WHEN LEN(f.FatherFullName)>0 THEN f.FatherFullName ELSE f.F_Title end)),
				 N'{{نام کامل مادر}}',(CASE WHEN LEN(f.MotherFullName)>0 THEN f.MotherFullName ELSE f.F_Title end))
		FROM @FamilyList fl
		INNER JOIN dbo.Vi_Family f
		ON f.F_ID=fl.id

	IF @SendToMother=1
		BEGIN
			INSERT INTO dbo.Tb_Sms
			(
			    S_Mobile,
			    S_SendTime,
			    S_SendedTime,
			    S_Sended,
			    S_Cancel,
			    S_Text,
			    S_CauserId,
			    S_Deleted,
			    S_FamilyId,
			    S_TypeId
			)
			SELECT 
				f.F_MotherMobile,
				@now,
				NULL,
				0,
				0,
				fl.SMSText,
				 @CauserId,
				 0,
				 f.F_Id,
				 NULL	
			FROM dbo.Vi_Family f
			INNER JOIN @FamilyList fl
			ON f.F_Id=fl.id
			WHERE f.F_MotherMobile IS NOT NULL AND
				  LEN(f.F_MotherMobile)>=10 AND
                   fl.SMSText IS NOT null
		END

	IF @SendToFather=1
		BEGIN
			INSERT INTO dbo.Tb_Sms
			(
			    S_Mobile,
			    S_SendTime,
			    S_SendedTime,
			    S_Sended,
			    S_Cancel,
			    S_Text,
			    S_CauserId,
			    S_Deleted,
			    S_FamilyId,
			    S_TypeId
			)
			SELECT 
				f.F_FatherMobile,
				@now,
				NULL,
				0,
				0,
				fl.SMSText,
				 @CauserId,
				 0,
				 f.F_Id,
				 NULL	
			FROM dbo.Vi_Family f
			INNER JOIN @FamilyList fl
			ON f.F_Id=fl.id
			WHERE f.F_FatherMobile IS NOT NULL AND
				  LEN(f.F_FatherMobile)>=10 AND
                  fl.SMSText IS NOT null
		END

	SET @HasError=0
	RETURN 1

END TRY
BEGIN CATCH
	SET @Message=ERROR_MESSAGE()
	SET @HasError=1
	RETURN 0
END CATCH
GO
CREATE VIEW dbo.vi_SMS
AS
SELECT 
	[S_Id],
	[S_Mobile],
	[S_SendTime],
	[S_SendedTime],
	[S_Sended],
	[S_Cancel],
	[S_Text],
	[S_CauserId],
	[S_FamilyId],
	[S_TypeId],
	[S_QueueTime]
FROM dbo.Tb_Sms
WHERE [S_Deleted]=0
GO
ALTER PROC [dbo].[usp_Sms_Select_For_Send]
AS

DECLARE @SMS TABLE(Id BIGINT,Textt NVARCHAR(4000),Mobile VARCHAR(110))
DECLARE @now DATETIME=GETDATE()
INSERT INTO @SMS
(
    Id,
    Textt,
    Mobile
)
SELECT TOP 59 S_Id,S_Text,S_Mobile FROM dbo.vi_SMS
	WHERE S_Cancel=0 AND
		  S_Sended=0 AND
          ([S_QueueTime] IS NULL OR DATEDIFF(MINUTE,[S_QueueTime],@now)>5)
ORDER BY S_Id


UPDATE s SET s.[S_QueueTime]=@now
	FROM dbo.Tb_Sms s
	INNER JOIN @SMS ss
	ON s.S_Id=ss.Id

SELECT Id,Textt,Mobile FROM @SMS

go
alter PROC dbo.usp_SMS_Select_ForGrid
@SearchText nvarchar(1001),
@CauserId BIGINT,
@FromDate VARCHAR(10),
@ToDate VARCHAR(10),
@FamilyId BIGINT,
@OnlyQueded BIT,
@Page INT,
@PerPage INT,
@OutCount INT OUT,
@TypeId bigint
AS
if len(ltrim(rtrim(@SearchText)))=0 set @SearchText=NULL
IF @CauserId=0 SET @CauserId=NULL
IF @FamilyId=0 SET @FamilyId=NULL
IF @TypeId=0 SET @TypeId=NULL
IF LEN(@FromDate)<10 SET @FromDate=NULL
IF LEN(@ToDate)<10 SET @ToDate=null
DECLARE @FD DATE=NULL
DECLARE @TD DATE=NULL

IF @FromDate IS NOT NULL SET @FD=dbo.ConvertShamsiToMiladi(@FromDate)
IF @ToDate IS NOT NULL SET @TD=dbo.ConvertShamsiToMiladi(@ToDate)


declare @SMSs table(id bigint,rown int)

insert into @SMSs(id,rown)
select 
S_Id,
ROW_NUMBER()over(order by S_Id desc)
from dbo.vi_SMS
where (@FamilyId IS NULL OR S_FamilyId=@FamilyId) AND
	  (@CauserId IS NULL OR S_CauserId=@CauserId) AND
      (@FromDate IS NULL OR CONVERT(DATE,S_SendTime)>=@FD) AND
      (@ToDate IS NULL OR CONVERT(DATE,S_SendTime)<=@TD) AND
      (@OnlyQueded=0 OR (S_Sended=0 AND S_Cancel=0)) and
	  (
	    @SearchText is null or 
		S_Text like N'%'+@SearchText+'%'
	  )

SELECT @OutCount=COUNT(1) FROM @SMSs

SELECT 
	s.S_Id,
	s.S_Mobile,
	s.S_Text,
	s.S_SendTime,
	s.S_SendedTime,
	s.S_Sended,
	s.S_FamilyId,
	s.S_CauserId,
	p.FullName CauserName,
	d.D_Title TypeTitle,
	f.F_Title FamilyTitle
FROM dbo.vi_SMS s
INNER JOIN @SMSs ss
ON ss.id=s.S_Id
LEFT JOIN dbo.Vi_Family f
ON f.F_ID=s.S_FamilyId
left JOIN dbo.Vi_Personnel p
ON p.P_Id=s.S_CauserId
LEFT JOIN dbo.Vi_Data d
ON d.D_Id=s.S_TypeId
ORDER BY ss.rown
OFFSET @PerPage * (@Page - 1) ROWS
FETCH NEXT @PerPage ROWS ONLY
GO
CREATE PROC dbo.usp_SMS_Delete
@Ids VARCHAR(max),
@CauserId BIGINT
AS

DECLARE @SMSIds TABLE(id bigint)

INSERT INTO @SMSIds
(
    id
)
SELECT CONVERT(BIGINT,item) FROM dbo.Split(@Ids,',')

UPDATE s set s.S_Deleted=1,
			 s.S_DeletedBy=@CauserId,
			 s.S_DeletedTime=GETDATE()
	FROM dbo.Tb_Sms s
	INNER JOIN @SMSIds ss
	ON s.S_Id=ss.id