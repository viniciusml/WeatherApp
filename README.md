
# WeatherApp

[![Build Status](https://travis-ci.com/viniciusml/WeatherApp.svg?branch=master)](https://travis-ci.com/viniciusml/WeatherApp)

> An application that collects the current temperature information from '[Open Weather Map](http://openweathermap.org)' for the current location and displays current temperature (ºC) and weather.

> Developed following TDD methodology.

## Location Use Case

### Precondition:

-   User authorisation to share location.

### Primary course (happy path):

1.  Request user authorisation to use their position.
2.  Execute "Get Current Location" command with after being authorized.
3.  System fetches coordinates (latitude and longitude).
4.  System delivers location.

### Unauthorized – error course (sad path):

1.  System delivers error.

### Device unable to gather location – error course (sad path):

1.  System delivers error.

## Current Weather Loader Use Case

### Data (Input):

-  URL
-  User's current coordinates

### Primary course (happy path):

1.  Execute "Load" Current Weather" command with above data.
2.  System downloads data from the URL.
3.  System decodes downloaded data.
4.  System creates weather item from valid data.
5.  System delivers weather item.

### Invalid data – error course (sad path):

1.  System delivers error.

### No connectivity – error course (sad path):

1.  System delivers error.
