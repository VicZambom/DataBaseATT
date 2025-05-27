-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema petshop
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema petshop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `petshop` DEFAULT CHARACTER SET utf8 ;
USE `petshop` ;

-- -----------------------------------------------------
-- Table `petshop`.`Departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `localDep` VARCHAR(45) NULL,
  `Gerente_cpf` VARCHAR(14) NULL,
  PRIMARY KEY (`idDepartamento`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) ,
  INDEX `fk_Departamento_Empregado1_idx` (`Gerente_cpf` ASC))
-- ,
--  CONSTRAINT `fk_Departamento_Empregado1`
--    FOREIGN KEY (`Gerente_cpf`)
--    REFERENCES `petshop`.`Empregado` (`cpf`)
--    ON DELETE NO ACTION
--    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Empregado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Empregado` (
  `cpf` VARCHAR(14) NOT NULL,
  `nome` VARCHAR(60) NOT NULL,
  `sexo` CHAR(1) NOT NULL,
  `email` VARCHAR(60) NULL,
  `ctps` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `dataAdm` DATETIME NOT NULL,
  `dataDem` DATETIME NULL,
  `salario` DECIMAL(7,2) ZEROFILL NOT NULL,
  `comissao` DECIMAL(6,2) ZEROFILL NULL,
  `bonificacao` DECIMAL(6,2) ZEROFILL NULL,
  `Departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`cpf`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC)  ,
  INDEX `fk_Empregado_Departamento_idx` (`Departamento_idDepartamento` ASC)  ,
  CONSTRAINT `fk_Empregado_Departamento`
    FOREIGN KEY (`Departamento_idDepartamento`)
    REFERENCES `petshop`.`Departamento` (`idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Custos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Custos` (
  `idCusto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `valor` DECIMAL(7,2) ZEROFILL NOT NULL,
  `dataPag` DATETIME NULL,
  `dataVenc` DATETIME NOT NULL,
  `obs` VARCHAR(150) NULL,
  `Departamento_idDepartamento` INT NULL,
  PRIMARY KEY (`idCusto`),
  INDEX `fk_Custos_Departamento1_idx` (`Departamento_idDepartamento` ASC)  ,
  CONSTRAINT `fk_Custos_Departamento1`
    FOREIGN KEY (`Departamento_idDepartamento`)
    REFERENCES `petshop`.`Departamento` (`idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Cliente` (
  `cpf` VARCHAR(14) NOT NULL,
  `nome` VARCHAR(60) NOT NULL,
  `numTelefone` VARCHAR(11) NOT NULL,
  `numTelefone2` VARCHAR(11) NULL,
  `email` VARCHAR(60) NULL,
  `corresponsavel` VARCHAR(60) NULL,
  PRIMARY KEY (`cpf`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Venda` (
  `idVenda` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `valor` DECIMAL(7,2) ZEROFILL NOT NULL,
  `comissao` DECIMAL(6,2) ZEROFILL NULL,
  `desconto` DECIMAL(4,2) ZEROFILL NULL,
  `Cliente_cpf` VARCHAR(14) NULL,
  `Empregado_cpf` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idVenda`),
  INDEX `fk_Venda_Cliente1_idx` (`Cliente_cpf` ASC)  ,
  INDEX `fk_Venda_Empregado1_idx` (`Empregado_cpf` ASC)  ,
  CONSTRAINT `fk_Venda_Cliente1`
    FOREIGN KEY (`Cliente_cpf`)
    REFERENCES `petshop`.`Cliente` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_Empregado1`
    FOREIGN KEY (`Empregado_cpf`)
    REFERENCES `petshop`.`Empregado` (`cpf`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Servico` (
  `idServico` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(60) NOT NULL,
  `valorVenda` DECIMAL(6,2) ZEROFILL NOT NULL,
  `valorCusto` DECIMAL(6,2) ZEROFILL NULL,
  PRIMARY KEY (`idServico`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`PET`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`PET` (
  `idPET` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `idade` INT NULL,
  `especie` VARCHAR(45) NOT NULL,
  `raca` VARCHAR(45) NOT NULL,
  `cor` VARCHAR(45) NOT NULL,
  `porte` VARCHAR(45) NULL,
  `peso` DECIMAL(5,2) NULL,
  `alergia` VARCHAR(80) NULL,
  `obs` VARCHAR(150) NULL,
  `Cliente_cpf` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idPET`),
  INDEX `fk_PET_Cliente1_idx` (`Cliente_cpf` ASC)  ,
  CONSTRAINT `fk_PET_Cliente1`
    FOREIGN KEY (`Cliente_cpf`)
    REFERENCES `petshop`.`Cliente` (`cpf`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`itensServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`itensServico` (
  `Empregado_cpf` VARCHAR(14) NOT NULL,
  `Servico_idServico` INT NOT NULL,
  `Venda_idVenda` INT NOT NULL,
  `PET_idPET` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `valor` DECIMAL(6,2) ZEROFILL NOT NULL,
  `desconto` DECIMAL(4,2) ZEROFILL NULL,
  PRIMARY KEY (`Empregado_cpf`, `Servico_idServico`, `Venda_idVenda`, `PET_idPET`),
  INDEX `fk_itensServico_Servico1_idx` (`Servico_idServico` ASC)  ,
  INDEX `fk_itensServico_Venda1_idx` (`Venda_idVenda` ASC)  ,
  INDEX `fk_itensServico_PET1_idx` (`PET_idPET` ASC)  ,
  CONSTRAINT `fk_itensServico_Empregado1`
    FOREIGN KEY (`Empregado_cpf`)
    REFERENCES `petshop`.`Empregado` (`cpf`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_itensServico_Servico1`
    FOREIGN KEY (`Servico_idServico`)
    REFERENCES `petshop`.`Servico` (`idServico`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itensServico_Venda1`
    FOREIGN KEY (`Venda_idVenda`)
    REFERENCES `petshop`.`Venda` (`idVenda`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itensServico_PET1`
    FOREIGN KEY (`PET_idPET`)
    REFERENCES `petshop`.`PET` (`idPET`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`FormaPgVenda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`FormaPgVenda` (
  `idFormaPgVenda` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(45) NOT NULL,
  `valorPago` DECIMAL(7,2) ZEROFILL NOT NULL,
  `Venda_idVenda` INT NOT NULL,
  PRIMARY KEY (`idFormaPgVenda`),
  INDEX `fk_formaPgVenda_Venda1_idx` (`Venda_idVenda` ASC)  ,
  CONSTRAINT `fk_formaPgVenda_Venda1`
    FOREIGN KEY (`Venda_idVenda`)
    REFERENCES `petshop`.`Venda` (`idVenda`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Endereco` (
  `Cliente_cpf` VARCHAR(14) NOT NULL,
  `uf` CHAR(2) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `rua` VARCHAR(45) NOT NULL,
  `numero` INT NULL,
  `comp` VARCHAR(45) NULL,
  `cep` CHAR(9) NOT NULL,
  PRIMARY KEY (`Cliente_cpf`),
  CONSTRAINT `fk_Endereco_Cliente1`
    FOREIGN KEY (`Cliente_cpf`)
    REFERENCES `petshop`.`Cliente` (`cpf`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Produtos` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `quantidade` DECIMAL(6,2) NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  `dataVenc` DATE NULL,
  `valorVenda` DECIMAL(6,2) ZEROFILL NOT NULL,
  `precoCusto` DECIMAL(6,2) ZEROFILL NOT NULL,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`ItensVendaProd`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`ItensVendaProd` (
  `Venda_idVenda` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `quantidade` DECIMAL(6,2) NOT NULL,
  `valor` DECIMAL(6,2) ZEROFILL NOT NULL,
  `desconto` DECIMAL(4,2) NULL,
  INDEX `fk_Venda_has_Produto_Produto1_idx` (`Produto_idProduto` ASC)  ,
  INDEX `fk_Venda_has_Produto_Venda1_idx` (`Venda_idVenda` ASC)  ,
  PRIMARY KEY (`Venda_idVenda`, `Produto_idProduto`),
  CONSTRAINT `fk_Venda_has_Produto_Venda1`
    FOREIGN KEY (`Venda_idVenda`)
    REFERENCES `petshop`.`Venda` (`idVenda`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `petshop`.`Produtos` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Fornecedor` (
  `cpf_cnpj` VARCHAR(15) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `valorFrete` DECIMAL(6,2) ZEROFILL NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cpf_cnpj`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Compras` (
  `idCompra` INT NOT NULL AUTO_INCREMENT,
  `dataComp` DATETIME NOT NULL,
  `valorTotal` DECIMAL(7,2) ZEROFILL NOT NULL,
  `dataVenc` DATE NOT NULL,
  `dataPag` DATETIME NULL,
  `desconto` DECIMAL(4,2) NULL,
  `juros` DECIMAL(5,2) ZEROFILL NULL,
  `Fornecedor_cpf_cnpj` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idCompra`),
  INDEX `fk_Compras_Fornecedor1_idx` (`Fornecedor_cpf_cnpj` ASC)  ,
  CONSTRAINT `fk_Compras_Fornecedor1`
    FOREIGN KEY (`Fornecedor_cpf_cnpj`)
    REFERENCES `petshop`.`Fornecedor` (`cpf_cnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`ItensCompra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`ItensCompra` (
  `Compras_idCompra` INT NOT NULL,
  `Produtos_idProduto` INT NOT NULL,
  `quantidade` DECIMAL(6,2) NOT NULL,
  `valorCompra` DECIMAL(7,2) ZEROFILL NOT NULL,
  PRIMARY KEY (`Compras_idCompra`, `Produtos_idProduto`),
  INDEX `fk_Compras_has_Produtos_Produtos1_idx` (`Produtos_idProduto` ASC)  ,
  INDEX `fk_Compras_has_Produtos_Compras1_idx` (`Compras_idCompra` ASC)  ,
  CONSTRAINT `fk_Compras_has_Produtos_Compras1`
    FOREIGN KEY (`Compras_idCompra`)
    REFERENCES `petshop`.`Compras` (`idCompra`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Compras_has_Produtos_Produtos1`
    FOREIGN KEY (`Produtos_idProduto`)
    REFERENCES `petshop`.`Produtos` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`FormaPagCompra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`FormaPagCompra` (
  `idFormaPagCompra` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(45) NOT NULL,
  `valorPago` DECIMAL(7,2) ZEROFILL NOT NULL,
  `Compras_idCompra` INT NOT NULL,
  PRIMARY KEY (`idFormaPagCompra`),
  INDEX `fk_FormaPagCompra_Compras1_idx` (`Compras_idCompra` ASC)  ,
  CONSTRAINT `fk_FormaPagCompra_Compras1`
    FOREIGN KEY (`Compras_idCompra`)
    REFERENCES `petshop`.`Compras` (`idCompra`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petshop`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petshop`.`Telefone` (
  `idTelefone` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(11) NOT NULL,
  `Empregado_cpf` VARCHAR(14) NULL,
  `Departamento_idDepartamento` INT NULL,
  `Fornecedor_cpf_cnpj` VARCHAR(15) NULL,
  PRIMARY KEY (`idTelefone`),
  INDEX `fk_Telefone_Empregado1_idx` (`Empregado_cpf` ASC)  ,
  INDEX `fk_Telefone_Departamento1_idx` (`Departamento_idDepartamento` ASC)  ,
  INDEX `fk_Telefone_Fornecedor1_idx` (`Fornecedor_cpf_cnpj` ASC)  ,
  CONSTRAINT `fk_Telefone_Empregado1`
    FOREIGN KEY (`Empregado_cpf`)
    REFERENCES `petshop`.`Empregado` (`cpf`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Telefone_Departamento1`
    FOREIGN KEY (`Departamento_idDepartamento`)
    REFERENCES `petshop`.`Departamento` (`idDepartamento`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Telefone_Fornecedor1`
    FOREIGN KEY (`Fornecedor_cpf_cnpj`)
    REFERENCES `petshop`.`Fornecedor` (`cpf_cnpj`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Aprendendo ALTER TABLE
-- -----------------------------------------------------

alter table pet 
	add column foto blob null;

-- desc pet;

alter table pet
	drop column foto;

alter table pet 
	add column foto blob null after obs;

alter table pet	
	change column cor corPet varchar(15) not null;
    
-- select * from pet;