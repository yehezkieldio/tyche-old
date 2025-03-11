import { defineConfig } from "drizzle-kit";

export default defineConfig({
    dialect: "postgresql",
    schema: "./src/common/database/database.schema.ts",
    dbCredentials: {
        url: process.env.DATABASE_URL!,
    },
});
