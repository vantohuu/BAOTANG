USE [master]
GO
/****** Object:  Database [BAOTANG]    Script Date: 7/13/2023 11:55:18 AM ******/
CREATE DATABASE [BAOTANG]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BAOTANG', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BAOTANG.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BAOTANG_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BAOTANG_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [BAOTANG] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BAOTANG].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BAOTANG] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BAOTANG] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BAOTANG] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BAOTANG] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BAOTANG] SET ARITHABORT OFF 
GO
ALTER DATABASE [BAOTANG] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BAOTANG] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BAOTANG] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BAOTANG] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BAOTANG] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BAOTANG] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BAOTANG] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BAOTANG] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BAOTANG] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BAOTANG] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BAOTANG] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BAOTANG] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BAOTANG] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BAOTANG] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BAOTANG] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BAOTANG] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BAOTANG] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BAOTANG] SET RECOVERY FULL 
GO
ALTER DATABASE [BAOTANG] SET  MULTI_USER 
GO
ALTER DATABASE [BAOTANG] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BAOTANG] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BAOTANG] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BAOTANG] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BAOTANG] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'BAOTANG', N'ON'
GO
ALTER DATABASE [BAOTANG] SET QUERY_STORE = OFF
GO
USE [BAOTANG]
GO
/****** Object:  User [2]    Script Date: 7/13/2023 11:55:19 AM ******/
CREATE USER [2] FOR LOGIN [HUY] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [1]    Script Date: 7/13/2023 11:55:19 AM ******/
CREATE USER [1] FOR LOGIN [HUU] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [USER]    Script Date: 7/13/2023 11:55:19 AM ******/
CREATE ROLE [USER]
GO
/****** Object:  DatabaseRole [test]    Script Date: 7/13/2023 11:55:19 AM ******/
CREATE ROLE [test]
GO
/****** Object:  DatabaseRole [ADMIN]    Script Date: 7/13/2023 11:55:19 AM ******/
CREATE ROLE [ADMIN]
GO
ALTER ROLE [USER] ADD MEMBER [2]
GO
ALTER ROLE [db_datareader] ADD MEMBER [2]
GO
ALTER ROLE [ADMIN] ADD MEMBER [1]
GO
ALTER ROLE [db_owner] ADD MEMBER [1]
GO
ALTER ROLE [db_datareader] ADD MEMBER [USER]
GO
ALTER ROLE [db_owner] ADD MEMBER [ADMIN]
GO
/****** Object:  UserDefinedFunction [dbo].[KiemtraTonTaiCTTrienLam]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[KiemtraTonTaiCTTrienLam](@id_tl int, @matpnt int)
returns int
as
begin
	if exists(select * from CT_TRIENLAM where ID_TL = @id_tl and MATPNT = @matpnt) return 1
	return 0
end
GO
/****** Object:  UserDefinedFunction [dbo].[KiemTraTonTaiLoaiHinh]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[KiemTraTonTaiLoaiHinh](@ID int)
returns int
as
begin 
	if exists(select MASO from DIEUKHAC_TACTUONG where MASO = @id) return 1
	if exists(select MASO from HOIHOA where MASO = @id) return 2
	if exists(select MASO from LOAIHINHKHAC where MASO = @id) return 3
	return 0
end
GO
/****** Object:  UserDefinedFunction [dbo].[KiemTraTonTaiLoaiSoHuu]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[KiemTraTonTaiLoaiSoHuu](@ID int)
returns int
as
begin 
	if exists(select MASO from SOHUU where MASO = @id) return 1
	if exists(select  MATPNT from DIMUON where MATPNT = @id) return 2
	return 0
end
GO
/****** Object:  UserDefinedFunction [dbo].[LayChuoiInsertLoaiHinh]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[LayChuoiInsertLoaiHinh](@maso int)
returns nvarchar(300)
as
begin
	declare @insertString nvarchar(500) = 'NULL'
    declare @k int  =  dbo.KiemTraTonTaiLoaiHinh(@maso)
	if @k = 1 
	begin
	    declare @madktt varchar(20)
		declare @vatlieudktt nvarchar(50)
		declare @chieucaodktt varchar(20) 
		declare @khoiluongdktt varchar(20)
		declare @phongcachdktt nvarchar(50)
		select @madktt = CONVERT(INT, CONVERT(VARCHAR(20), MASO)), @vatlieudktt = VATLIEU, @chieucaodktt =  CONVERT(INT, CONVERT(VARCHAR(20), CHIEUCAO)),
		 @khoiluongdktt =  CONVERT(INT, CONVERT(VARCHAR(20), KHOILUONG)), @phongcachdktt = PHONGCACH
		from DIEUKHAC_TACTUONG
		where MASO = @maso
		set @insertString = 'insert into DIEUKHAC_TACTUONG(MASO, VATLIEU, CHIEUCAO, KHOILUONG, PHONGCACH) ' +
							'values (' + @madktt + ',N'''+ @vatlieudktt + ''',' + @chieucaodktt + ',' + @khoiluongdktt + ',N''' + @phongcachdktt + ''')'   
	end
	if @k = 2 
	begin
	    declare @mahh varchar(20)
		declare @chatlieuhh nvarchar(50)
		declare @vatlieuhh nvarchar(50)
		declare @truongphaihh nvarchar(50)
		select @mahh =  CONVERT(INT, CONVERT(VARCHAR(20), MASO)), @vatlieuhh = VATLIEU, @chatlieuhh = CHATLIEU, @truongphaihh = TRUONGPHAI
		from HOIHOA
		where MASO = @maso
		set @insertString = 'insert into HOIHOA(MASO, VATLIEU, CHATLIEU, TRUONGPHAI) ' +
							'values (' + @mahh + ',N'''+ @vatlieuhh + ''',' + 'N'''+ @chatlieuhh + ''',' + 'N'''+ @truongphaihh + ''')'    
	end
	if @k = 3 
	begin
	    declare @malhk varchar(20)
		declare @theloailhk nvarchar(50)
		declare @phongcachlhk nvarchar(50)
		select @malhk = CONVERT(INT, CONVERT(VARCHAR(20), MASO)), @theloailhk = THELOAI, @phongcachlhk = PHONGCACH
		from LOAIHINHKHAC
		where MASO = @maso
		set @insertString = 'insert into LOAIHINHKHAC(MASO, THELOAI, PHONGCACH) ' +
							'values (' + @malhk + ',N'''+ @theloailhk + '''' + ',N'''+ @phongcachlhk +  ''')'    
	end

	return @insertString
end
GO
/****** Object:  UserDefinedFunction [dbo].[LayChuoiInsertLoaiSoHuu]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[LayChuoiInsertLoaiSoHuu](@maso int)
returns nvarchar(300)
as
begin
	declare @insertString nvarchar(500) = 'NULL'
    declare @k int  =  dbo.KiemTraTonTaiLoaiSoHuu(@maso)
	if @k = 1 
	begin
	    declare @mash varchar(20)
		declare @ngaysh nvarchar(50)
		declare @tinhtrang varchar(20) 
		declare @trigia varchar(20)
		declare @phongcachdktt nvarchar(50)
		select @mash = CONVERT(INT, CONVERT(VARCHAR(20), MASO)), @tinhtrang = TINHTRANG, @trigia =  CONVERT(int, CONVERT(float,CONVERT(VARCHAR(20), TRIGIA))),
		 @ngaysh =  CONVERT(VARCHAR(20), NGAYSOHUU,101)
		from SOHUU
		where MASO = @maso
		set @insertString = 'insert into SOHUU(MASO, TINHTRANG, TRIGIA, NGAYSOHUU) ' +
							'values (' + @mash + ',N'''+ @tinhtrang + ''',' + @trigia + ',''' + @ngaysh + ''')'   
	end
	if @k = 2 
	begin
	    declare @matpnt varchar(20)
		declare @tenbst nvarchar(50)
		declare @ngaymuon nvarchar(50)
		declare @ngaytra nvarchar(50)
		select @matpnt =  CONVERT(INT, CONVERT(VARCHAR(20), MATPNT)), @tenbst = TENBST, 
			   @ngaymuon =  CONVERT(date, NGAYMUON),
			   @ngaytra =  CONVERT(date, NGAYTRA,101)

		from DIMUON
		where MATPNT = @maso
		set @insertString = 'insert into DIMUON(MATPNT, TENBST, NGAYMUON, NGAYTRA) ' +
							'values (' + @matpnt + ',N'''+ @tenbst + ''',' + ''''+ @ngaymuon + ''',' + ''''+ @ngaytra + ''')'    
	end
	return @insertString


end
GO
/****** Object:  UserDefinedFunction [dbo].[LayMaSo]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[LayMaSo]()
returns int
as
begin 
    declare @maso int = 0
	select @maso = max(MASO) from TPNT
	return @maso + 1
end
GO
/****** Object:  Table [dbo].[TRIENLAM]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRIENLAM](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TEN] [nvarchar](100) NOT NULL,
	[NGAYBATDAU] [date] NOT NULL,
	[NGAYKETTHUC] [date] NOT NULL,
 CONSTRAINT [PK__TRIENLAM__3214EC27241460EC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_TrienLAm]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_TrienLAm]
as
select * from TRIENLAM with(INDEX(IX_TRIENLAM))
GO
/****** Object:  Table [dbo].[BOSUUTAP]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOSUUTAP](
	[TEN] [nvarchar](50) NOT NULL,
	[HINHTHUC] [nvarchar](100) NOT NULL,
	[MOTA] [ntext] NULL,
	[DIACHI] [nvarchar](255) NOT NULL,
	[SODT] [varchar](20) NOT NULL,
	[NGUOIGIAODICH] [nvarchar](50) NULL,
 CONSTRAINT [PK_BOSUUTAP] PRIMARY KEY CLUSTERED 
(
	[TEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_TRIENLAM]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_TRIENLAM](
	[ID_TL] [int] NOT NULL,
	[MATPNT] [int] NOT NULL,
 CONSTRAINT [PK__CT_TRIEN__F6AAAD0757C03E08] PRIMARY KEY CLUSTERED 
(
	[ID_TL] ASC,
	[MATPNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIEUKHAC_TACTUONG]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIEUKHAC_TACTUONG](
	[MASO] [int] NOT NULL,
	[VATLIEU] [nvarchar](255) NOT NULL,
	[CHIEUCAO] [float] NOT NULL,
	[KHOILUONG] [float] NOT NULL,
	[PHONGCACH] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_DIEUKHAC_TACTUONG] PRIMARY KEY CLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIMUON]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIMUON](
	[MATPNT] [int] NOT NULL,
	[TENBST] [nvarchar](50) NOT NULL,
	[NGAYMUON] [date] NOT NULL,
	[NGAYTRA] [date] NOT NULL,
 CONSTRAINT [PK__DIMUON__DC91CAD6ECCF75A2] PRIMARY KEY CLUSTERED 
(
	[MATPNT] ASC,
	[TENBST] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOIHOA]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOIHOA](
	[MASO] [int] NOT NULL,
	[CHATLIEU] [nvarchar](255) NOT NULL,
	[VATLIEU] [nvarchar](255) NOT NULL,
	[TRUONGPHAI] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_HOIHOA] PRIMARY KEY CLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAIHINHKHAC]    Script Date: 7/13/2023 11:55:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIHINHKHAC](
	[MASO] [int] NOT NULL,
	[THELOAI] [nvarchar](50) NOT NULL,
	[PHONGCACH] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_LOAIHINHKHAC] PRIMARY KEY CLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MANV] [int] IDENTITY(1,1) NOT NULL,
	[HO] [nvarchar](50) NULL,
	[TEN] [nvarchar](50) NULL,
	[SOCMND] [varchar](50) NULL,
	[DIACHI] [nvarchar](300) NULL,
	[NGAYSINH] [datetime] NULL,
 CONSTRAINT [PK_NHANVIEN] PRIMARY KEY CLUSTERED 
(
	[MANV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SOHUU]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SOHUU](
	[MASO] [int] NOT NULL,
	[NGAYSOHUU] [date] NOT NULL,
	[TINHTRANG] [nvarchar](100) NOT NULL,
	[TRIGIA] [money] NOT NULL,
 CONSTRAINT [UX_SOHUU] UNIQUE CLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TACGIA]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TACGIA](
	[TEN] [nvarchar](50) NOT NULL,
	[NGAYSINH] [date] NULL,
	[NGAYMAT] [date] NULL,
	[QUOCTICH] [nvarchar](100) NOT NULL,
	[THOIDAI] [nvarchar](255) NOT NULL,
	[PHONGCACHCHINH] [nvarchar](255) NULL,
	[DIENGIAI] [ntext] NULL,
 CONSTRAINT [PK_TACGIA] PRIMARY KEY CLUSTERED 
(
	[TEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAIKHOAN]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOAN](
	[USERNAME] [nchar](20) NOT NULL,
	[PASSWORD] [nchar](10) NOT NULL,
	[TRANGTHAI] [bit] NOT NULL,
 CONSTRAINT [PK_TAIKHOAN] PRIMARY KEY CLUSTERED 
(
	[USERNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TPNT]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TPNT](
	[MASO] [int] NOT NULL,
	[NAMST] [date] NULL,
	[CHUDE] [nvarchar](255) NOT NULL,
	[LOIDIENGIAI] [nvarchar](255) NULL,
	[TENTG] [nvarchar](50) NOT NULL,
	[IDXX] [int] NOT NULL,
 CONSTRAINT [PK__TPNT__60228A33179315E0] PRIMARY KEY CLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XUATXU]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XUATXU](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TENQUOCGIA] [nvarchar](100) NOT NULL,
	[THOIDAI] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK__XUATXU__3214EC274F9D0290] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[BOSUUTAP] ([TEN], [HINHTHUC], [MOTA], [DIACHI], [SODT], [NGUOIGIAODICH]) VALUES (N'Đông', N'Tượng', N'asadasds', N'98 Man Thiện', N'21312312', N'abc')
INSERT [dbo].[BOSUUTAP] ([TEN], [HINHTHUC], [MOTA], [DIACHI], [SODT], [NGUOIGIAODICH]) VALUES (N'Hạ', N'dasdasd', N'dasdasdasd', N'sadsadcccccccccccccccc', N'123123', N'ádsad')
INSERT [dbo].[BOSUUTAP] ([TEN], [HINHTHUC], [MOTA], [DIACHI], [SODT], [NGUOIGIAODICH]) VALUES (N'Thu', N'ádasdasd', N'ádasdasd', N'ádasdasd', N'3123123123', N'ádasdasd')
INSERT [dbo].[BOSUUTAP] ([TEN], [HINHTHUC], [MOTA], [DIACHI], [SODT], [NGUOIGIAODICH]) VALUES (N'Xuân', N'Tranh vẽ', N'abc', N'97 Man Thiện', N'213213', N'abc')
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (1, 1)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (1, 4)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (2, 4)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (9, 5)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (13, 1)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (13, 2)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (15, 3)
INSERT [dbo].[CT_TRIENLAM] ([ID_TL], [MATPNT]) VALUES (16, 1)
INSERT [dbo].[DIEUKHAC_TACTUONG] ([MASO], [VATLIEU], [CHIEUCAO], [KHOILUONG], [PHONGCACH]) VALUES (1, N'Tranh', 100, 200, N'Sơn dầu')
INSERT [dbo].[DIEUKHAC_TACTUONG] ([MASO], [VATLIEU], [CHIEUCAO], [KHOILUONG], [PHONGCACH]) VALUES (2, N'Xi măng', 100, 200, N'Sơn dầu')
INSERT [dbo].[DIEUKHAC_TACTUONG] ([MASO], [VATLIEU], [CHIEUCAO], [KHOILUONG], [PHONGCACH]) VALUES (4, N'Kim loại', 10, 10, N'Đổ khuôn')
INSERT [dbo].[DIMUON] ([MATPNT], [TENBST], [NGAYMUON], [NGAYTRA]) VALUES (2, N'Hạ', CAST(N'2023-06-14' AS Date), CAST(N'2023-06-07' AS Date))
INSERT [dbo].[DIMUON] ([MATPNT], [TENBST], [NGAYMUON], [NGAYTRA]) VALUES (5, N'Xuân', CAST(N'2023-06-16' AS Date), CAST(N'2023-06-26' AS Date))
INSERT [dbo].[HOIHOA] ([MASO], [CHATLIEU], [VATLIEU], [TRUONGPHAI]) VALUES (3, N'NHOOM', N'NHOM', N'NGHE THUAT')
INSERT [dbo].[LOAIHINHKHAC] ([MASO], [THELOAI], [PHONGCACH]) VALUES (5, N'Thơ', N'Lục bát')
SET IDENTITY_INSERT [dbo].[NHANVIEN] ON 

INSERT [dbo].[NHANVIEN] ([MANV], [HO], [TEN], [SOCMND], [DIACHI], [NGAYSINH]) VALUES (1, N'Văn Tố ', N'Hữu', N'215556002', N'Bình Định                                         ', CAST(N'2022-02-02T00:00:00.000' AS DateTime))
INSERT [dbo].[NHANVIEN] ([MANV], [HO], [TEN], [SOCMND], [DIACHI], [NGAYSINH]) VALUES (2, N'Võ Quang', N'Huy', N'215556003', N'Bình Định                                         ', CAST(N'2022-02-02T00:00:00.000' AS DateTime))
INSERT [dbo].[NHANVIEN] ([MANV], [HO], [TEN], [SOCMND], [DIACHI], [NGAYSINH]) VALUES (3, N'Bùi Thanh', N'Tuấn', N'214443222', N'sss123                                                ', CAST(N'2023-07-26T00:00:00.000' AS DateTime))
INSERT [dbo].[NHANVIEN] ([MANV], [HO], [TEN], [SOCMND], [DIACHI], [NGAYSINH]) VALUES (12, N'sadsad', N'ádasdasd', N'123123', N'ádasdasd', CAST(N'2023-07-06T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[NHANVIEN] OFF
INSERT [dbo].[SOHUU] ([MASO], [NGAYSOHUU], [TINHTRANG], [TRIGIA]) VALUES (1, CAST(N'2002-02-02' AS Date), N'Còn zin', 2000222.0000)
INSERT [dbo].[SOHUU] ([MASO], [NGAYSOHUU], [TINHTRANG], [TRIGIA]) VALUES (3, CAST(N'2023-06-15' AS Date), N'DDEPJ', 11.0000)
INSERT [dbo].[SOHUU] ([MASO], [NGAYSOHUU], [TINHTRANG], [TRIGIA]) VALUES (4, CAST(N'2023-06-09' AS Date), N'Đẹp', 20000.0000)
INSERT [dbo].[TACGIA] ([TEN], [NGAYSINH], [NGAYMAT], [QUOCTICH], [THOIDAI], [PHONGCACHCHINH], [DIENGIAI]) VALUES (N'Bà Huyện Thanh Quan', CAST(N'2023-07-04' AS Date), CAST(N'2023-07-28' AS Date), N'Việt nam', N'Trung đại', N'Thơ', N'abc')
INSERT [dbo].[TACGIA] ([TEN], [NGAYSINH], [NGAYMAT], [QUOCTICH], [THOIDAI], [PHONGCACHCHINH], [DIENGIAI]) VALUES (N'Nguyễn Khoa Điềm', CAST(N'1943-04-15' AS Date), NULL, N'Việt Nam', N'Hiện đại', N'Thơ', N'ádsadasdsad')
INSERT [dbo].[TACGIA] ([TEN], [NGAYSINH], [NGAYMAT], [QUOCTICH], [THOIDAI], [PHONGCACHCHINH], [DIENGIAI]) VALUES (N'Tô Hoài', CAST(N'2023-07-03' AS Date), NULL, N'Mỹ', N'Cổ đại', N'Văn Học', N'abc')
INSERT [dbo].[TACGIA] ([TEN], [NGAYSINH], [NGAYMAT], [QUOCTICH], [THOIDAI], [PHONGCACHCHINH], [DIENGIAI]) VALUES (N'Tố Hữu', CAST(N'1920-10-04' AS Date), CAST(N'2002-12-09' AS Date), N'Việt Nam', N'Hiện đại', N'Thơ', NULL)
INSERT [dbo].[TACGIA] ([TEN], [NGAYSINH], [NGAYMAT], [QUOCTICH], [THOIDAI], [PHONGCACHCHINH], [DIENGIAI]) VALUES (N'Xuân Quỳnh', CAST(N'1942-10-06' AS Date), CAST(N'1988-08-29' AS Date), N'Viêt Nam', N'Hiện đại', N'Thơ', N'sad')
INSERT [dbo].[TPNT] ([MASO], [NAMST], [CHUDE], [LOIDIENGIAI], [TENTG], [IDXX]) VALUES (1, CAST(N'2002-01-01' AS Date), N'Nghệ thuật đường phố', N'avc', N'Bà Huyện Thanh Quan', 1)
INSERT [dbo].[TPNT] ([MASO], [NAMST], [CHUDE], [LOIDIENGIAI], [TENTG], [IDXX]) VALUES (2, CAST(N'2023-06-07' AS Date), N'sadasd', N'sadsad', N'Tố Hữu', 3)
INSERT [dbo].[TPNT] ([MASO], [NAMST], [CHUDE], [LOIDIENGIAI], [TENTG], [IDXX]) VALUES (3, CAST(N'2023-06-17' AS Date), N'SADASD', N'ASDASDASD', N'Nguyễn Khoa Điềm', 7)
INSERT [dbo].[TPNT] ([MASO], [NAMST], [CHUDE], [LOIDIENGIAI], [TENTG], [IDXX]) VALUES (4, CAST(N'2020-01-01' AS Date), N'Tình yêu', N'Tình yêu', N'Xuân Quỳnh', 1)
INSERT [dbo].[TPNT] ([MASO], [NAMST], [CHUDE], [LOIDIENGIAI], [TENTG], [IDXX]) VALUES (5, CAST(N'2023-01-01' AS Date), N'Biển đẹp', N'không có', N'Tố Hữu', 4)
SET IDENTITY_INSERT [dbo].[TRIENLAM] ON 

INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (1, N'Triển lãm trưng bày Ngày tết', CAST(N'2022-01-01' AS Date), CAST(N'2022-01-15' AS Date))
INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (2, N'Chào mừng đại hội', CAST(N'2023-06-04' AS Date), CAST(N'2023-06-04' AS Date))
INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (9, N'Chào mừng ngày giải phóng đất nước', CAST(N'2023-06-05' AS Date), CAST(N'2023-07-07' AS Date))
INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (13, N'Trưng bày ngày quốc tế thiếu nhi', CAST(N'2023-06-13' AS Date), CAST(N'2023-06-23' AS Date))
INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (15, N'Chào mừng ngày phụ nữ Việt Nam', CAST(N'2023-07-12' AS Date), CAST(N'2023-07-27' AS Date))
INSERT [dbo].[TRIENLAM] ([ID], [TEN], [NGAYBATDAU], [NGAYKETTHUC]) VALUES (16, N'Vì một thế giới hòa bình', CAST(N'2023-07-13' AS Date), CAST(N'2023-07-21' AS Date))
SET IDENTITY_INSERT [dbo].[TRIENLAM] OFF
SET IDENTITY_INSERT [dbo].[XUATXU] ON 

INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (1, N'Việt Nam', N'Hiện đại')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (2, N'Trung Quốc', N'Cổ đại')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (3, N'Mỹ', N'Hiện đại')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (4, N'Hi lạp', N'La mã')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (7, N'Nhật Bản', N'Trung đại')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (10, N'Trung quốc', N'Hiện đại')
INSERT [dbo].[XUATXU] ([ID], [TENQUOCGIA], [THOIDAI]) VALUES (12, N'Campuchia', N'Kherme')
SET IDENTITY_INSERT [dbo].[XUATXU] OFF
/****** Object:  Index [IX_DIEUKHAC_TACTUONG]    Script Date: 7/13/2023 11:55:20 AM ******/
ALTER TABLE [dbo].[DIEUKHAC_TACTUONG] ADD  CONSTRAINT [IX_DIEUKHAC_TACTUONG] UNIQUE NONCLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UK_HOIHOA]    Script Date: 7/13/2023 11:55:20 AM ******/
ALTER TABLE [dbo].[HOIHOA] ADD  CONSTRAINT [UK_HOIHOA] UNIQUE NONCLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UK_LOAIHINHKHAC]    Script Date: 7/13/2023 11:55:20 AM ******/
ALTER TABLE [dbo].[LOAIHINHKHAC] ADD  CONSTRAINT [UK_LOAIHINHKHAC] UNIQUE NONCLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_SOHUU]    Script Date: 7/13/2023 11:55:20 AM ******/
ALTER TABLE [dbo].[SOHUU] ADD  CONSTRAINT [PK_SOHUU] PRIMARY KEY NONCLUSTERED 
(
	[MASO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TRIENLAM]    Script Date: 7/13/2023 11:55:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_TRIENLAM] ON [dbo].[TRIENLAM]
(
	[TEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CT_TRIENLAM]  WITH CHECK ADD  CONSTRAINT [FK__CT_TRIENL__ID_TL__38996AB5] FOREIGN KEY([ID_TL])
REFERENCES [dbo].[TRIENLAM] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CT_TRIENLAM] CHECK CONSTRAINT [FK__CT_TRIENL__ID_TL__38996AB5]
GO
ALTER TABLE [dbo].[CT_TRIENLAM]  WITH CHECK ADD  CONSTRAINT [FK_CT_TRIENLAM_TPNT] FOREIGN KEY([MATPNT])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CT_TRIENLAM] CHECK CONSTRAINT [FK_CT_TRIENLAM_TPNT]
GO
ALTER TABLE [dbo].[DIEUKHAC_TACTUONG]  WITH CHECK ADD  CONSTRAINT [FK_DIEUKHAC_TACTUONG_TPNT] FOREIGN KEY([MASO])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DIEUKHAC_TACTUONG] CHECK CONSTRAINT [FK_DIEUKHAC_TACTUONG_TPNT]
GO
ALTER TABLE [dbo].[DIMUON]  WITH CHECK ADD  CONSTRAINT [FK_DIMUON_BOSUUTAP] FOREIGN KEY([TENBST])
REFERENCES [dbo].[BOSUUTAP] ([TEN])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DIMUON] CHECK CONSTRAINT [FK_DIMUON_BOSUUTAP]
GO
ALTER TABLE [dbo].[DIMUON]  WITH CHECK ADD  CONSTRAINT [FK_DIMUON_TPNT] FOREIGN KEY([MATPNT])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DIMUON] CHECK CONSTRAINT [FK_DIMUON_TPNT]
GO
ALTER TABLE [dbo].[HOIHOA]  WITH CHECK ADD  CONSTRAINT [FK_HOIHOA_TPNT] FOREIGN KEY([MASO])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HOIHOA] CHECK CONSTRAINT [FK_HOIHOA_TPNT]
GO
ALTER TABLE [dbo].[LOAIHINHKHAC]  WITH CHECK ADD  CONSTRAINT [FK_LOAIHINHKHAC_TPNT] FOREIGN KEY([MASO])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LOAIHINHKHAC] CHECK CONSTRAINT [FK_LOAIHINHKHAC_TPNT]
GO
ALTER TABLE [dbo].[SOHUU]  WITH CHECK ADD  CONSTRAINT [FK_SOHUU_TPNT] FOREIGN KEY([MASO])
REFERENCES [dbo].[TPNT] ([MASO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SOHUU] CHECK CONSTRAINT [FK_SOHUU_TPNT]
GO
ALTER TABLE [dbo].[TPNT]  WITH CHECK ADD  CONSTRAINT [FK_TPNT_TACGIA] FOREIGN KEY([TENTG])
REFERENCES [dbo].[TACGIA] ([TEN])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TPNT] CHECK CONSTRAINT [FK_TPNT_TACGIA]
GO
ALTER TABLE [dbo].[TPNT]  WITH CHECK ADD  CONSTRAINT [FK_TPNT_XUATXU] FOREIGN KEY([IDXX])
REFERENCES [dbo].[XUATXU] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TPNT] CHECK CONSTRAINT [FK_TPNT_XUATXU]
GO
/****** Object:  StoredProcedure [dbo].[BaoCaoTacGia]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[BaoCaoTacGia]
as
begin
select TEN,CONVERT(VARCHAR, NGAYSINH, 103) AS NGAYSINH,CONVERT(VARCHAR, NGAYMAT, 103) AS NGAYMAT , QUOCTICH, THOIDAI, PHONGCACHCHINH, DIENGIAI from TACGIA
end
GO
/****** Object:  StoredProcedure [dbo].[BaoCaoTPNT]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[BaoCaoTPNT]  
as
begin
select TPNT.MASO, CHUDE, LOIDIENGIAI,TENTG, year(NAMST) as NAMST, CONCAT(XUATXU.TENQUOCGIA , '-', XUATXU.THOIDAI) as XUATXU,
CASE
    WHEN SOHUU.MASO is not null THEN N'Sở hữu'
    WHEN DIMUON.MATPNT is not null THEN N'Bộ sưu tập'
END as LOAISOHUU
,
CASE
    WHEN SOHUU.MASO is not null THEN CONCAT(N'Ngày sở hữu: ',NGAYSOHUU, N', tình trạng: ', TINHTRANG, N', trị giá: ',TRIGIA)
    WHEN DIMUON.MATPNT is not null THEN CONCAT(N'Tên bộ sưu tập: ', TENBST, N', ngày mượn: ', NGAYMUON, N', ngày trả: ', NGAYTRA)
END as CTLOAISOHUU
,
CASE
    WHEN DIEUKHAC_TACTUONG.MASO is not NULL THEN N'Điêu khắc - Tạc tượng'
    WHEN HOIHOA.MASO is not NULL THEN N'Hội họa'
	WHEN LOAIHINHKHAC.MASO is not NULL THEN N'Loại hình khác'
END as LOAIHINH
,
CASE
    WHEN DIEUKHAC_TACTUONG.MASO is not NULL THEN CONCAT(N'Vật liệu: ', DIEUKHAC_TACTUONG.VATLIEU, N', chiều cao: ', DIEUKHAC_TACTUONG.CHIEUCAO,
	 N', khối lượng: ', DIEUKHAC_TACTUONG.KHOILUONG, N', phong cách: ', DIEUKHAC_TACTUONG.PHONGCACH)
    WHEN HOIHOA.MASO is not NULL THEN CONCAT(N'Chất liệu: ', HOIHOA.CHATLIEU, N', vật liệu: ', 
	HOIHOA.VATLIEU, N', trường phái: ', HOIHOA.TRUONGPHAI)

	WHEN LOAIHINHKHAC.MASO is not NULL THEN CONCAT(N'Thể loại: ', LOAIHINHKHAC.THELOAI, N', phong cách: ', LOAIHINHKHAC.PHONGCACH)
END as CTLOAIHINH
from  TPNT
LEFT JOIN XUATXU
ON XUATXU.ID = TPNT.IDXX
LEFT JOIN SOHUU
ON SOHUU.MASO = TPNT.MASO
LEFT JOIN DIMUON
ON DIMUON.MATPNT = TPNT.MASO
LEFT JOIN DIEUKHAC_TACTUONG
ON DIEUKHAC_TACTUONG.MASO = TPNT.MASO
LEFT JOIN HOIHOA
ON HOIHOA.MASO = TPNT.MASO
LEFT JOIN LOAIHINHKHAC
ON LOAIHINHKHAC.MASO = TPNT.MASO
end

GO
/****** Object:  StoredProcedure [dbo].[BaoCaoTrienLam]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[BaoCaoTrienLam](@tungay Datetime, @denngay Datetime)
as
begin 
select * from vw_TrienLAm
where NGAYBATDAU > @tungay and NGAYKETTHUC < @denngay
end
GO
/****** Object:  StoredProcedure [dbo].[CheckLogin]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CheckLogin] @loginname nvarchar(30)
AS
BEGIN
	DECLARE @tontai int  = 0
	if exists(select * from sys.sysusers where name  = @loginname) set @tontai = 1
	select @tontai
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Alter_Account]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_Alter_Account] (@loginnameold nvarchar(30), @loginname nvarchar(30), @password nvarchar(30))
as
begin
	declare @query nvarchar(200)
	set @query = 'alter login [' + @loginnameold +'] with  name = [' + @loginname + ']'  
	+ ' , password = ''' + @password  +   '''' 
	print(@query)
	exec(@query)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Backup]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Backup] @filename nvarchar(max)
AS
BEGIN
	BACKUP DATABASE [BAOTANG]
	TO DISK = @filename
	WITH INIT
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Check_DangNhap_Login]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Check_DangNhap_Login] (@loginname nvarchar(30))
as
begin
	if not exists(select * from sys.syslogins where loginname = @loginname) return 1
	declare @username nvarchar(100)
	SELECT @username = NAME FROM SYS.sysusers WHERE SID = SUSER_SID(@loginname)
	if ISNUMERIC(@username) = 0 return 1
	return 0
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Check_Exists_Id_Char]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_Check_Exists_Id_Char](@tablename nvarchar(10),@column nvarchar(20), @checkchar nvarchar(20))
as
begin
	declare @sql nvarchar(300)
	
	set @sql = 'declare @count int = 0 '
	         + 'if exists(select * from '+@tablename+'  where ' + @column +'= ''' +  @checkchar + ''') set @count = 1  '+ 
			 + ' select @count'
	print(@sql)
    exec(@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Check_Exists_Login]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Check_Exists_Login] (@loginname nvarchar(30))
as
begin
	if exists(select * from sys.syslogins where loginname = @loginname) return 1
	return 0
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Check_Exists_TenTG_Char]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_Check_Exists_TenTG_Char](@tablename nvarchar(10),@column nvarchar(20), @checkchar nvarchar(50))
as
begin
	declare @sql nvarchar(300)
	
	set @sql = 'declare @count int = 0 '
	         + 'if exists(select * from '+@tablename+'  where ' + @column +'= N''' +  @checkchar + ''') set @count = 1  '+ 
			 + ' select @count'
	print(@sql)
    exec(@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Create_Account]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Create_Account] (@loginname nvarchar(30), @password nvarchar(30), @rolename nvarchar(20), @manv int)
as
begin
    declare @query nvarchar(400)

	set @query = 
	 
	+ '  create login [' + @loginname +'] with password = ''' + @password  +   '''' 
	+ '  create user [' + cast(@manv as nvarchar(5)) +'] for login ' + @loginname
	+ '  alter role [' + @rolename + '] add member [' + cast(@manv as nvarchar(5)) + ']'

	print(@query)
	exec(@query)

	if(@rolename = 'ADMIN') 
	begin
		set @query = 
		+ '  alter server role  [securityadmin]  add member [' + @loginname +']'
		+ '  alter server role  [processadmin]  add member [' + @loginname +']'

		print(@query)
		exec(@query)
	end

	
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Drop_Account]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Drop_Account] (@loginname nvarchar(30), @rolename nvarchar(20), @manv int)
as
begin

	declare @query nvarchar(400)
	
	DECLARE @session_id int = -1;
	select @session_id = session_id from sys.dm_exec_sessions
	where  login_name = @loginname
	select @session_id
	if ( @session_id != -1)
	begin
		DECLARE @sql NVARCHAR(MAX) = 'KILL ' + + CONVERT(VARCHAR(11), @session_id) + N';'
		EXEC sys.sp_executesql @sql;
	end;

	if(@rolename = 'ADMIN') 
	begin
		set @query = 
		+ '  alter server role  [securityadmin]  drop member [' + @loginname +']'
	    + '  alter server role  [processadmin]  drop member [' + @loginname +']'

		print(@query)
		exec(@query)

	end

	set @query = ' USE [BAOTANG] exec sp_droprolemember ['+ @rolename + '] , [' +  cast(@manv as nvarchar(5)) +']'  
	+ ' USE [BAOTANG]   drop user [' + cast(@manv as nvarchar(5)) +']'
	+ ' USE [BAOTANG]   drop login [' + @loginname + ']'
	print(@query)
	exec(@query)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Lay_Thong_Tin_NV_Tu_Login]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_Lay_Thong_Tin_NV_Tu_Login]
@TENLOGIN NVARCHAR(20)
AS
DECLARE @UID INT
DECLARE @MANV INT
SELECT @UID = uid, @MANV = NAME FROM SYS.sysusers
  WHERE SID = SUSER_SID(@TENLOGIN)

SELECT MANV = @MANV,
       HOTEN = (SELECT HO + ' ' +TEN FROM NhanVien WHERE MANV = @MANV),
	   TENNHOM = NAME 
	FROM SYS.sysusers
	WHERE uid = (SELECT groupuid FROM SYS.sysmembers WHERE memberuid = @UID)

GO
/****** Object:  StoredProcedure [dbo].[sp_Restore]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_Restore] @filename nvarchar(max)
AS
BEGIN
	-- Restore backup CSDL
	ALTER DATABASE [BAOTANG] 
	SET OFFLINE WITH ROLLBACK IMMEDIATE
	-- Restore backup CSDL
	RESTORE DATABASE [BAOTANG] FROM DISK = @filename WITH REPLACE

	ALTER DATABASE [BAOTANG] 
	SET ONLINE
END
GO
/****** Object:  StoredProcedure [dbo].[XoaLienQuanTPNT]    Script Date: 7/13/2023 11:55:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[XoaLienQuanTPNT] @maso int
as
begin
	begin try
		begin tran
		delete from DIEUKHAC_TACTUONG where MASO = @maso
	    delete from HOIHOA where MASO = @maso
		delete from LOAIHINHKHAC where MASO = @maso
		delete from SOHUU where MASO = @maso
		delete from DIMUON where MATPNT = @maso
		commit tran
	end try
	begin catch
	    declare @err nvarchar(400)
		select @err = ERROR_MESSAGE()
		rollback tran
		RAISERROR ('Lỗi xóa liên quan. %s' , 16,1, @err);
	end catch 
end
GO
USE [master]
GO
ALTER DATABASE [BAOTANG] SET  READ_WRITE 
GO
