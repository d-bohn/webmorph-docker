CREATE DATABASE psychomorph;
USE psychomorph;
\. /var/www/html/webmorph/resources/mysql/db.sql
\. /var/www/html/webmorph/resources/mysql/tems.sql

-- CREATE TABLE `user` (
--   `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
--   `email` varchar(255) NOT NULL,
--   `password` varchar(255) NOT NULL,
--   `organisation` varchar(255) DEFAULT NULL,
--   `sex` enum('female','male','other') DEFAULT NULL,
--   `research` tinyint(1) DEFAULT NULL,
--   `personal` tinyint(1) DEFAULT NULL,
--   `business` tinyint(1) DEFAULT NULL,
--   `art` tinyint(1) DEFAULT NULL,
--   `regdate` datetime DEFAULT NULL,
--   `school` tinyint(1) DEFAULT NULL,
--   `firstname` varchar(255) DEFAULT NULL,
--   `lastname` varchar(255) DEFAULT NULL,
--   `pca` tinyint(1) DEFAULT '0',
--   `allocation` int(8) unsigned DEFAULT '1024',
--   PRIMARY KEY (`id`),
--   UNIQUE KEY `email` (`email`)
-- ) ENGINE=MyISAM AUTO_INCREMENT=91 DEFAULT CHARSET=latin1;

INSERT INTO user(id, email, password, organisation, sex, research, personal, business, art, regdate, school, firstname, lastname, pca, allocation)
VALUES ('12345678', 'default@example.com', 'default123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1024)