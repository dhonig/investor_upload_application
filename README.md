# InvestorUploadApplication

This project is an exercise in using Phoenix to solve a simple data entry and file upload problem.

## Database Setup with Docker

This project includes a Docker Compose configuration for setting up a PostgreSQL database for development and testing.

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Running PostgreSQL with Docker

1. **Start the PostgreSQL container:**

   ```bash
   docker-compose up db
   ```

Then run the following commands to create and migrate your database:

```bash
mix ecto.create
mix ecto.migrate
```

You can then run the project using
```
mix deps.get
mix phx. server
```
The project will start on http://localhost:4000

## Project Status

### Work Completed
* Created basic Phoenix application structure
* Implemented investor data model with validations
* Added form for investor data entry with field validation
* Implemented CSV file upload functionality
* Added input masking for formatted fields (SSN, phone number, zip code)
* Configured Docker for development environment
* Created comprehensive documentation
* Added format validation for SSN, phone number, and zip code
* Implemented date of birth validation
* Added helper text for form fields

### Next Steps

* Add user authentication and authorization using Pow
* Implement CSV parsing and data import functionality
* Create admin dashboard for managing investors
* Implement data export capabilities
* Create user roles and permissions
* Implement email notifications
* Add data visualization components
* Create a RESTful API for programmatic access
* Implement comprehensive test suite
* Phoenix should support 8mb file uploads by default, for larger files, we can adjust the multipart parser configuration
* Migrate frontend to Liveview and implement upload progress using Liveview features
* Move file strorage from localhost to a cloud based object storage (S3/Azure Blob Storage/Google Cloud Storage)

