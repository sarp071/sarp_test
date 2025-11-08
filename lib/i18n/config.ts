/**
 * i18n Configuration
 * Internationalization settings for BabeCycle
 * Default locale: English (en)
 */

export const i18n = {
  defaultLocale: 'en',
  locales: ['en', 'tr', 'es', 'fr', 'ar'],
  localeDetection: true,
  rtlLocales: ['ar'], // Right-to-left languages
} as const;

export type Locale = (typeof i18n.locales)[number];

/**
 * Locale metadata for display
 */
export const LOCALE_INFO: Record<Locale, { name: string; nativeName: string; flag: string }> = {
  en: {
    name: 'English',
    nativeName: 'English',
    flag: '🇺🇸',
  },
  tr: {
    name: 'Turkish',
    nativeName: 'Türkçe',
    flag: '🇹🇷',
  },
  es: {
    name: 'Spanish',
    nativeName: 'Español',
    flag: '🇪🇸',
  },
  fr: {
    name: 'French',
    nativeName: 'Français',
    flag: '🇫🇷',
  },
  ar: {
    name: 'Arabic',
    nativeName: 'العربية',
    flag: '🇸🇦',
  },
};

/**
 * Check if locale is RTL (right-to-left)
 */
export function isRTL(locale: Locale): boolean {
  return (i18n.rtlLocales as readonly string[]).includes(locale);
}

/**
 * Get text direction for locale
 */
export function getDirection(locale: Locale): 'ltr' | 'rtl' {
  return isRTL(locale) ? 'rtl' : 'ltr';
}

/**
 * Validate if string is a supported locale
 */
export function isValidLocale(locale: string): locale is Locale {
  return i18n.locales.includes(locale as Locale);
}
