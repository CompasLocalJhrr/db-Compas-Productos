
USE CompasProductos

IF Exists (Select * From dbo.sysobjects Where Id = object_Id(N'[dbo].[spEliminarProducto]') and OBJECTPROPERTY(Id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spEliminarProducto]
GO
 
/**		Procedimiento Almacenamos para dar de baja a los productos con un borrado logico ***/

CREATE PROCEDURE spEliminarProducto
  	@IdProducto			Int		= 0,
    @Success			Bit OUTPUT,
    @Message			VARCHAR(255) OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	

	Declare @Date As Date 
	Set @Date = GetDate()

	IF @IdProducto <= 0
    BEGIN
        SET @Success = 0;
        SET @Message = 'El Id del producto tiene un valor no valido.';
        RETURN;
    END 

	IF NOT EXISTS(Select 1 From dbo.Productos Where Id = @IdProducto And NullDate Is Null)
    BEGIN
        SET @Success = 0;
        SET @Message = 'El producto a eliminar no existe.';
        RETURN;
    END
	 

	IF EXISTS(	Select 1 
				From dbo.Productos P
				Inner Join FacturaProducto RFP On RFP.IdProducto = P.Id
				Inner Join Factura F On F.Id = RFP.IdFactura
				Where P.Id = @IdProducto 
					  And P.NullDate Is Null
					  And F.Anulada = 0
			  )
    BEGIN
        SET @Success = 0;
        SET @Message = 'Este producto no se puede eliminar porque se encuentra asociado a una o mas factura.';
        RETURN;
    END
	 
	Update  P 
			SET P.NullDate =  @Date
	From Productos P
	Where Id = @IdProducto


	SET @Success = 1;
    SET @Message = 'Producto ha sido eliminado de forma correcta.';

END
Go


