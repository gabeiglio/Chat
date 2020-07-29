#Chat - a swifty way to chat

Chat is a native iOS application in which it combines many technologies and frameworks together to deliver a fast and efficient way to send and receives messages.

##Features:
    * Authentication with email
    * Send and receives text
    * Send and receive images
    * Send an receive voice notes
    * Spotlight search contacts
    * Customize profile settings
    * Homescreen quick actions
    * Save pictures to device
    * Light/Dark mode

##Technical:
    
    * For the backend I used Google Firebase services like Database, Auth, Storage to store and 
      observe data in the app.
    * Used UIKit to create all the user interface programatically, making full use of constraints.
    * For the app architecture I used MVC (Model View Controller)
    * Used asynchronous requests in order to download data (images mostly) in order to the UI not to freeze while
      donwloading the data.
