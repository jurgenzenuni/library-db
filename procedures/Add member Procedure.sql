DELIMITER //

CREATE PROCEDURE AddMember(
  IN member_name VARCHAR(255),
  IN member_address VARCHAR(255),
  IN member_email VARCHAR(255)
)
BEGIN
  INSERT INTO members (name, address, email)
  VALUES (member_name, member_address, member_email);
END;
//

DELIMITER ;

CALL addmember('Cliff Robertson', '334 Main St, Staten Island NY', 'cliff.rob@gmail.com');