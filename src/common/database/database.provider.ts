import { ConfigService } from "@nestjs/config";
import { type PostgresJsDatabase, drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "./database.schema";

export const DrizzleProvider = "DrizzleProvider";

export const drizzleProvider = [
    {
        provide: DrizzleProvider,
        inject: [ConfigService],
        useFactory: (configService: ConfigService) => {
            const url: string | undefined = configService.get<string>("DATABASE_URL");
            if (!url) throw new Error("DATABASE_URL is not defined");

            const queryClient = postgres(url);
            return drizzle(queryClient, { schema }) as PostgresJsDatabase<typeof schema>;
        },
    },
];
