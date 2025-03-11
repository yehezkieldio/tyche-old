CREATE TABLE "event_store" (
	"id" uuid PRIMARY KEY NOT NULL,
	"aggregate_id" uuid NOT NULL,
	"aggregate_type" varchar(50) NOT NULL,
	"event_type" varchar(50) NOT NULL,
	"event_data" jsonb NOT NULL,
	"version" integer NOT NULL,
	"metadata" jsonb,
	"event_date" varchar(50) DEFAULT '2025-03-11T08:25:31.341Z' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T08:25:31.341Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T08:25:31.341Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
CREATE TABLE "snapshots" (
	"id" uuid PRIMARY KEY NOT NULL,
	"aggregate_id" uuid NOT NULL,
	"aggregate_type" varchar(50) NOT NULL,
	"state" jsonb NOT NULL,
	"version" integer NOT NULL,
	"snapshot_date" varchar(50) DEFAULT '2025-03-11T08:25:31.342Z' NOT NULL,
	"created_at" varchar(50) DEFAULT '2025-03-11T08:25:31.342Z' NOT NULL,
	"updated_at" varchar(50) DEFAULT '2025-03-11T08:25:31.342Z' NOT NULL,
	"deleted_at" varchar(50)
);
--> statement-breakpoint
ALTER TABLE "accounts" ALTER COLUMN "created_at" SET DEFAULT '2025-03-11T08:25:31.339Z';--> statement-breakpoint
ALTER TABLE "accounts" ALTER COLUMN "updated_at" SET DEFAULT '2025-03-11T08:25:31.339Z';--> statement-breakpoint
ALTER TABLE "transactions" ALTER COLUMN "transaction_date" SET DEFAULT '2025-03-11T08:25:31.340Z';--> statement-breakpoint
ALTER TABLE "transactions" ALTER COLUMN "created_at" SET DEFAULT '2025-03-11T08:25:31.340Z';--> statement-breakpoint
ALTER TABLE "transactions" ALTER COLUMN "updated_at" SET DEFAULT '2025-03-11T08:25:31.340Z';--> statement-breakpoint
ALTER TABLE "event_store" ADD CONSTRAINT "event_store_aggregate_id_accounts_id_fk" FOREIGN KEY ("aggregate_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "snapshots" ADD CONSTRAINT "snapshots_aggregate_id_accounts_id_fk" FOREIGN KEY ("aggregate_id") REFERENCES "public"."accounts"("id") ON DELETE cascade ON UPDATE no action;