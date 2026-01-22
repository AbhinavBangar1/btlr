BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "academic_schedule" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint NOT NULL,
    "title" text NOT NULL,
    "type" text NOT NULL,
    "location" text,
    "rrule" text,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "isRecurring" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "academic_schedule_student_idx" ON "academic_schedule" USING btree ("studentProfileId");
CREATE INDEX "academic_schedule_time_idx" ON "academic_schedule" USING btree ("startTime", "endTime");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "behavior_log" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint NOT NULL,
    "timeBlockId" bigint NOT NULL,
    "action" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actualDuration" bigint,
    "energyLevel" bigint,
    "notes" text,
    "reason" text,
    "context" text
);

-- Indexes
CREATE INDEX "behavior_log_student_idx" ON "behavior_log" USING btree ("studentProfileId");
CREATE INDEX "behavior_log_timeblock_idx" ON "behavior_log" USING btree ("timeBlockId");
CREATE INDEX "behavior_log_timestamp_idx" ON "behavior_log" USING btree ("timestamp");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "daily_plan" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint NOT NULL,
    "planDate" timestamp without time zone NOT NULL,
    "version" bigint NOT NULL DEFAULT 1,
    "reasoning" text,
    "totalPlannedMinutes" bigint NOT NULL DEFAULT 0,
    "generatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "adaptationNotes" text
);

-- Indexes
CREATE UNIQUE INDEX "daily_plan_student_date_idx" ON "daily_plan" USING btree ("studentProfileId", "planDate");
CREATE INDEX "daily_plan_date_idx" ON "daily_plan" USING btree ("planDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "learning_goal" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "category" text NOT NULL,
    "priority" text NOT NULL DEFAULT 'medium'::text,
    "status" text NOT NULL DEFAULT 'not_started'::text,
    "estimatedHours" double precision,
    "actualHours" double precision NOT NULL DEFAULT 0.0,
    "deadline" timestamp without time zone,
    "tags" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "learning_goal_student_idx" ON "learning_goal" USING btree ("studentProfileId");
CREATE INDEX "learning_goal_status_idx" ON "learning_goal" USING btree ("status");
CREATE INDEX "learning_goal_deadline_idx" ON "learning_goal" USING btree ("deadline");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "opportunity" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint,
    "title" text NOT NULL,
    "type" text NOT NULL,
    "description" text,
    "organization" text,
    "sourceUrl" text,
    "deadline" timestamp without time zone,
    "tags" text,
    "relevanceScore" double precision NOT NULL DEFAULT 0.0,
    "status" text NOT NULL DEFAULT 'discovered'::text,
    "prepTimeMinutes" bigint,
    "appliedAt" timestamp without time zone,
    "discoveredAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "opportunity_student_idx" ON "opportunity" USING btree ("studentProfileId");
CREATE INDEX "opportunity_deadline_idx" ON "opportunity" USING btree ("deadline");
CREATE INDEX "opportunity_status_idx" ON "opportunity" USING btree ("status");
CREATE INDEX "opportunity_type_idx" ON "opportunity" USING btree ("type");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student_profile" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "timezone" text NOT NULL DEFAULT 'UTC'::text,
    "wakeTime" text NOT NULL,
    "sleepTime" text NOT NULL,
    "preferredStudyBlockMinutes" bigint NOT NULL DEFAULT 50,
    "preferredBreakMinutes" bigint NOT NULL DEFAULT 10,
    "preferredStudyTimes" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "student_profile_email_idx" ON "student_profile" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "time_block" (
    "id" bigserial PRIMARY KEY,
    "dailyPlanId" bigint NOT NULL,
    "learningGoalId" bigint,
    "academicScheduleId" bigint,
    "title" text NOT NULL,
    "description" text,
    "blockType" text NOT NULL,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "durationMinutes" bigint NOT NULL,
    "isCompleted" boolean NOT NULL DEFAULT false,
    "completionStatus" text NOT NULL DEFAULT 'pending'::text,
    "actualDurationMinutes" bigint,
    "energyLevel" bigint,
    "notes" text,
    "missReason" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "time_block_plan_idx" ON "time_block" USING btree ("dailyPlanId");
CREATE INDEX "time_block_goal_idx" ON "time_block" USING btree ("learningGoalId");
CREATE INDEX "time_block_time_idx" ON "time_block" USING btree ("startTime", "endTime");
CREATE INDEX "time_block_completion_idx" ON "time_block" USING btree ("completionStatus");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "voice_note" (
    "id" bigserial PRIMARY KEY,
    "studentProfileId" bigint NOT NULL,
    "learningGoalId" bigint,
    "transcription" text NOT NULL,
    "originalAudioUrl" text,
    "recordedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration" bigint,
    "tags" text,
    "sentiment" text,
    "category" text,
    "searchableContent" text
);

-- Indexes
CREATE INDEX "voice_note_student_idx" ON "voice_note" USING btree ("studentProfileId");
CREATE INDEX "voice_note_goal_idx" ON "voice_note" USING btree ("learningGoalId");
CREATE INDEX "voice_note_recorded_idx" ON "voice_note" USING btree ("recordedAt");


--
-- MIGRATION VERSION FOR btlr
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('btlr', '20260121100505944', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260121100505944', "timestamp" = now();

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
