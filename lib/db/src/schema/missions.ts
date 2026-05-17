import { pgTable, text, serial, timestamp } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod/v4";

export const missionsTable = pgTable("missions", {
  id: serial("id").primaryKey(),
  discordUserId: text("discord_user_id").notNull(),
  username: text("username").notNull(),
  lieu: text("lieu").notNull(),
  pilote: text("pilote").notNull(),
  date: text("date").notNull(),
  notes: text("notes"),
  guildId: text("guild_id"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

export const insertMissionSchema = createInsertSchema(missionsTable).omit({
  id: true,
  createdAt: true,
});

export type InsertMission = z.infer<typeof insertMissionSchema>;
export type Mission = typeof missionsTable.$inferSelect;
