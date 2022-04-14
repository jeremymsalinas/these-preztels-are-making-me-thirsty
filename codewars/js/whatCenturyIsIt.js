/*
Return the century of the input year. The input will always be a 4 digit string, so there is no need for validation.

Examples
"1999" --> "20th"
"2011" --> "21st"
"2154" --> "22nd"
"2259" --> "23rd"
"1124" --> "12th"
"2000" --> "20th"
*/

function whatCentury(year) {
    const preTeenths = {
        0: 'th',
        1: 'th',
        2: 'th',
        3: 'th',
        4: 'th',
        5: 'th',
        6: 'th',
        7: 'th',
        8: 'th',
        9: 'th'
    }
    const everythingElse = {
        0: 'th',
        1: 'st',
        2: 'nd',
        3: 'rd',
        4: 'th',
        5: 'th',
        6: 'th',
        7: 'th',
        8: 'th',
        9: 'th'
    }
    if (Number(year <= 1901)) {
        return String(Number(year.slice(0, 2)) + 1) + preTeenths[Number(year.slice(1, 2)) + 1]
    } else {
        if (Number(year.slice(1, 2)) + 1 > 9) {
            console.log(Number(year.slice(1, 3)))
            return String(Number(year.slice(0, 2)) + 1) + everythingElse[0]
        } else if (Number(year.slice(1)) === 0) {
            return String(Number(year.slice(0, 2))) + everythingElse[0]
        } else {
            console.log(Number(year.slice(1, 2)))
            return String(Number(year.slice(0, 2)) + 1) + everythingElse[Number(year.slice(1, 2)) + 1]
        }
    }

}