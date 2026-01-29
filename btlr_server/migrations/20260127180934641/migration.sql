BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "activity_trackers" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "platform" text NOT NULL,
    "username" text NOT NULL,
    "lastSynced" timestamp without time zone,
    "activityData" text NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE INDEX "activity_tracker_user_idx" ON "activity_trackers" USING btree ("userId");
CREATE INDEX "activity_tracker_platform_idx" ON "activity_trackers" USING btree ("platform", "userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scraped_contents" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "platform" text NOT NULL,
    "title" text NOT NULL,
    "summary" text NOT NULL,
    "sourceUrl" text NOT NULL,
    "scrapedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isRead" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "scraped_contents_user_idx" ON "scraped_contents" USING btree ("userId");
CREATE INDEX "scraped_contents_platform_idx" ON "scraped_contents" USING btree ("platform");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_scraping_preferences" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "platform" text NOT NULL,
    "customUrl" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "user_scraping_user_idx" ON "user_scraping_preferences" USING btree ("userId");
CREATE INDEX "user_scraping_platform_idx" ON "user_scraping_preferences" USING btree ("platform", "userId");


--
-- MIGRATION VERSION FOR btlr
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('btlr', '20260127180934641', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127180934641', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
