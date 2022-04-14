/*
Your task in order to complete this Kata is to write a function which formats a duration, given as a number of seconds, in a human-friendly way.

The function must accept a non-negative integer. If it is zero, it just returns "now". Otherwise, the duration is expressed as a combination of years, days, hours, minutes and seconds.

It is much easier to understand with an example:

* For seconds = 62, your function should return 
    "1 minute and 2 seconds"
* For seconds = 3662, your function should return
    "1 hour, 1 minute and 2 seconds"
For the purpose of this Kata, a year is 365 days and a day is 24 hours.
*/

function formatDuration(seconds) {
    // Complete this function
    let yearStr = ''
    let dayStr = ''
    let hourStr = ''
    let minuteStr = ''
    let secondStr = ''
    let durationArr = []

    var years = Math.floor(seconds / (24 * 365 * 3600))
    seconds = seconds % (24 * 365 * 3600)

    if (years === 1) {
        yearStr = years + ' year'
        durationArr.push(yearStr)
    } else if (years > 1) {
        yearStr = years + ' years'
        durationArr.push(yearStr)
    }

    var days = Math.floor(seconds / (24 * 3600));
    seconds = seconds % (24 * 3600);

    if (days === 1) {
        dayStr = days + ' day'
        durationArr.push(dayStr)
    } else if (days > 1) {
        dayStr = days + ' days'
        durationArr.push(dayStr)
    }

    var hours = Math.floor(seconds / 3600);
    seconds %= 3600;

    if (hours === 1) {
        hourStr = hours + ' hour'
        durationArr.push(hourStr)
    } else if (hours > 1) {
        hourStr = hours + ' hours'
        durationArr.push(hourStr)
    }

    var minutes = Math.floor(seconds / 60);
    seconds %= 60;
    if (minutes === 1) {
        minuteStr = minutes + ' minute'
        durationArr.push(minuteStr)
    } else if (minutes > 1) {
        minuteStr = minutes + ' minutes'
        durationArr.push(minuteStr)
    }


    var seconds = seconds;

    if (seconds === 1) {
        secondStr = seconds + ' second'
        durationArr.push(secondStr)
    } else if (seconds > 1) {
        secondStr = seconds + ' seconds'
        durationArr.push(secondStr)
    }

    if (durationArr.length === 1) {
        return durationArr[0]
    } else if (durationArr.length === 2) {
        return durationArr.join(' and ')
    } else if (durationArr.length > 2) {
        let lastElements = durationArr[durationArr.length - 2] + ' and ' + durationArr[durationArr.length - 1]
        return durationArr.slice(0, durationArr.length - 2).join(', ') + ', ' + lastElements
    } else {
        return 'now'
    }
}