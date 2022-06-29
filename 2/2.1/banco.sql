CREATE DATABASE banco;
USE banco;

CREATE TABLE Ciudad(
	cod_postal INT UNSIGNED NOT NULL,
	nombre VARCHAR (45) NOT NULL,

	CONSTRAINT pk_Ciudad
	PRIMARY KEY (cod_postal)
) ENGINE=InnoDB;

CREATE TABLE Sucursal(
	nro_suc INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nombre VARCHAR (45) NOT NULL,
	direccion VARCHAR (45) NOT NULL,
	telefono VARCHAR (45) NOT NULL,
	horario VARCHAR (45) NOT NULL,
	cod_postal INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Sucursal_Ciudad
	FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Sucursal
	PRIMARY KEY (nro_suc)
) ENGINE=InnoDB;

CREATE TABLE Empleado(
	legajo INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nombre VARCHAR (45) NOT NULL,
	apellido VARCHAR (45) NOT NULL,
	password VARCHAR (32) NOT NULL,
	direccion VARCHAR (45) NOT NULL,
	telefono VARCHAR (45) NOT NULL,
	nro_doc INT UNSIGNED NOT NULL,
	tipo_doc VARCHAR (20) NOT NULL,
	cargo VARCHAR (45) NOT NULL,
	nro_suc INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Empleado_Sucursal
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Empleado
	PRIMARY KEY (legajo)
) ENGINE=InnoDB;

CREATE TABLE Cliente(
	nro_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
	apellido VARCHAR(45) NOT NULL,
	nombre VARCHAR(45) NOT NULL,
	tipo_doc VARCHAR(20) NOT NULL,
	nro_doc INT UNSIGNED NOT NULL,
	direccion VARCHAR(45) NOT NULL,
	telefono VARCHAR(45) NOT NULL,
	fecha_nac DATE NOT NULL,

	CONSTRAINT pk_Cliente
	PRIMARY KEY(nro_cliente)
	)ENGINE=InnoDB;

CREATE TABLE Plazo_Fijo(
	nro_plazo INT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NOT NULL,
	capital DECIMAL(16,2) UNSIGNED NOT NULL,
	tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
	interes DECIMAL(16,2) UNSIGNED NOT NULL,
	nro_suc INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Plazo_Fijo_Sucursal
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Plazo_Fijo
	PRIMARY KEY (nro_plazo)
) ENGINE=InnoDB;

CREATE TABLE Tasa_Plazo_Fijo(
	periodo INT UNSIGNED NOT NULL,
	monto_inf DECIMAL(16,2) UNSIGNED NOT NULL,
	monto_sup DECIMAL(16,2) UNSIGNED NOT NULL,
	tasa DECIMAL(4,2) UNSIGNED NOT NULL,

	CONSTRAINT pk_Tasa_Plazo_Fijo
	PRIMARY KEY (periodo, monto_inf, monto_sup)
) ENGINE=InnoDB;


CREATE TABLE Plazo_Cliente(
	nro_plazo INT UNSIGNED NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,

	CONSTRAINT pk_Plazo_Cliente
	PRIMARY KEY (nro_plazo, nro_cliente),

	CONSTRAINT fk_Plazo_Cliente_Plazo_Fijo
	FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo(nro_plazo)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Plazo_Cliente_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = InnoDB;

CREATE TABLE Prestamo(
	nro_prestamo INT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha DATE NOT NULL,
	cant_meses TINYINT UNSIGNED NOT NULL,
	monto DECIMAL(10,2) UNSIGNED NOT NULL,
	tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
	interes DECIMAL(9,2) UNSIGNED NOT NULL,
	valor_cuota DECIMAL(9,2) UNSIGNED NOT NULL,
	legajo INT UNSIGNED NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Prestamo_Empleado
	FOREIGN KEY (legajo) REFERENCES Empleado(legajo)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Prestamo_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Prestamo
	PRIMARY KEY (nro_prestamo)
) ENGINE=InnoDB;

CREATE TABLE Pago(
	nro_prestamo INT UNSIGNED NOT NULL,
	nro_pago TINYINT UNSIGNED NOT NULL,
	fecha_venc DATE NOT NULL,
	fecha_pago DATE,

	CONSTRAINT fk_Pago_Prestamo
	FOREIGN KEY (nro_prestamo) REFERENCES Prestamo(nro_prestamo)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Pago
	PRIMARY KEY (nro_prestamo, nro_pago)
) ENGINE=InnoDB;

CREATE TABLE Tasa_Prestamo(
	periodo INT UNSIGNED NOT NULL,
	monto_inf DECIMAL(10,2) UNSIGNED NOT NULL,
	monto_sup DECIMAL(10,2) UNSIGNED NOT NULL,
	tasa DECIMAL(4,2) UNSIGNED NOT NULL,

	CONSTRAINT pk_Tasa_Prestamo
	PRIMARY KEY (periodo, monto_inf, monto_sup)
) ENGINE=InnoDB;

CREATE TABLE Caja_Ahorro(
	nro_ca INT UNSIGNED NOT NULL AUTO_INCREMENT,
	CBU BIGINT UNSIGNED NOT NULL,
	saldo DECIMAL(16,2) UNSIGNED NOT NULL,

	CONSTRAINT pk_Caja_Ahorro
	PRIMARY KEY(nro_ca)
)ENGINE=InnoDB;

CREATE TABLE Cliente_CA(

	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT pk_Cliente_CA
	PRIMARY KEY (nro_cliente, nro_ca),

	CONSTRAINT fk_Cliente_CA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Cliente_CA_Caja_Ahorro
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE Tarjeta(
	PIN VARCHAR (32) NOT NULL,
	CVT VARCHAR (32) NOT NULL,
	nro_tarjeta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha_venc DATE NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Tarjeta_Cliente_CA
	FOREIGN KEY (nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Tarjeta
	PRIMARY KEY(nro_tarjeta)
	)ENGINE=InnoDB;

CREATE TABLE Caja(
	cod_caja INT UNSIGNED NOT NULL AUTO_INCREMENT,

	CONSTRAINT pk_Caja
	PRIMARY KEY (cod_caja)
) ENGINE=InnoDB;

CREATE TABLE Ventanilla(
	cod_caja INT UNSIGNED NOT NULL,
	nro_suc INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Ventanilla_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Ventanilla_Sucursal
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Ventanilla
	PRIMARY KEY(cod_caja)
	)ENGINE=InnoDB;

CREATE TABLE ATM(
	cod_caja INT UNSIGNED NOT NULL,
	cod_postal INT UNSIGNED NOT NULL,
	direccion VARCHAR (45) NOT NULL,

	CONSTRAINT fk_ATM_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_ATM_Ciudad
	FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_ATM
	PRIMARY KEY(cod_caja)
	)ENGINE=InnoDB;


CREATE TABLE Transaccion(
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	monto DECIMAL(16,2) UNSIGNED NOT NULL,
	nro_trans INT UNSIGNED NOT NULL AUTO_INCREMENT,

	CONSTRAINT pk_Transaccion
	PRIMARY KEY(nro_trans)
	)ENGINE=InnoDB;

CREATE TABLE Debito(
	nro_trans INT UNSIGNED NOT NULL,
	descripcion TINYTEXT,
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Debito_Cliente_CA
	FOREIGN KEY (nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Debito_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Debito
	PRIMARY KEY(nro_trans)
	)ENGINE=InnoDB;

CREATE TABLE Transaccion_por_caja(
	cod_caja INT UNSIGNED NOT NULL,
	nro_trans INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Transaccion_por_caja_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Transaccion_por_caja_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Transaccion_por_caja
	PRIMARY KEY(nro_trans)

	)ENGINE=InnoDB;


CREATE TABLE Deposito(
	nro_trans INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Deposito_Transaccion_por_caja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Deposito_Caja_Ahorro
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Deposito
	PRIMARY KEY(nro_trans)
	)ENGINE=InnoDB;

CREATE TABLE Extraccion(
	nro_trans INT UNSIGNED NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Extraccion_Transaccion_por_caja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Extraccion_Cliente_CA
	FOREIGN KEY (nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Extraccion
	PRIMARY KEY(nro_trans)
	)ENGINE=InnoDB;

CREATE TABLE Transferencia(
	nro_trans INT UNSIGNED NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,
	origen INT UNSIGNED NOT NULL,
	destino INT UNSIGNED NOT NULL,

	CONSTRAINT fk_Transferencia_Transaccion_por_caja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Transferencia_Cliente_CA
	FOREIGN KEY (nro_cliente, origen) REFERENCES Cliente_CA(nro_cliente, nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Transferencia_Caja_Ahorro
	FOREIGN KEY (destino) REFERENCES Caja_Ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT pk_Transferencia
	PRIMARY KEY(nro_trans)


	)ENGINE=InnoDB;

# creacion de la vista

CREATE VIEW trans_cajas_ahorro AS
	select distinct nro_ca, saldo, "depósito" as tipo, DpT.nro_trans, fecha, hora, monto, NULL as destino,
	cod_caja, NULL as nro_cliente, NULL as tipo_doc, NULL as nro_doc, NULL as nombre, NULL as apellido
	from
	(select distinct nro_trans, fecha, hora, monto from Deposito natural join Transaccion) DpT
	natural join
	(select distinct saldo, nro_ca, nro_trans from Deposito natural join Caja_Ahorro) DpCA
	natural join
	(select distinct cod_caja, nro_trans from Deposito natural join Transaccion_por_caja) DpTC

	UNION

	select distinct nro_ca, saldo, "débito" as tipo, DbT.nro_trans, fecha, hora, monto, NULL as destino,
	NULL as cod_caja, nro_cliente, tipo_doc, nro_doc, nombre, apellido
	from
	(select distinct nro_trans,fecha, hora, monto from Debito natural join Transaccion) DbT
	natural join
	(select distinct nro_trans,saldo, nro_ca from Debito natural join Caja_Ahorro) DbCA
	natural join
	(select distinct nro_trans, nro_cliente, tipo_doc, nro_doc, nombre, apellido
	from Debito natural join Cliente) DbC

	UNION

	select distinct nro_ca, saldo, "extracción" as tipo, ET.nro_trans, fecha, hora, monto, NULL as destino,
	cod_caja, nro_cliente,tipo_doc,	nro_doc, nombre, apellido
	from
	(select distinct nro_trans, fecha, hora, monto from Extraccion natural join Transaccion) ET
	natural join
	(select distinct saldo, nro_ca, nro_trans from Extraccion natural join Caja_Ahorro) ECA
	natural join
	(select distinct cod_caja, nro_trans from Extraccion natural join Transaccion_por_caja) ETC
	natural join
	(select distinct nro_trans, nro_cliente, tipo_doc, nro_doc, nombre, apellido
	from Extraccion natural join Cliente) EC

	UNION

	select distinct nro_ca, saldo, "transferencia" as tipo,	TT.nro_trans, fecha, hora, monto, destino,
	cod_caja, nro_cliente,tipo_doc,	nro_doc, nombre, apellido
	from
	 (select distinct nro_trans, destino, fecha, hora, monto from Transferencia natural join Transaccion) TT
	natural join
	 (select distinct saldo, nro_ca, nro_trans from Transferencia join Caja_Ahorro on origen = nro_ca) TCA
	natural join
	 (select distinct cod_caja, nro_trans from Transferencia natural join Transaccion_por_caja) TTC
	natural join
	 (select distinct nro_trans, nro_cliente, tipo_doc, nro_doc, nombre, apellido from Transferencia natural join Cliente) TC
	order by "caja de ahorro",tipo;

# creacion de los usuarios

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

# definición de privilegios

GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost';
GRANT GRANT OPTION ON banco.* TO 'admin'@'localhost';

GRANT SELECT ON banco.Empleado TO 'empleado'@'%';
GRANT SELECT ON banco.Sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Caja_Ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Tarjeta TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Pago TO 'empleado'@'%';

GRANT SELECT ON trans_cajas_ahorro TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.Tarjeta TO 'atm'@'%';

flush PRIVILEGES;
