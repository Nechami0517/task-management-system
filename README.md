
# Task Management System

A comprehensive task management system built on SQL Server. This project includes a database schema, functions, stored procedures, and triggers for efficient management of tasks and users.

## Project Description

This project implements a task management system that allows users to create, assign, and track tasks. The system is designed with an emphasis on data integrity and efficiency, featuring capabilities such as:

- **User authentication** via a scalar function.
- **Hierarchical management** of users and tasks (parent tasks and subtasks).
- **Automated task status updates** using stored procedures and triggers.
- **Task insertion with user permission validation.**
- **General task assignment** to a group of employees using Cursors and transactions.
- **Table optimization** by deleting old "completed" tasks using a trigger and window function.
- **A function to retrieve user tasks**, including calculated status information.

> **Note:** The view displaying a summary of tasks by status (described in the exercise) is not included in the provided SQL files.

## Environment Setup

This project is intended to run on **SQL Server**.

### Prerequisites

- SQL Server (latest version recommended)
- SQL Server Management Studio (SSMS) or a similar tool for executing scripts

### Installation and Execution

1. **Create a new database:**
    ```sql
    CREATE DATABASE project;
    GO
    USE project;
    GO
    ```

2. **Build the tables:**
   - `Users` table
   - `statusim` table
   - `task` table

   > The code for creating the tables is in the `task-management-system.sql` file.

3. **Insert sample data:**
   > The code for inserting sample data into the tables (`Users`, `statusim`, `task`) is in the `details
   .sql` file.

4. **Create the database objects (functions, procedures, triggers):**
   - **Functions:** `identification`, `the_workers_below`, `Retrieving_all_subtasks`, `fathersTask`, `retrievingTasks`
   - **Stored Procedures:** `ChangeStatus`, `addTask`, `addGeneralTask`
   - **Triggers:** `checkStatusim` (for status update), `deletingOldTask` (for old task deletion)

   > These scripts are located in `script.sql` and ` Objects.sql`

5. **Execute objects and test the system:**
   > Examples for executing the objects can be found in the `script.sql` and `Objects.sql` files.
