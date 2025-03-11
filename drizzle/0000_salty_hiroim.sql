CREATE TYPE "public"."account_status" AS ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED', 'CLOSED');--> statement-breakpoint
CREATE TYPE "public"."transaction_status" AS ENUM('PENDING', 'COMPLETED', 'FAILED');--> statement-breakpoint
CREATE TYPE "public"."transaction_type" AS ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');--> statement-breakpoint
CREATE TABLE "accounts" (
	"id" uuid PRIMARY KEY NOT NULL,
	"owner_id" uuid,
	"balance" numeric(10, 2) NOT NULL,
	"currency" varchar(3) DEFAULT 'USD' NOT NULL,
	"status" "account_status" DEFAULT 'ACTIVE' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T09:08:27.913Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T09:08:27.913Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
CREATE TABLE "event_store" (
	"id" uuid PRIMARY KEY NOT NULL,
	"aggregate_id" uuid NOT NULL,
	"aggregate_type" varchar(50) NOT NULL,
	"event_type" varchar(50) NOT NULL,
	"event_data" jsonb NOT NULL,
	"version" integer NOT NULL,
	"metadata" jsonb,
	"event_date" varchar(50) DEFAULT '2025-03-11T09:08:27.920Z' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T09:08:27.920Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T09:08:27.920Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
CREATE TABLE "snapshots" (
	"id" uuid PRIMARY KEY NOT NULL,
	"aggregate_id" uuid NOT NULL,
	"aggregate_type" varchar(50) NOT NULL,
	"state" jsonb NOT NULL,
	"version" integer NOT NULL,
	"snapshot_date" varchar(50) DEFAULT '2025-03-11T09:08:27.920Z' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T09:08:27.921Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T09:08:27.921Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
CREATE TABLE "transactions" (
	"id" uuid PRIMARY KEY NOT NULL,
	"account_id" uuid NOT NULL,
	"type" "transaction_type" NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"currency" varchar(3) DEFAULT 'USD' NOT NULL,
	"status" "transaction_status" DEFAULT 'PENDING' NOT NULL,
	"transaction_date" varchar(50) DEFAULT '2025-03-11T09:08:27.914Z' NOT NULL,
	"notes" varchar(255),
	"created_at" varchar(50) DEFAULT '2025-03-11T09:08:27.914Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T09:08:27.914Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
ALTER TABLE "event_store" ADD CONSTRAINT "event_store_aggregate_id_accounts_id_fk" FOREIGN KEY ("aggregate_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "snapshots" ADD CONSTRAINT "snapshots_aggregate_id_accounts_id_fk" FOREIGN KEY ("aggregate_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_account_id_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE MATERIALIZED VIEW "public"."account_summary" AS (select "accounts"."id", "accounts"."owner_id", "accounts"."currency", COALESCE(SUM(
          CASE
            WHEN "transactions"."type" = 'DEPOSIT' THEN "transactions"."amount"
            WHEN "transactions"."type" = 'WITHDRAWAL' THEN -"transactions"."amount"
            ELSE 0
          END
        ), 0) as "balance", "accounts"."status", "accounts"."created_at" from "accounts" left join "transactions" on "accounts"."id" = "transactions"."account_id" group by "accounts"."id", "accounts"."owner_id", "accounts"."currency", "accounts"."status", "accounts"."created_at");--> statement-breakpoint
CREATE MATERIALIZED VIEW "public"."transaction_history" AS (select "id", "account_id", "type", "amount", "currency", "status", "created_at" from "transactions");