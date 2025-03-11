CREATE TYPE "public"."account_status" AS ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED', 'CLOSED');--> statement-breakpoint
CREATE TABLE "accounts" (
	"id" uuid PRIMARY KEY NOT NULL,
	"owner_id" uuid,
	"balance" numeric(10, 2) NOT NULL,
	"currency" varchar(3) DEFAULT 'USD' NOT NULL,
	"status" "account_status" DEFAULT 'ACTIVE' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T08:12:14.603Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T08:12:14.603Z' NOT NULL,
	"deleted_at" varchar(50)
);
