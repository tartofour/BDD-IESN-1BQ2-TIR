/* A FAIRE :
  - Check global des types
  - Creer une dernière sélection
  - Faire vérifier */

/*Creation BD*/
CREATE DATABASE agenceDP;
GO
USE agenceDP;

/*Creation tables*/
CREATE TABLE DETECTIVE
(
  NumAutorisation varchar(8) PRIMARY KEY,
  Nom varchar(15) NOT NULL,
  Prenom varchar(15) NOT NULL,
  DateDeNaissance date NOT NULL,
  DateEmbauche date NOT NULL,
  DateSortie date NULL,
  CONSTRAINT CHECK_DETECTIVE_DATES CHECK (DateEmbauche < DateSortie)
)

CREATE TABLE CLIENT
(
  NumNational varchar(11) PRIMARY KEY,
  Nom varchar(15) NOT NULL,
  Prenom varchar(15) NOT NULL,
  Telephone varchar(20) NOT NULL,
  Email varchar(50) NULL
)


CREATE TABLE ENTREPRISE
(
  NumEntreprise varchar(10) PRIMARY KEY,
  Denomination varchar(50) NOT NULL,
  FormeLegale varchar(10) NOT NULL,
  DateDebut date NOT NULL
)


CREATE TABLE ENQUETE
(
  NumMission smallint IDENTITY(1,1) PRIMARY KEY,
  Description text NOT NULL,
  DateDebut date NOT NULL,
  DateFin date NULL,
  NomMission varchar(100) NULL,
  Superviseur varchar(8) FOREIGN KEY REFERENCES DETECTIVE(NumAutorisation),
  Client varchar(11) FOREIGN KEY REFERENCES CLIENT(NumNational),
  CONSTRAINT CHECK_ENQUETE_DATES CHECK (DateDebut < DateFin)
)

CREATE TABLE VEHICULE
(
  NumChassis varchar(17) PRIMARY KEY,
  Type varchar(20) NOT NULL,
  Marque varchar(20) NOT NULL,
  Modele varchar(20) NOT NULL,
  Couleur varchar(20) NOT NULL,
  Puissance smallint NOT NULL,
  DatePremiereImmat date NOT NULL
)

CREATE TABLE PARTICIPATION
(
  Detective varchar(8) FOREIGN KEY REFERENCES DETECTIVE(NumAutorisation),
  Enquete smallint FOREIGN KEY REFERENCES ENQUETE(NumMission),
  CONSTRAINT PK_PARTICIPATION PRIMARY KEY(Detective, Enquete)
)

CREATE TABLE ASSIGNATION
(
  Enquete smallint FOREIGN KEY REFERENCES ENQUETE(NumMission),
  Vehicule varchar(17) FOREIGN KEY REFERENCES VEHICULE(NumChassis),
  CONSTRAINT PK_ASSIGNATION PRIMARY KEY(Enquete, Vehicule)
)


CREATE TABLE REPRESENTATION
(
  Representant varchar(11) FOREIGN KEY REFERENCES CLIENT(NumNational),
  Entreprise varchar(10) FOREIGN KEY REFERENCES ENTREPRISE(NumEntreprise),
  CONSTRAINT PK_REPRESENTATION PRIMARY KEY(Representant, Entreprise)
)


GO

/*Insertion*/

INSERT INTO  DETECTIVE (NumAutorisation, Nom, Prenom, DateDeNaissance, DateEmbauche)
VALUES  ("14829323", "Drennen", "Romuald", "1987/12/17", "2010/09/11"),
        ("1412O211", "Smith", "John", "1982/07/19", "2018/02/12"),
        ("14828291", "Dupont", "Alexandra", "1992/01/13", "2018/02/10");

INSERT INTO  DETECTIVE
VALUES  ("14820192", "Fritz", "Michael", "1971/04/01", "2011/02/09", "2018/01/17"),
        ("14822134", "Mourreau", "Florence", "1976/01/02", "2010/08/28", "2018/01/17");


INSERT INTO  CLIENT
VALUES  ("61042742354", "Neuckermans", "Robert", "0496874532", "robert_neuckermans@nameless.be"),
        ("88082494385", "Neige", "Jean", "042634930", "winteriscoming@winterfell.no"),
        ("66030392992", "Gilbert", "Françoise", "0496239232", "francoise_gilbert@gmail.com"),
        ("92040717289", "Alain", "Jérémy", "042392323", "jerem_mimi@caramail.fr");


INSERT INTO  ENTREPRISE
VALUES  ("0464583239", "Nameless", "SPRL", "2013/01/18"),
        ("0464738902", "Winterfell", "SA", "1971/01/27"),
        ("0476738920", "Boulangerie Gilbert", "SPRL", "1999/10/12");

INSERT INTO  ENQUETE
VALUES  ("Enquête visant à retrouver les membres survivants de la famille Stark.", "2017/05/01", "2017/09/12", "Loups Géants", "14820192", "88082494385"),
        ("Enquête solvabilté sur l'épouse du client.", "2017/09/02", "2017/09/19", "Madame Alain", "14820192", "92040717289"),
        ("Vol présumé de tickets de loterie par l'employé d'une libraire.", "2019/03/19", "2019/04/02","Under the nail", "14829323", "61042742354"),
        ("Vérification de l'emploi du temps d'un employé en congé maladie.", "2020/01/12", "2020/01/28","Le malade imaginaire", "14829323", "61042742354");

INSERT INTO  ENQUETE (Description, DateDebut, Superviseur, Client)
VALUES  ("Vol présumé d'argent liquide par un employé.", "2020/04/20", "14829323", "61042742354"),
        ("Vérification de l'emploi du temps d'un employé en congé maladie.", "2020/05/01", "14829323", "66030392992");


INSERT INTO  VEHICULE
VALUES  ("DFE22374BH7381026", "Citadine", "Volkswagen", "Golf 6", "Gris", 220, "2014/01/01"),
        ("UHD20383JH3001190", "Sous-marin", "Mercedes", "Sprinter Fourgon", "Gris", 143, "2014/04/01"),
        ("PAF98232POA920122", "Berline", "BMW", "330i Xdrive Berline", "Gris", 258, "2019/06/01");

INSERT INTO  PARTICIPATION
VALUES  ("14820192", 1),
        ("14822134", 1),
        ("14820192", 2),
        ("14822134", 2),
        ("1412O211", 3),
        ("14828291", 3),
        ("1412O211", 4),
        ("14828291", 4),
        ("1412O211", 5),
        ("14828291", 5),
        ("1412O211", 6),
        ("14828291", 6);


INSERT INTO  ASSIGNATION
VALUES  (1, "DFE22374BH7381026"),
        (1, "UHD20383JH3001190"),
        (1, "PAF98232POA920122"),
        (3, "DFE22374BH7381026"),
        (4, "PAF98232POA920122"),
        (5, "DFE22374BH7381026"),
        (6, "DFE22374BH7381026");

INSERT INTO  REPRESENTATION
VALUES  ("61042742354", "0464583239"),
        ("88082494385", "0464738902"),
        ("66030392992", "0476738920");


GO

/*  Selections  */

/*  Affiche la marque, le modèle et la puissance des voitures possédant + de 150cv
    Les occurances sont triées en fonction de la date de première immatriculaton
    par ordre ascendant */
SELECT Marque, Modele, Puissance, DatePremiereImmat
FROM VEHICULE
WHERE Puissance > 150
ORDER BY DatePremiereImmat;

/* Affiche le nom et prénom du superviseur pour chacune des missions */
SELECT NumMission, NomMission, CONCAT(D.Nom," ",D.Prenom) as IdentiteSuperviseur
FROM ENQUETE
INNER JOIN DETECTIVE D
ON Superviseur = D.NumAutorisation;

/*  Affiche le nom, le prénom et le numéro d'autorisation des détectives ayants participés à
    la mission portant le nom "Loups Géants". */
SELECT D.Nom as NomParticipant, D.Prenom as PrenomParticipant, D.NumAutorisation
FROM DETECTIVE D, PARTICIPATION P, ENQUETE E
WHERE P.Detective = D.NumAutorisation
  AND P.Enquete = E.NumMission
  AND E.NomMission = "Loups Géants";

/*  Affiche le nom et prénom des clients représentant une entreprise.
    Affiche également la dénomination sociale de l'entreprise représentée. */
SELECT Cli.nom as NomRepresentant, Cli.prenom as PrenomRepresentant, Ent.Denomination as EntrepriseRepresentee
FROM CLIENT Cli, REPRESENTATION Rep, ENTREPRISE Ent
WHERE Rep.Representant = Cli.NumNational
  AND Rep.Entreprise = Ent.NumEntreprise
ORDER BY Ent.Denomination;

/* Calcule le nombre d'enquête ou les détectives ont été engagés, superviseur compris.
SELECT Nom, Prenom, NumAutorisation
FROM DETECTIVE*/
