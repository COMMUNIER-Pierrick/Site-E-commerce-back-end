CREATE DATABASE `site_e_commerce` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `site_e_commerce`;

CREATE TABLE `user` (
                         `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                         `firstname` VARCHAR(150) NOT NULL,
                         `lastname` VARCHAR(150) NOT NULL,
                         `password` VARCHAR(250) NOT NULL,
                         `email` VARCHAR(150) NOT NULL UNIQUE,
                         `phone` VARCHAR(250) NULL,
                         `active` BOOLEAN NOT NULL DEFAULT true,
                         `admin` BOOLEAN NOT NULL DEFAULT false,
                         `profile_img` VARCHAR(150) NULL DEFAULT 'no_picture.png',
                         `id_payement` INT NOT NULL,
                         `id_address` INT NOT NULL
)Engine = InnoDB;

CREATE TABLE `product`(
                           `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           `name` INT NOT NULL,
                           `id_category` INT NOT NULL,
                           `id_sub-category` INT NOT NULL,
                           `price` DOUBLE NULL,
                           `product_img` VARCHAR(255) NOT NULL DEFAULT 'no_picture.png',
                           `description_product` TEXT NULL,
                           `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP
)Engine = InnoDB;

CREATE TABLE `category`(
                        `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        `name` VARCHAR(50) NOT NULL
)Engine = InnoDB;

CREATE TABLE `sub-category`(
                        `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        `name` VARCHAR(50) NOT NULL
)Engine = InnoDB;

CREATE TABLE `address`(
                          `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT ,
                          `number` INT NULL,
                          `street` VARCHAR(250) NULL,
                          `additional_address` VARCHAR(250) NULL,
                          `zipcode` VARCHAR(50) NULL,
                          `city` VARCHAR(100) NULL,
                          `country` VARCHAR(100) NULL
)Engine = InnoDB;

CREATE TABLE `payment`(
                          `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                          `name` VARCHAR(255) NULL,
                          `iban` VARCHAR(255) NULL,
                          `number_card` VARCHAR(20) NULL,
                          `expired_date_card` DATETIME NULL
)Engine = InnoDB;

CREATE TABLE `order`(
                         `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                         `id_status` INT NOT NULL,
                         `id_product` INT NOT NULL,
                         `date_order` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
)Engine = InnoDB;

CREATE TABLE `status`(
                         `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                         `name` VARCHAR(255) NOT NULL
)Engine = InnoDB;

ALTER TABLE `user` ADD CONSTRAINT `fk_user_payment` FOREIGN KEY (`id_payement`) REFERENCES `payement`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `user` ADD CONSTRAINT `fk_user_address` FOREIGN KEY (`id_address`) REFERENCES `address`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `product` ADD CONSTRAINT `fk_product_category` FOREIGN KEY (`id_category`) REFERENCES `category`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `product` ADD CONSTRAINT `fk_product_sub-category` FOREIGN KEY (`id_sub-category`) REFERENCES `sub-category`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `order` ADD CONSTRAINT `fk_orders_id_status` FOREIGN KEY (`id_status`)  REFERENCES `status`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `order` ADD CONSTRAINT `fk_orders_id_product` FOREIGN KEY (`id_product`) REFERENCES `product`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;