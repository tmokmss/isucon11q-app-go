ALTER TABLE `isu_condition` ADD COLUMN `conditionLevel` VARCHAR(10) NOT NULL DEFAULT "warning";
UPDATE `isu_condition` SET `conditionLevel`="info" WHERE `condition`="is_dirty=false,is_overweight=false,is_broken=false";
UPDATE `isu_condition` SET `conditionLevel`="critical" WHERE `condition`="is_dirty=true,is_overweight=true,is_broken=true";
