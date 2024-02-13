-- noinspection SqlNoDataSourceInspectionForFile

create keyspace if not exists ares with replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

// set keyspace

use ares;

// archives

create table if not exists archives
(
    uniqueid        uuid,
    extendedid      text,
    timecreated     timestamp,
    primary key ( uniqueid )
);

// measurements

create table if not exists measurements
(
    archive         uuid,
    uniqueid        uuid,
    latitude        double,
    longitude       double,
    timecreated     timestamp,
    altitude        double,
    pressure        double,
    no2comp         double,
    cocomp          double,
    primary key ( archive, uniqueid )
);

// photos

create table if not exists photos
(
    archive         uuid,
    uniqueid        uuid,
    latitude        double,
    longitude       double,
    timecreated     timestamp,
    image           blob,
    primary key ( archive, uniqueid )
);

// panaromas

create table if not exists panaromas
(
    archive         uuid,
    uniqueid        uuid,
    latitude        double,
    longitude       double,
    timecreated     timestamp,
    image           blob,
    primary key ( archive, uniqueid )
);

