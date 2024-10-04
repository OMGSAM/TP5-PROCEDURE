--QST1

CREATE DATABASE GestionCampagnes;
USE GestionCampagnes;

CREATE TABLE Categorie (
    idCategorie INT PRIMARY KEY AUTO_INCREMENT,
    nomCategorie VARCHAR(255) NOT NULL
);

CREATE TABLE Organisateur (
    idOrg INT PRIMARY KEY AUTO_INCREMENT,
    nomOrg VARCHAR(255) NOT NULL,
    prenomOrg VARCHAR(255) NOT NULL,
    emailOrg VARCHAR(255) UNIQUE NOT NULL,
    passOrg VARCHAR(255) NOT NULL
);

CREATE TABLE Campagne (
    idCamp INT PRIMARY KEY AUTO_INCREMENT,
    nomCamp VARCHAR(255) NOT NULL,
    description TEXT,
    dateCreation DATE NOT NULL,
    dateFin DATE NOT NULL,
    montantCamp DECIMAL(10, 2) NOT NULL,
    nomBeneficiare VARCHAR(255) NOT NULL,
    prenBeneficiare VARCHAR(255) NOT NULL,
    dateDernierePart DATE,
    idCategorie INT,
    idOrg INT,
    FOREIGN KEY (idCategorie) REFERENCES Categorie(idCategorie),
    FOREIGN KEY (idOrg) REFERENCES Organisateur(idOrg)
);

CREATE TABLE Participant (
    idP INT PRIMARY KEY AUTO_INCREMENT,
    nomP VARCHAR(255) NOT NULL,
    prenomP VARCHAR(255) NOT NULL,
    emailP VARCHAR(255) UNIQUE NOT NULL,
    passP VARCHAR(255) NOT NULL
);

CREATE TABLE Participation (
    idPart INT PRIMARY KEY AUTO_INCREMENT,
    datePart DATE NOT NULL,
    montantPart DECIMAL(10, 2) NOT NULL,
    idCamp INT,
    idP INT,
    FOREIGN KEY (idCamp) REFERENCES Campagne(idCamp),
    FOREIGN KEY (idP) REFERENCES Participant(idP)
);

 
INSERT INTO Categorie (nomCategorie) VALUES 
('Santé'), 
('Éducation'), 
('Environnement');

INSERT INTO Organisateur (nomOrg, prenomOrg, emailOrg, passOrg) VALUES 
('LAMIN', 'SIMO', 'sara.dupont@example.com', 'pass123'),
('AMIN', 'SIMNO', 'saad@example.com', 'pass456');

INSERT INTO Campagne (nomCamp, description, dateCreation, dateFin, montantCamp, nomBeneficiare, prenBeneficiare, dateDernierePart, idCategorie, idOrg) VALUES 
('Campagne Santé 2024', 'Campagne pour la santé', '2024-01-01', '2024-12-31', 10000.00, 'Société A', 'Alice', NULL, 1, 1),
('Campagne Éducation 2024', 'Campagne pour l’éducation', '2024-02-01', '2024-11-30', 15000.00, 'Société B', 'Bob', NULL, 2, 2);

INSERT INTO Participant (nomP, prenomP, emailP, passP) VALUES 
('ANAS', 'IDRIS', 'lamai.leblanc@example.com', 'pass789'),
('SOFIA', 'MarcO', 'jfjd.giraud@example.com', 'pass321');

INSERT INTO Participation (datePart, montantPart, idCamp, idP) VALUES 
(CURDATE(), 100.00, 1, 1),
(CURDATE(), 150.00, 1, 2),
(CURDATE(), 200.00, 2, 1);

--QST2
SELECT c.nomCamp, COUNT(p.idP) AS nombreParticipants
FROM Campagne c
LEFT JOIN Participation pa ON c.idCamp = pa.idCamp
LEFT JOIN Participant p ON pa.idP = p.idP
GROUP BY c.nomCamp;

--QST3
DELIMITER //
    CREATE PROCEDURE AfficherParticipationsCampagne(  nomCampagne VARCHAR(255))
    BEGIN
    SELECT p.nomP, p.prenomP, pa.montantPart
    FROM Participation pa
    JOIN Participant p ON pa.idP = p.idP
    JOIN Campagne c ON pa.idCamp = c.idCamp
    WHERE YEAR(pa.datePart) = YEAR(CURDATE()) AND c.nomCamp = nomCampagne;
END //
 

-- QST4
DELIMITER //
    CREATE PROCEDURE AjouterParticipation(  montant DECIMAL(10, 2),   idCampagne INT,   idParticipant INT)
    BEGIN
    INSERT INTO Participation (datePart, montantPart, idCamp, idP)
    VALUES (CURDATE(), montant, idCampagne, idParticipant);
    END //
 

-- QST 5
DELIMITER //
    CREATE FUNCTION MontantTotalParticipationsParCategorie(  idCat INT) RETURNS DECIMAL(10, 2)
    BEGIN
    DECLARE montantTotal DECIMAL(10, 2);
    SELECT SUM(pa.montantPart) INTO montantTotal
    FROM Participation pa
    JOIN Campagne c ON pa.idCamp = c.idCamp
    WHERE c.idCategorie = idCat;
    RETURN IFNULL(montantTotal, 0);
END //
 
