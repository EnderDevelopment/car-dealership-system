CREATE TABLE IF NOT EXISTS `car_dealership_tycoon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `car_model` varchar(50) NOT NULL,
  `car_price` int(11) NOT NULL,
  `car_condition` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `car_dealership_tycoon` (`owner`, `car_model`, `car_price`, `car_condition`) VALUES
('system', 'adder', 100000, 100),
('system', 'banshee', 80000, 100),
('system', 'bullet', 120000, 100);