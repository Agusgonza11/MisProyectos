export enum Genre {
    FICTION = 'FICTION',
    NON_FICTION = 'NON_FICTION',
    MYSTERY = 'MYSTERY',
    FANTASY = 'FANTASY',
    SCIENCE_FICTION = 'SCIENCE_FICTION',
    BIOGRAPHY = 'BIOGRAPHY',
    HISTORY = 'HISTORY',
    ROMANCE = 'ROMANCE',
    HORROR = 'HORROR',
    SELF_HELP = 'SELF_HELP',
    POETRY = 'POETRY',
    THRILLER = 'THRILLER',
    YOUNG_ADULT = 'YOUNG_ADULT',
    CHILDRENS = 'CHILDRENS',
    CLASSIC = 'CLASSIC',
    GRAPHIC_NOVEL = 'GRAPHIC_NOVEL',
    ADVENTURE = 'ADVENTURE',
    RELIGION = 'RELIGION',
    SCIENCE = 'SCIENCE',
    ART = 'ART',
    PHILOSOPHY = 'PHILOSOPHY',
    COOKING = 'COOKING',
    TRAVEL = 'TRAVEL',
    BUSINESS = 'BUSINESS',
    SPORTS = 'SPORTS'
}

// Dictionary with Spanish translations in capital case
const genreTranslations: Record<Genre, string> = {
    [Genre.FICTION]: 'Ficción',
    [Genre.NON_FICTION]: 'No Ficción',
    [Genre.MYSTERY]: 'Misterio',
    [Genre.FANTASY]: 'Fantasía',
    [Genre.SCIENCE_FICTION]: 'Ciencia Ficción',
    [Genre.BIOGRAPHY]: 'Biografía',
    [Genre.HISTORY]: 'Historia',
    [Genre.ROMANCE]: 'Romance',
    [Genre.HORROR]: 'Terror',
    [Genre.SELF_HELP]: 'Autoayuda',
    [Genre.POETRY]: 'Poesía',
    [Genre.THRILLER]: 'Thriller',
    [Genre.YOUNG_ADULT]: 'Juvenil',
    [Genre.CHILDRENS]: 'Infantil',
    [Genre.CLASSIC]: 'Clásico',
    [Genre.GRAPHIC_NOVEL]: 'Novela Gráfica',
    [Genre.ADVENTURE]: 'Aventura',
    [Genre.RELIGION]: 'Religión',
    [Genre.SCIENCE]: 'Ciencia',
    [Genre.ART]: 'Artes',
    [Genre.PHILOSOPHY]: 'Filosofía',
    [Genre.COOKING]: 'Cocina',
    [Genre.TRAVEL]: 'Viajes',
    [Genre.BUSINESS]: 'Negocios',
    [Genre.SPORTS]: 'Deportes'
};
export function transformGenre(genre: string): string {
    return genreTranslations[genre as Genre];
}

export function formatIsoDate(isoDate: string): string {
    // Create a Date object from the ISO string
    const date = new Date(isoDate);

    // Check if the date is valid
    if (isNaN(date.getTime())) {
        throw new Error("Invalid ISO date format");
    }

    // Define options for the date formatting
    const options: Intl.DateTimeFormatOptions = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
    };

    // Format the date using the options
    return date.toLocaleDateString('es-AR', options);
}