--Persons(PersonID, FirstName, LastName, DateOfBirth, MedicareNumber, MedicareExpiry, TelephoneNumber, Address, City, Province, PostalCode, Citizenship, Email)--
--Employees--
INSERT INTO Persons VALUES(1, 'Joyce', 'Anderson', 1961-05-04, 'ANDJ61050472', 2025-05-04, '514-248-1537', '4999 boul. Edouard-Montpetit', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'janderson@gmail.com');
INSERT INTO Persons VALUES(2, 'Jacob', 'West', 1982-05-31, 'WESJ82053142', 2026-05-31, '514-176-5643', '2081 rue Legare', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'jwest@gmail.com');
INSERT INTO Persons VALUES(3, 'Michael', 'Cunningham', 1982-12-08, 'CUNM82120812', 2027-12-08, '514-579-1379', '231 rue Stanley', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'mcunningham@gmail.com');
INSERT INTO Persons VALUES(4, 'Cherry', 'Morris', 1984-06-23, 'MORC84062379', 2025-06-23, '514-457-4468', '9512 ch. de la Coe-des-Neiges', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'cmorris@gmail.com');
INSERT INTO Persons VALUES(5, 'Grace', 'Rogers', 1991-10-09, 'ROGG91100955', 2026-10-09, '514-005-4861', '20 Park Street', 'Kingston', 'ON', 'K1K9G6', 'USA', 'grogers@gmail.com');
INSERT INTO Persons VALUES(6, 'Edwin', 'Davis', 1993-01-06, 'EDWD93010654', 2027-01-06, '514-337-9147', '416 Maple Road', 'Cornwall', 'ON', 'K0B8G3', 'USA', 'edavis@gmail.com');
INSERT INTO Persons VALUES(7, 'Connie', 'Armstrong', 1997-09-08, 'ARMC97090834', 2025-09-08, '514-115-8111', '1867 rue Saint-Martin', 'Laval', 'QC', 'H7W1B8', 'Canada', 'carmstrong@gmail.com');
INSERT INTO Persons VALUES(8, 'Justin', 'Miller', 2004-02-25, 'MILJ04022595', 2026-02-05, '514-974-5451', '8177 rue Saint-Auguste', 'Brossard', 'QC', 'J4N0G3', 'Canada', 'jmiller@gmail.com');
INSERT INTO Persons VALUES(9, 'Edwin', 'Hall', 1996-02-15, 'HALE16021539', 2027-02-15, '514-911-9115', '11 Leaf Crescent', 'Cornwall', 'ON', 'K0B1D4', 'USA', 'ehall@gmail.com');
INSERT INTO Persons VALUES(10, 'Roger', 'Smith', 1992-07-30, 'SMIR22073081', 2026-07-30, '514-334-5148', '6833 boul. Saint-Laurent', 'Montreal', 'QC', 'H1X8Q3', 'Canada', 'rsmith@gmail.com');

--Students
INSERT INTO Persons VALUES(11, 'Marlie', 'Werner', 2004-12-19, 'WERM04121957', 2025-12-19, '514-134-6798', '4999 boul. des Causses', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'mwerner@gmail.com');
INSERT INTO Persons VALUES(12, 'Quinn', 'Esparza', 2010-06-29, 'ESPQ10062941', 2026-06-29, '514-224-3486', '2081 rue de Meaux', 'Montreal', 'QC', 'H3W4B9', 'Mexico', 'qesparza@gmail.com');
INSERT INTO Persons VALUES(13, 'Tessa', 'Richard', 2012-09-12, 'RICT12091243', 2027-09-12, '514-514-5147', '231 rue de Melun', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'trichard@gmail.com');
INSERT INTO Persons VALUES(14, 'Cassie', 'Lloyd', 2012-11-28, 'LLOC12112801', 2025-11-28, '514-997-5214', '9512 ch. Brillat-Savarin', 'Montreal', 'QC', 'H3W4B9', 'Canada', 'clloyd@gmail.com');
INSERT INTO Persons VALUES(15, 'Julien', 'Singleton', 2013-10-15, 'SINJ13101597', 2026-10-15, '514-105-6789', '20 Brie Street', 'Ottawa', 'ON', 'K1K9G6', 'Canada', 'jsingleton@gmail.com');
INSERT INTO Persons VALUES(16, 'Dale', 'Bond', 2015-03-09, 'BOND16030907', 2027-03-09, '514-115-2357', '416 Gruyere Road', 'Alexandria', 'ON', 'K0B8G3', 'Canada', 'dbond@gmail.com');
INSERT INTO Persons VALUES(17, 'Armando', 'Morales', 2016-05-26, 'MORA16052677', 2025-05-26, '514-889-5462', '1867 rue Emmental', 'Laval', 'QC', 'H7W1B8', 'Mexico', 'amorales@gmail.com');
INSERT INTO Persons VALUES(18, 'Cara', 'Manning', 2016-06-03, 'MANC16060333', 2026-06-03, '514-554-5357', '8177 rue Faisselle', 'Brossard', 'QC', 'J4N0G3', 'Canada', 'cmanning@gmail.com');
INSERT INTO Persons VALUES(19, 'Keenan', 'Mueller', 2016-09-06, 'MUEK16090657', 2027-09-06, '514-515-5151', '11 Morbier Crescent', 'Belleville', 'ON', 'K0B1D4', 'Germany', 'kmueller@gmail.com');
INSERT INTO Persons VALUES(20, 'Roger', 'Smith', 2010-10-23, 'SMIR10102387', 2026-10-23, '514-121-1212', '6833 boul. Picodon', 'Montreal', 'QC', 'H1X8Q3', 'Canada', 'rsmith@gmail.com');

--End of Persons--

--Infections(InfectionID, DateOfInfection, TypeID [(1, COVID-19), (2, SARS-CoV-2 Variant), (3, Other)], PersonID)--
INSERT INTO Infections VALUES(1, 2023-05-06, 1, 1);
INSERT INTO Infections VALUES(2, 2023-05-06, 1, 3);
INSERT INTO Infections VALUES(3, 2023-05-07, 2, 5);
INSERT INTO Infections VALUES(4, 2023-05-08, 2, 7);
INSERT INTO Infections VALUES(5, 2023-05-08, 3, 9);
INSERT INTO Infections VALUES(6, 2023-05-08, 1, 11);
INSERT INTO Infections VALUES(7, 2023-05-08, 2, 13);
INSERT INTO Infections VALUES(8, 2023-05-08, 2, 15);
INSERT INTO Infections VALUES(9, 2023-05-09, 1, 17);
INSERT INTO Infections VALUES(10, 2023-05-09, 3, 19);

--Vaccinations(VaccinationID, VaccinationDate, DoseNumber, VaccineID [(1, Pfizer), (2, Moderna), (3, AztraZeneca), (4, Johnson & Johnson)], PersonID)--
INSERT INTO Vaccinations VALUES(1, 2019-04-04, 1, 1, 2);
INSERT INTO Vaccinations VALUES(2, 2019-04-04, 1, 1, 4);
INSERT INTO Vaccinations VALUES(3, 2019-04-05, 1, 2, 6);
INSERT INTO Vaccinations VALUES(4, 2019-04-05, 1, 3, 8);
INSERT INTO Vaccinations VALUES(5, 2019-04-06, 1, 4, 10);
INSERT INTO Vaccinations VALUES(6, 2019-06-04, 2, 1, 2);
INSERT INTO Vaccinations VALUES(7, 2019-06-04, 2, 1, 4);
INSERT INTO Vaccinations VALUES(8, 2019-04-05, 1, 4, 12);
INSERT INTO Vaccinations VALUES(9, 2019-04-05, 1, 3, 16);
INSERT INTO Vaccinations VALUES(10, 2019-04-06, 2, 4, 12);

--Ministries(MinistryID, Name, Address, City, Province, PostalCode, PhoneNumber, WebAddress, Capacity, TypeID[unknown types])--
INSERT INTO Ministries VALUES(1, 'Laval Ministry of Education', '1201 ch. du Omelette', 'Laval', 'QC', 'H1P7U9', '514-999-8855', 'https://laval.education.qc.ca', 15000, type);
INSERT INTO Ministries VALUES(2, 'Montreal Ministry of Education', '4812 rue Fromage', 'Montreal', 'QC', 'H3X7H1', '514-111-2244', 'https://montreal.education.qc.ca', 40000, type);
INSERT INTO Ministries VALUES(3, 'West Island Ministry of Education', '157 boul. Camembert', 'Pierrefonds', 'QC', 'H7Q1E4', '514-149-4317', 'https://westisland.education.qc.ca', 25000, type);

--Facilities(FacilityID, Name, Address, City, Province, PostalCode, PhoneNumber, WebAddress, Capacity, MinistryID)--
INSERT INTO Facilities VALUES(1, 'Rosemont Elementary School', '123 Av. Rosemont', 'Montreal', 'QC', 'H7H8K0', '514-134-4513', 'https://ecolerosemont.edu', 2500, 2);
INSERT INTO Facilities VALUES(2, 'Vanier Education Centre', '456 ch. Vanier', 'Montreal', 'QC', 'H8H1Z3', '514-554-5145', 'https://ecolevanier.edu', 5000, 2);
INSERT INTO Facilities VALUES(3, 'Westmount Elementary School', '789 rue Westmount', 'Montreal', 'QC', 'H1Q8C1', '514-843-1579', 'https://ecolewestmount.edu', 2000, 2);
INSERT INTO Facilities VALUES(4, 'Pierrefonds Middle School', '100 boul. Pierrefonds', 'Montreal', 'QC', 'H7P8E3', '514-674-6647', 'https://ecolepierrefonds.edu', 750, 3);
INSERT INTO Facilities VALUES(5, 'Outremont High School', '200 Av. Outremont', 'Montreal', 'QC', 'H5L8A2', '514-551-1123', 'https://ecoleoutremont.edu', 3500, 2);
INSERT INTO Facilities VALUES(6, 'Laval School Board', '300 Av. Parmesan', 'Laval', 'QC', 'H1D6K9', '514-475-6324', 'https://laval.education.qc.ca/board', 100, 1);
INSERT INTO Facilities VALUES(7, 'Montreal School Board', '400 rue Beaufort', 'Montreal', 'QC', 'H5R7Y9', '514-227-9157', 'https://montreal.education.qc.ca/board', 150, 2);
INSERT INTO Facilities VALUES(8, 'West Island English School Board ', '500 Swiss Crescent', 'Pierrefonds', 'QC', 'H3B8M0', '514-377-9455', 'https://montreal.education.qc.ca/board', 100, 3);

--PossibleFacilitiesTypes(FacilityID, TypeID[(1, Management, Head Office), (2, Management, General Management), (3, Education, Primary), (4, Education, Middle), (5, Education, High)])--
INSERT INTO PossibleFacilitiesTypes VALUES(1, 3);
INSERT INTO PossibleFacilitiesTypes VALUES(2, 2);
INSERT INTO PossibleFacilitiesTypes VALUES(3, 3);
INSERT INTO PossibleFacilitiesTypes VALUES(4, 4);
INSERT INTO PossibleFacilitiesTypes VALUES(5, 5);
INSERT INTO PossibleFacilitiesTypes VALUES(6, 1);
INSERT INTO PossibleFacilitiesTypes VALUES(7, 1);
INSERT INTO PossibleFacilitiesTypes VALUES(8, 1);

--RegistrationHistory(StudentID, FacilityID, StartDate, EndDate)--
INSERT INTO RegistrationHistory VALUES(11, 5, 2023-09-01);
INSERT INTO RegistrationHistory VALUES(12, 4, 2020-09-01);
INSERT INTO RegistrationHistory VALUES(13, 3, 2022-09-01);
INSERT INTO RegistrationHistory VALUES(14, 1, 2020-09-01);
INSERT INTO RegistrationHistory VALUES(15, 2, 2019-09-01);
INSERT INTO RegistrationHistory VALUES(16, 5, 2023-09-01);
INSERT INTO RegistrationHistory VALUES(17, 4, 2020-09-01);
INSERT INTO RegistrationHistory VALUES(18, 3, 2022-09-01);
INSERT INTO RegistrationHistory VALUES(19, 1, 2019-09-01);
INSERT INTO RegistrationHistory VALUES(20, 2, 2020-09-01);

--StudentLevels(StudentID, CurrentLevel)--
INSERT INTO StudentLevels VALUES(11, 'Grade 12');
INSERT INTO StudentLevels VALUES(12, 'Grade 8');
INSERT INTO StudentLevels VALUES(13, 'Grade 6');
INSERT INTO StudentLevels VALUES(14, 'Grade 6');
INSERT INTO StudentLevels VALUES(15, 'Grade 5');
INSERT INTO StudentLevels VALUES(16, 'Grade 3');
INSERT INTO StudentLevels VALUES(17, 'Grade 2');
INSERT INTO StudentLevels VALUES(18, 'Grade 2');
INSERT INTO StudentLevels VALUES(19, 'Grade 2');
INSERT INTO StudentLevels VALUES(20, 'Grade 8');

--Roles(RoleID, StartDate, EndDate, CurrentStatus, PersonID, FacilityID)--
INSERT INTO Roles (1, 2020-08-01, 'President', 1, 6);
INSERT INTO Roles (2, 2020-11-25, 'President', 2, 7);
INSERT INTO Roles (3, 2021-12-28, 'President', 3, 8);
INSERT INTO Roles (4, 2022-02-17, 'Secretary', 4, 6);
INSERT INTO Roles (5, 2022-04-20, 'Teacher', 5, 1);
INSERT INTO Roles (6, 2022-07-27, 'Teacher', 6, 2);
INSERT INTO Roles (7, 2022-11-05, 'Teacher', 7, 3);
INSERT INTO Roles (8, 2023-07-31, 'Teacher', 8, 4);
INSERT INTO Roles (9, 2022-09-18, 'Teacher', 9, 5);
INSERT INTO Roles (10, 2022-11-30, 'IT Administrator', 10, 7);

--WorkHistory(PersonID, FacilityID, StartDate, EndDate)--
INSERT INTO WorkHistory (1, 8, 2015-06-01. 2019-12-30);
INSERT INTO WorkHistory (1, 6, 2020-08-01);
INSERT INTO WorkHistory (2, 7, 2020-11-25);
INSERT INTO WorkHistory (3, 7, 2016-07-15, 2021-06-25);
INSERT INTO WorkHistory (3, 8, 2021-12-28);
INSERT INTO WorkHistory (4, 6, 2022-02-17);
INSERT INTO WorkHistory (5, 4, 2012-07-15, 2015-07-16);
INSERT INTO WorkHistory (5, 3, 2015-09-01, 2022-01-03);
INSERT INTO WorkHistory (5, 1, 2022-04-20);
INSERT INTO WorkHistory (6, 2, 2022-07-27);
INSERT INTO WorkHistory (7, 1, 2019-06-15, 2022-09-01);
INSERT INTO WorkHistory (7, 3, 2022-11-05);
INSERT INTO WorkHistory (8, 4, 2023-07-31);
INSERT INTO WorkHistory (9, 2, 2020-06-30, 2022-07-30);
INSERT INTO WorkHistory (9, 5, 2022-09-18);
INSERT INTO WorkHistory (10, 7, 2022-11-30);

