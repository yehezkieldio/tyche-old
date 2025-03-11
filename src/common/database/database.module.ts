import { Module } from "@nestjs/common";
import { DrizzleProvider, drizzleProvider } from "#/database/database.provider";

@Module({
    providers: [...drizzleProvider],
    exports: [DrizzleProvider],
})
export class DrizzleModule {}
