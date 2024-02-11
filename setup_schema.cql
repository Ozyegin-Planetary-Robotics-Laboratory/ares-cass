-- noinspection SqlNoDataSourceInspectionForFile

create keyspace if not exists ares with replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

// set keyspace

use ares;

// archives

create table if not exists archives
(
    uuid        uuid,
    createdat   timestamp,
    updatedat   timestamp,
    name        text,
    eid         text,
    primary key ( uuid )
);

// measurements

create table if not exists measurements
(
    archive     uuid,
    uuid        uuid,
    createdat   timestamp,
    latitude    double,
    longitude   double,
    altitude    double,
    pressure    double,
    images      list<uuid>,
    panoramas   list<uuid>,
    no2comp     double,
    cocomp      double,
    primary key ( archive, uuid )
);

// images

create table if not exists images
(
    archive     uuid,
    measurement uuid,
    uuid        uuid,
    createdat   timestamp,
    image       blob,
    primary key ( archive, measurement, uuid )
)