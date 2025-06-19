# Private Events

This is part of the Associations Project in The Odin Project's Ruby on Rails Curriculum. Find it at https://www.theodinproject.com

A private Eventbrite clone that allows users to create events and manage user signups. Built with Ruby on Rails and PostgreSQL to demonstrate complex many-to-many associations and advanced database relationships.

## Features

- **User Authentication**: Complete registration, login, and logout system using Devise
- **Event Creation**: Users can create and manage their own events
- **Event Attendance**: Many-to-many relationship between users and events
- **Time-based Organization**: Automatic separation of past and upcoming events
- **User Profiles**: View created events and attended events for each user
- **Authorization**: Event creators can edit/delete their events
- **Responsive Design**: Clean, professional interface
- **PostgreSQL Database**: Production-ready database with advanced features

## Technologies Used

- **Ruby**: 3.4.4
- **Rails**: 8.0.2
- **PostgreSQL**: Production-grade database
- **Devise**: Authentication system
- **Frontend**: HTML, ERB templates, CSS
- **Deployment Ready**: Heroku-compatible configuration

## Live Demo Features

Try these user flows:
1. **Guest User**: Browse all events (past and upcoming)
2. **New User**: Sign up and create your first event
3. **Event Creator**: Create, edit, and manage your events
4. **Event Attendee**: Join and leave events created by others
5. **Profile Management**: View your created and attended events

## Installation

### Prerequisites
- Ruby 3.0 or higher
- Rails 7.0 or higher
- PostgreSQL 12 or higher
- Git

### Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/NatashaJWangui/Private-Events.git
   cd private-events
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   # Start PostgreSQL service
   # macOS: brew services start postgresql
   # Ubuntu: sudo service postgresql start
   
   # Create and migrate database
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: loads sample data
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Visit the application**
   Open your browser and navigate to `http://localhost:3000`

## Database Schema

### User Model (via Devise)
```ruby
# Table: users
- id: integer (primary key)
- email: string (unique, required)
- encrypted_password: string (required)
- name: string (required)
- created_at: datetime
- updated_at: datetime

# Associations
- has_many :created_events (class_name: 'Event', foreign_key: 'creator_id')
- has_many :event_attendances
- has_many :attended_events (through: :event_attendances, source: :event)
```

### Event Model
```ruby
# Table: events
- id: integer (primary key)
- title: string (required)
- description: text (required)
- date: datetime (required)
- location: string (required)
- creator_id: integer (foreign key to users)
- created_at: datetime
- updated_at: datetime

# Associations
- belongs_to :creator (class_name: 'User')
- has_many :event_attendances
- has_many :attendees (through: :event_attendances, source: :user)

# Scopes
- scope :past (events with date < current time)
- scope :upcoming (events with date > current time)
```

### EventAttendance Model (Join Table)
```ruby
# Table: event_attendances
- id: integer (primary key)
- user_id: integer (foreign key to users)
- event_id: integer (foreign key to events)
- created_at: datetime
- updated_at: datetime

# Associations
- belongs_to :user
- belongs_to :event

# Validations
- validates uniqueness of user_id scoped to event_id (prevents duplicate attendance)
```

## Complex Associations Explained

### Many-to-Many Relationship
```ruby
# A User can attend many Events
# An Event can have many Users as attendees
# This requires a join table: EventAttendance

User ←→ EventAttendance ←→ Event
```

### Dual User Roles
```ruby
# Users have two distinct relationships with Events:
1. Creator → Event (one-to-many)
2. Attendee → Event (many-to-many through EventAttendance)

# This allows users to both create and attend events
```

### Custom Association Names
```ruby
# User model uses custom association names to avoid conflicts:
has_many :created_events, class_name: 'Event', foreign_key: 'creator_id'
has_many :attended_events, through: :event_attendances, source: :event

# Event model specifies creator relationship:
belongs_to :creator, class_name: 'User'
```

## Routes

| HTTP Method | Path | Controller#Action | Purpose | Authentication |
|-------------|------|------------------|---------|----------------|
| GET | / | events#index | View all events | Public |
| GET | /events | events#index | View all events | Public |
| GET | /events/new | events#new | New event form | Required |
| POST | /events | events#create | Create event | Required |
| GET | /events/:id | events#show | View event details | Public |
| GET | /events/:id/edit | events#edit | Edit event form | Creator only |
| PATCH/PUT | /events/:id | events#update | Update event | Creator only |
| DELETE | /events/:id | events#destroy | Delete event | Creator only |
| POST | /events/:id/event_attendances | event_attendances#create | Join event | Required |
| DELETE | /events/:id/event_attendances/:id | event_attendances#destroy | Leave event | Required |
| GET | /users/:id | users#show | User profile | Public |

## Key Features

### 1. Event Management
- **Creation**: Users can create events with title, description, date, and location
- **Editing**: Event creators can modify their events
- **Deletion**: Event creators can delete their events (removes all attendances)
- **Validation**: All fields required, prevents invalid data

### 2. Attendance System
- **Join Events**: Users can attend events created by others
- **Leave Events**: Users can cancel their attendance
- **Prevent Duplicates**: Database constraint prevents double attendance
- **Creator Exclusion**: Event creators cannot attend their own events

### 3. Time-based Organization
- **Upcoming Events**: Events with future dates
- **Past Events**: Events that have already occurred
- **Automatic Sorting**: Past events newest first, upcoming events soonest first
- **Scopes**: Efficient database queries using ActiveRecord scopes

### 4. User Profiles
- **Created Events**: List of events user has created
- **Attended Events**: Separated into upcoming and past events
- **Event Statistics**: Count of attendees for created events
- **Cross-navigation**: Easy links between users and events

### 5. Authorization Logic
```ruby
# Event creators can edit/delete their events
before_action :check_creator, only: [:edit, :update, :destroy]

# Users can only attend events they didn't create
if @event.creator == current_user
  # Show "You are the creator" message
else
  # Show attend/leave buttons
end
```

## PostgreSQL Advantages

### Why PostgreSQL over SQLite?
- **Production Ready**: Used by major platforms (Heroku, AWS RDS)
- **Advanced Data Types**: JSON, arrays, custom types
- **Better Performance**: Optimized for concurrent users
- **Full-Text Search**: Built-in search capabilities
- **ACID Compliance**: Better data integrity
- **Scalability**: Handles large datasets efficiently

### PostgreSQL-Specific Features Used
- **Foreign Key Constraints**: Ensures referential integrity
- **Indexes**: Optimized queries on associations
- **Concurrent Connections**: Multiple users simultaneously
- **Advanced Queries**: Complex joins and scopes

## Sample Data

The application includes realistic seed data:
- **4 sample users** with different profiles
- **5 sample events** (mix of past and upcoming)
- **Multiple attendances** demonstrating relationships
- **Realistic content** for testing all features

Load sample data:
```bash
rails db:seed
```

## Testing

### Manual Testing Checklist

#### Authentication & Authorization
- [ ] Can register new account with valid information
- [ ] Can sign in and sign out successfully
- [ ] Cannot access protected routes when signed out
- [ ] Cannot edit/delete events created by others

#### Event Management
- [ ] Can create event with valid data
- [ ] Cannot create event with missing fields
- [ ] Can edit own events
- [ ] Can delete own events
- [ ] Cannot edit/delete others' events

#### Attendance System
- [ ] Can join events created by others
- [ ] Can leave events you're attending
- [ ] Cannot attend same event twice
- [ ] Cannot attend own events
- [ ] Attendance count updates correctly

#### Time-based Features
- [ ] Past and upcoming events properly separated
- [ ] Event dates display correctly
- [ ] Scopes return correct events
- [ ] User profile shows correct event categories

#### Navigation & UI
- [ ] All links work correctly
- [ ] Forms validate and show errors
- [ ] Flash messages display appropriately
- [ ] Responsive design works on mobile

### Console Testing
```ruby
# Test associations
user = User.first
user.created_events.count       # Events user created
user.attended_events.count      # Events user is attending

event = Event.first
event.creator.name              # Event creator
event.attendees.count           # Number of attendees

# Test scopes
Event.upcoming.count            # Future events
Event.past.count               # Past events

# Test attendance
attendance = EventAttendance.first
attendance.user.name           # Attendee name
attendance.event.title         # Event title
```

## Security Considerations

### Authentication Security
- **Password Encryption**: Bcrypt via Devise
- **Session Management**: Secure Rails sessions
- **CSRF Protection**: Forms protected against attacks
- **SQL Injection Prevention**: ActiveRecord parameterized queries

### Authorization
- **Route Protection**: `before_action :authenticate_user!`
- **Creator Verification**: `before_action :check_creator`
- **Association Security**: Foreign key constraints
- **User Ownership**: Automatic creator assignment

### Data Validation
- **Server-side Validation**: All inputs validated
- **Uniqueness Constraints**: Prevent duplicate attendances
- **Required Fields**: Presence validation
- **Date Validation**: Ensures valid datetime

## Deployment

### Heroku Deployment
```bash
# Add to Gemfile for production
group :production do
  gem 'pg', '~> 1.1'
end

# Heroku setup
heroku create your-app-name
heroku addons:create heroku-postgresql:mini
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

### Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `SECRET_KEY_BASE`: Rails secret key
- `RAILS_MASTER_KEY`: Credentials encryption key

## Performance Considerations

### Database Optimization
- **Indexes**: Foreign key columns indexed automatically
- **Includes**: Eager loading to prevent N+1 queries
- **Scopes**: Efficient database queries
- **Joins**: Optimized association queries

### Future Optimizations
- **Caching**: Page and fragment caching
- **Background Jobs**: Email notifications
- **CDN**: Asset delivery optimization
- **Database Pooling**: Connection management

## Future Enhancements

### Planned Features
- **Event Categories**: Tag and filter events by type
- **Private Events**: Invitation-only events
- **Event Images**: Photo uploads for events
- **Email Notifications**: Attendance confirmations
- **Calendar Integration**: Export to Google Calendar
- **Search Functionality**: Find events by keyword
- **User Following**: Follow other users' events
- **Comments System**: Discuss events

### Technical Improvements
- **API Endpoints**: JSON API for mobile apps
- **Real-time Updates**: WebSocket for live attendance
- **Advanced Search**: Full-text search with PostgreSQL
- **Geolocation**: Map integration for event locations
- **Social Features**: Share events on social media
- **Analytics**: Event attendance analytics

## Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Resources

- [Rails Guides - Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Rails API Documentation](https://api.rubyonrails.org/)
- [The Odin Project](https://www.theodinproject.com/)

## License

This project is for educational purposes.

## Acknowledgments

- The Odin Project for the excellent associations curriculum
- PostgreSQL community for the robust database system
- Devise team for authentication solutions
- Rails community for association best practices
- All developers contributing to complex Rails applications

---

**Project completed as part of The Odin Project - Ruby on Rails Course**
