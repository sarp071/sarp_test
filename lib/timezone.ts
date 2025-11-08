/**
 * Timezone Utilities
 * Handles timezone detection, conversion, and formatting for BabeCycle
 * All functions and comments in English
 */

import { format as formatDateFns, parseISO } from 'date-fns';
import { toZonedTime, fromZonedTime, format as formatTz } from 'date-fns-tz';

/**
 * Detects the user's timezone from the browser
 * @returns IANA timezone string (e.g., "America/New_York")
 */
export function detectUserTimezone(): string {
  try {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch {
    return 'UTC';
  }
}

/**
 * Converts a UTC date to user's timezone
 * @param date - Date object in UTC
 * @param targetTZ - Target timezone (IANA format)
 * @returns Date object in target timezone
 */
export function convertToUserTZ(date: Date, targetTZ: string): Date {
  return toZonedTime(date, targetTZ);
}

/**
 * Converts a local date to UTC
 * @param localDate - Date in user's local timezone
 * @param userTZ - User's timezone (IANA format)
 * @returns Date object in UTC
 */
export function normalizeToUTC(localDate: Date, userTZ: string): Date {
  return fromZonedTime(localDate, userTZ);
}

/**
 * Gets the timezone offset in minutes for a specific timezone
 * @param tz - Timezone (IANA format)
 * @returns Offset in minutes
 */
export function getTimezoneOffset(tz: string): number {
  const now = new Date();
  const utcDate = new Date(now.toLocaleString('en-US', { timeZone: 'UTC' }));
  const tzDate = new Date(now.toLocaleString('en-US', { timeZone: tz }));
  return (tzDate.getTime() - utcDate.getTime()) / 60000;
}

/**
 * Checks if a specific date is in Daylight Saving Time
 * @param date - Date to check
 * @param tz - Timezone (IANA format)
 * @returns true if in DST, false otherwise
 */
export function isDST(date: Date, tz: string): boolean {
  const jan = new Date(date.getFullYear(), 0, 1);
  const jul = new Date(date.getFullYear(), 6, 1);
  const janOffset = getTimezoneOffset(tz);
  const julOffset = getTimezoneOffset(tz);
  const currentOffset = getTimezoneOffset(tz);

  return Math.max(janOffset, julOffset) !== currentOffset;
}

/**
 * Schedules an event in user's timezone
 * Useful for notification scheduling
 * @param event - Event date/time in UTC
 * @param userTZ - User's timezone
 * @returns Scheduled date in user's timezone
 */
export function scheduleInUserTZ(event: Date, userTZ: string): Date {
  return convertToUserTZ(event, userTZ);
}

/**
 * Formats a date in a specific timezone
 * @param date - Date to format
 * @param tz - Target timezone
 * @param formatStr - Format string (date-fns format)
 * @returns Formatted date string
 */
export function formatInTZ(date: Date, tz: string, formatStr: string = 'yyyy-MM-dd HH:mm:ss zzz'): string {
  return formatTz(date, formatStr, { timeZone: tz });
}

/**
 * Converts a date string to user's timezone and formats it
 * @param dateString - ISO date string
 * @param tz - User's timezone
 * @param formatStr - Format string
 * @returns Formatted date in user's timezone
 */
export function formatDateInUserTZ(
  dateString: string,
  tz: string,
  formatStr: string = 'PPP'
): string {
  const date = parseISO(dateString);
  const zonedDate = convertToUserTZ(date, tz);
  return formatDateFns(zonedDate, formatStr);
}

/**
 * Gets the current date/time in user's timezone
 * @param tz - User's timezone
 * @returns Current date in user's timezone
 */
export function getCurrentTimeInTZ(tz: string): Date {
  return convertToUserTZ(new Date(), tz);
}

/**
 * Checks if a time is within quiet hours
 * @param time - Time to check (HH:MM format)
 * @param quietStart - Quiet hours start (HH:MM format)
 * @param quietEnd - Quiet hours end (HH:MM format)
 * @returns true if within quiet hours
 */
export function isWithinQuietHours(
  time: string,
  quietStart: string,
  quietEnd: string
): boolean {
  const [timeHour, timeMin] = time.split(':').map(Number);
  const [startHour, startMin] = quietStart.split(':').map(Number);
  const [endHour, endMin] = quietEnd.split(':').map(Number);

  const timeMinutes = timeHour * 60 + timeMin;
  const startMinutes = startHour * 60 + startMin;
  const endMinutes = endHour * 60 + endMin;

  // Handle overnight quiet hours (e.g., 22:00 to 08:00)
  if (startMinutes > endMinutes) {
    return timeMinutes >= startMinutes || timeMinutes <= endMinutes;
  }

  return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
}

/**
 * Gets the next available time outside quiet hours
 * @param currentTime - Current time (HH:MM)
 * @param quietStart - Quiet hours start
 * @param quietEnd - Quiet hours end
 * @returns Next available time outside quiet hours
 */
export function getNextAvailableTime(
  currentTime: string,
  quietStart: string,
  quietEnd: string
): string {
  if (!isWithinQuietHours(currentTime, quietStart, quietEnd)) {
    return currentTime;
  }

  // Return quiet end time if currently in quiet hours
  return quietEnd;
}

/**
 * Validates IANA timezone string
 * @param tz - Timezone to validate
 * @returns true if valid timezone
 */
export function isValidTimezone(tz: string): boolean {
  try {
    Intl.DateTimeFormat(undefined, { timeZone: tz });
    return true;
  } catch {
    return false;
  }
}

/**
 * Common timezones for quick selection
 */
export const COMMON_TIMEZONES = [
  { label: 'Eastern Time (US)', value: 'America/New_York' },
  { label: 'Central Time (US)', value: 'America/Chicago' },
  { label: 'Mountain Time (US)', value: 'America/Denver' },
  { label: 'Pacific Time (US)', value: 'America/Los_Angeles' },
  { label: 'London', value: 'Europe/London' },
  { label: 'Paris', value: 'Europe/Paris' },
  { label: 'Istanbul', value: 'Europe/Istanbul' },
  { label: 'Tokyo', value: 'Asia/Tokyo' },
  { label: 'Sydney', value: 'Australia/Sydney' },
  { label: 'UTC', value: 'UTC' },
] as const;
