-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema madangUniv
-- -----------------------------------------------------
-- 마당대학교 모델링

-- -----------------------------------------------------
-- Schema madangUniv
--
-- 마당대학교 모델링
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `madangUniv` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `madangUniv` ;

-- -----------------------------------------------------
-- Table `madangUniv`.`Professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`Professor` (
  `ssn` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `age` INT NULL,
  `rank` VARCHAR(20) NOT NULL,
  `speciality` VARCHAR(40) NULL,
  PRIMARY KEY (`ssn`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`Dept`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`Dept` (
  `dno` INT NOT NULL,
  `dname` VARCHAR(45) NOT NULL,
  `office` VARCHAR(45) NULL,
  `runprofessorssn` INT NOT NULL,
  PRIMARY KEY (`dno`),
  INDEX `fk_Dept_Professor_idx` (`runprofessorssn` ASC) VISIBLE,
  CONSTRAINT `fk_Dept_Professor`
    FOREIGN KEY (`runprofessorssn`)
    REFERENCES `madangUniv`.`Professor` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`Graduate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`Graduate` (
  `ssn` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `age` INT NULL,
  `deg_prog` VARCHAR(45) NULL,
  `dno` INT NOT NULL,
  `graduatessn` INT NOT NULL,
  PRIMARY KEY (`ssn`),
  INDEX `fk_Graduate_Dept1_idx` (`dno` ASC) VISIBLE,
  INDEX `fk_Graduate_Graduate1_idx` (`graduatessn` ASC) VISIBLE,
  CONSTRAINT `fk_Graduate_Dept1`
    FOREIGN KEY (`dno`)
    REFERENCES `madangUniv`.`Dept` (`dno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Graduate_Graduate1`
    FOREIGN KEY (`graduatessn`)
    REFERENCES `madangUniv`.`Graduate` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`Project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`Project` (
  `pid` INT NOT NULL,
  `pname` VARCHAR(45) NOT NULL,
  `sponsor` VARCHAR(45) NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `budget` INT NULL,
  `managessn` INT NOT NULL,
  PRIMARY KEY (`pid`),
  INDEX `fk_Project_Professor1_idx` (`managessn` ASC) VISIBLE,
  CONSTRAINT `fk_Project_Professor1`
    FOREIGN KEY (`managessn`)
    REFERENCES `madangUniv`.`Professor` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`work_dept`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`work_dept` (
  `professorssn` INT NOT NULL,
  `dno` INT NOT NULL,
  `pct_time` INT NOT NULL COMMENT '교수 참여 백분율',
  PRIMARY KEY (`professorssn`, `dno`),
  INDEX `fk_work_dept_Dept1_idx` (`dno` ASC) VISIBLE,
  CONSTRAINT `fk_work_dept_Professor1`
    FOREIGN KEY (`professorssn`)
    REFERENCES `madangUniv`.`Professor` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_dept_Dept1`
    FOREIGN KEY (`dno`)
    REFERENCES `madangUniv`.`Dept` (`dno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`work_in`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`work_in` (
  `professorssn` INT NOT NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`professorssn`, `pid`),
  INDEX `fk_work_in_Project1_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_work_in_Professor1`
    FOREIGN KEY (`professorssn`)
    REFERENCES `madangUniv`.`Professor` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_in_Project1`
    FOREIGN KEY (`pid`)
    REFERENCES `madangUniv`.`Project` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `madangUniv`.`work_prog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `madangUniv`.`work_prog` (
  `pid` INT NOT NULL,
  `graduatessn` INT NOT NULL,
  PRIMARY KEY (`pid`, `graduatessn`),
  INDEX `fk_work_prog_Graduate1_idx` (`graduatessn` ASC) VISIBLE,
  CONSTRAINT `fk_work_prog_Project1`
    FOREIGN KEY (`pid`)
    REFERENCES `madangUniv`.`Project` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_prog_Graduate1`
    FOREIGN KEY (`graduatessn`)
    REFERENCES `madangUniv`.`Graduate` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
