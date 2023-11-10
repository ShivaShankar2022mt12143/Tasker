Set Up Back4App
1. Sign Up for Back4App
If you do not have a Back4App account, please sign up by visiting Back4App Sign Up.

2. Create a New Back4App App
Once logged in, create a new Back4App app by navigating to the Dashboard and clicking on "Create a New App."

3. Create a Task Class
Within your Back4App app, create a class named Task with the following columns:

title (Type: String)
description (Type: String)
Flutter Setup
Download fultter and install in your system
1. Create a New Flutter Project
Initialize a new Flutter project using the following command:

flutter create Tasker
2. Add Dependencies to pubspec.yaml
In your pubspec.yaml file, add the necessary dependencies for Flutter and Parse SDK:

dependencies:
  flutter:
    sdk: flutter
  parse_server_sdk: ^7.0.0
Run flutter pub get to fetch the dependencies.

3. Initialize Parse SDK
In your main.dart or wherever you initialize your app, configure Parse SDK with your Back4App credentials:

import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  await Parse().initialize(
    'your_application_id',
    'https://parseapi.back4app.com/',
    clientKey: 'your_client_key',
    autoSendSessionId: true,
    debug: true,
  );
}
Task List
1. Create Task List Screen
Design a screen to display a list of tasks in your Flutter app.

2. Fetch Tasks from Back4App
Implement a function to fetch tasks from Back4App using the Parse SDK.

3. Display Tasks in List View
Utilize a list view to display tasks with their titles and descriptions.

Task Creation
1. Create Add Task Screen
Develop a screen for adding new tasks to your app.

2. Implement Task Creation
Implement functionality to create and save tasks to Back4App when the user adds a new task.

3. Verify Task Creation
Ensure that newly created tasks dynamically appear in the task list.

Task Details
1. View Task Details Screen
Add a feature that allows users to view detailed information when tapping on a task in the list.

2. Display Task Details
Display the title and description of the selected task in the details screen.

Task Search
1. Create a search function that queries the back4app and finds the task


To run the application 
flutter run
