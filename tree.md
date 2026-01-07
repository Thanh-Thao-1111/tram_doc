# Trạm Đọc - Project Structure

```
lib/
├── main.dart                           # Entry point
├── firebase_options.dart               # Firebase configuration
│
├── core/
│   └── assets/
│       └── app_images.dart             # Image asset constants
│
├── models/
│   ├── book_model.dart                 # Book data model
│   ├── card_model.dart                 # Flashcard data model
│   ├── comment_model.dart              # Comment data model
│   ├── community_post_model.dart       # Community post data model
│   ├── friend_model.dart               # Friend data model
│   ├── note_model.dart                 # Note data model
│   ├── review_model.dart               # Review data model
│   └── user_profile.dart               # User profile data model
│
├── repositories/
│   ├── auth_repository.dart            # Authentication repository
│   ├── book_repository.dart            # Book CRUD operations
│   └── card_repository.dart            # Flashcard repository
│
├── services/
│   ├── community_service.dart          # Community posts service
│   ├── friend_service.dart             # Friend management service
│   ├── google_books_service.dart       # Google Books API service
│   ├── notification_settings_service.dart  # Notification settings
│   ├── profile_service.dart            # User profile service
│   └── stats_service.dart              # Reading statistics service
│
├── viewmodels/
│   ├── community_viewmodel.dart        # Community state management
│   ├── home_viewmodel.dart             # Home page state management
│   ├── library_viewmodel.dart          # Library state management
│   ├── main_viewmodel.dart             # Main navigation state
│   ├── profile_viewmodel.dart          # Profile state management
│   └── review_viewmodel.dart           # Review/flashcard state
│
└── views/
    ├── main_page.dart                  # Main navigation with bottom bar
    ├── forgot_password_page.dart       # Forgot password page
    │
    ├── books/
    │   ├── add_book_page.dart          # Add book main page
    │   └── pages/
    │       ├── add_book_search_page.dart   # Search books to add
    │       ├── add_bookshelf_page.dart     # Add bookshelf
    │       ├── book_address_page.dart      # Book location/address
    │       └── scan_pr_page.dart           # Scan barcode page
    │
    ├── community/
    │   ├── community_page.dart         # Community wrapper
    │   ├── pages/
    │   │   ├── comments_page.dart          # Post comments page
    │   │   ├── community_feed_tab.dart     # Feed tab
    │   │   ├── community_friends_tab.dart  # Friends tab
    │   │   ├── community_page.dart         # Main community page
    │   │   ├── community_suggest_tab.dart  # Suggestions tab
    │   │   └── friend_profile_page.dart    # Friend profile page
    │   └── widgets/
    │       ├── add_friend_dialog.dart      # Add friend dialog
    │       ├── community_tokens.dart       # Design tokens
    │       ├── friend_request_tile.dart    # Friend request item
    │       ├── friend_tile.dart            # Friend list item
    │       ├── post_card.dart              # Post card widget
    │       ├── stat_tile.dart              # Statistics tile
    │       ├── suggestion_card.dart        # Book suggestion card
    │       └── user_book_grid.dart         # User books grid
    │
    ├── homes/
    │   ├── home_page.dart              # Home page
    │   └── pages/
    │       ├── forgot_password_page.dart   # Forgot password
    │       ├── login_page.dart             # Login page
    │       ├── notification_page.dart      # Notifications page
    │       ├── signup_page.dart            # Sign up page
    │       └── welcome_page.dart           # Welcome/onboarding page
    │
    ├── library/
    │   ├── library_page.dart           # Library main page
    │   ├── pages/
    │   │   ├── add_note_page.dart          # Add/edit note page
    │   │   ├── book_detail_page.dart       # Book detail page
    │   │   ├── create_flashcard_page.dart  # Create flashcard
    │   │   ├── ocr_capture_page.dart       # OCR capture page
    │   │   └── review_book_page.dart       # Write book review
    │   └── widgets/
    │       ├── flashcard_item.dart         # Flashcard item widget
    │       ├── library_book_item.dart      # Library book item
    │       ├── library_tab_bar.dart        # Library tab bar
    │       ├── note_item.dart              # Note item widget
    │       └── rating_star.dart            # Rating stars widget
    │
    ├── profile/
    │   ├── profile_page.dart           # Profile wrapper
    │   ├── pages/
    │   │   ├── account_page.dart           # Account settings
    │   │   ├── appearance_page.dart        # Appearance settings
    │   │   ├── edit_profile_page.dart      # Edit profile page
    │   │   ├── help_support_page.dart      # Help & support
    │   │   ├── notification_settings_page.dart  # Notification settings
    │   │   ├── profile_page.dart           # Main profile page
    │   │   └── stats_page.dart             # Reading statistics
    │   └── widgets/
    │       ├── danger_tile.dart            # Danger action tile
    │       ├── metric_card.dart            # Metric display card
    │       ├── profile_header.dart         # Profile header
    │       ├── profile_tokens.dart         # Profile design tokens
    │       ├── section_title.dart          # Section title widget
    │       └── setting_tile.dart           # Settings tile
    │
    └── review/
        ├── review_page.dart            # Review/study main page
        ├── pages/
        │   ├── flashcard_player_page.dart  # Flashcard player
        │   ├── review_result_page.dart     # Review results
        │   └── select_book_page.dart       # Select book for review
        └── widgets/
            ├── flashcard_view.dart         # Flashcard view widget
            ├── review_menu_item.dart       # Review menu item
            ├── streak_bar.dart             # Streak progress bar
            └── study_progress_bar.dart     # Study progress bar
```

## Architecture Overview

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models**: Data classes representing entities (books, users, notes, etc.)
- **Views**: UI components and pages
- **ViewModels**: State management and business logic using `ChangeNotifier`
- **Repositories**: Data access layer for Firestore operations
- **Services**: External API integrations and utility services

## Key Features

1. **📚 Library Management**: Add, organize, and track books
2. **📝 Note Taking**: Create notes with OCR support
3. **🎴 Flashcards**: Create and review flashcards
4. **👥 Community**: Share notes and connect with friends
5. **📊 Statistics**: Track reading progress and habits
6. **🔔 Notifications**: Reading reminders and updates
