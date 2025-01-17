
USE CompasProductos

IF Exists (Select * From dbo.sysobjects Where Id = object_Id(N'[dbo].[spCrearProducto]') and OBJECTPROPERTY(Id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCrearProducto]
GO
 
/**		Procedimiento Almacenamos para consultar un producto por el ID ***/

CREATE PROCEDURE spCrearProducto  
	@Nombre				VARCHAR(200),
	@Descripcion		VARCHAR(510),
	@Precio				DECIMAL = 0,
	@Stock 				INT = 0,
	@IdBodega			INT	= 0,
    @Success			Bit OUTPUT,
    @Message			VARCHAR(255) OUTPUT
	 

WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdProducto AS INT

	IF @Nombre = '' OR @Nombre Is Null
	BEGIN
        SET @Success = 0;
        SET @Message = 'El nombre el producto es requerido.';
        RETURN;
	END
	IF EXISTS (Select 1 From dbo.Productos Where Nombre = @Nombre And NullDate Is Null)
    BEGIN
        SET @Success = 0;
        SET @Message = 'Ya existe un producto con ese nombre.';
        RETURN;
    END 

	IF  @Precio <= 0 
	BEGIN
        SET @Success = 0;
        SET @Message = 'El precio del producto no es valido.';
        RETURN;
	END

	IF  @Stock <= 0 
	BEGIN
        SET @Success = 0;
        SET @Message = 'El Stock del producto no es valido.';
        RETURN;
	END

	IF  @IdBodega < 0 
	BEGIN
        SET @Success = 0;
        SET @Message = 'La Bodega no es valida.';
        RETURN;
	END

	IF  @IdBodega = 0 
	BEGIN 
		/** Cuando no se envia la bodega se le asigna la màs antigua **/

         Select @IdBodega = MIN(Id)
		 From	dbo.Bodega 
		 Where	NullDate Is Null

		IF @IdBodega IS NULL
		BEGIN
			SET @Success = 0;
			SET @Message = 'Debe tener por lo menos una bodega activa para asignarla al producto.';
			RETURN; 
		END 
	END

	IF NOT EXISTS (Select 1 From dbo.Bodega Where Id = @IdBodega And NullDate Is Null)
	BEGIN
        SET @Success = 0;
        SET @Message = 'La Bodega especificada no existe.';
        RETURN;
	END
	
	INSERT Productos(
						Nombre		
						,Descripcion
						,Precio		
						,Stock 		
						,IdBodega 
				)
	VALUES(
				@Nombre		
				,@Descripcion
				,@Precio		
				,@Stock 		
				,@IdBodega
			)
	  
	SELECT @IdProducto = SCOPE_IDENTITY();
	
	 
	Select	  Id
			, Nombre
			, Descripcion
			, Precio
			, Stock
			, NullDate
	From	Productos
	Where	NullDate Is Null
			And Id = @IdProducto

	SET @Success = 1;
    SET @Message = 'Se guardó el producto de forma correcta.';

END
Go
