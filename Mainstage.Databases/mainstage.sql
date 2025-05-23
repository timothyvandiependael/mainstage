USE [Mainstage]
GO
/****** Object:  Table [dbo].[Tiles]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tiles]') AND type in (N'U'))
DROP TABLE [dbo].[Tiles]
GO
/****** Object:  Table [dbo].[Players]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Players]') AND type in (N'U'))
DROP TABLE [dbo].[Players]
GO
/****** Object:  Table [dbo].[Games]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Games]') AND type in (N'U'))
DROP TABLE [dbo].[Games]
GO
/****** Object:  Table [dbo].[GamePlayers]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GamePlayers]') AND type in (N'U'))
DROP TABLE [dbo].[GamePlayers]
GO
/****** Object:  Table [dbo].[GamePlayerCards]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GamePlayerCards]') AND type in (N'U'))
DROP TABLE [dbo].[GamePlayerCards]
GO
/****** Object:  Table [dbo].[GameOptions]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameOptions]') AND type in (N'U'))
DROP TABLE [dbo].[GameOptions]
GO
/****** Object:  Table [dbo].[GameCards]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameCards]') AND type in (N'U'))
DROP TABLE [dbo].[GameCards]
GO
/****** Object:  Table [dbo].[GameActions]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameActions]') AND type in (N'U'))
DROP TABLE [dbo].[GameActions]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatMessages]') AND type in (N'U'))
DROP TABLE [dbo].[ChatMessages]
GO
/****** Object:  Table [dbo].[Cards]    Script Date: 17/03/2025 17:28:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cards]') AND type in (N'U'))
DROP TABLE [dbo].[Cards]
GO
/****** Object:  User [mainstage]    Script Date: 17/03/2025 17:28:05 ******/
DROP USER [mainstage]
GO
USE [master]
GO
/****** Object:  Database [Mainstage]    Script Date: 17/03/2025 17:28:05 ******/
DROP DATABASE [Mainstage]
GO
/****** Object:  Database [Mainstage]    Script Date: 17/03/2025 17:28:05 ******/
CREATE DATABASE [Mainstage]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Mainstage', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Mainstage.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Mainstage_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Mainstage_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Mainstage] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Mainstage].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Mainstage] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Mainstage] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Mainstage] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Mainstage] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Mainstage] SET ARITHABORT OFF 
GO
ALTER DATABASE [Mainstage] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Mainstage] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Mainstage] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Mainstage] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Mainstage] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Mainstage] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Mainstage] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Mainstage] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Mainstage] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Mainstage] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Mainstage] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Mainstage] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Mainstage] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Mainstage] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Mainstage] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Mainstage] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Mainstage] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Mainstage] SET RECOVERY FULL 
GO
ALTER DATABASE [Mainstage] SET  MULTI_USER 
GO
ALTER DATABASE [Mainstage] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Mainstage] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Mainstage] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Mainstage] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Mainstage] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Mainstage] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Mainstage', N'ON'
GO
ALTER DATABASE [Mainstage] SET QUERY_STORE = ON
GO
ALTER DATABASE [Mainstage] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Mainstage]
GO
/****** Object:  User [mainstage]    Script Date: 17/03/2025 17:28:05 ******/
CREATE USER [mainstage] FOR LOGIN [mainstage] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [mainstage]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mainstage]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [mainstage]
GO
/****** Object:  Table [dbo].[Cards]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[IsKeeper] [bit] NOT NULL,
	[CardType] [nvarchar](50) NOT NULL,
	[Parameter1Name] [nvarchar](50) NULL,
	[Parameter1] [nvarchar](50) NULL,
	[Parameter2Name] [nvarchar](50) NULL,
	[Parameter2] [nvarchar](50) NULL,
	[Parameter3Name] [nvarchar](50) NULL,
	[Parameter3] [nvarchar](50) NULL,
	[Parameter4Name] [nvarchar](50) NULL,
	[Parameter4] [nvarchar](50) NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Card] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[ChatId] [int] NOT NULL,
	[PlayerId] [nvarchar](50) NOT NULL,
	[MessageId] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ChatMessages] PRIMARY KEY CLUSTERED 
(
	[ChatId] ASC,
	[PlayerId] ASC,
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameActions]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameActions](
	[GameId] [int] NOT NULL,
	[PlayerId] [nvarchar](50) NOT NULL,
	[ActionId] [int] NOT NULL,
	[ActionType] [nvarchar](20) NOT NULL,
	[Parameter] [nvarchar](200) NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GameAction] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[PlayerId] ASC,
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameCards]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameCards](
	[GameId] [int] NOT NULL,
	[CardId] [int] NOT NULL,
	[Pile] [nvarchar](7) NOT NULL,
	[PilePosition] [int] NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GameCard] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[CardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameOptions]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameOptions](
	[GameId] [int] NOT NULL,
	[PlayerAmount] [int] NOT NULL,
	[TurnTimeLimit] [int] NOT NULL,
	[ReactionTimeLimit] [int] NOT NULL,
	[AiPlayers] [bit] NOT NULL,
	[UseMegaFatLady] [bit] NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GameOptions] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlayerCards]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlayerCards](
	[GameId] [int] NOT NULL,
	[PlayerId] [nvarchar](50) NOT NULL,
	[CardId] [int] NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GamePlayerCard] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[PlayerId] ASC,
	[CardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlayers]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlayers](
	[GameId] [int] NOT NULL,
	[PlayerId] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Position] [int] NOT NULL,
	[HasTurn] [bit] NOT NULL,
	[TurnStartMode] [nvarchar](50) NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GamePlayer] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[PlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Games]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Games](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[State] [nvarchar](100) NOT NULL,
	[IsPublic] [bit] NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Players]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Players](
	[Id] [nvarchar](50) NOT NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tiles]    Script Date: 17/03/2025 17:28:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tiles](
	[Id] [int] NOT NULL,
	[HasCard] [bit] NOT NULL,
	[ArrowTarget] [int] NOT NULL,
	[ArrowSource] [int] NOT NULL,
	[IsStage] [bit] NOT NULL,
	[Stage] [int] NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[CrDate] [datetime] NOT NULL,
	[CrUser] [nvarchar](50) NOT NULL,
	[LcDate] [datetime] NOT NULL,
	[LcUser] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Tile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Cards] ON 

INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (1, N'Streamline', N'+1', 0, N'move', N'type', N'self', N'amount', N'1', N'', N'', N'', N'', CAST(N'2024-12-26T10:50:31.877' AS DateTime), N'admin', CAST(N'2024-12-26T10:50:31.877' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (2, N'Streamline', N'+1', 0, N'move', N'type', N'self', N'amount', N'1', N'', N'', N'', N'', CAST(N'2024-12-26T10:50:32.690' AS DateTime), N'admin', CAST(N'2024-12-26T10:50:32.690' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (3, N'Stage Pass', N'Ge moet niet optreden!', 1, N'pass', N'type', N'noroll', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:51:36.727' AS DateTime), N'admin', CAST(N'2024-12-26T10:51:36.727' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (4, N'Battle', N'Iedereen gooit en de loser moet terug, awoehaha', 0, N'collectiveroll', N'type', N'battle', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:53:46.350' AS DateTime), N'admin', CAST(N'2024-12-26T10:53:46.350' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (5, N'Battle', N'Iedereen gooit en de loser moet terug, awoehaha', 0, N'collectiveroll', N'type', N'battle', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:53:47.890' AS DateTime), N'admin', CAST(N'2024-12-26T10:53:47.890' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (6, N'Doe de zalm', N'Pijlrichting omdraaien', 1, N'zalm', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:54:52.520' AS DateTime), N'admin', CAST(N'2024-12-26T10:54:52.520' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (7, N'Doe de zalm', N'Pijlrichting omdraaien', 1, N'zalm', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:54:53.673' AS DateTime), N'admin', CAST(N'2024-12-26T10:54:53.673' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (8, N'Gooi opnieuw', N'', 0, N'moveroll', N'type', N'self', N'direction', N'+', N'', N'', N'', N'', CAST(N'2024-12-26T10:55:26.107' AS DateTime), N'admin', CAST(N'2024-12-26T10:55:26.107' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (9, N'Gooi opnieuw', N'', 0, N'moveroll', N'type', N'self', N'direction', N'+', N'', N'', N'', N'', CAST(N'2024-12-26T10:55:28.180' AS DateTime), N'admin', CAST(N'2024-12-26T10:55:28.180' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (10, N'Steal a card', N'', 0, N'stealcard', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:55:41.033' AS DateTime), N'admin', CAST(N'2024-12-26T10:55:41.033' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (11, N'Steal a card', N'', 0, N'stealcard', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:55:41.867' AS DateTime), N'admin', CAST(N'2024-12-26T10:55:41.867' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (12, N'Oh jawel! LOL', N'Heft Nopekaart op', 1, N'ohjawel', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:58:01.683' AS DateTime), N'admin', CAST(N'2024-12-26T10:58:01.683' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (13, N'Oh jawel! LOL', N'Heft Nopekaart op', 1, N'ohjawel', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T10:58:03.103' AS DateTime), N'admin', CAST(N'2024-12-26T10:58:03.103' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (14, N'Package Deal', N'Jij en iemand naar keuze mogen +3', 0, N'move', N'type', N'self opponent', N'amount', N'3', N'', N'', N'', N'', CAST(N'2024-12-26T10:59:48.517' AS DateTime), N'admin', CAST(N'2024-12-26T10:59:48.517' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (15, N'Package Deal', N'Jij en iemand naar keuze mogen +3', 0, N'move', N'type', N'self opponent', N'amount', N'3', N'', N'', N'', N'', CAST(N'2024-12-26T10:59:51.103' AS DateTime), N'admin', CAST(N'2024-12-26T10:59:51.103' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (16, N'Package Deal', N'Jij en iemand naar keuze mogen +3', 0, N'move', N'type', N'self opponent', N'amount', N'3', N'', N'', N'', N'', CAST(N'2024-12-26T10:59:51.703' AS DateTime), N'admin', CAST(N'2024-12-26T10:59:51.703' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (17, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:29.513' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:29.513' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (18, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:30.337' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:30.337' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (19, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:31.037' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:31.037' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (20, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:32.427' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:32.427' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (21, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:33.320' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:33.320' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (22, N'Nope!!', N'', 1, N'nope', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:00:33.983' AS DateTime), N'admin', CAST(N'2024-12-26T11:00:33.983' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (23, N'The Poll', N'Allemaal gooien, winnaar zoveel vooruit inclusief skip stage!', 0, N'collectiveroll', N'type', N'poll', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:01:21.183' AS DateTime), N'admin', CAST(N'2024-12-26T11:01:21.183' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (24, N'The Fat Lady', N'Terug naar start & kaarten kwijt want dit is een frustrerend spelletje', 0, N'fatlady', N'type', N'self', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:02:07.700' AS DateTime), N'admin', CAST(N'2024-12-26T11:02:07.700' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (25, N'Steal a card', N'', 1, N'stealcard', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:02:45.973' AS DateTime), N'admin', CAST(N'2024-12-26T11:02:45.973' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (26, N'Attack!', N'Zodra iemand gegooid heeft moet hij zoveel plaatsen achteruit in plaats van vooruit', 1, N'attack', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:03:25.660' AS DateTime), N'admin', CAST(N'2024-12-26T11:03:25.660' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (27, N'Autotune kapot', N'Ga naar het jeugdhuis', 0, N'teleport', N'type', N'self', N'destination', N'jeugdhuis', N'', N'', N'', N'', CAST(N'2024-12-26T11:04:54.057' AS DateTime), N'admin', CAST(N'2024-12-26T11:04:54.057' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (28, N'Rock Rally', N'Iedereen gooit (ook meetellen als spelers hetzelfde gooien en dus opnieuw moeten gooien). Winnaar zoveel vooruit', 0, N'collectiveroll', N'type', N'rockrally', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:06:00.210' AS DateTime), N'admin', CAST(N'2024-12-26T11:06:00.210' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (29, N'Switch Places Immediately', N'', 0, N'switchplaces', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:06:42.127' AS DateTime), N'admin', CAST(N'2024-12-26T11:06:42.127' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (30, N'Gooi opnieuw en achteruit', N'', 0, N'moveroll', N'type', N'self', N'direction', N'-', N'', N'', N'', N'', CAST(N'2024-12-26T11:07:06.990' AS DateTime), N'admin', CAST(N'2024-12-26T11:07:06.990' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (31, N'One Hit Wonder', N'Next stage!', 0, N'teleport', N'type', N'self', N'destination', N'nextstage', N'', N'', N'', N'', CAST(N'2024-12-26T11:08:10.500' AS DateTime), N'admin', CAST(N'2024-12-26T11:08:10.500' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (32, N'+2', N'', 0, N'move', N'type', N'self', N'amount', N'2', N'', N'', N'', N'', CAST(N'2024-12-26T11:08:55.497' AS DateTime), N'admin', CAST(N'2024-12-26T11:08:55.497' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (33, N'-2', N'', 0, N'move', N'type', N'self', N'amount', N'-2', N'', N'', N'', N'', CAST(N'2024-12-26T11:09:17.637' AS DateTime), N'admin', CAST(N'2024-12-26T11:09:17.637' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (34, N'+5', N'', 0, N'move', N'type', N'self', N'amount', N'5', N'', N'', N'', N'', CAST(N'2024-12-26T11:09:35.583' AS DateTime), N'admin', CAST(N'2024-12-26T11:09:35.583' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (35, N'Stolen Van', N'-6', 0, N'move', N'type', N'self', N'amount', N'-6', N'', N'', N'', N'', CAST(N'2024-12-26T11:10:41.593' AS DateTime), N'admin', CAST(N'2024-12-26T11:10:41.593' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (36, N'Merch Sales', N'+5', 0, N'move', N'type', N'self', N'amount', N'5', N'', N'', N'', N'', CAST(N'2024-12-26T11:12:15.400' AS DateTime), N'admin', CAST(N'2024-12-26T11:12:15.400' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (37, N'+3', N'', 0, N'move', N'type', N'self', N'amount', N'3', N'', N'', N'', N'', CAST(N'2024-12-26T11:12:27.830' AS DateTime), N'admin', CAST(N'2024-12-26T11:12:27.830' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (38, N'Smash Hit', N'+6', 0, N'move', N'type', N'self', N'amount', N'6', N'', N'', N'', N'', CAST(N'2024-12-26T11:12:42.520' AS DateTime), N'admin', CAST(N'2024-12-26T11:12:42.520' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (39, N'Oeps, Politieke Mening Geuit', N'-3', 0, N'move', N'type', N'self', N'amount', N'-3', N'', N'', N'', N'', CAST(N'2024-12-26T11:13:13.663' AS DateTime), N'admin', CAST(N'2024-12-26T11:13:13.663' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (40, N'Airplay', N'+3', 0, N'move', N'type', N'self', N'amount', N'3', N'', N'', N'', N'', CAST(N'2024-12-26T11:13:35.263' AS DateTime), N'admin', CAST(N'2024-12-26T11:13:35.263' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (41, N'One Hit Wonder', N'+4', 0, N'move', N'type', N'self', N'amount', N'4', N'', N'', N'', N'', CAST(N'2024-12-26T11:14:10.307' AS DateTime), N'admin', CAST(N'2024-12-26T11:14:10.307' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (42, N'The Lovely Lady', N'Next stage', 0, N'teleport', N'type', N'self', N'destination', N'nextstage', N'', N'', N'', N'', CAST(N'2024-12-26T11:28:07.313' AS DateTime), N'admin', CAST(N'2024-12-26T11:28:07.313' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (43, N'Corrupt Manager', N'Ga naar vorige stage', 0, N'teleport', N'type', N'self', N'destination', N'previousstage', N'', N'', N'', N'', CAST(N'2024-12-26T11:28:55.900' AS DateTime), N'admin', CAST(N'2024-12-26T11:28:55.900' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (44, N'Route 66', N'Ga naar 66 duh', 0, N'teleport', N'type', N'self', N'destination', N'66', N'', N'', N'', N'', CAST(N'2024-12-26T11:29:55.447' AS DateTime), N'admin', CAST(N'2024-12-26T11:29:55.447' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (45, N'Club 27', N'Ga naar 27 nu!', 0, N'teleport', N'type', N'self', N'destination', N'27', N'', N'', N'', N'', CAST(N'2024-12-26T11:30:58.767' AS DateTime), N'admin', CAST(N'2024-12-26T11:30:58.767' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (46, N'Stage Pass', N'Je moet niet optreden vanwege die blowjob', 1, N'pass', N'type', N'noroll', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:34:56.223' AS DateTime), N'admin', CAST(N'2024-12-26T11:34:56.223' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (47, N'The Pro', N'Stage pass: 3, 4, 5, 6 = OK', 1, N'pass', N'type', N'3 4 5 6', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:36:15.987' AS DateTime), N'admin', CAST(N'2024-12-26T11:36:15.987' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (48, N'Stage Sjans', N'Stage pass: 4, 5, 6 = OK', 1, N'pass', N'type', N'4 5 6', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:36:48.707' AS DateTime), N'admin', CAST(N'2024-12-26T11:36:48.707' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (49, N'Podiumbeest', N'Stage pass: 3, 4, 5, 6 = OK', 1, N'pass', N'type', N'3 4 5 6', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:37:19.483' AS DateTime), N'admin', CAST(N'2024-12-26T11:37:19.483' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (50, N'Sabotage', N'Iemand naar keuze blijft ter plekke totdat iemand hen oppikt, 6 gooit, of ze zelf 6 gooien', 1, N'panne', N'type', N'opponent', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:45:25.463' AS DateTime), N'admin', CAST(N'2024-12-26T11:45:25.463' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (51, N'Panne', N'Blijf ter plekke totdat iemand je oppikt, 6 gooit, of je zelf 6 gooit', 0, N'panne', N'type', N'self', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T11:47:55.060' AS DateTime), N'admin', CAST(N'2024-12-26T11:47:55.060' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (52, N'Copyright klacht', N'Iemand +3 of -3', 0, N'move', N'type', N'anyone', N'amount', N'choice', N'choice1', N'3', N'choice2', N'-3', CAST(N'2024-12-26T11:53:01.407' AS DateTime), N'admin', CAST(N'2024-12-26T11:53:01.407' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (53, N'Plagiaat', N'Jij mag 3 vooruit of tegenstander -3, inclusief skip stage!', 0, N'move', N'type', N'self1opponent2 skipstage', N'amount', N'choice', N'choice1', N'3', N'choice2', N'-3', CAST(N'2024-12-26T12:05:44.017' AS DateTime), N'admin', CAST(N'2024-12-26T12:05:44.017' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (54, N'Smear Campaign', N'Tegenstander -4', 0, N'move', N'type', N'opponent', N'amount', N'-4', N'', N'', N'', N'', CAST(N'2024-12-26T12:07:25.573' AS DateTime), N'admin', CAST(N'2024-12-26T12:07:25.573' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (55, N'Confusion', N'Jij -2 of tegenstander +3', 0, N'move', N'type', N'self1opponent2', N'amount', N'choice', N'choice1', N'-2', N'choice2', N'3', CAST(N'2024-12-26T12:09:44.217' AS DateTime), N'admin', CAST(N'2024-12-26T12:09:44.217' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (56, N'Everybody wants to be a DJ', N'Allemaal 1 plek vooruit en rap een beetje (Eerst jij dan klok)', 0, N'move', N'type', N'everyone', N'amount', N'1', N'', N'', N'', N'', CAST(N'2024-12-26T12:11:32.037' AS DateTime), N'admin', CAST(N'2024-12-26T12:11:32.037' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (57, N'Festival Mismanagement', N'Allemaal een stage terug', 0, N'teleport', N'type', N'everyone', N'destination', N'previousstage', N'', N'', N'', N'', CAST(N'2024-12-26T12:35:36.037' AS DateTime), N'admin', CAST(N'2024-12-26T12:35:36.037' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (58, N'Kakfans', N'Jij en de anderen gooien. Optellen en zoveel moet jij achteruit', 0, N'collectiveroll', N'type', N'kakfans', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:45:05.617' AS DateTime), N'admin', CAST(N'2024-12-26T12:45:05.617' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (59, N'Mega Fat Lady', N'Iedereen terug naar af en kaarten kwijt. Bende prutsers!', 0, N'fatlady', N'type', N'everyone', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:46:48.450' AS DateTime), N'admin', CAST(N'2024-12-26T12:46:48.450' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (60, N'Groupie', N'Beurt overslaan', 0, N'skipturn', N'type', N'self', N'amount', N'1', N'', N'', N'', N'', CAST(N'2024-12-26T12:47:34.770' AS DateTime), N'admin', CAST(N'2024-12-26T12:47:34.770' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (61, N'Groupie + Vodka', N'Sla 2 beurten over', 0, N'skipturn', N'type', N'self', N'amount', N'2', N'', N'', N'', N'', CAST(N'2024-12-26T12:51:21.777' AS DateTime), N'admin', CAST(N'2024-12-26T12:51:21.777' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (62, N'The Remix', N'Iemand anders naar volgende stage, jij gooit hun optreden', 0, N'teleport', N'type', N'opponent youroll', N'destination', N'nextstage', N'', N'', N'', N'', CAST(N'2024-12-26T12:54:47.873' AS DateTime), N'admin', CAST(N'2024-12-26T12:54:47.873' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (63, N'Gooi opnieuw', N'Maar tegenstander vooruit', 0, N'moveroll', N'type', N'opponent', N'direction', N'+', N'', N'', N'', N'', CAST(N'2024-12-26T12:56:17.187' AS DateTime), N'admin', CAST(N'2024-12-26T12:56:17.187' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (64, N'Kaarten schudden', N'Met de klok mee', 0, N'shuffle', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:57:17.563' AS DateTime), N'admin', CAST(N'2024-12-26T12:57:17.563' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (65, N'Switch places', N'', 1, N'switchplaces', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:58:07.903' AS DateTime), N'admin', CAST(N'2024-12-26T12:58:07.903' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (66, N'Kaarten kwijt', N'U bent officieel uw kaarten kwijt', 0, N'losecards', N'type', N'self', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:59:06.580' AS DateTime), N'admin', CAST(N'2024-12-26T12:59:06.580' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (67, N'Iedereen kaarten kwijt', N'Iedereen alle kaarten kwijt. Boehoe. Huil maar!', 0, N'losecards', N'type', N'everyone', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T12:59:40.140' AS DateTime), N'admin', CAST(N'2024-12-26T12:59:40.140' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (68, N'Bandcest', N'Gooi en tegenstander moet zoveel achteruit', 0, N'moveroll', N'type', N'opponent', N'direction', N'-', N'', N'', N'', N'', CAST(N'2024-12-26T13:00:27.010' AS DateTime), N'admin', CAST(N'2024-12-26T13:00:27.010' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (69, N'Kaarten doorgeven', N'Met de klok mee. Alle spelers, ook de lelijke.', 0, N'passcards', N'type', N'everyone', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:02:08.527' AS DateTime), N'admin', CAST(N'2024-12-26T13:02:08.527' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (70, N'Verdeel uw kaarten', N'Met de klok mee. Want ge hebt teveel sjans.', 0, N'passcards', N'type', N'self', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:03:07.313' AS DateTime), N'admin', CAST(N'2024-12-26T13:03:07.313' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (71, N'All Or Nothing', N'Direct naar Main Stage. Geen 6 gerold? Terug naar Jeugdhuis', 1, N'allornothing', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:04:17.223' AS DateTime), N'admin', CAST(N'2024-12-26T13:04:17.223' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (72, N'#metoo', N'Dat ga ik ook doen. U mag hetzelfde doen als tegenstander die een kaart gebruikt.', 1, N'metoo', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:06:33.570' AS DateTime), N'admin', CAST(N'2024-12-26T13:06:33.570' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (73, N'Whatever you want', N'Eender welke bestaande kaart meteen gebruiken.', 0, N'joker', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:07:18.913' AS DateTime), N'admin', CAST(N'2024-12-26T13:07:18.913' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (74, N'Tous ensemble', N'Kies een tegenstander die hetzelfde moet doen als degene die de laatste kaart heeft getrokken', 1, N'tousensemble', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:08:16.190' AS DateTime), N'admin', CAST(N'2024-12-26T13:08:16.190' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (75, N'Iedereen raapt een kaart', N'Eerst jij, dan klok', 0, N'everybodydraws', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:10:07.933' AS DateTime), N'admin', CAST(N'2024-12-26T13:10:07.933' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (76, N'Bandwagon', N'Jij mag evenveel ogen vooruit als degene aan zet.', 1, N'bandwagon', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:10:45.000' AS DateTime), N'admin', CAST(N'2024-12-26T13:10:45.000' AS DateTime), N'admin')
INSERT [dbo].[Cards] ([Id], [Name], [Description], [IsKeeper], [CardType], [Parameter1Name], [Parameter1], [Parameter2Name], [Parameter2], [Parameter3Name], [Parameter3], [Parameter4Name], [Parameter4], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (77, N'PR Campaign', N'Nog eens evenveel ogen vooruit', 1, N'prcampaign', N'', N'', N'', N'', N'', N'', N'', N'', CAST(N'2024-12-26T13:11:09.707' AS DateTime), N'admin', CAST(N'2024-12-26T13:11:09.707' AS DateTime), N'admin')
SET IDENTITY_INSERT [dbo].[Cards] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatMessages] ON 

INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'BronstigeBarry', 17, N'Pas oep e manne, ik sta scherp', CAST(N'2025-02-19T11:59:23.610' AS DateTime), N'BronstigeBarry', CAST(N'2025-02-19T11:59:23.610' AS DateTime), N'BronstigeBarry')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 1, N'blatest', CAST(N'2025-01-27T10:38:59.617' AS DateTime), N'Timo', CAST(N'2025-01-27T10:38:59.627' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 2, N'testblabla', CAST(N'2025-01-27T10:41:51.440' AS DateTime), N'Timo', CAST(N'2025-01-27T10:41:51.440' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 3, N'bla', CAST(N'2025-01-27T10:51:40.143' AS DateTime), N'Timo', CAST(N'2025-01-27T10:51:40.143' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 4, N'test123', CAST(N'2025-01-27T11:18:37.187' AS DateTime), N'Timo', CAST(N'2025-01-27T11:18:37.187' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 5, N'The quick brown fox is kind of a sly bastard because he stole old McDonald''s prize winning chicken Manfred, and the old man was not so happy with this development. So he started installing traps all around his farm. However, the fox was cunning indeed, he made some noise near the chicken coop at night and made Old McDonald run out and end up in his own traps. ', CAST(N'2025-01-27T11:23:08.347' AS DateTime), N'Timo', CAST(N'2025-01-27T11:23:08.347' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 6, N'boe', CAST(N'2025-01-27T11:37:05.910' AS DateTime), N'Timo', CAST(N'2025-01-27T11:37:05.910' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'timo', 7, N'waza', CAST(N'2025-02-05T13:12:33.647' AS DateTime), N'timo', CAST(N'2025-02-05T13:12:33.647' AS DateTime), N'timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'timo', 8, N'yoyo', CAST(N'2025-02-05T13:12:37.410' AS DateTime), N'timo', CAST(N'2025-02-05T13:12:37.410' AS DateTime), N'timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'timo', 9, N'T', CAST(N'2025-02-05T13:12:40.040' AS DateTime), N'timo', CAST(N'2025-02-05T13:12:40.040' AS DateTime), N'timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 10, N'fdgfdgdfg', CAST(N'2025-02-05T13:37:22.780' AS DateTime), N'Timo', CAST(N'2025-02-05T13:37:22.780' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 11, N'rterjtop', CAST(N'2025-02-05T13:37:24.567' AS DateTime), N'Timo', CAST(N'2025-02-05T13:37:24.567' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 12, N'sdfsdfsdfsdfsdfdfsdf', CAST(N'2025-02-05T14:38:58.477' AS DateTime), N'Timo', CAST(N'2025-02-05T14:38:58.477' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 13, N'rtioerjtreoijteriotgj', CAST(N'2025-02-05T14:39:00.780' AS DateTime), N'Timo', CAST(N'2025-02-05T14:39:00.780' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 14, N'dsfdsf', CAST(N'2025-02-05T14:40:41.750' AS DateTime), N'Timo', CAST(N'2025-02-05T14:40:41.750' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 18, N'Kunnen we het hier een beetje rustig houden ja want anders ga ik het zeggen tegen de moderator', CAST(N'2025-02-19T11:59:58.317' AS DateTime), N'Timo', CAST(N'2025-02-19T11:59:58.317' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 125, N'test', CAST(N'2025-03-03T11:03:23.040' AS DateTime), N'Timo', CAST(N'2025-03-03T11:03:23.040' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 126, N'test', CAST(N'2025-03-03T11:03:24.103' AS DateTime), N'Timo', CAST(N'2025-03-03T11:03:24.103' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 127, N'test', CAST(N'2025-03-03T11:03:25.237' AS DateTime), N'Timo', CAST(N'2025-03-03T11:03:25.237' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 128, N'test', CAST(N'2025-03-03T11:03:26.157' AS DateTime), N'Timo', CAST(N'2025-03-03T11:03:26.157' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 129, N'tesss', CAST(N'2025-03-03T11:04:33.853' AS DateTime), N'Timo', CAST(N'2025-03-03T11:04:33.853' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 166, N'yoooyoyoyo', CAST(N'2025-03-03T11:28:14.953' AS DateTime), N'Timo', CAST(N'2025-03-03T11:28:14.953' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 167, N'yoyoyoo', CAST(N'2025-03-03T11:28:16.823' AS DateTime), N'Timo', CAST(N'2025-03-03T11:28:16.823' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 168, N'fgfdgfgfgdfg', CAST(N'2025-03-03T11:28:37.480' AS DateTime), N'Timo', CAST(N'2025-03-03T11:28:37.480' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 169, N'fdgdfgfdg', CAST(N'2025-03-03T11:28:38.833' AS DateTime), N'Timo', CAST(N'2025-03-03T11:28:38.833' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 171, N'test', CAST(N'2025-03-03T11:30:07.940' AS DateTime), N'Timo', CAST(N'2025-03-03T11:30:07.940' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 172, N'sfdfs', CAST(N'2025-03-03T11:30:10.073' AS DateTime), N'Timo', CAST(N'2025-03-03T11:30:10.073' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 173, N'sffsd', CAST(N'2025-03-03T11:30:11.233' AS DateTime), N'Timo', CAST(N'2025-03-03T11:30:11.233' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'Timo', 174, N'test', CAST(N'2025-03-03T11:35:02.210' AS DateTime), N'Timo', CAST(N'2025-03-03T11:35:02.210' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'VettigeSwa', 15, N'yo gasten, tis Swakke hier', CAST(N'2025-02-19T11:58:08.770' AS DateTime), N'VettigeSwa', CAST(N'2025-02-19T11:58:08.770' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'VettigeSwa', 170, N'tersfgsdfdsf', CAST(N'2025-03-03T11:28:59.567' AS DateTime), N'VettigeSwa', CAST(N'2025-03-03T11:28:59.567' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, N'ZatteLeo', 16, N'aaah hier sé, Swakke, ik gon a echt wel serieus inmaken', CAST(N'2025-02-19T11:59:06.953' AS DateTime), N'ZatteLeo', CAST(N'2025-02-19T11:59:06.953' AS DateTime), N'ZatteLeo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (129, N'sys', 19, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T10:41:01.053' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T10:41:01.053' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (134, N'sys', 20, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T10:50:38.367' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T10:50:38.367' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (137, N'sys', 21, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:00:24.963' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:00:24.963' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (139, N'sys', 22, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:02:03.177' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:02:03.177' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (143, N'sys', 23, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:04:45.757' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:04:45.757' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (143, N'sys', 24, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-24T11:04:57.633' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:04:57.633' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (144, N'sys', 25, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:05:31.057' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:05:31.057' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (145, N'sys', 26, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:11:14.930' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:11:14.930' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (145, N'sys', 27, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-24T11:11:53.970' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:11:53.970' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (146, N'sys', 28, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:13:07.830' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:13:07.830' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (147, N'sys', 29, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:13:54.190' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:13:54.190' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (147, N'sys', 30, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:21:58.203' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:21:58.203' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (147, N'sys', 31, N'Welkom, speler VettigeSwa', CAST(N'2025-02-24T11:21:58.197' AS DateTime), N'VettigeSwa', CAST(N'2025-02-24T11:21:58.197' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (150, N'sys', 32, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:10:35.067' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:10:35.067' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (151, N'sys', 33, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:14:53.717' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:14:53.717' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (151, N'sys', 34, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:15:04.810' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:15:04.810' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (153, N'sys', 35, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:17:30.440' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:17:30.440' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (153, N'sys', 36, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:17:35.240' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:17:35.240' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (154, N'sys', 37, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:19:53.117' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:19:53.117' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (154, N'sys', 38, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:22:00.327' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:22:00.327' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (156, N'sys', 39, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:34:46.223' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:34:46.223' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (157, N'sys', 40, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:43:15.257' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:43:15.257' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (157, N'sys', 41, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:44:28.027' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:44:28.027' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (157, N'sys', 42, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:44:31.480' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:44:31.480' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (157, N'sys', 43, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:45:19.170' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:45:19.170' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (158, N'sys', 44, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:56:11.720' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:56:11.720' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (158, N'sys', 45, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:56:20.590' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:56:20.590' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (159, N'sys', 46, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T10:57:11.993' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:57:11.993' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (159, N'sys', 47, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T10:58:00.293' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T10:58:00.293' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (160, N'sys', 48, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T11:16:52.853' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T11:16:52.853' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (160, N'sys', 49, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T11:17:15.643' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T11:17:15.643' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (161, N'sys', 50, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T11:19:02.890' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T11:19:02.890' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (162, N'sys', 51, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T11:20:53.383' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T11:20:53.383' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (167, N'sys', 52, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:05:34.283' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:05:34.283' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (167, N'sys', 53, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:07:35.013' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:07:35.013' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (167, N'sys', 54, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:11:02.537' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:11:02.537' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (168, N'sys', 55, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:11:38.283' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:11:38.283' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (169, N'sys', 56, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:12:06.547' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:12:06.547' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (169, N'sys', 58, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T20:12:29.567' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:12:29.567' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (169, N'Timo', 57, N'yo swakke', CAST(N'2025-02-26T20:12:24.000' AS DateTime), N'Timo', CAST(N'2025-02-26T20:12:24.017' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (170, N'sys', 59, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:13:18.477' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:13:18.477' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (170, N'sys', 62, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T20:14:39.313' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:14:39.313' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (170, N'Timo', 60, N'yo swakke', CAST(N'2025-02-26T20:13:22.943' AS DateTime), N'Timo', CAST(N'2025-02-26T20:13:22.943' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (170, N'VettigeSwa', 61, N'yo Timo', CAST(N'2025-02-26T20:13:32.960' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:13:32.960' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (171, N'sys', 63, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T20:17:00.903' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:17:00.903' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (171, N'Timo', 64, N'yo Swakke', CAST(N'2025-02-26T20:17:20.683' AS DateTime), N'Timo', CAST(N'2025-02-26T20:17:20.683' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (171, N'Timo', 66, N'In a moeder', CAST(N'2025-02-26T20:17:39.903' AS DateTime), N'Timo', CAST(N'2025-02-26T20:17:39.903' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (171, N'VettigeSwa', 65, N'yo Timon, waar is pumba', CAST(N'2025-02-26T20:17:32.707' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T20:17:32.707' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (172, N'sys', 67, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:03:01.277' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:03:01.277' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (173, N'sys', 68, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:08:08.877' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:08:08.877' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (173, N'sys', 69, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T21:09:35.097' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:09:35.097' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (174, N'sys', 70, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:10:08.700' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:10:08.700' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (174, N'sys', 71, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T21:10:39.330' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:10:39.330' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (176, N'sys', 72, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:13:54.603' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:13:54.603' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (177, N'sys', 73, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:22:43.967' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:22:43.967' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (177, N'sys', 74, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T21:22:45.903' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:22:45.903' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (178, N'sys', 75, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:29:54.543' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:29:54.543' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (179, N'sys', 76, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:45:14.987' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:45:14.987' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (179, N'Timo', 77, N'yo swakke', CAST(N'2025-02-26T21:45:20.457' AS DateTime), N'Timo', CAST(N'2025-02-26T21:45:20.457' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (179, N'VettigeSwa', 78, N'yo Timo', CAST(N'2025-02-26T21:45:26.873' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:45:26.873' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (180, N'sys', 79, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:49:58.793' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:49:58.793' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (181, N'sys', 80, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:53:05.103' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:53:05.103' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (181, N'sys', 81, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T21:53:54.087' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:53:54.087' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 82, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T21:59:23.880' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:59:23.880' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 83, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T21:59:31.783' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T21:59:31.783' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 84, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:00:47.223' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:00:47.223' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 85, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:01:06.430' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:01:06.430' AS DateTime), N'VettigeSwa')
GO
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 86, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:01:24.750' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:01:24.750' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 87, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:01:30.533' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:01:30.533' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 88, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:02:31.573' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:02:31.573' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 89, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:02:42.503' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:02:42.503' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 90, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:02:54.623' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:02:54.623' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 91, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:03:04.763' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:03:04.763' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 92, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:03:24.347' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:03:24.347' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 93, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:03:32.317' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:03:32.317' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 94, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:03:34.410' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:03:34.410' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 95, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:03:59.637' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:03:59.637' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 96, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:04:27.140' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:04:27.140' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 97, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:04:46.993' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:04:46.993' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 98, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:04:51.570' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:04:51.570' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 99, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:05:00.087' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:05:00.087' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 100, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:07:38.937' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:07:38.937' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 101, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:07:45.913' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:07:45.913' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 102, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:07:54.260' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:07:54.260' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 103, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:07:56.787' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:07:56.787' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 104, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:08:06.390' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:08:06.390' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 105, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:08:29.147' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:08:29.147' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 106, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:09:20.310' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:09:20.310' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 107, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:09:32.313' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:09:32.313' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 108, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:09:58.863' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:09:58.863' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 109, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:11:15.807' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:11:15.807' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 110, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:11:20.363' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:11:20.363' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 111, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:11:23.253' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:11:23.253' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 112, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:11:27.587' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:11:27.587' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 113, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:12:08.160' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:12:08.160' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (182, N'sys', 114, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:12:14.383' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:12:14.383' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (183, N'sys', 115, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:15:14.640' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:15:14.640' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (183, N'sys', 116, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:15:19.127' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:15:19.127' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (184, N'sys', 117, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:16:45.593' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:16:45.593' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (184, N'sys', 118, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:16:53.000' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:16:53.000' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (184, N'sys', 119, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:17:39.013' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:17:39.013' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (184, N'sys', 120, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:17:49.283' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:17:49.283' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (185, N'sys', 121, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:19:59.037' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:19:59.037' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (185, N'sys', 122, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:20:05.760' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:20:05.760' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (185, N'sys', 123, N'Welkom, speler VettigeSwa', CAST(N'2025-02-26T22:21:50.630' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:21:50.630' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (185, N'sys', 124, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-02-26T22:21:57.470' AS DateTime), N'VettigeSwa', CAST(N'2025-02-26T22:21:57.470' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 130, N'dfdsfds', CAST(N'2025-03-03T11:06:33.523' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:33.523' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 131, N'dsf', CAST(N'2025-03-03T11:06:33.690' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:33.690' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 132, N'sf', CAST(N'2025-03-03T11:06:33.857' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:33.857' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 133, N'sdf', CAST(N'2025-03-03T11:06:34.027' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.027' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 134, N'sdf', CAST(N'2025-03-03T11:06:34.207' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.207' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 135, N'dsf', CAST(N'2025-03-03T11:06:34.373' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.373' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 136, N'sdf', CAST(N'2025-03-03T11:06:34.550' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.550' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 137, N'sdf', CAST(N'2025-03-03T11:06:34.713' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.713' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 138, N'sdf', CAST(N'2025-03-03T11:06:34.880' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:34.880' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 139, N'dsf', CAST(N'2025-03-03T11:06:35.057' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.057' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 140, N'dsf', CAST(N'2025-03-03T11:06:35.220' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.220' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 141, N'sdf', CAST(N'2025-03-03T11:06:35.387' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.387' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 142, N'dssf', CAST(N'2025-03-03T11:06:35.553' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.553' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 143, N'f', CAST(N'2025-03-03T11:06:35.727' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.727' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 144, N'dsfsd', CAST(N'2025-03-03T11:06:35.913' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:35.913' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 145, N'fds', CAST(N'2025-03-03T11:06:36.090' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.090' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 146, N'fd', CAST(N'2025-03-03T11:06:36.267' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.267' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 147, N'sfds', CAST(N'2025-03-03T11:06:36.447' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.447' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 148, N'fsd', CAST(N'2025-03-03T11:06:36.627' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.627' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 149, N'fsd', CAST(N'2025-03-03T11:06:36.810' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.810' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 150, N'fds', CAST(N'2025-03-03T11:06:36.993' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:36.993' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 151, N'f', CAST(N'2025-03-03T11:06:37.173' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:37.173' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 152, N'fds', CAST(N'2025-03-03T11:06:37.357' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:37.357' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 153, N'fds', CAST(N'2025-03-03T11:06:37.550' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:37.550' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 154, N'fds', CAST(N'2025-03-03T11:06:37.723' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:37.723' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 155, N'fsd', CAST(N'2025-03-03T11:06:37.907' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:37.907' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 156, N'f', CAST(N'2025-03-03T11:06:38.090' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.090' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 157, N'fs', CAST(N'2025-03-03T11:06:38.257' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.257' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 158, N'f', CAST(N'2025-03-03T11:06:38.433' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.433' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 159, N'fsd', CAST(N'2025-03-03T11:06:38.610' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.610' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 160, N'fsd', CAST(N'2025-03-03T11:06:38.787' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.787' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 161, N'fsd', CAST(N'2025-03-03T11:06:38.967' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:38.967' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 162, N'fsd', CAST(N'2025-03-03T11:06:39.143' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:39.143' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 163, N'fsd', CAST(N'2025-03-03T11:06:39.320' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:39.320' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 164, N'fds', CAST(N'2025-03-03T11:06:39.497' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:39.497' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (203, N'Timo', 165, N'f', CAST(N'2025-03-03T11:06:39.670' AS DateTime), N'Timo', CAST(N'2025-03-03T11:06:39.670' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (217, N'sys', 175, N'Welkom, speler VettigeSwa', CAST(N'2025-03-04T12:43:33.747' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T12:43:33.747' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (217, N'sys', 176, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-04T12:43:36.823' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T12:43:36.823' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (218, N'sys', 177, N'Welkom, speler VettigeSwa', CAST(N'2025-03-04T13:21:06.330' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T13:21:06.330' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (218, N'sys', 178, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-04T13:21:07.917' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T13:21:07.917' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (219, N'sys', 179, N'Welkom, speler VettigeSwa', CAST(N'2025-03-04T13:22:00.783' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T13:22:00.783' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (219, N'sys', 180, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-04T13:22:02.430' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T13:22:02.430' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (220, N'sys', 181, N'Welkom, speler VettigeSwa', CAST(N'2025-03-04T13:23:02.420' AS DateTime), N'VettigeSwa', CAST(N'2025-03-04T13:23:02.420' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (220, N'sys', 182, N'Speler Timo is klaar om te spelen.', CAST(N'2025-03-04T13:23:05.207' AS DateTime), N'Timo', CAST(N'2025-03-04T13:23:05.207' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (221, N'sys', 183, N'Welkom, speler VettigeSwa', CAST(N'2025-03-05T10:48:10.417' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T10:48:10.417' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (221, N'sys', 184, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-05T10:48:12.957' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T10:48:12.957' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (222, N'sys', 185, N'Speler Timo is klaar om te spelen.', CAST(N'2025-03-05T11:05:06.150' AS DateTime), N'Timo', CAST(N'2025-03-05T11:05:06.150' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (222, N'sys', 186, N'Welkom, speler VettigeSwa', CAST(N'2025-03-05T11:05:19.850' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T11:05:19.850' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (222, N'sys', 187, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-05T11:05:21.413' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T11:05:21.413' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (223, N'sys', 188, N'Welkom, speler VettigeSwa', CAST(N'2025-03-05T13:45:14.047' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T13:45:14.047' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (223, N'sys', 189, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-05T13:45:15.983' AS DateTime), N'VettigeSwa', CAST(N'2025-03-05T13:45:15.983' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (224, N'sys', 190, N'Welkom, speler VettigeSwa', CAST(N'2025-03-06T12:05:27.610' AS DateTime), N'VettigeSwa', CAST(N'2025-03-06T12:05:27.610' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (224, N'sys', 191, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-06T12:05:29.593' AS DateTime), N'VettigeSwa', CAST(N'2025-03-06T12:05:29.593' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (225, N'sys', 192, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:17:46.233' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:17:46.233' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (225, N'sys', 193, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:17:47.377' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:17:47.377' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (226, N'sys', 194, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:20:42.970' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:20:42.970' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (226, N'sys', 195, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:20:44.073' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:20:44.073' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (227, N'sys', 196, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:33:49.343' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:33:49.343' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (227, N'sys', 197, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:33:51.027' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:33:51.027' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 198, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:36:55.623' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:36:55.623' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 199, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:36:56.643' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:36:56.643' AS DateTime), N'VettigeSwa')
GO
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 200, N'Speler Timo is klaar om te spelen.', CAST(N'2025-03-07T11:37:02.993' AS DateTime), N'Timo', CAST(N'2025-03-07T11:37:02.993' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 201, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:37:09.163' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:37:09.163' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 202, N'Speler Timo is klaar om te spelen.', CAST(N'2025-03-07T11:37:19.103' AS DateTime), N'Timo', CAST(N'2025-03-07T11:37:19.103' AS DateTime), N'Timo')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (228, N'sys', 203, N'Speler VettigeSwa heeft het spel verlaten.', CAST(N'2025-03-07T11:37:26.033' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:37:26.033' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (229, N'sys', 204, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:37:41.033' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:37:41.033' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (229, N'sys', 205, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:37:42.160' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:37:42.160' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, N'sys', 206, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T11:43:05.363' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:43:05.363' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, N'sys', 207, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T11:43:22.177' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:43:22.177' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, N'sys', 208, N'Welkom, speler VettigeSwa', CAST(N'2025-03-07T12:18:16.680' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T12:18:16.680' AS DateTime), N'VettigeSwa')
INSERT [dbo].[ChatMessages] ([ChatId], [PlayerId], [MessageId], [Message], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, N'sys', 209, N'Speler VettigeSwa is klaar om te spelen.', CAST(N'2025-03-07T12:18:18.983' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T12:18:18.983' AS DateTime), N'VettigeSwa')
SET IDENTITY_INSERT [dbo].[ChatMessages] OFF
GO
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 1, N'draw', 0, CAST(N'2025-03-07T12:17:26.563' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.563' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 2, N'draw', 0, CAST(N'2025-03-07T12:17:26.597' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.597' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 3, N'draw', 0, CAST(N'2025-03-07T12:17:26.607' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.607' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 4, N'draw', 0, CAST(N'2025-03-07T12:17:26.613' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.613' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 5, N'draw', 0, CAST(N'2025-03-07T12:17:26.623' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.623' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 6, N'draw', 0, CAST(N'2025-03-07T12:17:26.630' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.630' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 7, N'draw', 0, CAST(N'2025-03-07T12:17:26.637' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.637' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 8, N'draw', 0, CAST(N'2025-03-07T12:17:26.643' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.643' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 9, N'draw', 0, CAST(N'2025-03-07T12:17:26.653' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.653' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 10, N'draw', 0, CAST(N'2025-03-07T12:17:26.660' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.660' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 11, N'draw', 0, CAST(N'2025-03-07T12:17:26.667' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.667' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 12, N'draw', 0, CAST(N'2025-03-07T12:17:26.673' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.673' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 13, N'draw', 0, CAST(N'2025-03-07T12:17:26.683' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.683' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 14, N'draw', 0, CAST(N'2025-03-07T12:17:26.690' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.690' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 15, N'draw', 0, CAST(N'2025-03-07T12:17:26.693' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.693' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 16, N'draw', 0, CAST(N'2025-03-07T12:17:26.700' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.700' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 17, N'draw', 0, CAST(N'2025-03-07T12:17:26.707' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.707' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 18, N'draw', 0, CAST(N'2025-03-07T12:17:26.717' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.717' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 19, N'draw', 0, CAST(N'2025-03-07T12:17:26.723' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.723' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 20, N'draw', 0, CAST(N'2025-03-07T12:17:26.730' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.730' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 21, N'draw', 0, CAST(N'2025-03-07T12:17:26.737' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.737' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 22, N'draw', 0, CAST(N'2025-03-07T12:17:26.747' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.747' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 23, N'draw', 0, CAST(N'2025-03-07T12:17:26.753' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.753' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 24, N'draw', 0, CAST(N'2025-03-07T12:17:26.760' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.760' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 25, N'draw', 0, CAST(N'2025-03-07T12:17:26.767' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.767' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 26, N'draw', 0, CAST(N'2025-03-07T12:17:26.773' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.773' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 27, N'draw', 0, CAST(N'2025-03-07T12:17:26.783' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.783' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 28, N'draw', 0, CAST(N'2025-03-07T12:17:26.790' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.790' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 29, N'draw', 0, CAST(N'2025-03-07T12:17:26.797' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.797' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 30, N'draw', 0, CAST(N'2025-03-07T12:17:26.803' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.803' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 31, N'draw', 0, CAST(N'2025-03-07T12:17:26.810' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.810' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 32, N'draw', 0, CAST(N'2025-03-07T12:17:26.817' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.817' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 33, N'draw', 0, CAST(N'2025-03-07T12:17:26.823' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.823' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 34, N'draw', 0, CAST(N'2025-03-07T12:17:26.830' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.830' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 35, N'draw', 0, CAST(N'2025-03-07T12:17:26.837' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.837' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 36, N'draw', 0, CAST(N'2025-03-07T12:17:26.843' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.843' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 37, N'draw', 0, CAST(N'2025-03-07T12:17:26.850' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.850' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 38, N'draw', 0, CAST(N'2025-03-07T12:17:26.857' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.857' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 39, N'draw', 0, CAST(N'2025-03-07T12:17:26.867' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.867' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 40, N'draw', 0, CAST(N'2025-03-07T12:17:26.873' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.873' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 41, N'draw', 0, CAST(N'2025-03-07T12:17:26.880' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.880' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 42, N'draw', 0, CAST(N'2025-03-07T12:17:26.890' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.890' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 43, N'draw', 0, CAST(N'2025-03-07T12:17:26.897' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.897' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 44, N'draw', 0, CAST(N'2025-03-07T12:17:26.903' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.903' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 45, N'draw', 0, CAST(N'2025-03-07T12:17:26.913' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.913' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 46, N'draw', 0, CAST(N'2025-03-07T12:17:26.920' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.920' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 47, N'draw', 0, CAST(N'2025-03-07T12:17:26.927' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.927' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 48, N'draw', 0, CAST(N'2025-03-07T12:17:26.937' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.937' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 49, N'draw', 0, CAST(N'2025-03-07T12:17:26.943' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.943' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 50, N'draw', 0, CAST(N'2025-03-07T12:17:26.953' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.953' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 51, N'draw', 0, CAST(N'2025-03-07T12:17:26.960' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.960' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 52, N'draw', 0, CAST(N'2025-03-07T12:17:26.967' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.967' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 53, N'draw', 0, CAST(N'2025-03-07T12:17:26.977' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.977' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 54, N'draw', 0, CAST(N'2025-03-07T12:17:26.983' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.983' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 55, N'draw', 0, CAST(N'2025-03-07T12:17:26.990' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:26.990' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 56, N'draw', 0, CAST(N'2025-03-07T12:17:27.000' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.000' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 57, N'draw', 0, CAST(N'2025-03-07T12:17:27.007' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.007' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 58, N'draw', 0, CAST(N'2025-03-07T12:17:27.013' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.013' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 59, N'draw', 0, CAST(N'2025-03-07T12:17:27.023' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.023' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 60, N'draw', 0, CAST(N'2025-03-07T12:17:27.030' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.030' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 61, N'draw', 0, CAST(N'2025-03-07T12:17:27.037' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.037' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 62, N'draw', 0, CAST(N'2025-03-07T12:17:27.047' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.047' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 63, N'draw', 0, CAST(N'2025-03-07T12:17:27.053' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.053' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 64, N'draw', 0, CAST(N'2025-03-07T12:17:27.060' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.060' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 65, N'draw', 0, CAST(N'2025-03-07T12:17:27.067' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.067' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 66, N'draw', 0, CAST(N'2025-03-07T12:17:27.077' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.077' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 67, N'draw', 0, CAST(N'2025-03-07T12:17:27.083' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.083' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 68, N'draw', 0, CAST(N'2025-03-07T12:17:27.090' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.090' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 69, N'draw', 0, CAST(N'2025-03-07T12:17:27.097' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.097' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 70, N'draw', 0, CAST(N'2025-03-07T12:17:27.107' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.107' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 71, N'draw', 0, CAST(N'2025-03-07T12:17:27.110' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.110' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 72, N'draw', 0, CAST(N'2025-03-07T12:17:27.117' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.117' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 73, N'draw', 0, CAST(N'2025-03-07T12:17:27.123' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.123' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 74, N'draw', 0, CAST(N'2025-03-07T12:17:27.130' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.130' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 75, N'draw', 0, CAST(N'2025-03-07T12:17:27.140' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.140' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 76, N'draw', 0, CAST(N'2025-03-07T12:17:27.147' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.147' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 77, N'draw', 0, CAST(N'2025-03-07T12:17:27.157' AS DateTime), N'sys', CAST(N'2025-03-07T12:17:27.157' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 1, N'draw', 0, CAST(N'2025-03-07T12:33:53.367' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.367' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 2, N'draw', 0, CAST(N'2025-03-07T12:33:53.377' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.377' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 3, N'draw', 0, CAST(N'2025-03-07T12:33:53.383' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.383' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 4, N'draw', 0, CAST(N'2025-03-07T12:33:53.390' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.390' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 5, N'draw', 0, CAST(N'2025-03-07T12:33:53.397' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.397' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 6, N'draw', 0, CAST(N'2025-03-07T12:33:53.403' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.403' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 7, N'draw', 0, CAST(N'2025-03-07T12:33:53.410' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.410' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 8, N'draw', 0, CAST(N'2025-03-07T12:33:53.417' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.417' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 9, N'draw', 0, CAST(N'2025-03-07T12:33:53.423' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.423' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 10, N'draw', 0, CAST(N'2025-03-07T12:33:53.430' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.430' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 11, N'draw', 0, CAST(N'2025-03-07T12:33:53.437' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.437' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 12, N'draw', 0, CAST(N'2025-03-07T12:33:53.443' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.443' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 13, N'draw', 0, CAST(N'2025-03-07T12:33:53.450' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.450' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 14, N'draw', 0, CAST(N'2025-03-07T12:33:53.457' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.457' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 15, N'draw', 0, CAST(N'2025-03-07T12:33:53.463' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.463' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 16, N'draw', 0, CAST(N'2025-03-07T12:33:53.470' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.470' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 17, N'draw', 0, CAST(N'2025-03-07T12:33:53.477' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.477' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 18, N'draw', 0, CAST(N'2025-03-07T12:33:53.483' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.483' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 19, N'draw', 0, CAST(N'2025-03-07T12:33:53.490' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.490' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 20, N'draw', 0, CAST(N'2025-03-07T12:33:53.497' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.497' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 21, N'draw', 0, CAST(N'2025-03-07T12:33:53.503' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.503' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 22, N'draw', 0, CAST(N'2025-03-07T12:33:53.510' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.510' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 23, N'draw', 0, CAST(N'2025-03-07T12:33:53.517' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.517' AS DateTime), N'sys')
GO
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 24, N'draw', 0, CAST(N'2025-03-07T12:33:53.523' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.523' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 25, N'draw', 0, CAST(N'2025-03-07T12:33:53.530' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.530' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 26, N'draw', 0, CAST(N'2025-03-07T12:33:53.537' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.537' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 27, N'draw', 0, CAST(N'2025-03-07T12:33:53.543' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.543' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 28, N'draw', 0, CAST(N'2025-03-07T12:33:53.550' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.550' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 29, N'draw', 0, CAST(N'2025-03-07T12:33:53.553' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.553' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 30, N'draw', 0, CAST(N'2025-03-07T12:33:53.560' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.560' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 31, N'draw', 0, CAST(N'2025-03-07T12:33:53.567' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.567' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 32, N'draw', 0, CAST(N'2025-03-07T12:33:53.573' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.573' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 33, N'draw', 0, CAST(N'2025-03-07T12:33:53.580' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.580' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 34, N'draw', 0, CAST(N'2025-03-07T12:33:53.587' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.587' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 35, N'draw', 0, CAST(N'2025-03-07T12:33:53.593' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.593' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 36, N'draw', 0, CAST(N'2025-03-07T12:33:53.600' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.600' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 37, N'draw', 0, CAST(N'2025-03-07T12:33:53.607' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.607' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 38, N'draw', 0, CAST(N'2025-03-07T12:33:53.613' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.613' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 39, N'draw', 0, CAST(N'2025-03-07T12:33:53.620' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.620' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 40, N'draw', 0, CAST(N'2025-03-07T12:33:53.623' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.623' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 41, N'draw', 0, CAST(N'2025-03-07T12:33:53.630' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.630' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 42, N'draw', 0, CAST(N'2025-03-07T12:33:53.640' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.640' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 43, N'draw', 0, CAST(N'2025-03-07T12:33:53.647' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.647' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 44, N'draw', 0, CAST(N'2025-03-07T12:33:53.653' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.653' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 45, N'draw', 0, CAST(N'2025-03-07T12:33:53.660' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.660' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 46, N'draw', 0, CAST(N'2025-03-07T12:33:53.667' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.667' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 47, N'draw', 0, CAST(N'2025-03-07T12:33:53.677' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.677' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 48, N'draw', 0, CAST(N'2025-03-07T12:33:53.683' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.683' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 49, N'draw', 0, CAST(N'2025-03-07T12:33:53.690' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.690' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 50, N'draw', 0, CAST(N'2025-03-07T12:33:53.697' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.697' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 51, N'draw', 0, CAST(N'2025-03-07T12:33:53.703' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.703' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 52, N'draw', 0, CAST(N'2025-03-07T12:33:53.710' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.710' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 53, N'draw', 0, CAST(N'2025-03-07T12:33:53.720' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.720' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 54, N'draw', 0, CAST(N'2025-03-07T12:33:53.727' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.727' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 55, N'draw', 0, CAST(N'2025-03-07T12:33:53.733' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.733' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 56, N'draw', 0, CAST(N'2025-03-07T12:33:53.740' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.740' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 57, N'draw', 0, CAST(N'2025-03-07T12:33:53.747' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.747' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 58, N'draw', 0, CAST(N'2025-03-07T12:33:53.753' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.753' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 59, N'draw', 0, CAST(N'2025-03-07T12:33:53.760' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.760' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 60, N'draw', 0, CAST(N'2025-03-07T12:33:53.767' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.767' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 61, N'draw', 0, CAST(N'2025-03-07T12:33:53.773' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.773' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 62, N'draw', 0, CAST(N'2025-03-07T12:33:53.780' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.780' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 63, N'draw', 0, CAST(N'2025-03-07T12:33:53.787' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.787' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 64, N'draw', 0, CAST(N'2025-03-07T12:33:53.793' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.793' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 65, N'draw', 0, CAST(N'2025-03-07T12:33:53.800' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.800' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 66, N'draw', 0, CAST(N'2025-03-07T12:33:53.807' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.807' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 67, N'draw', 0, CAST(N'2025-03-07T12:33:53.813' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.813' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 68, N'draw', 0, CAST(N'2025-03-07T12:33:53.820' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.820' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 69, N'draw', 0, CAST(N'2025-03-07T12:33:53.827' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.827' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 70, N'draw', 0, CAST(N'2025-03-07T12:33:53.833' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.833' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 71, N'draw', 0, CAST(N'2025-03-07T12:33:53.840' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.840' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 72, N'draw', 0, CAST(N'2025-03-07T12:33:53.847' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.847' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 73, N'draw', 0, CAST(N'2025-03-07T12:33:53.853' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.853' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 74, N'draw', 0, CAST(N'2025-03-07T12:33:53.860' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.860' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 75, N'draw', 0, CAST(N'2025-03-07T12:33:53.867' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.867' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 76, N'draw', 0, CAST(N'2025-03-07T12:33:53.873' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.873' AS DateTime), N'sys')
INSERT [dbo].[GameCards] ([GameId], [CardId], [Pile], [PilePosition], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 77, N'draw', 0, CAST(N'2025-03-07T12:33:53.880' AS DateTime), N'sys', CAST(N'2025-03-07T12:33:53.880' AS DateTime), N'sys')
GO
INSERT [dbo].[GameOptions] ([GameId], [PlayerAmount], [TurnTimeLimit], [ReactionTimeLimit], [AiPlayers], [UseMegaFatLady], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, 2, 60, 5, 0, 1, CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo', CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo')
INSERT [dbo].[GameOptions] ([GameId], [PlayerAmount], [TurnTimeLimit], [ReactionTimeLimit], [AiPlayers], [UseMegaFatLady], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, 2, 60, 5, 0, 1, CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo', CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo')
GO
INSERT [dbo].[GamePlayers] ([GameId], [PlayerId], [State], [Position], [HasTurn], [TurnStartMode], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, N'Timo', N'ready', 0, 0, N'', CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo', CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo')
INSERT [dbo].[GamePlayers] ([GameId], [PlayerId], [State], [Position], [HasTurn], [TurnStartMode], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, N'VettigeSwa', N'ready', 0, 0, N'', CAST(N'2025-03-07T11:43:03.647' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T11:43:03.647' AS DateTime), N'VettigeSwa')
INSERT [dbo].[GamePlayers] ([GameId], [PlayerId], [State], [Position], [HasTurn], [TurnStartMode], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, N'Timo', N'ready', 5, 0, N'', CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo', CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo')
INSERT [dbo].[GamePlayers] ([GameId], [PlayerId], [State], [Position], [HasTurn], [TurnStartMode], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, N'VettigeSwa', N'ready', 0, 0, N'', CAST(N'2025-03-07T12:18:14.823' AS DateTime), N'VettigeSwa', CAST(N'2025-03-07T12:18:14.823' AS DateTime), N'VettigeSwa')
GO
SET IDENTITY_INSERT [dbo].[Games] ON 

INSERT [dbo].[Games] ([Id], [Name], [State], [IsPublic], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (230, N'Spel van Timo', N'ongoing', 1, CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo', CAST(N'2025-03-07T11:42:55.310' AS DateTime), N'Timo')
INSERT [dbo].[Games] ([Id], [Name], [State], [IsPublic], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (231, N'Spel van Timo', N'ongoing', 1, CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo', CAST(N'2025-03-07T12:18:09.287' AS DateTime), N'Timo')
SET IDENTITY_INSERT [dbo].[Games] OFF
GO
INSERT [dbo].[Players] ([Id], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'BronstigeBarry', CAST(N'2025-02-19T11:57:44.200' AS DateTime), N'BronstigeBarry', CAST(N'2025-02-19T11:57:44.200' AS DateTime), N'BronstigeBarry')
INSERT [dbo].[Players] ([Id], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'Timo', CAST(N'2025-01-21T12:40:28.493' AS DateTime), N'Timo', CAST(N'2025-01-21T12:40:28.493' AS DateTime), N'Timo')
INSERT [dbo].[Players] ([Id], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'VettigeSwa', CAST(N'2025-02-19T11:56:03.087' AS DateTime), N'VettigeSwa', CAST(N'2025-02-19T11:56:03.087' AS DateTime), N'VettigeSwa')
INSERT [dbo].[Players] ([Id], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (N'ZatteLeo', CAST(N'2025-02-19T11:56:48.120' AS DateTime), N'ZatteLeo', CAST(N'2025-02-19T11:56:48.120' AS DateTime), N'ZatteLeo')
GO
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (0, 0, 0, 0, 1, 0, 7, 21, CAST(N'2025-01-03T10:49:08.213' AS DateTime), N'admin', CAST(N'2025-01-03T10:49:08.213' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (1, 1, 0, 0, 0, 0, 8, 19, CAST(N'2025-01-03T10:49:56.300' AS DateTime), N'admin', CAST(N'2025-01-03T10:49:56.300' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (2, 0, 8, 0, 0, 0, 9, 19, CAST(N'2025-01-03T10:50:21.460' AS DateTime), N'admin', CAST(N'2025-01-03T10:50:21.460' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (3, 1, 0, 0, 0, 0, 10, 19, CAST(N'2025-01-03T10:50:35.990' AS DateTime), N'admin', CAST(N'2025-01-03T10:50:35.990' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (4, 0, 0, 0, 0, 0, 11, 19, CAST(N'2025-01-03T10:50:51.130' AS DateTime), N'admin', CAST(N'2025-01-03T10:50:51.130' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (5, 0, 0, 0, 0, 0, 11, 18, CAST(N'2025-01-03T10:50:54.850' AS DateTime), N'admin', CAST(N'2025-01-03T10:50:54.850' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (6, 0, 0, 0, 0, 0, 11, 17, CAST(N'2025-01-03T10:50:57.303' AS DateTime), N'admin', CAST(N'2025-01-03T10:50:57.303' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (7, 1, 0, 0, 0, 0, 10, 17, CAST(N'2025-01-03T10:51:08.330' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:08.330' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (8, 0, 0, 2, 0, 0, 9, 17, CAST(N'2025-01-03T10:51:22.997' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:22.997' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (9, 0, 0, 0, 0, 0, 8, 17, CAST(N'2025-01-03T10:51:32.447' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:32.447' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (10, 1, 0, 0, 0, 0, 7, 17, CAST(N'2025-01-03T10:51:39.190' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:39.190' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (11, 0, 0, 0, 0, 0, 6, 17, CAST(N'2025-01-03T10:51:45.227' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:45.227' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (12, 1, 0, 0, 0, 0, 6, 16, CAST(N'2025-01-03T10:51:50.810' AS DateTime), N'admin', CAST(N'2025-01-03T10:51:50.810' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (13, 0, 0, 21, 0, 0, 6, 15, CAST(N'2025-01-03T10:52:09.653' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:09.653' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (14, 1, 0, 0, 0, 0, 7, 15, CAST(N'2025-01-03T10:52:18.820' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:18.820' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (15, 0, 0, 0, 0, 0, 7, 14, CAST(N'2025-01-03T10:52:23.120' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:23.120' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (16, 0, 0, 0, 0, 0, 7, 13, CAST(N'2025-01-03T10:52:25.260' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:25.260' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (17, 1, 0, 0, 0, 0, 7, 12, CAST(N'2025-01-03T10:52:32.503' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:32.503' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (18, 0, 0, 29, 0, 0, 7, 11, CAST(N'2025-01-03T10:52:51.017' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:51.017' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (19, 0, 0, 0, 0, 0, 6, 11, CAST(N'2025-01-03T10:52:59.983' AS DateTime), N'admin', CAST(N'2025-01-03T10:52:59.983' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (20, 1, 0, 0, 0, 0, 5, 11, CAST(N'2025-01-03T10:53:06.810' AS DateTime), N'admin', CAST(N'2025-01-03T10:53:06.810' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (21, 0, 13, 0, 0, 0, 5, 12, CAST(N'2025-01-03T10:53:19.213' AS DateTime), N'admin', CAST(N'2025-01-03T10:53:19.213' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (22, 0, 0, 24, 0, 0, 4, 12, CAST(N'2025-01-03T10:53:40.640' AS DateTime), N'admin', CAST(N'2025-01-03T10:53:40.640' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (23, 1, 0, 0, 0, 0, 3, 12, CAST(N'2025-01-03T10:53:52.250' AS DateTime), N'admin', CAST(N'2025-01-03T10:53:52.250' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (24, 0, 22, 0, 1, 1, 2, 9, CAST(N'2025-01-03T10:54:12.550' AS DateTime), N'admin', CAST(N'2025-01-03T10:54:12.550' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (25, 1, 0, 0, 0, 0, 3, 9, CAST(N'2025-01-03T10:54:24.943' AS DateTime), N'admin', CAST(N'2025-01-03T10:54:24.943' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (26, 0, 0, 0, 0, 0, 4, 9, CAST(N'2025-01-03T10:54:31.750' AS DateTime), N'admin', CAST(N'2025-01-03T10:54:31.750' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (27, 0, 0, 0, 0, 0, 5, 9, CAST(N'2025-01-03T10:54:34.123' AS DateTime), N'admin', CAST(N'2025-01-03T10:54:34.123' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (28, 1, 0, 0, 0, 0, 6, 9, CAST(N'2025-01-03T10:54:45.433' AS DateTime), N'admin', CAST(N'2025-01-03T10:54:45.433' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (29, 0, 18, 0, 0, 0, 7, 9, CAST(N'2025-01-03T10:55:01.327' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:01.327' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (30, 0, 0, 0, 0, 0, 8, 9, CAST(N'2025-01-03T10:55:08.603' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:08.603' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (31, 0, 0, 0, 0, 0, 9, 9, CAST(N'2025-01-03T10:55:11.143' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:11.143' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (32, 1, 0, 0, 0, 0, 9, 10, CAST(N'2025-01-03T10:55:16.900' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:16.900' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (33, 0, 0, 0, 0, 0, 9, 11, CAST(N'2025-01-03T10:55:23.013' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:23.013' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (34, 0, 0, 0, 0, 0, 9, 12, CAST(N'2025-01-03T10:55:25.860' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:25.860' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (35, 1, 0, 50, 0, 0, 9, 13, CAST(N'2025-01-03T10:55:46.583' AS DateTime), N'admin', CAST(N'2025-01-03T10:55:46.583' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (36, 0, 43, 0, 0, 0, 9, 14, CAST(N'2025-01-03T10:56:05.913' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:05.913' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (37, 0, 0, 0, 0, 0, 9, 15, CAST(N'2025-01-03T10:56:15.633' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:15.633' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (38, 1, 0, 0, 0, 0, 10, 15, CAST(N'2025-01-03T10:56:20.930' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:20.930' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (39, 0, 0, 0, 0, 0, 11, 15, CAST(N'2025-01-03T10:56:25.760' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:25.760' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (40, 1, 0, 0, 0, 0, 12, 15, CAST(N'2025-01-03T10:56:34.013' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:34.013' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (41, 0, 0, 0, 0, 0, 12, 14, CAST(N'2025-01-03T10:56:39.320' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:39.320' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (42, 1, 0, 46, 0, 0, 12, 13, CAST(N'2025-01-03T10:56:55.973' AS DateTime), N'admin', CAST(N'2025-01-03T10:56:55.973' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (43, 0, 0, 36, 0, 0, 12, 12, CAST(N'2025-01-03T10:57:18.020' AS DateTime), N'admin', CAST(N'2025-01-03T10:57:18.020' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (44, 1, 0, 0, 0, 0, 12, 11, CAST(N'2025-01-03T10:57:23.777' AS DateTime), N'admin', CAST(N'2025-01-03T10:57:23.777' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (45, 1, 0, 0, 0, 0, 13, 11, CAST(N'2025-01-03T10:57:27.920' AS DateTime), N'admin', CAST(N'2025-01-03T10:57:27.920' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (46, 0, 42, 0, 1, 2, 14, 7, CAST(N'2025-01-03T10:57:50.823' AS DateTime), N'admin', CAST(N'2025-01-03T10:57:50.823' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (47, 1, 0, 0, 0, 0, 13, 7, CAST(N'2025-01-03T10:58:02.710' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:02.710' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (48, 0, 0, 0, 0, 0, 12, 7, CAST(N'2025-01-03T10:58:08.687' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:08.687' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (49, 0, 0, 0, 0, 0, 11, 7, CAST(N'2025-01-03T10:58:12.247' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:12.247' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (50, 0, 35, 0, 0, 0, 10, 7, CAST(N'2025-01-03T10:58:24.497' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:24.497' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (51, 1, 0, 0, 0, 0, 9, 7, CAST(N'2025-01-03T10:58:30.743' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:30.743' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (52, 0, 0, 64, 0, 0, 8, 7, CAST(N'2025-01-03T10:58:47.850' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:47.850' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (53, 1, 0, 0, 0, 0, 7, 7, CAST(N'2025-01-03T10:58:55.200' AS DateTime), N'admin', CAST(N'2025-01-03T10:58:55.200' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (54, 0, 0, 0, 0, 0, 6, 7, CAST(N'2025-01-03T10:59:04.093' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:04.093' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (55, 1, 0, 0, 0, 0, 5, 7, CAST(N'2025-01-03T10:59:10.047' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:10.047' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (56, 0, 0, 0, 0, 0, 4, 7, CAST(N'2025-01-03T10:59:14.490' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:14.490' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (57, 0, 0, 0, 0, 0, 3, 7, CAST(N'2025-01-03T10:59:16.397' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:16.397' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (58, 1, 0, 0, 0, 0, 3, 6, CAST(N'2025-01-03T10:59:21.953' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:21.953' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (59, 0, 0, 0, 0, 0, 3, 5, CAST(N'2025-01-03T10:59:26.813' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:26.813' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (60, 1, 0, 0, 0, 0, 4, 5, CAST(N'2025-01-03T10:59:32.153' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:32.153' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (61, 0, 0, 0, 0, 0, 5, 5, CAST(N'2025-01-03T10:59:40.777' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:40.777' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (62, 1, 0, 69, 0, 0, 6, 5, CAST(N'2025-01-03T10:59:55.430' AS DateTime), N'admin', CAST(N'2025-01-03T10:59:55.430' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (63, 0, 0, 0, 0, 0, 7, 5, CAST(N'2025-01-03T11:00:11.080' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:11.080' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (64, 0, 52, 0, 0, 0, 8, 5, CAST(N'2025-01-03T11:00:23.450' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:23.450' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (65, 0, 0, 0, 0, 0, 9, 5, CAST(N'2025-01-03T11:00:34.217' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:34.217' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (66, 1, 0, 0, 0, 0, 10, 5, CAST(N'2025-01-03T11:00:39.440' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:39.440' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (67, 1, 0, 0, 0, 0, 11, 5, CAST(N'2025-01-03T11:00:43.040' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:43.040' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (68, 1, 0, 0, 0, 0, 11, 4, CAST(N'2025-01-03T11:00:46.360' AS DateTime), N'admin', CAST(N'2025-01-03T11:00:46.360' AS DateTime), N'admin')
INSERT [dbo].[Tiles] ([Id], [HasCard], [ArrowTarget], [ArrowSource], [IsStage], [Stage], [X], [Y], [CrDate], [CrUser], [LcDate], [LcUser]) VALUES (69, 0, 62, 0, 1, 3, 8, 2, CAST(N'2025-01-03T11:01:12.740' AS DateTime), N'admin', CAST(N'2025-01-03T11:01:12.740' AS DateTime), N'admin')
GO
USE [master]
GO
ALTER DATABASE [Mainstage] SET  READ_WRITE 
GO
