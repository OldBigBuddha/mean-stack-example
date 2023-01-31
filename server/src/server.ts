import * as dotenv from "dotenv";
import cors from "cors";
import express from "express";
import { connectToDatabase } from "./database";
import { employeeRouter } from "./employee.routes";

// Load environment variables from the .env file, where the MONGO_DB_URL is configured
dotenv.config();

const { MONGO_DB_URL } = process.env;

if (!MONGO_DB_URL) {
    console.error("No MONGO_DB_URL environment variable has been defined in config.env");
    process.exit(1);
}

connectToDatabase(MONGO_DB_URL)
    .then(() => {
        const app = express();
        app.use(cors());
        app.use("/employees", employeeRouter);

        // start the Express server
        app.listen(5200, () => {
            console.log(`Server running at http://localhost:5200...`);
        });

    })
    .catch(error => console.error(error));
