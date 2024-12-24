CREATE TABLE Typhoon (
    tyno NUMBER(10) CONSTRAINT Typhoon_tyno_PK PRIMARY KEY,
    tyname VARCHAR2(50) CONSTRAINT Typhoon_tyname_NN NOT NULL,
    cdate DATE CONSTRAINT Typhoon_cdate_NN NOT NULL,
    edate DATE ,
    rno NUMBER(3) CONSTRAINT Typhoon_rno_FK REFERENCES Typhoon_Rating_System(rno)
);

CREATE TABLE Impact (
    impinfo NUMBER(10) CONSTRAINT Impact_impinfo_PK PRIMARY KEY,
    misperson NUMBER(6) DEFAULT 0 CONSTRAINT Impact_misperson_CHK CHECK (misperson >= 0),
    inperson NUMBER(6) DEFAULT 0 CONSTRAINT Impact_inperson_CHK CHECK (inperson >= 0),
    evaperson NUMBER(6) DEFAULT 0 CONSTRAINT Impact_evaperson_CHK CHECK (evaperson >= 0),
    prodmg NUMBER(12) DEFAULT 0 CONSTRAINT Impact_prodmg_CHK CHECK (prodmg >= 0),
    tyno NUMBER(10) CONSTRAINT Impact_tyno_FK REFERENCES Typhoon(tyno),
    regno NUMBER(10) CONSTRAINT Region_regno_FK REFERENCES Region(regno)
);

CREATE TABLE Region (
    regno NUMBER(4) CONSTRAINT Region_regno_PK PRIMARY KEY,
    regname VARCHAR2(20) CONSTRAINT Region_regname_NN NOT NULL,
    country VARCHAR2(20) CONSTRAINT Region_country_NN NOT NULL,
    latitude NUMBER(6,3) CONSTRAINT Region_latitude_NN NOT NULL 
        CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMBER(6,3) CONSTRAINT Region_longitude_NN NOT NULL 
        CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE Weather (
    wno NUMBER(4) CONSTRAINT Weather_wno_PK PRIMARY KEY,
    highws NUMBER(3,1) CONSTRAINT Weather_highws_CHK CHECK (highws >= 0),
    tysize NUMBER(4) CONSTRAINT Weather_tysize_CHK CHECK (tysize >= 0),
    rainfall NUMBER(4) CONSTRAINT Weather_rainfall_CHK CHECK (rainfall >= 0),
    lowap NUMBER(4) CONSTRAINT Weather_lowap_CHK CHECK (lowap >= 0),
    latitude NUMBER(6,3) 
        CONSTRAINT Weather_latitude_CHK CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMBER(6,3) 
        CONSTRAINT Weather_longitude_CHK CHECK (longitude BETWEEN -180 AND 180),
    section VARCHAR2(20),
    tyno NUMBER(10) CONSTRAINT Weather_tyno_FK REFERENCES Typhoon(tyno) ON DELETE CASCADE
);

CREATE TABLE Typhoon_Rating_System (
    rno NUMBER(2) CONSTRAINT TRS_rno_PK PRIMARY KEY,
    minstd NUMBER(2) CONSTRAINT TRS_minstd_NN NOT NULL,
    maxstd NUMBER(3) CONSTRAINT TRS_maxstd_NN NOT NULL,
    rname VARCHAR2(50) CONSTRAINT TRS_rname_NN NOT NULL,
    CONSTRAINT TRS_std_range_CHK CHECK (minstd <= maxstd)
);


