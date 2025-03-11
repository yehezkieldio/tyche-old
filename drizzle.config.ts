import { defineConfig } from "drizzle-kit";

export default defineConfig({
    dialect: "postgresql",
    schema: "./src/database/database.schema.ts",
    dbCredentials: {
        url: process.env.DATABASE_URL!,
    },
});
