# SIH Team Elevates Backend structure
## About
The Elevate backend repository for the SIH 2023 team uses Express framework with MongoDB and plans to transition to PostgreSQL integrated with Prisma ORM. It addresses challenges faced by shovel operators in large-scale mining by enhancing real-time visibility of dumper load statuses. This proactive system aims to reduce workflow inefficiencies, delays, and potential accidents resulting from the lack of immediate load status insight. Its evolution promises improved safety and efficiency in mining operations, while also setting the groundwork for future scalability and enhanced data management through potential database upgrades.

## How to Use
### Cloning Backend and Frontend Repositories

1. Clone the backend repository:
    ```bash
    git clone <backend_repository_url>
    ```

2. Clone the frontend repository:
    ```bash
    git clone <frontend_repository_url>
    ```

### Installing Dependencies

3. Navigate to the backend repository and install dependencies:
    ```bash
    cd <backend_repository_folder>
    npm install
    ```

4. Navigate to the frontend repository and install dependencies:
    ```bash
    cd <frontend_repository_folder>
    npm install
    ```

### Setting Up Environment Variables

5. Create a `.env` file in the backend repository with the following variables:
    ```dotenv
    MONGODB_URL=<your_mongodb_connection_string>
    SALT_WORK_FACTOR=<your_salt_work_factor_value>
    PORT=3001
    SECRET=<your_secret_key>
    ```

### Running the Applications

6. Start the backend server:
    ```bash
    cd <backend_repository_folder>
    npm start
    ```

7. Start the frontend server:
    ```bash
    cd <frontend_repository_folder>
    npm start
    ```

Make sure to replace `<backend_repository_url>`, `<frontend_repository_url>`, `<your_mongodb_connection_string>`, `<your_salt_work_factor_value>`, and `<your_secret_key>` with the actual URLs, values, and keys for your setup.

## Schema

this is a basic representation of the MongoDB schema, whereas hyperledger is suppose to store the present location and filled status of the dumster and other information related to shovel and dumster

| User        |               | Dumpster    |                 | Shovel   |               | Queries                          | Announcements |
|-------------|---------------|-------------|-----------------|----------|---------------|----------------------------------|---------------|
| _id         |               | _id         |                 | _id      |               | _id                              | _id           |
| email       |               | id          |                 | name     |               | user                             |content        |
| name        |               | name        |                 | size     |               | description/status/response      |createdAt      |
| password    |               | capacity    |                 | worker   |               |                                   |               |
| total       |               | driver      |                 |          |               |                                   |               |
| type        |               | status      |                 |          |               |                                   |               |
| autho       |               |             |                 |          |               |                                   |               |
| lastLogin   |               |             |                 |          |               |                                   |               |
| History     |               |             |                 |          |               |                                   |               |
| queries ⟶   | [User]        |             |                 |          |               |                                   |               |
| equipment   | [Dumster/Shovel] |             |                 |          |               |                                   |               |
| onModel     | ['dumsters', 'shovels'] |             |                 |          |               |                                   |               |


*The folder structure can be found in backend/database/


## API endpoints and their description
1. **POST /frontend/authenticate**
   - *Description*: Authenticates a user based on their email and password.
   - *Request Body*: `{ "email": "user@example.com", "password": "userpassword" }`
   - *Response*:
     - Successful authentication: `{ success: true, message: 'Authentication succeeded.', autho: 'generatedToken', name: 'userName' }`
     - Failed authentication: `{ success: false, message: 'Authentication failed. User not found.' }` or `{ success: false, message: 'Authentication failed. Wrong password.' }`

2. **POST /frontend/register**
   - *Description*: Registers a new user.
   - *Request Body*: `{ "name": "UserName", "email": "user@example.com", "password": "userpassword", "type": "userType" }`
   - *Response*:
     - Successful registration: `{ success: true, message: 'Register succeeded', autho: 'generatedToken', type: 'userType' }`
     - Failed registration: `{ success: false, message: 'Register failed' + errorMessage }`

3. **Middleware: Token Authentication**
   - *Description*: Verifies the token for authentication.
   - *Parameters*: `req.headers['Authorization']`
   - *Response*:
     - Failed to authenticate token: `{ success: false, message: 'Failed to authenticate token.' }`
     - No token provided: `{ success: false, message: 'No token provided.' }`
     - Success (if authenticated): Proceeds to the next middleware or endpoint.

4. **GET /frontend/users**
   - *Description*: Retrieves users based on type and/or name.
   - *Query Parameters*: `type`, `name`
   - *Response*: `{ success: true, message: 'Get users succeeded', users: [user1, user2, ...] }` or `{ success: false, message: 'Get users failed' + errorMessage }`

5. **DELETE /frontend/queries/:id**
   - *Description*: Deletes a query by ID.
   - *Parameters*: `id` (query ID)
   - *Response*: `{ success: true, message: 'Delete queries succeeded', query: deletedQuery }` or `{ success: false, message: 'Delete queries failed' + errorMessage }`

6. **PUT /frontend/queries/:id**
   - *Description*: Updates a query's status by ID.
   - *Parameters*: `id` (query ID)
   - *Response*: `{ success: true, message: 'Update queries succeeded', query: updatedQuery }` or `{ success: false, message: 'Update queries failed' + errorMessage }`

7. **POST /frontend/queries**
   - *Description*: Creates a new query and associates it with a user.
   - *Request Body*: `{ "user": "userID", "description": "Query description" }`
   - *Response*: `{ success: true, message: 'Post queries succeeded', query: newQuery }` or `{ success: false, message: 'Post queries failed' + errorMessage }`

8. **GET /frontend/queries**
   - *Description*: Retrieves queries with a specific status.
   - *Parameters*: `status`
   - *Response*: `{ success: true, message: 'Get queries succeeded', queries: [query1, query2, ...] }` or `{ success: false, message: 'Get queries failed' + errorMessage }`

9. **GET /frontend/dumpsters_shovels_summary**
   - *Description*: Retrieves a summary of the status of dumpsters and shovels.
   - *Response*: `{ success: true, message: 'Get dumpsters_shovels_summary succeeded', trueDumper: trueDumperCount, falseDumper: falseDumperCount, trueShovel: trueShovelCount, falseShovel: falseShovelCount }` or `{ success: false, message: 'Get dumpsters_shovels_summary failed' + errorMessage }`

10. **GET /frontend/announcements**
    - *Description*: Retrieves announcements sorted by creation date.
    - *Response*: `{ success: true, message: 'Get announcements succeeded', announcements: [announcement1, announcement2, ...] }` or `{ success: false, message: 'Get announcements failed' + errorMessage }`

11. **POST /frontend/announcements**
    - *Description*: Creates a new announcement.
    - *Request Body*: `{ "content": "Announcement content" }`
    - *Response*: `{ success: true, message: 'Post announcements succeeded', announcement: newAnnouncement }` or `{ success: false, message: 'Post announcements failed' + errorMessage }`

12. **GET /frontend/dumpsters_shovels**
    - *Description*: Retrieves all dumpsters and shovels along with their respective drivers.
    - *Response*: `{ success: true, message: 'Get dumpsters_shovels succeeded', dumper: [dumper1, dumper2, ...], shovel: [shovel1, shovel2, ...] }` or `{ success: false, message: 'Get dumpsters_shovels failed' + errorMessage }`

13. **POST /frontend/dumpster**
    - *Description*: Creates a new dumpster.
    - *Request Body*: `{ "id": "dumpsterID", "name": "DumpsterName", "capacity": "dumpsterCapacity" }`
    - *Response*: `{ success: true, message: 'Post dumpster succeeded', dumper: newDumper }` or `{ success: false, message: 'Post dumpster failed' + errorMessage }`

*the folder structure can be explored as backend/router  
*The backend is also suppose to serve the statics i.e. build of react i.e the admin page
