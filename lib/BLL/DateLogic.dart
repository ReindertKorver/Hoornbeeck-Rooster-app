class DateLogic{
 getWeekOfYearFromDate(DateTime date){
   // get today's date
   var currentDate = date;

   // set it to feb 10th for testing
   //now = now.add(new Duration(days:7));

   int today = currentDate.weekday;

   // ISO week date weeks start on monday
   // so correct the day number
   var dayNr = (today + 6) % 7;

   // ISO 8601 states that week 1 is the week
   // with the first thursday of that year.
   // Set the target date to the thursday in the target week
   var thisMonday = currentDate.subtract(new Duration(days:(dayNr)));
   var thisThursday = thisMonday.add(new Duration(days:3));

   // Set the target to the first thursday of the year
   // First set the target to january first
   var firstThursday = new DateTime(currentDate.year, DateTime.JANUARY, 1);

   if(firstThursday.weekday != (DateTime.THURSDAY))
   {
     firstThursday = new DateTime(currentDate.year, DateTime.JANUARY, 1 + ((4 - firstThursday.weekday) + 7) % 7);
   }

   // The weeknumber is the number of weeks between the
   // first thursday of the year and the thursday in the target week
   var x = thisThursday.millisecondsSinceEpoch - firstThursday.millisecondsSinceEpoch;
   var weekNumber = x.ceil() / 604800000; // 604800000 = 7 * 24 * 3600 * 1000

   print("Todays date: ${currentDate}");
   print("Monday of this week: ${thisMonday}");
   print("Thursday of this week: ${thisThursday}");
   print("First Thursday of this year: ${firstThursday}");
   print("This week is week #${weekNumber.ceil()}");
   return weekNumber.ceil();
 }

}