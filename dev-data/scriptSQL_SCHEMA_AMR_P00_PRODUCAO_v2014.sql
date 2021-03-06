USE [AMR_P00_PRODUCAO]
GO
/****** Object:  UserDefinedFunction [dbo].[fRemoveZeros]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fRemoveZeros]
(@TEXTO AS VARCHAR(30), @DIRECAO BIT)
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @RETORNO VARCHAR(30)
    IF @DIRECAO = 0 --Remover zeros a esquerda
     SET @RETORNO = SUBSTRING(@TEXTO,PATINDEX('%[a-z,1-9]%',@TEXTO),LEN(@TEXTO))
    ELSE --Remover zeros a direita
     SET @RETORNO = REVERSE(SUBSTRING(REVERSE(@TEXTO),PATINDEX('%[a-z,1-9]%',REVERSE(@TEXTO)),LEN(@TEXTO)))
    RETURN (@RETORNO)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fString]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fString] (
	@Nome varchar(250)
)
RETURNS varchar(250)
AS
BEGIN
	DECLARE @Pos tinyint = 1
	DECLARE @Ret varchar(250) = ''

WHILE (@Pos < LEN(@Nome) + 1)
  BEGIN
	IF @Pos = 1
	  BEGIN
		--FORMATA 1.LETRA DA "FRASE"
		SET @Ret += UPPER(SUBSTRING(@Nome, @Pos, 1))
	  END
	ELSE IF (SUBSTRING(@Nome, (@Pos-1), 1) = ' '
                AND SUBSTRING(@Nome, (@Pos+2), 1) <> ' ') AND (@Pos+1) <> LEN(@Nome)
	  BEGIN
		--FORMATA 1.LETRA DE "CADA INTERVALO""
		SET @Ret += UPPER(SUBSTRING(@Nome, @Pos, 1))
	  END
	ELSE
	  BEGIN
		--FORMATA CADA LETRA RESTANTE
		SET @Ret += LOWER(SUBSTRING(@Nome,@Pos, 1))
	  END

	SET @Pos += 1
  END

  RETURN @Ret
END
GO
/****** Object:  UserDefinedFunction [dbo].[fSubstringIndex2]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fSubstringIndex2]
    (
       @TEXTO NVARCHAR(200),
      @SUBSTRING_INDEX NVARCHAR(10),
       @DESPLAZAMIENTO INT
    )
    RETURNS NVARCHAR(200)
    AS

    BEGIN


        DECLARE @indiceSubstring INT
        DECLARE @RESULTADO NVARCHAR(200)
        SELECT @indiceSubstring = CHARINDEX(@SUBSTRING_INDEX,@TEXTO)

        IF @DESPLAZAMIENTO > 0
        BEGIN
            SELECT @RESULTADO=SUBSTRING(@TEXTO,@indiceSubstring+@DESPLAZAMIENTO+1,LEN(@TEXTO))
        END 
        ELSE
        BEGIN
            SELECT @RESULTADO=SUBSTRING(@TEXTO,0,@indiceSubstring-@DESPLAZAMIENTO-1)
        END 

    RETURN @RESULTADO
    END
GO
/****** Object:  UserDefinedFunction [dbo].[fSubstringIndex3]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fSubstringIndex3]
(
   @ExistingString NVARCHAR(200),
   @BreakPoint NVARCHAR(10),
   @number INT
)
RETURNS NVARCHAR(200)
AS
BEGIN
DECLARE @Count INT
DECLARE @Substring NVARCHAR(200)
DECLARE @ssubstring NVARCHAR(200)
SET @ssubstring=@ExistingString
DECLARE @scount INT
SET @scount=0
DECLARE @sscount INT
SET @sscount=0
WHILE(@number>@scount)
    BEGIN
            Select @Count=CHARINDEX(@BreakPoint,@ExistingString)
            Select @ExistingString=SUBSTRING(@ExistingString,@Count+1,LEN(@ExistingString))
            Select @scount=@scount+1 
            select @sscount=@sscount+@Count
    END

SELECT @Substring=SUBSTRING(@ssubstring,0,@sscount)

RETURN @Substring
END
GO
/****** Object:  UserDefinedFunction [dbo].[fSubtraction_Date]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fSubtraction_Date](@INI AS DATETIME, @FIM AS DATETIME)
RETURNS @TABLE TABLE(DIAS INT, MESES INT, ANOS INT) AS
BEGIN

DECLARE	@DIA_DIFF AS DECIMAL(10,2)
DECLARE	@MES_DIFF AS DECIMAL(10,2)

DECLARE	@DIA AS DECIMAL(10,2)
DECLARE	@MES AS DECIMAL(10,2)
DECLARE	@ANO AS DECIMAL(10,2)

SET	@DIA_DIFF = DATEDIFF(DAY, @INI, @FIM)
SET	@MES_DIFF = DATEDIFF(MONTH, @INI, @FIM)

SET @DIA = FLOOR(@DIA_DIFF%365.25)-FLOOR(365.25/12)*FLOOR(@MES_DIFF%12)
SET @MES = FLOOR(@MES_DIFF%12)
SET @ANO = DATEDIFF(YEAR, @INI, @FIM)

INSERT INTO @TABLE (DIAS, MESES, ANOS) VALUES (@DIA, @MES, @ANO)

RETURN

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDiaSemana]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetDiaSemana]
(@DATE AS VARCHAR(10))
RETURNS VARCHAR(14)
AS
BEGIN
    DECLARE @RETORNO VARCHAR(14)
    DECLARE @D_DATE VARCHAR (2)
    DECLARE @M_DATE VARCHAR (2)
    DECLARE @Y_DATE VARCHAR (4)
    SET @D_DATE= SUBSTRING (@DATE ,1,2)
    SET @M_DATE= SUBSTRING (@DATE ,4,2)
    SET @Y_DATE= SUBSTRING (@DATE ,7,4)
    DECLARE @DATE_ITEM DATE
    SET @DATE_ITEM = CONCAT(@Y_DATE,'-',@M_DATE,'-',@D_DATE)
    DECLARE @WEEK INT
    SET @WEEK=DATEPART(dw,@DATE_ITEM)
    SET @RETORNO=
      CASE
        WHEN @WEEK=1 THEN 'Domingo'
        WHEN @WEEK=2 THEN 'Segunda-feira'
        WHEN @WEEK=3 THEN 'Terça-feira'
        WHEN @WEEK=4 THEN 'Quarta-feira'
        WHEN @WEEK=5 THEN 'Quinta-feira'
        WHEN @WEEK=6 THEN 'Sexta-feira'
        WHEN @WEEK=7 THEN 'Sábado'
      END
    RETURN (@RETORNO)
END
GO
/****** Object:  View [dbo].[corporativo_vwEmpresas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwEmpresas] AS
SELECT M0_CODIGO AS Cod_Empresa,
        M0_NOME AS Nome_Empresa,
        M0_CODFIL AS Cod_Filial,
        M0_FILIAL AS Nome_Filial
FROM P12_PRODUCAO..SM0010
WHERE M0_CODFIL <> '02'
GO
/****** Object:  View [dbo].[processo_vwAprovFinTitulosParaAprovar]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[processo_vwAprovFinTitulosParaAprovar] AS
/*Empresa - 01*********************************************************************************************************/
SELECT

  REPLACE(vw_E.Nome_Empresa COLLATE Latin1_General_BIN, 'AMERICA', '' ) AS pagadora
	,SA2.A2_NOME AS beneficiario
	,'FI ' AS tipo
	,SE2.E2_VALOR  AS valor
	,LEFT(CONVERT(VARCHAR,CONVERT(DATE,SE2.E2_EMIS1), 105), 10) AS emissao
	,LEFT(CONVERT(VARCHAR,CONVERT(DATE,SE2.E2_VENCREA), 105), 10) AS vencimento
	,SE2.E2_FILIAL+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA AS  codigo
	,SE2.E2_HIST AS observacao
	,(CASE  SE2.E2_XPRTLIB WHEN '1' THEN 'PARA APROVAR' WHEN '2' THEN 'PARA ANALISE' END) AS status
	,'' AS selecao
	,SE2.E2_FILIAL
	,SE2.E2_PREFIXO
	,SE2.E2_NUM
	,SE2.E2_PARCELA
	,SE2.E2_TIPO
	,SE2.E2_FORNECE
	,SE2.E2_LOJA
	,SA2.A2_COD
	,SE2.E2_XPRTLIB
	,SE2.E2_STATLIB
	,SE2.E2_DATALIB
  ,vw_E.Cod_Empresa AS empresa
	FROM P12_PRODUCAO.dbo.SE2010 AS SE2
	JOIN P12_PRODUCAO.dbo.SA2010 AS SA2 ON A2_FILIAL=' ' AND SA2.A2_COD=E2_FORNECE AND SA2.A2_LOJA=SE2.E2_LOJA AND SA2.D_E_L_E_T_=' '
	JOIN AMR_P00_PRODUCAO.dbo.corporativo_vwEmpresas AS vw_E ON vw_E.Cod_Empresa+Cod_Filial='01'+E2_FILIAL
	WHERE E2_FILIAL IN('01','02')
	AND SE2.E2_SALDO>0
	AND SE2.D_E_L_E_T_=' '
	AND SE2.E2_DATALIB=''
	AND SE2.E2_XPRTLIB IN ('1','2')
GO
/****** Object:  View [dbo].[processo_vwAprovFinTitulosAprovados]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[processo_vwAprovFinTitulosAprovados] AS
/*Empresa - 01*********************************************************************************************************/
SELECT
	REPLACE(vw_E.Nome_Empresa COLLATE Latin1_General_BIN, 'AMERICA', '' ) AS pagadora
	,SA2.A2_NOME AS beneficiario
	,'FI ' AS tipo
	,FORMAT (SE2.E2_VALOR, 'c', 'pt-br')  AS valor
	,LEFT(CONVERT(VARCHAR,CONVERT(DATE,SE2.E2_EMIS1), 105), 10) AS emissao
	,LEFT(CONVERT(VARCHAR,CONVERT(DATE,SE2.E2_VENCREA), 105), 10) AS vencimento
	,SE2.E2_FILIAL+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA AS  codigo
	,SE2.E2_HIST AS observacao
	,LEFT(CONVERT(VARCHAR,CONVERT(DATE,SE2.E2_DATALIB), 105), 10) AS aprovacao
	,(CASE  SE2.E2_XPRTLIB WHEN '1' THEN 'PARA APROVAR' WHEN '2' THEN 'PARA ANALISE' WHEN '3' THEN 'APROVADO' END) AS status
	FROM P12_PRODUCAO.dbo.SE2010 AS SE2
	JOIN P12_PRODUCAO.dbo.SA2010 AS SA2 ON A2_FILIAL=' ' AND SA2.A2_COD=E2_FORNECE AND SA2.A2_LOJA=SE2.E2_LOJA AND SA2.D_E_L_E_T_=' '
	JOIN AMR_P00_PRODUCAO.dbo.corporativo_vwEmpresas AS vw_E ON vw_E.Cod_Empresa+Cod_Filial='01'+E2_FILIAL
	WHERE E2_FILIAL IN('01','02')
	AND SE2.D_E_L_E_T_=' '
	AND SE2.E2_DATALIB<>''
	AND SE2.E2_XPRTLIB='3'
GO
/****** Object:  View [dbo].[processo_vwAprovFinTitulosDocumentos]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[processo_vwAprovFinTitulosDocumentos] AS

-- Empresa 01 - Tabela SE2
SELECT vw_A.*, ACB.ACB_OBJETO documento
From processo_vwAprovFinTitulosParaAprovar AS vw_A
JOIN P12_PRODUCAO..AC9010 AS AC9 ON AC9.AC9_FILENT = vw_A.E2_FILIAL AND AC9.AC9_ENTIDA = 'SE2' AND AC9.D_E_L_E_T_ = ' '  AND AC9.AC9_CODENT = vw_A.E2_PREFIXO+vw_A.E2_NUM+vw_A.E2_PARCELA+vw_A.E2_TIPO+vw_A.E2_FORNECE+vw_A.E2_LOJA
JOIN P12_PRODUCAO..ACB010 AS ACB ON ACB.ACB_FILIAL = AC9.AC9_FILIAL  AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
-- where Numero like '%CP_SEM%'

UNION ALL 

-- Empresa 01 - Tabela SF1
SELECT vw_A.*, ACB_OBJETO documento
From processo_vwAprovFinTitulosParaAprovar vw_A
JOIN P12_PRODUCAO..AC9010 AS AC9 ON AC9_FILENT = vw_A.E2_FILIAL AND AC9.AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ = ' '  AND AC9.AC9_CODENT = vw_A.E2_NUM+vw_A.E2_PREFIXO+vw_A.E2_FORNECE+vw_A.E2_LOJA 
JOIN P12_PRODUCAO..ACB010 AS ACB ON ACB_FILIAL = AC9.AC9_FILIAL  AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
-- where Numero like '%TESTE%'

UNION ALL 

-- Empresa 01 - Tabela SC7
SELECT vw_A.*, ACB_OBJETO documento
From processo_vwAprovFinTitulosParaAprovar vw_A
JOIN P12_PRODUCAO..SF1010 AS SF1 ON SF1.F1_FILIAL=vw_A.E2_FILIAL AND SF1.F1_DOC=vw_A.E2_NUM AND F1_SERIE=vw_A.E2_PREFIXO AND F1_FORNECE=vw_A.E2_FORNECE AND F1_LOJA=vw_A.E2_LOJA AND SF1.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..SD1010 AS SD1 ON SD1.D1_FILIAL=SF1.F1_FILIAL AND SD1.D1_DOC=SF1.F1_DOC AND SD1.D1_SERIE=SF1.F1_SERIE AND SD1.D1_FORNECE=SF1.F1_FORNECE AND SD1.D1_LOJA=SF1.F1_LOJA AND SD1.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..SC7010 AS SC7 ON SC7.C7_FILIAL=SD1.D1_FILIAL AND SC7.C7_NUM=D1_PEDIDO AND SC7.C7_ITEM=SD1.D1_ITEMPC AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9010 AS AC9 ON AC9.AC9_FILENT = SC7.C7_FILIAL AND AC9.AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ = ' '  AND AC9.AC9_CODENT = SC7.C7_FILIAL+SC7.C7_NUM+SC7.C7_ITEM 
JOIN P12_PRODUCAO..ACB010 AS ACB ON ACB.ACB_FILIAL = AC9.AC9_FILIAL  AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
GO
/****** Object:  UserDefinedFunction [dbo].[fSplit]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fSplit] (@string varchar(max), @separador char(1))
returns table as return
    with a as (
        select
            id = 1,
            len_string = len(@string) + 1,
            ini = 1,
            fim = coalesce(nullif(charindex(@separador, @string, 1), 0), len(@string) + 1),
            elemento = ltrim(rtrim(substring(@string, 1, coalesce(nullif(charindex(@separador, @string, 1), 0), len(@string) + 1)-1)))
        union all
        select
            id + 1,
            len(@string) + 1,
            convert(int, fim) + 1,
            coalesce(nullif(charindex(@separador, @string, fim + 1), 0), len_string),
            ltrim(rtrim(substring(@string, fim + 1, coalesce(nullif(charindex(@separador, @string, fim + 1), 0), len_string)-fim-1)))
        from a where fim < len_string)
    select id, elemento from a
    -- incluir with option (maxrecursion 0) na chamada da FC para strings com mais de 100 elementos
go
GO
/****** Object:  UserDefinedFunction [dbo].[fSubstringIndex]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fSubstringIndex]
(
    @str NVARCHAR(4000),
    @delim NVARCHAR(1),
    @count INT
)
RETURNS NVARCHAR(4000)
WITH SCHEMABINDING
BEGIN
    DECLARE @XmlSourceString XML;
    SET @XmlSourceString = (SELECT N'<root><row>' + REPLACE( (SELECT @str AS '*' FOR XML PATH('')) , @delim, N'</row><row>' ) + N'</row></root>');

    RETURN STUFF
    (
        ((
            SELECT  @delim + x.XmlCol.value(N'(text())[1]', N'NVARCHAR(4000)') AS '*'
            FROM    @XmlSourceString.nodes(N'(root/row)[position() <= sql:variable("@count")]') x(XmlCol)
            FOR XML PATH(N''), TYPE
        ).value(N'.', N'NVARCHAR(4000)')),
        1, 1, N''
    );
END
GO
/****** Object:  Table [dbo].[colaborador_documento]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[colaborador_documento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [varchar](50) NULL,
	[data_inclusao] [varchar](250) NULL,
	[id_usuario] [int] NULL,
	[documento] [varchar](250) NULL,
	[id_remetente] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[colaborador_notificacao]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[colaborador_notificacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cod_tipo] [varchar](50) NULL,
	[data] [varchar](50) NULL,
	[id_status] [int] NULL,
	[id_usuario] [int] NULL,
	[id_path] [int] NULL,
	[id_msg] [int] NULL,
	[id_status_count] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_email_disparo]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_email_disparo](
	[email] [varchar](50) NULL,
	[tipo_disparo] [int] NULL,
	[nome] [varchar](20) NULL,
	[id_permissao] [int] NULL,
	[id_usuario] [int] NULL,
	[data] [datetime] NULL,
	[sobrenome ] [varchar](20) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_financeiro]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_financeiro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[numHistorico] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_geral_diretorio]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_geral_diretorio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[diretorio] [text] NULL,
	[data] [date] NULL,
	[descricao] [varchar](50) NULL,
	[ref] [varchar](5) NULL,
	[cod] [varchar](2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_reeembolso_tipo_email]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_reeembolso_tipo_email](
	[id] [int] NULL,
	[tipo] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_reembolso]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_reembolso](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dataLimite] [varchar](2) NULL,
	[data] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configuracao_reembolso_cotas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuracao_reembolso_cotas](
	[id_contexto] [varchar](5) NULL,
	[cota] [decimal](18, 2) NULL,
	[descricao] [varchar](100) NULL,
	[data] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[corporativo_departamento]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corporativo_departamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](200) NOT NULL,
	[descricao] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[financeiro_mensagem]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[financeiro_mensagem](
	[id_titulo] [varchar](50) NULL,
	[mensagem] [text] NULL,
	[tipo] [int] NULL,
	[id_usuario] [int] NULL,
	[status] [int] NULL,
	[data] [datetime] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_email]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_email](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_msg] [int] NULL,
	[id_contexto] [varchar](6) NULL,
	[id_usuario_de] [int] NULL,
	[id_usuario_para] [int] NULL,
	[data] [datetime] NULL,
	[tipo] [int] NULL,
	[status] [int] NULL,
	[data_envio] [datetime] NULL,
	[acao] [varchar](6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_financeiro_acao]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_financeiro_acao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_titulo] [varchar](50) NULL,
	[status] [int] NULL,
	[data] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_reembolso_acao]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_reembolso_acao](
	[id_reembolso] [varchar](6) NULL,
	[data] [datetime] NULL,
	[id_usuario] [int] NULL,
	[status_de] [int] NULL,
	[tipo] [int] NULL,
	[status_para] [int] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_servicos]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_servicos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [int] NOT NULL,
	[funcao] [varchar](200) NOT NULL,
	[parametros] [text] NULL,
	[hora] [char](19) NOT NULL,
	[duracao] [int] NOT NULL,
	[ambiente] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paginas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paginas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[permissao] [char](36) NOT NULL,
	[nome] [varchar](100) NOT NULL,
	[local] [varchar](500) NULL,
	[icone] [varchar](50) NULL,
	[desenvolvimento] [bit] NOT NULL,
	[menu] [bit] NOT NULL,
	[pai] [int] NULL,
	[ordem] [int] NULL,
	[nivel] [int] NULL,
	[verificar] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissoes_contaf]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissoes_contaf](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_conta] [int] NOT NULL,
	[id_permissao] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissoes_contap]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissoes_contap](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_conta] [int] NOT NULL,
	[id_permissao] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissoes_funcao]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissoes_funcao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[caminho] [varchar](250) NULL,
	[classe] [varchar](250) NULL,
	[funcao] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissoes_nusuariof]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissoes_nusuariof](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [int] NOT NULL,
	[id_permissao] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissoes_nusuariop]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissoes_nusuariop](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [int] NOT NULL,
	[id_permissao] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_aprovador_grupo]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_aprovador_grupo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](50) NULL,
	[descricao] [varchar](250) NULL,
	[id_departamento] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_aprovador_usuario]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_aprovador_usuario](
	[id_grupo] [int] NULL,
	[id_usuario] [int] NULL,
	[ordem] [int] NULL,
	[alcada_inicio] [decimal](18, 2) NULL,
	[alcada_fim] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_guia_aprovador]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_guia_aprovador](
	[id_reeembolso] [char](6) NOT NULL,
	[data_base] [varchar](7) NULL,
	[total_mes] [varchar](20) NULL,
	[inicio_aprov] [int] NULL,
	[fim_aprov] [int] NULL,
	[data_envio] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_itens]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_itens](
	[id] [int] NULL,
	[data_item] [varchar](50) NULL,
	[id_reembolso_solicitacao] [int] NULL,
	[id_cliente] [varchar](9) NULL,
	[id_natureza] [varchar](10) NULL,
	[id_ccusto] [varchar](50) NULL,
	[valor] [varchar](50) NULL,
	[observacao] [varchar](200) NULL,
	[documento] [varchar](200) NULL,
	[id_reembolso] [char](6) NULL,
	[desconto] [varchar](50) NULL,
	[total] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_limites]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_limites](
	[id_natureza] [varchar](10) NULL,
	[limite] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_mensagem]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_mensagem](
	[id_reembolso] [varchar](6) NULL,
	[mensagem] [text] NULL,
	[tipo] [int] NULL,
	[id_usuario] [int] NULL,
	[status] [int] NULL,
	[data] [datetime] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_solicitacao]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_solicitacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [int] NULL,
	[data_inclusao] [varchar](100) NULL,
	[data_envio] [varchar](100) NULL,
	[data_edicao] [varchar](100) NULL,
	[id_tipo_despesa] [int] NULL,
	[id_status] [int] NULL,
	[titulo_evento] [varchar](200) NULL,
	[id_empresa] [int] NULL,
	[mensagem_status] [bit] NULL,
	[mensagem] [varchar](300) NULL,
	[id_format] [char](8) NULL,
	[id_protheus] [varchar](6) NULL,
	[data_aprov] [varchar](100) NULL,
	[data_aprov_protheus] [varchar](100) NULL,
	[data_vencimento] [varchar](100) NULL,
	[data_base] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_status]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reembolso_tipo_despesa]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reembolso_tipo_despesa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_usuario]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_usuario](
	[id_temp] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [varchar](50) NOT NULL,
	[nome] [varchar](50) NOT NULL,
	[conta] [int] NULL,
	[senha] [char](50) NOT NULL,
	[ativo] [int] NULL,
	[sobrenome] [varchar](20) NULL,
	[cpf] [varchar](11) NOT NULL,
	[id_grupo] [int] NULL,
	[data_ativacao] [varchar](100) NULL,
	[data_registro] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario_ccusto]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario_ccusto](
	[id_usuario] [int] NULL,
	[id_ccusto] [varchar](9) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario_status]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario_status](
	[id] [int] NULL,
	[status] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[corporativo_vwCcustos]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwCcustos] AS
SELECT CTT_CUSTO AS Codigo,
       CTT_DESC01 AS Descricao
FROM P12_PRODUCAO..CTT010
WHERE CTT_FILIAL = '  '
AND D_E_L_E_T_ = ''
AND CTT_BLOQ = '2'
and LEN(CTT_CUSTO) > 4
GO
/****** Object:  View [dbo].[corporativo_vwClientes]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwClientes] AS
SELECT CTD_ITEM AS Codigo,
	  ISNULL((CASE WHEN A1_NREDUZ = '' THEN A1_NOME ELSE A1_NREDUZ END),CTD_DESC01) AS Descricao
FROM P12_PRODUCAO..CTD010 CTD
LEFT JOIN P12_PRODUCAO..SA1010 SA1 ON 'C'+A1_COD+A1_LOJA = CTD_ITEM AND SA1.D_E_L_E_T_ = '' 
WHERE CTD_FILIAL = '  '
AND CTD.D_E_L_E_T_ = ''
AND CTD_BLOQ = '2'
AND CTD_ITEM LIKE 'C%'

UNION ALL

SELECT CTD_ITEM AS Codigo,
       CTD_DESC01 AS Descricao
FROM P12_PRODUCAO..CTD010 CTD
WHERE CTD_FILIAL = '  '
AND CTD.D_E_L_E_T_ = ''
AND CTD_BLOQ = '2'
AND CTD_ITEM LIKE 'P%'
GO
/****** Object:  View [dbo].[corporativo_vwDespesas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwDespesas] AS

SELECT B1_COD AS Codigo, RTRIM(B1_DESC) AS Descricao , 'S' Tipo FROM P12_PRODUCAO..SB1010  WHERE B1_FILIAL = '  ' AND D_E_L_E_T_ = ' ' AND B1_COD IN (                 '300000000000088','300000000000093','300000000000095','300000000000091','300000000000013','300000000000089','300000000000094','300000000000090','300000000000075','300000000000092','300000000000060','300000000000061','500000000000306')
UNION ALL 
SELECT B1_COD AS Codigo, RTRIM(B1_DESC) AS Descricao , 'R' Tipo FROM P12_PRODUCAO..SB1010  WHERE B1_FILIAL = '  ' AND D_E_L_E_T_ = ' ' AND B1_COD IN (                 '300000000000088','300000000000093','300000000000095','300000000000091','300000000000013','300000000000089','300000000000094','300000000000090','300000000000075','300000000000092','300000000000060','300000000000061','500000000000306')
UNION ALL 
SELECT B1_COD AS Codigo, RTRIM(B1_DESC) AS Descricao , 'A' Tipo FROM P12_PRODUCAO..SB1010  WHERE B1_FILIAL = '  ' AND D_E_L_E_T_ = ''  AND B1_COD IN ('300000000000071')

GO
/****** Object:  View [dbo].[corporativo_vwFuncionarios]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwFuncionarios] AS
SELECT * 
FROM [P12_PRODUCAO].[dbo].[SA2010]
GO
/****** Object:  View [dbo].[corporativo_vwNaturezas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[corporativo_vwNaturezas] AS
--ALTER VIEW vwProdutos AS
SELECT ED_CODIGO AS Codigo,
       RTRIM(ED_DESCRIC) AS Descricao
FROM P12_PRODUCAO.dbo.SED010
WHERE ED_FILIAL = '  '
AND D_E_L_E_T_ = ''
-- and ED_DESCRIC LIKE '%EVENTO%'
AND ED_CODIGO IN
 ('20003','20014','18012','20002','20010','20006','20012','20009','20013','20005','17001','20004','20007','21007')
GO
/****** Object:  View [dbo].[processo_vwAprovFinHistoricoPagamentos]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[processo_vwAprovFinHistoricoPagamentos] AS
  SELECT
     REPLACE(SM.M0_NOME,'AMERICA','') AS pagadora
    ,CONVERT(VARCHAR(10),CONVERT(DATE,E5_DATA,105),105) AS  data
    ,A2.A2_NOME AS beneficiario
    ,E5_TIPO AS tipo
    ,FORMAT (E5_VALOR, 'c', 'pt-br') as valor
    ,RTRIM(ED_DESCRIC) AS natureza
    ,E5_HISTOR AS observacoes
    ,A2_COD
  FROM [P12_PRODUCAO].[dbo].[SE5010]
    LEFT JOIN [P12_PRODUCAO].[dbo].[SED010] AS ED ON ED_CODIGO=E5_NATUREZ
    LEFT JOIN [P12_PRODUCAO].[dbo].[SA2010] AS A2 ON A2.A2_COD = E5_FORNECE
    LEFT JOIN [P12_PRODUCAO].[dbo].[SM0010] AS SM ON SM.M0_CODIGO+M0_CODFIL='01'+A2.A2_LOJA
  WHERE E5_RECPAG='P'
GO
/****** Object:  View [dbo].[processo_vwAprovFinTituloDocumentos]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- SELECT * FROM vwAprovDocumentos

CREATE VIEW [dbo].[processo_vwAprovFinTituloDocumentos] AS

/* EMPRESA 01 **************************************************************************************************** */
SELECT '01'+CR_FILIAL empresa,CR_NUM numero, CR_TIPO tipo, ACB_OBJETO arquivo 
FROM P12_PRODUCAO..SCR010   SCR
JOIN P12_PRODUCAO..SE2010   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9010   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB010   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
--AND CR_TIPO = 'FI'
--AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '01'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, ACB_OBJETO Arquivo 
FROM P12_PRODUCAO..SCR010   SCR
JOIN P12_PRODUCAO..SC7010   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9010   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB010   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
--AND CR_TIPO = 'PC'
--AND CR_STATUS IN ('01','02','03')

/*
/* EMPRESA 02 **************************************************************************************************** */
UNION ALL
SELECT '02'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co02\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR020   SCR
JOIN P12_PRODUCAO..SE2020   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9020   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB020   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '02'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co02\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR020   SCR
JOIN P12_PRODUCAO..SC7020   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9020   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB020   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'PC'
AND CR_STATUS IN ('01','02','03')

/* EMPRESA 03 **************************************************************************************************** */
UNION ALL
SELECT '03'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co03\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR030   SCR
JOIN P12_PRODUCAO..SE2030   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9030   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB030   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '03'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co03\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR030   SCR
JOIN P12_PRODUCAO..SC7030   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9030   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB030   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'PC'
AND CR_STATUS IN ('01','02','03')

/* EMPRESA 04 **************************************************************************************************** */
UNION ALL
SELECT '04'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co04\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR040   SCR
JOIN P12_PRODUCAO..SE2040   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9040   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB040   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '04'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co04\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR040   SCR
JOIN P12_PRODUCAO..SC7040   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9040   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB040   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')

/* EMPRESA 05 **************************************************************************************************** */
UNION ALL
SELECT '05'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co05\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR050   SCR
JOIN P12_PRODUCAO..SE2050   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9050   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB050   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '05'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co05\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR050   SCR
JOIN P12_PRODUCAO..SC7050   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9050   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB050   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'PC'
AND CR_STATUS IN ('01','02','03')



/* EMPRESA 06 **************************************************************************************************** */
UNION ALL
SELECT '06'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co06\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR060   SCR
JOIN P12_PRODUCAO..SE2060   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9060   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB060   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '06'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co06\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR060   SCR
JOIN P12_PRODUCAO..SC7060   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9060   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB060   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'PC'
AND CR_STATUS IN ('01','02','03')




/* EMPRESA 07 **************************************************************************************************** */
UNION ALL
SELECT '07'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co07\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR070   SCR
JOIN P12_PRODUCAO..SE2070   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9070   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB070   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '07'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co07\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR070   SCR
JOIN P12_PRODUCAO..SC7070   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9070   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB070   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')





/* EMPRESA 08 **************************************************************************************************** */
UNION ALL
SELECT '08'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co08\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR080   SCR
JOIN P12_PRODUCAO..SE2080   SE2 ON E2_FILIAL = CR_FILIAL AND E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = CR_NUM /*AND E2_EMIS1 = CR_EMISSAO*/ AND SE2.D_E_L_E_T_ <> '*'
JOIN P12_PRODUCAO..AC9080   AC9 ON AC9_FILENT = E2_FILIAL AND AC9_ENTIDA = 'SF1' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA
JOIN P12_PRODUCAO..ACB080   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
UNION ALL 
SELECT '08'+CR_FILIAL Cod_Empresa,CR_NUM Numero, CR_TIPO Tipo, 'C:\Totvs\Microsiga\Protheus11\Protheus_Data\dirdoc\co08\shared\'+RTRIM(ACB_OBJETO) Arquivo 
FROM P12_PRODUCAO..SCR080   SCR
JOIN P12_PRODUCAO..SC7080   SC7 ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND SC7.D_E_L_E_T_=' '
JOIN P12_PRODUCAO..AC9080   AC9 ON AC9_FILENT = C7_FILIAL AND AC9_ENTIDA = 'SC7' AND AC9.D_E_L_E_T_ <> '*' AND AC9_CODENT = C7_FILIAL+C7_NUM+C7_ITEM
JOIN P12_PRODUCAO..ACB080   ACB ON ACB_FILIAL = AC9_FILIAL  AND ACB_CODOBJ = AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'
WHERE SCR.D_E_L_E_T_ <> '*'
AND CR_TIPO = 'FI'
AND CR_STATUS IN ('01','02','03')
*/

GO
/****** Object:  View [dbo].[processo_vwAprovFinTitulosItens]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[processo_vwAprovFinTitulosItens] AS
/*Empresa - 01*********************************************************************************************************/
SELECT
	 SD1.D1_ITEM AS item
	,SE2.E2_NUM AS numero
	,SE2.E2_FILIAL+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA AS codigo
	,SB1.B1_DESC AS produto
	,FORMAT (SD1.D1_TOTAL - SD1.D1_VALDESC, 'c', 'pt-br')  AS valor
FROM P12_PRODUCAO..SE2010 AS SE2
JOIN P12_PRODUCAO..SA2010 SA2 ON A2_FILIAL=' ' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND SA2.D_E_L_E_T_=' '
LEFT JOIN P12_PRODUCAO..SF1010 AS SF1 ON F1_FILIAL=E2_FILIAL AND F1_DOC=E2_NUM AND F1_SERIE=E2_PREFIXO AND F1_FORNECE=E2_FORNECE AND F1_LOJA=E2_LOJA AND SF1.D_E_L_E_T_=' '
LEFT JOIN P12_PRODUCAO..SD1010 AS SD1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=D1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_=' '
LEFT JOIN P12_PRODUCAO..SB1010 AS SB1 ON B1_FILIAL=' ' AND B1_COD=D1_COD AND SB1.D_E_L_E_T_=' '
WHERE SE2.E2_FILIAL IN('01','02')
AND SE2.E2_SALDO > 0
AND SE2.D_E_L_E_T_=' '
AND SE2.E2_DATALIB=' '
GO
/****** Object:  View [dbo].[vwEmpresas]    Script Date: 14-Jan-19 12:23:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwEmpresas] AS
SELECT  dbo.fRemoveZeros(M0_CODIGO,0) AS Cod_Empresa,
        M0_NOME AS Nome_Empresa,
        M0_CODFIL AS Cod_Filial,
        M0_FILIAL AS Nome_Filial
FROM P12_PRODUCAO..SM0010
GO
SET IDENTITY_INSERT [dbo].[colaborador_notificacao] ON 

INSERT [dbo].[colaborador_notificacao] ([id], [cod_tipo], [data], [id_status], [id_usuario], [id_path], [id_msg], [id_status_count]) VALUES (1, N'RD', N'2018-09-02', 1, 1, 1, 1, 0)
INSERT [dbo].[colaborador_notificacao] ([id], [cod_tipo], [data], [id_status], [id_usuario], [id_path], [id_msg], [id_status_count]) VALUES (2, N'DC', N'2018-09-02', 1, 1, 2, 2, 0)
SET IDENTITY_INSERT [dbo].[colaborador_notificacao] OFF
SET IDENTITY_INSERT [dbo].[configuracao_email_disparo] ON 

INSERT [dbo].[configuracao_email_disparo] ([email], [tipo_disparo], [nome], [id_permissao], [id_usuario], [data], [sobrenome ], [id]) VALUES (N'emptecnologia.contato@gmail.com', 500, N'Reg-Usr-RGT1', 1, 2, CAST(N'2019-01-11T20:22:22.303' AS DateTime), NULL, 1)
INSERT [dbo].[configuracao_email_disparo] ([email], [tipo_disparo], [nome], [id_permissao], [id_usuario], [data], [sobrenome ], [id]) VALUES (N'brunobrito.contato@gmail.com', 500, N'Reg-Usr-RGT2', 1, 2, CAST(N'2019-01-11T20:22:22.310' AS DateTime), N'Colaborador', 2)
INSERT [dbo].[configuracao_email_disparo] ([email], [tipo_disparo], [nome], [id_permissao], [id_usuario], [data], [sobrenome ], [id]) VALUES (N'emptecnologia.contato@gmail.com', 502, N'Atv-Usr-ATV1', 1, 2, CAST(N'2019-01-11T20:22:22.307' AS DateTime), NULL, 3)
INSERT [dbo].[configuracao_email_disparo] ([email], [tipo_disparo], [nome], [id_permissao], [id_usuario], [data], [sobrenome ], [id]) VALUES (N'brunobrito.contato@gmail.com', 400, N'Apv-Fin-APF1', 1, 2, CAST(N'2019-01-11T20:22:22.310' AS DateTime), N'Colaborador', 4)
INSERT [dbo].[configuracao_email_disparo] ([email], [tipo_disparo], [nome], [id_permissao], [id_usuario], [data], [sobrenome ], [id]) VALUES (N'brunobrito.contato@gmail.com', 410, N'Det-Fin-DTF1', 1, 2, CAST(N'2019-01-11T20:22:22.310' AS DateTime), N'Colaborador', 5)
SET IDENTITY_INSERT [dbo].[configuracao_email_disparo] OFF
SET IDENTITY_INSERT [dbo].[configuracao_financeiro] ON 

INSERT [dbo].[configuracao_financeiro] ([id], [numHistorico]) VALUES (1, 5)
SET IDENTITY_INSERT [dbo].[configuracao_financeiro] OFF
SET IDENTITY_INSERT [dbo].[configuracao_geral_diretorio] ON 

INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (1, N'http://localhost/workspace_php/producao/americaportal/img/user/', CAST(N'2019-01-09' AS Date), N'Imagens do Usuario', N'dir01', N'00')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (2, N'http://localhost/workspace_php/producao/americaportal/files/comp/', CAST(N'2019-01-09' AS Date), N'Comprovantes de Reembolsos', N'dir02', N'00')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (3, N'http://localhost/workspace_php/producao/americaportal/files/doc/', CAST(N'2019-01-09' AS Date), N'Documentos Compartilhados', N'dir03', N'00')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (4, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co01/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa01', N'emp01', N'01')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (5, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co02/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa02', N'emp02', N'02')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (6, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co03/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa03', N'emp03', N'03')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (7, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co04/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa04', N'emp04', N'04')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (8, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co05/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa05', N'emp05', N'05')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (9, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co06/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa06', N'emp06', N'06')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (10, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co07/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa07', N'emp07', N'07')
INSERT [dbo].[configuracao_geral_diretorio] ([id], [diretorio], [data], [descricao], [ref], [cod]) VALUES (11, N'C:/Totvs/Microsiga/Protheus11/Protheus_Data/dirdoc/co08/shared/', CAST(N'2019-01-09' AS Date), N'Documentos Protheus Empresa08', N'emp08', N'08')
SET IDENTITY_INSERT [dbo].[configuracao_geral_diretorio] OFF
INSERT [dbo].[configuracao_reeembolso_tipo_email] ([id], [tipo]) VALUES (500, N'Usuario registrado')
INSERT [dbo].[configuracao_reeembolso_tipo_email] ([id], [tipo]) VALUES (502, N'Usuário ativado')
INSERT [dbo].[configuracao_reeembolso_tipo_email] ([id], [tipo]) VALUES (400, N'Títulos Aprovados')
INSERT [dbo].[configuracao_reeembolso_tipo_email] ([id], [tipo]) VALUES (410, N'Mais Detalhes de Títulos')
SET IDENTITY_INSERT [dbo].[configuracao_reembolso] ON 

INSERT [dbo].[configuracao_reembolso] ([id], [dataLimite], [data]) VALUES (1, N'10', CAST(N'2019-01-09' AS Date))
INSERT [dbo].[configuracao_reembolso] ([id], [dataLimite], [data]) VALUES (4, N'3', CAST(N'2019-01-09' AS Date))
INSERT [dbo].[configuracao_reembolso] ([id], [dataLimite], [data]) VALUES (5, N'5', CAST(N'2019-01-04' AS Date))
SET IDENTITY_INSERT [dbo].[configuracao_reembolso] OFF
INSERT [dbo].[configuracao_reembolso_cotas] ([id_contexto], [cota], [descricao], [data]) VALUES (N'20002', CAST(4.20 AS Decimal(18, 2)), N'Natureza - Valor pago por km percorrido', CAST(N'2019-01-09T04:47:48.310' AS DateTime))
SET IDENTITY_INSERT [dbo].[contas] ON 

INSERT [dbo].[contas] ([id], [nome]) VALUES (1, N'Master')
INSERT [dbo].[contas] ([id], [nome]) VALUES (2, N'Recursos Humanos')
INSERT [dbo].[contas] ([id], [nome]) VALUES (3, N'Financeiro')
INSERT [dbo].[contas] ([id], [nome]) VALUES (5, N'Colaborador')
INSERT [dbo].[contas] ([id], [nome]) VALUES (6, N'Recursos humanos II')
SET IDENTITY_INSERT [dbo].[contas] OFF
SET IDENTITY_INSERT [dbo].[corporativo_departamento] ON 

INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (1, N'ADM', N'Administrativo')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (2, N'TRA', N'Trading')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (3, N'BAC', N'Back Office')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (4, N'COM', N'Comercial')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (5, N'GES', N'Gestao')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (6, N'EFE', N'Eficiencia Energetica')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (12, N'MKT', N'Marketing')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (13, N'POR', N'Portifolio')
INSERT [dbo].[corporativo_departamento] ([id], [codigo], [descricao]) VALUES (14, N'JUR', N'Juridico')
SET IDENTITY_INSERT [dbo].[corporativo_departamento] OFF
SET IDENTITY_INSERT [dbo].[financeiro_mensagem] ON 

INSERT [dbo].[financeiro_mensagem] ([id_titulo], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'01   000003671 NF 00006001', N'Minha Mensagem de solicitação de mais detalhes sobre o título



Att, Aprovador A1-G1', 1, 3, 410, CAST(N'2019-01-13T02:22:47.567' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[financeiro_mensagem] OFF
SET IDENTITY_INSERT [dbo].[log_email] ON 

INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (1, 0, N'N/A', 0, 82, NULL, 1, 501, CAST(N'2019-01-12T22:52:06.217' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (2, 0, N'N/A', 0, 2, NULL, 1, 500, CAST(N'2019-01-12T22:52:06.223' AS DateTime), N'E1CRGT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (3, 0, N'N/A', 0, 82, NULL, 1, 501, CAST(N'2019-01-12T23:04:11.553' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (5, 0, N'N/A', 0, 3, NULL, 1, 500, CAST(N'2019-01-12T23:04:12.373' AS DateTime), N'E1CRGT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (6, 0, N'N/A', 0, 82, NULL, 1, 501, CAST(N'2019-01-12T23:05:43.640' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (8, 0, N'N/A', 0, 4, NULL, 1, 500, CAST(N'2019-01-12T23:05:44.527' AS DateTime), N'E1CRGT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (10, 0, N'N/A', 0, 82, NULL, 1, 501, CAST(N'2019-01-12T23:53:40.550' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (14, 0, N'N/A', 0, 4, NULL, 1, 502, CAST(N'2019-01-13T00:02:24.620' AS DateTime), N'E2CATV')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (17, 0, N'N/A', 0, 4, NULL, 1, 503, CAST(N'2019-01-13T00:06:59.773' AS DateTime), N'E3CGRP')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (19, 0, N'N/A', 0, 2, NULL, 1, 503, CAST(N'2019-01-13T00:12:11.637' AS DateTime), N'E3CGRP')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (21, 0, N'N/A', 0, 5, NULL, 1, 503, CAST(N'2019-01-13T00:13:28.553' AS DateTime), N'E3CGRP')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (22, 0, N'N/A', 0, 82, NULL, 1, 501, CAST(N'2019-01-13T00:18:23.270' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (27, 45, N'RD0002', 2, 3, CAST(N'2019-01-13T01:32:49.360' AS DateTime), 2, 110, NULL, NULL)
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (28, 46, N'RD0002', 3, 6, CAST(N'2019-01-13T01:39:32.323' AS DateTime), 1, 210, NULL, NULL)
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (29, 47, N'RD0002', 2, 3, CAST(N'2019-01-13T01:43:50.803' AS DateTime), 2, 110, NULL, NULL)
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (30, 48, N'RD0002', 3, 6, CAST(N'2019-01-13T02:02:25.053' AS DateTime), 1, 210, NULL, NULL)
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (31, 1, N'N/A', 3, 2, NULL, 1, 410, CAST(N'2019-01-13T02:22:48.713' AS DateTime), N'E12FDT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (9, 0, N'N/A', 0, 2, NULL, 1, 502, CAST(N'2019-01-12T23:52:11.997' AS DateTime), N'E2CATV')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (4, 0, N'N/A', 0, 10, NULL, 1, 501, CAST(N'2019-01-12T23:04:12.363' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (7, 0, N'N/A', 0, 10, NULL, 1, 501, CAST(N'2019-01-12T23:05:44.517' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (12, 0, N'N/A', 0, 5, NULL, 1, 500, CAST(N'2019-01-12T23:53:41.410' AS DateTime), N'E1CRGT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (24, 0, N'N/A', 0, 6, NULL, 1, 500, CAST(N'2019-01-13T00:18:24.133' AS DateTime), N'E1CRGT')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (11, 0, N'N/A', 0, 10, NULL, 1, 501, CAST(N'2019-01-12T23:53:41.397' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (13, 0, N'N/A', 0, 3, NULL, 1, 502, CAST(N'2019-01-13T00:02:06.330' AS DateTime), N'E2CATV')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (15, 0, N'N/A', 0, 5, NULL, 1, 502, CAST(N'2019-01-13T00:02:48.707' AS DateTime), N'E2CATV')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (16, 0, N'N/A', 0, 3, NULL, 1, 503, CAST(N'2019-01-13T00:06:58.927' AS DateTime), N'E3CGRP')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (18, 0, N'N/A', 0, 3, NULL, 1, 503, CAST(N'2019-01-13T00:12:10.753' AS DateTime), N'E3CGRP')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (23, 0, N'N/A', 0, 10, NULL, 1, 501, CAST(N'2019-01-13T00:18:24.127' AS DateTime), N'E0ADRG')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (25, 0, N'N/A', 0, 6, NULL, 1, 502, CAST(N'2019-01-13T00:22:11.717' AS DateTime), N'E2CATV')
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (26, 44, N'RD0003', 3, 6, CAST(N'2019-01-13T01:24:35.840' AS DateTime), 1, 200, NULL, NULL)
INSERT [dbo].[log_email] ([id], [id_msg], [id_contexto], [id_usuario_de], [id_usuario_para], [data], [tipo], [status], [data_envio], [acao]) VALUES (20, 0, N'N/A', 0, 4, NULL, 1, 503, CAST(N'2019-01-13T00:13:27.723' AS DateTime), N'E3CGRP')
SET IDENTITY_INSERT [dbo].[log_email] OFF
SET IDENTITY_INSERT [dbo].[log_reembolso_acao] ON 

INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0001', CAST(N'2019-01-13T00:51:19.607' AS DateTime), 6, -2, 1, -1, 1)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T00:55:08.223' AS DateTime), 6, -2, 1, -1, 2)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0003', CAST(N'2019-01-13T00:56:02.613' AS DateTime), 6, -2, 1, -1, 3)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0001', CAST(N'2019-01-13T01:22:43.197' AS DateTime), 3, 0, 2, 100, 7)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:23:33.143' AS DateTime), 3, 0, 2, 1, 8)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0003', CAST(N'2019-01-13T01:24:35.897' AS DateTime), 3, 0, 2, 200, 9)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:32:49.403' AS DateTime), 2, 1, 2, 110, 10)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:39:32.353' AS DateTime), 3, 110, 2, 210, 11)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:40:57.353' AS DateTime), 6, 210, 1, -1, 12)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:41:10.770' AS DateTime), 6, -1, 1, 0, 13)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:42:15.360' AS DateTime), 3, 0, 2, 1, 14)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:43:50.837' AS DateTime), 2, 1, 2, 110, 15)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T02:02:25.120' AS DateTime), 3, 110, 2, 210, 16)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T02:04:12.973' AS DateTime), 6, 210, 1, -1, 17)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T02:04:23.933' AS DateTime), 6, -1, 1, 0, 18)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0001', CAST(N'2019-01-13T01:11:28.830' AS DateTime), 6, -1, 1, 0, 4)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T02:05:01.307' AS DateTime), 3, 0, 2, 1, 19)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T01:11:48.283' AS DateTime), 6, -1, 1, 0, 5)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0003', CAST(N'2019-01-13T01:11:55.040' AS DateTime), 6, -1, 1, 0, 6)
INSERT [dbo].[log_reembolso_acao] ([id_reembolso], [data], [id_usuario], [status_de], [tipo], [status_para], [id]) VALUES (N'RD0002', CAST(N'2019-01-13T02:06:35.897' AS DateTime), 2, 1, 2, 100, 20)
SET IDENTITY_INSERT [dbo].[log_reembolso_acao] OFF
SET IDENTITY_INSERT [dbo].[log_servicos] ON 

INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (11, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:41:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (346, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (818, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1319, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:12:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1349, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:56', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1437, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:20:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1515, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1631, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:30:20', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1847, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:36:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1881, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1935, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:42:21', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1936, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:42:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1937, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:42:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1942, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1943, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:23', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1945, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1957, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1962, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1966, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1974, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1985, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1988, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1989, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1991, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1995, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1996, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1997, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1999, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:38', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2013, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2014, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:52', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2015, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2020, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2021, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2022, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2024, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2030, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2036, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2041, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 03:07:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2146, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:12:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2164, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:16:59', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2549, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 07:52:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2566, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-14 12:17:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2213, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2214, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2215, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2219, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:22:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2235, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1848, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:36:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1849, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:36:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1853, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:34', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1854, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1855, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1858, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1859, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1870, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1872, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1884, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1899, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1900, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1903, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1911, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1928, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1932, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1933, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2042, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2044, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2050, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2053, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2054, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1438, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:20:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1441, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:20:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1442, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:20:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1446, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:20:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1447, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1448, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1452, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:21:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1453, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:21:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1454, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:21:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2147, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:12:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2155, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2161, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2169, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:17:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2191, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2196, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2198, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2316, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:47:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2324, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2333, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2334, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2338, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2341, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2342, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2344, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2346, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2353, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2356, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2362, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2371, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2377, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2378, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2381, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2384, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:50:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2386, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:50:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2389, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2391, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2392, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2395, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2399, 3, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 3
)
', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2400, 3, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2401, 3, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2407, 3, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 04:51:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2408, 3, N'services/colaborador/documento.php - getDocumentoUsuario', N'', N'2019-01-13 04:53:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2409, 3, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 04:53:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2410, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:53:28', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2411, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:53:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2412, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:53:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2423, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2426, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2428, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2429, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2435, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2436, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2455, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:03:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2456, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:03:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2457, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:09:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2461, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:10:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2472, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:16:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2473, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2475, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:18:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2476, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:18:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2477, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:18:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2478, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:18:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1350, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1351, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1355, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1356, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1358, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1361, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1364, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1372, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1373, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1378, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1384, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1385, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1392, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1400, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1402, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1403, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1410, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1412, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1416, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:55', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1423, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1430, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1432, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1940, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:42:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1941, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1944, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1946, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1949, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:25', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1950, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1951, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1953, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1955, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1956, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1967, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1968, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1970, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1972, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1973, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1976, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1977, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1978, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1980, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1982, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1983, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1984, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1986, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1990, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1993, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1994, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2000, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2002, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2006, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2008, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2011, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2012, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2017, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2019, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2033, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:54', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2034, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2035, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2038, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2040, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2183, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2184, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2186, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2188, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2190, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2193, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2194, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2201, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2206, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2208, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2209, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2211, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2212, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2220, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:22:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2226, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2228, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2231, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2232, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2236, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2245, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2283, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:34:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2285, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:42', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2287, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2291, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:35:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2298, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2300, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2302, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:39:09', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2308, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2309, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2312, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2318, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:47:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2320, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2321, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2322, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2331, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2343, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2350, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2354, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2363, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2375, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2390, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2394, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2406, 3, N'services/colaborador/documento.php - getDocumentoUsuario', N'', N'2019-01-13 04:51:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2438, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 04:58:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2451, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:02:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2462, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:10:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1359, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1360, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1363, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1366, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1369, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1381, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1382, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1388, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1391, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1398, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1404, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1407, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1408, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:50', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1413, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1415, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1424, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1426, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:18:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1428, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:18:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1433, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1436, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1851, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:36:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1856, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1860, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1861, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1866, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1868, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1869, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:49', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1871, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1875, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1877, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1879, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1880, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2047, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2051, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2052, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2065, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2073, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2087, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2092, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2097, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2107, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2110, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:10:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2112, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 03:10:55', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2113, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 03:10:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2114, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 03:10:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2123, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2124, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2125, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2130, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2131, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2132, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2134, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2135, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2144, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1749, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:33:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1757, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1771, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1775, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1780, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1781, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:02', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1789, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1795, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1799, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1800, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1803, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1807, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1808, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1815, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1825, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1830, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1831, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1842, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1843, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1844, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1845, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1439, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:20:48', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1440, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:20:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1443, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:20:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1445, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:20:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1451, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:21:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1457, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:22:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1458, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:22:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1474, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1479, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1485, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1486, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1487, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1488, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1490, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1491, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1508, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:26', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1885, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1887, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1888, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:03', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1889, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1893, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1897, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1902, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1906, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1910, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1912, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1915, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1919, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1920, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1922, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1923, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1929, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1934, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1516, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1520, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1521, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1522, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1523, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1525, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1541, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1548, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1552, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1554, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1555, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1560, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1561, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:12', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1566, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1567, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1572, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:25:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1573, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1574, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1575, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1578, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1580, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1584, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1587, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1605, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1608, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1617, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2290, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:35:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2292, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:35:14', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2293, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:35:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2294, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:35:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2297, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2301, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1456, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:22:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1463, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1469, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1470, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1472, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1475, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1481, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1482, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1483, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1493, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:17', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1494, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1495, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:18', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1500, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1502, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1507, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1510, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1513, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1850, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:36:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1857, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:36:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1862, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:45', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1863, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1874, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1878, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2151, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 03:12:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2152, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2153, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2154, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2156, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:00', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2046, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2048, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2055, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2057, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2058, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2063, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2064, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2069, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2070, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2081, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2082, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:19', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2085, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2090, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2091, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2093, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2096, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2098, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2103, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2111, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:10:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2117, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2126, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2127, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2133, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2145, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2149, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 03:12:58', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2150, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 03:12:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2157, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2158, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2159, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2160, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2162, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:08', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2056, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2060, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2062, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2067, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2072, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2074, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:17', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2076, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2080, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2083, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2084, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 03:09:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2086, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2101, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2106, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:57', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2109, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2119, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2121, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2122, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2128, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2129, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2138, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2142, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2187, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2197, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2199, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2202, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2216, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2217, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:21:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2223, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:22:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2224, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2227, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2229, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2237, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2239, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2241, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2242, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2243, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2244, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2262, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:30:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1459, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:22:08', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1460, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:22:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1461, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:22:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1464, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1466, 3, N'services/processo/financeiro/aprovacao.php - getFinanceiroInfoParaMensagemDetalhes', N'', N'2019-01-13 02:22:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1467, 3, N'services/processo/financeiro/aprovacao.php - setFinanceiroStatusAprovadorMaisDetalhes', N'Array
(
    [codigo] => 01   000003671 NF 00006001
    [pagadora] =>  ENERGIA                         
    [beneficiario] => BALCAO BRASIL. DE COM. ENERGIA SA       
    [valor] => R$ 1.802,45
    [emissao] => 09-01-2019
    [vencimento] => 18-01-2019
    [mensagem] => Minha Mensagem de solicitação de mais detalhes sobre o título



Att, Aprovador A1-G1
)
', N'2019-01-13 02:22:47', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1471, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1476, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1480, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1484, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1489, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1496, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1497, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1498, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1499, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1501, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1503, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1504, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1505, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1509, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1514, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1891, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1892, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1894, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1895, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:05', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1901, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1905, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1908, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1916, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1917, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1925, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1927, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1930, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1931, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1352, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1353, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1357, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1362, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1371, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1374, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1383, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1389, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1390, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1393, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1394, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1395, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1396, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1397, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1399, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1411, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1418, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1419, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1422, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:57', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1427, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:18:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1852, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:36:33', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1864, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1865, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1867, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:36:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1873, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1876, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:37:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1882, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1883, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1886, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1890, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:41:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1896, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1898, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:41:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1904, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1907, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1909, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1913, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1914, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:41:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1918, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1921, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:41:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1924, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1926, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:41:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1632, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:30:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1646, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1654, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1657, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1664, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1665, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1667, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1679, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:31:32', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1681, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:31:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1685, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:32:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1689, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1690, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1692, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1706, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1714, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1717, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1723, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:36', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1729, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1730, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1738, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1741, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1744, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1748, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1750, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:33:52', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1754, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:33:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1759, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1774, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1782, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1783, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1785, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1787, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1796, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1797, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1801, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1804, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1806, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1813, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1816, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1819, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1822, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1828, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1832, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1834, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1839, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1524, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1528, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1534, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1536, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:52', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1538, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1544, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1546, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1559, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1562, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1564, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1565, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1570, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:25:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1579, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1589, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1591, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1593, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1594, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1595, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1599, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1606, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1609, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1611, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1616, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1621, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1624, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1625, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1627, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1628, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1952, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1954, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1959, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1960, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1969, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1971, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1979, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1987, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1998, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2007, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2016, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2018, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2023, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:42:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2025, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2032, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2037, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2039, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1354, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:16:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1365, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1367, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1368, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1370, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1375, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1376, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1377, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1379, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1380, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:42', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1386, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1387, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1401, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1405, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1406, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:17:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1409, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:17:54', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1414, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1417, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1420, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1421, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:17:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1425, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:18:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1429, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1431, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1434, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1435, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:18:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1938, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:42:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1939, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:42:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1947, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1948, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1958, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1961, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1963, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1964, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1965, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1975, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:42:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1981, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1992, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:42:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2001, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2003, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2004, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2005, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:42:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2009, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2010, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2026, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2027, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2028, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2029, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2031, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:42:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1444, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:20:55', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1449, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1450, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1455, 3, N'services/processo/financeiro/aprovacao.php - getFinanceiroInfoParaMensagemDetalhes', N'', N'2019-01-13 02:21:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1462, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1465, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1468, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1473, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:22:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1477, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1478, 3, N'services/processo/financeiro/aprovacao.php - getMensagemMaisDetalhes', N'Array
(
    [id] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:22:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1492, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:17', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1506, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1511, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1512, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1635, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:30:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1640, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1643, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1644, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1645, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1647, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1650, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1653, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1659, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1662, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1668, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1676, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:31:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1678, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:31:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1682, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:31:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1684, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:32:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1688, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:32:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1691, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1698, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1704, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1709, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1711, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1713, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1715, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1721, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1725, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1740, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1742, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1745, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1751, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:33:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1755, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:54', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1760, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1321, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:12:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1328, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1338, 3, N'services/processo/financeiro/aprovacao.php - getMensagemMaisDetalhes', N'Array
(
    [id] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:13:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1339, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:13:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1343, 3, N'services/processo/financeiro/aprovacao.php - getMensagemMaisDetalhes', N'Array
(
    [id] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1348, 3, N'services/processo/financeiro/aprovacao.php - getMensagemMaisDetalhes', N'Array
(
    [id] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:13:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2251, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:25:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2253, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:25:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2256, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2257, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1633, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:30:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1634, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:30:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1636, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:30:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1638, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1639, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1641, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1642, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1648, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1649, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1651, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1652, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1656, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1658, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1660, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1661, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1666, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1669, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1670, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:31:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1672, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:31:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1673, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:31:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1677, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:31:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1680, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:31:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1683, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:32:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1687, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:32:23', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1693, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1695, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:27', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1696, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1697, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1699, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1700, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1701, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1705, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1707, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1708, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1710, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1712, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1716, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1718, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1719, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1720, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1726, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1727, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:37', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1728, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:32:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1731, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:38', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1732, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1733, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1734, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1736, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1737, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1739, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1746, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1747, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:32:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1752, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:33:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1753, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:33:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1756, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1758, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:55', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1761, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1762, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:56', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1763, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1764, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1765, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1766, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1767, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1327, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1333, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1334, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:13:25', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1337, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:13:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1342, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1345, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:13:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2303, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:39:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2311, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2385, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:50:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2387, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:50:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2393, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2398, 3, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2404, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2427, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2433, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2463, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:10:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2464, 1, N'services/acesso/usuario_permissao.php - setPermissoes', N'Array
(
    [conta] => 6
    [paginas] => Array
        (
            [0] => 40
            [1] => 41
            [2] => 42
            [3] => 43
            [4] => 46
            [5] => 47
            [6] => 48
            [7] => 104
            [8] => 49
            [9] => 52
            [10] => 55
            [11] => 58
            [12] => 59
            [13] => 68
            [14] => 85
            [15] => 88
            [16] => 90
            [17] => 95
            [18] => 96
            [19] => 1
            [20] => 2
            [21] => 57
            [22] => 98
            [23] => 3
            [24] => 4
        )

)
', N'2019-01-13 05:11:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2467, 1, N'services/acesso/usuario_permissao.php - setPermissoes', N'Array
(
    [conta] => 6
    [paginas] => Array
        (
            [0] => 41
            [1] => 42
            [2] => 43
            [3] => 46
            [4] => 47
            [5] => 48
            [6] => 104
            [7] => 49
            [8] => 52
            [9] => 55
            [10] => 58
            [11] => 59
            [12] => 68
            [13] => 85
            [14] => 88
            [15] => 90
            [16] => 95
            [17] => 96
            [18] => 1
            [19] => 2
            [20] => 57
            [21] => 98
            [22] => 3
            [23] => 4
        )

)
', N'2019-01-13 05:13:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2468, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:13:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1526, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1531, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1535, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1537, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1539, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1545, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1551, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1553, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1556, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1568, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1569, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:25:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1582, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1583, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:18', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1586, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1588, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1597, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1600, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1602, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1615, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1623, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1637, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1655, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:30:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1663, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:30:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1671, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:31:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1674, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:31:17', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1675, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:31:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1686, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:32:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1694, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1702, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1703, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1722, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1724, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1735, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:32:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1743, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:32:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2043, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2045, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 03:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2049, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2059, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2061, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 03:08:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2066, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 03:08:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2068, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2071, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 03:09:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2075, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2077, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2078, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2079, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:09:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2088, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:21', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2089, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 03:09:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2094, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2095, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 03:09:33', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2099, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2100, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2102, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:47', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2104, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2105, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2108, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:09:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2115, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 03:10:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2116, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2118, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2120, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:10:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2136, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:13', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2137, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2139, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 03:11:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2140, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2141, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2143, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:11:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2174, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:17:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2176, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:19', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2179, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2180, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2182, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2185, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2189, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2192, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:00', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2195, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:21:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2200, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2203, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2204, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2205, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2207, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2210, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:21:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2218, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:22:15', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2221, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:22:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2222, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:22:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2225, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:22:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2230, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2233, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2234, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:22:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2238, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2240, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:23:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2246, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2247, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:23:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2258, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2259, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2260, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:30:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2261, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:30:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2168, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:17:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2171, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:17:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2172, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:17:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2173, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:17:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1517, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1518, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1519, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1527, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1529, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:51', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1530, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1532, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1533, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1540, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1542, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1543, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:24:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1547, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1549, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1550, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1557, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1558, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1563, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1571, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:25:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1576, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1577, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1581, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:25:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1585, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1590, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:26:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1592, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1596, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1598, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1601, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1603, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1604, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1607, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1610, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1612, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1613, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1614, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1618, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1619, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1620, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1622, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1626, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:26:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1629, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1630, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:26:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1768, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1324, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 02:12:19', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1329, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1330, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1336, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:13:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1340, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:13:31', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1341, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1344, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:13:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1769, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1770, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1786, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1788, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1790, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1791, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1792, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1793, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:08', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1794, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1802, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1814, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1817, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1818, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:11', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1821, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1826, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1833, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1837, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1846, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:34:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2148, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 03:12:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2163, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 03:13:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2165, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:17:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2166, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:17:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2167, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:17:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2170, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:17:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2175, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:17:17', 1, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2177, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2178, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2181, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 04:17:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2252, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:25:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2248, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:25:34', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2249, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:25:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2250, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:25:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2254, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2255, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:25:37', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2263, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:30:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2269, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2270, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2272, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2273, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2274, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2289, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2304, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:39:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2306, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:39:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2313, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2315, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:47:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2317, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:47:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2319, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:47:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2323, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2325, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:47:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2328, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2329, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2330, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2332, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2336, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2337, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2339, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2340, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2347, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2348, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2349, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2351, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2352, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2355, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2358, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2360, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2367, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2369, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2370, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2373, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2376, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2379, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2380, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2416, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2419, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:31', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2420, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2422, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2425, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2439, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2442, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2443, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2444, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2445, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2447, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2448, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 04:58:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2449, 1, N'services/acesso/usuario_permissao.php - setNovaConta', N'Array
(
    [nome] => Recursos humanos II
)
', N'2019-01-13 04:59:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2450, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 04:59:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2458, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:09:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2459, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:09:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2465, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:13:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2471, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 2
)
', N'2019-01-13 05:14:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2474, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:17:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1320, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 02:12:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1322, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 02:12:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1323, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 02:12:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1325, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 02:12:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1326, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:35', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1331, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1332, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:12:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1335, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 02:13:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1346, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:13:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1347, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:13:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1772, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1773, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:33:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1776, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1777, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1778, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1779, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1784, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1798, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1805, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1809, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1810, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1811, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1812, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1820, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 02:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1823, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1824, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1827, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1829, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 02:34:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1835, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1836, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1838, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1840, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1841, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000000060 NF 00041101
)
', N'2019-01-13 02:34:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2264, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:30:01', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2267, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2268, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:03', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2275, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2278, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:34:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2279, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:34:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2280, 3, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 04:34:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2281, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:34:40', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2284, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2299, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:16', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2414, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:53:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2415, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:53:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2479, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:19:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2480, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:20:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2550, 1, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 07:56:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2551, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 07:56:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2552, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 07:56:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2553, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 07:56:27', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2554, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 07:56:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2555, 1, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 07:56:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2557, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 07:56:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2558, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2559, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2560, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2561, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2562, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2563, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 07:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2565, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 08:03:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (880, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 01:11:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (881, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 01:11:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (882, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 01:11:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (886, 6, N'services/colaborador/reembolso.php - setReembolsoStatusEnviado', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:11:28', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (887, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (888, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (889, 6, N'services/colaborador/reembolso.php - setReembolsoStatusEnviado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:11:48', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (903, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (907, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (908, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (913, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:15:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (919, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:16:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (920, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:16:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (925, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:16:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (926, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:16:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (927, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:16:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (929, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:16:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (962, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (974, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:22:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (977, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:22:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (985, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:23:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (986, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1005, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1014, 2, N'services/geral/login.php - logar', N'Array
(
    [usuario] => brunobrito.contato@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:25:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1018, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:26:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2266, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2277, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2514, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2519, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2524, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2525, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2527, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2528, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2530, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2534, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 05:37:59', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2535, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 05:38:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2541, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2542, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2546, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2265, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:30:01', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2271, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:30:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2276, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000003671 NF 00006001
)
', N'2019-01-13 04:30:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2282, 3, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 04:34:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2286, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2288, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   000446492 NF 00114802
)
', N'2019-01-13 04:34:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2295, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:35:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2296, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:35:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2305, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:39:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2307, 3, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 04:39:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2310, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 014  000201062 NF 00062501
)
', N'2019-01-13 04:39:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2314, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:47:09', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2326, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2327, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:47:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2335, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2345, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:09', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2357, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2359, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2361, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2364, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2365, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2366, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2368, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2372, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 01   012019    FOL00067501
)
', N'2019-01-13 04:48:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2374, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2382, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:50:39', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2383, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:50:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2388, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:50:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2396, 3, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 04:51:09', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2397, 3, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2402, 3, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2403, 3, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2405, 3, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 04:51:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2413, 3, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 04:53:29', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2417, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2418, 3, N'services/processo/financeiro/aprovacao.php - getHistoricoBeneficiario', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2421, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000332 NF 00020801
)
', N'2019-01-13 04:53:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2424, 3, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 04:56:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2430, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2431, 3, N'services/configuracao/parametros.php - getDiretorioFinanceiro', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2432, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2434, 3, N'services/processo/financeiro/aprovacao.php - getTituloItens', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2437, 3, N'services/processo/financeiro/aprovacao.php - getTituloDocumentos', N'Array
(
    [idTitulo] => 011  000000045 NF 00125301
)
', N'2019-01-13 04:56:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2440, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2441, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2446, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 04:58:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2452, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:02:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2453, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:02:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2454, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:02:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2460, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:10:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2466, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:13:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2469, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:13:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2470, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 1
)
', N'2019-01-13 05:13:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (824, 1, N'services/colaborador/documento.php - getDocumentoUsuario', N'', N'2019-01-13 01:02:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (825, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:02:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (828, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-13 01:03:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (829, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 01:03:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (830, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 01:03:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (834, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 01:04:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (835, 1, N'services/compartilhamento/documento.php - getDocumento', N'', N'2019-01-13 01:04:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (836, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:04:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (840, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 01:05:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (841, 1, N'services/compartilhamento/documento.php - getDocumento', N'', N'2019-01-13 01:05:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (842, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:05:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (850, 1, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 01:07:30', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (851, 1, N'services/processo/financeiro/aprovacao.php - getTitulosParaAprovar', N'', N'2019-01-13 01:07:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (852, 1, N'services/processo/financeiro/aprovacao.php - getTitulosInfo', N'', N'2019-01-13 01:07:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (853, 1, N'services/processo/financeiro/aprovacao.php - getTitulosPagadora', N'', N'2019-01-13 01:07:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (854, 1, N'services/processo/financeiro/aprovacao.php - getTitulosTipos', N'', N'2019-01-13 01:07:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (855, 1, N'services/processo/financeiro/aprovacao.php - getTitulosAprovados', N'', N'2019-01-13 01:07:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (862, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:08:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (865, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 01:09:07', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (866, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (869, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (873, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (875, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 01:11:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (877, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 01:11:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (878, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 01:11:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (884, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 01:11:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (885, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (890, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (891, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (937, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:19:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (943, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (945, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:20:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (947, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (949, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (950, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (951, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (952, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (953, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:20:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (958, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:20:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (964, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (965, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (967, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:22:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (968, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:22:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (971, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:22:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (989, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:23:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (991, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:23:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (994, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:23:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (995, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:23:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (996, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:23:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (997, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemReprovado', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:23:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (998, 3, N'services/processo/reembolso/aprovacao.php - setMensagemReprovado', N'Array
(
    [id_reembolso] => RD0003  
    [mensagem] => Minha Mensagem de reprovação ao usuário Colaborador C1-G1

Att Aprovador A1-G1
    [usuario_de] => 3
    [usuario_para] => 6
)
', N'2019-01-13 01:24:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1002, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1006, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1008, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:24:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1010, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:24:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1011, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:25:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1012, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:25:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1015, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:26:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1017, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:26:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1019, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:26:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1020, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:26:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1024, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:30:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1027, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (819, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (820, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (821, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (822, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (823, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 01:01:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (826, 1, N'services/colaborador/documento.php - getDocumentoUsuario', N'', N'2019-01-13 01:02:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (827, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:02:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (831, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 01:03:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (832, 1, N'services/compartilhamento/documento.php - getDocumento', N'', N'2019-01-13 01:03:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (833, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:03:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (837, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 01:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (838, 1, N'services/compartilhamento/documento.php - getDocumento', N'', N'2019-01-13 01:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (839, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 01:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (843, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-13 01:07:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (844, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 01:07:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (845, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 01:07:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (846, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 01:07:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (847, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 01:07:17', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (848, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 01:07:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (849, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 01:07:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (863, 6, N'services/geral/login.php - logar', N'Array
(
    [usuario] => oldwave.studio@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:09:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (874, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:09:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (876, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 01:11:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (883, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:11:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (894, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:14:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (895, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (900, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (909, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (916, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (917, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (921, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:16:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (924, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:16:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (938, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:19:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (948, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:20:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (954, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:20:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (956, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (957, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:20:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (961, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (970, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:22:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (972, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:22:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (973, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:22:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (975, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorAprovado', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:22:43', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (982, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:23:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (984, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:23:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (987, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:23:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (988, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorAprovado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:23:33', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (992, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:23:36', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (999, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorReprovado', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:24:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1003, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1004, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1009, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemReprovado', N'Array
(
    [id] => RD0003  
)
', N'2019-01-13 01:24:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1013, 3, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 01:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1016, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:26:01', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1023, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:30:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1025, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:30:13', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2481, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:23:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2482, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:24:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2484, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:24:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2489, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:26:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2498, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 
)
', N'2019-01-13 05:30:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2503, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2507, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2497, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 2
)
', N'2019-01-13 05:30:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2499, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:30:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2502, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2506, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2509, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 05:33:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2515, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2518, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2522, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2523, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2529, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2532, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2543, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2548, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 05:47:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (942, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (944, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (946, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:20:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (955, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:20:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2485, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:24:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2486, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:26:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2490, 1, N'services/acesso/usuario_permissao.php - setPermissoes', N'Array
(
    [conta] => 6
    [paginas] => Array
        (
            [0] => 41
            [1] => 42
            [2] => 43
            [3] => 46
            [4] => 47
            [5] => 48
            [6] => 104
            [7] => 49
            [8] => 52
            [9] => 55
            [10] => 58
            [11] => 59
            [12] => 68
            [13] => 85
            [14] => 88
            [15] => 90
            [16] => 95
            [17] => 96
            [18] => 1
            [19] => 2
            [20] => 57
            [21] => 98
            [22] => 3
        )

)
', N'2019-01-13 05:26:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2492, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 5
)
', N'2019-01-13 05:27:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2495, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:28:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2504, 1, N'services/cadastro/reembolso/limite.php - getLimiteTodos', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2505, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2508, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2510, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2512, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2513, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2517, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2520, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2531, 1, N'services/configuracao/parametros.php - getCotaKm_reembolso', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2536, 1, N'services/configuracao/parametros.php - getEmails_reembolso', N'', N'2019-01-13 05:38:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2537, 1, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 05:38:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2538, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2539, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2544, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2483, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:24:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2487, 1, N'services/acesso/usuario_permissao.php - getPermissoesConta', N'Array
(
    [conta] => 6
)
', N'2019-01-13 05:26:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2491, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:27:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2500, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2501, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 05:31:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2511, 1, N'services/configuracao/parametros.php - getDiretorioTodos_erp', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2516, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 05:36:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2521, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2526, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 05:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2533, 1, N'services/configuracao/parametros.php - getDiretorioTodos_reembolso', N'', N'2019-01-13 05:37:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2540, 1, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2545, 1, N'services/configuracao/parametros.php - getTipoEmails_reembolso', N'', N'2019-01-13 05:38:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (856, 1, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (857, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (858, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (859, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (860, 1, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (861, 1, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:07:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (870, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (871, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 01:09:08', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (872, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (932, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:19:08', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (933, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:19:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (934, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:19:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (935, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:19:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (939, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (940, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (941, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:20:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (959, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:21:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (960, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0001  
)
', N'2019-01-13 01:21:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1022, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:30:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2488, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:26:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2493, 1, N'services/acesso/usuario_permissao.php - setPermissoes', N'Array
(
    [conta] => 5
    [paginas] => Array
        (
            [0] => 40
            [1] => 47
            [2] => 48
            [3] => 104
            [4] => 49
            [5] => 4
        )

)
', N'2019-01-13 05:27:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2494, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 05:28:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (2496, 1, N'services/acesso/usuario_permissao.php - setPermissoes', N'Array
(
    [conta] => 6
    [paginas] => Array
        (
            [0] => 42
            [1] => 43
            [2] => 46
            [3] => 47
            [4] => 48
            [5] => 104
            [6] => 49
            [7] => 52
            [8] => 55
            [9] => 58
            [10] => 59
            [11] => 68
            [12] => 85
            [13] => 88
            [14] => 90
            [15] => 95
            [16] => 96
            [17] => 1
            [18] => 2
            [19] => 57
            [20] => 98
            [21] => 3
        )

)
', N'2019-01-13 05:28:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (864, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 01:09:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (867, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (868, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 01:09:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (879, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 01:11:15', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (892, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:11:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (893, 6, N'services/colaborador/reembolso.php - setReembolsoStatusEnviado', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:11:54', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (896, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (897, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (898, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (902, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (904, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (905, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:15:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (906, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:15:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (911, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (914, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:15:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (915, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (918, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (922, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:16:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (928, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:16:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (930, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0003  
)
', N'2019-01-13 01:16:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (931, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:19:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (936, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:19:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (963, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (966, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:22:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (969, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:22:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (976, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:22:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (980, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:22:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (990, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:23:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (993, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:23:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1000, 3, N'services/processo/reembolso/aprovacao.php - getDadosEmailReembolsoReprovado', N'Array
(
    [id_reembolso] => RD0003  
)
', N'2019-01-13 01:24:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1001, 3, N'services/email/email.php - e8cReprovadoReemmbolso', N'Array
(
    [nome_para] => Colaborador
    [email_para] => oldwave.studio@gmail.com
    [nome_de] => Aprovador
    [email_de] => bruno.britto.android@gmail.com
    [id_format] => RD0003  
    [empresa] => AMERICA ENERGIA                         
    [mes] => 01-2019
    [despesa] => REEMBOLSO
    [evento] => Evento 3
    [total] => 150.00
    [itens] => 1
    [envio] => 13-01-2019
    [mensagem] => Minha Mensagem de reprovação ao usuário Colaborador C1-G1

Att Aprovador A1-G1
)
', N'2019-01-13 01:24:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1007, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:24:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1021, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:30:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1026, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:30:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1028, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:30:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (899, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:14:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (901, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:03', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (910, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0001  
)
', N'2019-01-13 01:15:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (912, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:15:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (923, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:16:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (978, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:22:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (979, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:22:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (981, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:22:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (983, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:23:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (454, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-13 00:05:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (455, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:05:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (456, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:05:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (469, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-13 00:07:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (470, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:07:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (471, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:07:44', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (472, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:07:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (473, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:07:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (474, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:07:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (475, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:07:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (476, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:07:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (477, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:07:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (478, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:07:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (479, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:07:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (480, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:07:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (481, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:07:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (482, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:07:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (483, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:07:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (484, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (485, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (486, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (487, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (488, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (489, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (490, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (491, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (492, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (493, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (494, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (495, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:07:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (502, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:10:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (503, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:10:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (504, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:10:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (505, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:10:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (506, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:10:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1029, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:31:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1032, 2, N'services/processo/reembolso/aprovacao.php - setMensagemNegado', N'Array
(
    [id_reembolso] => RD0002  
    [mensagem] => Minha Mensagem de Negação acompanhadas de  justificativas

Att Aprovador A2-G1 
    [usuario_de] => 2
    [usuario_para] => 3
)
', N'2019-01-13 01:32:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1033, 2, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:32:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1040, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1041, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1042, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:34:20', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1045, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:34:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1046, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:34:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1047, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:34:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1052, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:35:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1068, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1074, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:38:09', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1084, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:38:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1085, 3, N'services/processo/reembolso/aprovacao.php - setMensagemRevisao', N'Array
(
    [id_reembolso] => RD0002  
    [mensagem] => Minha Mensagem de revisão para o colaborador Colaborador C1-G1

Att, Aprovador A1-G1
    [usuario_de] => 3
    [usuario_para] => 6
)
', N'2019-01-13 01:39:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1086, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:39:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1088, 3, N'services/email/email.php - e7cRevisarReembolso', N'Array
(
    [nome_para] => Colaborador
    [email_para] => oldwave.studio@gmail.com
    [nome_de] => Aprovador
    [email_de] => bruno.britto.android@gmail.com
    [id_format] => RD0002  
    [empresa] => AMERICA ENERGIA                         
    [mes] => 01-2019
    [despesa] => REEMBOLSO
    [evento] => Evento 2
    [total] => 84.00
    [itens] => 1
    [envio] => 13-01-2019
    [mensagem] => Minha Mensagem de revisão para o colaborador Colaborador C1-G1

Att, Aprovador A1-G1
)
', N'2019-01-13 01:39:32', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1091, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:39:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1092, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:39:35', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1093, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:39:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1096, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:39:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1097, 3, N'services/colaborador/reembolso.php - getReembolsoMensagemRevisao', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:39:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1167, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1169, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1173, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1174, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1175, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1183, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:54:21', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1195, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:56:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1196, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:56:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1206, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:57:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1211, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1212, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1217, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1220, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1231, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:02:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1234, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:02:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1238, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:02:28', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1239, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1240, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:02:34', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1244, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (347, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (348, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (349, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (350, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (351, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (352, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (353, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (354, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (355, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (356, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (357, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (358, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (359, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (360, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (361, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (362, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (363, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (364, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (365, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (366, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (367, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (368, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (369, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (370, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (371, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 5
)
', N'2019-01-13 00:04:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (372, 1, N'services/acesso/usuario_permissao.php - uploadFoto', N'Array
(
    [arquivo] => Uploads\p1d12f8amm1juj13hm181nkh51orsb.jpg
    [id] => 5
)
', N'2019-01-13 00:04:40', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (373, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 5
    [usuario] => emptecnologia.projetos@gmail.com
    [nome] => Aprovador
    [sobrenome] => A2-G2
    [cpf] => 32734618885
    [senha] => 
    [id_grupo] => 1
    [id_conta] => 2
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 5
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:04:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (374, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (375, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (376, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (377, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (378, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (379, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (380, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (381, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (382, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (383, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (384, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (385, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:43', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (386, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (387, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (388, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (389, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (390, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (391, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (392, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (393, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (394, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (395, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (396, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (397, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (398, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (399, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (400, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (401, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (402, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (403, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (404, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (405, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (406, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (407, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (408, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (409, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (410, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (411, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (412, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (413, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1030, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:31:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1031, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:32:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1037, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1053, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:35:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1054, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:35:12', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1055, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:35:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1056, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:35:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1060, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:35:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1061, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:35:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1063, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1066, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1067, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1071, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemNegado', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:37:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1072, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:38:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1075, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:38:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1080, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemNegado', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:38:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1082, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:38:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1087, 3, N'services/processo/reembolso/aprovacao.php - getDadosEmailReembolsoRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:39:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1094, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:39:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1098, 6, N'services/geral/login.php - logar', N'Array
(
    [usuario] => oldwave.studio@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:40:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1101, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1102, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1104, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1106, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1108, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 01:40:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1112, 6, N'services/colaborador/reembolso.php - getReembolsoItensReembolso', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:40:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1114, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1121, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1122, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1123, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1127, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1128, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1129, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1137, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:42:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1149, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:43:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1151, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:43:01', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1153, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:43:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1154, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:43:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1161, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1165, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:44:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1170, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1172, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1178, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1181, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:54:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1187, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:54:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1190, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:54:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1192, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:56:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1197, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1198, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:56:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1199, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1205, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:57:37', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1210, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1216, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:00:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1218, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1219, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1221, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1224, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1228, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemNegado', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:01:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1232, 3, N'services/processo/reembolso/aprovacao.php - getDadosEmailReembolsoRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:02:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1236, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:02:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1237, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:02:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1242, 3, N'services/colaborador/reembolso.php - getReembolsoMensagemRevisao', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:02:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1168, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1171, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:52:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1176, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1180, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:53:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1184, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:54:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1186, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:54:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1188, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:54:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1193, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:56:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1200, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1202, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1285, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1286, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1287, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorAprovado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:05:01', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1291, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:05:04', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1292, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:05:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1299, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1301, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:05:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1305, 2, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorAprovado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:06:35', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1307, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1308, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1309, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1310, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1315, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:07:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1318, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:07:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1034, 2, N'services/processo/reembolso/aprovacao.php - getDadosEmailReembolsoNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:32:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1036, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1038, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1100, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1105, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1111, 6, N'services/colaborador/reembolso.php - getReembolsoResumo', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:40:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1116, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1130, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1131, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1133, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:41:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1136, 3, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorAprovado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:42:15', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1138, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:42:18', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1140, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:42:19', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1141, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:42:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1142, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:42:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1144, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:42:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1147, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:43:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1150, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:43:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1156, 2, N'services/processo/reembolso/aprovacao.php - setReembolsoStatusAprovadorNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:43:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1157, 2, N'services/processo/reembolso/aprovacao.php - getDadosEmailReembolsoNegado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:43:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1159, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1162, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1163, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1208, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1209, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1115, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1119, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1124, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:41:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1125, 6, N'services/colaborador/reembolso.php - setReembolsoStatusEnviado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:41:10', 2, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1126, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:41:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1132, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:41:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1139, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:42:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1143, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:42:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1145, 2, N'services/geral/login.php - logar', N'Array
(
    [usuario] => brunobrito.contato@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:42:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1146, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:43:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1148, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:43:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1152, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:43:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1155, 2, N'services/processo/reembolso/aprovacao.php - setMensagemNegado', N'Array
(
    [id_reembolso] => RD0002  
    [mensagem] => Minha mensagem de negação de reeembolso somada as justificativas 

Att, A2-G1
    [usuario_de] => 2
    [usuario_para] => 3
)
', N'2019-01-13 01:43:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (26, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:47:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (27, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:47:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (28, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:47:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (29, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 22:47:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (30, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 22:48:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (53, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (54, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (55, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (56, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (57, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (58, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (59, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:13:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (60, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:13:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (61, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:13:37', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (62, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:13:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (63, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:13:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (64, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:13:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (65, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:13:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (66, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:13:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (67, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:13:47', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (68, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:13:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (69, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:13:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (70, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:13:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (71, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:13:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (78, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (79, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (80, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (81, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (82, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:17:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (83, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:17:46', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (84, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:17:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (85, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:17:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (86, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:17:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (87, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:17:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (88, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:17:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (89, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (90, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (91, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (92, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (93, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (94, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (95, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:22:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (96, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:22:53', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (97, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:22:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (98, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (99, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (100, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (101, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (115, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (116, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (117, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (118, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (119, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (120, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (121, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:23:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (122, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:23:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (123, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:23:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (124, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (125, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (126, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (127, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (128, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:23:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (129, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:23:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (133, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:25:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (134, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:25:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (135, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:25:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (136, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:25:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (414, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (415, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (416, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (417, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (418, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (419, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (420, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (421, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:46', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (422, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (423, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (424, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (425, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (426, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (427, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (428, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (429, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (430, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (431, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (432, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (433, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (434, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (435, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (436, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (437, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (438, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (439, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (440, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (441, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (442, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (443, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (444, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (445, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (446, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (447, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (448, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (449, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (450, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (451, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (452, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (453, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:04:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (457, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:05:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (458, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:05:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (459, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:05:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (460, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:05:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (461, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:05:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (462, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:05:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (463, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:05:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (464, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:06:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (465, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:06:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (466, 1, N'services/cadastro/reembolso/grupo.php - setGrupo', N'Array
(
    [id] => 
    [nome] => GRUPO-G1
    [descricao] => Grupo Destinado a Testes de aprovacao
    [departamento] => 1
    [aprovadores] => Array
        (
            [0] => Array
                (
                    [id] => 3
                    [ordem] => 1
                    [alcada_de] => 0.0
                    [alcada_ate] => 100
                    [nomeSobrenome] => Aprovador A1-G1
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => 
                )

            [1] => Array
                (
                    [id] => 4
                    [ordem] => 2
                    [alcada_de] => 100
                    [alcada_ate] => 500
                    [nomeSobrenome] => Aprovador A1-G2
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => 
                )

        )

)
', N'2019-01-13 00:06:57', 2, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (467, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:07:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (468, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:07:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (496, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (497, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (498, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:08:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (499, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:08:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (500, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:08:17', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (501, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:08:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (507, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:11:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (508, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:11:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (509, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:11:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (510, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:11:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (511, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:11:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (512, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:11:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (513, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:11:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (514, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:12:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (515, 1, N'services/cadastro/reembolso/grupo.php - setGrupo', N'Array
(
    [id] => 2
    [nome] => GRUPO-G1
    [descricao] => Grupo Destinado a Testes de aprovacao
    [departamento] => 1
    [aprovadores] => Array
        (
            [0] => Array
                (
                    [id] => 3
                    [ordem] => 1
                    [alcada_de] => .00
                    [alcada_ate] => 100.00
                    [nomeSobrenome] => Aprovador A1-G1
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => Administrativo
                )

            [1] => Array
                (
                    [id] => 2
                    [ordem] => 2
                    [alcada_de] => 100.00
                    [alcada_ate] => 500.00
                    [nomeSobrenome] => Aprovador A2-G1
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => Administrativo
                )

        )

)
', N'2019-01-13 00:12:09', 2, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (516, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:12:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1043, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:34:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1044, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:34:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1051, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:34:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1057, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:35:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1058, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:35:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1064, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1065, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:37:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1078, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:38:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1083, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:38:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1090, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:39:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1099, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1113, 6, N'services/colaborador/reembolso.php - setReembolso', N'Array
(
    [id] => RD0002  
    [data_inclusao] => 13-01-2019
    [despesa] => 1
    [empresa] => 01
    [titulo] => Evento 2
    [data_base] => 01-2019
    [itens] => Array
        (
            [0] => Array
                (
                    [data] => 02-01-2019
                    [cliente] => 9INJET              
                    [clienteId] => C00076601
                    [natureza] => 20002     
                    [naturezaId] => QUILOMETRAGEM
                    [ccusto] => 1SPADM   
                    [ccustoId] => ENERGIA-SP-ADMINISTRATIVO               
                    [valor] => 84
                    [desconto] => 0.0
                    [total] => 84
                    [observacao] => 
                    [documento] => CP_bbc5002bec3ac68ef94b18cce5b92719.png
                )

        )

)
', N'2019-01-13 01:40:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1117, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1118, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1120, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 01:40:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1134, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:41:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1135, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoItens', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:41:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1158, 2, N'services/email/email.php - e6aNegadoReembolso', N'Array
(
    [nome_para] => Aprovador
    [email_para] => bruno.britto.android@gmail.com
    [nome_de] => Aprovador
    [email_de] => brunobrito.contato@gmail.com
    [nome_usuario] => Colaborador
    [id_format] => RD0002  
    [empresa] => AMERICA ENERGIA                         
    [mes] => 01-2019
    [despesa] => REEMBOLSO
    [evento] => Evento 2
    [total] => 84.00
    [itens] => 1
    [envio] => 13-01-2019
    [mensagem] => Minha mensagem de negação de reeembolso somada as justificativas 

Att, A2-G1
)
', N'2019-01-13 01:43:50', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1160, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1164, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:43:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1166, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:44:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1223, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1225, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemNegado', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:00:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1226, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1229, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemRevisao', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:01:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1235, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:02:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1245, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1251, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1254, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1255, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1256, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1261, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 02:04:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1263, 6, N'services/colaborador/reembolso.php - getReembolsoResumo', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:04:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1282, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1289, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:05:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1297, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1298, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1035, 2, N'services/email/email.php - e6aNegadoReembolso', N'Array
(
    [nome_para] => Aprovador
    [email_para] => bruno.britto.android@gmail.com
    [nome_de] => Aprovador
    [email_de] => brunobrito.contato@gmail.com
    [nome_usuario] => Colaborador
    [id_format] => RD0002  
    [empresa] => AMERICA ENERGIA                         
    [mes] => 01-2019
    [despesa] => REEMBOLSO
    [evento] => Evento 2
    [total] => 84.00
    [itens] => 1
    [envio] => 13-01-2019
    [mensagem] => Minha Mensagem de Negação acompanhadas de  justificativas

Att Aprovador A2-G1 
)
', N'2019-01-13 01:32:49', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1039, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:32:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1048, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:34:27', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1049, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:34:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1050, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:34:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1059, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:35:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1062, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:37:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1069, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1070, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:37:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1073, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:38:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1076, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:38:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1077, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:38:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1079, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:38:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1081, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoInfoParaMensagemReprovado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 01:38:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1089, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:39:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1095, 3, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:39:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1103, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1107, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:40:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1109, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 01:40:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1110, 6, N'services/colaborador/reembolso.php - getReembolsoMensagemRevisao', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:40:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1177, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:52:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1179, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:53:05', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1182, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 01:54:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1185, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:54:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1189, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 01:54:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1191, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 01:56:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1194, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 01:56:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1201, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1203, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1204, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:57:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1207, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoMensagemNegado', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 01:57:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1213, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 01:58:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1214, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1215, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1222, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:00:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1227, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:00:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1230, 3, N'services/processo/reembolso/aprovacao.php - setMensagemRevisao', N'Array
(
    [id_reembolso] => RD0002  
    [mensagem] => Minha Mensagem de revisão para o aprovador Colaborador C1-G1

Att, Aprovador A1-G1 
    [usuario_de] => 3
    [usuario_para] => 6
)
', N'2019-01-13 02:02:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1233, 3, N'services/email/email.php - e7cRevisarReembolso', N'Array
(
    [nome_para] => Colaborador
    [email_para] => oldwave.studio@gmail.com
    [nome_de] => Aprovador
    [email_de] => bruno.britto.android@gmail.com
    [id_format] => RD0002  
    [empresa] => AMERICA ENERGIA                         
    [mes] => 01-2019
    [despesa] => REEMBOLSO
    [evento] => Evento 2
    [total] => 84.00
    [itens] => 1
    [envio] => 13-01-2019
    [mensagem] => Minha Mensagem de revisão para o aprovador Colaborador C1-G1

Att, Aprovador A1-G1 
)
', N'2019-01-13 02:02:25', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1241, 3, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [idReembolso] => RD0002  
)
', N'2019-01-13 02:02:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1243, 3, N'services/colaborador/reembolso.php - getReembolsoMensagemRevisao', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:03:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (12, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:41:21', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (13, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:41:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (14, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (15, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (16, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:42:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (20, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:43:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (21, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:43:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (22, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:43:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (150, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-12 23:41:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (151, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:41:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (152, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:41:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (153, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:41:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (158, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:43:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (164, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (165, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (166, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (167, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (168, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (169, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (170, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:49:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (171, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (172, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (173, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:50:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (174, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:50:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (175, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:50:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (176, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:50:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (177, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (178, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (179, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:50:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (180, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:50:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (181, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:50:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (182, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:50:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (183, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (184, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:50:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (185, 1, N'services/acesso/usuario_permissao.php - setUsuarioAtivacao', N'Array
(
    [id_usuario] => 2
    [nome_para] => Aprovador
    [email_para] => brunobrito.contato@gmail.com
    [id_grupo] => 1
    [id_conta] => 2
    [arrCcusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 2
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-12 23:52:10', 2, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (186, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:52:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (187, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:52:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (188, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:52:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (189, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:52:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (192, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-12 23:53:49', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (193, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (194, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (195, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (196, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (197, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (198, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (199, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:53:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (517, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:12:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1246, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (37, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-12 23:06:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (38, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (39, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (40, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (41, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (42, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (43, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (44, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:06:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (45, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:06:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (46, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:06:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (47, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:06:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (48, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:06:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (49, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:06:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (50, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:06:44', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (51, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:06:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (52, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:06:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (72, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:16:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (73, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:16:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (74, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:17:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (75, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:17:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (76, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:17:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (77, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:17:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (102, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (103, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (104, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (105, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (106, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (107, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (108, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:23:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (109, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:23:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (110, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:23:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (111, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (112, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:23:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (113, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (114, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-12 23:23:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (130, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-12 23:24:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (131, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:24:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (132, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:24:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (138, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-12 23:27:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (139, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:27:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (140, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:27:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (141, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:27:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (142, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-12 23:30:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (143, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:30:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (144, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:30:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (145, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:30:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (146, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-12 23:40:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (147, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:40:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (148, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:40:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (149, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:40:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (154, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (155, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (156, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:41:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (157, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:41:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (159, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:48:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (160, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 23:48:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (161, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 23:48:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (162, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-12 23:49:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (163, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:49:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (200, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (201, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (202, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (203, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (204, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (205, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (206, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-12 23:56:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (207, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:56:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (208, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-12 23:56:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (17, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:43:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (18, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:43:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (19, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:43:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (23, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:44:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (24, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:44:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (25, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:44:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (137, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-12 23:27:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1248, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1257, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1266, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1267, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1269, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1272, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1273, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1275, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 02:04:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1278, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:04:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1290, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:05:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1296, 2, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1304, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:06:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1311, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1314, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:07:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (527, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (528, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (529, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (530, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (531, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (532, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (533, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:21:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (534, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:21:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (535, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:21:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (536, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:21:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (537, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:21:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (538, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:21:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (539, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:21:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (540, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:21:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (541, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:21:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (542, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:21:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (543, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:21:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (544, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:21:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (545, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:21:22', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (546, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:21:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (547, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:21:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (548, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:21:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (549, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:21:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (550, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:21:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (551, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:21:28', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (552, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:21:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (553, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:21:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (554, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (555, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:21:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (556, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:21:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (557, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:21:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (558, 1, N'services/acesso/usuario_permissao.php - setUsuarioAtivacao', N'Array
(
    [id_usuario] => 6
    [nome_para] => Colaborador
    [email_para] => oldwave.studio@gmail.com
    [id_grupo] => 2
    [id_conta] => 5
    [arrCcusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

            [1] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 2SPADM
                    [ccusto] => GESTAO-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:22:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (559, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:22:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (560, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:22:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (561, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:22:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (562, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:22:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (563, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:22:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (564, 1, N'services/acesso/usuario_permissao.php - uploadFoto', N'Array
(
    [arquivo] => Uploads\p1d12ga4ep1ipv122o1au110um16rc3.jpg
    [id] => 6
)
', N'2019-01-13 00:23:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (565, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 6
    [usuario] => oldwave.studio@gmail.com
    [nome] => Colaborador
    [sobrenome] => C1-G1
    [cpf] => 16510717808
    [senha] => 
    [id_grupo] => 2
    [id_conta] => 5
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

            [1] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 2SPADM
                    [ccusto] => GESTAO-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:23:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (566, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (567, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (568, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (569, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (570, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (571, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:15', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (572, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:23:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (573, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:49', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (574, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (575, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (576, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (577, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (578, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (579, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (580, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (581, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (582, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (583, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (584, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:23:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (585, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:23:52', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (586, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (587, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (588, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (589, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (590, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (591, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:23:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (592, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 5
)
', N'2019-01-13 00:23:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (593, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (594, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (518, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:13:14', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (519, 1, N'services/cadastro/reembolso/grupo.php - setGrupo', N'Array
(
    [id] => 
    [nome] => GRUPO-G2
    [descricao] => Grupo Destinado a Testes de aprovacao 
    [departamento] => 14
    [aprovadores] => Array
        (
            [0] => Array
                (
                    [id] => 4
                    [ordem] => 1
                    [alcada_de] => 0.0
                    [alcada_ate] => 150
                    [nomeSobrenome] => Aprovador A1-G2
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => 
                )

            [1] => Array
                (
                    [id] => 5
                    [ordem] => 2
                    [alcada_de] => 150
                    [alcada_ate] => 800
                    [nomeSobrenome] => Aprovador A2-G2
                    [empresa] => AMERICA ENERGIA                         
                    [departamento] => 
                )

        )

)
', N'2019-01-13 00:13:26', 2, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (520, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:13:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (521, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:13:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (522, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 3
)
', N'2019-01-13 00:13:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (526, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-13 00:18:40', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1247, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1250, 6, N'services/geral/login.php - logar', N'Array
(
    [usuario] => oldwave.studio@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:03:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1252, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1253, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1265, 6, N'services/colaborador/reembolso.php - setReembolso', N'Array
(
    [id] => RD0002  
    [data_inclusao] => 13-01-2019
    [despesa] => 1
    [empresa] => 01
    [titulo] => Evento 2
    [data_base] => 01-2019
    [itens] => Array
        (
            [0] => Array
                (
                    [data] => 02-01-2019
                    [cliente] => 9INJET              
                    [clienteId] => C00076601
                    [natureza] => 20002     
                    [naturezaId] => QUILOMETRAGEM
                    [ccusto] => 1SPADM   
                    [ccustoId] => ENERGIA-SP-ADMINISTRATIVO               
                    [valor] => 84
                    [desconto] => 0.0
                    [total] => 84
                    [observacao] => 
                    [documento] => CP_bbc5002bec3ac68ef94b18cce5b92719.png
                )

        )

)
', N'2019-01-13 02:04:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1270, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1271, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1274, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1277, 6, N'services/colaborador/reembolso.php - setReembolsoStatusEnviado', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:04:23', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1279, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1280, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAprovador', N'', N'2019-01-13 02:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1281, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoRevisao', N'', N'2019-01-13 02:04:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1283, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:04:44', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1284, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:04:45', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1288, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:05:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1293, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:05:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1294, 2, N'services/geral/login.php - logar', N'Array
(
    [usuario] => brunobrito.contato@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:05:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1295, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1300, 2, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:05:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1302, 2, N'services/processo/reembolso/aprovacao.php - getInfoAprovador', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:05:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1303, 2, N'services/processo/reembolso/aprovacao.php - getInfoUsuario', N'Array
(
    [id_reembolso] => RD0002  
)
', N'2019-01-13 02:06:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1306, 2, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:06:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1312, 3, N'services/geral/login.php - logar', N'Array
(
    [usuario] => bruno.britto.android@gmail.com
    [senha] => 12345
)
', N'2019-01-13 02:07:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1313, 3, N'services/processo/reembolso/aprovacao.php - getPermissaoRevisao', N'', N'2019-01-13 02:07:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1317, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoAcompanhamento', N'', N'2019-01-13 02:07:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1249, 3, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:03:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1258, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1259, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1260, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 02:03:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1262, 6, N'services/colaborador/reembolso.php - getReembolsoMensagemRevisao', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:04:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1264, 6, N'services/colaborador/reembolso.php - getReembolsoItensReembolso', N'Array
(
    [id] => RD0002  
)
', N'2019-01-13 02:04:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1268, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 02:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1276, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 02:04:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (1316, 3, N'services/processo/reembolso/aprovacao.php - getReembolsoHistorico', N'', N'2019-01-13 02:07:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (7, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-12 22:39:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (8, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-12 22:39:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (9, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-12 22:39:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (10, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-12 22:39:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (209, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:56:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (595, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (616, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (617, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (618, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (619, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (620, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (621, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (622, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:25:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (623, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:25:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (624, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:25:39', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (625, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:26:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (626, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:26:47', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (627, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:26:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (628, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:26:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (629, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:26:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (630, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:26:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (656, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-13 00:29:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (657, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:29:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (658, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:29:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (659, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:29:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (660, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:30:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (661, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:30:44', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (665, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:31:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (666, 1, N'services/compartilhamento/documento.php - getDocumento', N'', N'2019-01-13 00:31:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (667, 1, N'services/configuracao/parametros.php - getDiretorioCompartilhamentoDocumento', N'', N'2019-01-13 00:31:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (672, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:32:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (673, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:32:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (674, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:32:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (675, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 2
)
', N'2019-01-13 00:32:08', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (684, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (685, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (686, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:34:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (687, 6, N'services/geral/login.php - logar', N'Array
(
    [usuario] => oldwave.studio@gmail.com
    [senha] => 12345
)
', N'2019-01-13 00:34:40', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (688, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:34:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (693, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:43:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (694, 6, N'services/acesso/usuario_permissao.php - setPerfil', N'Array
(
    [id] => 6
    [nome] => Colaborador
    [sobrenome] => C1-G1
    [senha] => 
)
', N'2019-01-13 00:43:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (696, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:45:41', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (697, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (698, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (699, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (700, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (701, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (702, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (703, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (704, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (705, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:45:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (211, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:00:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (212, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:00:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (213, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:01:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (214, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:01:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (215, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:01:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (216, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:01:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (217, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:01:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (218, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:01:38', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (219, 1, N'services/acesso/usuario_permissao.php - setUsuarioAtivacao', N'Array
(
    [id_usuario] => 3
    [nome_para] => Aprovador
    [email_para] => bruno.britto.android@gmail.com
    [id_grupo] => 1
    [id_conta] => 2
    [arrCcusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 3
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:02:05', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (220, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:02:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (221, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:02:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (222, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:02:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (223, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:02:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (224, 1, N'services/acesso/usuario_permissao.php - setUsuarioAtivacao', N'Array
(
    [id_usuario] => 4
    [nome_para] => Aprovador
    [email_para] => emptecnologia.contato@gmail.com
    [id_grupo] => 1
    [id_conta] => 2
    [arrCcusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 4
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:02:23', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (225, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (226, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (227, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (228, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (229, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (230, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 5
)
', N'2019-01-13 00:02:29', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (231, 1, N'services/acesso/usuario_permissao.php - setUsuarioAtivacao', N'Array
(
    [id_usuario] => 5
    [nome_para] => Aprovador
    [email_para] => emptecnologia.projetos@gmail.com
    [id_grupo] => 1
    [id_conta] => 2
    [arrCcusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 5
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:02:47', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (232, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (233, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (234, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (235, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (236, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (237, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (238, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (239, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:02:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (240, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 2
)
', N'2019-01-13 00:02:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (241, 1, N'services/acesso/usuario_permissao.php - uploadFoto', N'Array
(
    [arquivo] => Uploads\p1d12f6amk16oshcpi9in8tbfl5.jpg
    [id] => 2
)
', N'2019-01-13 00:03:35', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (242, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 2
    [usuario] => brunobrito.contato@gmail.com
    [nome] => Aprovador
    [sobrenome] => A2-G1
    [cpf] => 13596180821
    [senha] => 
    [id_grupo] => 1
    [id_conta] => 2
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 2
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:03:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (243, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (244, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (245, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (246, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (247, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (248, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (249, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (250, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (251, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (252, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:03:54', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (253, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (254, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (255, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (256, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (257, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (258, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (259, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (260, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (261, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (262, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:03:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (263, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (264, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (265, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (266, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (267, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (268, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (269, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (270, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (271, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (272, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:03:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (273, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 3
)
', N'2019-01-13 00:04:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (274, 1, N'services/acesso/usuario_permissao.php - uploadFoto', N'Array
(
    [arquivo] => Uploads\p1d12f7bdu121g1kpeibu1e4o3le7.jpg
    [id] => 3
)
', N'2019-01-13 00:04:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (275, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 3
    [usuario] => bruno.britto.android@gmail.com
    [nome] => Aprovador
    [sobrenome] => A1-G1
    [cpf] => 30280426810
    [senha] => 
    [id_grupo] => 1
    [id_conta] => 2
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 3
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:04:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (276, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (277, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (596, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (597, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (598, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:24:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (599, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 4
)
', N'2019-01-13 00:24:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (600, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (601, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (602, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (603, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:05', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (604, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (605, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (606, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:24:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (607, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 6
    [usuario] => oldwave.studio@gmail.com
    [nome] => Colaborador
    [sobrenome] => C1-G1
    [cpf] => 16510717808
    [senha] => 
    [id_grupo] => 2
    [id_conta] => 5
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 2SPADM
                    [ccusto] => GESTAO-SP-ADMINISTRATIVO
                )

            [1] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:24:24', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (608, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (609, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (610, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (611, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (612, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (613, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (614, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (615, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:24:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (631, 1, N'services/acesso/usuario_permissao.php - getUsuario', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (632, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (633, 1, N'services/corporativo/ccusto.php - getCcustoAll', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (634, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (635, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (636, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (637, 1, N'services/acesso/usuario_permissao.php - getContas', N'', N'2019-01-13 00:28:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (638, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:28:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (639, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 1
)
', N'2019-01-13 00:28:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (640, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:28:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (641, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:28:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (642, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:28:49', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (643, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 6
    [usuario] => oldwave.studio@gmail.com
    [nome] => Colaborado
    [sobrenome] => C1-G1
    [cpf] => 16510717808
    [senha] => 
    [id_grupo] => 2
    [id_conta] => 5
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 2SPADM
                    [ccusto] => GESTAO-SP-ADMINISTRATIVO
                )

            [1] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:29:01', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (644, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (645, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (646, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (647, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (648, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:29:05', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (649, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 6
    [usuario] => oldwave.studio@gmail.com
    [nome] => Colaborador
    [sobrenome] => C1-G1
    [cpf] => 16510717808
    [senha] => 
    [id_grupo] => 2
    [id_conta] => 5
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 2SPADM
                    [ccusto] => GESTAO-SP-ADMINISTRATIVO
                )

            [1] => Array
                (
                    [id_usuario] => 6
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:29:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (650, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (651, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (652, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (653, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (654, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (655, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 6
)
', N'2019-01-13 00:29:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (662, 1, N'services/cadastro/reembolso/grupo.php - getGrupoAprovador', N'', N'2019-01-13 00:30:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (663, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:30:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (664, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:30:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (668, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:31:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (669, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:31:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (670, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:31:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (671, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:31:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (676, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:32:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (677, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:32:20', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (678, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:32:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (679, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:32:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (680, 1, N'services/cadastro/reembolso/grupo.php - getGrupo', N'', N'2019-01-13 00:34:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (681, 1, N'services/acesso/usuario_permissao.php - getResumoUsuario', N'', N'2019-01-13 00:34:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (682, 1, N'services/corporativo/departamento.php - getDepartamento', N'', N'2019-01-13 00:34:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (683, 1, N'services/cadastro/reembolso/grupo.php - getInfoAprovadores', N'Array
(
    [idGrupo] => 1
)
', N'2019-01-13 00:34:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (689, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:36:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (690, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:38:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (691, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:43:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (692, 6, N'services/acesso/usuario_permissao.php - setPerfil', N'Array
(
    [id] => 6
    [nome] => Colaborado
    [sobrenome] => C1-G
    [senha] => 
)
', N'2019-01-13 00:43:37', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (695, 6, N'services/acesso/usuario_permissao.php - getPerfil', N'', N'2019-01-13 00:45:34', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (706, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (707, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (708, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (210, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-12 23:56:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (709, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (6, 1, N'services/geral/login.php - logar', N'Array
(
    [usuario] => loopconsultoria.brito@gmail.com
    [senha] => 123
)
', N'2019-01-12 22:23:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (278, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (710, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (711, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (712, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (713, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (714, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:46:56', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (715, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:47:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (716, 6, N'services/colaborador/reembolso.php - getData', N'', N'2019-01-13 00:47:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (717, 6, N'services/corporativo/ccusto.php - getCcustoUsuarioReembolso', N'Array
(
    [empresa] => 1
)
', N'2019-01-13 00:48:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (718, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:48:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (719, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:48:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (720, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:48:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (721, 6, N'services/cadastro/reembolso/limite.php - getLimite', N'Array
(
    [idNatureza] => 20014     
)
', N'2019-01-13 00:48:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (722, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 01-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:48:30', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (723, 6, N'services/colaborador/reembolso.php - uploadDocumento', N'Array
(
    [arquivo] => Uploads\p1d12hp9u78d66if1unnor61kfh3.jpg
    [idItem] => 
)
', N'2019-01-13 00:48:58', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (724, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 01-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:49:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (725, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 01-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:49:12', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (746, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (747, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (748, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (749, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (750, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (751, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (752, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (753, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (754, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:51:20', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (755, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:51:21', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (756, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 00:51:24', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (757, 6, N'services/colaborador/reembolso.php - getReembolsoItens', N'Array
(
    [id] => RD0001  
)
', N'2019-01-13 00:51:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (758, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (759, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (760, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (761, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (762, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (763, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:53:46', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (764, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:53:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (765, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:53:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (766, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:53:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (767, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:53:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (768, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 00:53:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (769, 6, N'services/colaborador/reembolso.php - getValidaDataLimite', N'Array
(
    [diaLimite] => 10
    [dataBase] => 01-2019
)
', N'2019-01-13 00:53:50', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (770, 6, N'services/colaborador/reembolso.php - getReembolsoItens', N'Array
(
    [id] => RD0001  
)
', N'2019-01-13 00:53:52', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (771, 6, N'services/colaborador/reembolso.php - getData', N'', N'2019-01-13 00:54:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (772, 6, N'services/corporativo/ccusto.php - getCcustoUsuarioReembolso', N'Array
(
    [empresa] => 1
)
', N'2019-01-13 00:54:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (773, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 02-01-2019
)
', N'2019-01-13 00:54:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (774, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 02-01-2019
)
', N'2019-01-13 00:54:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (775, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 02-01-2019
)
', N'2019-01-13 00:54:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (776, 6, N'services/cadastro/reembolso/limite.php - getLimite', N'Array
(
    [idNatureza] => 20002     
)
', N'2019-01-13 00:54:36', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (777, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 02-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:54:41', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (778, 6, N'services/colaborador/reembolso.php - uploadDocumento', N'Array
(
    [arquivo] => Uploads\p1d12i4500132a157i1hvvtvo1b3f3.png
    [idItem] => 
)
', N'2019-01-13 00:54:48', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (779, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 02-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:54:51', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (780, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 02-01-2019
)
', N'2019-01-13 00:54:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (781, 6, N'services/colaborador/reembolso.php - setReembolso', N'Array
(
    [id] => 
    [data_inclusao] => 13-01-2019
    [despesa] => 1
    [empresa] => 01
    [titulo] => Evento 2
    [data_base] => 01-2019
    [itens] => Array
        (
            [0] => Array
                (
                    [data] => 02-01-2019
                    [clienteId] => C00076601
                    [cliente] => 9INJET              
                    [naturezaId] => QUILOMETRAGEM
                    [natureza] => 20002     
                    [ccusto] => 1SPADM
                    [valor] => 84
                    [desconto] => 0.0
                    [total] => 84
                    [observacao] => 
                    [documento] => CP_bbc5002bec3ac68ef94b18cce5b92719.png
                )

        )

)
', N'2019-01-13 00:55:08', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (802, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (803, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (804, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (805, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (806, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (807, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (808, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (809, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (810, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:56:03', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (811, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:56:04', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (813, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (814, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (815, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (816, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (817, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 01:01:32', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (279, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (280, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (281, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (282, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (283, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (284, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (285, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (286, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:10', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (287, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (288, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (289, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (290, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (291, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (292, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (293, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (294, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (295, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (296, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (297, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (298, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (299, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:11', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (300, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (301, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (302, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (303, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (304, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (305, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (306, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (307, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (308, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (309, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (310, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (311, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:13', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (312, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [id] => 4
)
', N'2019-01-13 00:04:16', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (313, 1, N'services/acesso/usuario_permissao.php - uploadFoto', N'Array
(
    [arquivo] => Uploads\p1d12f7qd62a6pus1flv1bhcjg09.jpg
    [id] => 4
)
', N'2019-01-13 00:04:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (314, 1, N'services/acesso/usuario_permissao.php - setUsuario', N'Array
(
    [id] => 4
    [usuario] => emptecnologia.contato@gmail.com
    [nome] => Aprovador
    [sobrenome] => A1-G2
    [cpf] => 19751085829
    [senha] => 
    [id_grupo] => 1
    [id_conta] => 2
    [status] => 1
    [ccusto] => Array
        (
            [0] => Array
                (
                    [id_usuario] => 4
                    [id_ccusto] => 1SPADM
                    [ccusto] => ENERGIA-SP-ADMINISTRATIVO
                )

        )

)
', N'2019-01-13 00:04:25', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (315, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (316, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (317, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (318, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (319, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (320, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (321, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (322, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (323, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (324, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (325, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (326, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (327, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (328, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 2
)
', N'2019-01-13 00:04:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (329, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (330, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (331, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (332, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (333, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (334, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (335, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (336, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (337, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (338, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
GO
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (339, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (340, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (341, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (342, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 3
)
', N'2019-01-13 00:04:27', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (343, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (344, 1, N'services/corporativo/ccusto.php - getCcustoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (345, 1, N'services/acesso/usuario_permissao.php - getInfoUsuario', N'Array
(
    [idUsuario] => 4
)
', N'2019-01-13 00:04:28', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (726, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:50:06', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (727, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:50:06', 1, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (728, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (729, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (730, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (731, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (732, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (733, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (734, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (735, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:50:07', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (736, 6, N'services/colaborador/reembolso.php - getData', N'', N'2019-01-13 00:50:26', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (737, 6, N'services/corporativo/ccusto.php - getCcustoUsuarioReembolso', N'Array
(
    [empresa] => 1
)
', N'2019-01-13 00:50:33', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (738, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:50:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (739, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:50:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (740, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 01-01-2019
)
', N'2019-01-13 00:50:43', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (741, 6, N'services/cadastro/reembolso/limite.php - getLimite', N'Array
(
    [idNatureza] => 20014     
)
', N'2019-01-13 00:50:47', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (742, 6, N'services/colaborador/reembolso.php - uploadDocumento', N'Array
(
    [arquivo] => Uploads\p1d12ht15u1e7m6au1dui18j61dv13.jpg
    [idItem] => 
)
', N'2019-01-13 00:50:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (743, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 01-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:50:59', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (744, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 01-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:51:00', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (745, 6, N'services/colaborador/reembolso.php - setReembolso', N'Array
(
    [id] => 
    [data_inclusao] => 13-01-2019
    [despesa] => 1
    [empresa] => 01
    [titulo] => Evento 1
    [data_base] => 01-2019
    [itens] => Array
        (
            [0] => Array
                (
                    [data] => 01-01-2019
                    [clienteId] => C20046601
                    [cliente] =>  AMIL POSSOLO       
                    [naturezaId] => ALMOCO/JANTAR COM CLIENTES
                    [natureza] => 20014     
                    [ccusto] => 1SPADM
                    [valor] => 80
                    [desconto] => 0.0
                    [total] => 80
                    [observacao] => 
                    [documento] => CP_933d351ee33d7bf9fb2c5e9e70e68641.jpg
                )

        )

)
', N'2019-01-13 00:51:19', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (782, 6, N'services/colaborador/reembolso.php - getReembolso', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (783, 6, N'services/colaborador/reembolso.php - getReembolsoHistorico', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (784, 6, N'services/colaborador/reembolso.php - getDespesa', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (785, 6, N'services/corporativo/empresa.php - getEmpresaUsuario', N'Array
(
    [id] => 6
)
', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (786, 6, N'services/colaborador/reembolso.php - getCliente', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (787, 6, N'services/colaborador/reembolso.php - getNatureza', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (788, 6, N'services/colaborador/reembolso.php - getValorNaturezakm', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (789, 6, N'services/configuracao/parametros.php - getDataLimite_reembolso', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (790, 6, N'services/configuracao/parametros.php - getDiretorioReembolso', N'', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (791, 6, N'services/colaborador/reembolso.php - getDataBase', N'Array
(
    [data] => 10
)
', N'2019-01-13 00:55:09', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (792, 6, N'services/colaborador/reembolso.php - getData', N'', N'2019-01-13 00:55:18', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (793, 6, N'services/corporativo/ccusto.php - getCcustoUsuarioReembolso', N'Array
(
    [empresa] => 1
)
', N'2019-01-13 00:55:23', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (794, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 03-01-2019
)
', N'2019-01-13 00:55:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (795, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 03-01-2019
)
', N'2019-01-13 00:55:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (796, 6, N'services/colaborador/reembolso.php - getDataSemana', N'Array
(
    [dataItem] => 03-01-2019
)
', N'2019-01-13 00:55:31', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (797, 6, N'services/cadastro/reembolso/limite.php - getLimite', N'Array
(
    [idNatureza] => 20007     
)
', N'2019-01-13 00:55:42', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (798, 6, N'services/colaborador/reembolso.php - uploadDocumento', N'Array
(
    [arquivo] => Uploads\p1d12i64ea1rmo13kh1uo8lqjc623.png
    [idItem] => 
)
', N'2019-01-13 00:55:53', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (799, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 03-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:55:55', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (800, 6, N'services/colaborador/reembolso.php - getValidaPeriodoDataItem', N'Array
(
    [dataItem] => 03-01-2019
    [dataBase] => 01-2019
)
', N'2019-01-13 00:55:57', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (801, 6, N'services/colaborador/reembolso.php - setReembolso', N'Array
(
    [id] => 
    [data_inclusao] => 13-01-2019
    [despesa] => 1
    [empresa] => 01
    [titulo] => Evento 3
    [data_base] => 01-2019
    [itens] => Array
        (
            [0] => Array
                (
                    [data] => 03-01-2019
                    [clienteId] => C00000101
                    [cliente] => A.SCHULMAN          
                    [naturezaId] => LOCACAO DE VEICULOS
                    [natureza] => 20007     
                    [ccusto] => 1SPADM
                    [valor] => 150
                    [desconto] => 0.0
                    [total] => 150
                    [observacao] => 
                    [documento] => CP_792ea3b98948ba427e4a14cc0042d7d9.png
                )

        )

)
', N'2019-01-13 00:56:02', 0, 0)
INSERT [dbo].[log_servicos] ([id], [usuario], [funcao], [parametros], [hora], [duracao], [ambiente]) VALUES (812, 6, N'services/geral/login.php - logar', N'Array
(
    [usuario] => oldwave.studio@gmail.com
    [senha] => 12345
)
', N'2019-01-13 01:01:25', 0, 0)
SET IDENTITY_INSERT [dbo].[log_servicos] OFF
SET IDENTITY_INSERT [dbo].[paginas] ON 

INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (1, N'fb00013c-91f0-457b-bc68-8edb9cdb0c2c', N'Acesso', N'', N'fa fa-unlock-alt', 0, 1, NULL, 7, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (2, N'db9de3b4-edb0-4d01-a76c-be8468ec1080', N'<span class="fa fa-user"></span>  Usuários', N'pages/acesso/usuario.html', N'', 0, 1, 1, 1, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (3, N'fad2d57e-4219-4e61-a031-c0de69e944bc', N'<span class="fa fa-key"></span>  Permissões', N'pages/configuracao/permissao.html', N'', 0, 1, 57, 2, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (4, N'7c3eaac3-6287-45f0-bebd-f21fdcc7df1c', N'Meu perfil', N'pages/acesso/perfil.html', N'fa fa-info', 0, 1, NULL, 9, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (95, N'76400899-1ee0-4298-9bca-b586d7210404', N'Financeiro', NULL, N'', 0, 1, 85, 2, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (40, N'c8020a25-4817-42e8-a1f1-2473da2dfeac', N'Painel', N'pages/painel/painel.html', N'fa fa-desktop', 0, 1, NULL, 1, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (41, N'0884e834-ad70-4ea9-822a-989455623995', N'Corporativo', N'', N'fa fa-building-o', 0, 1, NULL, 2, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (42, N'b2b8c4ef-118a-4cbf-8c2b-782911a90da6', N'
Grupo de Empresas', N'pages/corporativo/empresa.html', N'fa fa-group', 0, 1, 41, 1, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (43, N'319bc746-66e0-4129-ad8b-0546c25596bf', N'
Filiais', N'pages/corporativo/filial.html', NULL, 0, 1, 41, 2, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (96, N'1dec8bf7-230e-44b8-b613-af2868e9c189', N'<span class="fa fa-thumbs-up"></span> Aprovação', N'pages/processo/financeiro/aprovacao.html', N'', 0, 1, 95, 1, 3, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (46, N'6be538d0-5b61-4f2e-85d0-6413e77d91dd', N'
Centros de Custo', N'pages/corporativo/ccusto.html', NULL, 0, 1, 41, 3, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (47, N'c931eca7-29dc-40f7-81c7-65f26d138c82', N'Colaborador', N'', N'fa fa-user', 0, 1, NULL, 3, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (48, N'eef64cf5-f05d-47ab-a75c-778c7aac714d', N'<span class="fa fa-folder-open"></span>  Meus documentos', N'pages/colaborador/documento.html', NULL, 0, 1, 47, 1, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (49, N'3af84de5-1d59-41d3-b7b9-ef8fa3aab3ac', N'<span class="fa fa-reply-all"></span>  Reembolso de Despesas', N'pages/colaborador/reembolso.html', NULL, 0, 1, 47, 3, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (98, N'77d1f07c-ba5c-4326-9146-a79fb66ed01d', N'<span class="fa fa-puzzle-piece"></span>  Parâmetros', N'pages/configuracao/parametros.html', NULL, 0, 1, 57, 2, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (104, N'803c1ea0-8eaf-495a-bbab-83bcdd847f20', N'<span class="fa fa-group"></span>  Meus grupos', N'pages/colaborador/grupo.html', NULL, 0, 1, 47, 2, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (52, N'0c5b4aaa-0fe9-409c-bd2a-cf756c3f0f2f', N'Compartilhamento', NULL, N'fa fa-share', 0, 1, NULL, 4, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (55, N'20a37443-52a6-4075-8662-4d1c0f90bcda', N'<span class="fa fa-file"></span>  Documentos', N'pages/compartilhamento/documento.html', NULL, 0, 1, 52, 3, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (57, N'26c8cf23-4504-4a8e-8f0d-223ba26fb950', N'Configurações', N'', N'fa fa-cog', 0, 1, NULL, 8, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (58, N'b71e31f2-6e9e-4885-be1f-5c16fa28a0c0', N'Cadastros', N'', N'fa fa-pencil', 0, 1, NULL, 5, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (59, N'b492119b-794e-498a-9d86-f68a19d0a47e', N'Reembolso de Despesas', N'', NULL, 0, 1, 58, 1, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (68, N'b08f7dad-2729-47e1-ae29-d1b72988170c', N'<span class="fa fa-legal"></span>  Aprovadores', N'pages/cadastro/reembolso/grupo.html', N'', 0, 1, 59, 1, 3, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (85, N'2848be67-0399-4a89-accc-59610ceb9855', N'Processos', NULL, N'fa fa-tasks', 0, 1, NULL, 6, 1, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (88, N'5f4769ba-c5a8-4008-b9bd-405f4a3860ca', N'Reeembolso de Despesas', N'', N'', 0, 1, 85, 1, 2, 1)
INSERT [dbo].[paginas] ([id], [permissao], [nome], [local], [icone], [desenvolvimento], [menu], [pai], [ordem], [nivel], [verificar]) VALUES (90, N'2c023613-49b4-435d-be0b-51ebec44e981', N'<span class="fa fa-thumbs-up"></span>  Aprovação', N'pages/processo/reembolso/aprovacao.html', N'', 0, 1, 88, 1, 3, 1)
SET IDENTITY_INSERT [dbo].[paginas] OFF
SET IDENTITY_INSERT [dbo].[permissoes_contaf] ON 

INSERT [dbo].[permissoes_contaf] ([id], [id_conta], [id_permissao]) VALUES (25, 2, 2)
INSERT [dbo].[permissoes_contaf] ([id], [id_conta], [id_permissao]) VALUES (26, 2, 3)
INSERT [dbo].[permissoes_contaf] ([id], [id_conta], [id_permissao]) VALUES (27, 2, 11)
INSERT [dbo].[permissoes_contaf] ([id], [id_conta], [id_permissao]) VALUES (28, 2, 17)
INSERT [dbo].[permissoes_contaf] ([id], [id_conta], [id_permissao]) VALUES (29, 2, 47)
SET IDENTITY_INSERT [dbo].[permissoes_contaf] OFF
SET IDENTITY_INSERT [dbo].[permissoes_contap] ON 

INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (234, 2, 104)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (313, 6, 42)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (314, 6, 43)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (315, 6, 46)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (316, 6, 47)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (317, 6, 48)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (33, 3, 1)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (318, 6, 104)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (319, 6, 49)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (36, 3, 4)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (320, 6, 52)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (321, 6, 55)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (322, 6, 58)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (323, 6, 59)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (41, 3, 40)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (42, 3, 47)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (324, 6, 68)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (325, 6, 85)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (326, 6, 88)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (327, 6, 90)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (328, 6, 95)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (329, 6, 96)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (330, 6, 1)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (331, 6, 2)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (332, 6, 57)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (333, 6, 98)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (334, 6, 3)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (21, 3, 48)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (22, 3, 49)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (213, 2, 40)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (214, 2, 41)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (215, 2, 42)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (216, 2, 43)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (217, 2, 46)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (218, 2, 47)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (219, 2, 48)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (220, 2, 49)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (221, 2, 52)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (222, 2, 55)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (223, 2, 58)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (224, 2, 59)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (225, 2, 68)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (226, 2, 85)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (227, 2, 88)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (77, 3, 85)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (78, 3, 95)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (79, 3, 96)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (228, 2, 90)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (229, 2, 95)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (230, 2, 96)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (231, 2, 1)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (232, 2, 2)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (233, 2, 4)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (307, 5, 40)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (308, 5, 47)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (309, 5, 48)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (310, 5, 104)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (311, 5, 49)
INSERT [dbo].[permissoes_contap] ([id], [id_conta], [id_permissao]) VALUES (312, 5, 4)
SET IDENTITY_INSERT [dbo].[permissoes_contap] OFF
SET IDENTITY_INSERT [dbo].[reembolso_aprovador_grupo] ON 

INSERT [dbo].[reembolso_aprovador_grupo] ([id], [nome], [descricao], [id_departamento]) VALUES (1, N'GRUPO-MASTER', N'ADM', 1)
INSERT [dbo].[reembolso_aprovador_grupo] ([id], [nome], [descricao], [id_departamento]) VALUES (2, N'GRUPO-G1', N'Grupo Destinado a Testes de aprovacao', 1)
INSERT [dbo].[reembolso_aprovador_grupo] ([id], [nome], [descricao], [id_departamento]) VALUES (3, N'GRUPO-G2', N'Grupo Destinado a Testes de aprovacao ', 14)
SET IDENTITY_INSERT [dbo].[reembolso_aprovador_grupo] OFF
INSERT [dbo].[reembolso_aprovador_usuario] ([id_grupo], [id_usuario], [ordem], [alcada_inicio], [alcada_fim]) VALUES (1, 1, 1, CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[reembolso_aprovador_usuario] ([id_grupo], [id_usuario], [ordem], [alcada_inicio], [alcada_fim]) VALUES (2, 2, 2, CAST(100.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)))
INSERT [dbo].[reembolso_aprovador_usuario] ([id_grupo], [id_usuario], [ordem], [alcada_inicio], [alcada_fim]) VALUES (3, 4, 1, CAST(0.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)))
INSERT [dbo].[reembolso_aprovador_usuario] ([id_grupo], [id_usuario], [ordem], [alcada_inicio], [alcada_fim]) VALUES (3, 5, 2, CAST(150.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)))
INSERT [dbo].[reembolso_aprovador_usuario] ([id_grupo], [id_usuario], [ordem], [alcada_inicio], [alcada_fim]) VALUES (2, 3, 1, CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[reembolso_guia_aprovador] ([id_reeembolso], [data_base], [total_mes], [inicio_aprov], [fim_aprov], [data_envio]) VALUES (N'RD0002', N'01-2019', N'164.00', 1, 2, CAST(N'2019-01-13T02:04:24.013' AS DateTime))
INSERT [dbo].[reembolso_guia_aprovador] ([id_reeembolso], [data_base], [total_mes], [inicio_aprov], [fim_aprov], [data_envio]) VALUES (N'RD0001', N'01-2019', N'80.00', 1, 1, CAST(N'2019-01-13T01:11:28.887' AS DateTime))
INSERT [dbo].[reembolso_guia_aprovador] ([id_reeembolso], [data_base], [total_mes], [inicio_aprov], [fim_aprov], [data_envio]) VALUES (N'RD0003', N'01-2019', N'314.00', 1, 2, CAST(N'2019-01-13T01:11:55.097' AS DateTime))
INSERT [dbo].[reembolso_itens] ([id], [data_item], [id_reembolso_solicitacao], [id_cliente], [id_natureza], [id_ccusto], [valor], [observacao], [documento], [id_reembolso], [desconto], [total]) VALUES (1, N'01-01-2019', 1, N'C20046601', N'20014     ', N'1SPADM', N'80', N'', N'CP_933d351ee33d7bf9fb2c5e9e70e68641.jpg', N'RD0001', N'0.0', N'80')
INSERT [dbo].[reembolso_itens] ([id], [data_item], [id_reembolso_solicitacao], [id_cliente], [id_natureza], [id_ccusto], [valor], [observacao], [documento], [id_reembolso], [desconto], [total]) VALUES (1, N'03-01-2019', 3, N'C00000101', N'20007     ', N'1SPADM', N'150', N'', N'CP_792ea3b98948ba427e4a14cc0042d7d9.png', N'RD0003', N'0.0', N'150')
INSERT [dbo].[reembolso_itens] ([id], [data_item], [id_reembolso_solicitacao], [id_cliente], [id_natureza], [id_ccusto], [valor], [observacao], [documento], [id_reembolso], [desconto], [total]) VALUES (1, N'02-01-2019', 2, N'C00076601', N'20002     ', N'1SPADM   ', N'84', N'', N'CP_bbc5002bec3ac68ef94b18cce5b92719.png', N'RD0002', N'0.0', N'84')
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20002', 120)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20003', 65)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20004', 40)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20005', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20006', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20007', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'21007', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'17001', 183)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'18012', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20009', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20010', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20012', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20013', -1)
INSERT [dbo].[reembolso_limites] ([id_natureza], [limite]) VALUES (N'20014', 98)
SET IDENTITY_INSERT [dbo].[reembolso_mensagem] ON 

INSERT [dbo].[reembolso_mensagem] ([id_reembolso], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'RD0003', N'Minha Mensagem de reprovação ao usuário Colaborador C1-G1

Att Aprovador A1-G1', 1, 3, 200, CAST(N'2019-01-13T01:24:35.840' AS DateTime), 44)
INSERT [dbo].[reembolso_mensagem] ([id_reembolso], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'RD0002', N'Minha mensagem de negação de reeembolso somada as justificativas 

Att, A2-G1', 2, 2, 110, CAST(N'2019-01-13T01:43:50.803' AS DateTime), 47)
INSERT [dbo].[reembolso_mensagem] ([id_reembolso], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'RD0002', N'Minha Mensagem de revisão para o aprovador Colaborador C1-G1

Att, Aprovador A1-G1 ', 1, 3, 210, CAST(N'2019-01-13T02:02:25.053' AS DateTime), 48)
INSERT [dbo].[reembolso_mensagem] ([id_reembolso], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'RD0002', N'Minha Mensagem de Negação acompanhadas de  justificativas

Att Aprovador A2-G1 ', 2, 2, 110, CAST(N'2019-01-13T01:32:49.360' AS DateTime), 45)
INSERT [dbo].[reembolso_mensagem] ([id_reembolso], [mensagem], [tipo], [id_usuario], [status], [data], [id]) VALUES (N'RD0002', N'Minha Mensagem de revisão para o colaborador Colaborador C1-G1

Att, Aprovador A1-G1', 1, 3, 210, CAST(N'2019-01-13T01:39:32.323' AS DateTime), 46)
SET IDENTITY_INSERT [dbo].[reembolso_mensagem] OFF
SET IDENTITY_INSERT [dbo].[reembolso_solicitacao] ON 

INSERT [dbo].[reembolso_solicitacao] ([id], [id_usuario], [data_inclusao], [data_envio], [data_edicao], [id_tipo_despesa], [id_status], [titulo_evento], [id_empresa], [mensagem_status], [mensagem], [id_format], [id_protheus], [data_aprov], [data_aprov_protheus], [data_vencimento], [data_base]) VALUES (1, 6, N'13-01-2019', N'13-01-2019', NULL, 1, 100, N'Evento 1', 1, NULL, NULL, N'RD0001  ', NULL, NULL, NULL, NULL, N'01-2019')
INSERT [dbo].[reembolso_solicitacao] ([id], [id_usuario], [data_inclusao], [data_envio], [data_edicao], [id_tipo_despesa], [id_status], [titulo_evento], [id_empresa], [mensagem_status], [mensagem], [id_format], [id_protheus], [data_aprov], [data_aprov_protheus], [data_vencimento], [data_base]) VALUES (2, 6, N'13-01-2019', N'13-01-2019', NULL, 1, 100, N'Evento 2', 1, NULL, NULL, N'RD0002  ', NULL, NULL, NULL, NULL, N'01-2019')
INSERT [dbo].[reembolso_solicitacao] ([id], [id_usuario], [data_inclusao], [data_envio], [data_edicao], [id_tipo_despesa], [id_status], [titulo_evento], [id_empresa], [mensagem_status], [mensagem], [id_format], [id_protheus], [data_aprov], [data_aprov_protheus], [data_vencimento], [data_base]) VALUES (3, 6, N'13-01-2019', N'13-01-2019', NULL, 1, 200, N'Evento 3', 1, NULL, NULL, N'RD0003  ', NULL, NULL, NULL, NULL, N'01-2019')
SET IDENTITY_INSERT [dbo].[reembolso_solicitacao] OFF
SET IDENTITY_INSERT [dbo].[reembolso_status] ON 

INSERT [dbo].[reembolso_status] ([id], [descricao]) VALUES (1, N'Edição')
INSERT [dbo].[reembolso_status] ([id], [descricao]) VALUES (2, N'Enviado')
INSERT [dbo].[reembolso_status] ([id], [descricao]) VALUES (3, N'Em análise')
INSERT [dbo].[reembolso_status] ([id], [descricao]) VALUES (4, N'Aprovado')
INSERT [dbo].[reembolso_status] ([id], [descricao]) VALUES (5, N'Reprovado')
SET IDENTITY_INSERT [dbo].[reembolso_status] OFF
SET IDENTITY_INSERT [dbo].[reembolso_tipo_despesa] ON 

INSERT [dbo].[reembolso_tipo_despesa] ([id], [descricao]) VALUES (1, N'REEMBOLSO')
INSERT [dbo].[reembolso_tipo_despesa] ([id], [descricao]) VALUES (3, N'AUXILIO SAÚDE')
SET IDENTITY_INSERT [dbo].[reembolso_tipo_despesa] OFF
INSERT [dbo].[temp_usuario] ([id_temp]) VALUES (97)
INSERT [dbo].[temp_usuario] ([id_temp]) VALUES (97)
SET IDENTITY_INSERT [dbo].[usuario] ON 

INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (1, N'loopconsultoria.brito@gmail.com', N'Master', 1, N'40bd001563085fc35165329ea1ff5c5ecbdbbeef', 1, N'Admin', N'00000000000', 1, N'12-01-2019', N'12-01-2019')
INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (5, N'emptecnologia.projetos@gmail.com', N'Aprovador', 2, N'8cb2237d0679ca88db6464eac60da96345513964', 1, N'A2-G2', N'32734618885', 1, NULL, N'Jan 12 2019 11:53PM')
INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (6, N'oldwave.studio@gmail.com', N'Colaborador', 5, N'8cb2237d0679ca88db6464eac60da96345513964', 1, N'C1-G1', N'16510717808', 2, NULL, N'Jan 13 2019 12:18AM')
INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (2, N'brunobrito.contato@gmail.com', N'Aprovador', 2, N'8cb2237d0679ca88db6464eac60da96345513964', 1, N'A2-G1', N'13596180821', 1, NULL, N'Jan 12 2019 10:52PM')
INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (3, N'bruno.britto.android@gmail.com', N'Aprovador', 2, N'8cb2237d0679ca88db6464eac60da96345513964', 1, N'A1-G1', N'30280426810', 1, NULL, N'Jan 12 2019 11:04PM')
INSERT [dbo].[usuario] ([id], [usuario], [nome], [conta], [senha], [ativo], [sobrenome], [cpf], [id_grupo], [data_ativacao], [data_registro]) VALUES (4, N'emptecnologia.contato@gmail.com', N'Aprovador', 2, N'8cb2237d0679ca88db6464eac60da96345513964', 1, N'A1-G2', N'19751085829', 1, NULL, N'Jan 12 2019 11:05PM')
SET IDENTITY_INSERT [dbo].[usuario] OFF
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (2, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (3, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (4, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (5, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (6, N'2SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (6, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (1, N'1SPADM')
INSERT [dbo].[usuario_ccusto] ([id_usuario], [id_ccusto]) VALUES (1, N'2SPEFE')
INSERT [dbo].[usuario_status] ([id], [status]) VALUES (0, N'Inativo')
INSERT [dbo].[usuario_status] ([id], [status]) VALUES (1, N'Ativo')
INSERT [dbo].[usuario_status] ([id], [status]) VALUES (2, N'Não ativado')
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_reembolso_guia_aprovador]    Script Date: 14-Jan-19 12:23:12 PM ******/
CREATE NONCLUSTERED INDEX [idx_reembolso_guia_aprovador] ON [dbo].[reembolso_guia_aprovador]
(
	[id_reeembolso] ASC,
	[fim_aprov] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [reembolso_itens_index]    Script Date: 14-Jan-19 12:23:12 PM ******/
CREATE NONCLUSTERED INDEX [reembolso_itens_index] ON [dbo].[reembolso_itens]
(
	[id_reembolso] ASC,
	[id] ASC,
	[valor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_reembolso_solicitacao]    Script Date: 14-Jan-19 12:23:12 PM ******/
CREATE NONCLUSTERED INDEX [idx_reembolso_solicitacao] ON [dbo].[reembolso_solicitacao]
(
	[id] ASC,
	[id_format] ASC,
	[data_base] ASC,
	[titulo_evento] ASC,
	[data_inclusao] ASC,
	[data_envio] ASC,
	[id_status] ASC,
	[id_usuario] ASC,
	[id_tipo_despesa] ASC,
	[id_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[reembolso_itens] ADD  CONSTRAINT [reembolso_itens_desconto_default]  DEFAULT ((0.0)) FOR [desconto]
GO
