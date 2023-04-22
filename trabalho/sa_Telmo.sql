USE master
create database lab

USE lab
CREATE TABLE RestaurantesNaoAprovados(
	Username				VARCHAR(20) PRIMARY KEY NOT NULL,
    Nome					VARCHAR(35) NOT NULL,
	morada					VARCHAR(50) NOT NULL,				
	telefone				INT NOT NULL,
	gps						VARCHAR(50) NOT NULL,
	horario					VARCHAR(100) NOT NULL,
	Dia_Descanso			VARCHAR(25) NOT NULL,
	tipo_servico			VARCHAR(50) NOT NULL,
	Foto					Varchar(50) NOT NULL,
	QuemAprovou				Varchar(20),
	CHECK(QuemAprovou = 'NULL')

);

CREATE TABLE PratosFavoritos(
	UsernameCliente			VARCHAR(20)  NOT NULL,
	Id_Prato				INT PRIMARY KEY NOT NULL,
	FOREIGN KEY (UsernameCliente) references Cliente(Username),
	FOREIGN KEY (Id_Prato) references Prato_Dia(ID),
);

CREATE TABLE RestaurantesFavoritos(
	UsernameCliente				VARCHAR(20)  NOT NULL,
	UsernameRestaurante			VARCHAR(20) PRIMARY KEY  NOT NULL,
);


USE lab
CREATE TABLE Avaliar_restaurates(
	Username_Restaurante	VARCHAR(20)  NOT NULL,
	Username_Cliente		VARCHAR(20)  NOT NULL,
	avaliacao		INTEGER,
	comentario		VARCHAR(50),
	PRIMARY KEY(Username_Restaurante,Username_Cliente),
);

USE lab
CREATE TABLE Avaliar_pratos(
	Id_prato	INT  NOT NULL,
	Username_Cliente		VARCHAR(20)  NOT NULL,
	avaliacao INTEGER,
	comentario VARCHAR(50),
	PRIMARY KEY(Username_Cliente,Id_prato),
	
);

-- LINKED SERVER 2
GO
USE master

EXEC sp_addlinkedserver @server = 'tabd',
   @srvproduct = 'SQLServer Native Client OLEDB Provider',
   @provider = 'SQLNCLI',
   @datasrc = '25.78.32.49'

EXEC sp_addlinkedsrvlogin @rmtsrvname = 'tabd',
   @useself = 'FALSE',
   @locallogin = 'sa',
   @rmtuser = 'sa',
   @rmtpassword = '12345'

-- ########## LOGINS #############
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


-- ############# Permissões ################

--Anonimo
GRANT SELECT ON RestaurantesNaoAprovados TO AnonimoU
GRANT SELECT ON Prato_Dia TO AnonimoU
GRANT SELECT ON Possuir TO AnonimoU

--Clientes

GRANT SELECT ON RestauranteNaoAprovados TO ClienteU
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

-- ######## PERMISSOES DAS VIEWS #########

GRANT SELECT ON Administrator TO AdminU
GRANT SELECT ON  Administrator TO AdminU
GRANT SELECT ON  Utilizador_ TO AdminU
GRANT SELECT ON  Cliente_ TO AdminU
GRANT SELECT ON  Bloq TO AdminU
GRANT SELECT ON  AvaliarRestaurantes TO AdminU
GRANT SELECT ON  AvaliarPratos TO AdminU
GRANT SELECT ON  RestaurantesFav TO AdminU
GRANT SELECT ON  PratosFav TO AdminU
GRANT SELECT ON  PratosDia TO AdminU

-- ########### Permissões Procedures #############

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

GRANT SELECT ON RestaurantesNaoAprovados TO RestauranteU
GRANT SELECT ON Prato_Dia TO RestauranteU
GRANT SELECT ON Possuir TO RestauranteU
GRANT INSERT,UPDATE,DELETE ON Possuir TO RestauranteU
GRANT INSERT,UPDATE,DELETE ON Prato_Dia TO RestauranteU

GO

--Admin
GRANT SELECT,INSERT ON Utilizador TO AdminU
GRANT SELECT,INSERT ON Cliente TO AdminU
GRANT SELECT,INSERT ON RestaurantesNaoAprovados TO AdminU
GRANT SELECT,INSERT ON Administrador TO AdminU
GRANT SELECT ON Prato_Dia TO AdminU
GRANT SELECT ON Possuir TO AdminU
GRANT SELECT ON PratosFavoritos TO AdminU
GRANT SELECT ON RestaurantesFavoritos TO AdminU
GRANT SELECT ON Avaliar_restaurates TO AdminU
GRANT SELECT ON Avaliar_pratos  TO AdminU


-- ######## PERMISSOES DAS VIEWS #########

GRANT SELECT ON TodosRestaurantes TO AdminU
GRANT SELECT ON RestaurantesNaoAprovados TO AdminU
GRANT SELECT ON Restaurantes_Aprovados TO AdminU
GRANT SELECT ON Pratos_Dia_Favoritos TO AdminU
GRANT SELECT ON RestaurantesFav TO AdminU
GRANT SELECT ON AvaliarRestaurantes TO AdminU
GRANT SELECT ON AvaliarPratos TO AdminU


-- ####### PERMISSOES PROCEDURES ##########

GRANT EXECUTE ON CriarAdmin TO AdminU
GRANT EXECUTE ON BloqUtilizador TO AdminU
GRANT EXECUTE ON DesbloquearUtilizador TO AdminU


GO

-- ################### Views ##################

USE lab
GO
CREATE VIEW Restaurantes_Aprovados
AS
SELECT * FROM tabd.lab.dbo.RestaurantesAprovados
GO

USE lab
GO
CREATE VIEW Administrator
AS
SELECT * FROM tabd.lab.dbo.Administrador
GO

USE lab
GO
CREATE VIEW Utilizador_
AS
SELECT * FROM tabd.lab.dbo.Utilizador
GO

USE lab
GO
CREATE VIEW Cliente_
AS
SELECT * FROM tabd.lab.dbo.Cliente
GO

USE lab
GO
CREATE VIEW Bloq
AS
SELECT * FROM tabd.lab.dbo.Bloquear
GO

USE lab
GO
CREATE VIEW AvaliarRestaurantes
AS
SELECT * FROM tabd.lab.dbo.Avaliar_restaurates
GO


USE lab
GO
CREATE VIEW AvaliarPratos
AS
SELECT * FROM tabd.lab.dbo.Avaliar_pratos
GO

USE lab
GO
CREATE VIEW RestaurantesFav
AS
SELECT * FROM tabd.lab.dbo.RestaurantesFavoritos
GO


USE lab
GO
CREATE VIEW PratosFav
AS
SELECT * FROM tabd.lab.dbo.PratosFavoritos
GO


USE lab
GO
CREATE VIEW PratosDia
AS
SELECT * FROM tabd.lab.dbo.Prato_Dia
GO



-- ############## PROCEDURES / TRANSACOES #####################

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
			insert into Administrator(Username)
				Values(@username)
			insert into Utilizador_(nome,email,username,pass_word,foto,ContaConfirmada)
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
				insert into Bloq(Username_Administrador,Username_Utilizador,motivo,DataBloqueio)
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
		DELETE FROM Bloq 
		WHERE Username_Administrador = @UsernameAdmin AND Username_Utilizador = @UsernameUtilizador

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO
		COMMIT
RETURN 1

ERRO:
	RETURN -1

GO


-- Avaliar Pratos / Avaliar Restaurantes / RestaurantesFavoritos / --

GO

create procedure AddAvaliar_pratos
	@UsernameCliente varchar,@avaliacao varchar, @comentario varchar

	as
		IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente))
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
		IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Restaurantes_Aprovados WHERE Username = @UsernameRestaurante)
			BEGIN 
				insert into AvaliarRestaurantes(Username_Restaurante,Username_Cliente,avaliacao,comentario)
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
	IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Restaurantes_Aprovados WHERE Username = @UsernameRestaurante)
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
	IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM PratosDia WHERE ID = @Id_Prato)
		BEGIN
			insert into PratosFav(UsernameCliente,Id_Prato)
				values(@UsernameCliente,@Id_Prato)
		END

		IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
			GOTO ERRO

return 1

ERRO:
	return -1


GO



---- Eliminar : Avaliar Pratos / Avaliar Restaurantes / RestaurantesFavoritos / ADDPratoDia Favorito--
go

create procedure Delete_Avaliar_pratos
	@UsernameCliente varchar , @Id_prato int 

	as
		IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente))
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
			IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Restaurantes_Aprovados WHERE Username = @UsernameRestaurante)
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
		IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM Restaurantes_Aprovados WHERE Username = @UsernameRestaurante)
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

	IF (EXISTS (SELECT * FROM Cliente_ WHERE Username = @UsernameCliente)) AND EXISTS (SELECT * FROM PratosDia WHERE ID = @ID_prato)
		BEGIN
			DELETE FROM PratosFav WHERE UsernameCliente = @UsernameCliente AND Id_Prato = @ID_prato
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




