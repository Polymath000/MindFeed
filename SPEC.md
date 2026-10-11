---
id: mindfeed.core.mvp
title: Mind Feed Core Application
status: ready
owner: Product Manager
intent: "Provide users with a focused, unified editorial reading, curation, and publishing experience powered by Supabase with clean offline text-reading capabilities."
depends_on: []
---

# Mind Feed Core Application

## Intent
Lifelong learners, readers, and thinkers face cluttered feeds, ad noise, and unreliable reading experiences when attempting to consume and organize valuable knowledge. Mind Feed provides a clean, unified platform where authenticated users can discover personalized articles across 20 curated categories, star and share high-value pieces, read article text offline, manage drafts on a dedicated drafts page, preview articles, and publish original articles within a single streamlined dashboard.

## Mini-requirements

### Target Personas
- **Primary**: The Unified App User (an authenticated individual who consumes personalized articles across 20 curated topics, stars and shares content, saves insights for offline text reading, drafts articles with previews, and publishes original articles to the feed).

### User Stories
- As a user, I want to authenticate using either Email/Password or Google Auth, so that I can securely log into my account with my preferred method.
- As a user, I want to select my favorite reading topics from 20 fixed categories during onboarding and update them anytime in Settings, so that my home feed dynamically prioritizes articles tailored to my current interests.
- As a user, I want to star articles, so that I can endorse valuable pieces and see community-endorsed content.
- As a user, I want to share articles via the device native share sheet, so that I can recommend insightful pieces to others.
- As a user, I want to read articles in a distraction-free reader and download article text for offline reading, so that I can consume content without internet access.
- As a user, I want to search articles by keywords and filter by fixed categories and tags, so that I can rapidly find specific information.
- As a user, I want a dedicated Drafts page to view, edit, and manage all my drafts, so that I can seamlessly work on articles in progress.
- As a user, I want to preview my drafted article before publishing, so that I can verify its exact layout and formatting.
- As a user, I want to publish articles with validation rules (max 12 words title, min 300 words content, landscape-only cover image URL, 1 required category from the 20 fixed categories, up to 5 tags from fixed tags), so that published articles maintain high editorial standards.
- As a user, I want to edit or delete my published article within 30 days of its publication, so that I can make timely corrections while preserving long-term archive integrity.
- As a user, I want my offline downloads cleared upon logging out, so that my local device storage is kept private and secure.
- As a user, I want to switch between dark and light themes, so that I have a comfortable reading interface at any time of day.

### Acceptance Criteria

### 1. Mandatory Authentication & Onboarding
- GIVEN a first-time user opens the application
  WHEN they complete the initial onboarding screens
  THEN they are directed to the authentication screen with options for Email/Password (Sign In / Sign Up) and Google Sign-In.
- GIVEN an unauthenticated user on the onboarding or auth screen
  WHEN attempting to access the home feed or any protected app feature
  THEN access is blocked until the user successfully authenticates via Email or Google (no guest access allowed).
- GIVEN a user chooses Google Sign-In or registers with Email/Password
  WHEN the signup request completes via Supabase
  THEN an authenticated session is established, and the user is routed to select their favorite categories from the 20 fixed categories list.
- GIVEN a user with an active session restarts the application
  WHEN the app initializes
  THEN the user remains authenticated and lands directly on the main dashboard without re-authenticating.
- GIVEN an authenticated user logs out from Settings
  WHEN logout completes
  THEN the session is terminated, all locally downloaded articles and cached user data are purged from the device, and the user is returned to the Login screen.

### 2. Home Feed & Discovery
- GIVEN an authenticated user opens the Home feed
  WHEN articles are fetched from the live Supabase database (no mock data)
  THEN articles are prioritized based on the user's selected preferred categories, showing newest articles from preferred categories first.
- GIVEN an article card on the feed
  WHEN rendered
  THEN it displays the landscape cover image, title, category, tags, total star count, reading duration, and publication date.
- GIVEN a user navigates to the Search screen
  WHEN they input a search query or filter by one of the 20 categories or fixed tags
  THEN the results list immediately reflects matching live articles from the database.

### 3. Article Reader, Starring & Sharing
- GIVEN a user selects an article card
  WHEN the article reader opens
  THEN the article content is rendered with clean typography, formatted markdown, landscape cover image, author info, publication date, star counter, and a share button.
- GIVEN a user views an article card or the article reader
  WHEN they tap the Star button
  THEN the article is marked as starred by the user, the total star count increments by 1, and the state persists in Supabase.
- GIVEN a user has already starred an article
  WHEN they tap the Star button again
  THEN the star is removed, the total star count decrements by 1, and the state updates in Supabase.
- GIVEN a user taps the Share button on an article
  WHEN the action triggers
  THEN the device native share sheet opens with the article title and link/text ready to send.

### 4. Offline Mode (Text-Only)
- GIVEN a user taps "Download" on an article
  WHEN the download action completes
  THEN the article text, title, category, tags, and metadata are saved locally for offline access (network images are NOT downloaded).
- GIVEN a user is offline with no active network connection
  WHEN they navigate to "Downloaded Articles" and open a downloaded article
  THEN the full article text and markdown render without network errors, while un-downloaded images display clean, unobtrusive placeholders.

### 5. Article Drafting, Preview, Publishing & Lifecycle
- GIVEN an authenticated user opens "Add Article"
  WHEN they compose an article and tap "Save Draft"
  THEN the article is saved with status `draft` in Supabase (not visible on the public feed).
- GIVEN an authenticated user accesses the dedicated "Drafts" page
  WHEN the page loads
  THEN all articles authored by the user with status `draft` are listed with title, last updated timestamp, and quick actions to edit or delete.
- GIVEN an author edits a draft or composes an article
  WHEN they tap "Preview"
  THEN an exact article preview view opens, displaying how the article will appear to readers once published (landscape cover, formatting, author details, tags).
- GIVEN a user attempts to publish an article
  WHEN the title exceeds 12 words, OR content is under 300 words, OR cover image is missing or not in landscape orientation, OR no category is selected from the 20 fixed categories, OR more than 5 tags are chosen
  THEN publishing is blocked with clear field-level validation messages.
- GIVEN a user submits an article satisfying all validation rules
  WHEN publishing completes
  THEN the article status changes from `draft` to `published` in Supabase, the article immediately appears on the public feed, and it is removed from the active drafts list.
- GIVEN an author views their own published article
  WHEN less than or equal to 30 days have elapsed since publication (`now - published_at <= 30 days`)
  THEN "Edit" and "Delete" options are available and functional.
- GIVEN an author views their own published article
  WHEN more than 30 days have elapsed since publication (`now - published_at > 30 days`)
  THEN "Edit" and "Delete" actions are disabled/hidden, and the article is immutable.

### 6. Personal Collections & Settings
- GIVEN a user bookmarks an article
  WHEN they open "Saved Articles"
  THEN the bookmarked article appears in their saved list and syncs across sessions.
- GIVEN a user opens Settings
  WHEN they select "Preferred Categories"
  THEN a selection screen with the 20 fixed categories opens, allowing the user to update their selected interests at any time.
- GIVEN a user updates their preferred categories in Settings
  WHEN they return to the Home feed
  THEN the feed immediately re-prioritizes articles according to the newly selected categories.
- GIVEN a user navigates to Settings
  WHEN they toggle the theme switch
  THEN the entire application immediately updates between Light and Dark mode without re-routing.

### Business Rules
1. **Mandatory Authentication**: Guest browsing is strictly prohibited; all views require an active session via Email/Password or Google Auth.
2. **Unified User Role**: Every user has the same dashboard capabilities (reading, saving, downloading, drafting, previewing, publishing, starring, and sharing articles).
3. **Article Status Lifecycle**: Drafts and published articles use the unified article entity with a status attribute (`draft` vs `published`). Publishing transitions an article from `draft` to `published`.
4. **Drafts Page**: A dedicated Drafts screen lists all private drafts owned by the current user.
5. **Article Preview**: Authors must have access to a real-time pre-publish preview reflecting the exact reader UI.
6. **Cover Image Orientation**: The cover image must be in landscape format only (width > height).
7. **Personalized Feed Sorting**: The Home Feed prioritizes articles matching the user's selected preferred categories (ordered by newest publication date). Users can modify their category preferences anytime via Settings.
8. **Star Mechanism**: Each user can star an article once (binary toggle). Starring updates a public aggregate counter.
9. **Native Sharing**: Users can share articles via the platform native share sheet.
10. **Text-Only Offline Downloads**: Offline downloads cache text and metadata only; network images are excluded to optimize device storage and data transfer.
11. **Logout Purge**: When a user logs out, all downloaded articles, cached records, and session tokens are permanently wiped from local device storage.
12. **Live Data Only**: All operations interact with the live Supabase backend. Mock data and client-side simulation must not be used.
13. **Validation Rules**:
    - Title: Maximum 12 words (minimum 1 word).
    - Content: Minimum 300 words.
    - Cover Image: Required landscape-only image URL.
    - Category: Exactly 1 category required from the 20 fixed categories.
    - Tags: Between 1 and 5 tags selected exclusively from the fixed tags list.
14. **Article 30-Day Edit/Delete Window**:
    - An author can modify or delete their published article strictly within 30 days of its creation timestamp.
    - Once 30 days pass, the article is permanently locked and cannot be edited or deleted.

### Taxonomy (Fixed Categories & Tags)

#### The 20 Fixed Categories (Pick exactly 1 per article)
1. **Technology**
2. **Science**
3. **Business & Entrepreneurship**
4. **Personal Development**
5. **Health & Wellness**
6. **Education & Learning**
7. **News & Current Events**
8. **Politics**
9. **Finance & Investing**
10. **Lifestyle**
11. **Travel & Culture**
12. **Food & Cooking**
13. **Sports**
14. **Entertainment & Movies**
15. **Books & Literature**
16. **Art & Design**
17. **Programming & Software Development**
18. **History**
19. **Psychology**
20. **Environment & Sustainability**

#### Fixed Tags (Select 1 to 5 tags per article)
* `AI & Machine Learning`, `Mobile Dev`, `UI/UX Design`, `Leadership`, `Startups`, `Deep Work`, `Mental Health`, `Psychology`, `Future of Tech`, `Writing & Creativity`, `Software Architecture`, `Product Strategy`

### Scope

### In Scope
- Mandatory authentication via Email/Password and Google Auth (Supabase).
- Onboarding category selection across 20 fixed categories.
- Updating preferred categories at any time via Settings, with immediate feed re-prioritization.
- Home feed displaying live Supabase articles personalized by onboarding/settings category preferences.
- Article starring (star/unstar toggle with live count updates).
- Article sharing via native OS share sheet.
- Article reading view with markdown support.
- Keyword, category, and tag search against live articles.
- Article bookmarking (Saved Articles).
- Offline text downloads (Downloaded Articles) without image caching.
- Session logout with local offline data wipe.
- Dedicated Drafts page (viewing and managing private drafts).
- Article pre-publish Preview mode.
- Direct article publishing with 12-word title max, 300-word content min, required landscape-only cover image, exactly 1 of the 20 fixed categories, and 1 to 5 fixed tags.
- Status transition from `draft` to `published`.
- 30-day edit and delete window for published articles.
- Theme switching (Light / Dark mode).

### Explicitly Out of Scope
- Guest / anonymous browsing mode.
- Offline image downloading/caching.
- Multi-tier role permissions (admin review, moderator gate).
- Dedicated "Starred Articles" collection view.
- Push notifications and in-app notification centers (Deferred to Future Phase).
- Threaded comments, multi-level replies, follower system.
- Custom user-created categories or user-created tags.
- Editing or deleting articles after 30 days from publication.
- Paid subscriptions, memberships, or paywalls.

### Open Questions
*None. All requirements, business rules, and edge cases have been resolved.*

## Proof contract

- [ ] A new user signs in via Google Auth or Email/Password via Supabase, picks favorite categories from the 20 fixed categories, views a personalized feed, creates a draft with landscape cover image, views it on the dedicated Drafts page, previews the article layout, publishes the article (verifying status transition from `draft` to `published` and adherence to the 12-word title and 300-word content constraints), stars and shares an article, downloads an article's text, reads it offline, updates category preferences in Settings (verifying feed updates), logs out, and confirms all local offline downloaded content is wiped clean.
