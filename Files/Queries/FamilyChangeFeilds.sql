ALTER TABLE	[dbo].[Tb_Family] ADD F_MotherBirthDate VARCHAR(10)
go
ALTER TABLE	[dbo].[Tb_Family] ADD F_FatherBirthDate VARCHAR(10)
go
ALTER TABLE	[dbo].[Tb_Family] ADD F_InviteTypeId bigint
GO
ALTER VIEW [dbo].[Vi_Family]
AS
SELECT	F_Id,
        F_Title,
        F_FatherName,
        F_FatherLName,
        F_MotherName,
        F_MotherLName,
        F_FatherMobile,
        F_MotherMobile,
        F_CityId,
        F_StateId,
        F_HomeAddress,
        F_Archive,
        F_MotherSituation,
        F_FatherSituation,
        F_Phone,
        F_Desc,
        F_InviteByCode,
        F_Causer,
        F_CreationTime,
        F_MarriageDate,
		(F_FatherName+' '+F_FatherLName) FatherFullName,
		(F_MotherName+' '+F_MotherLName) MotherFullName,
		F_MotherBirthDate,
		F_FatherBirthDate,
		F_InviteTypeId
FROM dbo.Tb_Family
WHERE F_Deleted=0
GO
create PROC [dbo].[usp_Family_Add_14031018]
@Title NVARCHAR(1001),
@FatherName NVARCHAR(110),
@FatherLName NVARCHAR(110),
@MotherName NVARCHAR(110),
@MotherLName NVARCHAR(110),
@MotherMobile VARCHAR(14),
@FatherMobile VARCHAR(14),
@CityId BIGINT,
@StateId BIGINT,
@HomeAddress NVARCHAR(1001),
@Archive BIT,
@MotherSit BIGINT,
@FatherSit BIGINT,
@Phone VARCHAR(14),
@Desc NVARCHAR(4000),
@MarriageDate VARCHAR(10),
@CauserId BIGINT,
@Message NVARCHAR(1001) OUT,
@HasError INT OUT,
@RersultId BIGINT OUT,
@MotherBirthDate VARCHAR(10),
@FatherBirthDate VARCHAR(10),
@InviteTypeId bigint
AS
BEGIN TRY
	
	IF @MotherMobile IS NOT NULL AND LEN(@MotherMobile)>10 and EXISTS(SELECT 1 FROM [dbo].[vi_Family] 
				WHERE F_MotherMobile=@MotherMobile OR
					  F_FatherMobile=@MotherMobile)
		BEGIN
			SET @Message=N'‘„«—Â Â„—«Â „«œ— ﬁ»·« À»  ‘œÂ «” '
			SET @HasError=1
			RETURN 0
        END

	IF @FatherMobile IS NOT NULL AND LEN(@FatherMobile)>10 and EXISTS(SELECT 1 FROM [dbo].[vi_Family] 
				WHERE F_MotherMobile=@FatherMobile OR
					  F_FatherMobile=@FatherMobile)
		BEGIN
			SET @Message=N'‘„«—Â Â„—«Â Åœ— ﬁ»·« À»  ‘œÂ «” '
			SET @HasError=1
			RETURN 0
        END

	INSERT INTO dbo.Tb_Family
	(
	    F_Title,
	    F_FatherName,
	    F_FatherLName,
	    F_MotherName,
	    F_MotherLName,
	    F_FatherMobile,
	    F_MotherMobile,
	    F_CityId,
	    F_StateId,
	    F_HomeAddress,
	    F_Archive,
	    F_MotherSituation,
	    F_FatherSituation,
	    F_Phone,
	    F_Desc,
	    F_Causer,
	    F_CreationTime,
	    F_MarriageDate,
		F_MotherBirthDate,
		F_FatherBirthDate,
		F_InviteTypeId
	)
	VALUES
	(   @Title,       -- F_Title - nvarchar(1001)
	    @FatherName,       -- F_FatherName - nvarchar(110)
	    @FatherLName,       -- F_FatherLName - nvarchar(110)
	    @MotherName,       -- F_MotherName - nvarchar(110)
	    @MotherLName,       -- F_MotherLName - nvarchar(110)
	    @FatherMobile,        -- F_FatherMobile - varchar(14)
	    @MotherMobile,        -- F_MotherMobile - varchar(14)
	    @CityId,         -- F_CityId - bigint
	    @StateId,         -- F_StateId - bigint
	    @HomeAddress,       -- F_HomeAddress - nvarchar(1001)
	    @Archive,      -- F_Archive - bit
	    @MotherSit,         -- F_MotherSituation - bigint
	    @FatherSit,       -- F_FatherSituation - nchar(10)
	    @Phone,        -- F_Phone - varchar(14)
	    @Desc,       -- F_Desc - nvarchar(4000)
	    @CauserId,         -- F_Causer - bigint
	    GETDATE(), -- F_CreationTime - datetime
	    @MarriageDate,         -- F_MarriageDate - varchar(10)
		@MotherBirthDate,
		@FatherBirthDate,
		@InviteTypeId

	    )
	SET @RersultId=SCOPE_IDENTITY()
	SET @HasError=0
	RETURN 1
END TRY	
BEGIN CATCH
	SET @Message=ERROR_MESSAGE()
	DECLARE @ProcName NVARCHAR(1001)=OBJECT_NAME(@@PROCID)
	EXEC dbo.usp_ErrorAdd @ProcName,@Message
	SET @HasError=1
	RETURN 0
END CATCH
GO
create PROC [dbo].[usp_Family_Edit_14031018]
@Id BIGINT,
@Title NVARCHAR(1001),
@FatherName NVARCHAR(110),
@FatherLName NVARCHAR(110),
@MotherName NVARCHAR(110),
@MotherLName NVARCHAR(110),
@MotherMobile VARCHAR(14),
@FatherMobile VARCHAR(14),
@CityId BIGINT,
@StateId BIGINT,
@HomeAddress NVARCHAR(1001),
@Archive BIT,
@MotherSit BIGINT,
@FatherSit BIGINT,
@Phone VARCHAR(14),
@Desc NVARCHAR(4000),
@MarriageDate VARCHAR(10),
@CauserId BIGINT,
@Message NVARCHAR(1001) OUT,
@HasError INT OUT,
@MotherBirthDate VARCHAR(10),
@FatherBirthDate VARCHAR(10),
@InviteTypeId bigint
AS
BEGIN TRY
	
	IF @MotherMobile IS NOT NULL AND LEN(@MotherMobile)>10 and EXISTS(SELECT 1 FROM [dbo].[vi_Family] 
				WHERE F_ID!=@ID and (F_MotherMobile=@MotherMobile OR
					  F_FatherMobile=@MotherMobile))
		BEGIN
			SET @Message=N'‘„«—Â Â„—«Â „«œ— ﬁ»·« À»  ‘œÂ «” '
			SET @HasError=1
			RETURN 0
        END

	IF @FatherMobile IS NOT NULL AND LEN(@FatherMobile)>10 and EXISTS(SELECT 1 FROM [dbo].[vi_Family] 
				WHERE F_ID!=@ID and (F_MotherMobile=@FatherMobile OR
					  F_FatherMobile=@FatherMobile)
					 )
		BEGIN
			SET @Message=N'‘„«—Â Â„—«Â Åœ— ﬁ»·« À»  ‘œÂ «” '
			SET @HasError=1
			RETURN 0
        END

	UPDATE dbo.Tb_Family
		SET F_Title=@Title,
			F_FatherLName=@FatherLName,
			F_FatherName=@FatherName,
			F_MotherName=@MotherName,
			F_MotherLName=@MotherLName,
			F_FatherMobile=@FatherMobile,
			F_MotherMobile=@MotherMobile,
			F_CityId=@CityId,
			F_StateId=@StateId,
			F_HomeAddress=@HomeAddress,
			F_Archive=@Archive,
			F_Phone=@Phone,
			F_Desc=@Desc,
			F_MarriageDate=@MarriageDate,
			F_MotherBirthDate=@MotherBirthDate,
			F_FatherBirthDate=@FatherBirthDate,
			F_InviteTypeId=@InviteTypeId
	WHERE F_ID=@Id

	SET @HasError=0
	RETURN 1
END TRY	
BEGIN CATCH
	SET @Message=ERROR_MESSAGE()
	DECLARE @ProcName NVARCHAR(1001)=OBJECT_NAME(@@PROCID)
	EXEC dbo.usp_ErrorAdd @ProcName,@Message
	SET @HasError=1
	RETURN 0
END CATCH
GO
ALTER PROC [dbo].[usp_Family_Select_By_Id]
@Id BIGINT
AS
SELECT 
    F_Title,
    F_FatherName,
    F_FatherLName,
    F_MotherName,
    F_MotherLName,
    F_FatherMobile,
    F_MotherMobile,
    F_CityId,
    F_StateId,
    F_HomeAddress,
    F_Archive,
    F_MotherSituation,
    F_FatherSituation,
    F_Phone,
    F_Desc,
    F_InviteByCode,
    F_Causer,
    F_CreationTime,
    F_MarriageDate,
	d.D_Title CityTitle,
	s.D_Title StateTitle,
	p.FullName CauserName,
	F_MotherBirthDate,
	F_FatherBirthDate,
	F_InviteTypeId
FROM dbo.Vi_Family f
LEFT JOIN [dbo].[Vi_Personnel] p
ON p.P_ID=f.F_Causer
LEFT JOIN [dbo].[Vi_Data] d
ON d.D_ID=f.F_CityId
LEFT JOIN [dbo].[Vi_Data] s
ON s.D_ID=f.F_StateId
WHERE F_Id=@Id