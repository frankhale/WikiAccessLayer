USE [master]
GO
/****** Object:  Database [wiki]    Script Date: 06/13/2014 16:55:47 ******/
CREATE DATABASE [wiki] ON  PRIMARY 
( NAME = N'wiki', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\wiki.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'wiki_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\wiki_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [wiki] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wiki].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wiki] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [wiki] SET ANSI_NULLS OFF
GO
ALTER DATABASE [wiki] SET ANSI_PADDING OFF
GO
ALTER DATABASE [wiki] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [wiki] SET ARITHABORT OFF
GO
ALTER DATABASE [wiki] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [wiki] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [wiki] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [wiki] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [wiki] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [wiki] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [wiki] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [wiki] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [wiki] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [wiki] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [wiki] SET  DISABLE_BROKER
GO
ALTER DATABASE [wiki] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [wiki] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [wiki] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [wiki] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [wiki] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [wiki] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [wiki] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [wiki] SET  READ_WRITE
GO
ALTER DATABASE [wiki] SET RECOVERY SIMPLE
GO
ALTER DATABASE [wiki] SET  MULTI_USER
GO
ALTER DATABASE [wiki] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [wiki] SET DB_CHAINING OFF
GO
USE [wiki]
GO
/****** Object:  Table [dbo].[tags]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
 CONSTRAINT [PK_tags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[users]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[full_name] [varchar](50) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pages]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[guid] [char](36) NOT NULL,
	[created_on] [datetime] NOT NULL,
	[modified_on] [datetime] NULL,
	[publish_on] [datetime] NULL,
	[author] [int] NOT NULL,
	[title] [varchar](255) NOT NULL,
	[body] [varchar](max) NOT NULL,
 CONSTRAINT [PK_pages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pageTags]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pageTags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[page] [int] NOT NULL,
	[tag] [int] NOT NULL,
 CONSTRAINT [PK_pageTags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comments]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[guid] [char](36) NOT NULL,
	[created_on] [datetime] NOT NULL,
	[modified_on] [datetime] NULL,
	[author] [int] NOT NULL,
	[page] [int] NOT NULL,
	[text] [varchar](max) NOT NULL,
 CONSTRAINT [PK_comments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[tagsForPage]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tagsForPage]
AS
SELECT     dbo.tags.name AS 'tag', dbo.pages.id
FROM         dbo.pages INNER JOIN
                      dbo.pageTags ON dbo.pages.id = dbo.pageTags.page INNER JOIN
                      dbo.tags ON dbo.pageTags.tag = dbo.tags.id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pages"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pageTags"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 111
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tags"
            Begin Extent = 
               Top = 6
               Left = 434
               Bottom = 96
               Right = 594
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tagsForPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tagsForPage'
GO
/****** Object:  View [dbo].[pagesWithTags]    Script Date: 06/13/2014 16:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[pagesWithTags]
AS
SELECT     dbo.pages.id, dbo.pages.created_on, dbo.pages.modified_on, dbo.pages.guid, dbo.pages.author, dbo.pages.title, dbo.pages.body, dbo.tags.name AS 'tag'
FROM         dbo.pages INNER JOIN
                      dbo.pageTags ON dbo.pages.id = dbo.pageTags.page INNER JOIN
                      dbo.tags ON dbo.pageTags.tag = dbo.tags.id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[37] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pages"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 184
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pageTags"
            Begin Extent = 
               Top = 15
               Left = 313
               Bottom = 180
               Right = 473
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tags"
            Begin Extent = 
               Top = 6
               Left = 511
               Bottom = 111
               Right = 671
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'pagesWithTags'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'pagesWithTags'
GO
/****** Object:  ForeignKey [FK_pages_users]    Script Date: 06/13/2014 16:55:48 ******/
ALTER TABLE [dbo].[pages]  WITH CHECK ADD  CONSTRAINT [FK_pages_users] FOREIGN KEY([author])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[pages] CHECK CONSTRAINT [FK_pages_users]
GO
/****** Object:  ForeignKey [FK_pageTags_page]    Script Date: 06/13/2014 16:55:48 ******/
ALTER TABLE [dbo].[pageTags]  WITH CHECK ADD  CONSTRAINT [FK_pageTags_page] FOREIGN KEY([page])
REFERENCES [dbo].[pages] ([id])
GO
ALTER TABLE [dbo].[pageTags] CHECK CONSTRAINT [FK_pageTags_page]
GO
/****** Object:  ForeignKey [FK_pageTags_tag]    Script Date: 06/13/2014 16:55:48 ******/
ALTER TABLE [dbo].[pageTags]  WITH CHECK ADD  CONSTRAINT [FK_pageTags_tag] FOREIGN KEY([tag])
REFERENCES [dbo].[tags] ([id])
GO
ALTER TABLE [dbo].[pageTags] CHECK CONSTRAINT [FK_pageTags_tag]
GO
/****** Object:  ForeignKey [FK_comments_page]    Script Date: 06/13/2014 16:55:48 ******/
ALTER TABLE [dbo].[comments]  WITH CHECK ADD  CONSTRAINT [FK_comments_page] FOREIGN KEY([page])
REFERENCES [dbo].[pages] ([id])
GO
ALTER TABLE [dbo].[comments] CHECK CONSTRAINT [FK_comments_page]
GO
/****** Object:  ForeignKey [FK_comments_users]    Script Date: 06/13/2014 16:55:48 ******/
ALTER TABLE [dbo].[comments]  WITH CHECK ADD  CONSTRAINT [FK_comments_users] FOREIGN KEY([author])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[comments] CHECK CONSTRAINT [FK_comments_users]
GO
