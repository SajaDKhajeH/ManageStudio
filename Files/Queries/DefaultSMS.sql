if not exists(select 1 from dbo.Tb_Data where D_ID=1001)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					1001,
					N'اولین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end
go
if not exists(select 1 from dbo.Tb_Data where D_ID=1000)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					1000,
					N'دومین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=999)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					999,
					N'سومین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=998)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					998,
					N'چهارمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=997)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					997,
					N'پنجمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=996)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					996,
					N'ششمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=995)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					995,
					N'هفتمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=994)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					994,
					N'هشتمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=993)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					993,
					N'نهمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=992)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					992,
					N'دهمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=991)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					991,
					N'یازدهمین ماهگرد فرزند',
					0,
					7,
					1,
					0,
					N'سلام {{عنوان خانواده}} عزیز
چند روز دیگه {{ماهگرد چندم}} ماهگرد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}-{{ماهگرد چندم}}'
				)
		set identity_insert dbo.tb_Data off
	end	
go
if not exists(select 1 from dbo.Tb_Data where D_ID=990)
	begin
		set identity_insert dbo.tb_Data on
			insert into dbo.Tb_Data
				(
					D_Id,
					D_Title,
					D_Active,
					D_TypeId,
					D_Systematic,
					D_Deleted,
					D_DefaultSMSText,
					D_CauserId,
					D_CreationTime,
					D_SmsKeys
				)
			values
				(
					990,
					N'سالگرد تولد فرزند',
					0,
					7,
					1,
					0,
					N'
سلام {{عنوان خانواده}} عزیز
چند روز دیگه سالگرد تولد {{نام فرزند}} جان هست.
خوشحال میشیم این لحظات زیبارو در کنار ما باشین تا خاطرات خوبی واستون بسازیم
استادیو کودک',
					1,
					GETDATE(),
					N'{{عنوان خانواده}}-{{نام فرزند}}'
				)
		set identity_insert dbo.tb_Data off
	end	