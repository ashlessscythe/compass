-- Sync protocol v0: per-user inventory replica (not waitlist).

CREATE TABLE "sync_users" (
    "id" UUID NOT NULL,
    "apple_sub" TEXT,
    "dev_key" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_users_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "sync_users_apple_sub_key" ON "sync_users"("apple_sub");
CREATE UNIQUE INDEX "sync_users_dev_key_key" ON "sync_users"("dev_key");

CREATE TABLE "sync_sessions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sync_sessions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "sync_sessions_token_hash_key" ON "sync_sessions"("token_hash");
CREATE INDEX "sync_sessions_user_id_idx" ON "sync_sessions"("user_id");

CREATE TABLE "sync_locations" (
    "user_id" UUID NOT NULL,
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "parent_location_id" TEXT,
    "path" TEXT,
    "nfc_tag_id" TEXT,
    "notes" TEXT,
    "metadata_json" TEXT NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_locations_pkey" PRIMARY KEY ("user_id","id")
);

CREATE INDEX "sync_locations_user_id_updated_at_idx" ON "sync_locations"("user_id", "updated_at");

CREATE TABLE "sync_containers" (
    "user_id" UUID NOT NULL,
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "parent_container_id" TEXT,
    "location_id" TEXT,
    "nfc_tag_id" TEXT,
    "notes" TEXT,
    "metadata_json" TEXT NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_containers_pkey" PRIMARY KEY ("user_id","id")
);

CREATE INDEX "sync_containers_user_id_updated_at_idx" ON "sync_containers"("user_id", "updated_at");

CREATE TABLE "sync_assets" (
    "user_id" UUID NOT NULL,
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "asset_type_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "container_id" TEXT,
    "location_id" TEXT,
    "notes" TEXT,
    "metadata_json" TEXT NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_assets_pkey" PRIMARY KEY ("user_id","id")
);

CREATE INDEX "sync_assets_user_id_updated_at_idx" ON "sync_assets"("user_id", "updated_at");

CREATE TABLE "sync_asset_types" (
    "user_id" UUID NOT NULL,
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "module_id" TEXT NOT NULL,
    "parent_id" TEXT,
    "description" TEXT,
    "metadata_json" TEXT NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_asset_types_pkey" PRIMARY KEY ("user_id","id")
);

CREATE INDEX "sync_asset_types_user_id_updated_at_idx" ON "sync_asset_types"("user_id", "updated_at");

CREATE TABLE "sync_tombstones" (
    "user_id" UUID NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_tombstones_pkey" PRIMARY KEY ("user_id","entity_type","entity_id")
);

CREATE INDEX "sync_tombstones_user_id_deleted_at_idx" ON "sync_tombstones"("user_id", "deleted_at");

ALTER TABLE "sync_sessions" ADD CONSTRAINT "sync_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sync_locations" ADD CONSTRAINT "sync_locations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sync_containers" ADD CONSTRAINT "sync_containers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sync_assets" ADD CONSTRAINT "sync_assets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sync_asset_types" ADD CONSTRAINT "sync_asset_types_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sync_tombstones" ADD CONSTRAINT "sync_tombstones_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "sync_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
