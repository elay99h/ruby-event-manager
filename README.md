Event Manager

This Ruby script utilizes CSV parsing, Google Civic Information API, and ERB templates to manage event attendee data. The program reads event attendee information from a CSV file, processes and cleans the data, generates personalized thank-you letters, and identifies insights such as peak registration hours and days

**Features:**

* **CSV Processing:** Read and process event attendee data from a CSV file.
* **Google Civic Information API:** Fetch legislators based on attendee ZIP codes using the Google Civic Information API.
* **ERB Templates:** Generate personalized thank-you letters using ERB templates.
* **Data Analysis:**
   * Identify peak registration hours.
   * Determine the days with the most registrations.

**Usage:**

1. Place the event attendee CSV file in the specified location.
2. Run the script to process the data and generate personalized thank-you letters.
3. Obtain insights into peak registration hours and days with the most registrations.

**Dependencies:**

* Ruby
* Google Civic Information API key

**How to Run:**

ruby event_manager.rb
