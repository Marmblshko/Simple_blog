# Simple Blog

Simple Blog is a straightforward blogging platform built on Ruby on Rails. It allows users to create, view, edit, and delete posts, as well as interact with other users through comments. The project consists of three main controllers and corresponding models: `CommentsController`, `ContactsController`, and `PostsController`, each serving a distinct purpose in managing the different aspects of the blog.

## Table of Contents

- [Overview](#overview)
- [Controllers](#controllers)
- [Models](#models)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

Simple Blog provides a user-friendly interface for creating and managing blog posts. Users can register, log in, and start sharing their thoughts with the community. The platform also supports user comments, enabling discussions around each post. Additionally, there's a contact form for users to reach out with any inquiries or feedback.

## Controllers

### CommentsController

- Handles the creation and deletion of comments on posts.
- Requires user authentication for certain actions.

### ContactsController

- Manages user contacts, allowing them to submit new contacts.

### PostsController

- Handles CRUD operations for posts.
- Requires user authentication for creating new posts.

## Models

### User

- Represents a user in the system.

### Comment

- Represents a comment associated with a post.

### Contact

- Represents user contacts with email and message fields.
## Upcoming Features

- **Styling and Theming:** Introduce a visually appealing design to enhance the user experience.

- **Likes for Posts and Comments:** Allow users to express their appreciation for posts and comments by adding a like feature.

- **Profile Section:** Move user profiles to a dedicated section, providing a comprehensive view of each user's activity.

## Usage

To use Simple Blog, follow these steps:

1. Clone the repository.
2. Run `bundle install` to install dependencies.
3. Set up the database with `rails db:migrate`.
4. Start the server with `rails server`.
5. Navigate to `http://localhost:3000` in your browser.

## Contributing

We welcome contributions! Feel free to fork the repository, make your changes, and submit a pull request. Please adhere to our coding standards, and check the issue tracker for any specific tasks or features that need attention.

## License

This project is licensed under the [MIT License](LICENSE).