# Portfolio Website

A flutter app deployed as a website to showcase students' portfolios.

## Prerequisites

+ [Flutter](https://flutter.dev/docs/get-started/install)
+ [Firebase](https://firebase.google.com/docs/web/setup): More on setting up a project below.
+ [Firebase CLI](https://firebase.google.com/docs/cli)

## Building

### Visual Studio Code

Install the [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) extension.

Select a device by pressing `Ctrl + Shift + P` and typing `Flutter: Select Device`.
To run on a web browser, select `Chrome`.
Then, run the app by pressing `F5` or going to `Run > Start Debugging`.

### Command Line

Run the app on a web browser by running `flutter run -d chrome`.

### Create a Firebase project.

During the creation of the project, it will ask you if you want to enable Google Analytics.
This is optional, but a great way to view the usage of your website.
If you do enable Google Analytics, either add it to an existing account or create a new one.
We recommend unchecking the "Use default settings for sharing Google Analytics Data".
This will allow you to customize the data sharing settings (with Google) to your liking.
This is especially helpful to maintain GDPR compliance.

### Initialize Firebase and Add Flutter App

Enable web frameworks and hosting.

```
firebase experiments:enable webframeworks
firebase init hosting
```

Follow the prompts to initialize Firebase and add a Flutter app.

In the Firebase Console, you will need to add Authentication and Firestore.
To do this, navigate to "All Products" and select "Authentication".
Follow the steps to add Email/Password and any other authentication methods needed for the app.
Currently, the app supports Email/Password, Google, and Apple signins.
Next, navigate to "Cloud Firestore" and create a new database.
We also recommend enable "App Check" in the Firebase Console to protect your app from abuse.

## Contributing

Although this has been a project for the New Mexico State University Google Developer Student Club, we welcome contributions from anyone.
Create Pull Requests and Issues on [GitHub][1].

[1]: https://github.com/PrestonHager/Website
