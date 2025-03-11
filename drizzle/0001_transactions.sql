CREATE TYPE "public"."transaction_status" AS ENUM('PENDING', 'COMPLETED', 'FAILED');--> statement-breakpoint
CREATE TYPE "public"."transaction_type" AS ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');--> statement-breakpoint
CREATE TABLE "transactions" (
	"id" uuid PRIMARY KEY NOT NULL,
	"account_id" uuid NOT NULL,
	"type" "transaction_type" NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"currency" varchar(3) DEFAULT 'USD' NOT NULL,
	"status" "transaction_status" DEFAULT 'PENDING' NOT NULL,
	"transaction_date" varchar(50) DEFAULT '2025-03-11T08:16:45.636Z' NOT NULL,
	"notes" varchar(255),
	"created_at" varchar(50) DEFAULT '2025-03-11T08:16:45.636Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T08:16:45.636Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
ALTER TABLE "accounts" ALTER COLUMN "created_at" SET DEFAULT '2025-03-11T08:16:45.635Z';--> statement-breakpoint
ALTER TABLE "accounts" ALTER COLUMN "updated_at" SET DEFAULT '2025-03-11T08:16:45.635Z';--> statement-breakpoint
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_account_id_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;