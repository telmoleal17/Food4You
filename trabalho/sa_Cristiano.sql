USE master
create database lab

USE lab
CREATE TABLE Utilizador(
	nome				VARCHAR(35) NOT NULL,
	email				VARCHAR(35) NOT NULL,
	username			VARCHAR(20) PRIMARY KEY NOT NULL,
	pass_word			VARCHAR(20) NOT NULL,
	foto				VARCHAR(50),
	ContaConfirmada		BIT DEFAULT(0) NOT NULL,
);

USE lab
CREATE TABLE Cliente(
	Username				VARCHAR(20) PRIMARY KEY  NOT NULL,
);

USE lab
CREATE TABLE Prato_Dia(
	ID			INTEGER NOT NULL IDENTITY,
	Nome		VARCHAR(35) NOT NULL,
	tipo		VARCHAR(15) NOT NULL,
	preco		FLOAT NOT NULL,
	descricao	VARCHAR(100) NOT NULL,
	foto		VARCHAR(50),
	PRIMARY KEY(ID),
);

USE lab
CREATE TABLE Administrador(
	Username	VARCHAR(20) PRIMARY KEY NOT NULL,
	FOREIGN KEY (Username) references Utilizador(username),
	
);

USE lab
CREATE TABLE RestaurantesAprovados(
	Username				VARCHAR(20) NOT NULL,
    Nome					VARCHAR(35) NOT NULL,
	morada					VARCHAR(50) NOT NULL,				
	telefone				INT NOT NULL,
	gps						VARCHAR(50) NOT NULL,
	horario					VARCHAR(100) NOT NULL,
	Dia_Descanso			VARCHAR(25) NOT NULL,
	tipo_servico			VARCHAR(50) NOT NULL,
	Foto					Varchar(50) NOT NULL,
	QuemAprovou				Varchar(20),
	PRIMARY KEY(Username,QuemAprovou),
	CHECK(QuemAprovou != 'NULL'),

);

USE lab
CREATE TABLE Bloquear(
	Username_Administrador	VARCHAR(20) NOT NULL,
	Username_Utilizador		VARCHAR(20) NOT NULL,
	motivo					VARCHAR(50) NOT NULL,
	DataBloqueio			DATE NOT NULL,
	PRIMARY KEY(Username_Utilizador,DataBloqueio),
	FOREIGN KEY (Username_Administrador) references Administrador(Username),
	FOREIGN KEY (Username_Utilizador) references Utilizador(username),
);

USE lab
CREATE TABLE Possuir(
	ID_Prato				INT NOT NULL,
	Username_Restaurante	VARCHAR(20) NOT NULL,
	Data_PratoDia			DATE NOT NULL,
	PRIMARY KEY(ID_Prato,Username_Restaurante),
	FOREIGN KEY (ID_Prato) references Prato_Dia(ID),
);


-- ########### Linked Server 1 ###########

GO
USE master

EXEC sp_addlinkedserver @server = 'tabd5',
   @srvproduct = 'SQLServer Native Client OLEDB Provider',
   @provider = 'SQLNCLI',
   @datasrc = '25.78.100.41'

EXEC sp_addlinkedsrvlogin @rmtsrvname = 'tabd5',
   @useself = 'FALSE',
   @locallogin = 'sa',
   @rmtuser = 'sa',
   @rmtpassword = 'sqlpass321'



-- ############ LOGINS #############


GO

CREATE LOGIN ClienteL WITH PASSWORD = '123456'
CREATE LOGIN RestauranteL WITH PASSWORD = '123456'
CREATE LOGIN AdminL WITH PASSWORD = '123456'
CREATE LOGIN AnonimoL WITH PASSWORD = '123456'

GO

USE lab
GO

-- CRIAR USERS

CREATE USER ClienteU FOR LOGIN ClienteL
CREATE USER RestauranteU FOR LOGIN RestauranteL
CREATE USER AdminU FOR LOGIN AdminL
CREATE USER AnonimoU FOR LOGIN AnonimoL

GO

-- CRIAR ROLES E ASSOCIAR USER

CREATE ROLE ClienteR 
CREATE ROLE RestauranteR 
CREATE ROLE AdminR 
CREATE ROLE AnonimoR 

ALTER ROLE ClienteR ADD ClienteU
ALTER ROLE RestauranteR ADD RestauranteU
ALTER ROLE AdminR ADD AdminU
ALTER ROLE AnonimoR ADD AnonimoU


--################ Permissoes ################

--Anonimo
GRANT SELECT ON RestaurantesAprovados TO AnonimoU
GRANT SELECT ON Prato_Dia TO AnonimoU
GRANT SELECT ON Possuir TO AnonimoU

--Clientes

GRANT SELECT ON RestaurantesAprovados TO ClienteU
GRANT SELECT ON Prato_Dia TO ClienteU
GRANT SELECT ON RestaurantesFavoritos TO ClienteU
GRANT SELECT ON PratosFavoritos TO ClienteU
GRANT SELECT ON Avaliar_pratos TO ClienteU
GRANT SELECT ON Avaliar_restaurante TO ClienteU
GRANT SELECT ON Possuir TO ClienteU
GRANT INSERT,DELETE ON RestaurantesFavoritos TO ClienteU
GRANT INSERT,DELETE ON PratosFavoritos TO ClienteU
GRANT INSERT,UPDATE,DELETE ON Avaliar_pratos TO ClienteU
GRANT INSERT,UPDATE,DELETE ON Avaliar_restaurantes TO ClienteU


-- ############## PERMISSOES VIEWS ##############
GRANT SELECT ON Pratos_Dia_Favoritos TO AdminU
GRANT SELECT ON RestaurantesFav TO AdminU
GRANT SELECT ON AvaliarRestaurantes TO AdminU
GRANT SELECT ON AvaliarPratos TO AdminU

-- ############## PERMISSOES PROCEDURES ##############
GRANT EXECUTE ON CriarCliente TO AdminU
GRANT EXECUTE ON ConfirmarConta TO AdminU
GRANT EXECUTE ON AddAvaliar_pratos TO AdminU
GRANT EXECUTE ON AddAvaliar_restaurantes TO AdminU
GRANT EXECUTE ON AddRestaurantesFavoritos TO AdminU
GRANT EXECUTE ON AddPratosFavoritos TO AdminU
GRANT EXECUTE ON Delete_Avaliar_pratos TO AdminU
GRANT EXECUTE ON Delete_Avaliar_restaurantes TO AdminU
GRANT EXECUTE ON Delete_RestaurantesFavoritos TO AdminU
GRANT EXECUTE ON Delete_PratosFavoritos TO AdminU


GO

-- Restaurantes 

GRANT SELECT ON RestaurantesAprovados TO RestauranteU
GRANT SELECT ON Prato_Dia TO RestauranteU
GRANT SELECT ON Possuir TO RestauranteU
GRANT INSERT,UPDATE,DELETE ON Possuir TO RestauranteU
GRANT INSERT,UPDATE,DELETE ON Prato_Dia TO RestauranteU

-- ############## PERMISSOES PROCEDURES ##############
GRANT EXECUTE ON CriarRestaurante TO AdminU
GRANT EXECUTE ON AddPrato_Dia TO AdminU
GRANT EXECUTE ON Delete_Prato_Dia TO AdminU

GO

--Admin

-- PERMISSOES BASE DE DADOS

GRANT SELECT,INSERT ON Utilizador TO AdminU
GRANT SELECT,INSERT ON Cliente TO AdminU
GRANT SELECT,INSERT ON RestaurantesAprovados TO AdminU
GRANT SELECT,INSERT ON Administrador TO AdminU
GRANT SELECT ON Prato_Dia TO AdminU
GRANT SELECT ON Possuir TO AdminU
GRANT SELECT ON PratosFavoritos TO AdminU
GRANT SELECT ON RestaurantesFavoritos TO AdminU
GRANT SELECT ON Avaliar_restaurates TO AdminU
GRANT SELECT ON Avaliar_pratos  TO AdminU


-- PERMISSOES DAS VIEWS

GRANT SELECT ON TodosRestaurantes TO AdminU
GRANT SELECT ON RestaurantesNaoAprovados TO AdminU
GRANT SELECT ON Restaurantes_Aprovados TO AdminU


-- PERMISSOES PROCEDURES

GRANT EXECUTE ON CriarAdmin TO AdminU
GRANT EXECUTE ON BloqUtilizador TO AdminU
GRANT EXECUTE ON DesbloquearUtilizador TO AdminU



GO


-- ########### Views ################

USE lab
GO
CREATE VIEW TodosRestaurantes
AS
SELECT * FROM RestaurantesAprovados
UNION ALL
SELECT * FROM tabd5.lab.dbo.RestaurantesNaoAprovados

GO

USE lab
GO
CREATE VIEW Restaurantes_Aprovados
AS
SELECT * FROM RestaurantesAprovados
GO

USE lab
GO
CREATE VIEW RestaurantesNaoAprovados
AS
SELECT * FROM tabd5.lab.dbo.RestaurantesNaoAprovados
GO

USE lab
GO
CREATE VIEW Pratos_Dia_Favoritos
AS
SELECT * FROM tabd5.lab.dbo.PratosFavoritos
GO

USE lab
GO
CREATE VIEW RestaurantesFav
AS
SELECT * FROM tabd5.lab.dbo.RestaurantesFavoritos
GO

USE lab
GO
CREATE VIEW AvaliarRestaurantes
AS
SELECT * FROM tabd5.lab.dbo.Avaliar_restaurates
GO


USE lab
GO
CREATE VIEW AvaliarPratos
AS
SELECT * FROM tabd5.lab.dbo.Avaliar_pratos
GO

-- ############## PROCEDURES / TRANSACOES #####################

create procedure CriarCliente
	@nome					VARCHAR(35), 
	@email					VARCHAR(35), 
	@username				VARCHAR(20),
	@pass_word				VARCHAR(20), 
	@foto					VARCHAR(50)

as
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin tran
			BEGIN
				insert into Cliente(Username)
					Values(@username)
				insert into Utilizador(nome,email,username,pass_word,foto,ContaConfirmada)
					Values(@nome,@email,@username,@pass_word,@foto,'0')
	
				IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
					GOTO ERRO
				commit
			END
return 1

ERRO:
	rollback
	return -1

GO

create procedure CriarRestaurante
	@Username				VARCHAR(20),
    @Nome					VARCHAR(35),
	@morada					VARCHAR(50),				
	@telefone				INT,
	@gps					VARCHAR(50),
	@horario				VARCHAR(100),
	@Dia_Descanso			VARCHAR(25),
	@tipo_servico			VARCHAR(50),
	@Foto					Varchar(50),
	@email					VARCHAR(35), 
	@pass_word				VARCHAR(20),
	@quemAprovou			VARCHAR(20)

as
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin tran
		BEGIN
			insert into TodosRestaurantes(Username,Nome,morada,telefone,gps,horario,Dia_Descanso,tipo_servico,Foto,QuemAprovou)
				Values(@Username,@Nome,@morada,@telefone,@gps,@horario,@Dia_Descanso,@tipo_servico,@Foto,@quemAprovou)

			insert into Utilizador(nome,email,username,pass_word,foto,ContaConfirmada)
				Values(@nome,@email,@pass_word,@foto,'0')

			IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
				GOTO ERRO
			commit
		END
return 1

ERRO:
	rollback
	return -1

GO

create procedure CriarAdmin		
	@nome					VARCHAR(35), 
	@email					VARCHAR(35), 
	@username				VARCHAR(20),
	@pass_word				VARCHAR(20), 
	@foto					VARCHAR(50)

as
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin tran
		BEGIN
			insert into Administrador(Username)
				Values(@username)
			insert into Utilizador(nome,email,username,pass_word,foto,ContaConfirmada)
				Values(@nome,@email,@username,@pass_word,@foto,'1')
	
			IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
				GOTO ERRO
			commit
		END
return 1

ERRO:
	rollback
	return -1

GO

-- ################################# PROCEDIMENTOS ################################

go

create procedure BloqUtilizador
		@UsernameUtilizador varchar(20), @UsernameAdmin varchar(20), @motivo varchar(50)
as
				insert into Bloquear(Username_Administrador,Username_Utilizador,motivo,DataBloqueio)
					Values(@UsernameAdmin,@UsernameUtilizador,@motivo,CURRENT_TIMESTAMP)

				IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
					GOTO ERRO
			
RETURN 1

ERRO:
	RETURN -1

GO

create procedure DesbloquearUtilizador
		@UsernameUtilizador varchar(20), @UsernameAdmin varchar(20)
as
		DELETE FROM Bloquear 
		WHERE Username_Administrador = @UsernameAdmin AND Username_Utilizador = @UsernameUtilizador

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO
		COMMIT
RETURN 1

ERRO:
	RETURN -1

GO

create procedure ConfirmarConta
	@username				VARCHAR(20)
as
		UPDATE Utilizador
		SET ContaConfirmada = '1'
		where username = @username

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			BEGIN
				GOTO ERRO
			END

return 1

ERRO:
	return -1

-- Prato Dia INSERT AND DELETE --

GO
create procedure AddPrato_Dia
	@ID int , @Nome varchar ,@tipo varchar , @preco float , @descricao varchar , @foto varchar , @UsernameRestaurante varchar

	as
		insert into Prato_Dia(ID,Nome,tipo,preco,descricao,foto)
			values(@ID,@Nome,@tipo,@preco,@descricao,@foto)
				
		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO


		ELSE
			BEGIN
				GOTO ERRO
			END
			
return 1

ERRO:
	return -1

GO
create procedure Delete_Prato_Dia
	@ID int , @UsernameRestaurante varchar

	as
			BEGIN
				DELETE FROM Prato_Dia WHERE ID = @ID

			END
		
		IF(@@ERROR <> 0)
			BEGIN
				GOTO ERRO
			END 

return 1

ERRO:
	return -1



-- Avaliar Pratos / Avaliar Restaurantes / RestaurantesFavoritos / --

GO

create procedure AddAvaliar_pratos
	@UsernameCliente varchar,@avaliacao varchar, @comentario varchar

	as
		IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente))
			BEGIN
				insert into AvaliarPratos(Username_Cliente,avaliacao,comentario)
					values(@UsernameCliente,@avaliacao,@comentario)
			END
		
		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			BEGIN
				GOTO ERRO
			END

return 1

ERRO:
	return -1

GO

create procedure AddAvaliar_restaurantes
	@UsernameRestaurante varchar, @UsernameCliente varchar , @avaliacao varchar, @comentario varchar

	as
		IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM RestaurantesAprovados WHERE Username = @UsernameRestaurante)
			BEGIN 
				insert into AvaliarPratos(Username_Restaurante,Username_Cliente,avaliacao,comentario)
					values(@UsernameRestaurante,@UsernameCliente,@avaliacao,@comentario)
			END
	
		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			BEGIN
				GOTO ERRO
			END

return 1

ERRO:
	return -1

GO

create procedure AddRestaurantesFavoritos
	@UsernameRestaurante varchar , @UsernameCliente varchar

	as
	IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM RestaurantesAprovados WHERE Username = @UsernameRestaurante)
		BEGIN
			insert into RestaurantesFav(UsernameCliente,UsernameRestaurante)
				values(@UsernameCliente,@UsernameRestaurante)
		END

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO

return 1

ERRO:
	return -1

GO
create procedure AddPratosFavoritos
	@UsernameCliente varchar ,
	@Id_Prato integer

	as
	IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Prato_Dia WHERE ID = @Id_Prato)
		BEGIN
			insert into Pratos_Dia_Favoritos(UsernameCliente,Id_Prato)
				values(@UsernameCliente,@Id_Prato)
		END

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO

return 1

ERRO:
	return -1


GO



---- Eliminar : Avaliar Pratos / Avaliar Restaurantes / RestaurantesFavoritos / --
go

create procedure Delete_Avaliar_pratos
	@UsernameCliente varchar , @Id_prato int 

	as
		IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente))
			DELETE FROM AvaliarPratos WHERE Id_prato = @Id_prato

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO

return 1

ERRO:
	return -1

go


create procedure Delete_Avaliar_restaurantes
	@UsernameRestaurante varchar, @UsernameCliente varchar

	as
			IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM RestaurantesAprovados WHERE Username = @UsernameRestaurante)
				BEGIN
					DELETE FROM AvaliarRestaurantes WHERE Username_Restaurante = @UsernameRestaurante AND Username_Cliente = @UsernameCliente
				END

	IF(@@ERROR <> 0)
		BEGIN
			GOTO ERRO
		END 

return 1

ERRO:
	return -1

go



create procedure Delete_RestaurantesFavoritos
	@UsernameRestaurante varchar , @UsernameCliente varchar

	as
		IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM RestaurantesAprovados WHERE Username = @UsernameRestaurante)
			BEGIN
				DELETE FROM RestaurantesFav WHERE UsernameCliente = @UsernameCliente AND UsernameRestaurante = @UsernameRestaurante
			END

		IF(@@ERROR <> 0)
			BEGIN
				GOTO ERRO
			END  

return 1

ERRO:
	return -1


go

create procedure Delete_PratosFavoritos
	@UsernameCliente varchar , @ID_prato int

	as

	IF (EXISTS (SELECT * FROM Cliente WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Prato_Dia WHERE ID = @ID_prato)
		BEGIN
			DELETE FROM Pratos_Dia_Favoritos WHERE UsernameCliente = @UsernameCliente AND Id_Prato = @ID_prato
		END

		IF(@@ERROR <> 0)
			BEGIN
				GOTO ERRO
			END 

return 1

ERRO:
	return -1


return 1

go

