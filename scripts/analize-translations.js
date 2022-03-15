#!/usr/local/bin/node

const fs = require('fs');
console.log(__dirname);

const locales = ['es', 'en', 'ca'];
const getTranslationPath = (locale) => `i18n/${locale}.json`;

const translationsPerLocale = {};
const metadataPerLocale = {};

for (let locale of locales) {
    translationsPerLocale[locale] = JSON.parse(fs.readFileSync(getTranslationPath(locale)).toString());
    metadataPerLocale[locale] = {
        totalLines: Object.keys(translationsPerLocale[locale]).length,
    };
}

let countPerKeyPerLocale = {};

for (let locale of locales) {
    const translations = translationsPerLocale[locale];

    for (let key in translations) {
        if (!countPerKeyPerLocale[key]) {
            countPerKeyPerLocale[key] = {
                [locale]: 1,
                total: 1,
            };
        } else {
            countPerKeyPerLocale[key][locale] = 1;
            countPerKeyPerLocale[key].total += 1;
        }
    }
}

let missingTranslations = {};
for (let key in countPerKeyPerLocale) {
    if (countPerKeyPerLocale[key] && countPerKeyPerLocale[key].total != locales.length) {
        missingTranslations[key] = {
            locales: [
                !countPerKeyPerLocale[key].es ? 'es' : null,
                !countPerKeyPerLocale[key].ca ? 'ca' : null,
                !countPerKeyPerLocale[key].en ? 'en' : null,
            ].filter(_ => _),
        };
    }
}


console.table(metadataPerLocale);

console.log('Missing translations');
const totalMissingTranslations = Object.keys(missingTranslations).length;
if (totalMissingTranslations) console.log(missingTranslations);
console.log(`Total: ${totalMissingTranslations}`);

