
USE CompasProductos

IF Exists (Select * From dbo.sysobjects Where Id = object_Id(N'[dbo].[spConsultarProductos]') and OBJECTPROPERTY(Id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spConsultarProductos]
GO
 
/**		Procedimiento Almacenamos para consultar los productos que no estén dados de baja ***/
/**		
	Declare 
		@Status				BIT  ,
		@Message			VARCHAR(255)  


	Exec spConsultarProductos @Status output, @Message output 

***/

CREATE PROCEDURE spConsultarProductos
    @Status				BIT OUTPUT,
    @Message			VARCHAR(255) OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	
	Declare @CantProductos AS INT;

	SELECT	@CantProductos = COUNT(1) 
	FROM	Productos P
	WHERE	P.NullDate Is Null
	 
	IF @CantProductos <= 0
    BEGIN
        SET @Status = 0;
        SET @Message = 'No existen productos.';
        RETURN;
    END 
	 
	Select	  Id
			, Nombre
			, Descripcion
			, Precio
			, Stock
			, NullDate
	From	Productos With(Nolock)
	Where	NullDate Is Null

	SET @Status = 1;
    SET @Message = 'Productos Listados correctamente.';

END
Go


