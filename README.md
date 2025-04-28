# Mortgage Database Normalization Project

## Overview

This project demonstrates how to take a large, messy mortgage dataset and transform it into a fully normalized relational database following database design principles. The project includes identifying functional dependencies, designing tables in 3rd Normal Form (3NF), cleaning data, and enforcing data integrity using SQL.
Dataset can be accessed by downloading the existing mortgage data from https://www.consumerfinance.gov/data-research/hmda/historic-data/
For this project we will want the following options:
All records Includes applications, denials, originations, institution purchases
Plain language labels and HMDA codes
For this project we will only use the New Jersey data.
Then download all the data for 2017 from NJ.

## Features

- 🔹 Functional Dependency Analysis (included in PDF)
- 🔹 Database Design following 3NF standards
- 🔹 Data Cleaning and Type Casting (e.g., replacing empty strings, forcing correct types)
- 🔹 Robust Primary Key and Foreign Key constraints
- 🔹 SQL Scripts for:
  - Creating the preliminary table
  - Normalizing the database
  - Reconstructing the original dataset
- 🔹 CSV Export from normalized database

## Technologies Used

- PostgreSQL
- SQL

## File Descriptions

| File | Description |
|:----|:-------------|
| `Proj 1 Dependency and Norm Relation.pdf` | Functional Dependencies and Normalized Relations |
| `Project0.sql` | Preliminary table creation and raw data loading |
| `Project1CSVScript.sql` | Script for normalizing and cleaning the database |
| `Project1Final.sql` | Final normalized database structure and export |

## How to Run

1. Run `Project0.sql` to create the preliminary table and load raw data.
2. Run `Project1CSVScript.sql` to normalize the data into 3NF tables.
3. Run `Project1Final.sql` to finalize the database and export back to a CSV.

All SQL scripts are written for PostgreSQL compatibility.

## Example Questions the Database Can Answer

- Which loan types are most common in New Jersey mortgage applications?
- How do loan approvals vary by applicant race, ethnicity, or income?
- How does loan approval vary by geographic location (county/state/MSA)?
