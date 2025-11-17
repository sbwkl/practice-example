# Liquibase Example

This project demonstrates how to use Liquibase with Maven to manage database schema changes.

## Prerequisites

* Java Development Kit (JDK) 8 or higher
* Apache Maven
* A running MySQL instance

## Configuration

1.  **Database Connection:** The database connection properties are defined in the `db/<environment>/liquibase.properties` files. You will need to update these files with your database connection details.
2.  **Maven Profiles:** The `pom.xml` file includes profiles for different environments (e.g., `dev`, `dev-test`). You can activate a specific profile when running Maven commands.

## How to Run

### Applying All Changes

To apply all pending database changes, use the following Maven command:

```bash
mvn liquibase:update -P<profile>
```

Replace `<profile>` with the name of the Maven profile you want to use (e.g., `dev`).

### Updating to a Specific Tag

You can update your database to a specific tag that you have previously set in your changelog.

```bash
mvn liquibase:updateToTag -Dliquibase.toTag=<tag_name> -P<profile>
```

### Rolling Back Changes

Liquibase allows you to roll back changes in several ways.

#### Rollback by Count

To roll back a specific number of changesets, use the `rollbackCount` parameter.

```bash
mvn liquibase:rollback -Dliquibase.rollbackCount=<number_of_changesets> -P<profile>
```

#### Rollback to a Specific Date

To roll back all changesets applied after a specific date, use the `rollbackDate` parameter. The date should be in `YYYY-MM-DD HH:MM:SS` format.

```bash
mvn liquibase:rollback "-Dliquibase.rollbackDate=YYYY-MM-DD HH:MM:SS" -P<profile>
```

#### Rollback to a Specific Tag

To roll back all changesets applied after a specific tag, use the `toTag` parameter.

```bash
mvn liquibase:rollback -Dliquibase.toTag=<tag_name> -P<profile>
```

### Tagging the Database

You can tag the current state of the database for future rollbacks.

```bash
mvn liquibase:tag -Dliquibase.tag=<tag_name>
```

### Generating a Diff

You can generate a diff between your database and your changelog to see what changes have not been applied.

```bash
mvn liquibase:diff
```

### Checking Status

To see which changesets have been deployed and which are pending, use the `status` command.

```bash
mvn liquibase:status -P<profile>
```

### Validating the Changelog

To check your changelog for possible errors, use the `validate` command.

```bash
mvn liquibase:validate -P<profile>
```

### Marking Changes as Executed

If you need to mark all undeployed changes as executed in the database without actually running them, you can use `changelogSync`.

```bash
mvn liquibase:changelogSync -P<profile>
```

### Clearing Checksums

If you have modified a changeset that has already been deployed, you will get a checksum validation error. To clear the checksums from the database and allow the changeset to be re-deployed, you can use `clearCheckSums`.

```bash
mvn liquibase:clearCheckSums -P<profile>
```
