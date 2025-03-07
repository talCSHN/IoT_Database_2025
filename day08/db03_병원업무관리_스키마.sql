CREATE TABLE Doctors
(
	doc_id               INTEGER NOT NULL,
	major_treat          VARCHAR(25) NOT NULL,
	doc_name             VARCHAR(20) NOT NULL,
	doc_gen              CHAR(1) NOT NULL,
	doc_phone            VARCHAR(20) NULL,
	doc_email            VARCHAR(50) NULL UNIQUE,
	doc_position         VARCHAR(20) NOT NULL
);
ALTER TABLE Doctors
ADD PRIMARY KEY (doc_id);

CREATE TABLE Nurses
(
	nur_id               INTEGER NOT NULL,
	major_job            VARCHAR(25) NOT NULL,
	nur_name             VARCHAR(20) NOT NULL,
	nur_gen              char(1) NOT NULL,
	nur_phone            VARCHAR(20) NULL,
	nur_email            VARCHAR(50) NULL UNIQUE,
	nur_position         VARCHAR(20) NOT NULL
);
ALTER TABLE Nurses
ADD PRIMARY KEY (nur_id);

CREATE TABLE Patients
(
	pat_id               INTEGER NOT NULL,
	pat_name             VARCHAR(20) NOT NULL,
	pat_gen              char(1) NOT NULL,
	pat_jumin            VARCHAR(14) NOT NULL,
	pat_addr             VARCHAR(100) NOT NULL,
	pat_phone            VARCHAR(20) NULL,
	pat_email            VARCHAR(50) NULL UNIQUE,
	pat_job              VARCHAR(20) NOT NULL,
	doc_id               INTEGER NULL,
	nur_id               INTEGER NULL
);
ALTER TABLE Patients
ADD PRIMARY KEY (pat_id);

CREATE TABLE Treatments
(
	treat_id             INTEGER NOT NULL,
	treat_contents       VARCHAR(1000) NOT NULL,
	treat_date           DATE NOT NULL,
	doc_id               INTEGER NOT NULL,
	pat_id               INTEGER NOT NULL
);
ALTER TABLE Treatments
ADD PRIMARY KEY (treat_id,doc_id,pat_id);


CREATE TABLE Charts
(
	chart_id             VARCHAR(20) NOT NULL,
	chart_contents       VARCHAR(1000) NOT NULL,
	treat_id             INTEGER NOT NULL,
	doc_id               INTEGER NOT NULL,
	pat_id               INTEGER NOT NULL,
	nur_id               INTEGER NULL
);
ALTER TABLE Charts
ADD PRIMARY KEY (chart_id,treat_id,doc_id,pat_id);


ALTER TABLE Patients
ADD FOREIGN KEY R_1 (doc_id) REFERENCES Doctors (doc_id);

ALTER TABLE Patients
ADD FOREIGN KEY R_2 (nur_id) REFERENCES Nurses (nur_id);

ALTER TABLE Treatments
ADD FOREIGN KEY R_3 (doc_id) REFERENCES Doctors (doc_id);

ALTER TABLE Treatments
ADD FOREIGN KEY R_4 (pat_id) REFERENCES Patients (pat_id);

ALTER TABLE Charts
ADD FOREIGN KEY R_5 (treat_id, doc_id, pat_id) REFERENCES Treatments (treat_id, doc_id, pat_id);

ALTER TABLE Charts
ADD FOREIGN KEY R_6 (nur_id) REFERENCES Nurses (nur_id);