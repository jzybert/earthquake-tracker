# Project Submission Document
## Meta
### Our team
- Juan Lopez (lopez.ju@husky.neu.edu)
- Jonathan Zybert (zybert.j@husky.neu.edu)

### Deployment URL
https://earthquake.jonathanzybert.com

### GitHub URL
https://github.com/jzybert/earthquake-tracker

### Deployment Status
Not Deployed

### Completion Status
Completed

### Team Contributions
- Juan Lopez
  - Google Maps API
  - Tracked areas for users
  - News API w/ channel updates
- Jonathan Zybert
  - USGS API
  - User registration
  - Emails/email automation for tracked areas

## App
### What does our app do?
Our app is an earthquake tracker. Using the USGS API to retrieve earthquake 
data from around the world as well as the Google Maps API to display dropped 
pins for each earthquake, users can register on our site, query earthquakes, 
and save areas to track.

### How can users interact with our app?
The first thing that a user can do is register an account using an email and 
password. We use a secure method of storing passwords so users can be 
confident their information won't be taken. Once a user is logged in, 
they will be able to query earthquake data on the home page. They can enter 
a date range, location, and magnitude. The USGS API is then queried and the 
results are displayed in a table with information for each earthquake. Each 
earthquake also appears as a pin on a Google Map.

Users also have the ability to track specific queries. They enter information 
as before and can save it to their "Tracked Area" page. Users will be able to 
quickly view their areas for earthquakes within the last day. If a user 
chooses, they can opt-in to get email notifications about those areas. Once 
a day, the server will email their user email address with a table of their 
tracked area queries.

### How does our final app differ from our proposal?
One aspect of our project that differs from the proposal is our authenticated 
API. We chose to authenticate our app with a earthquake news API. We'd get 
real-time news and, using Phoenix channels, display that news to users.

Another difference is users can have multiple tracked areas which display 
information whenever they click on it's name - the server no longer 
periodically contacts the USGS API.

### How well did we execute our app idea?
Our application was executed very well. We achieved everything we wanted to 
achieve and more. Overall, we have a very comprehensive app which could be 
valuable to those who have a need to view earthquake information quickly 
and efficiently.

### Project requirements?
#### In general, this application should be significantly more ambitious and have more features and functions than either the memory game or the task tracker app.
Our application is much more ambitious than the previous homework assignments. 
Not only do we have forms for user's to enter data and multiple databases like 
the previous homework, but we've incorporated email, multiple APIs, and 
live updates to users for earthquake news.

#### The server-side logic of your app must be built using Elixir / Phoenix.
All of our server-side logic is built in Elixir / Phoenix.

#### Your application must have significant server-side logic.
Our server-side logic is significant in that it builds complicated URLs to 
query USGS, it builds Google Maps with complicated data with lots of data 
points, it automates sending daily emails to users, and handles user 
registration with passwords.

#### Your app must be deployed to the VPS of one or more members of your team.
It is deployed to our VPSs.

#### If you can self-host things on your VPS, you should.
The majority of our application is self-hosted on our VPS. The only thing 
that isn't is SMTP server for which we're using Mailjet.

#### Your application should have user accounts, and should support local password authentication (implemented securely).
Users are able to register accounts with passwords stored in the user 
database. We are using the correct and secure password authentication 
methods that we learned in class.

#### Users should be stored in a Postgres database, along with some other persistent state.
Users are stored in a Postgres database. We also stored tracked areas for 
earthquake areas which are associated with a user.

#### Your application should use an external API that requires authentication of your app, your app's user, or both.
Our application authenticates with a news API which we use to display 
earthquake data to users.

#### Any API access should be server <-> server. Your browser code should only make requests to your server, not remote APIs.
We use two APIs that achieve this. The first is the USGS Earthquake 
Catalog API which we get earthquake data from for user queries. The second 
is a Google Maps API which we display pins with earthquake information.

#### Your application should use Phoenix Channels to push real-time updates to users, triggered either from an external API or from actions by other concurrent users.
Our application uses Phoenix Channels to send real-time updates to users about 
earthquake news which we get from the news API.

### Interesting features beyond requirements
One interesting feature not needed in the requirements is our periodic 
emails. Users can opt-in to email notifications. If opted-in, they will 
receive a daily email with any new earthquakes the occurred within the last 
day for each of their tracked area.

### Which part of our app is complex? How was it designed?

### Most significant challenge?