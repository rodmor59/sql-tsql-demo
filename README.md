# SQL and Transact SQL (T-SQL) Demo
Welcome to the SQL and Transact SQL Demo. This project encompasses a series of SQL/T-SQL scripts that demonstrate the functionality of the SQL programming language and Microsoft SQL Server databases. I constructed this demo when studying and completing Alison's **Diploma in Databases and T-SQL** course, which you can find at [this link](https://alison.com/course/diploma-in-databases-and-t-sql-revised).

Feel free to explore the code and don't hesitate to reach out with any questions or feedback you may have!

<!--
(#table-of-contents)
-->

## Table of Contents

* [About this Project](#about-this-project)
* [Completed Features](#completed-features)
* [Planned Features](#planned-features)
* [Technologies](#technologies)
* [Setup](#setup)
* [Usage](#usage)
* [Project Status](#project-status)
* [Contact](#contact)

<!--
(#general-information)
-->

## About This Project

This project aims to:

* Describe the core concepts of databases and their structure.
* Demonstrate how to retrieve data from a database using Structured Query Language (SQL) and Microsoft's variant Transact-SQL (T-SQL)
* Describe the different constraints and clauses you can include in SQL queries.
* Demonstrate how to perform administrative tasks on a database.

<!--
(#list-of-sql-scripts)
-->

## List of SQL | T-SQL Scripts

This project contains a series of SQL script files; Each includes code comments describing the course challenge completed in each SQL code segment.

These scripts were developed for the Microsoft AdventureWorks Database, included in this repo [here](./adventureworks-sql-server-database).

The SQL script files are:

* **Lab 1 Intro to Transact SQL:** Introduction to the SQL language, retrieving data from tables using different constraints and clauses methods.
* **Lab 2 Querying with Transact-SQL:** More querying tables using SELECT, WHERE, IN, LIKE and more.
* **Lab 3 QUerying Multiple Tables With Joins:** Using JOIN, ON, INNER-JOIN, LEFT-JOIN, RIGHT-JOIN, ORDER-BY and more.
* **Lab 4 Using Set Operators:** Use set operators to combine the results of multiple queries.
* **Lab 5 Using Functions and Aggregating Data:** Use functions to retrieve, aggregate, and group data.
* **Lab 6 Using Subqueries and APPLY:** Use subqueries and the APPLY operator to apply filters and calculations at different levels to retrieve data that match certain characteristics.
* **Lab 7 Using Table Expressions:** Views, temporary tables, variables, table-valued functions, derived tables, 
-- and common table expressions.
* **Lab 8 Grouping Sets and Pivoting Data:** Grouping sets and the PIVOT operator to summarize data.
* **Lab 9 Modyfing Data:** Using INSERT, UPDATE and DELETE to add, modify and remove data.
* **Lab 10 Programming With Transact-SQL:** Demonstrate using Transact-SQL programming logic to work with data.
* **Lab 11 Error Handling and Transactions:** Use Transact-SQL to implement error handling and transactions

<!--
(#tech-stack-used)
-->

## Technologies

### Stack

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

### Tools

- SQL Server.
- SQL Server Management Studio 2022.

<!--
(#instalation-instructions)
-->

## Setup

### Prerequisites

- This project was developed in a Windows environment. However, it can run on any SQL Database in any environment, except for the scripts of labs 10 and 11 that require a database that supports T-SQL.
- Install Microsoft SQL Server or SQL Express. [Download here](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- Install SQL Server Management Studio. [Download here](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16&redirectedfrom=MSDN)

### Setup Procedure

- Download or clone repo.
- Open SQL Server Management Studio.
- Answer the prompt to connect to the database server configured in your environment.
- Restore the Microsoft Adventure Works Database:
    * On the object explorer at the left side of the screen, right-click on the folder "Databases."
    * Select the "Restore Database" option.
    * Press the add button.
    * On the Source section, select "Device."
    * Press the file prompt button (Button with '...').
    * Press the "Add" button.
    * Look for the Adventure Works Database .bak file. This file is included in this repo [here](./adventureworks-sql-server-database). 
- You are set to run the project once the database is restored.

<!--
(#instructions-for-running-sql-script)
-->

## Usage

- Open SQL Server Management Studio.
- Answer the prompt to connect to the database server configured in your environment.
- Add the SQL Scripts files:
    * Select the "File" menu.
    * Select the "Open" menu option.
    * Select the "File" option in the submenu.
    * Look for the folder with the SQL scripts files [here](./sql-script-files)
    * Use your mouse to select all the 11 SQL script files.
    * The system will create a new SQL solution and add the SQL script files.
    * You may reorganize the files, rename the solution and create SQL subprojects as required.
- Run SQL server scripts as you require.
    * You can now run the SQL server scripts.
    * To run the entire script, select one of the files and press the "Execute" button.
    * You may also select a segment of SQL code with your mouse, right-click, and then select the "Execute" option from the prompt menu.
    * Feel free to review, study, run different segments of SQL code and experiment. 

<!--
(#project-status)
-->

## Project Status

Project is: Completed. 

Feel free to make suggestions on how to improve the project.

<!--
(#contact-me)
-->

## Contact

Created by **Ricardo Rodriguez** - contact me on the following links:

[![Ricardo's Github Profile](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rodmor59)
[![Ricardo's Linkedin Profile](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ricartrodrig)