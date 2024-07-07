# ToDoBuddy
  ToDoBuddy is a Flutter application designed to help users manage their tasks efficiently. It utilizes GetX architecture with MVVM pattern for streamlined state management and modular code structure.

Features:

1. Task Management:

-Create, edit, and delete tasks.
-View task details including title, description, priority level, due date, and creation date.
-Mark tasks as complete with visual indicators.

2. User Interface

- Task list displayed in a card format.
- Responsive UI with intuitive interactions using Flutter widgets.
- Filtering tasks by priority level, due date, and creation date.

3. Add Task Screen:

-Validate input fields to ensure no empty fields.
-Display green snackbar upon successful task addition.
-Push notification confirmation upon task addition.

4. Search and Live Search:

-Search tasks based on title and description.
-Live search functionality for real-time results.

5. Task Updates and Deletion:

-Update task details with validation checks.
-Confirmation popup for task deletion to prevent accidental removal.

6. Enhanced User Engagement:

-Reminder popup to encourage task completion.
-Visual cues such as color changes and notifications for task updates and completions.

7. Architecture and Design
-GetX Architecture: Utilizes controllers for state management, dependency injection, and efficient navigation.
-MVVM Pattern: Separates business logic (ViewModels) from UI components (View), promoting code reusability and maintainability.