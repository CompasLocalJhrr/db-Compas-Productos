
USE CompasProductos

IF Exists (Select * From dbo.sysobjects Where Id = object_Id(N'[dbo].[spConsultarIdProducto]') and OBJECTPROPERTY(Id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spConsultarIdProducto]
GO
 
/**		Procedimiento Almacenamos para consultar un producto por el ID ***/

CREATE PROCEDURE spConsultarIdProducto
  	@IdProducto			Int		= 0,
    @Success			Bit OUTPUT,
    @Message			VARCHAR(255) OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	
	IF @IdProducto <= 0
    BEGIN
        SET @Success = 0;
        SET @Message = 'El Id del producto tiene un valor no valido.';
        RETURN;
    END 

	IF NOT EXISTS(Select 1 From dbo.Productos Where Id = @IdProducto And NullDate Is Null)
    BEGIN
        SET @Success = 0;
        SET @Message = 'El producto que desea consultar no existe.';
        RETURN;
    END
	 
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
    SET @Message = 'Se encontró de forma correcta.';

END
Go
