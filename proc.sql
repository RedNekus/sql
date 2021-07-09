DELIMITER $$
DROP FUNCTION IF EXISTS `setSelectStatament`$$
CREATE FUNCTION `setSelectStatament`( tableName VARCHAR(20) )
BEGIN 
	IF tableName = 'country' THEN
		SELECT `country_ID` FROM `List_country` WHERE 1;
	ELSE
		SELECT `direction_ID` FROM `List_direction` WHERE 1;
	END IF;
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS `getNamesFromList`$$
CREATE PROCEDURE `getNamesFromList`( IN tableName VARCHAR(20) )
BEGIN  
	DECLARE done INT DEFAULT FALSE;
	DECLARE ID INT(11) DEFAULT 0;
	DECLARE outStr TEXT;
	DECLARE Cur CURSOR FOR SELECT * FROM temp;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	SET @tmp := CONCAT('SELECT `', tableName, '_ID` FROM `List_', tableName, '`');
	PREPARE temp FROM @tmp;
	CREATE TEMPORARY TABLE temp AS (EXECUTE temp);
	DEALLOCATE PREPARE tmp;

	SET outStr = '';
	SET @QUERY := CONCAT('(SELECT `', tableName, '_Name` FROM `List_', tableName,'` WHERE `', tableName,'_ID` = %ID) AS \'%ID\'');
	OPEN Cur;
	read_loop: LOOP
		FETCH Cur INTO ID;
		IF done THEN
			LEAVE read_loop;
		END IF;
		IF outStr = '' THEN
			SET outStr = REPLACE(@QUERY, '%ID', ID);
		ELSE
			SET outStr = CONCAT(outStr, ', ', REPLACE(@QUERY, '%ID', ID));
		END IF;
	END LOOP;
	CLOSE Cur;
	IF outStr <> '' THEN
		SET @q := CONCAT('SELECT ', outStr);
		PREPARE stmt FROM @q;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS `getIdFromList`$$
CREATE PROCEDURE `getIdFromList`( IN tableName VARCHAR(50), IN tableFild VARCHAR(10) )
BEGIN  
	DECLARE Item INT;
	DECLARE Filds TEXT;
	DECLARE SQLText VARCHAR(255);
	SET @Num := 0;
	SET @cnt = CONCAT('SELECT COUNT(*) INTO @Num FROM `List_', tableName, '`');
	PREPARE cquery FROM @cnt;
	EXECUTE cquery;
	DEALLOCATE PREPARE cquery;
	IF @Num <> 0 THEN
		SET Item = 0;
		SET Filds = '';
		SET SQLText = CONCAT('(SELECT `', tableName, '_', tableFild, '` FROM `List_', tableName ,'` LIMIT ');
		WHILE Item < @Num DO
			IF Item = 0 THEN
				SET Filds = CONCAT( SQLText, Item, ', 1) AS \'', Item, '\'' );
			ELSE
				SET Filds = CONCAT( Filds, ', ', SQLText, Item, ', 1) AS \'', Item, '\'' );
			END IF;
			SET Item = Item + 1;
		END WHILE;
		SET @q := CONCAT('SELECT ', Filds);
		PREPARE stmt FROM @q;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
END $$