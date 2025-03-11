import { randomUUIDv7 } from "bun";
import { decimal, integer, jsonb, pgEnum, pgTable, uuid, varchar } from "drizzle-orm/pg-core";

export const accountStatus = pgEnum("account_status", ["ACTIVE", "INACTIVE", "SUSPENDED", "CLOSED"]);

/**
 * Financial accounts table to store all account-related information.
 */
export const accounts = pgTable("accounts", {
    id: uuid("id")
        .primaryKey()
        .$defaultFn((): string => randomUUIDv7()),
    ownerId: uuid("owner_id").$defaultFn((): string => randomUUIDv7()),
    balance: decimal("balance", { precision: 10, scale: 2 }).notNull(),
    currency: varchar("currency", { length: 3 }).notNull().default("USD"),
    status: accountStatus("status").notNull().default("ACTIVE"),
    createdAt: varchar("created_at", { length: 50 }).notNull().default(new Date().toISOString()),
    updatedAt: varchar("updated_at", { length: 50 }).notNull().default(new Date().toISOString()),
    deletedAt: varchar("deleted_at", { length: 50 }),
});

export const transactionType = pgEnum("transaction_type", ["DEPOSIT", "WITHDRAWAL", "TRANSFER"]);
export const transactionStatus = pgEnum("transaction_status", ["PENDING", "COMPLETED", "FAILED"]);

/**
 * Transactions table to store all transactions related to accounts.
 */
export const transactions = pgTable("transactions", {
    id: uuid("id")
        .primaryKey()
        .$defaultFn((): string => randomUUIDv7()),
    accountId: uuid("account_id")
        .notNull()
        .references(() => accounts.id, { onDelete: "cascade" }),
    type: transactionType("type").notNull(),
    amount: decimal("amount", { precision: 10, scale: 2 }).notNull(),
    currency: varchar("currency", { length: 3 }).notNull().default("USD"),
    status: transactionStatus("status").notNull().default("PENDING"),
    transactionDate: varchar("transaction_date", { length: 50 }).notNull().default(new Date().toISOString()),
    notes: varchar("notes", { length: 255 }),
    createdAt: varchar("created_at", { length: 50 }).notNull().default(new Date().toISOString()),
    updatedAt: varchar("updated_at", { length: 50 }).notNull().default(new Date().toISOString()),
    deletedAt: varchar("deleted_at", { length: 50 }),
});

/**
 * Stores all domain events, enabling full event replay and system auditability.
 */
export const eventStore = pgTable("event_store", {
    id: uuid("id")
        .primaryKey()
        .$defaultFn((): string => randomUUIDv7()),
    aggregateId: uuid("aggregate_id")
        .notNull()
        .references(() => accounts.id, { onDelete: "cascade" }),
    aggregateType: varchar("aggregate_type", { length: 50 }).notNull(),
    eventType: varchar("event_type", { length: 50 }).notNull(),
    eventData: jsonb("event_data").notNull(),
    version: integer("version").notNull(),
    metadata: jsonb("metadata"),
    eventDate: varchar("event_date", { length: 50 }).notNull().default(new Date().toISOString()),
    createdAt: varchar("created_at", { length: 50 }).notNull().default(new Date().toISOString()),
    updatedAt: varchar("updated_at", { length: 50 }).notNull().default(new Date().toISOString()),
    deletedAt: varchar("deleted_at", { length: 50 }),
});

/**
 * Stores periodic snapshots of aggregates to optimize event replay.
 */
export const snapshots = pgTable("snapshots", {
    id: uuid("id")
        .primaryKey()
        .$defaultFn((): string => randomUUIDv7()),
    aggregateId: uuid("aggregate_id")
        .notNull()
        .references(() => accounts.id, { onDelete: "cascade" }),
    aggregateType: varchar("aggregate_type", { length: 50 }).notNull(),
    state: jsonb("state").notNull(),
    version: integer("version").notNull(),
    snapshotDate: varchar("snapshot_date", { length: 50 }).notNull().default(new Date().toISOString()),
    createdAt: varchar("created_at", { length: 50 }).notNull().default(new Date().toISOString()),
    updatedAt: varchar("updated_at", { length: 50 }).notNull().default(new Date().toISOString()),
    deletedAt: varchar("deleted_at", { length: 50 }),
});
