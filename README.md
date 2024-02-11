# ares-cass

Ares Cassandra/Scylla Scientific Data Schema

## Installation

### Install ScyllaDB
Run a ScyllaDB container with the following command:

```bash
docker run -p 9042:9042 --name some-scylla --hostname some-scylla -d scylladb/scylla
```

### Connect to ScyllaDB

#### 1. Using DataGrip:

Add a new data source with the following settings:

- Host: localhost
- Port: 9042
- Username: cassandra
- Password: cassandra

#### 2. Using cqlsh:

Connect to the ScyllaDB container with the following command:

```bash
docker exec -it some-scylla cqlsh
```

### Setup schema

Schema is defined in `setup_schema.cql` file. Paste the script into cqlsh shell or DataGrip console and execute it to create keyspace and tables.

## Usage

### Insert data

Insert data into table using CQL commands or DataGrip console.

#### Create an archive

```cql
INSERT INTO ares.archives (uuid, name, eid, createdat, updatedat) VALUES (uuid(), 'Test Archive', 'external_id_0000', toTimestamp(now()), toTimestamp(now()));
```

#### Create an image

Image data is blob.
```cql
INSERT INTO ares.images (archive, measurement, uuid, image, createdat) VALUES (archive_uuid_0001, measurement_uuid_0001, uuid(), 0x00000000, toTimestamp(now()));
```

#### Create a measurement

```cql
INSERT INTO ares.measurements(archive, uuid, createdat, latitude, longitude, altitude, pressure, images, panoramas, no2comp, cocomp) VALUES (archive_uuid_0001, uuid(), toTimestamp(now()), 0.0, 0.0, 0.0, 0.0, {image_uuid_0001, image_uuid_0002}, {image_uuid_0003, image_uuid_0004}, 0.0, 0.0);
```

### Query data

Query data from table using CQL commands or DataGrip console.

#### Get all archives

```cql
SELECT * FROM ares.archives;
```

#### Get images

- All images
    ```cql
    SELECT * FROM ares.images;
    ```
- Images by archive
    ```cql
    SELECT * FROM ares.images WHERE archive = archive_uuid_0001;
    ```
- Images by measurement
    ```cql
    SELECT * FROM ares.images WHERE archive = archive_uuid_0001 AND measurement = measurement_uuid_0001;
    ```
- Image by uuid
    ```cql
    SELECT * FROM ares.images WHERE archive = archive_uuid_0001 AND measurement = measurement_uuid_0001 AND uuid = image_uuid_0001;
    ```
  
#### Get measurements

- All measurements
    ```cql
    SELECT * FROM ares.measurements;
    ```
- Measurements by archive
    ```cql
    SELECT * FROM ares.measurements WHERE archive = archive_uuid_0001;
    ```

## Troubleshooting

### DataGrip connection error

Check if the ScyllaDB container is running and the connection settings are correct. Ensure that port 9042 is open, not used by any other process, and accessible.

### Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING

This is the most common issue with Cassandra databases. It is caused by the fact that Cassandra does not support filtering by non-primary key columns. If you are querying by a primary key column, your query must restrict any other primary key with lower ordinal (if table a has primary key(X, Y, Z), you can't query by Y without restricting X).

To fix this issue:

#### 1. Add ALLOW FILTERING at the end of the query (Not recommended, it will slow down the query)

#### 2. Create a new table with a different primary key

#### 3. Create a secondary index (Don't use this option if you have a lot of data it will slow down the query, especially if you have a lot of nodes and a high cardinality of the indexed column)

#### 4. Rewrite your query to properly specify the primary key