USE [MainstageAuth]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17/03/2025 17:29:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
DROP TABLE [dbo].[Users]
GO
/****** Object:  Table [dbo].[TempUsers]    Script Date: 17/03/2025 17:29:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUsers]') AND type in (N'U'))
DROP TABLE [dbo].[TempUsers]
GO
/****** Object:  Table [dbo].[RefreshTokens]    Script Date: 17/03/2025 17:29:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshTokens]') AND type in (N'U'))
DROP TABLE [dbo].[RefreshTokens]
GO
/****** Object:  User [mainstageauth]    Script Date: 17/03/2025 17:29:06 ******/
DROP USER [mainstageauth]
GO
USE [master]
GO
/****** Object:  Database [MainstageAuth]    Script Date: 17/03/2025 17:29:06 ******/
DROP DATABASE [MainstageAuth]
GO
/****** Object:  Database [MainstageAuth]    Script Date: 17/03/2025 17:29:06 ******/
CREATE DATABASE [MainstageAuth]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MainstageAuth', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MainstageAuth.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MainstageAuth_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MainstageAuth_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MainstageAuth] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MainstageAuth].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MainstageAuth] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MainstageAuth] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MainstageAuth] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MainstageAuth] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MainstageAuth] SET ARITHABORT OFF 
GO
ALTER DATABASE [MainstageAuth] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MainstageAuth] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MainstageAuth] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MainstageAuth] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MainstageAuth] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MainstageAuth] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MainstageAuth] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MainstageAuth] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MainstageAuth] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MainstageAuth] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MainstageAuth] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MainstageAuth] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MainstageAuth] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MainstageAuth] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MainstageAuth] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MainstageAuth] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MainstageAuth] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MainstageAuth] SET RECOVERY FULL 
GO
ALTER DATABASE [MainstageAuth] SET  MULTI_USER 
GO
ALTER DATABASE [MainstageAuth] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MainstageAuth] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MainstageAuth] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MainstageAuth] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MainstageAuth] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MainstageAuth] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MainstageAuth', N'ON'
GO
ALTER DATABASE [MainstageAuth] SET QUERY_STORE = ON
GO
ALTER DATABASE [MainstageAuth] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MainstageAuth]
GO
/****** Object:  User [mainstageauth]    Script Date: 17/03/2025 17:29:06 ******/
CREATE USER [mainstageauth] FOR LOGIN [mainstageauth] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [mainstageauth]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mainstageauth]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [mainstageauth]
GO
/****** Object:  Table [dbo].[RefreshTokens]    Script Date: 17/03/2025 17:29:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RefreshTokens](
	[UserId] [nvarchar](50) NOT NULL,
	[Token] [nvarchar](max) NOT NULL,
	[Expires] [datetime] NOT NULL,
 CONSTRAINT [PK_RefreshTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TempUsers]    Script Date: 17/03/2025 17:29:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempUsers](
	[Id] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Token] [nvarchar](200) NOT NULL,
	[TokenExpirationDate] [datetime] NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TempUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17/03/2025 17:29:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[RefreshTokens] ([UserId], [Token], [Expires]) VALUES (N'BronstigeBarry', N'awpUjW1Kl8jSoE7V10iJrt54G2FiK6gS0m89ru964Vo=', CAST(N'2025-03-03T09:54:20.347' AS DateTime))
INSERT [dbo].[RefreshTokens] ([UserId], [Token], [Expires]) VALUES (N'Timo', N'viujRsL3285LXE6OSypJIUk+zW2W0zvZxCCeZ3AUvKw=', CAST(N'2025-03-14T12:18:02.053' AS DateTime))
INSERT [dbo].[RefreshTokens] ([UserId], [Token], [Expires]) VALUES (N'VettigeSwa', N'5bDw+1QW6NBK7ml7ZTBaOsc/HJa4IvpVec1kIznB30M=', CAST(N'2025-03-14T12:17:53.430' AS DateTime))
INSERT [dbo].[RefreshTokens] ([UserId], [Token], [Expires]) VALUES (N'ZatteLeo', N'CrHG18UlNXFVq/zbNzwMMmZWHuXDNL7IREJKa9q5sNI=', CAST(N'2025-03-03T09:54:13.967' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Password], [Email], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'BronstigeBarry', N'AQAAAAEAACcQAAAAEETr82ESPxYZWxmmydUyGxFqmJ2l5KEwU/wivFfT8c+b/xuus/8PUsZc8wqdyPWlmw==', N'mainstagethe.game@gmail.com', CAST(N'2025-02-19T11:57:44.187' AS DateTime), N'BronstigeBarry', CAST(N'2025-02-19T11:57:44.187' AS DateTime), N'BronstigeBarry')
INSERT [dbo].[Users] ([Id], [Password], [Email], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'Timo', N'AQAAAAEAACcQAAAAEM+j1j9a6QSUGN16Kf139Qci8lxYnn9X8NUJrqaQGmcd3g0o+oCjY24RICcKXYAqWw==', N'timothy.vandiependael@gmail.com', CAST(N'2025-01-21T12:40:28.387' AS DateTime), N'Timo', CAST(N'2025-01-21T12:40:28.387' AS DateTime), N'Timo')
INSERT [dbo].[Users] ([Id], [Password], [Email], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'VettigeSwa', N'AQAAAAEAACcQAAAAEBm/tgeflFOFSiBYhyGraAkJ4of9PU+8j76b5snKM3cCh3yZOnhjHRG5nsOO5jcMAA==', N'ma.instagethegame@gmail.com', CAST(N'2025-02-19T11:56:03.007' AS DateTime), N'VettigeSwa', CAST(N'2025-02-19T11:56:03.007' AS DateTime), N'VettigeSwa')
INSERT [dbo].[Users] ([Id], [Password], [Email], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'ZatteLeo', N'AQAAAAEAACcQAAAAEJ5dADM3OLEb27dumfCRqoNif36sNWTBGEl1LTXUrQ5FoH9eOeuWrH0hx6XKF18yzQ==', N'm.ainstagethegame@gmail.com', CAST(N'2025-02-19T11:56:48.103' AS DateTime), N'ZatteLeo', CAST(N'2025-02-19T11:56:48.103' AS DateTime), N'ZatteLeo')
GO
USE [master]
GO
ALTER DATABASE [MainstageAuth] SET  READ_WRITE 
GO
